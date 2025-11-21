<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 상세</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        .child-reply {
            /* 대댓글을 위한 약간의 들여쓰기 */
            margin-left: 20px; 
            border-left: 3px solid #0dcaf0; /* info 색상 */
            background-color: #f8f9fa; /* light 배경 */
        }
        .reply-content {
            margin-top: 5px;
            margin-bottom: 5px;
        }
    </style>
</head>
<body>

<div class="container my-5">

    <div class="row">
        <div class="col-12">
            <h1 class="text-center mb-5 text-success">게시글 상세</h1>
        </div>
    </div>
    
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-lg mb-4">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">
                        <i class="bi bi-file-text-fill me-2"></i> 
                        <c:out value="${post.title }"/>
                    </h5>
                </div>
                <div class="card-body">
                    
                    <dl class="row mb-0">
                        <dt class="col-sm-3">게시물 종류</dt>
                        <dd class="col-sm-9"><span class="badge bg-info"><c:out value="${post.post_type}"/></span></dd>
                        
                        <dt class="col-sm-3">작성자</dt>
                        <dd class="col-sm-9"><c:out value="${post.author_email }"/></dd>

                        <dt class="col-sm-3">작성일</dt>
                        <dd class="col-sm-9"><fmt:formatDate value="${post.created_date}" pattern="yyyy-MM-dd HH:mm:ss"/></dd>
                    </dl>
                    <hr>
                    
                    <div class="mb-4 p-3 border rounded bg-light">
                        <p style="white-space: pre-wrap;"><c:out value="${post.content}" /></p>
                    </div>

                    <div class="mb-4">
                        <h6 class="text-secondary mb-2"><i class="bi bi-paperclip me-1"></i> 첨부파일</h6>
                        <div classcard card-body bg-light p-2">
                            <ul class="list-group list-group-flush" id="attachList">
                                <c:choose>
                                    <c:when test="${not empty post.attachList}">
                                        <c:forEach items="${post.attachList}" var="file">
                                            <li class="list-group-item d-flex align-items-center">
                                                <i class="bi bi-file-earmark-arrow-down-fill me-2 text-primary"></i>
                                                <a href="/post/download?file_id=${file.file_id}" class="text-decoration-none">
                                                    <c:out value="${file.file_name}" />
                                                </a>
                                            </li>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="list-group-item text-muted">첨부된 파일이 없습니다.</li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-end gap-2">
                        <c:if test="${sessionScope.user_email == post.author_email}">
                            <button data-oper='modify' class="btn btn-warning text-dark"><i class="bi bi-pencil-square me-1"></i> Modify</button>
                        </c:if>
                        <button data-oper='list' class="btn btn-info text-white"><i class="bi bi-list-columns-reverse me-1"></i> List</button>
                    </div>

                </div>
            </div>
            
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-primary text-white">
                    <i class="bi bi-chat-dots-fill me-1"></i> 새 댓글
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label for="replyContent" class="form-label">댓글 내용</label>
                        <textarea class="form-control" rows="3" id="replyContent" placeholder="댓글을 입력하세요."></textarea>
                    </div>
                    <button id="replyAddBtn" class="btn btn-primary btn-sm float-end">
                        <i class="bi bi-chat-dots me-1"></i> 등록
                    </button>
                </div>
            </div>

            <div class="card shadow-sm">
                <div class="card-header bg-secondary text-white">
                    <i class="bi bi-chat-square-text-fill me-1"></i> 댓글 목록
                </div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush" id="replyList">
                        </ul>
                </div>
            </div>

        </div>
    </div>
    
    <div class="modal fade" id="replyModal" tabindex="-1" aria-labelledby="replyModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title" id="replyModalLabel"><i class="bi bi-pencil-square me-1"></i> 댓글 수정</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="replyModalContent" class="form-label">수정할 내용</label>
                        <textarea class="form-control" rows="3" id="replyModalContent"></textarea>
                    </div>
                    <input type="hidden" id="replyModalCommentId">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" id="replyModalSaveBtn">저장</button>
                </div>
            </div>
        </div>
    </div>

    <form id='operForm' action="/post/modify" method="get">
      <input type='hidden' id='post_id' name='post_id' value='<c:out value="${post.post_id}"/>'>
      <input type='hidden' name='club_id' value='<c:out value="${post.club_id}"/>'>
      <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
      <input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
      <input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'>
      <input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>  
      <input type='hidden' name='post_type' value='<c:out value="${cri.post_type}"/>'>
    </form>


