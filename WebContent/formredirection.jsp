<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<%@ page contentType="text/html; charset=UTF-8" import="
org.duckdns.util.EnvironmentUtils" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="module" tagdir="/WEB-INF/tags" %>
	<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
	<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
	<head>
		<meta charset="utf-8" />
		<title>Duck DNS - logging in...</title>
		<meta name="viewport" content="initial-scale=1.0" />
		<meta name="description" content="" />
		<meta name="keywords" content="" />
		<meta name="author" content="" />

		<module:includes/>
	</head>
	
	<body onload="document.forms['openid-form-redirection'].submit();">
		<main id="main" tabindex="0" role="main" class="ducky">
		    <section class="module panels">
		        <div class="container">
		        	<div class="match-alignment white">
		        		<div class="col span-12">
		        			<div class="panel white domain-add">
		        				<div class="panel center">
			        				<span class="h1">please stand by...</span>
									<form name="openid-form-redirection" action="${message.OPEndpoint}" class="form-inline" action="domains" method="post" accept-charset="utf-8">		
									<c:forEach var="parameter" items="${message.parameterMap}">
							        	<input type="hidden" name="${parameter.key}" value="${parameter.value}"/>
							        </c:forEach>
										<button id="adddomain" title="add a domain" type="submit" name="continue" class="button-continue">continue...</button>	
									</form>
	 							</div>
 							</div>
		                </div>
		            </div>
		    	</div>
		    </section>
		</main>
	</body>
</html>