package org.duckdns.servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.http.client.ClientProtocolException;
import org.duckdns.dao.AmazonDynamoDBDAO;
import org.duckdns.dao.model.Account;
import org.duckdns.dao.model.Domain;
import org.duckdns.dao.model.Session;
import org.duckdns.facebook.FacebookOAuth;
import org.duckdns.reddit.RedditOAuth;
import org.duckdns.twitter.TwitterDetails;
import org.duckdns.twitter.TwitterOAuth;
import org.duckdns.util.EnvironmentUtils;
import org.duckdns.util.SecurityHelper;
import org.duckdns.util.ServletUtils;
import org.scribe.builder.ServiceBuilder;
import org.scribe.builder.api.Google2Api;
import org.scribe.builder.api.TwitterApi;
import org.scribe.model.OAuthRequest;
import org.scribe.model.Response;
import org.scribe.model.Token;
import org.scribe.model.Verb;
import org.scribe.model.Verifier;
import org.scribe.oauth.OAuthService;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.plus.samples.verifytoken.Checker;


public class LoginServlet extends javax.servlet.http.HttpServlet {

	private static final long serialVersionUID = -1;
	private static final Log LOG = LogFactory.getLog(LoginServlet.class);

	private ServletContext context;
	private OAuthService twitterOAuthservice;
	private OAuthService googleOAuthservice;
	
	/**
	 * {@inheritDoc}
	 */
	public void init(ServletConfig config) throws ServletException {
		super.init(config);

		context = config.getServletContext();

		LOG.debug("context: " + context);
		
		twitterOAuthservice = new ServiceBuilder()
			.provider(TwitterApi.SSL.class)
			.apiKey(EnvironmentUtils.getInstance().getTwitterApiKey())
			.apiSecret(EnvironmentUtils.getInstance().getTwitterApiSecret())
			.callback("https://www.duckdns.org/login")
			.build();
		
		googleOAuthservice = new ServiceBuilder()
			.provider(Google2Api.class)
			.apiKey(EnvironmentUtils.getInstance().getGoogleApiKey())
			.apiSecret(EnvironmentUtils.getInstance().getGoogleApiSecret())
			.callback("https://www.duckdns.org/login-google")
			.scope("email")
			.build();
		
		// KICK OFF THE DB CLEANER
		( new Thread("DuckDNS DB Cleaner") {
			public void run() {
				while (true) {
					try {
						AmazonDynamoDBDAO.getInstance().sessionsCleanUpOldSessions();
					} catch (Throwable tw) {}
					try {
						Thread.sleep(60*1000);
					} catch (InterruptedException e) {}
				}
			}
		} ).start();
		
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doPost(req, resp);
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		if (req.getParameter("generateRequest") != null) {
			generateARequestToken(req, resp);
			return;
		} else {
			processReturnFromAOuth(req, resp);
			return;
		}
	}
	
	private void generateARequestToken(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if ("twitter".equals(req.getParameter("generateRequest"))) {
			Token requestToken = twitterOAuthservice.getRequestToken();
			req.getSession().setAttribute("requestToken",requestToken);
			String redirectURL = twitterOAuthservice.getAuthorizationUrl(requestToken);
			resp.sendRedirect(redirectURL);
			return;
		} else if ("google".equals(req.getParameter("generateRequest"))) {
			String redirectURL = googleOAuthservice.getAuthorizationUrl(null);
			resp.sendRedirect(redirectURL);
			return;
		} else if ("persona".equals(req.getParameter("generateRequest"))) {
			if (EnvironmentUtils.isDynamoSessionCache()) {
				Session session = AmazonDynamoDBDAO.getInstance().sessionsGetSession(req.getSession().getId(), ServletUtils.getAddressFromRequest(req));
				if (session == null) {
					// MAKE THEM A SESSION WITH NO EMAIL
					session = AmazonDynamoDBDAO.getInstance().sessionsCreateSession(req.getSession().getId(), "", ServletUtils.getAddressFromRequest(req));
				}
				req.getSession().setAttribute("clrfToken", session.getClrfToken());
			}
			this.getServletContext().getRequestDispatcher("/WEB-INF/jsp/persona_login.jsp").forward(req, resp);
			return;
		} 
	}
	
