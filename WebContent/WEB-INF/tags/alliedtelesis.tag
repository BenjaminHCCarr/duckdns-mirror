<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'alliedtelesis'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="alliedtelesis">
						<h2>allied telesis</h2>
						these instructions are for <a target="new" style="color:#cccccc;text-decoration:underline;" href="http://www.alliedtelesis.co.uk/p-2011.html">allied telesis AT-AR450S</a><br/>

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

the AT-AR450S and some of the other models allow you to make plain http(s) requests.<br/>
use the following URL (the pattern https://duckdns.org/update/exampledomain/yourtoken)<br/>
you can add an additional ipaddress if you want to force a value (https://duckdns.org/update/exampledomain/yourtoken/ipaddress)<br/>
<br/> 
modify/create the file

<pre>
pppupipc.scp
</pre>

add these lines (to make the http request work for your domain)

<pre>
del file=ddnsipup.txt
load method=http destination=flash destfile=ddnsipup.txt fi=update/${dynattrs.exampleSingleDomain}/${dynattrs.exampleToken}  server=www.duckdns.org
</pre>

then enable the trigger on the <b>ppp up</b> event

<pre>
# TRIGGER Configuration
enable trigger
create trigger=1 interface=ppp1 event=up cp=ipcp script=pppupipc.scp
</pre>


					</div>