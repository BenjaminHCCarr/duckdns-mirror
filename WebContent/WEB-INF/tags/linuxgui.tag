<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'linux-gui'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="linux-gui">
						<h2>linux GUI</h2>
						
						the linux GUI version requires zenity, curl &amp; cron to be installed.<br/>
						install zenity, curl &amp; cron if it is not installed already.<br/>
						on debian based linux systems open a terminal and enter<br/>
						
<pre>
sudo apt-get install zenity cron curl
</pre>

						download the <a href="scripts/duck-setup-gui.sh" style="color:#cccccc;text-decoration:underline;">linux GUI version</a> to your users home folder<br/>
						to run the script open a terminal window and enter:<br/>

<pre>
chmod +x duck-setup-gui.sh
./duck-setup-gui.sh
</pre>	
<c:choose>
	<c:when test="${dynattrs.isLoggedIn == 'yes' and dynattrs.exampleSingleDomain == 'exampledomain'}">
						if you want the configuration for a domain you have, <strong>use the drop down box</strong> above to select the domain<br/>							
						enter your domain<br/>
						<img data-src="img/linux-gui-01.png" class="hidden-linux-gui img-rounded" /><br/>
						enter your token<br/>
						<img data-src="img/linux-gui-02.png" class="hidden-linux-gui img-rounded" /><br/>			
	</c:when>
	<c:when test="${dynattrs.isLoggedIn == 'yes' and dynattrs.exampleSingleDomain != 'exampledomain'}">
						enter your domain <strong>${dynattrs.exampleSingleDomain}</strong><br/>
						<img data-src="img/linux-gui-01.png" class="hidden-linux-gui img-rounded" /><br/>
						enter your token <strong>${dynattrs.exampleToken}</strong><br/>
						<img data-src="img/linux-gui-02.png" class="hidden-linux-gui img-rounded" /><br/>	
	</c:when>
	<c:otherwise>
						enter your domain<br/>
						<img data-src="img/linux-gui-01.png" class="hidden-linux-gui img-rounded" /><br/>
						enter your token<br/>
						<img data-src="img/linux-gui-02.png" class="hidden-linux-gui img-rounded" /><br/>
	</c:otherwise>
</c:choose>

						There will now be a log file and shell script (which you can test manually) installed at something like<br/>
<pre>
~/duckdns/duck.log
~/duckdns/duck.sh
</pre>
						The shell script will have been added to a cron that is called every 5 minutes as your user, you can view this with<br/>
<pre>
crontab -l
</pre>
					</div>