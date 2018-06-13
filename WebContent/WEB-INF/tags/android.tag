<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'android'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="android">
						<h2>android</h2>
						these instructions are for people wanting to use an Android based OS to keep their duckdns record up-to date<br/><br/>
						you could simply have an old android device - connected to your home network keeping your DuckDNS record up-to date, or you may run some service on your android device on a mobile network and want to reach it by a duckdns domain.<br/><br/>
						the client is provided by http://www.etx.ca/ and is download-able from the <a href="https://play.google.com/store/apps/details?id=com.duckdns.updater" target="new" style="color:#cccccc;text-decoration:underline;">Play Market</a> as you would expect.	
			
						<img data-src="img/android.png" class="hidden-android img-rounded" /><br/>	
						
					</div>