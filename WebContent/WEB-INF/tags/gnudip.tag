<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'gnudip'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="gnudip">
						<h2>GnuDIP.http</h2>
						these instructions are for <a target="new" style="color:#cccccc;text-decoration:underline;" href="http://gnudip2.sourceforge.net/gnudip-www/latest/gnudip/html/protocol.html">GnuDIP.http</a><br/>
						
						many provided ADSL routers have this protocol as an option, such as the Huawei HG533.<br/>

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


						on the <b>web frontend of the router</b> (usually <a target="new" style="color:#cccccc;text-decoration:underline;" href="http://192.168.1.1">http://192.168.1.1</a> with username and password - admin) go to the <b>Advanced Settings</b> and select <b>DDNS</b>.<br/>
						now complete the configuration form and submit the configuration.
<pre>
Service provider:Others
Host:${dynattrs.exampleSingleDomain}
User name:NA
Server address:duckdns.org/gnudip/
Protocol:GNUDip.http
WAN connection:nas_0_38
Domain:duckdns.org
Password:${dynattrs.exampleToken}
Server port:80
Service name:DuckDNS
</pre>

						now check that your IP, has updated in our domains screen.<br/>
						if this has not happened, then check you configuration (make sure you entered the correct host [your domain] and password [your token])<br/>

						<img data-src="img/gnudip-http.png" class="hidden-gnudip img-rounded" /><br/>

					</div>