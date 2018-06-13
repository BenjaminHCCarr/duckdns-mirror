package org.duckdns.util;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.duckdns.dao.AmazonDynamoDBDAO;
import org.duckdns.dao.model.Account;
import org.duckdns.dao.model.Domain;
import org.duckdns.dao.model.Session;

public class SessionHelper {
	private static final String HAS_TRIED_TO_RESTORE_SESSION = "hasTriedToRestoreSession";
	public static final String DID_RESTORE_SESSION = "didRestoreSession";
	

	public static void restoreSessionIfNeeded(HttpServletRequest request) throws IOException, ClassNotFoundException {
		
		if (request.getAttribute(HAS_TRIED_TO_RESTORE_SESSION) != null) {
			return;
		}
		request.setAttribute(HAS_TRIED_TO_RESTORE_SESSION,"yes");
		// IF SESSION IS NEW 
		// AND WE HAVE AN OLD JSESSIONID IN REQUEST THAT DOES NOT MATCH
		// THEN WE SHOULD TRY TO FETCH A SESSION FROM ELASTICACHE
		if (request.getSession() == null || request.getSession().isNew()) {
			String oldJsession = "";
			if (request.getCookies() != null) {
				for (Cookie cookie : request.getCookies()) {
					if (cookie.getName().equals("JSESSIONID")) {
						oldJsession = cookie.getValue();
						break;
					}
				}
			}
			if (oldJsession != null && oldJsession.length() > 0) {
				
				SessionHolder theOldSession = null;
				if (EnvironmentUtils.isDynamoSessionCache()) {
					Session session = AmazonDynamoDBDAO.getInstance().sessionsGetSession(oldJsession, ServletUtils.getAddressFromRequest(request));
					if (session != null) {
						theOldSession = new SessionHolder(session.getEmail(), session.getIp());
					}
				}
				
				if (theOldSession != null) {
					// ONLY ALLOWS SESSIONS TO BE RECOVERED FROM THE SAME ORIGONATING IP
					if (ServletUtils.getAddressFromRequest(request).equals(theOldSession.getIp())) {
						
						AmazonDynamoDBDAO dao = AmazonDynamoDBDAO.getInstance();
						Account account = dao.accountsGetAccount(theOldSession.getEmail(), ServletUtils.getUpdaterIp(request), ServletUtils.getUpdaterAgent(request));
						if (account == null) {
							// Accounts must be locked
							return;
						}
						request.getSession().setAttribute("email", theOldSession.getEmail());
						request.getSession().setAttribute("account", account);
						List<Domain> domains = dao.domainsGetDomainsByToken(account.getAccountToken());
						request.getSession().setAttribute("domains", domains);
						
						request.setAttribute(DID_RESTORE_SESSION, "yes");
						// OK THAT'S DONE BOSH THE OLD ONE AND MOVE IT ACROSS
						if (EnvironmentUtils.isDynamoSessionCache()) {
							// DynamoDB Move the session to the new JSessionID
							dao.sessionsDeleteSession(oldJsession, theOldSession.getIp());
							dao.sessionsCreateSession(request.getSession().getId(), theOldSession.getEmail(), theOldSession.getIp());
						}
					}
				}
			} 
		} else {
			// KEEP THE SESSION ALIVE
			if (SecurityHelper.hasValidSession(request)) {
				if (EnvironmentUtils.isDynamoSessionCache()) {
					// UPDATE THE DB CACHE FOR SESSIONS
					AmazonDynamoDBDAO.getInstance().sessionsRefreshSession(request.getSession().getId(), ServletUtils.getAddressFromRequest(request));
				}
			}
		}
	}
}
