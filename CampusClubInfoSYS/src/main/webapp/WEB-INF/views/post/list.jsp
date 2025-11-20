<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시판 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        /* 추가적인 작은 스타일 */
        .post-list-card .card-header .btn {
            line-height: 1; /* 버튼 높이 맞추기 */
        }
        .pagination li.active a {
            color: #fff !important;
            background-color: #0d6efd !important;
            border-color: #0d6efd !important;
        }
    </style>
</head>
<body>
<div class="container my-5">

    <h1 class="text-center mb-4 text-primary">
    	<c:out value="${clubName}" default="게시판 목록"/>
    </h1>
    
    <div class="row mb-4">
        <div class="col-lg-12">
            <div class="card shadow-sm p-3 mb-3">
                <div class="d-flex flex-wrap gap-3 align-items-center">
                    <c:if test="${not empty sessionScope.user_email and sessionScope.user_email != clubInfo.leader_email}">
                        <a href="../application/apply?club_id=<c:out value="${pageMaker.cri.club_id}"/>" class="btn btn-sm btn-outline-success">
                            <i class="bi bi-person-plus-fill me-1"></i> 동아리 가입 신청
                        </a>
                    </c:if>
                    
                    <c:if test="${sessionScope.user_email == clubInfo.leader_email}">
                        <a href="../application/list?club_id=<c:out value="${pageMaker.cri.club_id}"/>" class="btn btn-sm btn-success">
                            <i class="bi bi-people-fill me-1"></i> 회원 관리
                        </a>
                    </c:if>
                    
                    <c:if test="${sessionScope.user_email == clubInfo.leader_email}">
                        <a href="../club/get?club_id=<c:out value="${pageMaker.cri.club_id}"/>" class="btn btn-sm btn-info text-white">
                            <i class="bi bi-pencil-square me-1"></i> 정보 수정
                        </a> 
                        <form action="../club/remove" method="post" class="d-inline"
                              onsubmit="return confirm('정말 이 동아리를 삭제하시겠습니까?');">
                            <input type="hidden" name="club_id" value="<c:out value='${pageMaker.cri.club_id}'/>" />
                            <button type="submit" class="btn btn-sm btn-danger">
                                <i class="bi bi-trash-fill me-1"></i> 동아리 삭제
                            </button>
                        </form>
                    </c:if>

                    <a href="../club/list" class="btn btn-sm btn-outline-secondary ms-auto">
                        <i class="bi bi-list-columns-reverse me-1"></i> 동아리 목록으로 돌아가기
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="row">
        <div class="col-lg-12">
            <div class="card shadow post-list-card">
                <div class="card-header bg-light d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 text-secondary">게시물 목록</h5>
                    <button id='regBtn' type="button" class="btn btn-primary btn-sm">
                        <i class="bi bi-pencil-fill me-1"></i> 새 글 등록
                    </button>
                </div>

                <div class="card-body">

                    <ul class="nav nav-tabs mb-4">
                        <li class="nav-item">
                            <a class="nav-link ${pageMaker.cri.post_type == null ? 'active' : ''}" href="전체">전체</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${pageMaker.cri.post_type == '공지' ? 'active' : ''}" href="공지">공지</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${pageMaker.cri.post_type == '자유' ? 'active' : ''}" href="자유">자유</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${pageMaker.cri.post_type == '활동앨범' ? 'active' : ''}" href="활동앨범">활동앨범</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${pageMaker.cri.post_type == '문의' ? 'active' : ''}" href="문의">문의</a>
                        </li>
                    </ul>
                    
                    <div class="table-responsive">
                        <table class="table table-striped table-hover table-bordered">
                            <thead class="table-dark">
                                <tr>
                                    <th style="width: 10%;">번호</th>
                                    <th style="width: 40%;">제목</th>
                                    <th style="width: 10%;">작성자</th>
                                    <th style="width: 15%;">작성일</th>
                                    <th style="width: 15%;">종류</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${list}" var="post">
                                  <tr>
                                    <td><c:out value="${post.post_id}" /></td>
                                    <td>
                                        <a class='move text-decoration-none fw-bold' href='<c:out value="${post.post_id}"/>'>
                                            <c:out value="${post.title}"/>
                                        </a>
                                        <c:if test="${post.reply_cnt > 0}">
                                            &nbsp;<span class="badge text-bg-secondary">[<c:out value="${post.reply_cnt}"/>]</span>
                                        </c:if>
                                    </td>
                                    <td><c:out value="${post.author_email}" /></td>
                                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${post.created_date}" /></td>
                                    <td><span class="badge text-bg-info"><c:out value="${post.post_type}" /></span></td>
                                  </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class='row mt-4'>
                        <div class="col-lg-12">
                            <form id="searchForm" action="/post/list" method='get' class="d-flex justify-content-end gap-2">
                                <select name='type' class="form-select form-select-sm" style="width: auto;">
                                    <option value="T" <c:out value="${pageMaker.cri.type == 'T' or pageMaker.cri.type == null ? 'selected' : ''}"/>>제목</option>
                                    <option value="C" <c:out value="${pageMaker.cri.type == 'C' ? 'selected' : ''}"/>>내용</option>
                                    <option value="A" <c:out value="${pageMaker.cri.type == 'A' ? 'selected' : ''}"/>>작성자</option>
                                    <option value="TC" <c:out value="${pageMaker.cri.type == 'TC' ? 'selected' : ''}"/>>제목 or 내용</option>
                                    <option value="TCA" <c:out value="${pageMaker.cri.type == 'TCA' ? 'selected' : ''}"/>>제목 or 내용 or 작성자</option>
                                </select>
                                <input type='text' name='keyword' value='<c:out value="${pageMaker.cri.keyword}"/>' class="form-control form-control-sm" style="width: 200px;" placeholder="검색 키워드">

                                <input type='hidden' name='pageNum' value='1'> 
                                <input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
                                <input type='hidden' name='post_type' value='${pageMaker.cri.post_type}'>
                                <input type='hidden' name='club_id' value='${pageMaker.cri.club_id}'>

                                <button type="submit" class='btn btn-outline-primary btn-sm'>
                                    <i class="bi bi-search"></i> Search
                                </button>
                            </form>
                        </div>
                    </div>
                    
                    <div class='d-flex justify-content-center mt-4'>
                        <ul class="pagination">
                            <c:if test="${pageMaker.prev}">
                                <li class="page-item previous"><a class="page-link" href="${pageMaker.startPage -1}"><i class="bi bi-chevron-left"></i> Previous</a></li>
                            </c:if>

                            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                                <li class="page-item ${pageMaker.cri.pageNum == num ? "active":""} ">
                                    <a class="page-link" href="${num}">${num}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${pageMaker.next}">
                                <li class="page-item next"><a class="page-link" href="${pageMaker.endPage +1 }">Next <i class="bi bi-chevron-right"></i></a></li>
                            </c:if>
                        </ul>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="myModal" tabindex="-1" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="myModalLabel"><i class="bi bi-check-circle-fill me-1"></i> 알림</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    처리가 완료되었습니다.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    
    <form id='actionForm' action="/post/list" method='get'>
        <input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
        <input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
        <input type='hidden' name='type' value='<c:out value="${ pageMaker.cri.type }"/>'> 
        <input type='hidden' name='keyword' value='<c:out value="${ pageMaker.cri.keyword }"/>'>
        <input type='hidden' name='post_type' value='<c:out value="${ pageMaker.cri.post_type }"/>'>
        <input type='hidden' name='club_id' value='<c:out value="${ pageMaker.cri.club_id }"/>'> 
    </form>


