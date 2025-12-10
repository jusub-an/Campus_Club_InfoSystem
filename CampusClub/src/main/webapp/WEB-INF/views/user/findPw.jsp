<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap');
        :root { font-family: 'Inter', sans-serif; }

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
            color: #4f46e5 !important;
            letter-spacing: 0.5px;
        }

        .auth-card {
            border-radius: 1.5rem;
            border: 1px solid #e2e8f0;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.10),
                        0 4px 6px -2px rgba(0,0,0,0.05);
        }

        .indigo-btn {
            background-color: #4f46e5;
            border-color: #4f46e5;
            color: white;
            font-weight: 600;
        }
        .indigo-btn:hover {
            background-color: #4338ca;
            border-color: #4338ca;
            color: white;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light navbar-custom fixed-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                캠퍼스 동아리 정보시스템
            </a>
        </div>
    </nav>

    <div class="container py-5" style="padding-top: 6rem !important;">

        <div class="row justify-content-center">
            <div class="col-lg-5 col-md-7">

                <div class="text-center mb-4">
                    <h1 class="h3 fw-bold text-primary mb-2">비밀번호 찾기</h1>
                    <p class="text-muted mb-0">
                        비밀번호를 재설정하기 위해 사용자 정보를 입력해주세요.
                    </p>
                </div>

                <div class="card auth-card">
                    <div class="card-body p-4 p-lg-5">

                        <!-- 실패 메시지 -->
                        <c:if test="${not empty result and result == 'find_pw_fail'}">
                            <div class="alert alert-danger small text-center" role="alert">
                                일치하는 사용자 정보가 없습니다.
                            </div>
                        </c:if>

                        <form role="form" action="<c:url value='/user/findPw' />" method="post" class="mt-3">

                            <div class="mb-3">
                                <label for="user_email" class="form-label fw-semibold">이메일</label>
                                <input type="email"
                                       class="form-control form-control-lg"
                                       id="user_email" name="user_email" required>
                            </div>

                            <div class="mb-3">
                                <label for="name" class="form-label fw-semibold">이름</label>
                                <input type="text"
                                       class="form-control form-control-lg"
                                       id="name" name="name" required>
                            </div>

                            <div class="mb-4">
                                <label for="student_id" class="form-label fw-semibold">학번</label>
                                <input type="text"
                                       class="form-control form-control-lg"
                                       id="student_id" name="student_id" required>
                            </div>

                            <button type="submit" class="btn indigo-btn btn-lg w-100">
                                다음 단계로
                            </button>

                            <div class="text-center mt-3 small text-muted">
                                <a href="<c:url value='/user/login' />"
                                   class="text-primary text-decoration-none">
                                    로그인 페이지로 돌아가기
                                </a>
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
