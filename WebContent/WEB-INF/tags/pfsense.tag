<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'pfsense'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="pfsense">
						<h2>pfSense</h2>
						these instructions are for <a target="new" style="color:#cccccc;text-decoration:underline;" href="http://www.pfsense.org/">pfSense open source firewall</a><br/>

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

						on the <b>web frontend</b> of pfSense go to the page where you setup <b>dyndns services</b> and select <b>custom service</b>.<br/>
						enter the following <b>Update Url</b>
<pre>
https://www.duckdns.org/update?domains=${dynattrs.exampleSingleDomain}&token=${dynattrs.exampleToken}&ip=%IP%
</pre>

<c:if test="${dynattrs.isLoggedIn == 'yes' and dynattrs.exampleSingleDomain == 'exampledomain'}">
					you <strong>must</strong> change your <strong>token</strong> and <strong>domain</strong> to be the one you want to update<br/><br/>
</c:if>

						
						change the <b>Result Match</b> to 
<pre>
OK
</pre>
						the <b>username</b> can be empty<br/>
						the <b>password</b> can be empty<br/>
						
						
						<img data-src="img/pfsense.png" class="hidden-pfsense img-rounded" /><br/>
					</div>