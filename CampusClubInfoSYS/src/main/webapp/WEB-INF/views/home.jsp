<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>캠퍼스 동아리 정보시스템 - 홈페이지</title>
	<!-- Bootstrap 5.3.3 CSS CDN 유지 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" xintegrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<style>
		/* Inter 폰트 사용 (reference.html 디자인 반영) */
		@import url('https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap');
		body { 
			background-color: #f8fafc; /* Tailwind의 gray-50/100 느낌 */
			font-family: 'Inter', sans-serif;
		}

		/* 카테고리 버튼 커스텀 스타일 (인디고 색상으로 변경) */
		.category-btn {
			border-radius: 0.75rem; /* rounded-xl */
			font-weight: 500;
			transition: all 0.2s;
		}
		.category-btn.active {
			font-weight: 700;
			background-color: #4f46e5 !important; /* Tailwind indigo-600 */
			color: white !important;
			border-color: #4f46e5 !important;
			box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.06); /* shadow-md */
		}
		.category-btn:not(.active) {
			border-color: #e2e8f0; /* gray-200 */
			color: #4a5568; /* gray-600 */
		}
		.category-btn:not(.active):hover {
			background-color: #eff6ff; /* indigo-50 */
			border-color: #93c5fd; /* blue-300 */
		}

		.navbar-brand {
			font-weight: 800;
			color: #4f46e5 !important; /* indigo-600 */
			letter-spacing: 1px;
		}
		
		/* 검색/필터 카드 스타일 */
		.search-filter-card {
			border-radius: 1rem; /* rounded-xl */
			box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05); /* shadow-lg */
			border: none;
		}
		.search-filter-card .card-header {
			background-color: #f1f5f9; /* gray-100 */
			border-bottom: 1px solid #e2e8f0; /* gray-200 */
			border-top-left-radius: 1rem !important;
			border-top-right-radius: 1rem !important;
			padding: 1rem 1.5rem;
		}

		/* 검색 입력창 스타일 */
		.search-box .input-group-lg .form-control {
			border-top-left-radius: 0.75rem !important; /* rounded-lg */
			border-bottom-left-radius: 0.75rem !important;
			padding: 0.75rem 1.25rem;
			font-size: 1.1rem;
		}
		.search-box .input-group-lg .btn-dark {
			background-color: #4f46e5; /* indigo-600 */
			border-color: #4f46e5;
			font-weight: 600;
			border-top-right-radius: 0.75rem !important;
			border-bottom-right-radius: 0.75rem !important;
		}
		.search-box .input-group-lg .btn-dark:hover {
			background-color: #4338ca; /* indigo-700 */
			border-color: #4338ca;
		}

		/* 동아리 카드 이미지 비율 유지 */
		.club-card-img {
			width: 100%;
			height: 200px; /* 고정 높이 */
			object-fit: cover; /* 이미지가 카드 영역에 꽉 차도록 */
			border-top-left-radius: 0.75rem; /* rounded-t-lg */
			border-top-right-radius: 0.75rem;
		}
		.club-card {
			border-radius: 0.75rem; /* rounded-xl */
			transition: all 0.3s ease;
			border: 1px solid #e2e8f0; /* gray-200 */
		}
		.club-card:hover {
			transform: translateY(-3px);
			box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05) !important; /* reference.html의 hover 효과 */
		}

		.club-card .card-body {
			padding: 1.25rem;
		}
		.club-card .card-title {
			font-size: 1.3rem;
			font-weight: 800;
			color: #4f46e5; /* indigo-600 */
			margin-bottom: 0.3rem;
		}
		.club-card .card-text {
			font-size: 0.95rem;
			color: #6c757d;
			height: 3em; 
			overflow: hidden;
			text-overflow: ellipsis;
			display: -webkit-box;
			-webkit-line-clamp: 2;
			-webkit-box-orient: vertical;
		}
		.club-card .card-footer {
			font-size: 0.85rem;
			color: #495057;
			background-color: #f8fafc; /* gray-50 */
			border-top: 1px solid #e2e8f0;
			border-bottom-left-radius: 0.75rem !important;
			border-bottom-right-radius: 0.75rem !important;
		}
		.card-img-placeholder {
			width: 100%;
			height: 200px;
			background-color: #e2e8f0; /* gray-200 */
			color: #64748b; /* slate-500 */
			display: flex;
			justify-content: center;
			align-items: center;
			font-size: 1.1rem;
			font-weight: 600;
			border-top-left-radius: 0.75rem;
			border-top-right-radius: 0.75rem;
		}
		
		/* 결과 섹션 */
		.result-section h2 {
			color: #1e293b !important; /* slate-800 */
			border-bottom-color: #e2e8f0 !important;
		}
		
		/* 동아리 등록 버튼 */
		.admin-menu-section .btn-success {
			background-color: #10b981; /* emerald-500 */
			border-color: #10b981;
			font-weight: 700;
			border-radius: 0.75rem;
			padding: 0.75rem 2rem;
			transition: all 0.2s;
		}
		.admin-menu-section .btn-success:hover {
			background-color: #059669; /* emerald-600 */
			border-color: #059669;
		}
		
		/* footer 스타일링 */
		footer {
			background-color: #1e293b !important; /* slate-800 */
		}
	</style>
