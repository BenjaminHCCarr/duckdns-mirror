<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'osx-ios-realdns'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="osx-ios-realdns">
						<h2>RealDNS for iOS and OSX</h2>
						<a target="new" style="color:#cccccc;text-decoration:underline;" href="http://minglebit.com/products/realdns.php">RealDNS</a> is a client for iOS and <br/> <br/>
						
						they support DuckDNS, have a look on the <a target="new" style="color:#cccccc;text-decoration:underline;" href="https://itunes.apple.com/us/app/realdns/id907980233?mt=12&ign-mpt=uo%3D4">iTunes Store</a> 
						<br/>
						<img data-src="img/realdns_screenshot.png" class="hidden-osx-ios-realdns img-rounded" /><br/>
					</div>