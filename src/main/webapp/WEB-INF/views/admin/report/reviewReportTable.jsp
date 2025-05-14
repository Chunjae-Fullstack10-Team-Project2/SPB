<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String uri = request.getRequestURI();
    request.setAttribute("currentURI", uri);
%>
<html>
<head>
    <title>리뷰 신고 목록</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<%@ include file="../../common/sidebarHeader.jsp" %>

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
                            <use xlink:href="#house-door-fill"/>
                        </svg>
                        <span class="visually-hidden">Home</span>
                    </a>
                </li>
                <li class="breadcrumb-item">
                    <a class="link-body-emphasis fw-semibold text-decoration-none" href="/admin/member/list">관리자 페이지</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    리뷰 신고
                </li>
            </ol>
        </nav>
    </div>

    <div class="container my-5" style="height: 100%; min-height: 100vh;">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">리뷰 신고 목록</h3>
        </div>

        <%
            List<Map<String, String>> dateOptions = new ArrayList<>();
            dateOptions.add(Map.of("value", "reportCreatedAt", "label", "신고 일자"));
            dateOptions.add(Map.of("value", "lectureReviewCreatedAt", "label", "강의평 작성일자"));
            request.setAttribute("dateOptions", dateOptions);

            List<Map<String, String>> searchTypeOptions = new ArrayList<>();
            searchTypeOptions.add(Map.of("value", "lectureReviewMemberId", "label", "강의평 작성자"));
            searchTypeOptions.add(Map.of("value", "lectureReviewContent", "label", "강의평 내용"));
            request.setAttribute("searchTypeOptions", searchTypeOptions);
            request.setAttribute("searchAction", "/admin/report/list/review");
        %>
        <jsp:include page="../../common/searchBox.jsp"/>

        <c:choose>
            <c:when test="${not empty reviewReportList and fn:length(reviewReportList) > 0}">
                <table class="table table-hover text-center align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>번호</th>
                        <th>
                            <a href="javascript:void(0);" onclick="applySort('lectureReviewContent')">
                                내용
                                <c:if test="${searchDTO.sortColumn eq 'lectureReviewContent'}">
                                    ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                        <th>
                            <a href="javascript:void(0);" onclick="applySort('lectureReviewMemberId')">
                                작성자
                                <c:if test="${searchDTO.sortColumn eq 'lectureReviewMemberId'}">
                                    ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                        <th>
                            <a href="javascript:void(0);" onclick="applySort('lectureReviewCreatedAt')">
                                작성일
                                <c:if test="${searchDTO.sortColumn eq 'lectureReviewCreatedAt'}">
                                    ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${reviewReportList}" var="postDTO" varStatus="status">
                        <tr>
                            <td>${postDTO.reportIdx}</td>
                            <td class="text-start">${postDTO.lectureReviewContent}</td>
                            <td>${postDTO.lectureReviewMemberId}</td>
                            <td>${postDTO.lectureReviewCreatedAt.toLocalDate()}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="alert alert-warning mt-4" role="alert">
                    리뷰 신고 내역이 없습니다.
                </div>
            </c:otherwise>
        </c:choose>

        <div class="mt-4 text-center">
            <jsp:include page="../../common/paging.jsp"/>
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
