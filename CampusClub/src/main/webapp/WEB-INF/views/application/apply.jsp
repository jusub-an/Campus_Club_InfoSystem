<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동아리 가입</title>
</head>
<body>
<h1>동아리 가입 신청</h1>

<%-- [추가] RedirectAttributes로 전달받은 에러 메시지 출력 --%>
<c:if test="${not empty error}">
    <p style="color: red;">${error}</p>
</c:if>

<form action="/application/apply" method="post">
이메일: <input type="email" name="applicant_email"> 
동아리코드: <input type="number" name="club_id">
<button type="submit">가입하기</button>
</form>
</body>
</html>