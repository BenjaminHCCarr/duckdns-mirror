package org.duckdns.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashSet;
import java.util.Set;
import java.util.StringTokenizer;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.duckdns.communications.Sender;
import org.duckdns.communications.clients.SimpleSender;
import org.duckdns.communications.messages.SingleLineMessage;
import org.duckdns.dao.AmazonDynamoDBDAO;
import org.duckdns.dao.model.Domain;
import org.duckdns.util.EnvironmentUtils;
import org.duckdns.util.ServletUtils;

public class DynDnsServlet extends javax.servlet.http.HttpServlet {

	private static final long serialVersionUID = -1;
	private static final Log LOG = LogFactory.getLog(DynDnsServlet.class);
	
	private static final String ROOT_DOMAIN = ".duckdns.org";

	private ServletContext context;
	
	private Sender s1;
	private Sender s2;
	private Sender s3;
	
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		context = config.getServletContext();
		LOG.debug("context: " + context);
		s1 = new Sender(EnvironmentUtils.getInstance().getFIXED_IP_NS1_INTERNAL(), 10025, 3, 100, 2000, new SimpleSender());
		s2 = new Sender(EnvironmentUtils.getInstance().getFIXED_IP_NS2_INTERNAL(), 10025, 3, 100, 2000, new SimpleSender());
		s3 = new Sender(EnvironmentUtils.getInstance().getFIXED_IP_NS3_INTERNAL(), 10025, 3, 100, 2000, new SimpleSender());
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		// http://username:password@members.dyndns.org/nic/update?hostname=yourhostname&myip=ipaddress&wildcard=NOCHG&mx=NOCHG&backmx=NOCHG
		
		String username = "";
		String password = "";
		
		// FORCE AN AUTH
		final String authorization = req.getHeader("Authorization");
		if (authorization != null && authorization.startsWith("Basic")) {
			// Authorization: Basic base64credentials
			String base64Credentials = authorization.substring("Basic".length()).trim();
			String credentials = StringUtils.newStringUtf8(Base64.decodeBase64(base64Credentials));
			// credentials = username:password
			final String[] values = credentials.split(":",2);
			
			username = values[0];
			password = values[1];
			
			//System.out.println(values[0] + " " + values[1]);
		} else {
			resp.setStatus(401);
			resp.setHeader("WWW-Authenticate", "basic realm=\"Auth ("  + ")\"" );
			PrintWriter writer = resp.getWriter();
			writer.print("Login Required");
			writer.flush();
			writer.close();
			return;
		}
		
		String updateDomains = req.getParameter("hostname");
		String token = password;
		String optionalIp = req.getParameter("myip");
		
		if (updateDomains != null && token != null) {
			String message = updateTheDomains(req,updateDomains,token,optionalIp);
			PrintWriter writer = resp.getWriter();
			writer.print(message);
			writer.flush();
			writer.close();
			return;
		}
		
		PrintWriter writer = resp.getWriter();
		writer.print("bad");
		writer.flush();
		writer.close();
		return;
	}

	private String updateTheDomains(HttpServletRequest req, String updateDomains, String token, String optionalIp) {
		String returnMessage = "bad";
		boolean allSame = true;
		if (updateDomains.length() > 0) {
			int largestPossible = (Domain.MAX_DOMAIN_LENGTH * Domain.MAX_DOMAINS_DONATE) + 9;
			if (updateDomains.length() < largestPossible) {
				// SENSIBLE - KEEP AT IT
				int hasAComma = updateDomains.indexOf(',');
				Set<String> domains = new HashSet<String>();
				if (hasAComma == -1) {
					domains.add(updateDomains);
				} else {
					// MORE THAN ONE
					StringTokenizer st = new StringTokenizer(updateDomains,",");
					while (st.hasMoreTokens()) {
						domains.add(st.nextToken());
					}
				}
				if (domains.size() > 0) {
					if (optionalIp == null || optionalIp.length() == 0) {
						optionalIp = ServletUtils.getAddressFromRequest(req);
					}
					boolean oneFailed = false;
					for (String domain : domains) {
						boolean isAllowed = true;
						// PROTECTION BLOCK FOR WWW
						if (domain.equals("www")) {
							String requestIP = ServletUtils.getAddressFromRequest(req);
							if (requestIP.equals(EnvironmentUtils.getInstance().getFIXED_IP_NS1()) || requestIP.equals(EnvironmentUtils.getInstance().getFIXED_IP_NS2()) || requestIP.equals(EnvironmentUtils.getInstance().getFIXED_IP_NS3())) {
								LOG.warn("domain update request for " + domain + " from " + ServletUtils.getAddressFromRequest(req)+ " main site now at " + optionalIp);
							} else {
								isAllowed = false;
							}
						}
						if (isAllowed) {
							
							// STRIP TRAILING ROOT DOMAIN FOR PEOPLE THAT CANNOT FOLLOW INSTRUCTIONS
							if (domain.endsWith(ROOT_DOMAIN)) {
								domain = domain.substring(0,domain.length()-ROOT_DOMAIN.length());
							}
							
							int result = AmazonDynamoDBDAO.getInstance().domainUpdateIp(optionalIp, domain, token, Domain.UPDATER_TYPE_DYNDNS);
							if (result == AmazonDynamoDBDAO.UPDATE_RETURN_FAILED) {
								oneFailed = true;
							} else {
								if (result == AmazonDynamoDBDAO.UPDATE_RETURN_UPDATED) {
									// COOL expire the DNS CACHE(s)
									s1.send(new SingleLineMessage(domain));
									s2.send(new SingleLineMessage(domain));
									s3.send(new SingleLineMessage(domain));
									allSame = false;
								}
							}
						} else {
							oneFailed = true;
						}
					}
					if (!oneFailed) {
						if (allSame) {
							returnMessage = "nochg";
						} else {
							returnMessage = "good";	
						}
					}
				}
			}
		}
		return returnMessage;
	}
}