</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
// 댓글 서비스 모듈 (기존과 동일)
var replyService = (function() {
    function add(reply, callback, error) {
        $.ajax({
            type: 'post',
            url: '/replies/new', 
            data: JSON.stringify(reply),
            contentType: "application/json; charset=utf-8",
            success: function(result, status, xhr) { if (callback) { callback(result); } },
            error: function(xhr, status, er) { if (error) { error(er); } }
        });
    }

    function getList(post_id, callback, error) {
        $.getJSON("/replies/post/" + post_id, function(data) {
            if (callback) { callback(data); }
        }).fail(function(xhr, status, err) {
            if (error) { error(); }
        });
    }

    function remove(comment_id, callback, error) {
        $.ajax({
            type: 'delete',
            url: '/replies/' + comment_id, 
            success: function(deleteResult, status, xhr) { if (callback) { callback(deleteResult); } },
            error: function(xhr, status, er) { if (error) { error(er); } }
        });
    }

    function update(reply, callback, error) {
        $.ajax({
            type: 'put',
            url: '/replies/' + reply.comment_id, 
            data: JSON.stringify(reply),
            contentType: "application/json; charset=utf-8",
            success: function(result, status, xhr) { if (callback) { callback(result); } },
            error: function(xhr, status, er) { if (error) { error(er); } }
        });
    }

    return { add: add, getList: getList, remove: remove, update: update };
})();

var loggedInUserEmail = "${sessionScope.user_email}";

