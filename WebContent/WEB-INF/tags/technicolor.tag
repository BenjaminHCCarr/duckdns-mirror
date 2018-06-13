<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'technicolor'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="technicolor">
						<h2>technicolor TG582n</h2>
						these instructions are for the Technicolor TG582n other models may work with these instructions<br/>
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
						<br/>use telnet to connect to the router<br/>
<pre>
telnet 192.168.1.1
</pre>
						once logged in type the following commands and press enter after each line<br/>

<pre>
dyndns
service
modify
name = custom
[server] = www.duckdns.org
[port] = www-http   (leave as default)
[request] = /update/${dynattrs.exampleSingleDomain}/${dynattrs.exampleToken}
[updateinterval] = 10800  (in seconds - this 3 hours)
[retryinterval] = 30 (left as default)
[max_retry] = 3 (left as default)
saveall
</pre>

						now open the gui interface for the router in your web browser and go to the <b>dyndns</b> settings.<br/>
<pre>
user: NA
password: anything as long as its not blank
service: custom
host: www.duckdns.org
</pre>
						the routers dyndns settings page looks like the one below<br/>
						<img data-src="img/technicolor.png" class="hidden-technicolor img-rounded" /><br/>
					</div>