	private boolean testAndDeliverIndexIfAlreadyLoggedIn(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException  {
		// TEST EXISTING SESSION
		Object o = req.getSession().getAttribute("email");
		if (o != null && o instanceof String) {
			String email = (String) o;
			if (email.length() > 0) {
				Account account = (Account) req.getSession().getAttribute("account");
				if (account != null) {
					if (SecurityHelper.hasValidSession(req)) {
						// Already got Email move along
						this.getServletContext().getRequestDispatcher("/index.jsp").forward(req, resp);
						return true;
					}
				}
			}
		}
		return false;
	}

	private void processReturnFromAOuth(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		// REDDIT & GOOGLE
		String code = req.getParameter("code");
		// FACEBOOK
		String access_token = req.getParameter("access_token");
		// TWITTER
		String oauth_token = req.getParameter("oauth_token");
		String oauth_verifier = req.getParameter("oauth_verifier");
		
		// PATH
		String path = req.getServletPath();
		if (code != null) {
			
			// TEST EXISTING SESSION
			if (testAndDeliverIndexIfAlreadyLoggedIn(req, resp)) {
				return;
			}
			
			if (path != null && path.equals("/login-google")) {
				// GOOGLE LOGIN
				this.processGoogleReturn(code, req, resp);
				return;
			} else {
				// REDDIT LOGIN
				this.processRedditReturn(code, req, resp);
				return;
			}
		} else if (path != null && path.equals("/login-persona")) {
			// PERSONA
			String email = req.getParameter("email");
			String token = req.getParameter("token");
			String clrf = req.getParameter("clrf");
			// CHECK CLRF
			this.processPersonaReturn(email, token, clrf, req, resp);
			return;
		} else if(oauth_verifier != null) {
			// TWITTER LOGIN
			this.processTwitterReturn(oauth_token, oauth_verifier, req, resp);
			return;
		} else if(access_token != null) {
			// FACEBOOK LOGIN
			this.processFacebookReturn(access_token, req, resp);
			return;
		} else {
			this.getServletContext().getRequestDispatcher("/index.jsp").forward(req, resp);
			return;
		}
	}
	
	private void processPersonaReturn(String email, String token, String clrf, HttpServletRequest req, HttpServletResponse resp) throws ClientProtocolException, IOException, ServletException {
		AmazonDynamoDBDAO dao = AmazonDynamoDBDAO.getInstance();
		
		boolean clrfpass = AmazonDynamoDBDAO.getInstance().sessionsCheckClrfToken(req.getSession().getId(), ServletUtils.getAddressFromRequest(req), clrf);
		boolean correctCreds = false;
		String personaName = "";
		if (clrfpass) {
			personaName = email+"#persona";
			correctCreds = dao.accountCheckLogin(personaName, token);
		}
		if (correctCreds && clrfpass) {
			req.getSession().setAttribute("email", personaName);
			// LOAD FROM THE DYANAMO DB
			
			Account account = dao.accountsGetAccount(personaName, ServletUtils.getUpdaterIp(req), ServletUtils.getUpdaterAgent(req));
			if (account == null) {
				ServletUtils.setFeedback(req, false,EnvironmentUtils.ACCOUNTS_LOCKED);
			} else {
				req.getSession().setAttribute("account", account);
				List<Domain> domains = dao.domainsGetDomainsByToken(account.getAccountToken());
				req.getSession().setAttribute("domains", domains);
				// PLACE THE UPDATED ITEM INTO THE SESSION CACHE
				if (EnvironmentUtils.isDynamoSessionCache()) {
					AmazonDynamoDBDAO.getInstance().sessionsCreateSession(req.getSession().getId(), account.getEmail(), ServletUtils.getAddressFromRequest(req));
				}
			}
			// RESET TOKEN 
			Session session = AmazonDynamoDBDAO.getInstance().sessionsChangeClrfToken(req.getSession().getId(), ServletUtils.getAddressFromRequest(req));
			req.getSession().setAttribute("clrfToken", session.getClrfToken());
			
			this.getServletContext().getRequestDispatcher("/index.jsp").forward(req, resp);
			return;
		}
		// WE GET HERE ITS BAD
		// RESET TOKEN 
		Session session = AmazonDynamoDBDAO.getInstance().sessionsChangeClrfToken(req.getSession().getId(), ServletUtils.getAddressFromRequest(req));
		req.getSession().setAttribute("clrfToken", session.getClrfToken());
		
		ServletUtils.setFeedback(req, false,"wrong email or token");
		this.getServletContext().getRequestDispatcher("/WEB-INF/jsp/persona_login.jsp").forward(req, resp);
		return;
	}

	private void processTwitterReturn(String oauth_token, String oauth_verifier, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		Verifier verifier = new Verifier(oauth_verifier);
		Object o = req.getSession().getAttribute("requestToken");
		if (o instanceof Token) {
			Token requestToken = (Token) o;
			Token accessToken = twitterOAuthservice.getAccessToken(requestToken, verifier);
			if (accessToken != null) {
				
				OAuthRequest request = new OAuthRequest(Verb.GET, "https://api.twitter.com/1.1/account/verify_credentials.json");
				twitterOAuthservice.signRequest(accessToken, request);
			    Response response = request.send();
			    
			    // CLEAR THE TOKEN
			    req.getSession().removeAttribute("requestToken");
				
			    TwitterDetails twitterDetails = TwitterOAuth.getUserDetails(response.getBody());
				if (twitterDetails != null) {
					
					String twitterName = twitterDetails.getTwitterId()+"@twitter";
					req.getSession().setAttribute("email", twitterName);
					// LOAD FROM THE DYANAMO DB
					AmazonDynamoDBDAO dao = AmazonDynamoDBDAO.getInstance();
					Account account = dao.accountsGetAccount(twitterName, ServletUtils.getUpdaterIp(req), ServletUtils.getUpdaterAgent(req));
					if (account == null) {
						ServletUtils.setFeedback(req, false,EnvironmentUtils.ACCOUNTS_LOCKED);
					} else {
						req.getSession().setAttribute("account", account);
						List<Domain> domains = dao.domainsGetDomainsByToken(account.getAccountToken());
						req.getSession().setAttribute("domains", domains);
						// PLACE THE UPDATED ITEM INTO THE SESSION CACHE
						if (EnvironmentUtils.isDynamoSessionCache()) {
							AmazonDynamoDBDAO.getInstance().sessionsCreateSession(req.getSession().getId(), account.getEmail(), ServletUtils.getAddressFromRequest(req));
						}
					}
					this.getServletContext().getRequestDispatcher("/index.jsp").forward(req, resp);
					return;
				}
			}
		}
		
		// WE GET HERE ITS BAD
		this.getServletContext().getRequestDispatcher("/index.jsp").forward(req, resp);
	}
	
	private void processFacebookReturn(String access_token, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String facebookEmail = FacebookOAuth.getUserEmail(access_token);
		if (facebookEmail != null) {
			String redditName = facebookEmail+"#facebook";
			req.getSession().setAttribute("email", redditName);
			// LOAD FROM THE DYANAMO DB
			AmazonDynamoDBDAO dao = AmazonDynamoDBDAO.getInstance();
			Account account = dao.accountsGetAccount(redditName, ServletUtils.getUpdaterIp(req), ServletUtils.getUpdaterAgent(req));
			if (account == null) {
				ServletUtils.setFeedback(req, false,EnvironmentUtils.ACCOUNTS_LOCKED);
			} else {
				req.getSession().setAttribute("account", account);
				List<Domain> domains = dao.domainsGetDomainsByToken(account.getAccountToken());
				req.getSession().setAttribute("domains", domains);
				// PLACE THE UPDATED ITEM INTO THE SESSION CACHE
				if (EnvironmentUtils.isDynamoSessionCache()) {
					AmazonDynamoDBDAO.getInstance().sessionsCreateSession(req.getSession().getId(), account.getEmail(), ServletUtils.getAddressFromRequest(req));
				}
			}
			this.getServletContext().getRequestDispatcher("/index.jsp").forward(req, resp);
			return;
		}
		// WE GET HERE ITS BAD
		this.getServletContext().getRequestDispatcher("/index.jsp").forward(req, resp);
	}
	
	private void processRedditReturn(String code, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String token = RedditOAuth.getAccessToken(code, EnvironmentUtils.getProtocol()+"://"+ServletUtils.getHostNameFromRequest(req)+"/login");
		if (token != null) {
			String redditUserName = RedditOAuth.getUserName(token);
			if (redditUserName != null) {
				String redditName = redditUserName+"@reddit";
				req.getSession().setAttribute("email", redditName);
				// LOAD FROM THE DYANAMO DB
				AmazonDynamoDBDAO dao = AmazonDynamoDBDAO.getInstance();
				Account account = dao.accountsGetAccount(redditName, ServletUtils.getUpdaterIp(req), ServletUtils.getUpdaterAgent(req));
				if (account == null) {
					ServletUtils.setFeedback(req, false,EnvironmentUtils.ACCOUNTS_LOCKED);
				} else {
					req.getSession().setAttribute("account", account);
					List<Domain> domains = dao.domainsGetDomainsByToken(account.getAccountToken());
					req.getSession().setAttribute("domains", domains);
					// PLACE THE UPDATED ITEM INTO THE SESSION CACHE
					if (EnvironmentUtils.isDynamoSessionCache()) {
						AmazonDynamoDBDAO.getInstance().sessionsCreateSession(req.getSession().getId(), account.getEmail(), ServletUtils.getAddressFromRequest(req));
					}
				}
				this.getServletContext().getRequestDispatcher("/index.jsp").forward(req, resp);
				return;
			}
		}
		// WE GET HERE ITS BAD
		this.getServletContext().getRequestDispatcher("/index.jsp").forward(req, resp);
	}

	private void processGoogleReturn(String code, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		Verifier verifier = new Verifier(code);
		Token accessToken = googleOAuthservice.getAccessToken(null, verifier);

		if (accessToken != null) {
			// Now we decrypt and Verify the JWT
			Checker checker = new Checker(new String[]{EnvironmentUtils.getInstance().getGoogleApiKey()}, EnvironmentUtils.getInstance().getGoogleApiKey());
			GoogleIdToken.Payload jwt = checker.check(accessToken.getToken());
			
	        if (jwt != null) {
	        	
	        	String email = jwt.getEmail();
	        	req.getSession().setAttribute("email", email);
	        	AmazonDynamoDBDAO dao = AmazonDynamoDBDAO.getInstance();
				Account account = dao.accountsGetAccount(email, ServletUtils.getUpdaterIp(req), ServletUtils.getUpdaterAgent(req));
				if (account == null) {
					ServletUtils.setFeedback(req, false,EnvironmentUtils.ACCOUNTS_LOCKED);
				} else {
					req.getSession().setAttribute("account", account);
					List<Domain> domains = dao.domainsGetDomainsByToken(account.getAccountToken());
					req.getSession().setAttribute("domains", domains);
					// PLACE THE UPDATED ITEM INTO THE SESSION CACHE
					if (EnvironmentUtils.isDynamoSessionCache()) {
						AmazonDynamoDBDAO.getInstance().sessionsCreateSession(req.getSession().getId(), account.getEmail(), ServletUtils.getAddressFromRequest(req));
					}
				}
				this.getServletContext().getRequestDispatcher("/index.jsp").forward(req, resp);
				return;
	        }
		}
		
		// WE GET HERE ITS BAD
		this.getServletContext().getRequestDispatcher("/index.jsp").forward(req, resp);
	}

}
