<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'windows-powershell'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="windows-powershell">
					<h2>windows powershell</h2>
						these scripts are for <strong>Windows Powershell</strong><br/>

						<h3>Step 1 - Choose a Script</h3>
						
						Tested in Windows 8 - Powershell 4 - script by - Bryan Childs<br/>
						<a target="new" style="color:#cccccc;text-decoration:underline;" href="https://github.com/godeater/Enable-DuckDns">https://github.com/godeater/Enable-DuckDns</a>
						
						<h3>or</h3>
						
						Tested in Windows Vista - Powershell 2 - script by - Adam Taylor<br/>
						<a target="new" style="color:#cccccc;text-decoration:underline;" href="https://github.com/ataylor32/duckdns-powershell">https://github.com/ataylor32/duckdns-powershell</a>
						
					</div>