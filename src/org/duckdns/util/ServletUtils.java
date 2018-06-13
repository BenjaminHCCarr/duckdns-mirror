package org.duckdns.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

public class ServletUtils {
	private static final String IP_ADDRESS_REGEX = "([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3})";
    private static final String PRIVATE_IP_ADDRESS_REGEX = "(^127\\.0\\.0\\.1)|(^10\\.)|(^172\\.1[6-9]\\.)|(^172\\.2[0-9]\\.)|(^172\\.3[0-1]\\.)|(^192\\.168\\.)";
    private static Pattern IP_ADDRESS_PATTERN = null;
    private static Pattern PRIVATE_IP_ADDRESS_PATTERN = null;

	public static final String FEEDBACK_POSITIVE = "feedbackP";
	public static final String FEEDBACK_NEGATIVE = "feedbackN";
	
	public static void setFeedback(HttpServletRequest req, boolean isPositive, String theMessage) {
		if (isPositive) {
			req.setAttribute(FEEDBACK_POSITIVE, theMessage);
		} else {
			req.setAttribute(FEEDBACK_NEGATIVE, theMessage);
		}
	}
 
    private static String findNonPrivateIpAddress(String s) {
        if (IP_ADDRESS_PATTERN == null) {
            IP_ADDRESS_PATTERN = Pattern.compile(IP_ADDRESS_REGEX);
            PRIVATE_IP_ADDRESS_PATTERN = Pattern.compile(PRIVATE_IP_ADDRESS_REGEX);
        }
        Matcher matcher = IP_ADDRESS_PATTERN.matcher(s);
        while (matcher.find()) {
            if (!PRIVATE_IP_ADDRESS_PATTERN.matcher(matcher.group(0)).find()) {
                return matcher.group(0);
            }
            matcher.region(matcher.end(), s.length());
        }
        return null;
    }
 
    public static boolean isIPv6Address(String input) {
    	if (input != null && input.contains(":")) {
    		return true;
    	}
    	return false;
    }
    
    public static String getAddressFromRequest(HttpServletRequest request) {
        String forwardedFor = request.getHeader("X-Forwarded-For");
        // TEST TO SEE IF THIS IS A COMMA SEPERATED LIST OF IP'S - TAKE THE FIRST
        if (forwardedFor != null) {
        	int commaPos = forwardedFor.indexOf(",");
        	if (commaPos > -1) {
        		forwardedFor = forwardedFor.substring(0,commaPos);
        	}
        }
        if (isIPv6Address(forwardedFor)) {
        	return forwardedFor;
        }
        if (forwardedFor != null && (forwardedFor = findNonPrivateIpAddress(forwardedFor)) != null) {
            return forwardedFor;
        }
        return request.getRemoteAddr();
    }
    
    public static boolean isSecureFromRequest(HttpServletRequest request) {
        String forwardedProto = request.getHeader("X-Forwarded-Proto");
        if (forwardedProto != null && forwardedProto.toLowerCase().equals("https")) {
            return true;
        }
        return false;
    }
    
    public static String getHostNameFromRequest(HttpServletRequest request) {
        String forwardedFor = request.getHeader("X-Host");
        if (forwardedFor != null) {
            return forwardedFor;
        } 
        return EnvironmentUtils.getHostName();
    }
    
    public static String getUpdaterIp(HttpServletRequest request) {
    	return ServletUtils.getAddressFromRequest(request);
    }
    
    public static String getUpdaterAgent(HttpServletRequest request) {
    	String ua = request.getHeader("user-agent");
    	if (ua == null) {
    		return "";
    	}
    	return ua.trim();    	
    }
    
    
    
}
