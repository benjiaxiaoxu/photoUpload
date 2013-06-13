<%@ page language="java"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    <title>show</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
    <table border="1">
    	<tr><td>序号</td>
    		<td>照片名称</td>
    		<td>时间</td>
    		<td>城市</td>
    		<td>省份</td>
    	</tr>
    	<c:forEach var="Photo" items="${list }" varStatus="p">
    		<tr><td>${p.index }</td>
    			<td>${Photo.filename }</td>
    			<td>${Photo.filedate }</td>
    			<td>${Photo.city }</td>
    			<td>${Photo.prov }</td>
    			<!--  <td><img src="http://www.baidu.com/img/baidu_jgylogo3.gif" width="117" height="38" border="0"></a></td>-->
    		</tr>
		</c:forEach>
    	
    </table>
  </body>
</html>
