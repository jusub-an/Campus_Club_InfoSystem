<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp" %>
<div class="row">
  <div class="col-lg-12">
    <h1 class="page-header">Post Register</h1>
  </div>
  </div>
<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">

      <div class="panel-heading">Post Register</div>
      <div class="panel-body">

        <div class="form-group">
            <label>게시판 선택</label>
            <ul class="nav nav-tabs">
                <li role="presentation">
                    <a href="#" data-role="restricted" data-value="공지">공지</a>
                </li>
                <li role="presentation" class="active"> <a href="#" data-role="allowed" data-value="자유">자유</a>
                </li>
                <li role="presentation">
                    <a href="#" data-role="allowed" data-value="활동앨범">활동앨범</a>
                </li>
                <li role="presentation">
                    <a href="#" data-role="allowed" data-value="문의">문의</a>
                </li>
            </ul>
        </div>

        <form role="form" id="registerForm" action="/post/register" method="post" enctype="multipart/form-data">
          
          <input type="hidden" id="post_type_input" name="post_type" value="자유">

          <div class="form-group">
            <label>Title</label> <input class="form-control" name='title'>
          </div>

          <div class="form-group">
            <label>Text area</label>
            <textarea class="form-control" rows="3" name='content'></textarea>
          </div>
          
          <div class="form-group">
	        <label>File Attach</label>
	        <input type="file" name='uploadFiles' multiple>
	      </div>

          <button type="submit" class="btn btn-default">Submit
            Button</button>
          <button type="reset" class="btn btn-default">Reset Button</button>
        </form>

      </div>
      </div>
    </div>
  </div>
<div class="modal fade" id="authModal" tabindex="-1" role="dialog"
    aria-labelledby="authModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                    aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="authModalLabel">권한 알림</h4>
            </div>
            <div class="modal-body">
                동아리장만 작성 가능한 게시판입니다.
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default"
                    data-dismiss="modal">Close</button>
            </div>
        </div>
        </div>
    </div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {

    // 카테고리 탭 클릭 이벤트
    $(".nav-tabs a").on("click", function(e) {
        e.preventDefault(); // a 태그 기본 동작(페이지 이동) 방지
        
        var tabRole = $(this).data("role");
        var postType = $(this).data("value");

        if (tabRole === 'allowed') {
            // 1. 허용된 탭인 경우
            // 모든 탭에서 'active' 클래스 제거
            $(".nav-tabs li").removeClass("active");
            // 클릭한 탭에 'active' 클래스 추가
            $(this).parent("li").addClass("active");
            // hidden input에 선택한 값(postType) 설정
            $("#post_type_input").val(postType);
        } else if (tabRole === 'restricted') {
            // 2. 제한된 탭인 경우
            // 경고 모달창 띄우기
            $("#authModal").modal("show");
        }
    });

    // 폼 전송 시 유효성 검사 (선택 사항이지만 권장)
    $("#registerForm").on("submit", function(e) {
        var title = $("input[name='title']").val();
        var content = $("textarea[name='content']").val();
        var postType = $("#post_type_input").val();
        
        if (postType === '' || postType === null) {
            alert("게시판 종류를 선택하세요.");
            e.preventDefault(); // 폼 전송 중단
            return;
        }

        if (title === '') {
            alert("제목을 입력하세요.");
            $("input[name='title']").focus();
            e.preventDefault();
            return;
        }

        if (content === '') {
            alert("내용을 입력하세요.");
            $("textarea[name='content']").focus();
            e.preventDefault();
            return;
        }
    });
});
</script>


<%@include file="../includes/footer.jsp"%>