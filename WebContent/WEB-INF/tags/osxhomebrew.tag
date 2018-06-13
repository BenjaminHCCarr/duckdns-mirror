<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'osx-homebrew'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="osx-homebrew">
						<h2>osx homebrew</h2>
						open a new terminal, it will be in your home directory<br/>
<pre>
brew tap jzelinskie/duckdns
brew install duckdns
ln -sfv /usr/local/opt/duckdns/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.duckdns.plist
</pre>
						create a new text file at<br/>
<pre>
$HOME/.duckdns
</pre>

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

						paste these contents into the file<br/>
<pre>
DOMAIN="${dynattrs.exampleSingleDomain}"
TOKEN="${dynattrs.exampleToken}"
</pre>
						
					</div>