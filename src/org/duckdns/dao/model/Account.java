package org.duckdns.dao.model;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBIgnore;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBIndexHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable;

@DynamoDBTable(tableName = "accountsv2")
public class Account {

	public static final String ACCOUNT_FREE = "free";
	public static final String ACCOUNT_DONATE = "donated";
	public static final String ACCOUNT_FRIENDS_OF_DUCK = "friends of duck";
	public static final String ACCOUNT_DUCK_MAX = "duck max";
	public static final String ACCOUNT_SUPER_DUCK = "super duck";
	public static final String ACCOUNT_NAUGHTY_DUCK = "naughty duck";

	private String email;
	private String accountToken;
	private String lastUpdated;
	private String createdDate;
	private String accountType;

	@DynamoDBHashKey
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	@DynamoDBAttribute
	@DynamoDBIndexHashKey(globalSecondaryIndexName = "accountToken-index")
	public String getAccountToken() {
		return accountToken;
	}

	public void setAccountToken(String accountToken) {
		this.accountToken = accountToken;
	}

	@DynamoDBAttribute
	public String getLastUpdated() {
		return lastUpdated;
	}

	public void setLastUpdated(String lastUpdated) {
		this.lastUpdated = lastUpdated;
	}

	@DynamoDBAttribute
	public String getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(String createdDate) {
		this.createdDate = createdDate;
	}

	@DynamoDBAttribute
	public String getAccountType() {
		return accountType;
	}

	public void setAccountType(String accountType) {
		this.accountType = accountType;
	}

	@DynamoDBIgnore
	public int getMaxDomains() {
		if (getAccountType() != null && getAccountType().equals(ACCOUNT_DONATE)) {
			return Domain.MAX_DOMAINS_DONATE;
		} else if (getAccountType() != null && getAccountType().equals(ACCOUNT_FRIENDS_OF_DUCK)) {
			return Domain.MAX_DOMAINS_FRIENDS_OF_DUCK;
		} else if (getAccountType() != null && getAccountType().equals(ACCOUNT_DUCK_MAX)) {
			return Domain.MAX_DOMAINS_DUCK_MAX;
		} else if (getAccountType() != null && getAccountType().equals(ACCOUNT_SUPER_DUCK)) {
			return Domain.MAX_DOMAINS_SUPER_DUCK;
		} else if (getAccountType() != null && getAccountType().equals(ACCOUNT_NAUGHTY_DUCK)) {
			return Domain.MAX_DOMAINS_NAUGHTY_DUCK;
		} else {
			return Domain.MAX_DOMAINS_FREE;
		}
	}
}