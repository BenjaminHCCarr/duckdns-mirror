<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'ec2'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="ec2">
						<h2>ec2 (linux)</h2>
						on ec2 the current ip can be found using the command <strong>ec2-metadata --public-ipv4</strong><br/>
						this means that we only need to update your record when it does change<br/>
						because ec2 instances get assigned an ip on boot we need to force the ip in the curl command</br>
						so first lets login to your ubuntu ec2 instance over ssh as ubuntu user
<pre>
ssh -i &lt;YOUR PEM KEY&gt; user@ec2-00-00-00-00.us-west-2.compute.amazonaws.com
</pre>
						then lets make a directory to put your files in, move into it and make our main script
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
						hit <strong>ESC</strong> then use use arrow keys to move the cursor <strong>x</strong> deletes, <strong>i</strong> puts you back into insert mode
<pre>				
#!/bin/bash
current=""
while true; do
	latest=`ec2-metadata --public-ipv4`
	echo "public-ipv4=$latest"
	if [ "$current" == "$latest" ]
	then
		echo "ip not changed"
	else
		echo "ip has changed - updating"
		current=$latest
		echo url="https://www.duckdns.org/update?domains=${dynattrs.exampleSingleDomain}&token=${dynattrs.exampleToken}&ip=" | curl -k -o ~/duckdns/duck.log -K -
	fi
	sleep 5m
done
</pre>
						now save the file (in vi hit <strong>ESC</strong> then <strong>:wq!</strong> then <strong>ENTER</strong>)<br/>
						now make the duck.sh file executeable and then create the next script file
<pre>
chmod 700 duck.sh
vi duck_daemon.sh
</pre>
						now copy this text and put it into the file (in vi you hit the <strong>i</strong> key to insert, <strong>ESC</strong> then <strong>u</strong> to undo)
<pre>
#!/bin/bash
su - ubuntu -c "nohup ~/duckdns/duck.sh > ~/duckdns/duck.log 2>&1&"
</pre>
						now save the file (in vi hit <strong>ESC</strong> then <strong>:wq!</strong> then <strong>ENTER</strong>)<br/>
						now make the duck_daemon.sh file executeable and change its permissions
<pre>
chmod +x duck_daemon.sh
sudo chown root duck_daemon.sh
sudo chmod 744 duck_daemon.sh
</pre>
						to test this we must run it as root
<pre>
sudo ./duck_daemon.sh
</pre>
						this should simply return to a prompt<br/>
						we can see it is running with 
<pre>
ps -ef | grep duck
</pre>
						we can also see if the last attempt was successful (<strong>OK</strong> or bad <strong>KO</strong>)
<pre>
cat duck.log
</pre>
						if it is KO check your Token and Domain is correct in the <strong>duck.sh</strong> script<br/>
						finally we make the duck daemon auto start on boot up
<pre>
sudo ln -s ~/duckdns/duck_daemon.sh /etc/rc2.d/S10duckdns
</pre>
						as you can see the script is all set to start as the instance boots
<pre>
ls -la /etc/rc2.d/
</pre>
						the final test is to kill the process running and start it as the bootup would
<pre>
pkill duck
sudo /etc/rc2.d/S10duckdns
</pre>
						we can now see if its running
<pre>
ps -ef | grep duck
</pre>
					</div>