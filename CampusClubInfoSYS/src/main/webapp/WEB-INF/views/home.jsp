<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>캠퍼스 동아리 정보시스템 - 홈페이지</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<style>
		/* 카테고리 버튼 커스텀 스타일 */
		.category-btn.active {
			font-weight: bold;
			background-color: #0d6efd !important; /* btn-primary 색상 */
			color: white !important;
			border-color: #0d6efd !important;
		}
		.navbar-brand {
			font-weight: 700;
		}
		/* 동아리 카드 이미지 비율 유지 */
		.club-card-img {
			width: 100%;
			height: 200px; /* 고정 높이 */
			object-fit: cover; /* 이미지가 카드 영역에 꽉 차도록 */
			border-bottom: 1px solid rgba(0,0,0,.125);
		}
		.club-card .card-body {
			padding: 1rem;
		}
		.club-card .card-title {
			font-size: 1.25rem;
			font-weight: bold;
			margin-bottom: 0.5rem;
		}
		.club-card .card-text {
			font-size: 0.9rem;
			color: #6c757d;
			height: 3em; /* 2줄까지만 표시하고 넘치면 ... */
			overflow: hidden;
			text-overflow: ellipsis;
			display: -webkit-box;
			-webkit-line-clamp: 2;
			-webkit-box-orient: vertical;
		}
		.club-card .card-footer {
			font-size: 0.85rem;
			color: #495057;
		}
		.card-img-placeholder {
			width: 100%;
			height: 200px;
			background-color: #f8f9fa;
			color: #adb5bd;
			display: flex;
			justify-content: center;
			align-items: center;
			font-size: 1rem;
			border-bottom: 1px solid rgba(0,0,0,.125);
		}
	</style>
</head>
<body>

	<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm fixed-top">
		<div class="container">
			<a class="navbar-brand" href="${pageContext.request.contextPath}/">
				캠퍼스 동아리 정보시스템
			</a>
			
			<div class="ms-auto d-flex align-items-center">
		
				<c:choose>
					<%-- 1. 로그인 상태 --%>
					<c:when test="${!empty loginUser}">
						<span class="text-white me-3 d-none d-sm-inline">
							<strong>${loginUser}</strong>님
						</span>
						<a href="user/logout" class="btn btn-warning btn-sm">
							로그아웃
						</a>
					</c:when>
					
					<%-- 2. 로그아웃 상태 --%>
					<c:otherwise>
						<a href="user/login" class="btn btn-light btn-sm">
							로그인
						</a>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</nav>
	<div class="container my-5 pt-5">
		<header class="py-4 text-center">
			<h1 class="display-5 fw-bold text-dark">
				우리 학교 동아리 찾기
			</h1>
			<p class="lead text-muted">카테고리와 검색으로 원하는 동아리를 찾아보세요.</p>
		</header>
	
		<hr class="my-4">
		
		<div class="card shadow-lg mb-5 border-0">
			<div class="card-header bg-light border-bottom border-secondary-subtle">
				<h5 class="fw-bold text-secondary mb-0">동아리 검색 및 필터</h5>
			</div>
			
			<div class="card-body">
				
				<div class="category-section mb-4">
					<h6 class="fw-bold mb-3 text-dark">카테고리별 보기</h6>
					
					<form method="get" action="${pageContext.request.contextPath}/">
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
				
				<hr class="my-4">
				
				<div class="search-box">
					<h6 class="fw-bold mb-3 text-dark">동아리 이름 검색</h6>
					
					<form method="get" action="${pageContext.request.contextPath}/" class="input-group input-group-lg">
						<input type="hidden" name="category" value="${selectedCategory}">
						
						<input type="text"
								name="keyword"
								class="form-control"
								placeholder="동아리명, 키워드를 입력하세요"
								value="${empty keyword ? '' : keyword}">
						<button type="submit" class="btn btn-dark">
							검색
						</button>
					</form>
				</div>
				
			</div>
		</div>
		<div class="result-section">
			<h2 class="mb-3 text-secondary border-bottom pb-2">
				검색 결과
			</h2>
			
			<c:if test="${empty clubList}">
				<div class="alert alert-info py-3 shadow-sm" role="alert">
					<p class="mb-0 fw-bold">검색된 동아리가 없습니다. 다른 키워드나 카테고리를 시도해 보세요.</p>
				</div>
			</c:if>
			
			<c:if test="${!empty clubList}">
				<p class="text-muted mb-3">총 <strong>${clubList.size()}</strong>개의 동아리가 검색되었습니다.</p>
				<div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
					<c:forEach var="club" items="${clubList}">
						<div class="col">
							<div class="card club-card h-100 shadow-sm border-0">
								<a href="/post/list?club_id=${club.club_id}" class="text-decoration-none text-dark">
									<c:if test="${not empty club.logo_url}">
										<img src="<c:url value='${club.logo_url}' />" 
											alt="${club.club_name} 로고" class="club-card-img card-img-top" />
									</c:if>
									<c:if test="${empty club.logo_url}">
										<div class="card-img-placeholder">
											<span>로고 없음</span>
										</div>
									</c:if>
									<div class="card-body">
										<h5 class="card-title text-primary">${club.club_name}</h5>
										<p class="card-text">${club.description}</p>
									</div>
								</a>
								<div class="card-footer bg-light border-0">
									<small class="text-muted">회장: ${club.leader_email}</small>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:if>
		</div>
			<div class="admin-menu-section text-center my-5 p-4">
			   	<c:if test="${!empty loginUser}">
			        <c:choose>
						<c:when test="${userHasClub}">
			                <div class="alert alert-secondary d-inline-block px-4 fw-bold" role="alert">
			                    이미 하나의 동아리를 등록하였습니다.
			                </div>
			                <p class="text-muted small mt-2">* 동아리는 계정당 1개만 등록할 수 있습니다.</p>
			            </c:when>
						
			            <c:when test="${fn:trim(sessionScope.user_type_code) eq 'MGR'}">
			                <a href="/club/register" class="btn btn-success btn-lg shadow-sm">
			                	새 동아리 등록하기
			                </a>
			            </c:when>
				
			            <c:otherwise>
			                <div class="d-grid gap-2 col-md-4 mx-auto">
			                    <div class="alert alert-warning d-inline-block px-4 fw-bold" role="alert">
			                    	동아리 등록 권한이 없습니다. (운영자에게 문의)
			                	</div>
			                </div>
			            </c:otherwise>
			        </c:choose>
			    </c:if>
			</div>
		
		<footer class="bg-dark text-white-50 py-3 mt-5">
		<div class="container d-flex justify-content-between align-items-center">
			<p class="mb-0">&copy; 2025 Campus Club Information System</p>
			<p class="mb-0">현재 서버 시간: ${serverTime}.</P>
		</div>
	</footer>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>