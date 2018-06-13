<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'ddwrt'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="ddwrt">
						<h2>dd-wrt</h2>
						these instructions are for <a target="new" style="color:#cccccc;text-decoration:underline;" href="http://www.dd-wrt.com/">dd-wrt routers</a><br/>

<c:choose>
	<c:when test="${dynattrs.isLoggedIn == 'yes' and dynattrs.exampleSingleDomain == 'exampledomain'}">
					if you want the configuration for a domain you have, <strong>use the drop down box</strong> above to select the domain<br/>	
	</c:when>
	<c:when test="${dynattrs.isLoggedIn == 'yes' and dynattrs.exampleSingleDomain != 'exampledomain'}">
					The example below is for the domain <strong>${dynattrs.exampleSingleDomain}</strong><br/>
					if you want the configuration for a different domain, use the drop down box above<br/>
	</c:when>
	<c:otherwise>
		
	</c:otherwise>
</c:choose>


						on the <b>web frontend of the router</b> find the DDNS section in the Setup area.<br/>
						You can or <b>HTTP</b> or <b>HTTPS</b> for the URL
<pre>
DDNS Service:Custom
DYNSND Server:duckdns.org
Username:NA
Password:NA
Hostname:${dynattrs.exampleToken}
URL:http://www.duckdns.org/update?domains=${dynattrs.exampleSingleDomain}&token=
Additional DDNS Options:--verbose 5
Do no use External IP Check:Yes
Force Update Interval:10
</pre>
						<p/>
						now click <b>Save</b> and <b>Apply Settings</b> and see the logs get produced 

						<img data-src="img/ddwrt.png" class="hidden-ddwrt img-rounded" /><br/>

					</div>