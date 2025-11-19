<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>캠퍼스 동아리 정보시스템 - 홈페이지</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<style>
		.category-btn.active {
			font-weight: bold;
			background-color: #0d6efd; /* btn-primary 색상 */
			color: white;
		}
		/* 카테고리 버튼의 hover 상태를 btn-primary처럼 보이게 함 */
		.category-btn:hover {
			opacity: 0.8;
		}
	</style>
</head>
<body>
<div class="container my-5">
	<h1 class="text-center mb-4 text-primary">
		<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-people-fill me-2" viewBox="0 0 16 16">
			<path d="M7 14s-1 0-1-1 1-4 5-4 5 3 5 4-1 1-1 1zm4-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6m-7 2H2a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1v-1a1 1 0 0 0-1-1zm-4-3a3 3 0 1 0 0-6 3 3 0 0 0 0 6"/>
		</svg>
		캠퍼스 동아리 정보시스템
	</h1>

	<div class="d-flex justify-content-end align-items-center mb-3">
		<c:choose>
			<%-- 1. loginUser가 null이 아닐 때 (로그인 상태) --%>
			<c:when test="${!empty loginUser}">
				<span class="me-3">
					<strong>${loginUser}</strong>님 환영합니다.
				</span>
				<a href="user/logout" class="btn btn-outline-danger btn-sm">
					로그아웃
				</a>
			</c:when>

			<%-- 2. loginUser가 null일 때 (로그아웃 상태) --%>
			<c:otherwise>
				<a href="user/login" class="btn btn-primary btn-sm">
					로그인
				</a>
			</c:otherwise>
		</c:choose>
	</div>

	<hr class="my-4">

	<div class="search-box mb-4">
		<%-- GET / (HomeController) 로 검색 요청 --%>
		<form method="get" action="${pageContext.request.contextPath}/" class="input-group">
			<input type="text"
					name="keyword"
					class="form-control"
					placeholder="동아리명을 입력하세요"
					value="${empty keyword ? '' : keyword}">
			<button type="submit" class="btn btn-dark">
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
					<path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0"/>
				</svg>
				검색
			</button>
		</form>
	</div>

	<div class="category-section mb-5 p-3 bg-light rounded shadow-sm">
		<div class="category-title mb-3">
			<h5 class="fw-bold text-secondary">카테고리별 보기</h5>
		</div>

		<%-- 카테고리 선택도 GET / 로 요청 보냄 --%>
		<form method="get" action="${pageContext.request.contextPath}/">
			<%-- 검색어를 유지한 상태에서 카테고리만 바꿀 수 있도록 hidden 값 유지 --%>
			<input type="hidden" name="keyword" value="${empty keyword ? '' : keyword}">

			<div class="d-flex flex-wrap gap-2">
				<c:forEach var="cat" items="${categories}">
					<button type="submit"
							name="category"
							value="${cat}"
							class="category-btn btn ${cat == selectedCategory ? 'btn-primary active' : 'btn-outline-secondary'}">
						${cat}
					</button>
				</c:forEach>
			</div>
		</form>
	</div>

	<div class="menu-area mb-5 text-end">
		<a href="club/list" class="btn btn-success">
			<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-list-columns-reverse me-1" viewBox="0 0 16 16">
				<path fill-rule="evenodd" d="M0 2a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1H1a1 1 0 0 1-1-1zm14 1a.5.5 0 0 0-.5-.5H1.5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h13a.5.5 0 0 0 .5-.5zm0 4a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1H1a1 1 0 0 1-1-1V8a1 1 0 0 1 1-1zm-1 2a.5.5 0 0 0-.5-.5H1.5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h13a.5.5 0 0 0 .5-.5zm-1 4a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1H1a1 1 0 0 1-1-1v-2a1 1 0 0 1 1-1zm-1 2a.5.5 0 0 0-.5-.5H1.5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h13a.5.5 0 0 0 .5-.5z"/>
			</svg>
			동아리 전체 목록 페이지로 이동
		</a>
	</div>

	<div class="result-section">
		<h2 class="mb-3 text-secondary">🔍 검색 결과</h2>

		<c:if test="${empty clubList}">
			<div class="alert alert-warning" role="alert">
				<p class="mb-0">검색된 동아리가 없습니다. 다른 키워드나 카테고리를 시도해 보세요.</p>
			</div>
		</c:if>

		<c:if test="${!empty clubList}">
			<div class="table-responsive">
				<table class="table table-striped table-hover table-bordered caption-top">
					<caption>총 ${clubList.size()}개의 동아리가 검색되었습니다.</caption>
					<thead class="table-dark">
						<tr>
							<th>번호</th>
							<th>동아리명</th>
							<th>카테고리</th>
							<th>소개</th>
							<th>대표자 이메일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="club" items="${clubList}">
							<tr>
								<td>${club.club_id}</td>
								<td><strong>${club.club_name}</strong></td>
								<td><span class="badge bg-info text-dark">${club.category}</span></td>
								<td>${club.description}</td>
								<td>${club.leader_email}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</c:if>
	</div>

	<hr class="mt-5">

	<p class="text-muted text-end"> 현재 시간: ${serverTime}. </P>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>