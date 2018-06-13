<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'zteh108n'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="zteh108n">
						<h2>zte h108n</h2>
						these instructions are for the <a target="new" style="color:#cccccc;text-decoration:underline;" href="http://wwwen.zte.com.cn/en/products/access/cpe/201405/t20140522_424137.html">zte h108n</a> router<br/>

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

<br/>
the zteh108n has a DDNS panel in the Applications section of the web interface.<br/>
the actual DDNS scheme it uses is not supported by us, however we can use it to make plain http(s) requests.<br/><br/>
you must add the ? at the end of the URL so that the extra text that is added by the router is ignored.<br/>
use the following URL (the pattern https://duckdns.org/update/exampledomain/yourtoken?)<br/>
you can add an additional ipaddress if you want to force a value (https://duckdns.org/update/exampledomain/yourtoken/ipaddress?)<br/>
<br/>

<pre>
Enable : Checked
Service Name : dyndns
Custom Server : www.duckdns.org
Custom URL : /update/${dynattrs.exampleSingleDomain}/${dynattrs.exampleToken}?
Hostname : ${dynattrs.exampleSingleDomain}
Provider : NA
Password : NA
</pre>

here is what the section looks like in the web interface (make sure you follow the steps above)<br/> 

<img data-src="img/zteh108n.png" class="hidden-zteh108n img-rounded" /><br/>


					</div>