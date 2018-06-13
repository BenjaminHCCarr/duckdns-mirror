package org.duckdns.dao.model;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable;

@DynamoDBTable(tableName = "sessions")
public class Session {
	
	private String jsessionId;
	private String email;
	private String ip;
	private long lastHit;
	private String clrfToken;
	
	public static int TTL_SESSIONS_SECONDS = 10 * 60;
	
	@DynamoDBHashKey
	public String getJsessionId() { return jsessionId; }
	public void setJsessionId(String jsessionId) { this.jsessionId = jsessionId; }
	
	@DynamoDBAttribute
	public String getEmail() { return email; }
	public void setEmail(String email) { this.email = email; }
	
	@DynamoDBAttribute
	public String getIp() { return ip; }
	public void setIp(String ip) { this.ip = ip; }
	
	@DynamoDBAttribute
	public long getLastHit() { return lastHit; }
	public void setLastHit(long lastHit) { this.lastHit = lastHit; }
	
	@DynamoDBAttribute
	public String getClrfToken() { return clrfToken; }
	public void setClrfToken(String clrfToken) { this.clrfToken = clrfToken; }
}