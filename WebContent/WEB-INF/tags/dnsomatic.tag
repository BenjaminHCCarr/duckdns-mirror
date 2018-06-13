<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'dnsomatic'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="dnsomatic">
						<h2>DNSOmatic</h2>
						<a target="new" style="color:#cccccc;text-decoration:underline;" href="https://dnsomatic.com/">dnsomatic.com</a> have DuckDNS as an option in their systems, they support a <a target="new" style="color:#cccccc;text-decoration:underline;" href="https://dnsomatic.com/wiki/supportedservices">variety of software and hardware</a><br/> <br/>
						
						have a look at the <a target="new" style="color:#cccccc;text-decoration:underline;" href="https://dnsomatic.com/wiki/">wiki</a> <a target="new" style="color:#cccccc;text-decoration:underline;" href="https://dnsomatic.com/wiki/software">software</a> and <a target="new" style="color:#cccccc;text-decoration:underline;" href="https://dnsomatic.com/wiki/hardware">hardware</a>
						
					</div>