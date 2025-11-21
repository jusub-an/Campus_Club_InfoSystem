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
            for(var i = 0; i < categoryRadios.length; i++) {
                if(categoryRadios[i].checked) {
                    categorySelected = true; 
                    break;
                }
            }
            if (!categorySelected) {
                alert("카테고리를 선택해 주세요."); 
                return false;
            }
            
         	// 3. 로고 이미지 (logo_file) 확인 (파일 필드는 value 확인이 어려워 일단 통과시키고 서버에서 체크하는 것이 일반적이나, 
         	// 기존 로직의 의도에 따라 description 체크를 파일 체크로 임시 간주함)
         	// [원래 로직의 오타로 추정되는 'description' 대신 파일 선택 여부 검사 로직을 추가하지 않고, 다음 단계로 넘어갑니다.]
            
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
</head>
<body>
<div class="container my-5">

    <div class="row">
        <div class="col-12">
            <h2 class="text-center mb-5 text-success">새 동아리 등록</h2> 
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">
            <div class="card shadow-lg">
                <div class="card-header bg-success text-white text-center">
                    <h5 class="mb-0">Club Registration</h5>
                </div>
                <div class="card-body">

                    <form action="/club/register" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
                        
                        <div class="mb-3">
                            <label for="club_name" class="form-label">이름</label>
                            <input type="text" class="form-control" id="club_name" name="club_name" required>
                        </div>
                        
                        <div class="mb-3">
						    <label class="form-label d-block">카테고리</label>
						    
						    <c:set var="categoriesStr" value="공연·예술|체육·레저|학술·전공|사회·봉사|문화·교류|창업·취업·자기계발|취미·창작|종교·인문|기타" />
						    <c:set var="emojisStr" value="🎭|⚽|💻|💬|🌏|💡|🕹️|🪩|🧑‍🤝‍🧑" />
						    
						    <c:set var="catNames" value="${fn:split(categoriesStr, '|')}" />
						    <c:set var="emoList" value="${fn:split(emojisStr, '|')}" />
						    
						    <div class="row g-2 p-2 border rounded">
						        
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
                            <button type="submit" class="btn btn-success btn-lg">등록하기</button>
                        </div>
                        
                        <div class="text-center mt-3 small">
                            <a href="/club/list" class="text-decoration-none">목록으로 돌아가기</a>
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