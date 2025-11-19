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
        /* 기존 help-block 스타일 유지 */
        .help-block {
            font-size: 0.85rem;
            margin-top: 0.3rem;
        }
        .text-success { color: #198754 !important; } /* Bootstrap success color */
        .text-danger { color: #dc3545 !important; } /* Bootstrap danger color */
    </style>
</head>
<body>

<div class="container my-5">

    <div class="row">
        <div class="col-12">
            <h1 class="text-center mb-5 text-success">회원가입</h1>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-6 col-md-8">
            <div class="card shadow-lg">
                <div class="card-header bg-success text-white text-center">
                    <h5 class="mb-0">새 계정 등록</h5>
                </div>
                <div class="card-body">

                    <c:if test="${not empty result and result == 'register_fail'}">
                        <div class="alert alert-danger" role="alert">
                            ${error_message}
                        </div>
                    </c:if>

                    <form role="form" id="registerForm" action="/user/register" method="post">
                        
                        <div class="mb-3">
                            <label for="user_email" class="form-label">Email</label>
                            <div class="input-group">
                                <input type="email" class="form-control" id="user_email" name="user_email" required placeholder="example@school.ac.kr">
                                <button class="btn btn-outline-secondary" type="button" id="emailCheckBtn">중복 확인</button>
                            </div>
                            <div id="email_message" class="help-block"></div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="password" class="form-label">비밀번호</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="password_confirm" class="form-label">비밀번호 확인</label>
                            <input type="password" class="form-control" id="password_confirm" required>
                            <div id="password_message" class="help-block"></div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="name" class="form-label">이름</label>
                            <input type="text" class="form-control" id="name" name="name" required>
                        </div>
                    
                        <div class="mb-4">
                            <label for="student_id" class="form-label">학번</label>
                            <input type="text" class="form-control" id="student_id" name="student_id" required>
                        </div>
                        
                        <button type="submit" class="btn btn-success w-100" id="registerBtn" disabled>가입하기</button>
                    
                    </form>

                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    
    // 
    var isEmailChecked = false; // 이메일 중복 확인 완료 여부
    var isPasswordConfirmed = false; // 비밀번호 일치 여부

    var $registerBtn = $("#registerBtn");
    var $emailMessage = $("#email_message");
    var $passwordMessage = $("#password_message");
    
    // 모든 조건이 만족될 때만 가입 버튼 활성화 
    function checkFormState() {
        if (isEmailChecked && isPasswordConfirmed && 
            $("#name").val() !== '' && $("#student_id").val() !== '') {
            $registerBtn.prop("disabled", false); // 
        } else {
            $registerBtn.prop("disabled", true); // 
        }
    }

    // --- 1. 이메일 중복 확인 (AJAX) ---
    $("#emailCheckBtn").on("click", function() {
        var email = $("#user_email").val();
        
        if (email === '') {
            $emailMessage.text("이메일을 입력해주세요.").removeClass("text-success").addClass("text-danger");
            return;
        }

        $.ajax({
            type: "POST", // 
            url: "/user/emailCheck",
            data: { "user_email": email },
            success: function(result) {
                if (result == "0") {
                    $emailMessage.text("사용 가능한 이메일입니다.").removeClass("text-danger").addClass("text-success");
                    isEmailChecked = true; // 
                } else {
                    $emailMessage.text("이미 사용 중인 이메일입니다.").removeClass("text-success").addClass("text-danger");
                    isEmailChecked = false;
                }
                checkFormState(); // 상태 갱신
            },
            error: function() {
                $emailMessage.text("오류가 발생했습니다. 다시 시도해주세요.").addClass("text-danger"); // 
                isEmailChecked = false;
                checkFormState(); // 상태 갱신
            }
        });
    });

    // 이메일 입력란이 변경되면 중복 확인 상태 초기화
    $("#user_email").on("input", function() {
        isEmailChecked = false;
        $emailMessage.text("");
        checkFormState(); // 상태 갱신
    });

    // --- 2. 비밀번호 일치 확인 ---
    function checkPasswordMatch() {
        var password = $("#password").val();
        var confirm = $("#password_confirm").val();

        if (password === '' && confirm === '') {
            $passwordMessage.text("");
            isPasswordConfirmed = false;
        } else if (password === confirm) { // 
            $passwordMessage.text("비밀번호가 일치합니다.").removeClass("text-danger").addClass("text-success");
            isPasswordConfirmed = true;
        } else {
            $passwordMessage.text("비밀번호가 일치하지 않습니다.").removeClass("text-success").addClass("text-danger");
            isPasswordConfirmed = false; // 
        }
        checkFormState(); // 상태 갱신
    }

    $("#password").on("keyup", checkPasswordMatch); // 
    $("#password_confirm").on("keyup", checkPasswordMatch);

    // --- 3. 이름, 학번 입력 감지 ---
    $("#name, #student_id").on("keyup", checkFormState); // 

});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>