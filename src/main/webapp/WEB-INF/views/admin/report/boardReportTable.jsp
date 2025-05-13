<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>

<%
    List<Map<String, String>> dateOptions = new ArrayList<>();
    dateOptions.add(Map.of("value", "reportCreatedAt", "label", "신고 일자"));
    dateOptions.add(Map.of("value", "postCreatedAt", "label", "게시글 작성일자"));
    request.setAttribute("dateOptions", dateOptions);

    List<Map<String, String>> searchTypeOptions = new ArrayList<>();
    searchTypeOptions.add(Map.of("value", "postTitle", "label", "게시글 제목"));
    searchTypeOptions.add(Map.of("value", "postContent", "label", "게시글 내용"));
    searchTypeOptions.add(Map.of("value", "postMemberId", "label", "게시글 작성자"));
    request.setAttribute("searchTypeOptions", searchTypeOptions);
    request.setAttribute("searchAction", "/admin/report/list/board");
%>
<c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/searchBox.jsp"/>

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
            <a href="javascript:void(0);" onclick="applySort('postMemberId')">
                작성자
                <c:if test="${searchDTO.sortColumn eq 'postMemberId'}">
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
    <c:forEach items="${boardReportList}" var="orderDTO" varStatus="status">
        <tr>
            <td>${orderDTO.reportIdx}</td>
            <td class="text-start">
                <a href="/post/detail?postIdx=${orderDTO.reportRefIdx}"
                   class="text-decoration-none text-dark">
                        ${orderDTO.postTitle}
                </a>
            </td>
            <td>${orderDTO.postMemberId}</td>
            <td>${orderDTO.postCreatedAt.toLocalDate()}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<c:if test="${empty boardReportList}">
    <div class="alert alert-warning mt-4" role="alert">
        게시글이 없습니다.
    </div>
</c:if>

<div class="mt-4 text-center">
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/paging.jsp"/>
</div>
<script>
    <c:if test="${not empty message}">
    alert("${message}");
    </c:if>
</script>
</body>
</html>
