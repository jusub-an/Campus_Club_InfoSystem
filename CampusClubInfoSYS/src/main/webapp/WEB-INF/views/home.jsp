<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page session="false" %>
<html>
<head>
	<title>HomePage</title>
</head>
<body>
<h1>
	캠퍼스 동아리 정보시스템 
</h1>
<c:choose>
	<%-- 1. loginUser가 null이 아닐 때 (로그인 상태) --%>
	<c:when test="${!empty loginUser}">
		<p>
			<strong>${loginUser}</strong>님 환영합니다. 
		</p>
		<p>
			<a href="user/logout">
				<button>로그아웃</button>
			</a>
		</p>
	</c:when>
	
	<%-- 2. loginUser가 null일 때 (로그아웃 상태) --%>
	<c:otherwise>
		<p>
			<a href="user/login">
				<button>로그인 페이지</button>
			</a>
		</p>
	</c:otherwise>
</c:choose>
<p>
	<a href="club/list">
		<button>동아리 목록 페이지</button>
	</a>
</p>
<P>  현재 시간: ${serverTime}. </P>
</body>
</html>
