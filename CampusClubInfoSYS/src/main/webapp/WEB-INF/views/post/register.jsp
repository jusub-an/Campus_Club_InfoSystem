<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 등록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
	<style>
		/* ==========================================
   		🔥 전체 디자인 보라색(Indigo) 톤 통일
  		 ========================================== */

		/* 페이지 제목 */
		h1.text-primary {
    		color: #4f46e5 !important;
    		margin-top: 70px; /* 원하는 만큼 조절 */
    		font-weight: 800;
		}

		/* 카드 전체 스타일 */
		.card {
    		border: none !important;
    		border-radius: 1rem !important;
    		box-shadow:
        		0 10px 15px -3px rgba(0, 0, 0, 0.10),
        		0 4px 6px -2px rgba(0, 0, 0, 0.05) !important;
		}

		/* 카드 헤더 보라색 */
		.card-header.bg-primary {
    		background-color: #4f46e5 !important;
    		border-radius: 1rem 1rem 0 0 !important;
		}

		/* 기본 primary 버튼 */
		.btn-primary {
    		background-color: #4f46e5 !important;
    		border-color: #4f46e5 !important;
		}
		
		.btn-primary:hover,
		.btn-primary:focus {
    		background-color: #4338ca !important;
    		border-color: #4338ca !important;
		}

		/* secondary 버튼색도 살짝 보라톤 */
		.btn-secondary {
    		background-color: #6b7280 !important;
    		border-color: #6b7280 !important;
		}
		.btn-secondary:hover {
    		background-color: #4b5563 !important;
		}

		/* nav pill 탭 기본 글색 = 보라 */
		.nav-pills .nav-link {
    		color: #4f46e5 !important;
    		border-radius: 8px;
    		font-weight: 600;
		}

		/* 활성 탭 = 보라 배경 + 흰 글씨 */
		.nav-pills .nav-link.active {
    		background-color: #4f46e5 !important;
    		color: #ffffff !important;
    		font-weight: 700;
		}

		/* hover 시 연보라 */
		.nav-pills .nav-link:hover {
    		background-color: rgba(79, 70, 229, 0.15) !important;
		}

		/* disabled 탭 */
		.nav-pills .disabled {
    		color: #9ca3af !important;
    		background-color: transparent !important;
    		cursor: not-allowed !important;
    		pointer-events: none;
		}

		/* input, textarea 포커스 시 보라 그림자 */
		.form-control:focus {
    		border-color: #4f46e5 !important;
    		box-shadow: 0 0 0 0.15rem rgba(79, 70, 229, 0.25) !important;
		}

		/* 파일 업로드 focus */
		.form-control[type='file']:focus {
    		border-color: #4f46e5 !important;
    		box-shadow: 0 0 0 0.15rem rgba(79, 70, 229, 0.25) !important;
		}

		/* 경고 모달 헤더 보라색 */
		.modal-header.bg-warning {
    		background-color: #4f46e5 !important;
    		color: #fff !important;
		}
	</style>

</head>
<body>

