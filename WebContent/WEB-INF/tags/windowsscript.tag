<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${not empty dynattrs.tab and dynattrs.tab == 'windows-script'}">
		<c:set var="divstyle" value=" active" />
	</c:when>
	<c:otherwise>
		<c:set var="divstyle" value="" />
	</c:otherwise>
</c:choose>

					<div class="tab-pane${divstyle}" id="windows-script">
					<h2>windows script</h2>
						these instructions are for <strong>Windows 7</strong>, the vbs script should work in Vista, Windows 8 and even XP<br/>
						however you will have to work out the differences in the <strong>Task Scheduler</strong> between different versions of Windows.<br/>
						
						<h3>Step 1 - Choose your Domain</h3>
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

						<h3>Step 2 - Creating the script</h3>
						
						<strong>2.1</strong> Go to &apos;Start&apos; and select Computer (Windows XP select My Computer)<br/>
						<strong>2.2</strong> Go into C:\users\YOUR-USERNAME (Windows XP: C:\Documents and Settings\YOUR-USERNAME)<br/>
						<strong>2.3</strong> Right click in an empty spot and go to NEW > Text Document. Name the file Duckdns and open the file.<br/>
						<strong>2.4</strong> Highlight all of the green text below and RIGHT CLICK > COPY<br/>
<pre>
Call LogEntry()

Sub LogEntry()
	On Error Resume Next
	Dim objRequest
	Dim URL

	URL = "https://www.duckdns.org/update?domains=${dynattrs.exampleSingleDomain}&token=${dynattrs.exampleToken}&ip="

	Set objRequest = CreateObject("Microsoft.XMLHTTP")
	objRequest.open "GET", URL , false
	objRequest.Send
	Set objRequest = Nothing
End Sub
</pre>
						<strong>2.5</strong> Go back to the text document and select Paste. Save the document and close it.<br/>
						<strong>2.6</strong> Replace the .TXT at the end of the text document file with .VBS and press enter. Select Yes to the extension popup.<br/>
						<strong>NOTE:</strong> If you can&apos;t see the .TXT at the end of the file you will need to turn on &apos;File Name Extensions&apos;. This can be done by:<br/>
						<strong>Windows 8:</strong> Open an explorer window such as Computer or Documents folder by pressing CTRL + E key’s on your keyboard. Along the top bar there is an option called VIEW, select it and to the right hand side place a tick in the box that reads "File Name Extensions". Go back to your file and perform step 2.6.<br/> 
						<strong>Windows 7 / XP:</strong> Go to Start and select Computer (My Computer for XP) then along the top of the window find and select Tools > Folder Options and go to the View tab. Find and de-select the "Hide extensions for known file types". Click OK, go back to your file and perform step 2.6.<br/>

						<h3>Step 3 - Creating a Task</h3>
						
						This task is to automatically run the script file you have just created. Please follow the instructions based on your edition of Windows.<br/>
						<strong>Windows 7 and 8:</strong>
						To open Task Scheduler on Windows 8 and 8.1: Click on the Start menu (Windows 8.1) or press your Windows key on your keyboard. Start typing the words CONTROL PANEL and select Control Panel from the right hand side when the option appears.  Go in to Administrative Tools and open Task Scheduler.<br/> 
						To open Task Scheduler on Windows 7: Click Start and select Control Panel. Go in to Administrative Tools and open Task Scheduler.<br/>
						Select Create Task from the right column. Enter "DuckDns Updater" in the Name field then select the Triggers tab and click New.<br/>
						Set the Trigger to be Daily, starting at 12:00:01AM and tick the box to &apos;Repeat task every:&apos; and set it to 5 minutes. (Refer to image below). Click OK when done.<br/>

						<img data-src="img/win_3_tasks_trigger.png" class="hidden-windows-script img-rounded" /><br/>
						
						Next go to the Actions tab and select New. In the &apos;]Program/script&apos; field select the Browse button. In the new window that opened, click on ‘This PC’ on the left column and then go to C:\Users\YOUR-USERNAME and click once on the script you created before. Click OPEN on the bottom of the window then click OK and OK again on the Create Task window.<br/>
						
						<img data-src="img/win_4_tasks_action.png" class="hidden-windows-script img-rounded" /><br/>
						
						<strong>Windows XP:</strong><br/>
						Click Start, go to Control Panel and open &apos;Schedule Tasks&apos;. Select Add a new Task from the top of the window.<br/>
						Click Next on the new window that opens then select Browse when presented with the window shown below.<br/>
						
						<img data-src="img/win_1_browse.png" class="hidden-windows-script img-rounded" /><br/>
						
						Click on My Computer on the left column and go to C:\Documents and Settings\YOUR-USERNAME<br/>
						Click once on your script file and select Open from the bottom right.<br/>
						
						<img data-src="img/win_2_file.png" class="hidden-windows-script img-rounded" /><br/>
						
						On the next window select &apos;When I Log On&apos; and click Next. Leave the username and password boxes as they are and select Next, then Select Finish.</br>
						
					</div>