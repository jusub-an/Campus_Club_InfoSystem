<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp" %>
<div class="row">
  <div class="col-lg-12">
    <h1 class="page-header">Post Modify</h1>
  </div>
  </div>
<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">

      <div class="panel-heading">Post Modify</div>
      <div class="panel-body">

      <form role="form" id="modifyForm" action="/post/modify" method="post" enctype="multipart/form-data">
      
        <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum }"/>'>
        <input type='hidden' name='amount' value='<c:out value="${cri.amount }"/>'>
	    <input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
		<input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>
      
 
		<div class="form-group">
		  <label>Post_id</label> 
		  <input class="form-control" name='post_id' 
		     value='<c:out value="${post.post_id }"/>' readonly="readonly">
		</div>
		
		<div class="form-group">
            <label>게시판 선택</label>
            <ul class="nav nav-tabs">
                <li role="presentation" class="${post.post_type == '공지' ? 'active' : ''}">
                    <a href="#" data-role="restricted" data-value="공지">공지</a>
                </li>
                <li role="presentation" class="${post.post_type == '자유' ? 'active' : ''}">
                    <a href="#" data-role="allowed" data-value="자유">자유</a>
                </li>
                <li role="presentation" class="${post.post_type == '활동앨범' ? 'active' : ''}">
                    <a href="#" data-role="restricted" data-value="활동앨범">활동앨범</a>
                </li>
                <li role="presentation" class="${post.post_type == '문의' ? 'active' : ''}">
                    <a href="#" data-role="allowed" data-value="문의">문의</a>
                </li>
            </ul>
        </div>
        
        <input type="hidden" id="post_type_input" name="post_type" 
               value="<c:out value='${post.post_type}'/>">
		<div class="form-group">
		  <label>Title</label> 
		  <input class="form-control" name='title' 
		    value='<c:out value="${post.title }"/>' >
		</div>
		
		<div class="form-group">
		  <label>Text area</label>
		  <textarea class="form-control" rows="3" name='content' ><c:out value="${post.content}"/></textarea>
		</div>
		
		<div class="form-group">
		  <label>Writer</label> 
		  <input class="form-control" name='writer'
		    value='<c:out value="${post.author_email}"/>' readonly="readonly">            
		</div>
		
		<div class="form-group">
		  <label>RegDate</label> 
		  <input class="form-control" name='regDate'
		    value='<fmt:formatDate pattern = "yyyy/MM/dd" value = "${post.created_date}" />'  readonly="readonly">            
		</div>
		
		<div class="form-group">
		    <label>기존 첨부파일</label>
		    <div class="panel panel-default">
		        <div class="panel-body">
		            <ul class="list-group" id="attachList">
		                <c:forEach items="${post.attachList}" var="file">
		                    <li class="list-group-item" data-fileid="${file.file_id}">
		                         <span class="glyphicon glyphicon-save"></span>
		                         <a href="/post/download?file_id=${file.file_id}">
		                            <c:out value="${file.file_name}" />
		                        </a>
		                         <button type="button" class="btn btn-danger btn-xs pull-right delete-file-btn">X</button>
		                    </li>
		                </c:forEach>
		            </ul>
		        </div>
		    </div>
		</div>
		
		<div class="form-group">
		  <label>파일 추가</label>
		  <input type="file" name='uploadFiles' multiple>
		</div>
		
		<div class="form-group" id="newFileListContainer">
		    <label>새로 첨부할 파일 (미리보기)</label>
		    <div class="panel panel-default">
		        <div class="panel-body">
		            <ul class="list-group" id="newFileList">
		                </ul>
		        </div>
		    </div>
		</div>
		

		<button type="submit" data-oper='modify' class="btn btn-default">Modify</button>
		<button type="submit" data-oper='remove' class="btn btn-danger">Remove</button>
		<button type="submit" data-oper='list' class="btn btn-info">List</button>
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

