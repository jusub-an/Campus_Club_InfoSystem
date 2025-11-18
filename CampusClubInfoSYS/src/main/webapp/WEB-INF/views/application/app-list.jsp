<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가입신청자 목록</title>
<!-- 간단한 스타일링을 위해 Bootstrap CDN 추가 -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container">
	<h3 class="mt-4 mb-4">가입신청자 목록</h3>
	<c:choose>
		<c:when test="${not empty a_list}">
			<table class="table table-striped table-bordered table-hover">
				<thead class="thead-dark">
					<tr>
						<th>신청자 이메일</th>
						<th>지원글</th>
						<th>신청일</th>
						<th>상태</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${a_list}" var="app">
						<tr>
							<td><c:out value="${app.applicant_email}" /></td>
							<td><c:out value="${app.applicant_text}" /></td>
							<td><fmt:formatDate pattern="yyyy-MM-dd" value="${app.applied_at}" /></td>
							<td>
							    <%-- 1. 승인(O) 폼: POST 요청으로 club_id를 전달 --%>
							    <form action="/application/approve" method="post" style="display:inline;">
							        <input type="hidden" name="app_id" value="${app.app_id}">
							        <input type="hidden" name="club_id" value="${app.club_id}">
							        <input type="hidden" name="applicant_email" value="${app.applicant_email}">
							        <button type="submit" class="btn btn-success btn-sm">O</button>
							    </form>
							    
							    <%-- 2. 거절(X) 폼: POST 요청으로 app_id를 전달 --%>
							    <form action="/application/reject" method="post" style="display:inline;">
							        <input type="hidden" name="app_id" value="${app.app_id}">
							        <input type="hidden" name="club_id" value="<c:out value="${club_id}"/>">
							        <button type="submit" class="btn btn-danger btn-sm">X</button>
							    </form>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:when>
		<c:otherwise>
			<div class="alert alert-info" role="alert">
				가입 신청이 없습니다.
			</div>
		</c:otherwise>
	</c:choose>
	<h3 class="mt-4 mb-4">회원 목록</h3>
	<c:choose>
		<c:when test="${not empty m_list}">
			<table class="table table-striped table-bordered table-hover">
				<thead class="thead-dark">
					<tr>
						<th>동아리 ID</th>
						<th>이메일</th>
						<th>관리</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${m_list}" var="mem">
						<tr>
							<td><c:out value="${mem.club_id}" /></td>
							<td><c:out value="${mem.user_email}" /></td>
							<td>
                                <form action="/application/expel" method="post" style="display:inline;">
                                    <input type="hidden" name="club_id" value="${mem.club_id}">
                                    <input type="hidden" name="user_email" value="${mem.user_email}">
                                    <input type="hidden" name="club_id" value="<c:out value="${club_id}"/>">
                                    <button type="submit" class="btn btn-warning btn-sm" 
                                            onclick="return confirm('${mem.user_email} 회원을 추방하시겠습니까?');">추방</button>
                                </form>
                            </td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:when>
		<c:otherwise>
			<div class="alert alert-info" role="alert">
				회원이 없습니다.
			</div>
		</c:otherwise>
	</c:choose>
</div>
</body>
</html>