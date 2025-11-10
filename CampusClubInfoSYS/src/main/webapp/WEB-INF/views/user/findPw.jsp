<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<%@include file="../includes/header.jsp" %>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">비밀번호 찾기</h1>
    </div>
</div>

<div class="row">
    <div class="col-lg-6 col-lg-offset-3">
        <div class="panel panel-default">
            <div class="panel-heading">
                Find Password (Step 1. 인증)
            </div>
            <div class="panel-body">
                
                <c:if test="${not empty result and result == 'find_pw_fail'}">
                    <div class="alert alert-danger">
                        일치하는 사용자 정보가 없습니다.
                    </div>
                </c:if>

                <p>비밀번호를 재설정하기 위해 사용자 정보를 입력해주세요.</p>
                <form role="form" action="/user/findPw" method="post">
                    <div class="form-group">
                        <label>이메일</label>
                        <input type="email" class="form-control" name="user_email" required>
                    </div>
                    <div class="form-group">
                        <label>이름</label>
                        <input type="text" class="form-control" name="name" required>
                    </div>
                    <div class="form-group">
                        <label>학번</label>
                        <input type="text" class="form-control" name="student_id" required>
                    </div>
                    
                    <button type="submit" class="btn btn-info btn-block">다음 단계로</button>
                    
                    <div class="text-center" style="margin-top: 15px;">
                        <a href="/user/login">로그인 페이지로 돌아가기</a>
                    </div>
                </form>

            </div>
        </div>
    </div>
</div>

<%@include file="../includes/footer.jsp" %>