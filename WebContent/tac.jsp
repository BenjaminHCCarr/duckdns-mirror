<?xml version="1.0" encoding="UTF-8"?>
<%@ page contentType="text/html; charset=UTF-8" import="
java.util.GregorianCalendar,
java.util.Calendar,
java.util.UUID,
org.duckdns.dao.model.Account,
org.duckdns.util.ServletUtils,
org.duckdns.util.FormatHelper,
org.duckdns.util.EnvironmentUtils,org.duckdns.util.SessionHelper" %>
<%@ taglib prefix="module" tagdir="/WEB-INF/tags" %>
<%
SessionHelper.restoreSessionIfNeeded(request);

boolean isLoggedIn = false;
String sessionEmail = "";
Account account = null;

if (request.getSession() != null) {
	sessionEmail = (String) request.getSession().getAttribute("email");
	if (sessionEmail != null && sessionEmail.length() > 0) {
		account = (Account) request.getSession().getAttribute("account");
		if (account != null) {
			isLoggedIn = true;
		}
	}
}

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
	pageContext.setAttribute("accountType", account.getAccountType());
	pageContext.setAttribute("accountToken", account.getAccountToken());
	pageContext.setAttribute("tokenGenerated", FormatHelper.convertShortDateToHumanReadableTimeAgo(account.getLastUpdated()));
	pageContext.setAttribute("createdDate", FormatHelper.toReadableDate(account.getCreatedDate()));
}

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
		<title>Duck DNS - terms of use</title>
		<meta name="viewport" content="initial-scale=1.0" />
		<meta name="description" content="terms of use" />
		<meta name="keywords" content="abuse, terms" />
		<meta name="author" content="" />

		<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
		<module:includes/>
	</head>
	
	<body>
		<header id="ducky-head" class="ducky-head" role="banner">
			<module:header 
				section="faqs" 
				sessionEmail="${sessionEmailStr}"
				isLoggedIn="${isLoggedInStr}"
				state="${state}"
			/>
		</header>
		<main id="main" tabindex="0" role="main" class="ducky">
		    <section class="module panels">
		    	<module:accountinfo 
					section="faqs"
					sessionEmail="${sessionEmailStr}"
					isLoggedIn="${isLoggedInStr}"
					accountIcon="${accountIcon}"
					accountType="${accountType}"
					accountToken="${accountToken}"
					tokenGenerated="${tokenGenerated}"
					createdDate="${createdDate}"
				/>
		        <div class="container">
		        	<div class="match-alignment white">
		                <div class="col span-12">
		                    <div class="panel white">
						  		<div class="ducky-unit">
<p class="text-bold">
Terms of Use
<br/><br/>
</p>
<p>
1. As a user of the DuckDNS Website, you agree to these terms and conditions (the
"Terms"). DuckDNS may change these Terms from time to time, so you should check
back periodically to ensure you are aware of any changes, as they will continue to apply
to you as a user of DuckDNS. If you violate these Terms, we may remove, delete, lock
and/or take over your DuckDNS account or DuckDNS domain.
</p>
<p>
2. By using this Website, or by using or creating an account with DuckDNS, you may
provide us with personal information as described in our Privacy Policy. You
acknowledge that you have read and understood our Privacy Policy, which governs the
collection, use, storage and disclosure of such personal information, and that you
consent to the collection, use, storage and disclosure of your personal information as
outlined in the Privacy Policy.
</p>
<p>
3. When registering for a DuckDNS user account, you agree to provide accurate and
complete information. You are responsible for the activity that occurs on your user
account, and you must keep your account password secure.
4. Users of the Website and DuckDNS service are responsible for any content hosted on
DuckDNS subdomains registered by such users, and agree to not use DuckDNS
services or a subdomain of a DuckDNS shared domain for any illegal or unlawful
purpose.
</p>
<p>
5. YOUR USE OF THIS WEBSITE IS ENTIRELY AT YOUR OWN RISK. DUCKDNS DOES
NOT WARRANT THAT THE WEBSITE WILL BE UNINTERRUPTED OR
ERROR-FREE, THAT DEFECTS WILL BE CORRECTED, OR THAT THIS WEBSITE
OR THE SERVER THAT MAKES IT AVAILABLE ARE FREE OF VIRUSES OR OTHER
HARMFUL COMPONENTS.
</p>
<p>
6. DUCKDNS, ITS EMPLOYEES, AGENTS, OFFICERS AND DIRECTORS WILL NOT BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, PUNITIVE, CONSEQUENTIAL,
SPECIAL, EXEMPLARY, OR OTHER DAMAGES RESULTING FROM ANY USE OF
THE WEBSITE OR DUCKDNS SERVICES.
</p>
<p>
7. By using this Website, you are confirming that you are either at least 19 years of age, or
that you have parental or guardian consent to agree to these Terms and to access and
use the Website.
</p>
<p>
8. These Terms will be governed by and construed in accordance with the laws of the
United Kingdom. You agree to submit to the personal and
exclusive jurisdiction of the courts located in the United Kingdom.
</p>
<p>
9. In addition to the laws of the United Kingdom, you also agree to
comply with all local laws that apply to your use of the Website
</p>
									<br/>
						  		</div>
							</div>
		                </div>
		            </div>
		    	</div>
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
	</body>
</html>