package org.duckdns.util;

import java.util.HashSet;
import java.util.Set;

public class DomainNameFilterer {
	private static DomainNameFilterer instance = null;
	
	private Set<String> bannedList;
	
	protected DomainNameFilterer() {
		bannedList = new HashSet<String>();
		bannedList.add("www");
		bannedList.add("ns1");
		bannedList.add("ns2");
		bannedList.add("ns3");
	}
	
	public static DomainNameFilterer getInstance() {
		if(instance == null) {
			instance = new DomainNameFilterer();
		}
		return instance;
	}
	
	public boolean isAllowed(String testString) {
		if (bannedList.contains(testString)) {
			return false;
		}
		return true;
	}
}
