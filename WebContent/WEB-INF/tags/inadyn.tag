<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'inadyn'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="inadyn">
						<h2>inadyn</h2>
						<a target="new" style="color:#cccccc;text-decoration:underline;" href="http://troglobit.com/inadyn.html">http://troglobit.com/inadyn.html</a> have a small open source client that is in most Linux package repos<br/> 
						the client uses the <a href="/install.jsp?tab=dyndns&domain=${dynattrs.exampleSingleDomain}" style="color:#cccccc;text-decoration:underline;">dyndns endpoint</a><br/><br/>
						

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
<h2>terminal example</h2>

						you can test the endpoint with the <b>indyn</b> command with
<pre>
inadyn --dyndns_server_name www.duckdns.org --username nouser --password ${dynattrs.exampleToken} --update_period 60000 --alias ${dynattrs.exampleSingleDomain} --verbose 5 --dyndns_server_url /nic/?
</pre>

<h2>ubuntu example</h2>
						this example is <a target="new" style="color:#cccccc;text-decoration:underline;" href="http://ubuntuforums.org/showthread.php?t=1758930">taken off</a> someone setting up inadyn in Ubuntu<br/><br/>
						
						install inadyn
<pre>
sudo apt-get install inadyn curl
</pre>
						
						create configuration file of inadyn (/etc/inadyn.conf)
<pre>
sudo gedit /etc/inadyn.conf
</pre>
						and save this content
<pre>
--dyndns_server_name www.duckdns.org
--username nouser
--password ${dynattrs.exampleToken}
--update_period 60000
--forced_update_period 320000
--alias ${dynattrs.exampleSingleDomain}
--verbose 0
--dyndns_server_url /nic/?
--syslog
--background
</pre>
						add inadyn to crontab
<pre>
export EDITOR=gedit && sudo crontab -e
</pre>

						edit the file to add the following line
<pre>
@reboot /usr/sbin/inadyn
</pre>
						reboot your PC<br/>
						wait 3 minutes<br/>
						check if inadyn is running
<pre>
ps -A | grep inadyn
</pre>
						check inadyn behaviour
<pre>
more /var/log/messages | grep INADYN
</pre>
						check if your domain name resolves
<pre>
nslookup ${dynattrs.exampleSingleDomain}.duckdns.org
</pre>				
						
						
					</div>