<?xml version="1.0" encoding="UTF-8"?>
<%@ page contentType="text/html; charset=UTF-8" import="
java.util.ArrayList,
java.util.GregorianCalendar,
java.util.Calendar,
java.util.Map,
java.util.Date,
java.util.Enumeration,
java.util.List,
java.util.LinkedHashMap,
java.util.Collections,
java.util.UUID,
java.text.DateFormat,
org.duckdns.util.SessionHolder,
org.duckdns.dao.model.Account,
org.duckdns.dao.model.Domain,
org.duckdns.servlets.DomainsServlet,
org.duckdns.util.ValidationUtils,
org.duckdns.util.ServletUtils,
org.duckdns.util.FormatHelper,
org.duckdns.util.EnvironmentUtils,
org.duckdns.util.Serialization,
org.duckdns.util.SessionHelper,
org.duckdns.util.SecurityHelper" %>
<%@ taglib prefix="module" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
SessionHelper.restoreSessionIfNeeded(request);
String ourDomain = EnvironmentUtils.OUR_DOMAIN;

boolean isLoggedIn = false;
String sessionEmail = "";
Account account = null;
List<Domain> domains = null;
int numDomains = 0;

if (request.getSession() != null) {
	sessionEmail = (String) request.getSession().getAttribute("email");
	if (sessionEmail != null && sessionEmail.length() > 0) {
		account = (Account) request.getSession().getAttribute("account");
		if (account != null) {
			isLoggedIn = true;
			if (SecurityHelper.hasValidSession(request)) {
				DomainsServlet.reloadDomains(request);
			}	
			if (request.getSession().getAttribute("domains") != null) {
				Object oDomains = request.getSession().getAttribute("domains");
				if (oDomains instanceof List) {
					domains = (List<Domain>) oDomains;
					numDomains = domains.size();
				}
			}
		}
	}
}

//TEST
/*
isLoggedIn = true;
String isLoggedInStr = "true";
account = new Account();
account.setAccountToken("432434234-34234-2343-22423423");
account.setAccountType("free");
account.setCreatedDate("11/04/12 9:30 PM");
account.setEmail("test@test.com");
account.setLastUpdated("12/02/13 9:30 PM");
ourDomain = ".duckdns.org";
sessionEmail = "timothy@test.com";

domains = new ArrayList<Domain>();
Domain tmpDomain = new Domain();
tmpDomain.setDomainName("easypeasy");
tmpDomain.setAccountToken("dsadsad-rewef-sxsfd-sdfds");
tmpDomain.setCurrentIp("134.23.57.87");
tmpDomain.setLastUpdated("05/04/14 9:30 PM");
domains.add(tmpDomain);
tmpDomain = new Domain();
tmpDomain.setDomainName("lemonsqueezy");
tmpDomain.setAccountToken("richard-is-a-noob-lol-cat");
tmpDomain.setCurrentIp("145.243.157.187");
tmpDomain.setLastUpdated("01/01/13 9:30 PM");
domains.add(tmpDomain);
*/

String accountIcon = "ducky_icon";
if (isLoggedIn && account.getAccountType().equals(Account.ACCOUNT_DONATE)) {
	accountIcon = "ducky_icon_gold";
} else if (isLoggedIn && account != null && account.getAccountType().equals(Account.ACCOUNT_FRIENDS_OF_DUCK)) {
	accountIcon = "ducky_icon_diamond";
} else if (isLoggedIn && account != null && account.getAccountType().equals(Account.ACCOUNT_DUCK_MAX)) {
	accountIcon = "ducky_icon_max";
} else if (isLoggedIn && account != null && account.getAccountType().equals(Account.ACCOUNT_SUPER_DUCK)) {
	accountIcon = "ducky_icon_super";
} else if (isLoggedIn && account != null && account.getAccountType().equals(Account.ACCOUNT_NAUGHTY_DUCK)) {
	accountIcon = "ducky_icon_naughty";
}

String isProductionStr = "false";
if (EnvironmentUtils.isProduction()) {
	isProductionStr = "true";
}

String isLoggedInStr = "false";
if (isLoggedIn) {
	isLoggedInStr = "true";
	pageContext.setAttribute("sessionEmailStr", sessionEmail);
	pageContext.setAttribute("accountType", account.getAccountType());
	pageContext.setAttribute("accountToken", account.getAccountToken());
	pageContext.setAttribute("tokenGenerated", FormatHelper.convertShortDateToHumanReadableTimeAgo(account.getLastUpdated()));
	pageContext.setAttribute("createdDate", FormatHelper.toReadableDate(account.getCreatedDate()));
}

