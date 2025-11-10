<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>동아리 상세보기</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<h2>동아리 상세정보</h2>

<form action="/club/modify" method="post">
    <input type="hidden" name="club_id" value="${club.club_id}" />

    이름: <input type="text" name="club_name" value="${club.club_name}" /><br>
    카테고리: <input type="text" name="category" value="${club.category}" /><br>
    로고 URL: <input type="text" name="logo_url" value="${club.logo_url}" /><br>
    한줄 설명: <input type="text" name="description" value="${club.description}" /><br>
    소개글: <textarea name="introduction" rows="4" cols="40">${club.introduction}</textarea><br>

    <input type="submit" value="수정" />
</form>

<a href="../post/list?club_id=<c:out value="${club_id}"/>">취소</a>

</body>
</html>

