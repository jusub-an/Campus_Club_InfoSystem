<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    /* Global Styles (Inter 폰트 사용) */
	@import url('https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap');
	:root { 
		font-family: 'Inter', sans-serif;
	}

	/* 네비게이션바 배경색 (흰색으로 변경 - reference.html 스타일 적용) */
	.navbar-custom {
		background-color: #ffffff !important; /* 흰색 배경 */
		box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.06); /* 옅은 그림자 유지 */
		border-bottom: 1px solid #e2e8f0; /* gray-200 느낌으로 하단에 얇은 구분선 추가 */
	}
	
	/* 브랜드 로고 스타일 (인디고 색상으로 변경) */
	.navbar-brand {
		font-weight: 800;
		color: #4f46e5 !important; /* Tailwind indigo-600 */
		letter-spacing: 0.5px;
	}
	
	/* 로그인 사용자 이름 스타일 (짙은 회색으로 변경) */
	.login-user-text {
		color: #475569 !important; /* slate-600 */
		font-weight: 500;
	}

	/* 버튼 스타일 (로그아웃 버튼) */
	.btn-login-action {
		font-weight: 600;
		border-radius: 0.75rem; /* rounded-xl */
		padding: 0.5rem 1.25rem;
		transition: all 0.2s;
	}
	.btn-logout-custom {
		background-color: #dc3545; /* amber-300 (주황색 계열 유지) */
		color: #F5F5F5; /* gray-800 */
		border-color: #fcd34d;
	}
	.btn-logout-custom:hover {
		background-color: #b02a37 ; /* amber-400 */
		border-color: #fbbf24;
	}

	/* 로그인 버튼 */
	.btn-login-custom {
		background-color: #4f46e5; /* indigo-600 */
		color: #fff;
		border-color: #4f46e5;
		box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
	}
	.btn-login-custom:hover {
		background-color: #4338ca; /* indigo-700 */
		color: #fff;
		border-color: #4338ca;
	}
	
	/* header.jsp의 <style> 블록에 추가 */
/* -------------------------------------- */

/* 이미지 위에 텍스트를 띄우는 카테고리 버튼 컨테이너 스타일 */
.category-img-button {
    /* 버튼처럼 보이지만 컨테이너 역할 */
    position: relative;
    overflow: hidden;
    border-radius: 0.75rem; /* rounded-lg */
    height: 120px; /* 고정 높이 설정 */
    cursor: pointer;
    border: 3px solid transparent;
    transition: all 0.3s ease;
}

.category-img-button:hover {
    box-shadow: 0 4px 10px rgba(79, 70, 229, 0.3); /* indigo shadow */
}

/* 배경 이미지 스타일 */
.category-img-button img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.3s ease;
    filter: brightness(0.7); /* 이미지를 어둡게 하여 텍스트가 잘 보이도록 */
}

/* 마우스 오버 시 이미지 확대 효과 */
.category-img-button:hover img {
    transform: scale(1.05);
    filter: brightness(0.8);
}

/* 이미지 위에 띄울 텍스트 스타일 */
.category-img-button-text {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    color: white;
    font-weight: 700;
    font-size: 1.1rem;
    padding: 0.5rem;
    text-align: center;
    background-color: rgba(0, 0, 0, 0.2); /* 텍스트 배경 오버레이 */
}

/* 선택된(Active) 상태 스타일 */
.category-img-button.active {
    border-color: #4f46e5 !important; /* Indigo-600 테두리 */
    box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.2); /* 링 효과 */
}

.category-img-button.active .category-img-button-text {
    background-color: rgba(79, 70, 229, 0.6); /* Active 시 배경 강조 */
}

</style>

<nav class="navbar navbar-expand-lg navbar-light navbar-custom fixed-top">
	<div class="container">
		<a class="navbar-brand" href="${pageContext.request.contextPath}/">
			캠퍼스 동아리 정보시스템
		</a>
		
		<div class="ms-auto d-flex align-items-center">
	
			<c:choose>
				<%-- 1. 로그인 상태 --%>
				<c:when test="${!empty loginUser}">
					<span class="login-user-text me-3 d-none d-sm-inline">
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="me-1 align-text-bottom"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
						<strong>${loginUser}</strong>님
					</span>
					<a href="user/logout" class="btn btn-login-action btn-logout-custom btn-sm">
						로그아웃
					</a>
				</c:when>
				
				<%-- 2. 로그아웃 상태 --%>
				<c:otherwise>
					<a href="user/login" class="btn btn-login-action btn-login-custom btn-sm">
						로그인
					</a>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</nav>