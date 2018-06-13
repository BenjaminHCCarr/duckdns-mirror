package org.duckdns.util;

public class ValidationUtils {
	
	public static boolean isValidSubDomain(final String testString) {
		if (testString == null || testString.length() == 0) {
			return false;
		}
		if (testString.matches("^[a-zA-Z0-9\\-]*$")) {
			return true;
		}
		return false;
	}
	
	public static boolean isValidIpAddress(final String testString) {
		if (testString == null || testString.length() == 0) {
			return true;
		}
		if (testString.matches("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$")) {
			return true;
		}
		return false;
	}
	
	public static boolean isValidIpV6Address(final String testString) {
		if (testString == null || testString.length() == 0) {
			return true;
		}
		if (testString.matches("(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))")) {
			return true;
		}
		return false;
	}
	
	public static void main(String[] args) {
		System.out.println(isValidSubDomain("banana"));
		System.out.println(isValidSubDomain("banana___"));
		System.out.println(isValidSubDomain("banana-fdfsdf45434"));
		
		System.out.println(isValidIpAddress("127.0.0.1"));
		System.out.println(isValidIpAddress("127.300.0.1"));
	}

}
