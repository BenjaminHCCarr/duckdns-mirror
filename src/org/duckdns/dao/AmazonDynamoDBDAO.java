package org.duckdns.dao;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.duckdns.dao.model.Account;
import org.duckdns.dao.model.Domain;
import org.duckdns.dao.model.Session;
import org.duckdns.util.EnvironmentUtils;
import org.duckdns.util.SecurityHelper;
import org.duckdns.util.ServletUtils;
import org.duckdns.util.ValidationUtils;

import com.amazonaws.auth.ClasspathPropertiesFileCredentialsProvider;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBScanExpression;
import com.amazonaws.services.dynamodbv2.datamodeling.PaginatedScanList;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.ComparisonOperator;
import com.amazonaws.services.dynamodbv2.model.Condition;
import com.amazonaws.services.dynamodbv2.model.QueryRequest;
import com.amazonaws.services.dynamodbv2.model.QueryResult;

public class AmazonDynamoDBDAO {
	
	private static AmazonDynamoDBDAO instance = null;
	private static AmazonDynamoDBClient dynamoDB;
	private static DynamoDBMapper mapper;
	
	public static final int UPDATE_RETURN_FAILED = 0;
	public static final int UPDATE_RETURN_UPDATED = 1;
	public static final int UPDATE_RETURN_SAME = 2;
	
	private static final Log LOG = LogFactory.getLog(AmazonDynamoDBDAO.class);
	
	private static final String SIMPLE_PATTERN = "MM/dd/yy hh:mm:ss aa";
	
	protected AmazonDynamoDBDAO() {
		dynamoDB = new AmazonDynamoDBClient(new ClasspathPropertiesFileCredentialsProvider());
        Region usWest2 = Region.getRegion(Regions.US_WEST_2);
        
        String local_db = EnvironmentUtils.getInstance().getLocal_db();
        if (local_db != null && local_db.trim().length() > 0) {
        	// LOCAL
        	dynamoDB.setEndpoint(local_db,"local","us-west-2"); 
        } else {
        	// PROD
        	dynamoDB.setRegion(usWest2);
        }
        mapper = new DynamoDBMapper(dynamoDB);
	}
	
	public static AmazonDynamoDBDAO getInstance() {
		if(instance == null) {
			instance = new AmazonDynamoDBDAO();
		}
		return instance;
	}
	
	public Session sessionsCreateSession(String jsessionId, String email, String ip) {
		Session session = new Session();
		session.setJsessionId(jsessionId);
		session.setEmail(email);
		session.setIp(ip);
		session.setLastHit(System.currentTimeMillis());
		session.setClrfToken(createClrfToken());
		mapper.save(session);
		//LOG.info("Sessions Create Result: " + session);
		return session;
	}
	
	private String createClrfToken() {
		return UUID.randomUUID().toString().replaceAll("-", "");
	}
	
	public boolean sessionsCheckClrfToken(String jsessionId, String ip, String clrf) {
		Session session = sessionsGetSession(jsessionId, ip);
		if (session != null && clrf != null) {
			if (session.getClrfToken().equals(clrf)) {
				return true;
			}
		}
		return false;
	}
	
	public Session sessionsChangeClrfToken(String jsessionId, String ip) {
		Session session = sessionsGetSession(jsessionId, ip);
		if (session != null) {
			session.setClrfToken(createClrfToken());
			mapper.save(session);
			return session;
		}
		return null;
	}

	public boolean sessionsDeleteSession(String jsessionId, String ip) {
		Session session = sessionsGetSession(jsessionId, ip);
		if (session != null) {
			mapper.delete(session);
			return true;
		}
		return false;
	}
	
	public boolean sessionsRefreshSession(String jsessionId, String ip) {
		Session session = sessionsGetSession(jsessionId, ip);
		if (session != null) {
			session.setLastHit(System.currentTimeMillis());
			mapper.save(session);
			return true;
		}
		return false;
	}
	
	public Session sessionsGetSession(String jsessionId, String ip) {
		if (jsessionId == null || ip == null) {
			return null;
		}
		Session session = mapper.load(Session.class, jsessionId);
		if (session == null) {
			return null;
		}
		// SECURITY CHECK
		if (session.getIp() != null && session.getIp().equals(ip)) {
			//LOG.info("Session Get Result: " + session);           
			return session;
		}
		return null;
	}
	
