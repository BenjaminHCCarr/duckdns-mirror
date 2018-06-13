<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'windows-csharp'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="windows-csharp">
						<h2>Windows C# - Visual Studio 2013</h2>
						
						XWolfOverride has produced a C# updater <a href="https://github.com/XWolfOverride/DuckDNS" target="_blank" style="color:#cccccc;text-decoration:underline;">https://github.com/XWolfOverride/DuckDNS</a><br/>
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