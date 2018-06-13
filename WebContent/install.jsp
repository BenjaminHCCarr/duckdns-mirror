<?xml version="1.0" encoding="UTF-8"?>
<%@ page contentType="text/html; charset=UTF-8" import="
java.util.ArrayList,
java.util.GregorianCalendar,
java.util.Calendar,
java.util.List,
java.util.Collections,
java.util.UUID,
org.duckdns.dao.model.Account,
org.duckdns.dao.model.Domain,
org.duckdns.util.ServletUtils,
org.duckdns.util.FormatHelper,
org.duckdns.util.EnvironmentUtils,
org.duckdns.util.SessionHelper,
org.apache.commons.lang.StringEscapeUtils" %>
<%@ taglib prefix="module" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
SessionHelper.restoreSessionIfNeeded(request);
String ourDomain = EnvironmentUtils.OUR_DOMAIN;

boolean isLoggedIn = false;
boolean hasAtLeastOneDomain = false;
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
			if (request.getSession().getAttribute("domains") != null) {
				Object oDomains = request.getSession().getAttribute("domains");
				if (oDomains instanceof List) {
					domains = (List<Domain>) oDomains;
					numDomains = domains.size();
					if (numDomains > 0) {
						hasAtLeastOneDomain = true;
						Collections.sort(domains);
					}
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
account.setCreatedDate("11/26/12 9:30 PM");
account.setEmail("test@test.com");
account.setLastUpdated("12/26/13 9:30 PM");
ourDomain = ".duckdns.org";
sessionEmail = "timothy@test.com";

hasAtLeastOneDomain = true;
domains = new ArrayList<Domain>();
Domain tmpDomain = new Domain();
numDomains = 2;
tmpDomain.setDomainName("easypeasy");
tmpDomain.setAccountToken("dsadsad-rewef-sxsfd-sdfds");
tmpDomain.setCurrentIp("134.23.57.87");
tmpDomain.setLastUpdated("11/26/13 9:30 PM");
domains.add(tmpDomain);
tmpDomain = new Domain();
tmpDomain.setDomainName("lemonsqueezy");
tmpDomain.setAccountToken("richard-is-a-noob-lol-cat");
tmpDomain.setCurrentIp("145.243.157.187");
tmpDomain.setLastUpdated("11/26/13 9:30 PM");
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

String exampleToken = "a7c4d0ad-114e-40ef-ba1d-d217904a50f2";

String exampleSingleDomain = "exampledomain";

if (isLoggedIn) {
	exampleToken = account.getAccountToken();
	if (numDomains > 0) {
		String chosenDomain = request.getParameter("domain");
		if (chosenDomain != null) {
			for (Domain domain : domains) {
				if (chosenDomain.equals(domain.getDomainName())) {
					exampleSingleDomain = StringEscapeUtils.escapeHtml(domain.getDomainName());
					break;
				}
			}
		}
		// Put the list of Domains (sorted) into PageContext
		List<Domain> listDomains = new ArrayList<Domain>(domains);
		Collections.sort(listDomains);
		pageContext.setAttribute("domains",domains);
	}
}
String tab = "linux-cron";
if (request.getParameter("tab") != null) {
	tab = request.getParameter("tab");
}
pageContext.setAttribute("tab",tab);
pageContext.setAttribute("exampleSingleDomain",exampleSingleDomain);
pageContext.setAttribute("exampleToken",exampleToken);
if (isLoggedIn) {
	pageContext.setAttribute("isLoggedIn","yes");
} else {
	pageContext.setAttribute("isLoggedIn","no");
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
String hasAtLeastOneDomainStr = "false";
if (hasAtLeastOneDomain) {
	hasAtLeastOneDomainStr = "true";
}

pageContext.setAttribute("ourDomain", ourDomain);
pageContext.setAttribute("isLoggedInStr", isLoggedInStr);
pageContext.setAttribute("sessionEmailStr", sessionEmail);
pageContext.setAttribute("accountIcon", accountIcon);
pageContext.setAttribute("isProductionStr", isProductionStr);
pageContext.setAttribute("state", UUID.randomUUID().toString().replaceAll("-", ""));

if (tab.equals("linux-gui")) pageContext.setAttribute("linuxguiTabClass", "active");
else if (tab.equals("linux-cron")) pageContext.setAttribute("linuxcronTabClass", "active");
else if (tab.equals("dotnet-core-script")) pageContext.setAttribute("linuxshellTabClass", "active");
else if (tab.equals("windows-gui")) pageContext.setAttribute("windowsguiTabClass", "active");
else if (tab.equals("windows-script")) pageContext.setAttribute("windowsscriptTabClass", "active");
else if (tab.equals("windows-powershell")) pageContext.setAttribute("windowspowershellTabClass", "active");
else if (tab.equals("osx")) pageContext.setAttribute("osxTabClass", "active");
else if (tab.equals("osx-homebrew")) pageContext.setAttribute("osxhomebrewTabClass", "active");
else if (tab.equals("pi")) pageContext.setAttribute("piTabClass", "active");
else if (tab.equals("raspbmc")) pageContext.setAttribute("raspbmcTabClass", "active");
else if (tab.equals("ec2")) pageContext.setAttribute("ec2TabClass", "active");
else if (tab.equals("openwrt")) pageContext.setAttribute("openwrtTabClass", "active");
else if (tab.equals("tomatousb")) pageContext.setAttribute("tomatousbTabClass", "active");
else if (tab.equals("mikrotik")) pageContext.setAttribute("mikrotikTabClass", "active");
else if (tab.equals("fritzbox")) pageContext.setAttribute("fritzboxTabClass", "active");
else if (tab.equals("android")) pageContext.setAttribute("androidTabClass", "active");
else if (tab.equals("pfsense")) pageContext.setAttribute("pfsenseTabClass", "active");
else if (tab.equals("gnudip")) pageContext.setAttribute("gnudipTabClass", "active");
else if (tab.equals("ddwrt")) pageContext.setAttribute("ddwrtTabClass", "active");
else if (tab.equals("allied-telesis")) pageContext.setAttribute("alliedtelesisTabClass", "active");
else if (tab.equals("technicolor")) pageContext.setAttribute("technicolorTabClass", "active");
else if (tab.equals("zteh108n")) pageContext.setAttribute("zteh108nTabClass", "active");
else if (tab.equals("dyndns")) pageContext.setAttribute("dyndnsTabClass", "active");
else if (tab.equals("inadyn")) pageContext.setAttribute("inadynTabClass", "active");
else if (tab.equals("dnsomatic")) pageContext.setAttribute("dnsomaticTabClass", "active");
else if (tab.equals("osx-ios-realdns")) pageContext.setAttribute("osxiosrealdnsTabClass", "active");
else if (tab.equals("freenas")) pageContext.setAttribute("freenasTabClass", "active");
else if (tab.equals("osx-ip-monitor")) pageContext.setAttribute("osxipmonitorTabClass", "active");
else if (tab.equals("hardware")) pageContext.setAttribute("hardwareTabClass", "active");
else if (tab.equals("windows-csharp")) pageContext.setAttribute("windowscsharpTabClass", "active");
else if (tab.equals("linux-bsd-cron")) pageContext.setAttribute("linuxbsdcronTabClass", "active");
else if (tab.equals("linux-netcat-cron")) pageContext.setAttribute("linuxnetcatcronTabClass", "active");
else if (tab.equals("edgerouter")) pageContext.setAttribute("edgerouterTabClass", "active");
else if (tab.equals("mono")) pageContext.setAttribute("monoTabClass", "active");
else if (tab.equals("smoothwall")) pageContext.setAttribute("smoothwallTabClass", "active");
else if (tab.equals("synology")) pageContext.setAttribute("synologyTabClass", "active");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
	<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
	<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
	<head>
		<meta charset="utf-8" />
		<title>Duck DNS - install</title>
		<meta name="viewport" content="initial-scale=1.0" />
		<meta name="description" content="installation instructions" />
		<meta name="keywords" content="install,client,linux,cron,shell,pi,raspian,raspbmc,openwrt,ec2,openwrt,tomatoUSB,mikrotik,fritzbox,android,pfSense,GnuDIP.http,ddwrt,dd-wrt,allied telesis,technicolor,zte,h108n,powershell,dyndns,inadyn,dnsomatic,realdns,freenas" />
		<meta name="author" content="" />
		
		<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
		<module:includes/>
	</head>
	
	<body>
		<header id="ducky-head" class="ducky-head" role="banner">
			<module:header 
				section="install" 
				sessionEmail="${sessionEmailStr}"
				isLoggedIn="${isLoggedInStr}"
				state="${state}"
			/>
		</header>
		
		<main id="main" tabindex="0" role="main" class="ducky">
		    <section class="module panels">
		    	<module:accountinfo 
					section="install"
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
		                <div class="col span-12 install-panel">
		                    <div class="panel white">

			<ul class="nav nav-tabs">
				Operating Systems<br/>
				<li id="nav-linux-cron" class="${linuxcronTabClass}"><a href="#linux-cron" data-toggle="tab">linux cron</a></li>
				<li id="nav-linux-bsd-cron" class="${linuxbsdcronTabClass}"><a href="#linux-bsd-cron" data-toggle="tab">linux bsd cron</a></li>
				<li id="nav-linux-netcat-cron" class="${linuxnetcatcronTabClass}"><a href="#linux-netcat-cron" data-toggle="tab">linux netcat cron</a></li>
				<li id="nav-linux-gui" class="${linuxguiTabClass}"><a href="#linux-gui" data-toggle="tab">linux GUI</a></li>
				<li id="nav-dotnet-core-script" class="${linuxshellTabClass}"><a href="#dotnet-core-script" data-toggle="tab">DotNet Core Script</a></li>
				<li id="nav-mono" class="${monoTabClass}"><a href="#mono" data-toggle="tab">mono</a></li>
				<li id="nav-windows-gui" class="${windowsguiTabClass}"><a href="#windows-gui" data-toggle="tab">windows-gui</a></li>
				<li id="nav-windows-script" class="${windowsscriptTabClass}"><a href="#windows-script" data-toggle="tab">windows-script</a></li>
				<li id="nav-windows-powershell" class="${windowspowershellTabClass}"><a href="#windows-powershell" data-toggle="tab">windows-powershell</a></li>
				<li id="nav-windows-csharp" class="${windowscsharpTabClass}"><a href="#windows-csharp" data-toggle="tab">windows-c#</a></li>
				
				<li id="nav-osx" class="${osxTabClass}"><a href="#osx" data-toggle="tab">osx</a></li>
				<li id="nav-osx-homebrew" class="${osxhomebrewTabClass}"><a href="#osx-homebrew" data-toggle="tab">osx-homebrew</a></li>
				<li id="nav-osx-ip-monitor" class="${osxipmonitorTabClass}"><a href="#osx-ip-monitor" data-toggle="tab">osx IP Monitor</a></li>
				<li id="nav-osx-ios-realdns" class="${osxiosrealdnsTabClass}"><a href="#osx-ios-realdns" data-toggle="tab">osx-ios RealDNS</a></li>
				<li id="nav-android" class="${androidTabClass}"><a href="#android" data-toggle="tab">android</a></li>
				<li id="nav-pi" class="${piTabClass}"><a href="#pi" data-toggle="tab">pi</a></li>
				<li id="nav-raspbmc" class="${raspbmcTabClass}"><a href="#raspbmc" data-toggle="tab">raspbmc</a></li>
				<li id="nav-ec2" class="${ec2TabClass}"><a href="#ec2" data-toggle="tab">ec2</a></li>
				
				<br/>
				Routers<br/>		
				<li id="nav-openwrt" class="${openwrtTabClass}"><a href="#openwrt" data-toggle="tab">openwrt</a></li>
				<li id="nav-tomatousb" class="${tomatousbTabClass}"><a href="#tomatousb" data-toggle="tab">tomatoUSB</a></li>
				<li id="nav-mikrotik" class="${mikrotikTabClass}"><a href="#mikrotik" data-toggle="tab">mikrotik</a></li>
				<li id="nav-fritzbox" class="${fritzboxTabClass}"><a href="#fritzbox" data-toggle="tab">fritzbox</a></li>
				<li id="nav-ddwrt" class="${ddwrtTabClass}"><a href="#ddwrt" data-toggle="tab">dd-wrt</a></li>
				<li id="nav-allied-telesis" class="${alliedtelesisTabClass}"><a href="#alliedtelesis" data-toggle="tab">allied telesis</a></li>
				<li id="nav-technicolor" class="${technicolorTabClass}"><a href="#technicolor" data-toggle="tab">technicolor tg582n</a></li>
				<li id="nav-zteh108n" class="${zteh108nTabClass}"><a href="#zteh108n" data-toggle="tab">zte h108n</a></li>
				<li id="nav-pfsense" class="${pfsenseTabClass}"><a href="#pfsense" data-toggle="tab">pfSense</a></li>
				<li id="nav-freenas" class="${freenasTabClass}"><a href="#freenas" data-toggle="tab">freenas</a></li>
				<li id="nav-edgerouter" class="${edgerouterTabClass}"><a href="#edgerouter" data-toggle="tab">EdgeRouter</a></li>
				<li id="nav-smoothwall" class="${smoothwallTabClass}"><a href="#smoothwall" data-toggle="tab">smoothwall</a></li>
				<li id="nav-synology" class="${synologyTabClass}"><a href="#synology" data-toggle="tab">synology</a></li>
				<li id="nav-hardware" class="${hardwareTabClass}"><a href="#hardware" data-toggle="tab">hardware</a></li>
				
				<br/>
				Standards<br/>
				<li id="nav-gnudip" class="${gnudipTabClass}"><a href="#gnudip" data-toggle="tab">GnuDIP.http</a></li>
				<li id="nav-dyndns" class="${dyndnsTabClass}"><a href="#dyndns" data-toggle="tab">DynDns</a></li>
				<li id="nav-inadyn" class="${inadynTabClass}"><a href="#inadyn" data-toggle="tab">inadyn</a></li>
				<li id="nav-dnsomatic" class="${dnsomaticTabClass}"><a href="#dnsomatic" data-toggle="tab">DNSOmatic</a></li>
				
				
			</ul>				
			<div class="ducky-unit">
<c:if test="${isLoggedInStr eq 'true' and not empty domains}">
				<div class="content">
					<h2>first step - choose a domain.</h2>
				</div>
				<div class="domain-wrapper" id="selectdomain">
					<form class="form-inline" action="/install.jsp" method="get">
						<div class="domain-holder">
							<span class="domain">http://</span>
							<input type="hidden" id="hiddenTabInput" name="tab" value="${tab}"/>
							<select id="install-selectdomain" title="select domain" name="domain" class="input-domain" placeholder="choose domain">
								<option value="">choose domain</option>
	<c:forEach var="domain" items="${domains}">
								<c:choose>
									<c:when test="${exampleSingleDomain eq domain.domainName}">
										<option value="${domain.domainName}" selected="selected">${domain.domainName}</option>
									</c:when>
									<c:otherwise>
										<option value="${domain.domainName}">${domain.domainName}</option>
									</c:otherwise>
								</c:choose>
	</c:forEach>						
							</select>
							<span class="domain">${ourDomain}</span>
						</div>
					</form>
				</div>
</c:if>

<c:if test="${isLoggedInStr eq 'false' or (isLoggedInStr eq 'true' and hasAtLeastOneDomainStr eq 'false') or (isLoggedInStr eq 'true' and !(exampleSingleDomain eq 'exampledomain'))}">
				<div class="tab-content" id="all-tabs">
				 
					<module:linuxcron tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:linuxgui tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:dotnetcorescript tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:windowsgui tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:windowsscript tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:windowspowershell tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:osx tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:osxhomebrew tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:osxipmonitor tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:osxiosrealdns tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:pi tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:raspbmc tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:ec2 tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:openwrt tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:tomatousb tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:mikrotik tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:fritzbox tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:zteh108n tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:freenas tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:hardware tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:android tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:pfsense tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:gnudip tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:ddwrt tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:alliedtelesis tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:technicolor tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:dyndns tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:inadyn tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:dnsomatic tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:windowscsharp tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:linuxbsdcron tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:edgerouter tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:mono tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:smoothwall tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:synology tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
					<module:linuxnetcatcron tab="${tab}" exampleSingleDomain="${exampleSingleDomain}" exampleToken="${exampleToken}" isLoggedIn="${isLoggedIn}"/>
				</div>
				
				<div class="tab-content">
					<br/>
					<h2>what now?</h2>
					Well you probably want to setup port forwarding on your router to make use of your new DDNS name<br/>
					we recommend <a target="new" style="color:#cccccc;text-decoration:underline;" href="http://portforward.com/">portforward.com</a> to learn all about this.
				</div>
</c:if> <!-- is not logged in - or is logged in and not default  --> 
				
				
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
		<script>
		$(document).ready(function() {
			$("img.hidden-${tab}").reveal("fadeIn", 1000);
		});
		</script>
<c:if test="${isProductionStr eq 'true'}">
		<script src="js/tracking.js"></script>
</c:if>
	</body>
</html>