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
                    
                    <c:choose>
                        <c:when test="${post.post_type == '문의' or sessionScope.user_email == clubInfo.leader_email or isMember}">
                            <div class="mb-3">
                                <label for="replyContent" class="form-label">댓글 내용</label>
                                <textarea class="form-control" rows="3" id="replyContent" placeholder="댓글을 입력하세요."></textarea>
                            </div>
                            <button id="replyAddBtn" class="btn btn-primary btn-sm float-end">
                                <i class="bi bi-chat-dots me-1"></i> 등록
                            </button>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-secondary text-center mb-0">
                                <i class="bi bi-lock-fill"></i> 동아리 회원만 댓글을 작성할 수 있습니다.
                            </div>
                        </c:otherwise>
                    </c:choose>

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

    var postType = '<c:out value="${post.post_type}"/>';
    var isLeader = ${empty isLeader ? 'false' : isLeader}; 
    var isMember = ${empty isMember ? 'false' : isMember};
    var loggedInUser = "${sessionScope.user_email}";
    
    // ⭐️ [추가] 들여쓰기를 위한 CSS 스타일 동적 추가
    $("<style>")
        .prop("type", "text/css")
        .html("\
            .reply-tree ul { list-style: none; padding-left: 0; } \
            .reply-tree ul ul { margin-left: 30px; border-left: 2px solid #e9ecef; } \
            .reply-tree li { position: relative; } \
        ")
        .appendTo("head");

    showList(); 
    
    function canReply() {
        if (postType === '문의') return true;
        if (isLeader) return true;
        if (isMember) return true;
        return false;
    }

    // ⭐️ 1. (수정) 메인 목록 출력 함수
    function showList() {
        replyService.getList(post_id, function(list) {
            replyList.empty();
            
            if (list == null || list.length === 0) {
                replyList.html("<li class='list-group-item text-center text-muted'>등록된 댓글이 없습니다.</li>");
                return;
            }

            // 1. 평면 리스트를 트리 구조로 변환
            var replyTree = buildCommentTree(list);
            
            // 2. 재귀적으로 HTML 생성
            var htmlStr = "<div class='reply-tree'><ul>";
            htmlStr += recursiveRender(replyTree);
            htmlStr += "</ul></div>";
            
            replyList.html(htmlStr);
        });
    }

    // ⭐️ [신규] 리스트 -> 트리 변환 헬퍼 함수
    function buildCommentTree(list) {
        var map = {};
        var roots = [];
        
        // 1. 모든 댓글을 Map에 저장 (key: comment_id)
        list.forEach(function(reply) {
            reply.children = []; // 자식을 담을 배열 초기화
            map[reply.comment_id] = reply;
        });
        
        // 2. 부모-자식 연결
        list.forEach(function(reply) {
            if (reply.parent_comment_id != null && map[reply.parent_comment_id]) {
                // 부모가 있으면 부모의 children 배열에 추가
                map[reply.parent_comment_id].children.push(reply);
            } else {
                // 부모가 없으면 최상위 루트
                roots.push(reply);
            }
        });
        return roots;
    }

    // ⭐️ [신규] 재귀적 렌더링 함수
    function recursiveRender(nodes) {
        var html = "";
        
        nodes.forEach(function(reply) {
            // HTML 생성 (formatReplyBody 함수로 분리)
            html += formatReplyBody(reply);
            
            // 자식이 있다면 재귀 호출로 내부에 <ul> 생성
            if (reply.children && reply.children.length > 0) {
                html += "<ul>";
                html += recursiveRender(reply.children); // 자기 자신을 다시 호출 (재귀)
                html += "</ul>";
            }
            
            html += "</li>"; // formatReplyBody에서 연 <li>를 여기서 닫음
        });
        
        return html;
    }

    // ⭐️ [신규] 댓글 1개 내용 생성 함수 (<li> 시작 태그 포함, 닫는 태그 제외)
    function formatReplyBody(reply) {
        var str = "";
        var liClass = "list-group-item";
        
        // 들여쓰기 효과는 CSS(ul ul margin-left)로 처리하므로 child-reply 클래스는 제거해도 됨
        
        str += "<li class='" + liClass + "' data-comment-id='" + reply.comment_id + "'>";
        
        var roleBadge = "";
        if (reply.writer_role === '동아리장') {
            roleBadge = " <span class='badge rounded-pill bg-success'>동아리장</span>";
        } else if (reply.writer_role === '회원') {
            roleBadge = " <span class='badge rounded-pill bg-primary'>회원</span>";
        } else {
            roleBadge = " <span class='badge rounded-pill bg-secondary'>비회원</span>";
        }
        
        str += "<div>";
        // 대댓글인 경우 아이콘 표시 (선택 사항)
        if (reply.parent_comment_id != null) {
            str += "<i class='bi bi-arrow-return-right text-secondary me-1'></i>";
        }
        str += "<strong>" + reply.author_email + "</strong>" + roleBadge;
        str += "<small class='float-end text-muted'>" + displayTime(reply.created_date) + "</small>"; 
        str += "</div>";
        
        str += "<p class='reply-content mt-2'>" + reply.content + "</p>";
        
        str += "<div class='d-flex gap-2 mb-2'>";
        
        // 답글 버튼
        if (canReply()) { 
            str += "<button class='btn btn-info btn-xs btn-show-reply-form'><i class='bi bi-reply-fill'></i> 답글</button>";
        }
        
        // 수정/삭제 버튼
        if (reply.author_email === loggedInUser) {
            str += "<button class='btn btn-warning btn-xs btn-modify'><i class='bi bi-pencil-square'></i> 수정</button>";
            str += "<button class='btn btn-danger btn-xs btn-delete'><i class='bi bi-trash-fill'></i> 삭제</button>";
        }
        str += "</div>";

        // 답글 입력 폼 (숨김 상태)
        if (canReply()) {
            str += "<div class='reply-form-container border p-2 bg-white rounded' style='display:none; margin-top:10px;'>";
            str += "  <textarea class='form-control mb-2' rows='2' placeholder='답글 내용을 입력하세요.'></textarea>";
            str += "  <button class='btn btn-primary btn-xs btn-register-reply' data-parent-id='" + reply.comment_id + "'>답글 등록</button>";
            str += "</div>";
        }
        
        // 닫는 </li> 태그는 recursiveRender에서 처리함 (자식 ul을 포함해야 하기 때문)
        return str;
    }
    
 // [추가] 날짜 포맷팅 함수
    function displayTime(timeValue) {
        var dateObj = new Date(timeValue);
        var today = new Date();
        
        var year = dateObj.getFullYear();
        var month = dateObj.getMonth() + 1;
        var date = dateObj.getDate();
        var hour = dateObj.getHours();
        var minute = dateObj.getMinutes();
        var second = dateObj.getSeconds();

        // 24시간 이내면 시간만, 지나면 날짜 표시 (선택사항. 원치 않으면 무조건 날짜 포맷 리턴하면 됨)
        // 여기서는 요청하신 대로 날짜 포맷으로 리턴합니다.
        return [year, '/', (month > 9 ? '' : '0') + month, '/', (date > 9 ? '' : '0') + date, ' ', 
                (hour > 9 ? '' : '0') + hour, ':', (minute > 9 ? '' : '0') + minute].join('');
    }

 // ⭐️ 2. 댓글 <li> 템플릿을 생성하는 함수
    function formatReply(reply, isChild) {
        
        var str = "";
        var liClass = isChild ? "list-group-item child-reply" : "list-group-item";
        
        // li 태그 시작
        str += "<li class='" + liClass + "' data-comment-id='" + reply.comment_id + "'>";
        
        // (대댓글 아이콘)
        if (isChild) {
            str += "<i class='bi bi-arrow-return-right me-1'></i> ";
        }
        
        var roleBadge = "";
        if (reply.writer_role === '동아리장') {
            roleBadge = " <span class='badge rounded-pill bg-success'>동아리장</span>";
        } else if (reply.writer_role === '회원') {
            roleBadge = " <span class='badge rounded-pill bg-primary'>회원</span>";
        } else {
            roleBadge = " <span class='badge rounded-pill bg-secondary'>비회원</span>";
        }
        
        str += "<strong>" + reply.author_email + "</strong>" + roleBadge;
        
        str += "<small class='float-end text-muted'>" + displayTime(reply.created_date) + "</small>"; 
        
        // 댓글 내용
        str += "<p class='reply-content'>" + reply.content + "</p>";
        
        str += "<div class='d-flex gap-2 mb-2'>";
        
        // 답글 버튼 (권한 체크)
        if (canReply()) { 
            str += "<button class='btn btn-info btn-xs btn-show-reply-form'><i class='bi bi-reply-fill'></i> 답글</button>";
        }
        
        // 수정/삭제 버튼
        if (reply.author_email === loggedInUser) {
            str += "<button class='btn btn-warning btn-xs btn-modify'><i class='bi bi-pencil-square'></i> 수정</button>";
            str += "<button class='btn btn-danger btn-xs btn-delete'><i class='bi bi-trash-fill'></i> 삭제</button>";
        }
        str += "</div>";

        // 답글 입력 폼
        if (canReply()) {
            str += "<div class='reply-form-container border p-2 bg-white rounded' style='display:none; margin-top:10px;'>";
            str += "  <textarea class='form-control mb-2' rows='2' placeholder='답글 내용을 입력하세요.'></textarea>";
            str += "  <button class='btn btn-primary btn-xs btn-register-reply' data-parent-id='" + reply.comment_id + "'>답글 등록</button>";
            str += "</div>";
        }
        
        // ⭐️ [수정] 자식을 붙일 <ul> 컨테이너 생성 로직 변경
        // 기존: if (!isChild) { ... } 
        // 변경: 조건 없이 모든 댓글에 하위 리스트 컨테이너를 생성합니다. 
        // (이렇게 해야 답글(Level 2) 밑에 답글(Level 3)이 붙을 수 있습니다.)
        str += "<ul class='list-group list-group-flush child-replies mt-2'></ul>";

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