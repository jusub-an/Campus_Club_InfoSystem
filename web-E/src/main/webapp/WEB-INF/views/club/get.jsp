<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>동아리 상세보기</title>
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
    회장 이메일: <input type="email" name="leader_email" value="${club.leader_email}" /><br><br>

    <input type="submit" value="수정" />
</form>

<a href="/club/list">목록으로 돌아가기</a>

</body>
</html>