boolean hasGoodFeedback = false;
boolean hasBadFeedback = false;
String hasGoodFeedbackStr = "false";
String hasBadFeedbackStr = "false";
String goodFeedback = "";
String badFeedback = "";
Object goodFeedbackRaw = request.getAttribute(ServletUtils.FEEDBACK_POSITIVE);
Object badFeedbackRaw = request.getAttribute(ServletUtils.FEEDBACK_NEGATIVE);
if (goodFeedbackRaw != null && goodFeedbackRaw instanceof String) {
	goodFeedback = (String) goodFeedbackRaw;
	hasGoodFeedback = true;
	hasGoodFeedbackStr = "true";
}
if (badFeedbackRaw != null && badFeedbackRaw instanceof String) {
	badFeedback = (String) badFeedbackRaw;
	hasBadFeedback = true;
	hasBadFeedbackStr = "true";
}

String domainsLabel = "success";
int maxDomains = 4;
if (isLoggedIn) {
	maxDomains = account.getMaxDomains();
}
if (isLoggedIn && domains != null && account != null && numDomains >= account.getMaxDomains()) {
	domainsLabel = "important";
}

List<Domain> listDomains;
if (domains != null) {
	listDomains = new ArrayList<Domain>(domains);
	Collections.sort(listDomains);
	for (Domain eachDomain : listDomains) {
		eachDomain.setLastUpdated(FormatHelper.convertShortDateToHumanReadableTimeAgo(eachDomain.getLastUpdated()));
	}
	pageContext.setAttribute("listDomains", listDomains);
}

pageContext.setAttribute("domainsLabel", domainsLabel);
pageContext.setAttribute("numDomains", numDomains);
pageContext.setAttribute("maxDomains", maxDomains);

pageContext.setAttribute("ourDomain", ourDomain);
pageContext.setAttribute("goodFeedback", goodFeedback);
pageContext.setAttribute("badFeedback", badFeedback);
pageContext.setAttribute("hasGoodFeedbackStr", hasGoodFeedbackStr);
pageContext.setAttribute("hasBadFeedbackStr", hasBadFeedbackStr);

pageContext.setAttribute("isLoggedInStr", isLoggedInStr);
pageContext.setAttribute("accountIcon", accountIcon);
pageContext.setAttribute("isProductionStr", isProductionStr);

pageContext.setAttribute("state", UUID.randomUUID().toString().replaceAll("-", ""));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
	<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
	<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
	<head>
		<meta charset="utf-8" />
		<title>Duck DNS</title>
		<meta name="viewport" content="initial-scale=1.0" />
		<meta name="description" content="Duck DNS free dynamic DNS hosted on Amazon VPC" />
		<meta name="keywords" content="DDNS,free,Dynamic DNS" />
		<meta name="author" content="" />
		<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
		<module:includes/>
		
	</head>
	
	<body>
		<header id="ducky-head" class="ducky-head" role="banner">
			<module:header 
				section="index" 
				sessionEmail="${sessionEmailStr}"
				isLoggedIn="${isLoggedInStr}"
				state="${state}"
			/>
		</header>
		<main id="main" tabindex="0" role="main" class="ducky">
		    <section class="module panels">
		    	<module:accountinfo 
					section="index"
					sessionEmail="${sessionEmailStr}"
					isLoggedIn="${isLoggedInStr}"
					accountIcon="${accountIcon}"
					accountType="${accountType}"
					accountToken="${accountToken}"
					tokenGenerated="${tokenGenerated}"
					createdDate="${createdDate}"
				/>
				
				<module:feedback 
					isLoggedIn="${isLoggedInStr}"
					hasGoodFeedback="${hasGoodFeedbackStr}"
					hasBadFeedback="${hasBadFeedbackStr}"
					goodFeedback="${goodFeedback}"
					badFeedback="${badFeedback}"
				/>