<div class="modal fade" id="confirmModal" tabindex="-1" role="dialog"
    aria-labelledby="confirmModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                    aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="confirmModalLabel">확인</h4>
            </div>
             <div class="modal-body">
                </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default"
                    data-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="confirmModalButton">확인</button>
            </div>
        </div>
      </div>
    </div>

<div class="modal fade" id="notificationModal" tabindex="-1" role="dialog"
    aria-labelledby="notificationModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                    aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="notificationModalLabel">알림</h4>
            </div>
            <div class="modal-body">
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
     
    // 1. 새로 추가/삭제할 파일 배열
    var newFileArray = [];
    var deleteFileIdArray = [];
    
    // 2. 폼 객체
    var formObj = $("form#modifyForm");

    // 3. 새 파일 목록 갱신 함수 (기존과 동일)
    function refreshNewFileList() {
        var $newFileList = $("#newFileList");
        $newFileList.empty(); 
        
        $(newFileArray).each(function(index, file) {
             var $li = $("<li class='list-group-item'></li>");
            $li.append("<span class='glyphicon glyphicon-file'></span> ");
            $li.append(file.name);
            $li.append("<button type="
                +"'button' class='btn btn-warning btn-xs pull-right remove-new-file' "
                +"data-index='" + index + "'>X</button>");
            $newFileList.append($li);
        });
    }

    // 4. "파일 추가" <input> 변경 이벤트 (기존과 동일)
    $("input[name='uploadFiles']").on("change", function(e) {
        var files = e.target.files;
        for (var i = 0; i < files.length; i++) {
            newFileArray.push(files[i]);
        }
        $(this).val(null); 
        refreshNewFileList();
    });

    // 5. "새로 첨부할 파일" 삭제(X) 버튼 (기존과 동일)
    $("#newFileList").on("click", ".remove-new-file", function(e) {
        var indexToRemove = $(this).data("index");
        newFileArray.splice(indexToRemove, 1);
        refreshNewFileList();
    });

    // ▼▼▼ [수정] 6. "기존 첨부파일" 삭제(X) 버튼 -> confirmModal 띄우기 ▼▼▼
    $("#attachList").on("click", ".delete-file-btn", function(e) {
        e.preventDefault(); 
        var $li = $(this).closest("li"); 
        var file_id = $li.data("fileid"); 
        
        // 1. 확인 모달창 내용 설정
        $("#confirmModal .modal-title").text("파일 삭제 확인");
        $("#confirmModal .modal-body").text("이 파일을 삭제 목록에 추가하시겠습니까?\n(최종 저장은 'Modify' 버튼을 눌러야 반영됩니다.)");
        
        // 2. '확인' 버튼에 동적 이벤트 바인딩 (기존 핸들러 제거 후)
        $("#confirmModalButton").off("click").on("click", function() {
            // 'confirm'의 '확인'을 눌렀을 때의 로직
            deleteFileIdArray.push(file_id);
            $li.remove();
            $("#confirmModal").modal("hide");
        });
        
        // 3. 모달 띄우기
        $("#confirmModal").modal("show");
    });
    // ▲▲▲ [수정] ▲▲▲

    // 7. 카테고리 탭 클릭 이벤트 (기존과 동일)
    $(".nav-tabs a").on("click", function(e) {
        e.preventDefault(); 
        var tabRole = $(this).data("role");
        var postType = $(this).data("value");
        if (tabRole === 'allowed') {
            $(".nav-tabs li").removeClass("active");
            $(this).parent("li").addClass("active");
            $("#post_type_input").val(postType);
        } else if (tabRole === 'restricted') {
            $("#authModal").modal("show");
        }
    });

    // 8. 폼(form)의 data-oper 버튼 클릭 이벤트
    $('button[data-oper]').on("click", function(e){
        e.preventDefault(); 
        var operation = $(this).data("oper");
        
        if (operation === 'remove') {
            formObj.attr("action", "/post/remove").submit();
            
        // ▼▼▼ [수정] 'list' 버튼 -> confirmModal 띄우기 ▼▼▼
        } else if (operation === 'list') {
            // 1. 확인 모달창 내용 설정
            $("#confirmModal .modal-title").text("변경사항 경고");
            $("#confirmModal .modal-body").text("수정된 내용은 저장되지 않습니다.\n목록으로 이동하시겠습니까?");

            // 2. '확인' 버튼에 동적 이벤트 바인딩 (기존 핸들러 제거 후)
            $("#confirmModalButton").off("click").on("click", function() {
                $("#confirmModal").modal("hide");
                
                // 'List' 버튼의 원래 로직 (폼 전송)
                formObj.attr("action", "/post/list").attr("method","get");
           
                var pageNumTag = $("input[name='pageNum']").clone();
                var amountTag = $("input[name='amount']").clone();
                var keywordTag = $("input[name='keyword']").clone();
                var typeTag = $("input[name='type']").clone();    
                var postTypeTag = $("input[name='post_type']").clone();
                
                formObj.empty();
                formObj.append(pageNumTag);
                formObj.append(amountTag);
                formObj.append(keywordTag);
                formObj.append(typeTag);
                formObj.append(postTypeTag);
                
                formObj.submit();
            });
            
            // 3. 모달 띄우기
            $("#confirmModal").modal("show");
        // ▲▲▲ [수정] ▲▲▲
            
        } else if (operation === 'modify') {
            // 8-1. FormData 준비 (기존과 동일)
            var formData = new FormData(formObj[0]);
            formData.delete("uploadFiles");
            
            $(newFileArray).each(function(index, file) {
                formData.append("uploadFiles", file);
            });
            
            $(deleteFileIdArray).each(function(index, file_id) {
                formData.append("deleteFileIds", file_id); 
            });

            // 8-2. AJAX 전송
            $.ajax({
                type: "POST",
                url: "/post/modify", 
                data: formData,
                processData: false, 
                contentType: false, 
                
                // ▼▼▼ [수정] success 콜백 -> notificationModal 띄우기 ▼▼▼
                success: function(response) {
                    if (response === 'success') {
	                    // 'List' 버튼의 원래 로직 (폼 전송)
                      formObj.attr("action", "/post/list").attr("method","get");
         
                      var pageNumTag = $("input[name='pageNum']").clone();
                      var amountTag = $("input[name='amount']").clone();
                      var keywordTag = $("input[name='keyword']").clone();
                      var typeTag = $("input[name='type']").clone();    
                      var postTypeTag = $("input[name='post_type']").clone();
                      var resultTag = "<input type='hidden' name='result' value='success'>";
                      
                      formObj.empty();
                      formObj.append(pageNumTag);
                      formObj.append(amountTag);
                      formObj.append(keywordTag);
                      formObj.append(typeTag);
                      formObj.append(postTypeTag);
                      formObj.append(resultTag);
                      
                      formObj.submit();
                     
                    }
                },
                // ▲▲▲ [수정] ▲▲▲
                
                // ▼▼▼ [수정] error 콜백 -> notificationModal 띄우기 ▼▼▼
                error: function(xhr) {
                    // 1. (중요) '수정 성공' 시의 '닫힘' 이벤트를 제거
                    $("#notificationModal").off('hidden.bs.modal');
                    
                    // 2. 알림 모달 내용 설정 (줄바꿈을 위해 .html() 사용)
                    $("#notificationModal .modal-body").html("수정 중 오류가 발생했습니다.<br>" + xhr.responseText);
                    
                    // 3. 모달 띄우기
                    $("#notificationModal").modal("show");
                }
                // ▲▲▲ [수정] ▲▲▲
            }); // end ajax
        } // end if (operation === 'modify')
    }); // end button[data-oper] click
    
    // ⭐️ [삭제] 기존 'confirmListButton'의 클릭 이벤트 핸들러는
    // 'list' 버튼 핸들러 내부로 이동했으므로 이 블록은 삭제합니다.

}); // end $(document).ready
</script>
  
<%@include file="../includes/footer.jsp"%>