<%@ page language="java" contentType="text/html; charset=UTF-8"

    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

    

<%@include file="../includes/header.jsp" %>



<div class="row">

    <div class="col-lg-12">

        <h1 class="page-header">아이디(이메일) 찾기</h1>

    </div>

</div>



<div class="row">

    <div class="col-lg-6 col-lg-offset-3">

        <div class="panel panel-default">

            <div class="panel-heading">

                Find ID

            </div>

            <div class="panel-body">

                

                <!-- 아이디 찾기 결과 표시 -->

                <c:if test="${not empty result}">

                    <c:if test="${result == 'find_id_success'}">

                        <div class="alert alert-success">

                            찾으시는 이메일은 <strong>${found_email}</strong> 입니다.

                            <br><br>

                            <a href="/user/login" class="btn btn-primary btn-sm">로그인 하러가기</a>

                        </div>

                    </c:if>

                    <c:if test="${result == 'find_id_fail'}">

                        <div class="alert alert-danger">

                            일치하는 사용자 정보가 없습니다.

                        </div>

                    </c:if>

                </c:if>



                <!-- 결과가 없을 때만 폼을 표시 -->

                <c:if test="${empty result or result == 'find_id_fail'}">

                    <form role="form" action="/user/findId" method="post">

                        <div class="form-group">

                            <label>이름</label>

                            <input type="text" class="form-control" name="name" required>

                        </div>

                        <div class="form-group">

                            <label>학번</label>

                            <input type="text" class="form-control" name="student_id" required>

                        </div>

                        

                        <button type="submit" class="btn btn-info btn-block">아이디 찾기</button>

                        

                        <div class="text-center" style="margin-top: 15px;">

                            <a href="/user/login">로그인 페이지로 돌아가기</a>

                        </div>

                    </form>

                </c:if>



            </div>

        </div>

    </div>

</div>



<%@include file="../includes/footer.jsp" %>