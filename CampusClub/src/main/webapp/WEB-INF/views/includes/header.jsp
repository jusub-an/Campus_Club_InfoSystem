<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    
	@import url('https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap');
:root { 
		font-family: 'Inter', sans-serif;
	}

	
	.navbar-custom {
		background-color: #ffffff !important;
		box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.06);
		border-bottom: 1px solid #e2e8f0; 
	}
	
	
	.navbar-brand {
		font-weight: 800;
color: #4f46e5 !important; 
		letter-spacing: 0.5px;
	}
	
	
	.login-user-text {
		color: #475569 !important;
		font-weight: 500;
	}

	
	.btn-login-action {
		font-weight: 600;
		border-radius: 0.75rem; 
		padding: 0.5rem 1.25rem;
transition: all 0.2s;
	}
	.btn-logout-custom {
		background-color: #dc3545; 
		color: #F5F5F5; 
		border-color: #fcd34d;
	}
	.btn-logout-custom:hover {
		background-color: #b02a37 ; 
		border-color: #fbbf24;
	}

	
	.btn-login-custom {
		background-color: #4f46e5; 
		color: #fff;
		border-color: #4f46e5;
box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
	}
	.btn-login-custom:hover {
		background-color: #4338ca;
		color: #fff;
		border-color: #4338ca;
	}
	
	
.category-img-button {
    
    position: relative;
overflow: hidden;
    border-radius: 0.75rem; 
    height: 120px;
    cursor: pointer;
    border: 3px solid transparent;
    transition: all 0.3s ease;
	}

.category-img-button:hover {
    box-shadow: 0 4px 10px rgba(79, 70, 229, 0.3);
}

.category-img-button img {
    width: 100%;
    height: 100%;
    object-fit: cover;
transition: transform 0.3s ease;
    filter: brightness(0.7); 
}

.category-img-button:hover img {
    transform: scale(1.05);
filter: brightness(0.8);
}

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
    background-color: rgba(0, 0, 0, 0.2); 
}

.category-img-button.active {
    border-color: #4f46e5 !important;
    box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.2);
}

.category-img-button.active .category-img-button-text {
    background-color: rgba(79, 70, 229, 0.6);
}

</style>

<nav class="navbar navbar-expand-lg navbar-light navbar-custom fixed-top">
	<div class="container">
		<a class="navbar-brand" href="${pageContext.request.contextPath}/">
			캠퍼스 동아리 정보시스템
		</a>
		
		<div class="ms-auto d-flex align-items-center">
	
		<c:choose>
    		
    		<c:when test="${not empty sessionScope.user_email or not empty loginUser}">
        		
        		<c:set var="displayName"
               		value="${not empty sessionScope.userName
              ? sessionScope.userName
                        : (not empty userName ? userName : loginUser)}" />

        		<span class="login-user-text me-3 d-none d-sm-inline">
            		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                 		viewBox="0 0 24 24" fill="none" stroke="currentColor"
     
             		stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                 		class="me-1 align-text-bottom">
                		<path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                		<circle cx="12" cy="7" r="4"></circle>
            		</svg>
          
   		<strong>${displayName}</strong>님
        		</span>

        		<a href="${pageContext.request.contextPath}/user/logout"
           			class="btn btn-login-action btn-logout-custom btn-sm">
            		로그아웃
        		</a>
    		</c:when>

    		
    		<c:otherwise>
        		<a href="${pageContext.request.contextPath}/user/login"
           			class="btn btn-login-action btn-login-custom btn-sm">
		     		로그인
        		</a>
    		</c:otherwise>
		</c:choose>

		</div>
	</div>
</nav>