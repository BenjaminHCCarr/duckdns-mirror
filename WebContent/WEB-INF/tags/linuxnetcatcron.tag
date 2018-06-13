<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'linux-netcat-cron'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="linux-netcat-cron">
						<h2>linux netcat cron</h2>
						this netcat version is for systems that do not have wget or curl available<br/><br/>
						<b>THIS VERSION IS OVER HTTP : USE THIS ONLY IF YOU HAVE NO WAY TO USE A SECURE METHOD</b><br/><br/>
						if your linux install is running a crontab, then you can use a cron job to keep updated<br/>
						we can see this with
<pre>
ps -ef | grep cr[o]n
</pre>
					if this returns nothing - then go and read up how to install cron for your distribution of linux.<br/>
					also confirm that you have <b>curl</b> installed, test this by attempting to run curl
<pre>
curl
</pre>
					if this returns a command not found like error - then find out how to install curl for your distribution.</br>
					otherwise lets get started and make a directory to put your files in, move into it and make our main script
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
#!/bin/sh
TOKEN='${dynattrs.exampleToken}'
DOMAINS='${dynattrs.exampleSingleDomain}'
HOST="www.duckdns.org"
PORT="80"

# MAKE THE REQUEST PATTERN - remove the Verbose if you want to
URI=$(echo /update?domains=$DOMAINS\&token=$TOKEN\&ip=\&verbose=true)

# BUILD FULL HTTP REQUEST - note extra \ at the end to ignore editor and OS carraige returns
HTTP_QUERY="GET $URI HTTP/1.1\r\n\
Host: $HOST\r\n\
Accept: text/html\r\n\
Connection: close\r\n\
\r\n"

# OUTPUT TO SCREEN - Nice for Debug
echo "$HTTP_QUERY"
(printf "$HTTP_QUERY" && sleep 5) | nc $HOST $PORT
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
*/5 * * * * ~/duckdns/duck.sh >/dev/null 2>&1
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