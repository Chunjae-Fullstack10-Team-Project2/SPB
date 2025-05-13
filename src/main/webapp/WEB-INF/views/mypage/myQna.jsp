<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String uri = request.getRequestURI();
    request.setAttribute("currentURI", uri);
%>
<html>
<head>
    <title>나의 1:1 문의</title>
</head>
<body class="bg-light-subtle">

<%@ include file="../common/sidebarHeader.jsp" %>

<div class="content">
    <div class="container my-5">
        <%@ include file="../common/breadcrumb.jsp" %>
    </div>
    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">나의 문의 목록</h3>
            <a href="/qna/regist" class="btn btn-primary">
                <i class="bi bi-pencil-square"></i> 문의 등록
            </a>
        </div>
        <%
            List<Map<String, String>> searchTypeOptions = new ArrayList<>();
            searchTypeOptions.add(Map.of("value", "qnaTitle", "label", "제목"));
            searchTypeOptions.add(Map.of("value", "qnaQContent", "label", "질문 내용"));
            searchTypeOptions.add(Map.of("value", "qnaQMemberId", "label", "질문 작성자"));
            searchTypeOptions.add(Map.of("value", "qnaAContent", "label", "답변 내용"));
            searchTypeOptions.add(Map.of("value", "qnaAMemberId", "label", "답변 작성자"));

            request.setAttribute("searchTypeOptions", searchTypeOptions);
            request.setAttribute("searchAction", "/qna/myQna");
        %>
        <jsp:include page="../common/searchBox.jsp"/>
        <c:if test="${not empty qnaList}">
            <div class="list-group">
                <c:forEach var="qnaDTO" items="${qnaList}">
                    <a href="/qna/view?qnaIdx=${qnaDTO.qnaIdx}"
                       class="list-group-item list-group-item-action d-flex justify-content-between align-items-start">
                        <div class="ms-2 me-auto">
                            <div class="fw-bold">${qnaDTO.qnaTitle}</div>
                            <small class="text-muted">작성자: ${qnaDTO.qnaQMemberId}</small>
                        </div>
                        <div class="d-flex flex-column align-items-end">
                            <c:choose>
                                <c:when test="${not empty qnaDTO.qnaAnsweredAt}">
                                    <span class="badge bg-success mb-1">답변</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger mb-1">미답변</span>
                                </c:otherwise>
                            </c:choose>
                            <small class="text-muted"><fmt:formatDate value="${qnaDTO.qnaCreatedAt}"
                                                                      pattern="yyyy-MM-dd"/></small>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${empty qnaList}">
            <div class="alert alert-warning mt-4" role="alert">
                등록된 문의가 없습니다.
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
