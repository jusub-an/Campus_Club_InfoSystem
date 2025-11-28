<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>동아리 상세보기 및 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  
    
    <style>
        body {
            background-color: #f8fafc;
        }
        

        /* 제목 보라색 + 굵게 */
        h2.page-title {
            font-weight: 800;
            margin-top: 40px;
            color: #4f46e5;
        }

        /* 카드 스타일 */
        .club-card {
            border-radius: 1rem;
            overflow: hidden;
        }

        /* 카드 헤더 보라색 */
        .club-card .card-header {
            background-color: #4f46e5 !important;
            border-bottom: none;
        }

        .club-card .card-header h5 {
            font-weight: 700;
        }

        /* 주요 버튼 보라색 */
        .btn-primary {
            background-color: #4f46e5 !important;
            border-color: #4f46e5 !important;
        }
        .btn-primary:hover,
        .btn-primary:focus {
            background-color: #4338ca !important;
            border-color: #4338ca !important;
        }

        /* 폼 요소 포커스 시 보라색 라인 */
        .form-control:focus,
        .form-select:focus {
            border-color: #4f46e5 !important;
            box-shadow: 0 0 0 0.15rem rgba(79, 70, 229, 0.25) !important;
        }

        /* 카테고리 라디오 영역 */
        .category-group {
            border: 1px solid #e5e7eb;
            border-radius: 0.75rem;
            padding: 0.75rem 1rem;
            background-color: #ffffff;
        }

        .category-group .form-check-label {
            cursor: pointer;
        }

        /* 카테고리 타이틀 */
        .category-label-title {
            font-weight: 600;
        }

        /* 반응형 간격 조정 */
        .category-group .col-md-4 {
            margin-bottom: 0.25rem;
        }

        /* 취소 버튼은 회색으로 유지 */
        .btn-secondary {
            background-color: #6b7280;
            border-color: #6b7280;
        }
        .btn-secondary:hover,
        .btn-secondary:focus {
            background-color: #4b5563;
            border-color: #4b5563;
        }
        
    </style>
</head>
<body>

<div class="container my-5">
	
	<%@include file="../includes/header.jsp" %>
	
    <div class="row">
        <div class="col-12">
            <h2 class="text-center mb-5 page-title">동아리 상세정보 및 수정</h2>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">
            <div class="card shadow-lg club-card">
                <div class="card-header text-white text-center">
                    <h5 class="mb-0">동아리 정보 수정: ${club.club_name}</h5>
                </div>
                <div class="card-body">
                    
                    <form action="/club/modify" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="club_id" value="${club.club_id}" />

                        <div class="mb-3">
                            <label for="club_name" class="form-label">이름</label>
                            <input type="text" class="form-control" id="club_name" name="club_name" value="${club.club_name}" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label d-block category-label-title">카테고리</label>
                            
                            <c:set var="categoriesStr" value="공연·예술|체육·레저|학술·전공|사회·봉사|문화·교류|창업·취업·자기계발|취미·창작|종교·인문|기타" />
                            <c:set var="emojisStr" value="🎭|⚽|💻|💬|🌏|💡|🕹️|🪩|🧑‍🤝‍🧑" />
                            
                            <c:set var="catNames" value="${fn:split(categoriesStr, '|')}" />
                            <c:set var="emoList" value="${fn:split(emojisStr, '|')}" />
                            
                            <div class="row g-2 category-group">
                                
                                <c:forEach var="catName" items="${catNames}" varStatus="status">
                                    
                                    <c:set var="emoji" value="${emoList[status.index]}" />
                                    
                                    <div class="col-md-4 col-sm-6">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="category" 
                                                id="reg_category${status.index + 1}" value="${catName}"
                                                <c:if test="${club.category == catName}">checked</c:if>>
                                            
                                            <label class="form-check-label" for="reg_category${status.index + 1}">
                                                ${emoji} ${catName} 
                                            </label>
                                        </div>
                                    </div>
                                </c:forEach>
                                
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="logo_file" class="form-label">로고 이미지 (현재: ${club.logo_url})</label>
                            <input type="file" class="form-control" id="logo_file" name="logo_file">
                        </div>
                        
                        <div class="mb-3">
                            <label for="description" class="form-label">한줄 설명</label>
                            <input type="text" class="form-control" id="description" name="description" value="${club.description}" required>
                        </div>
                        
                        <div class="mb-4">
                            <label for="introduction" class="form-label">소개글</label>
                            <textarea class="form-control" id="introduction" name="introduction" rows="4" required>${club.introduction}</textarea>
                        </div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-center">
                            <button type="submit" class="btn btn-primary btn-lg">수정하기</button>
                            <a href="../post/list?club_id=<c:out value="${club_id}"/>" class="btn btn-secondary btn-lg">취소</a>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
