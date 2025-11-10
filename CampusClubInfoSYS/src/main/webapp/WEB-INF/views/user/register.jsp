<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<%@include file="../includes/header.jsp" %>

<style>
    .help-block {
        font-size: 12px;
        margin-top: 5px;
    }
    .text-success { color: green; }
    .text-danger { color: red; }
</style>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">회원가입</h1>
    </div>
</div>

<div class="row">
    <div class="col-lg-6 col-lg-offset-3">
        <div class="panel panel-default">
            <div class="panel-heading">
                Register
            </div>
            <div class="panel-body">

                <!-- 회원가입 실패 시 메시지 -->
                <c:if test="${not empty result and result == 'register_fail'}">
                    <div class="alert alert-danger">
                        ${error_message}
                    </div>
                </c:if>

                <form role="form" id="registerForm" action="/user/register" method="post">
                    
                    <div class="form-group">
                        <label>이메일 (Email)</label>
                        <div class="input-group">
                            <input type="email" class="form-control" id="user_email" name="user_email" required>
                            <span class="input-group-btn">
                                <button class="btn btn-default" type="button" id="emailCheckBtn">중복 확인</button>
                            </span>
                        </div>
                        <div id="email_message" class="help-block"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>비밀번호 (Password)</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    
                    <div class="form-group">
                        <label>비밀번호 확인</label>
                        <input type="password" class="form-control" id="password_confirm" required>
                        <div id="password_message" class="help-block"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>이름</label>
                        <input type="text" class="form-control" id="name" name="name" required>
                    </div>
                    
                    <div class="form-group">
                        <label>학번</label>
                        <input type="text" class="form-control" id="student_id" name="student_id" required>
                    </div>
                    
                    <button type="submit" class="btn btn-success btn-block" id="registerBtn" disabled>가입하기</button>
                
                </form>

            </div>
            <!-- /.panel-body -->
        </div>
        <!-- /.panel -->
    </div>
    <!-- /.col-lg-6 -->
</div>
<!-- /.row -->

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    
    // 유효성 검사 상태 변수
    var isEmailChecked = false; // 이메일 중복 확인 완료 여부
    var isPasswordConfirmed = false; // 비밀번호 일치 여부

    var $registerBtn = $("#registerBtn");
    var $emailMessage = $("#email_message");
    var $passwordMessage = $("#password_message");
    
    // 모든 조건이 만족될 때만 가입 버튼 활성화
    function checkFormState() {
        if (isEmailChecked && isPasswordConfirmed && 
            $("#name").val() !== '' && $("#student_id").val() !== '') {
            $registerBtn.prop("disabled", false);
        } else {
            $registerBtn.prop("disabled", true);
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
            type: "POST",
            url: "/user/emailCheck",
            data: { "user_email": email },
            success: function(result) {
                if (result == "0") {
                    $emailMessage.text("사용 가능한 이메일입니다.").removeClass("text-danger").addClass("text-success");
                    isEmailChecked = true;
                } else {
                    $emailMessage.text("이미 사용 중인 이메일입니다.").removeClass("text-success").addClass("text-danger");
                    isEmailChecked = false;
                }
                checkFormState(); // 상태 갱신
            },
            error: function() {
                $emailMessage.text("오류가 발생했습니다. 다시 시도해주세요.").addClass("text-danger");
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
        } else if (password === confirm) {
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

    // --- 3. 이름, 학번 입력 감지 ---
    $("#name, #student_id").on("keyup", checkFormState);

    // --- 4. 폼 최종 제출 ---
    // (버튼이 disabled 상태일 때는 submit 이벤트 자체가 발생하지 않으므로
    //  별도의 submit 이벤트 핸들러는 필요하지 않습니다.)
    
    /*
    // 만약 버튼을 비활성화하지 않고 submit에서 막으려면
    $("#registerForm").on("submit", function(e) {
        if (!isEmailChecked) {
            alert("이메일 중복 확인을 해주세요.");
            e.preventDefault(); // 폼 제출 중단
            return;
        }
        if (!isPasswordConfirmed) {
            alert("비밀번호가 일치하지 않습니다.");
            e.preventDefault();
            return;
        }
        // (이름, 학번 등 빈 값 체크)
    });
    */

});
</script>

<%@include file="../includes/footer.jsp" %>