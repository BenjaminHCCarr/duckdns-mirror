<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'edgerouter'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="edgerouter">
						<h2>EdgeRouter</h2>
						
						Instructions to setup on an EdgeRouter <a href="https://loganmarchione.com/2017/04/duckdns-on-edgerouter/" target="_blank" style="color:#cccccc;text-decoration:underline;">https://loganmarchione.com/2017/04/duckdns-on-edgerouter/</a><br/>
<c:choose>
	<c:when test="${dynattrs.isLoggedIn == 'yes' and dynattrs.exampleSingleDomain == 'exampledomain'}">
						if you want the configuration for a domain you have, <strong>use the drop down box</strong> above to select the domain<br/>							
	
	</c:when>
	<c:when test="${dynattrs.isLoggedIn == 'yes' and dynattrs.exampleSingleDomain != 'exampledomain'}">

<br/>				
<pre>use your domain : ${dynattrs.exampleSingleDomain}
use you token : ${dynattrs.exampleToken}
</pre>

	</c:when>
	<c:otherwise>
	</c:otherwise>
</c:choose>
					</div>