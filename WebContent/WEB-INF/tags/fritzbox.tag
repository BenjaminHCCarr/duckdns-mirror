<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'fritzbox'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="fritzbox">
						<h2>fritzbox</h2>
						these instructions are for <a target="new" style="color:#cccccc;text-decoration:underline;" href="http://www.fritzbox.eu/en/index.php">fritzbox router</a><br/>

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

some firmwares (Fritz!Box 7170) don't support HTTPS and do not like the &ip=&lt;ipaddr&gt; part of the URL - use the alternative URL if the HTTPS one does not work<br/>

on the <b>web frontend</b> of your fritzbox go to the page where you setup <b>dyndns services</b> and select <b>custom service</b>.<br/>
						enter the following update Url
<pre>
https://www.duckdns.org/update?domains=${dynattrs.exampleSingleDomain}&token=${dynattrs.exampleToken}&ip=&lt;ipaddr&gt;&ipv6=&lt;ip6addr&gt;
</pre>
						the domain is your subdomain on DuckDNS.<br/>
						the password is your token.<br/>
						the username should be set to "none".<br/>
						<br/>
						use this <b>alternative url</b> (confirmed to work on Fritz!Box 7170) if your IP does not auto update
<pre>
http://www.duckdns.org/update?domains=${dynattrs.exampleSingleDomain}&token=${dynattrs.exampleToken}&ip=
</pre>
					</div>