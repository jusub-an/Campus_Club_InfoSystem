<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<%@include file="../includes/header.jsp" %>

<style>
    .help-block { font-size: 12px; margin-top: 5px; }
    .text-success { color: green; }
    .text-danger { color: red; }
</style>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">비밀번호 재설정</h1>
    </div>
</div>

<div class="row">
    <div class="col-lg-6 col-lg-offset-3">
        <div class="panel panel-default">
            <div class="panel-heading">
                Find Password (Step 2. 재설정)
            </div>
            <div class="panel-body">

                <p><strong>${user_email}</strong> 님의 비밀번호를 새로 설정합니다.</p>

                <form role="form" id="resetPwForm" action="/user/resetPw" method="post">
                    
                    <!-- [중요] 인증된 이메일 정보를 숨겨서 전송 -->
                    <input type="hidden" name="user_email" value="${user_email}">
                    
                    <div class="form-group">
                        <label>새 비밀번호 (Password)</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    
                    <div class="form-group">
                        <label>새 비밀번호 확인</label>
                        <input type="password" class="form-control" id="password_confirm" required>
                        <div id="password_message" class="help-block"></div>
                    </div>
                    
                    <button type="submit" class="btn btn-success btn-block" id="resetPwBtn" disabled>비밀번호 변경하기</button>
                
                </form>

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

<%@include file="../includes/footer.jsp" %>