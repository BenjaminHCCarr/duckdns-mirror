<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'windows-gui'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="windows-gui">
					<h2>windows gui</h2>
						this is an <a href="https://github.com/JozefJarosciak/DuckDNSClient" target="new" style="color:#cccccc;text-decoration:underline;">Open Source</a> tray based service that was created by <a href="https://plus.google.com/110084948024859637588/posts" target="new" style="color:#cccccc;text-decoration:underline;">Joe Jaro</a>.<br/>
						you can either use the EXE to install the software and it will deal with starting on login, or you can use the JAR file directly, but you will have to make it start-up when you want it to be running .
						
						<h3>Step 1 - download &amp; install the software from www.etx.ca</h3>
						
						download the software from <a href="http://www.etx.ca/products/windows-applications/duckdns-update-client/" target="new" style="color:#cccccc;text-decoration:underline;">http://www.etx.ca/</a><br/>
						install the client and start it, you should see a new Tray Icon appear (in Windows 7 you may need to make it always visible, by right clicking on your tray and changing the settings)<br/>
						
						<img data-src="img/duckdns_updater_settings1.png" class="hidden-windows-gui img-rounded" /><br/>
						
						<h3>Step 2 - configure the software for your chosen domain</h3>
						
						right click on the tray and choose <b>DuckDNS Settings</b> you should now see the settings screen<br/>	
<c:choose>
	<c:when test="${dynattrs.isLoggedIn == 'yes' and dynattrs.exampleSingleDomain == 'exampledomain'}">
					on this screen enter your <b>domain</b> and <b>token</b>, choose the domain you want <strong>using the drop down box</strong> above<br/>	
	</c:when>
	<c:when test="${dynattrs.isLoggedIn == 'yes' and dynattrs.exampleSingleDomain != 'exampledomain'}">
					on this screen enter your <b>domain</b>
<pre>
${dynattrs.exampleSingleDomain}
</pre>
					and <b>token</b>
<pre>
${dynattrs.exampleToken}
</pre>
	</c:when>
	<c:otherwise>
					on this screen you <strong>must</strong> change your <strong>token</strong> and <strong>domain</strong> to be the one you want to update<br/>
	</c:otherwise>
</c:choose>

						then click <b>OK</b> to apply the new settings<br/>
						
						<img data-src="img/duckdns_updater_settings2.png" class="hidden-windows-gui img-rounded" /><br/>
						
						<h3>Step 3 - check it works</h3>
						
						you should now see the new tray icon, when you hover the mouse over it you will see some details of its current status.<br/>
						
						<img data-src="img/duckdns_updater_tray_icon.png" class="hidden-windows-gui img-rounded" /><br/>
						
					</div>