<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container my-5">

    <div class="row">
        <div class="col-12">
            <h1 class="text-center mb-5 text-primary">로그인</h1>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-6 col-md-8">
            <div class="card shadow-lg">
                <div class="card-header bg-primary text-white text-center">
                    <h5 class="mb-0">캠퍼스 동아리 정보시스템 로그인</h5>
                </div>
             
                <div class="card-body">
                    
                    <c:if test="${not empty result}">
                        <c:if test="${result == 'login_fail'}">
                            <div class="alert alert-danger" role="alert">
                                이메일 또는 비밀번호가 일치하지 않습니다.
                            </div>
                        </c:if>
                        <c:if test="${result == 'register_success'}">
                            <div class="alert alert-success" role="alert">
                                회원가입이 완료되었습니다. 로그인해주세요.
                            </div>
                        </c:if>
                    </c:if>
                    
                    <c:if test="${not empty msg}">
                        <div class="alert alert-warning" role="alert">
                            ${msg}
                        </div>
                    </c:if>

                    
                    <form role="form" action="/user/login" method="post">
                        <div class="mb-3">
                            <label for="user_email" class="form-label">이메일 (Email)</label>
                            <input type="email" class="form-control" id="user_email" name="user_email" required>
                        </div>
                        <div class="mb-4">
                            <label for="password" class="form-label">비밀번호 (Password)</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
    
                        <button type="submit" class="btn btn-primary w-100 mb-3">로그인</button>
                        
                        <div class="text-center mt-3 small">
                            <a href="/user/register" class="text-decoration-none me-2">아직 회원이 아니신가요? (회원가입)</a>
                            <span class="text-muted">|</span>
                            <a href="/user/findId" class="text-decoration-none mx-2">아이디 찾기</a> 
                            <span class="text-muted">|</span>
                            <a href="/user/findPw" class="text-decoration-none ms-2">비밀번호 찾기</a>
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