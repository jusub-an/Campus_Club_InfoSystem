<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 재설정</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* Inter 폰트 */
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap');
        :root { font-family: 'Inter', sans-serif; }

        body {
            background-color: #f8fafc;
        }

        /* 네비게이션 바 */
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

        /* 카드 */
        .auth-card {
            border-radius: 1.5rem;
            border: 1px solid #e2e8f0;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.10),
                        0 4px 6px -2px rgba(0,0,0,0.05);
        }

        /* 버튼 */
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

        /* 비밀번호 확인 메시지 */
        #password_message {
            font-size: 0.85rem;
            margin-top: 0.3rem;
        }
    </style>
</head>
<body>

    <!-- 네비게이션 바 -->
    <nav class="navbar navbar-expand-lg navbar-light navbar-custom fixed-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                캠퍼스 동아리 정보시스템
            </a>
        </div>
    </nav>

    <!-- 메인 -->
    <div class="container py-5" style="padding-top: 6rem !important;">

        <div class="row justify-content-center">
            <div class="col-lg-5 col-md-7">

                <!-- 타이틀 -->
                <div class="text-center mb-4">
                    <h1 class="h3 fw-bold text-primary mb-2">비밀번호 재설정</h1>
                    <p class="text-muted">
                        <strong>${user_email}</strong> 님의 새 비밀번호를 입력해주세요.
                    </p>
                </div>

                <!-- 카드 -->
                <div class="card auth-card">
                    <div class="card-body p-4 p-lg-5">

                        <form role="form" id="resetPwForm"
                              action="<c:url value='/user/resetPw' />"
                              method="post">

                            <input type="hidden" name="user_email" value="${user_email}">

                            <div class="mb-3">
                                <label for="password" class="form-label fw-semibold">새 비밀번호</label>
                                <input type="password" class="form-control form-control-lg"
                                       id="password" name="password" required>
                            </div>

                            <div class="mb-4">
                                <label for="password_confirm" class="form-label fw-semibold">비밀번호 확인</label>
                                <input type="password" class="form-control form-control-lg"
                                       id="password_confirm" required>
                                <div id="password_message"></div>
                            </div>

                            <button type="submit" class="btn indigo-btn btn-lg w-100" id="resetPwBtn" disabled>
                                비밀번호 변경하기
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

    <!-- JS: 비밀번호 일치 검사 -->
    <script>
        const pw = document.getElementById("password");
        const pwc = document.getElementById("password_confirm");
        const msg = document.getElementById("password_message");
        const btn = document.getElementById("resetPwBtn");

        function checkPw() {
            if (pw.value === "" && pwc.value === "") {
                msg.textContent = "";
                btn.disabled = true;
            } else if (pw.value === pwc.value) {
                msg.textContent = "비밀번호가 일치합니다.";
                msg.style.color = "#198754"; // green
                btn.disabled = false;
            } else {
                msg.textContent = "비밀번호가 일치하지 않습니다.";
                msg.style.color = "#dc3545"; // red
                btn.disabled = true;
            }
        }

        pw.addEventListener("keyup", checkPw);
        pwc.addEventListener("keyup", checkPw);
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
