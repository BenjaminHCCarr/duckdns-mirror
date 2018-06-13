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
		<title>Duck DNS - privacy policy</title>
		<meta name="viewport" content="initial-scale=1.0" />
		<meta name="description" content="privacy policy" />
		<meta name="keywords" content="privacy, policy" />
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
Privacy Policy
<br/><br/>
</p>
<p>
1. Information that we collect, and why we collect it<br/>
When you register for the DuckDNS Dynamic Domain Name System service, we collect certain information from you to allow you to effectively use the service: Specifically, the IP address used to create your account, your email address, the issued access token for authorisation (required by DDNS updater scripts/applications that use the DuckDNS API), and your target IP address. 
This information can be personal information in that it may be possible to identify you based on this information alone, or in connection with other information. 
DuckDNS does not store any logs of user activity of the site.
<br/><br/>
This Website uses cookies to facilitate user login. For instance, when we use a cookie to identify
you, you do not have to login a password more than once, thereby saving time while on our
Website. You can choose to not accept cookies, but it may affect your ability to login to, or to
effectively use the Website.
<br/><br/>
Cookies are also used on our Website by third parties for analytics, specifically, GoogleAnalytics. 
</p>
<p>
2. Sharing / disclosing personal information<br/>
DuckDNS may share personal information with companies, organizations or individuals outside
of DuckDNS if we have a good-faith belief that access, use, preservation or disclosure of the
information is reasonably necessary or desirable to:
<ul>
  <li>meet any applicable law, regulation, legal process or enforceable governmental
request.</li>
  <li>enforce applicable Terms of Use, including investigation of potential violations.</li>
  <li>detect, prevent, or otherwise address abuse, security or technical issues.</li>
  <li>protect against harm to the rights, property or safety of DuckDNS, our users or the public as required or permitted by law</li>
</ul>
</p>
<p>
3. Access to personal information<br/>
Users of DuckDNS can request a copy of all personal information we have in our system by
sending an email request to admin@duckdns.org. Users can also
delete their DuckDNS account at any time through the “Account” page.
</p>
<p>
4. Security of personal information<br/>
DuckDNS protects personal information with security safeguards appropriate to the sensitivity of
the information. The DuckDNS service is run over https with a valid 256bit signed ssl certificate.
</p>
<p>
5. Privacy contact<br/>
Any privacy-related issues or concerns about DuckDNS, the site or our services can be directed
to admin@duckdns.org
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