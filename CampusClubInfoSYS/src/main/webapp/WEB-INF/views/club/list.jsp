<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>동아리 목록</title>
</head>
<body>
<h2>동아리 목록</h2>

<a href="/club/register">새 동아리 등록</a>
<br><br>

<table border="1">
    <tr>
        <th>로고</th>
        <th>이름</th>
        <th>카테고리</th>
        <th>회장 이메일</th>
        <th>관리</th>
    </tr>

    <c:forEach var="club" items="${list}">
        <tr>
            <td>
                <c:if test="${not empty club.logo_url}">
                    <img src="<c:url value='${club.logo_url}' />" 
                         alt="${club.club_name} 로고" width="50" height="50" />
                </c:if>
                <c:if test="${empty club.logo_url}">
                    (이미지 없음)
                </c:if>
            </td>
            <td><a href="/post/list?club_id=${club.club_id}">${club.club_name}</a></td>
            <td>${club.category}</td>
            <td>${club.leader_email}</td>
            <td>
                <form action="/club/remove" method="post">
                    <input type="hidden" name="club_id" value="${club.club_id}" />
                    <input type="submit" value="삭제" />
                </form>
            </td>
        </tr>
    </c:forEach>
</table>

</body>
</html>