<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>동아리 등록</title>
</head>
<body>
<h2>새 동아리 등록</h2>

<form action="/club/register" method="post">
    이름: <input type="text" name="club_name" required /><br>
    카테고리: <input type="text" name="category" /><br>
    로고 URL: <input type="text" name="logo_url" /><br>
    한줄 설명: <input type="text" name="description" /><br>
    소개글: <textarea name="introduction" rows="4" cols="40"></textarea><br>
    <input type="submit" value="등록" />
</form>

<a href="/club/list">목록으로 돌아가기</a>

</body>
</html>