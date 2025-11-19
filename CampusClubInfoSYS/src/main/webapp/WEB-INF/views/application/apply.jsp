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
</head>
<body>

<div class="container my-5">
    
    <div class="row">
        <div class="col-12">
            <h1 class="text-center mb-5 text-info">동아리 가입 신청</h1>
        </div>
    </div>
    
    <div class="row justify-content-center">
        <div class="col-lg-6 col-md-8">
            <div class="card shadow-lg">
                <div class="card-header bg-info text-white text-center">
                    <h5 class="mb-0">Application Form</h5>
                </div>
                <div class="card-body">

                    <%-- RedirectAttributes로 전달받은 에러 메시지 출력 --%>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            [cite_start]${error} [cite: 136]
                        </div>
                    </c:if>
                    
                    <c:choose>
                        <c:when test="${!empty result}">
                            <div class="alert alert-success" role="alert">
                                [cite_start]${result} [cite: 136]
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="mb-4 text-muted">동아리에 가입하기 위한 간단한 지원글을 작성해 주세요.</p>
                            <form action="/application/apply" method="post">
                                <input type="hidden" name="club_id" value="<c:out value="${club_id}"/>">
                                
                                <div class="mb-3">
                                    <label for="applicant_text" class="form-label">지원글</label>
                                    <textarea class="form-control" id="applicant_text" name="applicant_text" rows="3" placeholder="간단한 자기소개 및 가입 동기를 작성해주세요." required></textarea>
                                </div>
                                
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-info btn-lg">가입 신청</button>
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