<c:if test="${isLoggedInStr eq 'true'}">

				<div class="container outer-container">
					<div class="match-alignment white">
					
						<div class="col span-4">
		                    <div class="panel white domain-remaining">
		                    	<span class="h2">domains</span>
		                    	<span class="label label-${domainsLabel}">${numDomains}/${maxDomains}</span>
							</div>
						</div>
						<div class="col span-8">
							<div class="panel white domain-add">
								<div class="domain-wrapper">
									<form class="form-inline" action="domains" method="post">
										<div class="domain-holder">
											<span class="domain">http://</span>
											<input type="text" title="enter domain" name="addDomain" class="input-domain" placeholder="sub domain" autocomplete="off" maxlength="${Domain.MAX_DOMAIN_LENGTH}" min="0" max="${Domain.MAX_DOMAIN_LENGTH}"/>
											<span class="domain">${ourDomain}</span>
										</div>
										<div class="domain-holder">
											<button id="adddomain" title="add a domain" type="button" name="Add Domain" class="button-domain">add&nbsp;domain</button>
										</div>
									</form>
 								</div>
 							</div>
 						</div>
					
						<div class="col span-12 white">
							<div id="domainPanel" class="panel white table module">
								<table class="container__table cols-4" id="domainsTable">
									<colgroup>
										<col class="table__col-width" />
										<col class="table__col-width" />
										<col class="table__col-width" />
										<col class="table__col-width" />
										<col class="table__col-width" />
									</colgroup>
									<thead>
										<tr>
											<th class="theme-standard">domain</th>
											<th class="theme-standard">current ip</th>
											<th class="theme-standard">ipv6</th>
											<th class="theme-standard">changed</th>
											<th class="theme-standard"></th>
										</tr>
									</thead>
									<tbody>
<c:if test="${not empty listDomains}">
	<c:forEach items="${listDomains}" var="domain">
	
										<tr>
											<td class="h5 table__row-header ">
												<span class="h4">${domain.domainName}</span><span class="h4 domainPostfix">${ourDomain}</span>
											</td>
											<td class="h5">
												<form class="form-inline" action="domains" method="post">
													<div class="domain-holder">
														<input type="text" title="enter ip, or leave blank to have it auto detected" name="updateIp" class="input-ip" placeholder="ip address" value="${domain.currentIp}" autocomplete="off" maxlength="15" min="0" max="15"/>
														<input type="hidden" name="domainName" value="${domain.domainName}"/>
													</div>
													<div class="domain-holder">
														<button id="updateip" title="update ip" type="button" name="updateIpButton" class="button-update updateips">update ip</button>
													</div>
												</form>
											</td>
											<td class="h5">
												<form class="form-inline" action="domains" method="post">
													<div class="domain-holder">
														<input type="text" title="enter ip, or leave blank to have it auto detected" name="updateIpV6" class="input-ipv6" placeholder="ipv6 address" value="${domain.currentIpV6}" autocomplete="off" maxlength="39" min="0" max="39"/>
														<input type="hidden" name="domainName" value="${domain.domainName}"/>
													</div>
													<div class="domain-holder">
														<button id="updateipv6" title="update ipv6" type="button" name="updateIpV6Button" class="button-update updateips">update ipv6</button>
													</div>
												</form>
											</td>
											<td class="h5">${domain.lastUpdated}</td>
											<td class="h5">
												<form action="domains" method="post" class="form-table deletedomains">
													<div class="domain-holder">
														<button type="submit" title="delete domain" name="deleteDomain" class="button-delete" value="${domain.domainName}">delete domain</button>
													</div>
												</form>
											</td>
										</tr>
	
	</c:forEach>
</c:if>
									</tbody>
								</table>
							</div>
						</div>
		            </div>
		    	</div>
</c:if>
			</section>
		    
		</main>
		<footer>
			<module:footer
				sessionEmail="${sessionEmailStr}"
				isLoggedIn="${isLoggedInStr}"
			/>
		</footer>
		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
		<script src="js/ducky-11.js"></script>
<c:if test="${isProductionStr eq 'true' }">
		<script src="js/tracking.js"></script>
</c:if>
<script type="text/javascript">
	<!-- HACKY FACEBOOK LOGIN -->
	if (typeof String.prototype.startsWith != 'function') {
	  String.prototype.startsWith = function (str){
	    return this.slice(0, str.length) == str;
	  };
	}
	if (window.location.hash.startsWith("#access_token")) {
	 var newlocation = window.location.hash.slice(1);
	 window.location = "?"+newlocation;
	}
</script>

	</body>
</html>