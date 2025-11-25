<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap');
        :root {
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: #f8fafc;
        }

        .navbar-custom {
            background-color: #ffffff !important;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1),
                        0 2px 4px -2px rgba(0, 0, 0, 0.06);
            border-bottom: 1px solid #e2e8f0;
            padding-top: 0.5rem !important;
    		padding-bottom: 0.5rem !important;
        }

        .navbar-brand {
            font-weight: 800;
            color: #4f46e5 !important; /* indigo-600 */
            letter-spacing: 1px;
        }

        .auth-card {
            border-radius: 1.5rem;
            border: 1px solid #e2e8f0;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.10),
                        0 4px 6px -2px rgba(0,0,0,0.05);
        }

        .login-btn {
            background-color: #4f46e5;  /* indigo-600 */
            border-color: #4f46e5;
            font-weight: 600;
            color: #ffffff !important;
        }
        
        .login-btn:hover {
            background-color: #4338ca;  /* indigo-700 */
            border-color: #4338ca;
            color: #ffffff !important;
        }
    </style>
</head>
<body>

    <%-- 네비게이션 바 --%>
    <nav class="navbar navbar-expand-lg navbar-light navbar-custom fixed-top" style="font-family: 'Inter', sans-serif;">
    	<div class="container d-flex justify-content-between align-items-center">

        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            캠퍼스 동아리 정보시스템
        </a>
        </div>
	</nav>

    <!-- 메인 컨텐츠 영역: 네비가 fixed-top이라 위에 여백 조금 줌 -->
    <div class="container py-5" style="padding-top: 6rem !important;">

        <div class="row justify-content-center">
            <div class="col-lg-5 col-md-7">

                <!-- 타이틀 -->
                <div class="text-center mb-4">
                    <h1 class="h3 fw-bold text-primary mb-2">로그인</h1>
                    <p class="text-muted mb-0">
                        캠퍼스 동아리 정보시스템에 로그인해주세요.
                    </p>
                </div>

                <!-- 로그인 카드 -->
                <div class="card auth-card">
                    <div class="card-body p-4 p-lg-5">

                        <!-- 알림 메시지 -->
                        <c:if test="${not empty result}">
                            <c:if test="${result == 'login_fail'}">
                                <div class="alert alert-danger small" role="alert">
                                    이메일 또는 비밀번호가 일치하지 않습니다.
                                </div>
                            </c:if>
                            <c:if test="${result == 'register_success'}">
                                <div class="alert alert-success small" role="alert">
                                    회원가입이 완료되었습니다. 로그인해주세요.
                                </div>
                            </c:if>
                        </c:if>

                        <c:if test="${not empty msg}">
                            <div class="alert alert-warning small" role="alert">
                                ${msg}
                            </div>
                        </c:if>

                        <!-- 로그인 폼 -->
                        <form role="form" action="<c:url value='/user/login' />" method="post" class="mt-3">

                            <div class="mb-3">
                                <label for="user_email" class="form-label fw-semibold">
                                    이메일 (Email)
                                </label>
                                <input type="email"
                                       class="form-control form-control-lg"
                                       id="user_email" name="user_email" required
                                       placeholder="example@school.ac.kr">
                            </div>

                            <div class="mb-4">
                                <label for="password" class="form-label fw-semibold">
                                    비밀번호 (Password)
                                </label>
                                <input type="password"
                                       class="form-control form-control-lg"
                                       id="password" name="password" required
                                       placeholder="비밀번호를 입력하세요">
                            </div>

                            <!-- 로그인 버튼 -->
                            <button type="submit"
                                    class="btn btn-lg w-100 mb-3 login-btn">
                                로그인
                            </button>

                            <!-- 하단 링크 -->
                            <div class="text-center small text-muted">
                                <div class="mb-2">
                                    <a href="<c:url value='/user/register' />"
                                       class="text-primary text-decoration-none fw-semibold">
                                        아직 회원이 아니신가요? (회원가입)
                                    </a>
                                </div>
                                <div>
                                    <a href="<c:url value='/user/findId' />"
                                       class="text-primary text-decoration-none me-2">
                                        아이디 찾기
                                    </a>
                                    <span class="text-secondary">|</span>
                                    <a href="<c:url value='/user/findPw' />"
                                       class="text-primary text-decoration-none ms-2">
                                        비밀번호 찾기
                                    </a>
                                </div>
                            </div>
                        </form>

                    </div> <!-- card-body -->
                </div> <!-- card -->
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