	public void sessionsCleanUpOldSessions() {
		DynamoDBScanExpression scanExpression = new DynamoDBScanExpression();
		scanExpression.addFilterCondition("lastHit", 
				new Condition()
        			.withComparisonOperator(ComparisonOperator.LT.toString())
        			.withAttributeValueList(new AttributeValue().withN(""+(System.currentTimeMillis()-(Session.TTL_SESSIONS_SECONDS * 1000))))
				);
		PaginatedScanList<Session> result = mapper.scan(Session.class, scanExpression);
		mapper.batchDelete(result);
	}
	
	private String getUniqueToken() {
		for (int attempts = 0;attempts<10;attempts++) {
			String candidate = UUID.randomUUID().toString();
			if (accountGetAccountByToken(candidate) == null) {
				return candidate;
			}
		}
		return null;
	}

	public Account accountsCreateAccount(String email, String creatorIp) {
		Account account = new Account();
		account.setEmail(email);
		account.setAccountType(Account.ACCOUNT_FREE);
		String token = getUniqueToken();
		if (token == null) {
			// 10 attempts to get a Unique token failed
			// They will see an error
			return null;
		}
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(SIMPLE_PATTERN);
		account.setAccountToken(token);
		account.setLastUpdated(simpleDateFormat.format(new Date()));
		account.setCreatedDate(simpleDateFormat.format(new Date()));
		mapper.save(account);
		//LOG.info("Accounts Create Result: " + account);
		return account;
	}
	
	public Account accountGetAccountByToken(String token) {
		
		Condition hashKeyCondition = new Condition();
		hashKeyCondition.withComparisonOperator(ComparisonOperator.EQ).withAttributeValueList(new AttributeValue().withS(token));

		Map<String, Condition> keyConditions = new HashMap<String, Condition>();
		keyConditions.put("accountToken", hashKeyCondition);

		QueryRequest queryRequest = new QueryRequest();
		queryRequest.withTableName("accountsv2");
		queryRequest.withIndexName("accountToken-index");
		queryRequest.withKeyConditions(keyConditions);

		QueryResult result = dynamoDB.query(queryRequest);

		for(Map<String, AttributeValue> item : result.getItems()) {
			Account mappedItem = mapper.marshallIntoObject(Account.class, item);
			// Only want the First one
			return mappedItem;
		}
		
		return null;
	}
	
	public boolean accountCheckLogin(String email, String token) {
		if (email != null && token != null) {
			Account account = mapper.load(Account.class, email);
			if (account != null) {
				if (account.getAccountToken() != null) {
					if (account.getAccountToken().equals(token)) {
						return true;
					}
 				}
			}
		}
		return false;
	}

	public Account accountsGetAccount(String email, String creatorIp, String creatorAgent) {
		Account account = mapper.load(Account.class, email);
		if (account == null) {
			if (EnvironmentUtils.isAccountReadOnly()) {
				return null;
			}
			account = accountsCreateAccount(email, creatorIp);
		}
		boolean hadToFixSomething = false;
		if (account.getAccountToken() == null || account.getAccountToken().length() == 0) {
			// DEAL WITH ACCOUNTS WITH NO TOKEN
			String token = getUniqueToken();
			if (token == null) {
				// 10 attempts to get a Unique token failed
				// They will see an error
				return null;
			}
			account.setAccountToken(token);
			hadToFixSomething = true;
		}
		if (account.getAccountType() == null || account.getAccountType().length() == 0) {
			// DEAL WITH ACCOUNTS WITH NO TYPE
			account.setAccountType(Account.ACCOUNT_FREE);
			hadToFixSomething = true;
		}
		if (account.getCreatedDate() == null || account.getCreatedDate().length() == 0) {
			// DEAL WITH BLANK CREATED DATE
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(SIMPLE_PATTERN);
			account.setCreatedDate(simpleDateFormat.format(new Date()));
			hadToFixSomething = true;
		}
		if (hadToFixSomething) {
			mapper.save(account);
		}
		//LOG.info("Account Get Result: " + account);           
		return account;
	}
	
