<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'hardware'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="hardware">
						<h2>hardware</h2>
						If you fancy making an Arduino solution based on the ESP8266 core, then best of luck someone has done this!<br/><br/>
						<a target="new" style="color:#cccccc;text-decoration:underline;" href="http://davidegironi.blogspot.co.uk/">Davide Gironi</a> has created a Hardware board with <a target="new" style="color:#cccccc;text-decoration:underline;" href="https://github.com/davidegironi/espduckdns">custom firmware</a> to use DuckdDns and provide a web interface<br/><br/>
						The instructions are <a target="new" style="color:#cccccc;text-decoration:underline;" href="http://davidegironi.blogspot.co.uk/2017/02/duck-dns-esp8266-mini-wifi-client.html">covered in detail on his blog</a><br/><br/>  

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


The configuration you will need is
<pre>
domain : ${dynattrs.exampleSingleDomain}
token : ${dynattrs.exampleToken}
</pre>
					</div>