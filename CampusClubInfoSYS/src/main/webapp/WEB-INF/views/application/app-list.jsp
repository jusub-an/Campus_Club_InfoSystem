<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>동아리 관리: 가입신청자 및 회원 목록</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container my-5">

    <h2 class="mb-4 text-primary">동아리 관리 페이지</h2>

	<h3 class="mt-4 mb-3">가입신청자 목록</h3>
	<c:choose>
		<c:when test="${not empty a_list}">
			<table class="table table-striped table-bordered">
				<thead class="table-dark">
					<tr>
						<th>신청자 이메일</th>
						<th>지원글</th>
						<th>신청일</th>
						<th class="text-center">상태</th>
					</tr>
				</thead>
				<tbody class="table-group-divider">
					<c:forEach items="${a_list}" var="app">
						<tr>
							<td><c:out value="${app.applicant_email}" /></td>
							<td><c:out value="${app.applicant_text}" /></td>
							<td><fmt:formatDate pattern="yyyy-MM-dd" value="${app.applied_at}" /></td>
							<td class="text-center">
							    <div class="d-flex justify-content-center gap-2">
    							    <%-- 1. 승인(O) 폼: POST 요청으로 club_id를 전달 --%>
    							    <form action="/application/approve" method="post" class="d-inline">
    							        <input type="hidden" name="app_id" value="${app.app_id}">
    							        <input type="hidden" name="club_id" value="${app.club_id}">
    							        <input type="hidden" name="applicant_email" value="${app.applicant_email}">
    							        <button type="submit" class="btn btn-success btn-sm">승인 (O)</button>
    							    </form>
    							    
    							    <%-- 2. 거절(X) 폼: POST 요청으로 app_id를 전달 --%>
    							    <form action="/application/reject" method="post" class="d-inline">
    							        <input type="hidden" name="app_id" value="${app.app_id}">
    							        <input type="hidden" name="club_id" value="<c:out value="${club_id}"/>">
    							        <button type="submit" class="btn btn-danger btn-sm">거절 (X)</button>
    							    </form>
							    </div>
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
	
	<h3 class="mt-5 mb-3">회원 목록</h3> 
	<c:choose>
		<c:when test="${not empty m_list}">
			<table class="table table-striped table-bordered">
				<thead class="table-dark">
					<tr>
						<th>동아리 ID</th>
						<th>이메일</th>
						<th class="text-center">관리</th>
					</tr>
				</thead>
				<tbody class="table-group-divider">
					<c:forEach items="${m_list}" var="mem">
						<tr>
							<td><c:out value="${mem.club_id}" /></td>
							<td><c:out value="${mem.user_email}" /></td>
							<td class="text-center">
                                <form action="/application/expel" method="post" class="d-inline">
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>