</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
	$(document)
			.ready(
					function() {

						var flashResult = '<c:out value="${result}"/>';
						var paramResult = '<c:out value="${param.result}"/>';
						var result = flashResult || paramResult;
						checkModal(result);
						
						// URL 히스토리를 깔끔하게 처리
						history.replaceState({}, null, location.pathname + location.search);
						
						// 결과값에 따라 모달을 표시하는 함수
						function checkModal(result) {
							if (result === '' || history.state) {
								return;
							}
							// Bootstrap 5 모달 show/hide
							var myModal = new bootstrap.Modal(document.getElementById('myModal'));

							if (parseInt(result) > 0) {
								$("#myModal .modal-body").html("게시글 " + parseInt(result) + " 번이 등록되었습니다.");
								myModal.show();
							}else if (result === 'success') { // 수정 또는 삭제 성공
						        $("#myModal .modal-body").html("처리가 완료되었습니다.");
						        myModal.show();
						    }
						}

						// 새 글 등록 버튼
						$("#regBtn").on("click", function() {
						    var actionForm = $("#actionForm");
						    var currentClubId = actionForm.find("input[name='club_id']").val();
						    self.location = "/post/register" + (currentClubId ? "?club_id=" + currentClubId : "");
						});

						var actionForm = $("#actionForm");

						// 탭 클릭 이벤트 처리 (게시판 종류 변경)
						$(".nav-tabs a").on("click", function(e) {
							e.preventDefault(); 
							
							actionForm.find("input[name='post_id']").remove(); 
						    actionForm.attr("action", "/post/list"); 
							
							var postType = $(this).attr("href");
							
							if (postType === '전체') {
								actionForm.find("input[name='post_type']").val('');
							} else {
								actionForm.find("input[name='post_type']").val(postType);
							}
							
							actionForm.find("input[name='pageNum']").val(1);
							actionForm.submit(); 
						});

						// 페이지 번호 클릭 이벤트
						$(".pagination a").on(
								"click",
								function(e) {

									e.preventDefault();

									actionForm.find("input[name='post_id']").remove(); 
						            actionForm.attr("action", "/post/list"); 

									actionForm.find("input[name='pageNum']")
											.val($(this).attr("href"));
									actionForm.submit();
								});

						// 제목 클릭 이벤트 (게시글 상세 보기로 이동)
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

						// 검색 폼 전송 이벤트
						$("#searchForm").on("submit", function(e) {

							var keyword = $(this).find("input[name='keyword']").val();

							if (keyword === '') {
								alert("키워드를 입력하세요.");
								$(this).find("input[name='keyword']").focus();
								return false;
							}
							// 폼 전송
						});
					});
</script>
</body>
</html>