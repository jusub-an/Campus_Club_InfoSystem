<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page session="false" %>
<html>
<head>
	<title>HomePage</title>
</head>
<body>
<h1> 캠퍼스 동아리 정보시스템 </h1>

<!-- 상단 로그인 / 로그아웃 영역 -->
<div class="top-area">
    <c:choose>
        <%-- 1. loginUser가 null이 아닐 때 (로그인 상태) --%>
        <c:when test="${!empty loginUser}">
            <p>
                <strong>${loginUser}</strong>님 환영합니다.
            </p>
            <p>
                <a href="user/logout">
                    <button>로그아웃</button>
                </a>
            </p>
        </c:when>

        <%-- 2. loginUser가 null일 때 (로그아웃 상태) --%>
        <c:otherwise>
            <p>
                <a href="user/login">
                    <button>로그인 페이지</button>
                </a>
            </p>
        </c:otherwise>
    </c:choose>
</div>

<!-- 동아리명 검색창 -->
<div class="search-box">
    <%-- GET / (HomeController) 로 검색 요청 --%>
    <form method="get" action="${pageContext.request.contextPath}/">
        <input type="text"
               name="keyword"
               placeholder="동아리명을 입력하세요"
               value="${empty keyword ? '' : keyword}">
        <button type="submit">검색</button>
    </form>
</div>

<!-- 카테고리 버튼 영역 -->
<div class="category-section">
    <div class="category-title">카테고리별 보기</div>

    <%-- 카테고리 선택도 GET / 로 요청 보냄 --%>
    <form method="get" action="${pageContext.request.contextPath}/">
        <%-- 검색어를 유지한 상태에서 카테고리만 바꿀 수 있도록 hidden 값 유지 --%>
        <input type="hidden" name="keyword" value="${empty keyword ? '' : keyword}">

        <div class="category-grid">
            <c:forEach var="cat" items="${categories}">
                <button type="submit"
                        name="category"
                        value="${cat}"
                        class="category-btn ${cat == selectedCategory ? 'active' : ''}">
                    ${cat}
                </button>
            </c:forEach>
        </div>
    </form>
</div>

<div class="menu-area">
    <p>
        <a href="club/list">
            <button>동아리 목록 페이지</button>
        </a>
    </p>
</div>

<hr>

<!-- 검색 결과 영역 -->
<div class="result-section">
    <h2>검색 결과</h2>

    <c:if test="${empty clubList}">
        <p>검색된 동아리가 없습니다.</p>
    </c:if>

    <c:if test="${!empty clubList}">
        <table border="1">
            <thead>
                <tr>
                    <th>번호</th>
                    <th>동아리명</th>
                    <th>카테고리</th>
                    <th>소개</th>
                    <th>대표자 이메일</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="club" items="${clubList}">
                    <tr>
                        <td>${club.club_id}</td>
                    	<td>${club.club_name}</td>
                    	<td>${club.category}</td>
                    	<td>${club.description}</td>
                    	<td>${club.leader_email}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
</div>

<P>  현재 시간: ${serverTime}. </P>
</body>
</html>
