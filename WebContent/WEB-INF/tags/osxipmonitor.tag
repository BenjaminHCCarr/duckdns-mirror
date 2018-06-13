<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'osx-ip-monitor'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>
	
					<div class="tab-pane${divstyle}" id="osx-ip-monitor">
						<h2>IP Monitor for OS X</h2>
						<a target="new" style="color:#cccccc;text-decoration:underline;" href="https://appquarter.com/products-ip-monitor.html">IP Monitor</a> is an easy to use dynamic DNS update client for OS X.<br/>
						It supports DuckDNS and other dynamic DNS providers.<br/>
						IP Monitor v2.0 update introduced IPv6 support.<br/><br/>
						IP Monitor is available from <a target="new" style="color:#cccccc;text-decoration:underline;" href="https://itunes.apple.com/us/app/ip-monitor/id1050307950?mt=8">Apple Mac App Store</a> around the world. <br/>
					  <img data-src="img/ip-monitor-user-interface.png" class="hidden-osx-ip-monitor img-rounded"/><br/>
					  <img data-src="img/ip-monitor-service-record.png" class="hidden-osx-ip-monitor img-rounded"/><br/>
					</div>