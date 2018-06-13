<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'openwrt'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="openwrt">
						<h2>OpenWrt</h2>
						the first part of the instructions are for people who want an easier install, but will accept http<br/>
						if you want to use https, then you need to follow the further instructions<br/>
						the wiki at <a target="new" style="color:#cccccc;text-decoration:underline;" href="http://wiki.openwrt.org/doc/howto/ddns.client">http://wiki.openwrt.org/doc/howto/ddns.client</a> may be helpful if you have issues<br/>
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
						we install the <b>ddns</b> packages
<pre>
opkg update
opkg install ddns-scripts
</pre>
						then setup the <b>ddns-scripts</b>
<pre>
ddns-scripts
</pre>
						edit the config at <b>/etc/config/ddns</b><br/>

<pre>
config service "duckdns"
        option enabled          "1"
        option domain           "${dynattrs.exampleSingleDomain}.duckdns.org"
        option username         "${dynattrs.exampleSingleDomain}"
        option password         "${dynattrs.exampleToken}"
        option ip_source        "network"
        option ip_network       "wan"
        option force_interval   "72"
        option force_unit       "hours"
        option check_interval   "10"
        option check_unit       "minutes"
        #option ip_source       "interface"
        #option ip_interface    "eth0.1"
        #option ip_source       "web"
        #option ip_url          "http://ipv4.wtfismyip.com/text"
        option update_url       "http://www.duckdns.org/update?domains=[USERNAME]&token=[PASSWORD]&ip=[IP]"
        #option use_https       "1"
        #option cacert          "/etc/ssl/certs/cacert.pem"
</pre>
						now start it up
<pre>
sh
. /usr/lib/ddns/dynamic_dns_functions.sh # note the leading period
start_daemon_for_all_ddns_sections "wan"
exit
</pre>

						we can now test the script by running the command
<pre>
/usr/lib/ddns/dynamic_dns_updater.sh duckdns
</pre>

						if you want to use https - you will need to download Start SSL's ca bundle and install it<br/>
						first we install curl and download the PEM file
<pre>
opkg update
opkg install curl
mkdir -p /etc/ssl/certs
curl -k https://certs.secureserver.net/repository/sf_bundle-g2.crt >  /etc/ssl/certs/ca-bundle.pem
</pre>

						then you need to re-alter the config at <b>/etc/config/ddns</b> (uncomment these 2 lines)<br/>
 
<pre>
        option use_https       "1"
        option cacert          "/etc/ssl/certs/ca-bundle.pem"
</pre>
						refer to the wiki on debugging etc <a target="new" style="color:#cccccc;text-decoration:underline;" href="http://wiki.openwrt.org/doc/howto/ddns.client">http://wiki.openwrt.org/doc/howto/ddns.client</a>
					</div>