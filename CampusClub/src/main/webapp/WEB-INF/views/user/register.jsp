<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>

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

        .help-block {
            font-size: 0.85rem;
            margin-top: 0.3rem;
        }
        .text-success { color: #198754 !important; }
        .text-danger { color: #dc3545 !important; }
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
                    <h1 class="h3 fw-bold text-primary mb-2">회원가입</h1>
                    <p class="text-muted mb-0">
                        새로운 계정을 생성해주세요.
                    </p>
                </div>

                <!-- 카드 -->
                <div class="card auth-card">
                    <div class="card-body p-4 p-lg-5">

                        <!-- 가입 실패 메시지 -->
                        <c:if test="${not empty result and result == 'register_fail'}">
                            <div class="alert alert-danger small" role="alert">
                                ${error_message}
                            </div>
                        </c:if>

                        <!-- 회원가입 폼 -->
                        <form role="form" id="registerForm" action="<c:url value='/user/register' />" method="post">

                            <!-- 이메일 + 중복확인 -->
                            <div class="mb-3">
                                <label for="user_email" class="form-label fw-semibold">이메일</label>
                                <div class="input-group input-group-lg">
                                    <input type="email"
                                           class="form-control"
                                           id="user_email" name="user_email"
                                           required
                                           placeholder="example@school.ac.kr">
                                    <button class="btn btn-outline-secondary" type="button" id="emailCheckBtn">
                                        중복 확인
                                    </button>
                                </div>
                                <div id="email_message" class="help-block"></div>
                            </div>

                            <!-- 비밀번호 -->
                            <div class="mb-3">
                                <label for="password" class="form-label fw-semibold">비밀번호</label>
                                <input type="password"
                                       class="form-control form-control-lg"
                                       id="password" name="password"
                                       required>
                            </div>

                            <!-- 비밀번호 확인 -->
                            <div class="mb-3">
                                <label for="password_confirm" class="form-label fw-semibold">비밀번호 확인</label>
                                <input type="password"
                                       class="form-control form-control-lg"
                                       id="password_confirm"
                                       required>
                                <div id="password_message" class="help-block"></div>
                            </div>

                            <!-- 이름 -->
                            <div class="mb-3">
                                <label for="name" class="form-label fw-semibold">이름</label>
                                <input type="text"
                                       class="form-control form-control-lg"
                                       id="name" name="name"
                                       required>
                            </div>

                            <!-- 학번 -->
                            <div class="mb-4">
                                <label for="student_id" class="form-label fw-semibold">학번</label>
                                <input type="text"
                                       class="form-control form-control-lg"
                                       id="student_id" name="student_id"
                                       required>
                            </div>

                            <!-- 가입 버튼 -->
                            <button type="submit"
                                    class="btn indigo-btn btn-lg w-100"
                                    id="registerBtn" disabled>
                                가입하기
                            </button>

                            <div class="text-center mt-3 small text-muted">
                                <a href="<c:url value='/user/login' />"
                                   class="text-primary text-decoration-none">
                                    이미 계정이 있으신가요? (로그인)
                                </a>
                            </div>
                        </form>

                    </div>
                </div>

            </div>
        </div>

    </div>

    <!-- jQuery (AJAX용) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- 이메일 중복 확인 + 비밀번호 확인 스크립트 -->
    <script type="text/javascript">
        $(document).ready(function() {
            // 상태 변수
            var isEmailChecked = false;      // 이메일 중복 확인 완료 여부
            var isPasswordConfirmed = false; // 비밀번호 일치 여부

            var $registerBtn     = $("#registerBtn");
            var $emailMessage    = $("#email_message");
            var $passwordMessage = $("#password_message");

            // 폼 전체 상태 체크
            function checkFormState() {
                if (isEmailChecked &&
                    isPasswordConfirmed &&
                    $("#name").val().trim() !== '' &&
                    $("#student_id").val().trim() !== '') {
                    $registerBtn.prop("disabled", false);
                } else {
                    $registerBtn.prop("disabled", true);
                }
            }

            // 이메일 중복 확인 AJAX
            $("#emailCheckBtn").on("click", function() {
                var email = $("#user_email").val().trim();

                if (email === '') {
                    $emailMessage
                        .text("이메일을 입력해주세요.")
                        .removeClass("text-success").addClass("text-danger");
                    isEmailChecked = false;
                    checkFormState();
                    return;
                }

                $.ajax({
                    type: "POST",
                    url: "<c:url value='/user/emailCheck' />",
                    data: { "user_email": email },
                    success: function(result) {
                        if (result == "0") {
                            $emailMessage
                                .text("사용 가능한 이메일입니다.")
                                .removeClass("text-danger").addClass("text-success");
                            isEmailChecked = true;
                        } else {
                            $emailMessage
                                .text("이미 사용 중인 이메일입니다.")
                                .removeClass("text-success").addClass("text-danger");
                            isEmailChecked = false;
                        }
                        checkFormState();
                    },
                    error: function() {
                        $emailMessage
                            .text("오류가 발생했습니다. 다시 시도해주세요.")
                            .removeClass("text-success").addClass("text-danger");
                        isEmailChecked = false;
                        checkFormState();
                    }
                });
            });

            // 이메일 입력값이 바뀌면 중복 확인 상태 초기화
            $("#user_email").on("input", function() {
                isEmailChecked = false;
                $emailMessage.text("").removeClass("text-success text-danger");
                checkFormState();
            });

            // 비밀번호 일치 확인
            function checkPasswordMatch() {
                var password = $("#password").val();
                var confirm  = $("#password_confirm").val();

                if (password === '' && confirm === '') {
                    $passwordMessage.text("").removeClass("text-success text-danger");
                    isPasswordConfirmed = false;
                } else if (password === confirm) {
                    $passwordMessage
                        .text("비밀번호가 일치합니다.")
                        .removeClass("text-danger").addClass("text-success");
                    isPasswordConfirmed = true;
                } else {
                    $passwordMessage
                        .text("비밀번호가 일치하지 않습니다.")
                        .removeClass("text-success").addClass("text-danger");
                    isPasswordConfirmed = false;
                }
                checkFormState();
            }

            $("#password").on("keyup", checkPasswordMatch);
            $("#password_confirm").on("keyup", checkPasswordMatch);

            // 이름/학번 입력 감지
            $("#name, #student_id").on("keyup", checkFormState);
        });
    </script>

</body>
</html>