</head>
<body>
	<%@include file="includes/header.jsp" %>
	<div class="container my-5 pt-5">
		
		<div class="card search-filter-card mb-5">
			<div class="card-header border-bottom">
				<h5 class="fw-bold text-gray-700 mb-0 d-flex align-items-center">
					<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="me-2 text-indigo-500"><path d="M4 22h16"></path><path d="M10 12l2 2 4-4"></path><path d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20z"></path></svg>
					동아리 검색
				</h5>
			</div>
			
			<div class="card-body p-4 p-md-5">
				
				<div class="category-section mb-4">
		            
		            <form method="get" action="${pageContext.request.contextPath}/">
		                <input type="hidden" name="keyword" value="${empty keyword ? '' : keyword}">
		                
		                <%-- **[수정]** Controller에서 받은 categoryMap의 KeySet을 순회 --%>
		                <div class="row row-cols-2 row-cols-sm-3 row-cols-lg-5 g-3">							
		                    <c:forEach var="cat" items="${categoryMap.keySet()}">
		                        <div class="col">
		                            
		                            <button type="submit"
		                                    name="category"
		                                    value="${cat}"
		                                    class="category-img-button w-100 ${cat == selectedCategory ? 'active' : ''}">
		                                
		                                <%-- **[수정]** categoryMap[cat]으로 이미지 URL 조회 --%>
		                                <img src="<c:url value='${categoryMap[cat]}' />" 
		                                     alt="${cat} 카테고리 이미지" />
		                                
		                                <span class="category-img-button-text">
		                                    <span class="fs-6">${cat}</span>
		                                </span>
		                            </button>
		                            
		                        </div>
		                    </c:forEach>
		                </div>
		            </form>
		        </div>
				
				<div class="search-box">
					
					<form method="get" action="${pageContext.request.contextPath}/" class="input-group input-group-lg shadow-md">
						<input type="hidden" name="category" value="${selectedCategory}">
						
						<input type="text"
								name="keyword"
								class="form-control"
								placeholder="동아리 이름을 입력하세요"
								value="${empty keyword ? '' : keyword}">
						<button type="submit" class="btn btn-dark">
							<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="me-1"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
							검색
						</button>
					</form>
				</div>
				
			</div>
		</div>
		<div class="result-section">
			<h2 class="mb-4 pt-2 fw-bold">
				검색 결과
			</h2>
			
			<c:if test="${empty clubList}">
				<div class="alert alert-info py-4 shadow-sm border-0 rounded-xl" role="alert">
					<p class="mb-0 fw-bold d-flex align-items-center">
						<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="me-2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
						검색된 동아리가 없습니다. 다른 키워드나 카테고리를 시도해 보세요.
					</p>
				</div>
			</c:if>
			
			<c:if test="${!empty clubList}">
				<p class="text-muted mb-4">총 <strong>${clubList.size()}</strong>개의 동아리가 검색되었습니다.</p>
				<div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
					<c:forEach var="club" items="${clubList}">
						<div class="col">
							<div class="card club-card h-100 shadow-md">
								<a href="<c:url value='/post/list?club_id=${club.club_id}' />" class="text-decoration-none text-dark">
									<c:if test="${not empty club.logo_url}">
										<img src="<c:url value='${club.logo_url}' />" 
											alt="${club.club_name} 로고" class="club-card-img card-img-top" 
											onerror="this.onerror=null;this.src='https://placehold.co/400x200/e2e8f0/64748b?text=로고+없음';"
										/>
									</c:if>
									<c:if test="${empty club.logo_url}">
										<div class="card-img-placeholder">
											<span>로고 없음</span>
										</div>
									</c:if>
									<div class="card-body">
										<h5 class="card-title">${club.club_name}</h5>
										<p class="card-text">${club.description}</p>
									</div>
								</a>
								<div class="card-footer">
									<small class="text-muted d-flex align-items-center">
										<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="me-1 text-gray-400"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
										회장: ${club.leader_email}
									</small>
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
			                <div class="alert alert-secondary d-inline-block px-4 fw-bold border-0 rounded-xl shadow-sm" role="alert">
			                    이미 하나의 동아리를 등록하였습니다.
			                </div>
			                <p class="text-muted small mt-2">* 동아리는 계정당 1개만 등록할 수 있습니다.</p>
			            </c:when>
						
			            <c:when test="${fn:trim(sessionScope.user_type_code) eq 'MGR'}">
			                <a href="<c:url value='/club/register' />" class="btn btn-success btn-lg shadow-lg">
			                	<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="me-2"><path d="M12 5v14"></path><path d="M5 12h14"></path></svg>
			                	새 동아리 등록하기
			                </a>
			            </c:when>
				
			            <c:otherwise>
			                <div class="d-grid gap-2 col-md-4 mx-auto">
			                	<p class="text-muted small mt-2">* 새로운 동아리 등록은 운영자에게 문의해주세요.</p>
			                </div>
			            </c:otherwise>
			        </c:choose>
			    </c:if>
			</div>
		
		<footer class="text-white-50 py-4 mt-5">
		<div class="container d-flex flex-column flex-md-row justify-content-between align-items-center">
			<p class="mb-2 mb-md-0">&copy; 2025 Campus Club Information System</p>
			<p class="mb-0">현재 시간: ${serverTime}.</P>
		</div>
	</footer>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" xintegrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<script>
		// Lucide Icons 라이브러리를 사용하여 아이콘 렌더링을 시도합니다. (Bootstrap 환경에서는 작동하지 않을 수 있으나 디자인 요소로 유지)
		// 실제 JSP 환경에서는 HTML에 직접 SVG를 삽입하거나 Bootstrap Icons를 사용하는 것이 더 안정적일 수 있습니다.
		if (typeof lucide !== 'undefined') {
			lucide.createIcons();
		}
	</script>
</body>
</html>