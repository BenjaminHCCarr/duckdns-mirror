<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'dotnet-core-script'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="dotnet-core-script">
						<h2>DotNet Core Script</h2>
						
						the DotNew Core Script should work on any system that can run DotNet: Windows, OSX, Linux systems<br/>
						
						the Project includes a full set of instructions <a href="https://github.com/PFCKrutonium/DuckDNS_Updater/" style="color:#cccccc;text-decoration:underline;">linux Shell version</a><br/>
<c:choose>
	<c:when test="${dynattrs.isLoggedIn == 'yes' and dynattrs.exampleSingleDomain == 'exampledomain'}">
						if you want the configuration for a domain you have, <strong>use the drop down box</strong> above to select the domain<br/>							
	
	</c:when>
	<c:when test="${dynattrs.isLoggedIn == 'yes' and dynattrs.exampleSingleDomain != 'exampledomain'}">

<br/>				
<pre>use your domain : ${dynattrs.exampleSingleDomain}
use you token : ${dynattrs.exampleToken}
</pre>

	</c:when>
	<c:otherwise>
	</c:otherwise>
</c:choose>
					</div>