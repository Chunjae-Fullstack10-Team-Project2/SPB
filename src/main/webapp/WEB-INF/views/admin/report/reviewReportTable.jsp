<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>리뷰 신고 목록</title>
</head>
<body>

<div class="container my-5">
<%--    <div class="d-flex justify-content-between align-items-center mb-4">--%>
<%--        <h3 class="mb-0">리뷰 신고 목록</h3>--%>
<%--    </div>--%>
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
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/searchBox.jsp"/>

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
        <c:forEach items="${reviewReportList}" var="bookmarkDTO" varStatus="status">
            <tr>
                <td>${bookmarkDTO.reportIdx}</td>
                <td class="text-start">${bookmarkDTO.lectureReviewContent}</td>
                <td>${bookmarkDTO.lectureReviewMemberId}</td>
                <td>${bookmarkDTO.lectureReviewCreatedAt.toLocalDate()}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <c:if test="${empty reviewReportList}">
        <div class="alert alert-warning mt-4" role="alert">
            게시글이 없습니다.
        </div>
    </c:if>

    <div class="my-4 text-center">
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/paging.jsp"/>
    </div>
</div>
<script>
    <c:if test="${not empty message}">
    alert("${message}");
    </c:if>
</script>
</body>
</html>
