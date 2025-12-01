<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>새 동아리 등록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- 
    <script>
        function validateForm() {
            // 폼 요소들을 가져옵니다. 
            var form = document.forms[0];
            
            // 1. 이름 (club_name) 확인
            if (form.club_name.value.trim() === "") {
                alert("이름을 입력해 주세요.");
                form.club_name.focus();
                return false;
            }

            // 2. 카테고리 (category) 확인
            var categorySelected = false;
            var categoryRadios = form.category; // name="category"인 모든 radio 버튼 
            for (var i = 0; i < categoryRadios.length; i++) {
                if (categoryRadios[i].checked) {
                    categorySelected = true; 
                    break;
                }
            }
            if (!categorySelected) {
                alert("카테고리를 선택해 주세요."); 
                return false;
            }
            
            // 4. 한줄 설명 (description) 확인
            if (form.description.value.trim() === "") {
                alert("한줄 설명을 입력해 주세요."); 
                form.description.focus();
                return false;
            }

            // 5. 소개글 (introduction) 확인
            if (form.introduction.value.trim() === "") {
                alert("소개글을 입력해 주세요.");
                form.introduction.focus();
                return false;
            }
            
            // 모든 검사를 통과하면 true를 반환하여 폼이 제출됩니다. 
            return true;
        }
    </script>
 -->
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap');

        body {
            background-color: #f8fafc;
            font-family: 'Inter', sans-serif;
        }

        /* 페이지 제목 */
        .page-title {
            color: #4f46e5; /* indigo-600 */
            font-weight: 800;
        }

        /* 카드 스타일 */
        .register-card {
            border-radius: 1rem !important; /* rounded-xl */
            border: none !important;
            box-shadow:
                0 10px 15px -3px rgba(0, 0, 0, 0.1),
                0 4px 6px -2px rgba(0, 0, 0, 0.05) !important;
            background-color: #ffffff;
        }

        .register-card .card-header {
            background-color: #4f46e5 !important; /* indigo-600 */
            color: #ffffff;
            border-radius: 1rem 1rem 0 0 !important;
            border-bottom: 1px solid #4338ca;
        }

        .register-card .card-body {
            padding: 2rem 2.5rem;
        }

        /* primary 버튼을 인디고 톤으로 */
        .btn-primary {
            background-color: #4f46e5 !important;
            border-color: #4f46e5 !important;
            font-weight: 600;
            border-radius: 0.75rem;
            padding: 0.75rem 1.5rem;
        }

        .btn-primary:hover,
        .btn-primary:focus {
            background-color: #4338ca !important;
            border-color: #4338ca !important;
        }

        /* input, textarea 포커스 시 보라색 포커스 */
        .form-control:focus {
            border-color: #4f46e5 !important;
            box-shadow: 0 0 0 0.15rem rgba(79, 70, 229, 0.25) !important;
        }

        .form-control[type='file']:focus {
            border-color: #4f46e5 !important;
            box-shadow: 0 0 0 0.15rem rgba(79, 70, 229, 0.25) !important;
        }

        /* 카테고리 선택 영역 */
        .category-wrap {
            border-radius: 0.75rem;
            border: 1px solid #e2e8f0; /* gray-200 */
            background-color: #f8fafc; /* gray-50 */
        }

        .form-check-input:checked {
            background-color: #4f46e5 !important;
            border-color: #4f46e5 !important;
        }

        /* 하단 링크 색상을 indigo로 */
        .link-indigo {
            color: #4f46e5;
        }
        .link-indigo:hover {
            color: #4338ca;
        }
        .form-label {
    		font-weight: 600 !important;
    		color: #374151 !important;
		}
    </style>
</head>
<body>

    <%@include file="../includes/header.jsp" %>

    <div class="container my-5 pt-5">

        <div class="row">
            <div class="col-12">
                <h2 class="page-title text-center mb-5">
                    새 동아리 등록
                </h2> 
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10">
                <div class="card register-card">
                    <div class="card-header text-center">
                        <h5 class="mb-0">Club Registration</h5>
                    </div>
                    <div class="card-body">

                        <form action="/club/register" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
                            
                            <div class="mb-3">
                                <label for="club_name" class="form-label">동아리명</label>
                                <input type="text" class="form-control" id="club_name" name="club_name" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label d-block">카테고리</label>
                                
                                <c:set var="categoriesStr" value="공연·예술|체육·레저|학술·전공|사회·봉사|문화·교류|창업·취업·자기계발|취미·창작|종교·인문|기타" />
                                <c:set var="emojisStr" value="🎭|⚽|💻|💬|🌏|💡|🕹️|🪩|🧑‍🤝‍🧑" />
                                
                                <c:set var="catNames" value="${fn:split(categoriesStr, '|')}" />
                                <c:set var="emoList" value="${fn:split(emojisStr, '|')}" />
                                
                                <div class="row g-2 p-3 category-wrap">
                                    
                                    <c:forEach var="catName" items="${catNames}" varStatus="status">
                                        
                                        <c:set var="emoji" value="${emoList[status.index]}" />
                                        
                                        <div class="col-md-4 col-sm-6">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="category" 
                                                    id="reg_category${status.index + 1}" value="${catName}">
                                                
                                                <label class="form-check-label" for="reg_category${status.index + 1}">
                                                    ${emoji} ${catName}
                                                </label>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="logo_file" class="form-label">로고 이미지</label>
                                <input type="file" class="form-control" id="logo_file" name="logo_file" required>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">한줄 설명</label>
                                <input type="text" class="form-control" id="description" name="description" required>
                            </div>

                            <div class="mb-4">
                                <label for="introduction" class="form-label">소개글</label>
                                <textarea class="form-control" id="introduction" name="introduction" rows="4" required></textarea>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    등록하기
                                </button>
                            </div>
                            
                            <div class="text-center mt-3 small">
                                <a href="/club/list" class="text-decoration-none link-indigo">목록으로 돌아가기</a>
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