	public Domain domainsCreateDomain(String domainName, String accountToken, String currentIp, String updaterType) {
		
		if (!ValidationUtils.isValidSubDomain(domainName)) {
			return null;
		}
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(SIMPLE_PATTERN);
		
		Domain domain = new Domain();
		domain.setDomainName(domainName);
		domain.setAccountToken(accountToken);
		if (ServletUtils.isIPv6Address(currentIp)) {
			domain.setCurrentIpV6(currentIp);
		} else {
			domain.setCurrentIp(currentIp);
		}
		domain.setLastUpdated(simpleDateFormat.format(new Date()));
		domain.setUpdaterType(updaterType);
		mapper.save(domain);
		//LOG.info("Domains Create Result: " + domain);
		return domain;
	}

	public Domain domainGetDomain(String domainName) {
		Domain domain = mapper.load(Domain.class, domainName);
		//LOG.info("Domains Get Result: " + domain);           
		return domain;
	}
	
	public int domainUpdateIp(String ipAddress, String domainName, String accountToken, String updaterType) {
		
		if (!ValidationUtils.isValidSubDomain(domainName)) {
			return UPDATE_RETURN_FAILED;
		}
		if (!ValidationUtils.isValidIpAddress(ipAddress)) {
			return UPDATE_RETURN_FAILED;
		}
		
		Domain domain = mapper.load(Domain.class, domainName);
		if (domain == null) {
			return UPDATE_RETURN_FAILED;
		}
		// NAUGHTY DUCK - DOMAIN LOCKED
		if (domain.getLocked() != null && domain.getLocked().equals("true")) {
			return UPDATE_RETURN_FAILED;
		}
		//LOG.info("Domains update ip check Result: " + domain); 
		if (domain.getAccountToken().equals(accountToken)) {
			
			// QUICK CHECK BOTH EMPTY OR NULL
			if ((ipAddress == null || ipAddress.length() == 0) && (domain.getCurrentIp() == null || domain.getCurrentIp().length() == 0)) {
				// Nothing to do here
				return UPDATE_RETURN_SAME;
			}
			
			if (ipAddress.equals(domain.getCurrentIp())) {
				// Nothing to do here
				return UPDATE_RETURN_SAME;
			}
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(SIMPLE_PATTERN);
			domain.setCurrentIp(ipAddress);
			domain.setLastUpdated(simpleDateFormat.format(new Date()));
			domain.setUpdaterType(updaterType);
			mapper.save(domain);
			return UPDATE_RETURN_UPDATED;
		}
		return UPDATE_RETURN_FAILED;
	}
	
	public int domainUpdateIpV6(String ipv6Address, String domainName, String accountToken, String updaterType) {
		
		if (!ValidationUtils.isValidSubDomain(domainName)) {
			return UPDATE_RETURN_FAILED;
		}
		if (!ValidationUtils.isValidIpV6Address(ipv6Address)) {
			return UPDATE_RETURN_FAILED;
		}
		
		Domain domain = mapper.load(Domain.class, domainName);
		if (domain == null) {
			return UPDATE_RETURN_FAILED;
		}
		// NAUGHTY DUCK - DOMAIN LOCKED
		if (domain.getLocked() != null && domain.getLocked().equals("true")) {
			return UPDATE_RETURN_FAILED;
		}
		//LOG.info("Domains update ip check Result: " + domain); 
		if (domain.getAccountToken().equals(accountToken)) {
			
			// QUICK CHECK BOTH EMPTY OR NULL
			if ((ipv6Address == null || ipv6Address.length() == 0) && (domain.getCurrentIpV6() == null || domain.getCurrentIpV6().length() == 0)) {
				// Nothing to do here
				return UPDATE_RETURN_SAME;
			}
			
			if (ipv6Address.equals(domain.getCurrentIpV6())) {
				// Nothing to do here
				return UPDATE_RETURN_SAME;
			}
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(SIMPLE_PATTERN);
			domain.setCurrentIpV6(ipv6Address);
			domain.setLastUpdated(simpleDateFormat.format(new Date()));
			domain.setUpdaterType(updaterType);
			mapper.save(domain);
			return UPDATE_RETURN_UPDATED;
		}
		return UPDATE_RETURN_FAILED;
	}
	
