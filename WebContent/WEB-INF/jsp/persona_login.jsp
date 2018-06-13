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
String clrfToken = "";

if (request.getSession() != null) {
	sessionEmail = (String) request.getSession().getAttribute("email");
	clrfToken = (String) request.getSession().getAttribute("clrfToken");
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
pageContext.setAttribute("clrfToken", clrfToken);

if (isLoggedIn) {
	response.sendRedirect("/");
	return;
}

String isProductionStr = "false";
if (EnvironmentUtils.isProduction()) {
	isProductionStr = "true";
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

pageContext.setAttribute("ourDomain", ourDomain);
pageContext.setAttribute("goodFeedback", goodFeedback);
pageContext.setAttribute("badFeedback", badFeedback);
pageContext.setAttribute("hasGoodFeedbackStr", hasGoodFeedbackStr);
pageContext.setAttribute("hasBadFeedbackStr", hasBadFeedbackStr);

pageContext.setAttribute("isProductionStr", isProductionStr);

String isLoggedInStr = "false";
pageContext.setAttribute("isLoggedInStr", isLoggedInStr);
String accountIcon = "ducky_icon";
pageContext.setAttribute("accountIcon", accountIcon);
// TODO : move this into session so we can check against it
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


				<div class="container outer-container">
					<div class="match-alignment white">
					
						<div class="col span-6">
		                    <div class="panel white">
		                    	<span class="h2">Persona Login</span>
		                    	<br/>
		                    	<span>Persona is now discontinued, however we still allow you to login with your email address and account token.
		                    	<br/><br/>Please consider moving off Persona, by deleting your domains and re-adding them to another login.
		                    	<br/><br/>If you lose your token or forget your token, we have no-way of giving you access.</span>
							</div>
						</div>
						<div class="col span-6">
							<div class="panel white domain-add">
								<span class="h2">Login<br/><br/></span>
								
								<div class="domain-wrapper">
									
									<form class="form-inline" action="login-persona" method="post">
										<div class="domain-holder">
											<input type="hidden" name="action" value="login"/>
											<input type="hidden" name="clrf" value="${clrfToken}"/>
											<span class="email">email address</span>
											<input type="text" title="enter email address" name="email" class="input-email" placeholder="email" autocomplete="off" maxlength="100" min="0" max="100"/>
											<span class="email">(full email address)</span>
										</div>
										<div class="spacer"></div>
										<div class="domain-holder">
											<span class="token">account token</span>
											<input type="text" title="enter accout token" name="token" class="input-token" placeholder="token" autocomplete="off" maxlength="100" min="0" max="100"/>
											<span class="token">(full token)</span>
										</div>
										<div class="spacer"></div>
										<div class="domain-holder">
											<button id="loginPersona" title="login" type="submit" name="Login" class="button-login">login</button>
										</div>
									</form>
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