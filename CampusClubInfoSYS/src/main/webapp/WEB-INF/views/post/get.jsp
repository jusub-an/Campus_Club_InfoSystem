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

<c:if test="${sessionScope.user_email == post.author_email}">
    <button data-oper='modify' class="btn btn-default">Modify</button>
</c:if>
<button data-oper='list' class="btn btn-info">List</button>

<%-- <form id='operForm' action="/boad/modify" method="get">
  <input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
</form> --%>

<div class="panel panel-default">
    <div class="panel-heading">
        <i class="fa fa-comments fa-fw"></i> New Reply
    </div>
    <div class="panel-body">
        <div class="form-group">
            <label>Reply Content</label>
            <textarea class="form-control" rows="3" id="replyContent"></textarea>
        </div>
        <button id="replyAddBtn" class="btn btn-primary btn-sm pull-right">Submit</button>
    </div>
</div>

<div class="panel panel-default">
    <div class="panel-heading">
        <i class="fa fa-comments fa-fw"></i> Reply List
    </div>
    <div class="panel-body">
        <ul class="chat" id="replyList">
            </ul>
    </div>
</div>

<div class="modal fade" id="replyModal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">댓글 수정</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label>수정할 내용</label>
                    <textarea class="form-control" rows="3" id="replyModalContent"></textarea>
                </div>
                <input type="hidden" id="replyModalCommentId">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
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
      </div>
    </div>
  </div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<script type="text/javascript">

var replyService = (function() {

    // 1. 댓글 등록 (add)
    function add(reply, callback, error) {
        $.ajax({
            type: 'post',
            url: '/replies/new', // ReplyController의 @PostMapping("/new")
            data: JSON.stringify(reply),
            contentType: "application/json; charset=utf-8",
            success: function(result, status, xhr) {
                if (callback) { callback(result); }
            },
            error: function(xhr, status, er) {
                if (error) { error(er); }
            }
        });
    }

    // 2. 댓글 목록 (getList)
    function getList(post_id, callback, error) {
        // @GetMapping("/post/{post_id}")
        $.getJSON("/replies/post/" + post_id, function(data) {
            if (callback) { callback(data); }
        }).fail(function(xhr, status, err) {
            if (error) { error(); }
        });
    }

    // 3. 댓글 삭제 (remove)
    function remove(comment_id, callback, error) {
        $.ajax({
            type: 'delete',
            url: '/replies/' + comment_id, // @DeleteMapping("/{comment_id}")
            success: function(deleteResult, status, xhr) {
                if (callback) { callback(deleteResult); }
            },
            error: function(xhr, status, er) {
                if (error) { error(er); }
            }
        });
    }

    // 4. 댓글 수정 (update)
    function update(reply, callback, error) {
        $.ajax({
            type: 'put',
            url: '/replies/' + reply.comment_id, // @PutMapping("/{comment_id}")
            data: JSON.stringify(reply),
            contentType: "application/json; charset=utf-8",
            success: function(result, status, xhr) {
                if (callback) { callback(result); }
            },
            error: function(xhr, status, er) {
                if (error) { error(er); }
            }
        });
    }

    return {
        add: add,
        getList: getList,
        remove: remove,
        update: update
    };
})();

var loggedInUserEmail = "${sessionScope.user_email}";

