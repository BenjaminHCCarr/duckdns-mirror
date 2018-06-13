package org.duckdns.util;

import java.security.MessageDigest;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.duckdns.dao.model.Account;

public final class SecurityHelper {

	public static boolean hasValidSession(HttpServletRequest req) {
		boolean isValidSession = false;
		
		if (req != null && req.getSession() != null) {
			if (req.getSession().getAttribute("email") != null && ((String)req.getSession().getAttribute("email")).length() != 0) {
				if (req.getSession().getAttribute("account") != null) {
					Object o = req.getSession().getAttribute("account");
					if (o instanceof Account) {
						Account account = (Account) o;
						if (account.getAccountToken() != null && account.getAccountToken().length() != 0) {
							isValidSession = true;
						}
					}
				}
			}
		}
		return isValidSession;
	}
		
	public static String generateEncryptedId(String identifier) {
		String returnId = "";
		try {
			byte[] identifierAsBytes = identifier.getBytes("UTF-8");
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] identifierDigest = md.digest(identifierAsBytes);
			String strIdentifierDigestAsHEX = bytesToHex(identifierDigest);
			strIdentifierDigestAsHEX = strIdentifierDigestAsHEX.toLowerCase();
	
			String saltedDigest = strIdentifierDigestAsHEX + "." + EnvironmentUtils.getInstance().getSalt();
			byte[] saltedIdentifierDigest = md.digest(saltedDigest.getBytes());
			String strSaltedIdentifierDigestAsBaseHEX = bytesToHex(saltedIdentifierDigest);
			
			returnId = strSaltedIdentifierDigestAsBaseHEX.toLowerCase();
		} catch (Exception e) {
			e.printStackTrace();
			returnId = UUID.randomUUID().toString();
		}
		return returnId;
	}	
	
	final protected static char[] hexArray = "0123456789abcdef".toCharArray();
	public static String bytesToHex(byte[] bytes) {
	    char[] hexChars = new char[bytes.length * 2];
	    for ( int j = 0; j < bytes.length; j++ ) {
	        int v = bytes[j] & 0xFF;
	        hexChars[j * 2] = hexArray[v >>> 4];
	        hexChars[j * 2 + 1] = hexArray[v & 0x0F];
	    }
	    return new String(hexChars);
	}
	
}
