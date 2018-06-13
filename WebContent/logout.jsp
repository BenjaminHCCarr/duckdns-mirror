<%@ page contentType="text/html; charset=UTF-8" import="
org.duckdns.dao.AmazonDynamoDBDAO,
org.duckdns.util.EnvironmentUtils,
org.duckdns.util.GoogleAnalyticsHelper,
org.duckdns.util.ServletUtils" %><%
if (EnvironmentUtils.isDynamoSessionCache()) {
	AmazonDynamoDBDAO.getInstance().sessionsDeleteSession(request.getSession().getId(), ServletUtils.getAddressFromRequest(request));
}
GoogleAnalyticsHelper.RecordAsyncEvent(GoogleAnalyticsHelper.TMP_ID,GoogleAnalyticsHelper.CATEGORY_USER,GoogleAnalyticsHelper.ACTION_LOGOUT,"","");
session.invalidate();
String hostStr = ServletUtils.getHostNameFromRequest(request);
if (ServletUtils.isSecureFromRequest(request)) {
	response.sendRedirect("https://"+hostStr+"/index.jsp");
} else {
	response.sendRedirect("index.jsp");
}
%>