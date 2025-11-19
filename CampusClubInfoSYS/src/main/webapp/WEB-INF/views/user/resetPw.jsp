<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 재설정</title>
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
            <h1 class="text-center mb-5 text-success">비밀번호 재설정</h1>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-6 col-md-8">
            <div class="card shadow-lg">
                <div class="card-header bg-success text-white text-center">
                    <h5 class="mb-0">Find Password (Step 2. 재설정)</h5>
                </div>
                <div class="card-body">

                    <p class="mb-4 text-muted"><strong>${user_email}</strong> 님의 비밀번호를 새로 설정합니다. </p>

                    <form role="form" id="resetPwForm" action="/user/resetPw" method="post">
                        
                        <input type="hidden" name="user_email" value="${user_email}"> 
                        
                        <div class="mb-3">
                            <label for="password" class="form-label">새 비밀번호 (Password)</label>
                            <input type="password" class="form-control" id="password" name="password" required> 
                        </div>
                        
                        <div class="mb-4">
                            <label for="password_confirm" class="form-label">새 비밀번호 확인</label>
                            <input type="password" class="form-control" id="password_confirm" required> 
                            <div id="password_message" class="help-block"></div>
                        </div>
                        
                        <button type="submit" class="btn btn-success w-100" id="resetPwBtn" disabled>비밀번호 변경하기</button> 
                    
                    </form>

                </div>
            </div>
        </div>
    </div>

</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    
    var isPasswordConfirmed = false; 
    var $resetPwBtn = $("#resetPwBtn");
    var $passwordMessage = $("#password_message");
    
    function checkFormState() {
        if (isPasswordConfirmed) {
            $resetPwBtn.prop("disabled", false); 
        } else {
            $resetPwBtn.prop("disabled", true); 
        }
    }

    // --- 비밀번호 일치 확인 ---
    function checkPasswordMatch() {
        var password = $("#password").val();
        var confirm = $("#password_confirm").val(); 

        if (password === '' && confirm === '') {
            $passwordMessage.text("");
            isPasswordConfirmed = false; 
        } else if (password !== '' && password === confirm) {
            $passwordMessage.text("비밀번호가 일치합니다.").removeClass("text-danger").addClass("text-success"); 
            isPasswordConfirmed = true;
        } else {
            $passwordMessage.text("비밀번호가 일치하지 않습니다.").removeClass("text-success").addClass("text-danger"); 
            isPasswordConfirmed = false;
        }
        checkFormState(); // 상태 갱신 
    }

    $("#password").on("keyup", checkPasswordMatch);
    $("#password_confirm").on("keyup", checkPasswordMatch);

});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>