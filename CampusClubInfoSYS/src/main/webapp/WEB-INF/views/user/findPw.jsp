<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container my-5">

    <div class="row">
        <div class="col-12">
            <h1 class="text-center mb-5 text-info">비밀번호 찾기</h1>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-6 col-md-8">
            <div class="card shadow-lg">
                <div class="card-header bg-info text-white text-center">
                    <h5 class="mb-0">Find Password (Step 1. 인증)</h5>
                </div>
                <div class="card-body">
                    
                    <c:if test="${not empty result and result == 'find_pw_fail'}">
                        <div class="alert alert-danger" role="alert">
                            일치하는 사용자 정보가 없습니다. 
                        </div>
                    </c:if>

                    <p class="mb-4 text-muted">비밀번호를 재설정하기 위해 사용자 정보를 입력해주세요.</p>
                    <form role="form" action="/user/findPw" method="post">
                        
                        <div class="mb-3">
                            <label for="user_email" class="form-label">이메일</label> 
                            <input type="email" class="form-control" id="user_email" name="user_email" required>
                        </div>
                        <div class="mb-3">
                            <label for="name" class="form-label">이름</label>
                            <input type="text" class="form-control" id="name" name="name" required> 
                        </div>
                        <div class="mb-4">
                            <label for="student_id" class="form-label">학번</label>
                            <input type="text" class="form-control" id="student_id" name="student_id" required> 
                        </div>
                        
                        <button type="submit" class="btn btn-info w-100">다음 단계로</button>
                    
                        <div class="text-center mt-3 small">
                            <a href="/user/login" class="text-decoration-none">로그인 페이지로 돌아가기</a>
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