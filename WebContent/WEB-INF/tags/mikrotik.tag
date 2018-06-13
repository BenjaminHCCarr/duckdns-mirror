<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'mikrotik'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="mikrotik">
						<h2>mikrotik</h2>
						recent forum posts <a target="_blank" style="color:#cccccc;text-decoration:underline;" href="https://forum.mikrotik.com/viewtopic.php?f=9&t=84140#">https://forum.mikrotik.com/viewtopic.php?f=9&t=84140#</a><br/><br/>
						
						these instructions are for <a target="_blank" style="color:#cccccc;text-decoration:underline;" href="http://www.mikrotik.com/">mikrotik routers</a><br/>

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

<br/>Newer update to the script<br/>

<pre>
:global actualIP value=[/ip address get [find where interface=MATRIX] value-name=address];
:global actualIP value=[:pick $actualIP -1 [:find $actualIP "/" -1] ];
:if ([:len [/file find where name=ipstore.txt]] < 1 ) do={
 /file print file=ipstore.txt where name=ipstore.txt;
 /delay delay-time=2;
 /file set ipstore.txt contents="0.0.0.0";
};
:global previousIP value=[/file get [find where name=ipstore.txt ] value-name=contents];
:if ($previousIP != $actualIP) do={
 :log info message=("Try to Update DuckDNS with actual IP ".$actualIP." -  Previous IP are ".$previousIP);
 /tool fetch mode=https keep-result=yes dst-path=duckdns-result.txt address=[:resolve www.duckdns.org] port=443 host=www.duckdns.org src-path=("/update?domains=${dynattrs.exampleSingleDomain}&token=${dynattrs.exampleToken}&ip=".$actualIP);
 /delay delay-time=5;
 :global lastChange value=[/file get [find where name=duckdns-result.txt ] value-name=contents];
 :global previousIP value=$actualIP;
 /file set ipstore.txt contents=$actualIP;
 :if ($lastChange = "OK") do={:log warning message=("DuckDNS update successfull with IP ".$actualIP);};
 :if ($lastChange = "KO") do={:log error message=("Fail to update DuckDNS with new IP ".$actualIP);};
};
</pre>

Older version of the script<br/>

<pre>
:global currentIP;
:local newIP [/ip address get [find interface="INTERFACENAMEHERE"] address];
:if ($newIP != $currentIP) do={
    :log info "IP address $currentIP changed to $newIP";
    :set currentIP $newIP;
    /tool fetch mode=https url="https://www.duckdns.org/update?domains=${dynattrs.exampleSingleDomain}&token=${dynattrs.exampleToken}&ip=$newIP" dst-path=duckdns.txt;
    :local result [/file get duckdns.txt contents];
    :log info "Duck DNS update result: $result";
}
</pre>
add permissions for: read, write, policy, test<br/>
<c:choose>

	<c:when test="${dynattrs.isLoggedIn != 'yes' or dynattrs.exampleSingleDomain == 'exampledomain'}">
		don't forget to change <b>interface name</b>, <b>domains</b> and <b>token</b> according to your configuration!<br/>
	</c:when>
	<c:otherwise>
		don't forget to change <b>interface name</b> according to your configuration!<br/>
	</c:otherwise>
</c:choose>
don't forget to set scheduler!<br/>
don't forget to enable IP Cloud (if you can't enable IP Cloud or are using an earlier version than RouterOS v6.14, use "newIP [/ip address get [find interface="ether1-gateway"];" instead of "newIP [/ip cloud get public-address];" in your script.<br/>
					</div>