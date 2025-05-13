<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>신고 관리</title>
</head>
<body>
<c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp"/>

<div class="content">
    <svg xmlns="http://www.w3.org/2000/svg" class="d-none">
        <symbol id="house-door-fill" viewBox="0 0 16 16">
            <path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5z"/>
        </symbol>
    </svg>
    <div class="container my-5">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb breadcrumb-chevron p-3 bg-body-tertiary rounded-3">
                <li class="breadcrumb-item">
                    <a class="link-body-emphasis" href="/">
                        <svg class="bi" width="16" height="16" aria-hidden="true">
                            <use xlink:href="#house-door-fill"></use>
                        </svg>
                        <span class="visually-hidden">Home</span>
                    </a>
                </li>
                <li class="breadcrumb-item">
                    <a class="link-body-emphasis fw-semibold text-decoration-none" href="/admin/member/list">관리자 페이지</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    신고 목록
                </li>
            </ol>
        </nav>
    </div>
    <div class="container my-5" style="height: 100%; min-height: 100vh;">
        <div class="container mb-4">
            <ul class="nav nav-tabs">
                <li class="nav-item">
                    <a class="nav-link ${not empty boardReportList ? 'active' : ''}" href="/admin/report/list/board">게시글
                        신고</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${not empty reviewReportList ? 'active' : ''}" href="/admin/report/list/review">강의평
                        신고</a>
                </li>
            </ul>
        </div>
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">신고 목록</h3>
        </div>

        <div class="mb-5">
            <c:if test="${not empty boardReportList}">
                <c:import url="${pageContext.request.contextPath}/WEB-INF/views/admin/report/boardReportTable.jsp"/>
            </c:if>
            <c:if test="${not empty reviewReportList}">
                <c:import url="${pageContext.request.contextPath}/WEB-INF/views/admin/report/reviewReportTable.jsp"/>
            </c:if>
        </div>
    </div>
</div>
<script>
    <c:if test="${not empty message}">
    alert("${message}");
    </c:if>
</script>
</body>
</html>
