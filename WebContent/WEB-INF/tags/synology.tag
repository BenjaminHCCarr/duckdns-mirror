<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'synology'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="synology">
						<h2>synology </h2>
						these instructions are for the synology dsm 6.1 setup<br/>

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
In the webpanel : go to control panel / external access /ddns tab<br/>
choose customize - add a new DDNS Provider<br/>
<br/>

<pre>
duckdns
http://www.duckdns.org/update?domains=__HOSTNAME__&token=__PASSWORD__&ip=__MYIP__
</pre>

here is what the section looks like in the web interface (make sure you follow the steps above)<br/> 
<img data-src="img/synology1.png" class="hidden-synology img-rounded" /><br/>

<br/>now complete the form with your details<br/>

<pre>
Enable : CHECKED
Service Provide : duckdns
Hostname : ${dynattrs.exampleSingleDomain}
Username/Email : none
Password/Key : ${dynattrs.exampleToken}
</pre>

<img data-src="img/synology2.png" class="hidden-synology img-rounded" /><br/>

<br/>you should be able to see the udpater in the web GUI<br/>
<img data-src="img/synology3.png" class="hidden-synology img-rounded" /><br/>

					</div>