	public int domainUpdateTxt(String txt, String domainName, String accountToken) {
		if (!ValidationUtils.isValidSubDomain(domainName)) {
			return UPDATE_RETURN_FAILED;
		}
		
		Domain domain = mapper.load(Domain.class, domainName);
		if (domain == null) {
			return UPDATE_RETURN_FAILED;
		}
		// NAUGHTY DUCK - DOMAIN LOCKED
		if (domain.getLocked() != null && domain.getLocked().equals("true")) {
			return UPDATE_RETURN_FAILED;
		}
		//LOG.info("Domains update ip check Result: " + domain); 
		if (domain.getAccountToken().equals(accountToken)) {
			
			// QUICK CHECK BOTH EMPTY OR NULL
			if ((txt == null || txt.length() == 0) && (domain.getTxt() == null || domain.getTxt().length() == 0)) {
				// Nothing to do here
				return UPDATE_RETURN_SAME;
			}
			
			if (txt.equals(domain.getTxt())) {
				// Nothing to do here
				return UPDATE_RETURN_SAME;
			}
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(SIMPLE_PATTERN);
			// TODO SANITISE THE TXT
			domain.setTxt(txt);
			domain.setLastUpdated(simpleDateFormat.format(new Date()));
			mapper.save(domain);
			return UPDATE_RETURN_UPDATED;
		}
		return UPDATE_RETURN_FAILED;
	}
	
	public boolean domainDeleteDomain(String domainName, String accountToken) {
		Domain domain = mapper.load(Domain.class, domainName);
		if (domain == null) {
			return false;
		}
		//LOG.info("Domains Delete check Result: " + domain); 
		if (domain.getAccountToken().equals(accountToken)) {
			mapper.delete(domain);
			return true;
		}
		return false;
	}
	
	public String recreateToken(String email, String creatorIp, String creatorAgent) {
		// GET OLD TOKEN
		Account currentAccount = accountsGetAccount(email, creatorIp, creatorAgent);
		String oldToken = currentAccount.getAccountToken();
		
		// GENERATE NEW TOKEN
		String newToken = getUniqueToken();
		if (newToken == null) {
			// 10 attempts to get a Unique token failed
			// They will see an error
			return null;
		}
		
		// UPDATE THE ACCOUNT TABLE
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(SIMPLE_PATTERN);
		currentAccount.setAccountToken(newToken);
		currentAccount.setLastUpdated(simpleDateFormat.format(new Date()));
		mapper.save(currentAccount);
        
		// SEARCH FOR MATCHING DOMAIN RECORD
		List<Domain> domains = domainsGetDomainsByToken(oldToken);
        
        // SPIN THROUGH THEM UPDATING THEM
        for (Domain domain : domains) {
        	domain.setAccountToken(newToken);
        	mapper.save(domain);
        }
        
        return newToken;
	}

	public List<Domain> domainsGetDomainsByToken(String token) {
		
		Condition hashKeyCondition = new Condition();
		hashKeyCondition.withComparisonOperator(ComparisonOperator.EQ).withAttributeValueList(new AttributeValue().withS(token));


		Map<String, Condition> keyConditions = new HashMap<String, Condition>();
		keyConditions.put("accountToken", hashKeyCondition);


		QueryRequest queryRequest = new QueryRequest();
		queryRequest.withTableName("domainsv2");
		queryRequest.withIndexName("accountToken-index");
		queryRequest.withKeyConditions(keyConditions);

		QueryResult result = dynamoDB.query(queryRequest);
		
		List<Domain> mappedItems = new ArrayList<Domain>();

		for(Map<String, AttributeValue> item : result.getItems()) {
			Domain mappedItem = mapper.marshallIntoObject(Domain.class, item);
		    mappedItems.add(mappedItem);
		}
		
		return mappedItems;
	}

	public boolean accountDeleteAccount(String email) {
		Account account = accountsGetAccount(email, "", "");
		if (account != null) {
			List<Domain> domains = domainsGetDomainsByToken(account.getAccountToken());
			if (domains != null) {
				for (Domain domain : domains) {
					mapper.delete(domain);
				}
			}
			mapper.delete(account);
		} else {
			return false;
		}
		return true;
	}

}