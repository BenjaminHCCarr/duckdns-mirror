<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'dyndns'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="dyndns">
						<h2>DynDns</h2>
						we host a DynDns compatible endpoint <a target="new" style="color:#cccccc;text-decoration:underline;" href="https://help.dyn.com/remote-access-api/perform-update/">https://help.dyn.com/remote-access-api/perform-update/</a><br/> 
						any Client that can use this - should be-able to use this. e,g, <a href="/install.jsp?tab=inadyn&domain=${dynattrs.exampleSingleDomain}" style="color:#cccccc;text-decoration:underline;">inadyn</a><br/><br/>
						<b>Note</b> we support both the new v3 endpoint as well<br/><br/>
						

<c:choose>
	<c:when test="${dynattrs.isLoggedIn == 'yes' and dynattrs.exampleSingleDomain == 'exampledomain'}">
					if you want the configuration for a domain you have, <strong>use the drop down box</strong> above to select the domain<br/>	
	</c:when>
	<c:when test="${dynattrs.isLoggedIn == 'yes' and dynattrs.exampleSingleDomain != 'exampledomain'}">
					The example below is for the domain <strong>${dynattrs.exampleSingleDomain}</strong><br/>
					if you want the configuration for a different domain, use the drop down box above<br/>
	</c:when>
	<c:otherwise>
					you <strong>must</strong> change your <strong>token</strong> and <strong>domain</strong> to be the one you want to update<br/>
	</c:otherwise>
</c:choose>

						any client will be making requests with the following format (the IP is optional - if not present or empty it will be detected)<br/><br/>
<pre>
https://nouser:${dynattrs.exampleToken}@www.duckdns.org/nic/update?hostname=${dynattrs.exampleSingleDomain}&myip=1.1.1.1&wildcard=NOCHG&mx=NOCHG&backmx=NOCHG
</pre>

						v3 version
<pre>
http://nouser:${dynattrs.exampleToken}@www.duckdns.org/v3/update?hostname=${dynattrs.exampleSingleDomain}&myip=1.1.1.1
</pre>
						
						the responses from this service are <b>good, bad, nochg</b><br/>
						
					</div>