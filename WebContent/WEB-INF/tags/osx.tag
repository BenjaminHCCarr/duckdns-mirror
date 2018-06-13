<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'osx'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="osx">
					<h2>osx</h2>
						if you are not familiar with using the terminal on OSX consider using the JAR file (from the windows-gui) from <a href="http://www.etx.ca/products/windows-applications/duckdns-update-client/" target="new" style="color:#cccccc;text-decoration:underline;">http://www.etx.ca/</a><br/><br/> 
						
						osx (10.8 or older) by default does have cron installed,<br/>
						when you open the crontab, a new crontab will be setup for your user<br/>
						lets get started and make a directory to put your files in, move into it and make our main script<br/>
						these instructions are for the user <strong>administrator</strong> change the paths to match your user<br/>
						open a new terminal, it will be in your home directory<br/>
<pre>
mkdir duckdns
cd duckdns
vi duck.sh
</pre>
						now copy this text and put it into the file (in vi you hit the <strong>i</strong> key to insert, <strong>ESC</strong> then <strong>u</strong> to undo)	
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

						you can pass a comma separated (no spaces) list of domains<br/>
						you can if you need to hard code an IP (best not to - leave it blank and we detect your remote ip)<br/>
						hit <strong>ESC</strong> then use use arrow keys to move the cursor <strong>x</strong> deletes, <strong>i</strong> puts you back into insert mode
<pre>
echo url="https://www.duckdns.org/update?domains=${dynattrs.exampleSingleDomain}&token=${dynattrs.exampleToken}&ip=" | curl -k -o /Users/administrator/duckdns/duck.log -K -
</pre>
						now save the file (in vi hit <strong>ESC</strong> then <strong>:wq!</strong> then <strong>ENTER</strong>)<br/>
						this script will make a https request and log the output in the file duck.log<br/>
						now make the duck.sh file executeable
<pre>
chmod 700 duck.sh
</pre>
						next we will be using the cron process to make the script get run every 5 minutes
<pre>
crontab -e
</pre>
						copy this text and paste it at the bottom of the crontab
<pre>
*/5 * * * * /Users/administrator/duckdns/duck.sh >/dev/null 2>&1
</pre>
						now save the file (<strong>CTRL+o</strong> then <strong>CTRL+x</strong>)<br/>
						lets test the script 
<pre>
./duck.sh
</pre>
						this should simply return to a prompt<br/>
						we can also see if the last attempt was successful (<strong>OK</strong> or bad <strong>KO</strong>)
<pre>
cat duck.log
</pre>
						if it is KO check your Token and Domain are correct in the <strong>duck.sh</strong> script
					</div>