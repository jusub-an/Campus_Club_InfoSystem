<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>

<div class="container my-5">

    <div class="row">
        <div class="col-12">
            <h1 class="text-center mb-5 text-warning">게시글 수정</h1>
        </div>
    </div>
    
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-lg">
                <div class="card-header bg-warning text-dark text-center">
                    <h5 class="mb-0">Post Modify</h5>
                </div>
                <div class="card-body">

                    <form role="form" id="modifyForm" action="/post/modify" method="post" enctype="multipart/form-data">
                    
                        <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum }"/>'>
                        <input type='hidden' name='amount' value='<c:out value="${cri.amount }"/>'>
                        <input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
                        <input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>
                    
                        <div class="mb-3">
                            <label class="form-label">게시물 번호 (Post_id)</label> 
                            <input type="text" class="form-control" name='post_id' value='<c:out value="${post.post_id }"/>' readonly>
                        </div>
                        
                        <input type='hidden' name='club_id' value='<c:out value="${post.club_id }"/>'>
                        
                        <div class="mb-4">
                            <label class="form-label">게시판 선택</label>
                            <ul class="nav nav-pills card-header-pills">
                                <c:if test="${sessionScope.user_email == clubInfo.leader_email}">
                                    <li class="nav-item">
                                        <a class="nav-link ${post.post_type == '공지' ? 'active' : ''}" href="#" data-role="allowed" data-value="공지">공지</a>
                                    </li>
                                </c:if>
                                <li class="nav-item">
                                    <a class="nav-link ${post.post_type == '자유' ? 'active' : ''}" href="#" data-role="allowed" data-value="자유">자유</a>
                                </li>
                                <c:if test="${sessionScope.user_email == clubInfo.leader_email}">
                                    <li class="nav-item">
                                        <a class="nav-link ${post.post_type == '활동앨범' ? 'active' : ''}" href="#" data-role="allowed" data-value="활동앨범">활동앨범</a>
                                    </li>
                                </c:if>
                                <li class="nav-item">
                                    <a class="nav-link ${post.post_type == '문의' ? 'active' : ''}" href="#" data-role="allowed" data-value="문의">문의</a>
                                </li>
                            </ul>
                        </div>
                        
                        <input type="hidden" id="post_type_input" name="post_type" value="<c:out value='${post.post_type}'/>">
                        
                        <div class="mb-3">
                            <label class="form-label">제목 (Title)</label> 
                            <input type="text" class="form-control" name='title' value='<c:out value="${post.title }"/>'>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">내용 (Text area)</label>
                            <textarea class="form-control" rows="6" name='content'><c:out value="${post.content}"/></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">작성자 (Writer)</label> 
                            <input type="text" class="form-control" name='writer' value='<c:out value="${post.author_email}"/>' readonly>            
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label">작성일 (RegDate)</label> 
                            <input type="text" class="form-control" name='regDate' value='<fmt:formatDate pattern = "yyyy/MM/dd HH:mm" value = "${post.created_date}" />'  readonly>            
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label">기존 첨부파일</label>
                            <div class="card card-body bg-light">
                                <ul class="list-group list-group-flush" id="attachList">
                                    <c:forEach items="${post.attachList}" var="file">
                                        <li class="list-group-item d-flex justify-content-between align-items-center" data-fileid="${file.file_id}">
                                             <div class="text-truncate">
                                                 <i class="bi bi-file-earmark-arrow-down-fill me-2 text-info"></i>
                                                 <a href="/post/download?file_id=${file.file_id}" class="text-decoration-none">
                                                     <c:out value="${file.file_name}" />
                                                 </a>
                                             </div>
                                             <button type="button" class="btn btn-danger btn-sm delete-file-btn">
                                                 <i class="bi bi-x-lg"></i>
                                             </button>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label">새 파일 추가</label>
                            <input type="file" class="form-control" name='uploadFiles' multiple>
                        </div>
                        
                        <div class="mb-4" id="newFileListContainer">
                            <label class="form-label">새로 첨부할 파일 (미리보기)</label>
                            <div class="card card-body bg-light">
                                <ul class="list-group list-group-flush" id="newFileList">
                                    </ul>
                                <p class="text-muted small mt-2 mb-0" id="newFilePlaceholder" style="<c:if test="${!empty newFileList}">display:none;</c:if>">새로 추가된 파일이 없습니다.</p>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end gap-2">
                            <button type="submit" data-oper='modify' class="btn btn-warning text-dark"><i class="bi bi-pencil-square me-1"></i> Modify</button>
                            <button type="submit" data-oper='remove' class="btn btn-danger"><i class="bi bi-trash-fill me-1"></i> Remove</button>
                            <button type="submit" data-oper='list' class="btn btn-info text-white"><i class="bi bi-list-columns-reverse me-1"></i> List</button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="authModal" tabindex="-1" aria-labelledby="authModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title" id="authModalLabel"><i class="bi bi-exclamation-triangle-fill me-1"></i> 권한 알림</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    동아리장만 작성 가능한 게시판입니다.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="confirmModalLabel"><i class="bi bi-question-circle-fill me-1"></i> 확인</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" id="confirmModalButton">확인</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="notificationModal" tabindex="-1" aria-labelledby="notificationModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title" id="notificationModalLabel"><i class="bi bi-info-circle-fill me-1"></i> 알림</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
     
    // 1. 새로 추가/삭제할 파일 배열
    var newFileArray = [];
    var deleteFileIdArray = [];
    
    // 2. 폼 객체
    var formObj = $("form#modifyForm");
    var confirmModal = new bootstrap.Modal(document.getElementById('confirmModal'));
    var notificationModal = new bootstrap.Modal(document.getElementById('notificationModal'));

    // 3. 새 파일 목록 갱신 함수
    function refreshNewFileList() {
        var $newFileList = $("#newFileList");
        $newFileList.empty(); 
        
        if (newFileArray.length === 0) {
            $("#newFilePlaceholder").show();
        } else {
             $("#newFilePlaceholder").hide();
            $(newFileArray).each(function(index, file) {
                 var $li = $("<li class='list-group-item d-flex justify-content-between align-items-center'></li>");
                $li.append("<div class='text-truncate'><i class='bi bi-file-earmark me-2 text-success'></i> " + file.name + "</div>");
                $li.append("<button type='button' class='btn btn-warning btn-sm remove-new-file' data-index='" + index + "'><i class='bi bi-x-lg'></i></button>");
                $newFileList.append($li);
            });
        }
    }

    // 4. "파일 추가" <input> 변경 이벤트
    $("input[name='uploadFiles']").on("change", function(e) {
        var files = e.target.files;
        for (var i = 0; i < files.length; i++) {
            newFileArray.push(files[i]);
        }
        $(this).val(null); 
        refreshNewFileList();
    });

    // 5. "새로 첨부할 파일" 삭제(X) 버튼
    $("#newFileList").on("click", ".remove-new-file", function(e) {
        var indexToRemove = $(this).data("index");
        newFileArray.splice(indexToRemove, 1);
        refreshNewFileList();
    });

    // 6. "기존 첨부파일" 삭제(X) 버튼 -> confirmModal 띄우기
    $("#attachList").on("click", ".delete-file-btn", function(e) {
        e.preventDefault(); 
        var $li = $(this).closest("li"); 
        var file_id = $li.data("fileid"); 
        
        // 1. 확인 모달창 내용 설정
        $("#confirmModal .modal-header").removeClass("bg-danger").addClass("bg-warning text-dark");
        $("#confirmModal .modal-title").html('<i class="bi bi-question-circle-fill me-1"></i> 파일 삭제 확인');
        $("#confirmModal .modal-body").html("이 파일을 삭제 목록에 추가하시겠습니까?<br>(최종 저장은 'Modify' 버튼을 눌러야 반영됩니다.)");
        
        // 2. '확인' 버튼에 동적 이벤트 바인딩
        $("#confirmModalButton").off("click").on("click", function() {
            deleteFileIdArray.push(file_id);
            $li.remove();
            confirmModal.hide();
        });
        
        // 3. 모달 띄우기
        confirmModal.show();
    });

    // 7. 카테고리 탭 클릭 이벤트
    $(".nav-pills a").on("click", function(e) {
        e.preventDefault(); 
        var tabRole = $(this).data("role");
        var postType = $(this).data("value");
        if (tabRole === 'allowed') {
            $(".nav-pills a").removeClass("active");
            $(this).addClass("active");
            $("#post_type_input").val(postType);
        } else if (tabRole === 'restricted') {
            new bootstrap.Modal(document.getElementById('authModal')).show();
        }
    });

    // 8. 폼(form)의 data-oper 버튼 클릭 이벤트
    $('button[data-oper]').on("click", function(e){
        e.preventDefault(); 
        var operation = $(this).data("oper");
        
        if (operation === 'remove') {
            // 삭제 확인은 폼 제출 시 브라우저 기본 confirm을 사용하거나 별도 모달을 띄울 수 있음.
            // 여기서는 깔끔하게 목록으로 이동하도록 confirmModal을 사용합니다.
            
            // 1. 확인 모달창 내용 설정
            $("#confirmModal .modal-header").removeClass("bg-warning text-dark").addClass("bg-danger text-white");
            $("#confirmModal .modal-title").html('<i class="bi bi-trash-fill me-1"></i> 게시글 삭제 확인');
            $("#confirmModal .modal-body").html("정말로 이 게시글을 삭제하시겠습니까?");

            // 2. '확인' 버튼에 동적 이벤트 바인딩
            $("#confirmModalButton").off("click").on("click", function() {
                confirmModal.hide();
                formObj.attr("action", "/post/remove").attr("method","post").submit();
            });
            // 3. 모달 띄우기
            confirmModal.show();

        } else if (operation === 'list') {
            // 변경사항 경고 후 목록으로 이동
            
            // 1. 확인 모달창 내용 설정
            $("#confirmModal .modal-header").removeClass("bg-danger text-white").addClass("bg-warning text-dark");
            $("#confirmModal .modal-title").html('<i class="bi bi-exclamation-triangle-fill me-1"></i> 변경사항 경고');
            $("#confirmModal .modal-body").html("수정된 내용은 저장되지 않습니다.<br>목록으로 이동하시겠습니까?");

            // 2. '확인' 버튼에 동적 이벤트 바인딩
            $("#confirmModalButton").off("click").on("click", function() {
                confirmModal.hide();
                
                // 'List' 버튼의 원래 로직 (폼 전송)
                formObj.attr("action", "/post/list").attr("method","get");
           
                var pageNumTag = $("input[name='pageNum']").clone();
                var amountTag = $("input[name='amount']").clone();
                var keywordTag = $("input[name='keyword']").clone();
                var typeTag = $("input[name='type']").clone();
                var postTypeTag = $("input[name='post_type']").clone();
                var clubIdTag = $("input[name='club_id']").clone();
                
                formObj.empty();
                formObj.append(pageNumTag);
                formObj.append(amountTag);
                formObj.append(keywordTag);
                formObj.append(typeTag);
                formObj.append(postTypeTag);
                formObj.append(clubIdTag);
                
                formObj.submit();
            });
            // 3. 모달 띄우기
            confirmModal.show();
            
        } else if (operation === 'modify') {
            // 8-1. FormData 준비 (파일 포함)
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
                
                // success 콜백: 성공 시 목록 페이지로 이동
                success: function(response) {
                    if (response === 'success') {
                      // 'List' 버튼의 원래 로직 재사용
                      formObj.attr("action", "/post/list").attr("method","get");
                      
                      var pageNumTag = $("input[name='pageNum']").clone();
                      var amountTag = $("input[name='amount']").clone();
                      var keywordTag = $("input[name='keyword']").clone();
                      var typeTag = $("input[name='type']").clone();    
                      var postTypeTag = $("input[name='post_type']").clone();
                      var clubIdTag = $("input[name='club_id']").clone();
                      var resultTag = "<input type='hidden' name='result' value='success'>";

                      formObj.empty();
                      formObj.append(pageNumTag);
                      formObj.append(amountTag);
                      formObj.append(keywordTag);
                      formObj.append(typeTag);
                      formObj.append(postTypeTag);
                      formObj.append(clubIdTag);
                      formObj.append(resultTag);
                      
                      formObj.submit();
                    }
                },
                
                // error 콜백: 오류 알림 모달 띄우기
                error: function(xhr) {
                    $("#notificationModal .modal-header").removeClass("bg-info").addClass("bg-danger");
                    $("#notificationModal .modal-title").html('<i class="bi bi-x-circle-fill me-1"></i> 오류');
                    $("#notificationModal .modal-body").html("수정 중 오류가 발생했습니다.<br>" + xhr.responseText);
                    notificationModal.show();
                }
            });
        }
    });
});
</script>
</body>
</html>