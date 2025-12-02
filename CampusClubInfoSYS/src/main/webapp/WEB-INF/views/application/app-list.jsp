<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>동아리 관리: 가입신청자 및 회원 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* Inter 폰트 사용 */
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap');
        body {
            background-color: #f8fafc; /* Tailwind gray-50 */
            font-family: 'Inter', sans-serif;
        }

        /* 상단 큰 카드 */
        .manage-card {
            border-radius: 1rem;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1),
                        0 4px 6px -2px rgba(0, 0, 0, 0.05);
            border: none;
        }
        .manage-card .card-header {
            background-color: #f1f5f9; /* gray-100 */
            border-bottom: 1px solid #e2e8f0;
            border-top-left-radius: 1rem !important;
            border-top-right-radius: 1rem !important;
            padding: 1rem 1.5rem;
        }

        .page-title {
            font-weight: 800;
            color: #1e293b; /* slate-800 */
        }

        .section-title {
            font-weight: 700;
            font-size: 1.1rem;
            color: #0f172a; /* slate-900 */
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }

        .section-title svg {
            margin-right: 0.5rem;
        }

        /* 표를 감싸는 카드 스타일 */
        .table-card {
            border-radius: 0.75rem;
            border: 1px solid #e2e8f0;
            background-color: #ffffff;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            padding: 1.25rem 1.5rem;
            margin-bottom: 1.5rem;
        }

        .table thead {
            background-color: #0f172a;
            color: white;
        }

        .badge-status {
            font-size: 0.8rem;
            border-radius: 999px;
            padding: 0.25rem 0.75rem;
        }

        footer {
            background-color: #1e293b !important; /* slate-800 */
        }
    </style>
</head>
<body>

    <%@include file="../includes/header.jsp" %>

    <div class="container my-5 pt-5">

        <!-- 상단 관리 카드 -->
        <div class="card manage-card mb-4">
            <div class="card-header d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                         viewBox="0 0 24 24" fill="none" stroke="currentColor"
                         stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                         class="me-2 text-primary">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                    </svg>
                    <h2 class="page-title mb-0">동아리 관리 페이지</h2>
                </div>
                <c:if test="${not empty club_id}">
                    <span class="badge bg-indigo-600 text-white">
                        관리 중인 동아리 ID : ${club_id}
                    </span>
                </c:if>
            </div>
            <div class="card-body">
                <p class="text-muted mb-0">
                    이 페이지에서 동아리의
                    <strong>가입 신청자 승인/거절</strong> 및
                    <strong>기존 회원 관리(추방)</strong>를 할 수 있습니다.
                </p>
            </div>
        </div>

        <!-- 가입신청자 목록 섹션 -->
        <div class="mb-4">
            <div class="section-title">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                     viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M4 21v-4"></path>
                    <path d="M4 10V3"></path>
                    <path d="M12 21v-9"></path>
                    <path d="M12 6V3"></path>
                    <path d="M20 21v-6"></path>
                    <path d="M20 8V3"></path>
                    <path d="M1 14h6"></path>
                    <path d="M9 8h6"></path>
                    <path d="M17 12h6"></path>
                </svg>
                가입신청자 목록
            </div>

            <c:choose>
                <c:when test="${not empty a_list}">
                    <div class="table-card">
                        <table class="table table-striped table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>신청자 이메일</th>
        							<th>신청자 이름</th>   <%-- ✅ 추가 --%>
                                    <th>지원글</th>
                                    <th>신청일</th>
                                    <th class="text-center">상태</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <c:forEach items="${a_list}" var="app">
                                    <tr>
                                        <td>
                                            <span class="fw-semibold">
                                                <c:out value="${app.applicant_email}" />
                                            </span>
                                        </td>
                                        
                                        <td>
            								<span class="fw-semibold">
                								<c:out value="${app.name}" />
            								</span>
        								</td>
        								
                                        <td style="max-width: 380px;">
                                            <span class="text-muted">
                                                <c:out value="${app.applicant_text}" />
                                            </span>
                                        </td>
                                        <td>
                                            <span class="text-muted">
                                                <fmt:formatDate pattern="yyyy-MM-dd" value="${app.applied_at}" />
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center gap-2">

                                                <%-- 승인 폼 --%>
                                                <form action="<c:url value='/application/approve' />" method="post" class="d-inline">
                                                    <input type="hidden" name="app_id" value="${app.app_id}">
                                                    <input type="hidden" name="club_id" value="${app.club_id}">
                                                    <input type="hidden" name="applicant_email" value="${app.applicant_email}">
                                                    <button type="submit" class="btn btn-success btn-sm">
                                                        승인 (O)
                                                    </button>
                                                </form>

                                                <%-- 거절 폼 --%>
                                                <form action="<c:url value='/application/reject' />" method="post" class="d-inline">
                                                    <input type="hidden" name="app_id" value="${app.app_id}">
                                                    <input type="hidden" name="club_id" value="${club_id}">
                                                    <button type="submit" class="btn btn-danger btn-sm">
                                                        거절 (X)
                                                    </button>
                                                </form>

                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info py-3 px-4 shadow-sm border-0 rounded-3" role="alert">
                        현재 <strong>가입 신청</strong>이 없습니다.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 회원 목록 섹션 -->
        <div class="mt-4">
            <div class="section-title">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                     viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M16 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                    <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                    <path d="M5 17.13A4 4 0 0 0 2 19v2"></path>
                    <path d="M18 7a4 4 0 0 0-3-3.87"></path>
                    <path d="M6 3.13A4 4 0 0 0 3 7"></path>
                </svg>
                회원 목록
            </div>

            <c:choose>
                <c:when test="${not empty m_list}">
                    <div class="table-card">
                        <table class="table table-striped table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>동아리 ID</th>
                                    <th>회원 이메일</th>
                                    <th>회원 이름</th>   <%-- ✅ 추가 --%>
                                    <th class="text-center">관리</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <c:forEach items="${m_list}" var="mem">
                                    <tr>
                                        <td>
                                            <span class="fw-semibold">
                                                <c:out value="${mem.club_id}" />
                                            </span>
                                        </td>
                                        <td>
                                            <span class="text-muted">
                                                <c:out value="${mem.user_email}" />
                                            </span>
                                        </td>
                                        
                                        
        								<!-- ✅ 회원 이름 -->
        								<td>
            								<span class="fw-semibold">
                								<c:out value="${mem.name}" />
            								</span>
        								</td>
                                        
                                        <td class="text-center">
                                            <form action="<c:url value='/application/expel' />" method="post" class="d-inline">
                                                <input type="hidden" name="club_id" value="${mem.club_id}">
                                                <input type="hidden" name="user_email" value="${mem.user_email}">
                                                <button type="submit"
                                                        class="btn btn-warning btn-sm"
                                                        onclick="return confirm('${mem.user_email} 회원을 추방하시겠습니까?');">
                                                    추방
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info py-3 px-4 shadow-sm border-0 rounded-3" role="alert">
                        현재 등록된 <strong>회원</strong>이 없습니다.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

<!--  	
    <footer class="text-white-50 py-4 mt-5">
        <div class="container d-flex flex-column flex-md-row justify-content-between align-items-center">
            <p class="mb-2 mb-md-0">&copy; 2025 Campus Club Information System</p>
            <p class="mb-0">현재 시간: ${serverTime}.</p>
        </div>
    </footer>
-->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
