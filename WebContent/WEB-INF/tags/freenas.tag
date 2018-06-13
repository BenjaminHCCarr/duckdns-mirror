<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'freenas'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="freenas">
						<h2>freenas</h2>
						there is a good online guide at : <a href="https://forums.freenas.org/index.php?threads/how-to-install-duckdns-org-a-how-to-guide.24170" target="_blank" style="color:#cccccc;text-decoration:underline;">https://forums.freenas.org/index.php?threads/how-to-install-duckdns-org-a-how-to-guide.24170/</a><br/><br/>
						these instructions are for any installation of freenas<br/>
						

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

Login to your Freenas server GUI<br/>
Go to <b>System-&gt;Cron Jobs-&gt;Add New Cron Job</b><br/>
Set up the new cron job.<br/>
Set it run as 'nobody'<br/>
You can have it at 1 minute past the hour, every 12 hours (or less), every day of the week.<br/>
The command to run is
<pre>
/usr/local/bin/curl http://www.duckdns.org/update/${dynattrs.exampleSingleDomain}/${dynattrs.exampleToken}
</pre>
					</div>