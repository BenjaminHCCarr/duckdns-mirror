<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'smoothwall'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="smoothwall">
						<h2>smoothwall</h2>
						smoothwall has WGET to use by default - this script is for basic smooothwall installs<br/>

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


<pre>
#!/bin/sh
wget --no-check-certificate -O - -o ./duck-mydns.log "https://www.duckdns.org/update?domains=${dynattrs.exampleSingleDomain}&token=${dynattrs.exampleToken}&ip="
</pre>

<c:choose>
	<c:when test="${dynattrs.isLoggedIn != 'yes' or dynattrs.exampleSingleDomain == 'exampledomain'}">
		don't forget to change <b>domains</b> and <b>token</b> according to your configuration!<br/>
	</c:when>
</c:choose>

					</div>