$(document).ready(function() {
    
    var post_id = <c:out value="${post.post_id}" />; // ⭐️ 게시글 번호
    var replyList = $("#replyList"); // ⭐️ 댓글 목록 <ul> 태그 ID (예시)
    
    showList(); // ⭐️ 페이지 로드 시 목록 표시

    // ⭐️ 1. 댓글 목록을 그리는 함수 (대대적 수정)
    function showList() {
        
        replyService.getList(post_id, function(list) {
            
            replyList.empty(); // 목록 비우기
            
            var str = "";
            
            // ⭐️ (A) 1차 순회: 부모 댓글(parent_comment_id == null)만 먼저 그립니다.
            list.forEach(function(reply) {
                if (reply.parent_comment_id == null) {
                    str += formatReply(reply, false); // 부모용 템플릿
                }
            });
            replyList.html(str); // 1차 렌더링 (부모만)
            
            // ⭐️ (B) 2차 순회: 대댓글(parent_comment_id != null)을 부모에 붙입니다.
            list.forEach(function(reply) {
                if (reply.parent_comment_id != null) {
                    var parentLi = replyList.find("li[data-comment-id='" + reply.parent_comment_id + "']");
                    var childHtml = formatReply(reply, true); // 대댓글용 템플릿
                    
                    // 부모 <li> 안의 .child-replies <ul>에 추가
                    parentLi.find(".child-replies").append(childHtml);
                }
            });
            
        }); // end getList
    } // end showList

    // ⭐️ 2. 댓글 <li> 템플릿을 생성하는 함수
    // isChild: 대댓글인지 여부 (true/false)
    function formatReply(reply, isChild) {
        
        var loggedInUser = "${sessionScope.user_email}"; // ⭐️ 현재 로그인한 사용자
        var str = "";
        
        // 대댓글이면 CSS 클래스 추가
        var liClass = isChild ? "list-group-item child-reply" : "list-group-item";
        
        // ⭐️ data-comment-id: 댓글의 고유 ID (수정/삭제/대댓글의 기준)
        str += "<li class='" + liClass + "' data-comment-id='" + reply.comment_id + "'>";
        
        // (대댓글 표시)
        if (isChild) {
            str += "<span class='glyphicon glyphicon-share-alt'></span> ";
        }
        
        str += "<strong>" + reply.author_email + "</strong>";
        str += "<small class='pull-right'>" + reply.created_date + "</small>"; // (날짜 포맷은 reply.js에서 처리 필요)
        
        // ⭐️ (수정/삭제용) 댓글 내용 영역
        str += "<p class='reply-content'>" + reply.content + "</p>";
        
        // ⭐️ (A) 부모 댓글에만 "답글" 버튼 표시
        if (!isChild) {
            str += "<button class='btn btn-info btn-xs btn-show-reply-form'>답글</button> ";
        }
        
        // ⭐️ (B) 본인 댓글에만 "수정", "삭제" 버튼 표시
        if (reply.author_email === loggedInUser) {
            str += "<button class='btn btn-warning btn-xs btn-modify'>수정</button> ";
            str += "<button class='btn btn-danger btn-xs btn-delete'>삭제</button>";
        }

        // ⭐️ (C) 대댓글을 담을 <ul> (부모 댓글에만 생성됨)
        if (!isChild) {
            str += "<div class='reply-form-container' style='display:none; margin-top:10px;'>";
            str += "  <textarea class='form-control' rows='2'></textarea>";
            str += "  <button class='btn btn-primary btn-xs btn-register-reply' data-parent-id='" + reply.comment_id + "'>답글 등록</button>";
            str += "</div>";
            
            str += "<ul class='list-group child-replies' style='margin-top:10px;'></ul>";
        }
        
        str += "</li>";
        return str;
    }

    // ⭐️ 3. (신규) "답글" 버튼 클릭 (대댓글 폼 토글)
    replyList.on("click", ".btn-show-reply-form", function() {
        // 클릭한 버튼의 부모 <li>에서 .reply-form-container를 찾아서 토글
        $(this).closest("li").find(".reply-form-container").toggle();
    });

    // ⭐️ 4. (신규) "답글 등록" 버튼 클릭 (대댓글 등록)
    replyList.on("click", ".btn-register-reply", function() {
        var $this = $(this);
        var parent_comment_id = $this.data("parent-id");
        var content = $this.siblings("textarea").val();
        
        if (!content) {
            alert("답글 내용을 입력하세요.");
            return;
        }

        replyService.add(
            {
                post_id: post_id,
                content: content,
                parent_comment_id: parent_comment_id // ⭐️ 부모 ID 전송
            },
            function(result) {
                alert("답글이 등록되었습니다.");
                showList(); // 목록 새로고침
            }
        );
    });

    // ⭐️ 5. (기존) "댓글 등록" 버튼 (최상위 부모 댓글 등록)
    $("#replyAddBtn").on("click", function() {
        var content = $("#replyContent").val(); // ⭐️ (기존 댓글 입력창 ID 예시)

        if (!content) {
            alert("댓글 내용을 입력하세요.");
            return;
        }

        replyService.add(
            {
                post_id: post_id,
                content: content,
                parent_comment_id: null // ⭐️ 부모 ID가 없음 (null)
            },
            function(result) {
                alert("댓글이 등록되었습니다.");
                $("#replyContent").val("");
                showList(); // 목록 새로고침
            }
        );
    });

    // ⭐️ 6. (수정) "삭제" 버튼 클릭
    replyList.on("click", ".btn-delete", function() {
        var comment_id = $(this).closest("li").data("comment-id");
        
        if (confirm("정말 삭제하시겠습니까?")) {
            replyService.remove(comment_id, function(result) {
                alert("삭제되었습니다.");
                showList(); // 목록 새로고침
            });
        }
    });

    // ⭐️ 7. (수정) "수정" 버튼 클릭
    replyList.on("click", ".btn-modify", function() {
        var $li = $(this).closest("li");
        var comment_id = $li.data("comment-id");
        var $content = $li.find(".reply-content");
        
        var newContent = prompt("수정할 내용을 입력하세요.", $content.text());
        
        if (newContent) {
            replyService.update(
                {
                    comment_id: comment_id,
                    content: newContent
                }, 
                function(result) {
                    alert("수정되었습니다.");
                    showList(); // 목록 새로고침
                }
            );
        }
    });
    
    var operForm = $("#operForm"); // 폼 객체 [cite: 1]

    $("button[data-oper='modify']").on("click", function(e) {
        e.preventDefault();
        operForm.submit(); // 폼의 action="/post/modify"
    });

    $("button[data-oper='list']").on("click", function(e) {
        e.preventDefault();
        operForm.find("input[name='post_id']").remove(); // 목록으로 갈 땐 post_id 필요 없음
        operForm.attr("action", "/post/list"); // 폼 action 변경
        operForm.submit();
    });


}); // end document.ready
</script>


<%@include file="../includes/footer.jsp"%>