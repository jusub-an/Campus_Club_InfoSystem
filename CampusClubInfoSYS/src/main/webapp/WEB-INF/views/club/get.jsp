<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>동아리 상세보기</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<h2>동아리 상세정보</h2>

<form action="/club/modify" method="post" enctype="multipart/form-data">
    <input type="hidden" name="club_id" value="${club.club_id}" />

    이름: <input type="text" name="club_name" value="${club.club_name}" /><br>
    카테고리: <br>
    <div style="padding-left: 10px;">
        <input type="radio" name="category" value="공연·예술" 
            <c:if test="${club.category == '공연·예술'}">checked</c:if>> 🎭 1. 공연·예술<br>
        <input type="radio" name="category" value="체육·레저"
            <c:if test="${club.category == '체육·레저'}">checked</c:if>> ⚽ 2. 체육·레저<br>
        <input type="radio" name="category" value="학술·전공"
            <c:if test="${club.category == '학술·전공'}">checked</c:if>> 💻 3. 학술·전공<br>
        <input type="radio" name="category" value="사회·봉사"
            <c:if test="${club.category == '사회·봉사'}">checked</c:if>> 💬 4. 사회·봉사<br>
        <input type="radio" name="category" value="문화·교류"
            <c:if test="${club.category == '문화·교류'}">checked</c:if>> 🌏 5. 문화·교류<br>
        <input type="radio" name="category" value="창업·취업·자기계발"
            <c:if test="${club.category == '창업·취업·자기계발'}">checked</c:if>> 💡 6. 창업·취업·자기계발<br>
        <input type="radio" name="category" value="취미·창작"
            <c:if test="${club.category == '취미·창작'}">checked</c:if>> 🕹️ 7. 취미·창작<br>
        <input type="radio" name="category" value="종교·인문"
            <c:if test="${club.category == '종교·인문'}">checked</c:if>> 🪩 8. 종교·인문<br>
        <input type="radio" name="category" value="기타"
            <c:if test="${club.category == '기타'}">checked</c:if>> 🧑‍🤝‍🧑 9. 기타<br>
    </div>
    <br>
    로고 이미지: <input type="file" name="logo_file" value="${club.logo_url}" /><br>
    한줄 설명: <input type="text" name="description" value="${club.description}" /><br>
    소개글: <textarea name="introduction" rows="4" cols="40">${club.introduction}</textarea><br>

    <input type="submit" value="수정" />
</form>

<a href="../post/list?club_id=<c:out value="${club_id}"/>">취소</a>

</body>
</html>

