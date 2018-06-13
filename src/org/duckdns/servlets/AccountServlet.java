package org.duckdns.servlets;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.duckdns.communications.Sender;
import org.duckdns.communications.clients.SimpleSender;
import org.duckdns.communications.messages.SingleLineMessage;
import org.duckdns.dao.AmazonDynamoDBDAO;
import org.duckdns.dao.model.Account;
import org.duckdns.dao.model.Domain;
import org.duckdns.util.EnvironmentUtils;
import org.duckdns.util.SessionHelper;
import org.duckdns.util.SecurityHelper;
import org.duckdns.util.ServletUtils;

public class AccountServlet extends javax.servlet.http.HttpServlet {
	private static final long serialVersionUID = -1;
	private static final Log LOG = LogFactory.getLog(DomainsServlet.class);

	private ServletContext context;
	private Sender s1;
	private Sender s2;
	private Sender s3;
	
	private static final String SIMPLE_PATTERN = "MM/dd/yy hh:mm:ss aa";

	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		context = config.getServletContext();
		LOG.debug("context: " + context);
		s1 = new Sender(EnvironmentUtils.getInstance().getFIXED_IP_NS1_INTERNAL(), 10025, 3, 50, 100, new SimpleSender());
		s2 = new Sender(EnvironmentUtils.getInstance().getFIXED_IP_NS2_INTERNAL(), 10025, 3, 50, 100, new SimpleSender());
		s3 = new Sender(EnvironmentUtils.getInstance().getFIXED_IP_NS3_INTERNAL(), 10025, 3, 50, 100, new SimpleSender());
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// NAUGHTY
		this.getServletContext().getRequestDispatcher("/index.jsp").forward(req, resp);
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			SessionHelper.restoreSessionIfNeeded(req);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
		if (SecurityHelper.hasValidSession(req)) {
			String recreateToken = req.getParameter("recreateToken");
			if (recreateToken != null) {
				recreateToken(req);
			}
			
			String deleteAccount = req.getParameter("deleteAccount");
			if (deleteAccount != null) {
				
				// NAUGHTY DUCK
				Account account = (Account) req.getSession().getAttribute("account");
				if (account.getAccountType().equals(Account.ACCOUNT_NAUGHTY_DUCK)) {
					ServletUtils.setFeedback(req, false,"unable to delete account because the account is locked");
				} else if (isAnyDomainSinkholed(account)) {
					ServletUtils.setFeedback(req, false,"unable to delete account");
				} else {
					boolean didWork = deleteAccount(req);
					if (didWork) {
						this.getServletContext().getRequestDispatcher("/logout.jsp").forward(req, resp);
						return;
					}
				}
			}
		}
		this.getServletContext().getRequestDispatcher("/index.jsp").forward(req, resp);
	}
	
	private boolean isAnyDomainSinkholed(Account account) {
		if (account != null) {
			AmazonDynamoDBDAO dao = AmazonDynamoDBDAO.getInstance();;
			List<Domain> domains = dao.domainsGetDomainsByToken(account.getAccountToken());
			if (domains != null) {
				for (Domain domain : domains) {
					if (domain.getSinkholedIp() != null && !domain.getSinkholedIp().equals("")) {
						return true;
					}
				}
			}
		}
		return false;
	}

	private boolean deleteAccount(HttpServletRequest req) {
		if (EnvironmentUtils.isAccountReadOnly()) {
			ServletUtils.setFeedback(req, false,EnvironmentUtils.ACCOUNTS_LOCKED);
			return false;
		}
		
		AmazonDynamoDBDAO dao = AmazonDynamoDBDAO.getInstance();
		Account account = (Account) req.getSession().getAttribute("account");
		// FLUSH all the Domains they have
		if (account != null) {
			List<Domain> domains = dao.domainsGetDomainsByToken(account.getAccountToken());
			if (domains != null) {
				for (Domain domain : domains) {
					// COOL expire the DNS CACHE(s)
					s1.send(new SingleLineMessage(domain.getDomainName()));
					s2.send(new SingleLineMessage(domain.getDomainName()));
					s3.send(new SingleLineMessage(domain.getDomainName()));
				}
			}
		}
		
		if (!dao.accountDeleteAccount(account.getEmail())) {
			ServletUtils.setFeedback(req, false,"unable to delete account");
			return false;
		}
		return true;
	}
	
	private void recreateToken(HttpServletRequest req) throws IOException {
		if (EnvironmentUtils.isAccountReadOnly()) {
			ServletUtils.setFeedback(req, false,EnvironmentUtils.ACCOUNTS_LOCKED);
			return;
		}
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(SIMPLE_PATTERN);
		Account account = (Account) req.getSession().getAttribute("account");
		AmazonDynamoDBDAO dao = AmazonDynamoDBDAO.getInstance();
		String newToken = dao.recreateToken(account.getEmail(), ServletUtils.getUpdaterIp(req), ServletUtils.getUpdaterAgent(req));
		// SAVE ANOTHER RE-READ AND JUST PUSH IT IN
		account.setAccountToken(newToken);
		// JUST PUT A NEAR DATE IN - NEXT LOGIN WILL BE 100% ACCURATE
		account.setLastUpdated(simpleDateFormat.format(new Date()));
		// TELL THEM IT WORKED
		ServletUtils.setFeedback(req, true,"account token updated - don't forget to update your clients");
	}
}
