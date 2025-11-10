<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@include file="../includes/header.jsp" %>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">로그인</h1>
    </div>
</div>

<div class="row">
    <div class="col-lg-6 col-lg-offset-3">
        <div class="panel panel-default">
            <div class="panel-heading">
                Login
            </div>
            <div class="panel-body">
                
                <!-- 서버에서 보낸 Flash 메시지 표시 -->
                <c:if test="${not empty result}">
                    <c:if test="${result == 'login_fail'}">
                        <div class="alert alert-danger">
                            이메일 또는 비밀번호가 일치하지 않습니다.
                        </div>
                    </c:if>
                    <c:if test="${result == 'register_success'}">
                        <div class="alert alert-success">
                            회원가입이 완료되었습니다. 로그인해주세요.
                        </div>
                    </c:if>
                </c:if>

                <form role="form" action="/user/login" method="post">
                    <div class="form-group">
                        <label>이메일 (Email)</label>
                        <input type="email" class="form-control" name="user_email" required>
                    </div>
                    <div class="form-group">
                        <label>비밀번호 (Password)</label>
                        <input type="password" class="form-control" name="password" required>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-block">로그인</button>
                    
                    <div class="text-center" style="margin-top: 15px;">
                        <a href="/user/register">아직 회원이 아니신가요? (회원가입)</a>|
                        <a href="/user/findId">아이디 찾기</a> |
                        <a href="/user/findPw">비밀번호 찾기</a>
                    </div>
                </form>

            </div>
            <!-- /.panel-body -->
        </div>
        <!-- /.panel -->
    </div>
    <!-- /.col-lg-6 -->
</div>
<!-- /.row -->

<%@include file="../includes/footer.jsp" %>