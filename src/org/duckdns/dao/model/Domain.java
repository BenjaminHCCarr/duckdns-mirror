package org.duckdns.dao.model;

import java.io.Serializable;
import java.util.Comparator;

import org.duckdns.util.FormatHelper;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBIgnore;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBIndexHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable;


@DynamoDBTable(tableName = "domainsv2")
public class Domain implements Comparable<Domain>, Serializable{

	private static final long serialVersionUID = -2423683302008845927L;
	public static int MAX_DOMAINS_FREE = 5;
	public static int MAX_DOMAINS_DONATE = 10;
	public static int MAX_DOMAINS_FRIENDS_OF_DUCK = 50;
	public static int MAX_DOMAINS_DUCK_MAX = 250;
	public static int MAX_DOMAINS_SUPER_DUCK = 100;
	public static int MAX_DOMAINS_NAUGHTY_DUCK = 0;
	public static int MAX_DOMAIN_LENGTH = 40;
	
	public static final String UPDATER_TYPE_HTTP = "http";
	public static final String UPDATER_TYPE_GUNDIP = "gundip";
	public static final String UPDATER_TYPE_DYNDNS = "dyndns";
	public static final String UPDATER_TYPE_SITE = "site";
	
	private String domainName;
	private String accountToken;
	private String currentIp;
	private String currentIpV6;
	private String lastUpdated;
	private String locked;
	private String updaterType;
	private String sinkholedIp;
	private String txt;

	@DynamoDBHashKey
	public String getDomainName() { return domainName; }
	public void setDomainName(String domainName) { this.domainName = domainName; }
	
	@DynamoDBAttribute
	@DynamoDBIndexHashKey(globalSecondaryIndexName = "accountToken-index")
	public String getAccountToken() { return accountToken; }
	public void setAccountToken(String accountToken) { this.accountToken = accountToken; }

	@DynamoDBAttribute
	public String getCurrentIp() { return currentIp; }
	public void setCurrentIp(String currentIp) { this.currentIp = currentIp; }
	
	@DynamoDBAttribute
	public String getCurrentIpV6() { 
		return FormatHelper.cleanLocalScopedIPv6(currentIpV6);
	}
	public void setCurrentIpV6(String currentIpV6) { 
		this.currentIpV6 = FormatHelper.cleanLocalScopedIPv6(currentIpV6);
	}
	
	@DynamoDBAttribute
	public String getLastUpdated() { return lastUpdated; }
	public void setLastUpdated(String lastUpdated) { this.lastUpdated = lastUpdated; }
	
	@DynamoDBAttribute
	public String getLocked() { return locked; }
	public void setLocked(String locked) { this.locked = locked; }
	
	@DynamoDBAttribute
	public String getUpdaterType() { return updaterType; }
	public void setUpdaterType(String updaterType) { this.updaterType = updaterType; }
	
	@DynamoDBAttribute
	public String getSinkholedIp() { return sinkholedIp; }
	public void setSinkholedIp(String sinkholedIp) { this.sinkholedIp = sinkholedIp; }
	
	@DynamoDBAttribute
	public String getTxt() { return txt; }
	public void setTxt(String txt) { this.txt = txt; }
	
	@DynamoDBIgnore
	@Override
	public int compareTo(Domain compareDomain){
		return (this.getDomainName()).compareTo(compareDomain.getDomainName());
	}

	public static Comparator<Domain> DomainComparator = new Comparator<Domain>() {
		public int compare(Domain domain1, Domain domain2) {
			String domainName1 = domain1.getDomainName().toUpperCase();
			String domainName2 = domain2.getDomainName().toUpperCase();
			return domainName1.compareTo(domainName2);
		}
	};
	
}