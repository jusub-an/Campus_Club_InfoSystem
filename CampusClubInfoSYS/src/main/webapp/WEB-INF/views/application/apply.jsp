<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>동아리 가입 신청</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap');
        :root { font-family: 'Inter', sans-serif; }

        body {
            background-color: #f8fafc;
        }

        /* 상단 네비게이션 (login / findId와 통일) */
        .navbar-custom {
            background-color: #ffffff !important;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1),
                        0 2px 4px -2px rgba(0, 0, 0, 0.06);
            border-bottom: 1px solid #e2e8f0;
            padding-top: 0.5rem !important;
            padding-bottom: 0.5rem !important;
        }
        .navbar-brand {
            font-weight: 800;
            color: #4f46e5 !important; /* indigo-600 */
            letter-spacing: 0.5px;
        }

        /* 카드 스타일 (auth-card 재사용 느낌) */
        .auth-card {
            border-radius: 1.5rem;
            border: 1px solid #e2e8f0;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.10),
                        0 4px 6px -2px rgba(0,0,0,0.05);
        }

        .card-header-indigo {
            background-color: #4f46e5;   /* indigo-600 */
            color: #ffffff;
            border-top-left-radius: 1.5rem !important;
            border-top-right-radius: 1.5rem !important;
        }

        .main-title {
            font-weight: 700;
            color: #1d4ed8;  /* blue-700-ish */
        }

        .indigo-btn {
            background-color: #4f46e5;
            border-color: #4f46e5;
            color: #ffffff;
            font-weight: 600;
        }
        .indigo-btn:hover {
            background-color: #4338ca;
            border-color: #4338ca;
            color: #ffffff;
        }
    </style>
</head>
<body>

    <%-- 상단 네비게이션 바 --%>
    <nav class="navbar navbar-expand-lg navbar-light navbar-custom fixed-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                캠퍼스 동아리 정보시스템
            </a>
        </div>
    </nav>

    <%-- 메인 컨텐츠: 네비가 fixed-top이라 위쪽 여백 추가 --%>
    <div class="container py-5" style="padding-top: 6rem !important;">

        <div class="row">
            <div class="col-12 text-center mb-4">
                <h1 class="h3 main-title">동아리 가입 신청</h1>
                <p class="text-muted mb-0">
                    동아리에 가입하기 위한 간단한 지원글을 작성해 주세요.
                </p>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-6 col-md-8">

                <div class="card auth-card">
                    <div class="card-header card-header-indigo text-center">
                        <h5 class="mb-0">Application Form</h5>
                    </div>

                    <div class="card-body p-4 p-lg-5">

                        <%-- 에러 메시지 --%>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger small" role="alert">
                                ${error}
                            </div>
                        </c:if>

                        <c:choose>
                            <%-- 신청 성공 등 결과 메시지 있을 때 --%>
                            <c:when test="${!empty result}">
                                <div class="alert alert-success text-center" role="alert">
                                    ${result}
                                </div>

                                <div class="mt-3 text-center">
                                    <a href="<c:url value='/' />"
                                       class="btn btn-outline-secondary btn-sm">
                                        홈으로 돌아가기
                                    </a>
                                </div>
                            </c:when>

                            <%-- 일반 폼 표시 --%>
                            <c:otherwise>
                                <form action="<c:url value='/application/apply' />" method="post" class="mt-2">
                                    <input type="hidden" name="club_id" value="${club_id}">

                                    <div class="mb-3">
                                        <label for="applicant_text" class="form-label fw-semibold">
                                            지원글
                                        </label>
                                        <textarea class="form-control"
                                                  id="applicant_text"
                                                  name="applicant_text"
                                                  rows="4"
                                                  placeholder="간단한 자기소개와 동아리에 가입하고 싶은 이유를 작성해주세요."
                                                  required></textarea>
                                    </div>

                                    <div class="d-grid mt-3">
                                        <button type="submit" class="btn indigo-btn btn-lg">
                                            가입 신청
                                        </button>
                                    </div>

                                    <div class="text-center mt-3 small text-muted">
                                        <a href="<c:url value='/' />"
                                           class="text-primary text-decoration-none">
                                            홈으로 돌아가기
                                        </a>
                                    </div>
                                </form>
                            </c:otherwise>
                        </c:choose>

                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
