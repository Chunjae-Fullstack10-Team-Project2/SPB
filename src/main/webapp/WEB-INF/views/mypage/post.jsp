<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>작성한 게시글</title>
    <style>
        .text-muted-deleted {
            color: lightgray !important;
            text-decoration: line-through;
        }
    </style>
</head>
<body class="bg-light-subtle">
<%@ include file="../common/sidebarHeader.jsp" %>

<div class="content">
    <div class="container my-5">
        <%@ include file="../common/breadcrumb.jsp" %>
    </div>
    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">작성한 게시글</h3>
        </div>
        <%
            List<Map<String, String>> dateOptions = new ArrayList<>();
            dateOptions.add(Map.of("value", "postCreatedAt", "label", "게시글 작성일자"));
            dateOptions.add(Map.of("value", "postUpdatedAt", "label", "게시글 수정일자"));
            request.setAttribute("dateOptions", dateOptions);

            List<Map<String, String>> searchTypeOptions = new ArrayList<>();
            searchTypeOptions.add(Map.of("value", "postTitle", "label", "제목"));
            searchTypeOptions.add(Map.of("value", "postContent", "label", "내용"));
            request.setAttribute("searchTypeOptions", searchTypeOptions);
            request.setAttribute("searchAction", "/mypage/post");
        %>
        <jsp:include page="../common/searchBox.jsp"/>

        <c:if test="${not empty postList}">
            <table class="table table-hover text-center align-middle">
                <thead class="table-light">
                <tr>
                    <th>번호</th>
                    <th>
                        <a href="javascript:void(0);" onclick="applySort('postTitle')">
                            제목
                            <c:if test="${searchDTO.sortColumn eq 'postTitle'}">
                                ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
                    <th>
                        <a href="javascript:void(0);" onclick="applySort('postCreatedAt')">
                            작성일
                            <c:if test="${searchDTO.sortColumn eq 'postCreatedAt'}">
                                ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${postList}" var="reportDTO" varStatus="status">
                    <tr>
                        <td>${reportDTO.postIdx}</td>
                        <td class="text-start">
                            <c:choose>
                                <c:when test="${reportDTO.reportState == 2}">
                                    <span class="text-muted-deleted">
                                        ${reportDTO.postTitle} (관리자에 의해 삭제됨)
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <a href="/board/freeboard/view?idx=${reportDTO.postIdx}"
                                       class="text-dark text-decoration-none">
                                            ${reportDTO.postTitle}
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${reportDTO.postCreatedAt.toLocalDate()}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>

        <c:if test="${empty postList}">
            <div class="alert alert-warning mt-4" role="alert">
                게시글이 없습니다.
            </div>
        </c:if>

        <div class="mt-4 text-center">
            <%@ include file="../common/paging.jsp" %>
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