$(document).ready(function() {
    
    var post_id = <c:out value="${post.post_id}" />; 
    var replyList = $("#replyList"); 
    
    showList(); // 페이지 로드 시 목록 표시

    // ⭐️ 1. 댓글 목록을 그리는 함수
    function showList() {
        
        replyService.getList(post_id, function(list) {
            
            replyList.empty(); 
            var str = "";
            
            // (A) 1차 순회: 부모 댓글(parent_comment_id == null)만 먼저 그립니다.
            list.forEach(function(reply) {
                if (reply.parent_comment_id == null) {
                    str += formatReply(reply, false); 
                }
            });
            replyList.html(str); // 1차 렌더링 (부모만)
            
            // (B) 2차 순회: 대댓글(parent_comment_id != null)을 부모에 붙입니다.
            list.forEach(function(reply) {
                if (reply.parent_comment_id != null) {
                    var parentLi = replyList.find("li[data-comment-id='" + reply.parent_comment_id + "']");
                    var childHtml = formatReply(reply, true); 
                    
                    // 부모 <li> 안의 .child-replies <ul>에 추가
                    parentLi.find(".child-replies").append(childHtml);
                }
            });
            
        });
    } 

    // ⭐️ 2. 댓글 <li> 템플릿을 생성하는 함수
    function formatReply(reply, isChild) {
        
        var loggedInUser = "${sessionScope.user_email}";
        var str = "";
        
        var liClass = isChild ? "list-group-item child-reply" : "list-group-item";
        
        str += "<li class='" + liClass + "' data-comment-id='" + reply.comment_id + "'>";
        
        // (대댓글 표시)
        if (isChild) {
            str += "<i class='bi bi-arrow-return-right me-1'></i> ";
        }
        
        str += "<strong>" + reply.author_email + "</strong>";
        str += "<small class='float-end text-muted'>" + reply.created_date + "</small>"; 
        
        // 댓글 내용 영역
        str += "<p class='reply-content'>" + reply.content + "</p>";
        
        str += "<div class='d-flex gap-2 mb-2'>";
        // (A) 부모 댓글에만 "답글" 버튼 표시
        if (!isChild) {
            str += "<button class='btn btn-info btn-xs btn-show-reply-form'><i class='bi bi-reply-fill'></i> 답글</button>";
        }
        
        // (B) 본인 댓글에만 "수정", "삭제" 버튼 표시
        if (reply.author_email === loggedInUser) {
            str += "<button class='btn btn-warning btn-xs btn-modify'><i class='bi bi-pencil-square'></i> 수정</button>"; 
            str += "<button class='btn btn-danger btn-xs btn-delete'><i class='bi bi-trash-fill'></i> 삭제</button>";
        }
        str += "</div>";

        // (C) 대댓글 폼과 목록 (부모 댓글에만 생성됨)
        if (!isChild) {
            str += "<div class='reply-form-container border p-2 bg-white rounded' style='display:none; margin-top:10px;'>";
            str += "  <textarea class='form-control mb-2' rows='2' placeholder='답글 내용을 입력하세요.'></textarea>";
            str += "  <button class='btn btn-primary btn-xs btn-register-reply' data-parent-id='" + reply.comment_id + "'>답글 등록</button>";
            str += "</div>";
            
            str += "<ul class='list-group list-group-flush child-replies mt-2'></ul>";
        }
        
        str += "</li>";
        return str;
    }

    // 3. (신규) "답글" 버튼 클릭 (대댓글 폼 토글)
    replyList.on("click", ".btn-show-reply-form", function() {
        $(this).closest("li").find(".reply-form-container").toggle();
    });

    // 4. (신규) "답글 등록" 버튼 클릭 (대댓글 등록)
    replyList.on("click", ".btn-register-reply", function() {
        var $this = $(this);
        var parent_comment_id = $this.data("parent-id");
        var content = $this.siblings("textarea").val().trim();
        
        if (!content) {
            alert("답글 내용을 입력하세요.");
            return;
        }

        replyService.add(
            { post_id: post_id, content: content, parent_comment_id: parent_comment_id },
            function(result) {
                alert("답글이 등록되었습니다.");
                showList(); 
            }
        );
    });

    // 5. (기존) "댓글 등록" 버튼 (최상위 부모 댓글 등록)
    $("#replyAddBtn").on("click", function() {
        var content = $("#replyContent").val().trim(); 

        if (!content) {
            alert("댓글 내용을 입력하세요.");
            return;
        }

        replyService.add(
            { post_id: post_id, content: content, parent_comment_id: null },
            function(result) {
                alert("댓글이 등록되었습니다.");
                $("#replyContent").val("");
                showList(); 
            }
        );
    });

    // 6. (수정) "삭제" 버튼 클릭
    replyList.on("click", ".btn-delete", function() {
        var comment_id = $(this).closest("li").data("comment-id");
        
        if (confirm("정말 삭제하시겠습니까?")) {
            replyService.remove(comment_id, function(result) {
                alert("삭제되었습니다.");
                showList(); 
            });
        }
    });

    // 7. (수정) "수정" 버튼 클릭
    replyList.on("click", ".btn-modify", function() {
        var $li = $(this).closest("li");
        var comment_id = $li.data("comment-id");
        var $content = $li.find(".reply-content");
        
        var newContent = prompt("수정할 내용을 입력하세요.", $content.text());
        
        if (newContent) {
            replyService.update(
                { comment_id: comment_id, content: newContent }, 
                function(result) {
                    alert("수정되었습니다.");
                    showList(); 
                }
            );
        }
    });

    var operForm = $("#operForm"); 

    // "Modify" 버튼 (수정 페이지로 이동)
    $("button[data-oper='modify']").on("click", function(e) {
        e.preventDefault();
        operForm.submit(); 
    });

    // "List" 버튼 (목록 페이지로 이동)
    $("button[data-oper='list']").on("click", function(e) {
        e.preventDefault();
        operForm.find("input[name='post_id']").remove(); 
        operForm.attr("action", "/post/list"); 
        operForm.submit();
    });
}); 
</script>
</body>
</html>