<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>
GnuDIP Update Server
</title>
<meta name="retc" content="${result}"><c:if test="${not empty addr}">
<meta name="addr" content="${addr}"></c:if>
</head>
<body>
<center>
<h2>
GnuDIP Update Server
</h2>
<c:choose>
<c:when test="${result eq '1'}">Failed update request for domain ${domain}</c:when>
<c:otherwise>Successful update request for domain ${domain}</c:otherwise>
</c:choose>
<br/>
${detailedMessage}
</center>
</body>
</html>