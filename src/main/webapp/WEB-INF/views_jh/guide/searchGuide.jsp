<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>병원 검색 가이드</title>
</head>
<body>
	<div align="center">
		<h1>병원 검색 가이드</h1>
		<br>
		<c:forEach var="var" begin="1" end="5" step="1" varStatus="stat">
			<font color="red" size="6px">${stat.count}.</font>
			<img src="/hospital/img/mainImg/partners-${stat.current}.jpg" alt="partners" style="width: 1000px;">
			<br><br><br>
		</c:forEach>
	</div>
</body>
</html>