<%@include file="../includes/header.jsp" %>
<div class="container my-5">

    <div class="row">
        <div class="col-12">
            <h1 class="text-center mb-5 text-primary">게시글 등록</h1>
        </div>
    </div>
    
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-lg">
                <div class="card-header bg-primary text-white text-center">
                    <h5 class="mb-0">Post Register</h5>
                </div>
                <div class="card-body">
                    
                    <div class="mb-4">
                        <label class="form-label">게시판 선택</label>
                        <ul class="nav nav-pills card-header-pills">
                           
                            <c:if test="${sessionScope.user_email == clubInfo.leader_email}">
                                <li class="nav-item">
                                    <a class="nav-link active" href="#" data-role="allowed" data-value="공지">
                                        <i class="bi bi-megaphone-fill me-1"></i> 공지
                                    </a>
                                </li>
                            </c:if>
                            
                            <li class="nav-item">
                                <a class="nav-link ${sessionScope.user_email == clubInfo.leader_email ? '' : (isMember ? '' : 'disabled')}" 
                                   href="#" 
                                   data-role="${sessionScope.user_email == clubInfo.leader_email or isMember ? 'allowed' : 'restricted'}" 
                                   data-value="자유">
                                    <i class="bi bi-chat-square-text-fill me-1"></i> 자유
                                </a>
                            </li>
                            
                            <c:if test="${sessionScope.user_email == clubInfo.leader_email}">
                                <li class="nav-item">
                                    <a class="nav-link" href="#" data-role="allowed" data-value="활동앨범">
                                        <i class="bi bi-images me-1"></i> 활동앨범
                                    </a>
                                </li>
                            </c:if>
                            
                            <li class="nav-item">
                                <a class="nav-link ${sessionScope.user_email != clubInfo.leader_email and !isMember ? 'active' : ''}" 
                                   href="#" data-role="allowed" data-value="문의">
                                    <i class="bi bi-question-circle-fill me-1"></i> 문의
                                </a>
                            </li>
                        </ul>
                        
                        </div>

                    <form role="form" id="registerForm" action="/post/register" method="post" enctype="multipart/form-data">
                        
                        <input type="hidden" name="club_id" value="<c:out value='${club_id}'/>">
                        
                        <c:choose>
                        	<c:when test="${sessionScope.user_email == clubInfo.leader_email}">
                        		<c:set var="initType" value="공지"/>
                        	</c:when>
                        	<c:when test="${isMember}">
                        		<c:set var="initType" value="자유"/>
                        	</c:when>
                        	<c:otherwise>
                        		<c:set var="initType" value="문의"/>
                        	</c:otherwise>
                        </c:choose>
                        
                        <input type="hidden" id="post_type_input" name="post_type" value="${initType}">

                    <form role="form" id="registerForm" action="/post/register" method="post" enctype="multipart/form-data">
                        
                        <input type="hidden" name="club_id" value="<c:out value='${club_id}'/>">
                
                             
                        <div class="mb-3">
                            <label for="title" class="form-label">제목 (Title)</label> 
                            <input type="text" class="form-control" id="title" name='title' required>
                        </div>

                        <div class="mb-3">
                            <label for="content" class="form-label">내용 (Text area)</label>
                            <textarea class="form-control" id="content" rows="6" name='content' required></textarea>
                        </div>
                        
                        <div class="mb-4">
                            <label for="uploadFiles" class="form-label">첨부 파일 (File Attach)</label>
                            <input type="file" class="form-control" id="uploadFiles" name='uploadFiles' multiple>
                        </div>

                        <div class="d-flex justify-content-end gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle-fill me-1"></i> 등록하기
                            </button>
                            <button type="reset" class="btn btn-secondary">
                                <i class="bi bi-arrow-counterclockwise me-1"></i> 다시 쓰기
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>
    
    <div class="modal fade" id="authModal" tabindex="-1" aria-labelledby="authModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title" id="authModalLabel"><i class="bi bi-exclamation-triangle-fill me-1"></i> 권한 알림</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    동아리장만 작성 가능한 게시판입니다.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {

    // 카테고리 탭 클릭 이벤트
    $(".nav-pills a").on("click", function(e) {
        e.preventDefault(); 
        
        var tabRole = $(this).data("role");
        var postType = $(this).data("value");

        if (tabRole === 'allowed') {
            // 허용된 탭인 경우
            $(".nav-pills a").removeClass("active");
            $(this).addClass("active");
            $("#post_type_input").val(postType);
        } else if (tabRole === 'restricted') {
            // 제한된 탭인 경우
            var authModal = new bootstrap.Modal(document.getElementById('authModal'));
            authModal.show();
        }
    });

    // 폼 전송 시 유효성 검사
    $("#registerForm").on("submit", function(e) {
        var title = $("input[name='title']").val().trim();
        var content = $("textarea[name='content']").val().trim();
        var postType = $("#post_type_input").val();
        
        if (postType === '' || postType === null) {
            alert("게시판 종류를 선택하세요.");
            e.preventDefault(); 
            return;
        }

        if (title === '') {
            alert("제목을 입력하세요.");
            $("input[name='title']").focus();
            e.preventDefault();
            return;
        }

        if (content === '') {
            alert("내용을 입력하세요.");
            $("textarea[name='content']").focus();
            e.preventDefault();
            return;
        }
    });
});
</script>
</body>
</html>