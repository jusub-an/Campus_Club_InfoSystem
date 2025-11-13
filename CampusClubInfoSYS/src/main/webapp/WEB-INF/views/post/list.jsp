<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp" %>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header"><c:out value="${clubName}" default="게시판 목록"/></h1>
		<p>회원</p>
		<p>
			<c:if test="${not empty sessionScope.user_email and sessionScope.user_email != clubInfo.leader_email}">
				<a href="../application/apply?club_id=<c:out value="${pageMaker.cri.club_id}"/>"><button>동아리 가입 신청</button></a>
			</c:if>
			
			<c:if test="${sessionScope.user_email == clubInfo.leader_email}">
				<a href="../application/list?club_id=<c:out value="${pageMaker.cri.club_id}"/>"><button>회원 관리</button></a> 
			</c:if>
		</p>
		<p>동아리 관리</p>
		<p>
			<c:if test="${sessionScope.user_email == clubInfo.leader_email}">
				<a href="../club/get?club_id=<c:out value="${pageMaker.cri.club_id}"/>"><button>정보 수정</button></a> 
			</c:if>
			<a href="../club/list"><button>동아리 목록으로 돌아가기</button></a>
		</p>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				Post List Page
				<button id='regBtn' type="button" class="btn btn-xs pull-right">Register
					New Post</button>
			</div>

			<div class="panel-body">

				<ul class="nav nav-tabs">
					<li role="presentation"
						class="${pageMaker.cri.post_type == null ? 'active' : ''}">
						<a href="전체">전체</a></li>
					<li role="presentation"
						class="${pageMaker.cri.post_type == '공지' ? 'active' : ''}">
						<a href="공지">공지</a></li>
					<li role="presentation"
						class="${pageMaker.cri.post_type == '자유' ? 'active' : ''}">
						<a href="자유">자유</a></li>
					<li role="presentation"
						class="${pageMaker.cri.post_type == '활동앨범' ? 'active' : ''}">
						<a href="활동앨범">활동앨범</a></li>
					<li role="presentation"
						class="${pageMaker.cri.post_type == '문의' ? 'active' : ''}">
						<a href="문의">문의</a></li>
				</ul>
				<br/> <table class="table table-striped table-bordered table-hover">
					<thead>
					<thead>
						<tr>
							<th>게시물 번호</th>
							<th>제목</th>
							<th>동아리 번호</th>
							<th>작성자</th>
							<th>작성일</th>
							<th>게시물 종류</th>
						</tr>
					</thead>

					<c:forEach items="${list}" var="post">
					  <tr>
					    <td><c:out value="${post.post_id}" /></td>
					    <td><a class='move' href='<c:out value="${post.post_id}"/>'><c:out value="${post.title}"/></a>&nbsp;<strong>[<c:out value="${post.reply_cnt}"/>]</strong></td>
					    <td><c:out value="${post.club_id}" /></td>
					    <td><c:out value="${post.author_email}" /></td>
					    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${post.created_date}" /></td>
					    <td><c:out value="${post.post_type}" /></td>
					  </tr>
					</c:forEach>
				</table>
				
				<div class='row'>
					<div class="col-lg-12">
						<form id="searchForm" action="/post/list" method='get'>
							<select name='type'>
								<option value="T" <c:out value="${pageMaker.cri.type == 'T' or pageMaker.cri.type == null ? 'selected' : ''}"/>>제목</option>
								<option value="C" <c:out value="${pageMaker.cri.type == 'C' ? 'selected' : ''}"/>>내용</option>
								<option value="A" <c:out value="${pageMaker.cri.type == 'A' ? 'selected' : ''}"/>>작성자</option>
								<option value="TC" <c:out value="${pageMaker.cri.type == 'TC' ? 'selected' : ''}"/>>제목 or 내용</option>
								<option value="TCA" <c:out value="${pageMaker.cri.type == 'TCA' ? 'selected' : ''}"/>>제목 or 내용 or 작성자</option>
							</select>
							<input type='text' name='keyword' value='<c:out value="${pageMaker.cri.keyword}"/>' />

							<input type='hidden' name='pageNum' value='1'> <input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
							<input type='hidden' name='post_type' value='${pageMaker.cri.post_type}'>
							<input type='hidden' name='club_id' value='${pageMaker.cri.club_id}'>

							<button class='btn btn-default'>Search</button>
						</form>
					</div>
				</div>
				<div class='pull-right'>
					<ul class="pagination">
						</ul>
				</div>

				


				<div class='pull-right'>
					<ul class="pagination">

						<%--             <c:if test="${pageMaker.prev}">
              <li class="paginate_button previous"><a href="#">Previous</a>
           </li>
            </c:if>

            <c:forEach var="num" begin="${pageMaker.startPage}"
              end="${pageMaker.endPage}">
              <li class="paginate_button"><a href="#">${num}</a></li>
            </c:forEach>

            <c:if test="${pageMaker.next}">
              <li class="paginate_button next"><a href="#">Next</a></li>
            </c:if> --%>

						<c:if test="${pageMaker.prev}">
							<li class="paginate_button previous"><a
								href="${pageMaker.startPage -1}">Previous</a></li>
						</c:if>

						<c:forEach var="num" begin="${pageMaker.startPage}"
							end="${pageMaker.endPage}">
							<li class="paginate_button  ${pageMaker.cri.pageNum == num ? "active":""} ">
								<a href="${num}">${num}</a>
							</li>
						</c:forEach>

						<c:if test="${pageMaker.next}">
							<li class="paginate_button next"><a
								href="${pageMaker.endPage +1 }">Next</a></li>
						</c:if>


					</ul>
				</div>
				</div>

			<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
				aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal"
								aria-hidden="true">&times;</button>
							<h4 class="modal-title" id="myModalLabel">Modal title</h4>
						</div>
						<div class="modal-body">처리가 완료되었습니다.</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default"
								data-dismiss="modal">Close</button>
							<button type="button" class="btn btn-primary" data-dismiss="modal">Save
								changes</button>
						</div>
					</div>
					</div>
				</div>
			<form id='actionForm' action="/post/list" method='get'>
			    <input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
			    <input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
			
			    <input type='hidden' name='type'
			        value='<c:out value="${ pageMaker.cri.type }"/>'> <input
			        type='hidden' name='keyword'
			        value='<c:out value="${ pageMaker.cri.keyword }"/>'>
			        
			    <input type='hidden' name='post_type'
			        value='<c:out value="${ pageMaker.cri.post_type }"/>'>
			        
			    <input type='hidden' name='club_id'
			        value='<c:out value="${ pageMaker.cri.club_id }"/>'> 
			
			</form>



 
		</div>
		</div>
	</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<script type="text/javascript">
	$(document)
			.ready(
					function() {

						var flashResult = '<c:out value="${result}"/>'; 
						var paramResult = '<c:out value="${param.result}"/>';
						var result = flashResult || paramResult;
						checkModal(result);
	                    // ▲▲▲ [수정] ▲▲▲

						history.replaceState({}, null, null);

						function checkModal(result) {

							if (result === '' || history.state) {
								return;
							}

							if (parseInt(result) > 0) {
								$(".modal-body").html(
										"게시글 " + parseInt(result)
												+ " 번이 등록되었습니다.");
								$("#myModal").modal("show");
							}else if (result === 'success') { // 수정 또는 삭제 성공
						        $(".modal-body").html("처리가 완료되었습니다.");
						        $("#myModal").modal("show");
						    }
						}

						$("#regBtn").on("click", function() {
						    // club_id 값을 actionForm에서 가져와 URL에 추가합니다.
						    var actionForm = $("#actionForm");
						    var currentClubId = actionForm.find("input[name='club_id']").val();

						    // club_id가 있으면 쿼리 파라미터로 추가
						    self.location = "/post/register" + (currentClubId ? "?club_id=" + currentClubId : "");

						});

						var actionForm = $("#actionForm");

						// 탭 클릭 이벤트 처리
						$(".nav-tabs a").on("click", function(e) {
							e.preventDefault(); // a 태그의 기본 이동을 막습니다.
							
							actionForm.find("input[name='post_id']").remove(); // '뒤로가기'로 남아있을 수 있는 post_id 제거
						    actionForm.attr("action", "/post/list"); // action 속성을 강제로 /post/list로 복원
							
							// 클릭한 탭의 href 값("전체", "공지" 등)을 가져옵니다.
							var postType = $(this).attr("href");
							
							if (postType === '전체') {
								// "전체" 탭이면 값을 비웁니다.
								actionForm.find("input[name='post_type']").val('');
							} else {
								// 다른 탭이면 해당 값을 설정합니다.
								actionForm.find("input[name='post_type']").val(postType);
							}
							
							// 카테고리를 변경하면 1페이지로 이동시킵니다.
							actionForm.find("input[name='pageNum']").val(1);
							// 폼을 전송하여 컨트롤러에 /post/list를 다시 요청합니다.
							actionForm.submit(); 
						});

						$(".paginate_button a").on(
								"click",
								function(e) {

									e.preventDefault();

									console.log('click');
									
									actionForm.find("input[name='post_id']").remove(); // '뒤로가기'로 남아있을 수 있는 post_id 제거
						            actionForm.attr("action", "/post/list"); // action 속성을 강제로 /post/list로 복원

									actionForm.find("input[name='pageNum']")
											.val($(this).attr("href"));
									actionForm.submit();
								});

						$(".move")
								.on(
										"click",
										function(e) {

											e.preventDefault();
											actionForm
													.append("<input type='hidden' name='post_id' value='"
															+ $(this).attr(
																	"href")
															+ "'>");
											actionForm.attr("action",
													"/post/get");
											actionForm.submit();

										});

						var searchForm = $("#searchForm");

						searchForm.on("submit", function(e) {

							var type = searchForm.find("select[name='type']").val();
							var keyword = searchForm.find("input[name='keyword']").val();

							

							if (keyword === '') {
								alert("키워드를 입력하세요.");
								searchForm.find("input[name='keyword']").focus();
								return false;
							}

							// pageNum, amount, post_type, club_id는
							// 폼 내부에 hidden input으로 이미 포함되어 있음.
							// 폼 전송 (e.preventDefault()가 없으므로 폼이 전송됨)
						});
					});
</script>




<%@include file="../includes/footer.jsp"%>