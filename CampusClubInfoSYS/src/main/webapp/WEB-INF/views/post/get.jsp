<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<%@include file="../includes/header.jsp" %>
<div class="row">
  <div class="col-lg-12">
    <h1 class="page-header">Post Read</h1>
  </div>
  </div>
<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">

      <div class="panel-heading">Post Read Page</div>
      <div class="panel-body">

          <div class="form-group">
          <label>Post</label> <input class="form-control" name='post_id'
            value='<c:out value="${post.post_id }"/>' readonly="readonly">
        </div>

        <div class="form-group">
          <label>Title</label> <input class="form-control" name='title'
            value='<c:out value="${post.title }"/>' readonly="readonly">
        </div>

        <div class="form-group">
          <label>Text area</label>
          <textarea class="form-control" rows="3" name='content'
             readonly="readonly"><c:out value="${post.content}" /></textarea>
        </div>
        
        <div class="form-group">
          <label>Club ID</label> 
          <input class="form-control" name='club_id' value='<c:out value="${post.club_id}"/>' readonly="readonly">
        </div>

        <div class="form-group">
          <label>Writer</label> <input class="form-control" name='writer'
            value='<c:out value="${post.author_email }"/>' readonly="readonly">
        </div>
        
        <div class="form-group">
            <label>첨부파일</label>
            <div class="panel panel-default">
                <div class="panel-heading">Files</div>
                <div class="panel-body">
                    <ul class="list-group">
                        <c:forEach items="${post.attachList}" var="file">
                        
                            <li class="list-group-item">
                                <span class="glyphicon glyphicon-save"></span>
                                <a href="/post/download?file_id=${file.file_id}">
                                    <c:out value="${file.file_name}" />
                                </a>
                            </li>
                            
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>

<%-- 		<button data-oper='modify' class="btn btn-default">
        <a href="/board/modify?bno=<c:out value="${board.bno}"/>">Modify</a></button>
        <button data-oper='list' class="btn btn-info">
        <a href="/board/list">List</a></button> --%>
		<div class="form-group">
          <label>Created Date</label> 
          <input class="form-control" name='created_date' value='<fmt:formatDate value="${post.created_date}" pattern="yyyy-MM-dd HH:mm:ss"/>' readonly="readonly">
        </div>

        <div class="form-group">
          <label>Post Type</label> 
          <input class="form-control" name='post_type' value='<c:out value="${post.post_type}"/>' readonly="readonly">
        </div>

<button data-oper='modify' class="btn btn-default">Modify</button>
<button data-oper='list' class="btn btn-info">List</button>

<%-- <form id='operForm' action="/boad/modify" method="get">
  <input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
</form> --%>


<form id='operForm' action="/post/modify" method="get">
  <input type='hidden' id='post_id' name='post_id' value='<c:out value="${post.post_id}"/>'>
  <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
  <input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
  <input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'>
  <input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>  
  <input type='hidden' name='post_type' value='<c:out value="${cri.post_type}"/>'>
</form>



      </div>
      </div>
    </div>
  </div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<script type="text/javascript">
$(document).ready(function() {
  
  var operForm = $("#operForm");
  $("button[data-oper='modify']").on("click", function(e){
    
    operForm.attr("action","/post/modify").submit();
    
  });
  $("button[data-oper='list']").on("click", function(e){
    
    operForm.find("#post_id").remove();
    operForm.attr("action","/post/list")
    operForm.submit();
    
  });
});
</script>


<%@include file="../includes/footer.jsp"%>