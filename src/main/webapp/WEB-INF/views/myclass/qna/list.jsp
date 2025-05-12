<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>QnA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
<div class="content">
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
    <div class="container my-5">
        <h1 class="mb-4">QnA</h1>

        <%
            List<Map<String, String>> dateSelect = new ArrayList<>();
            dateSelect.add(Map.of("value", "teacherQnaCreatedAt", "label", "문의 작성일"));
            dateSelect.add(Map.of("value", "teacherQnaAnsweredAt", "label", "문의 답변일"));

            List<Map<String, String>> searchSelect = new ArrayList<>();
            searchSelect.add(Map.of("value", "teacherQnaTitle", "label", "제목"));
            searchSelect.add(Map.of("value", "teacherQnaQContent", "label", "문의 내용"));
            searchSelect.add(Map.of("value", "teacherQnaAnsweredAt", "label", "답변 내용"));
            searchSelect.add(Map.of("value", "teacherQnaQMemberId", "label", "문의 작성자"));

            request.setAttribute("dateSelect", dateSelect);
            request.setAttribute("searchSelect", searchSelect);
            request.setAttribute("searchAction", "/myclass/notice/");
        %>
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/searchBoxOnlyPage.jsp" />

        <c:if test="${not empty noticeList}">
            <table class="table table-hover text-center align-middle">
                <thead class="table-light">
                <tr>
                    <th>번호</th>
                    <th>
                        <a onclick="applySort('teacherNoticeTitle')">
                            제목
                            <c:if test="${pageDTO['sort_by'] eq 'teacherNoticeTitle'}">
                                ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
                    <th>
                        <a onclick="applySort('teacherNoticeCreatedAt')">
                            작성일
                            <c:if test="${pageDTO['sort_by'] eq 'teacherNoticeCreatedAt'}">
                                ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${noticeList}" var="notice" varStatus="status">
                    <tr ${notice.teacherNoticeFixed == 1 ? "class='table-secondary'" : ""}>
                        <td>${pageDTO.total_count - ((pageDTO.page_no - 1) * pageDTO.page_size) - status.index}</td>
                        <td class="text-start">
                            <a href="/myclass/notice/view?idx=${notice.teacherNoticeIdx}&${pageDTO.linkUrl}"
                               class="text-decoration-none text-dark">
                                    ${notice.teacherNoticeTitle}
                            </a>
                        </td>
                        <td>${notice.teacherNoticeCreatedAt.toLocalDate()}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
        <c:if test="${empty noticeList}">
            <div class="alert alert-warning mt-4" role="alert">
                게시글이 없습니다.
            </div>
        </c:if>

        <div class="mb-2 mb-md-0 text-center">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/pagingOnlyPage.jsp" />
        </div>

        <div class="d-grid float-md-end">
            <button class="btn btn-primary" type="button" id="btnRegist" onclick="location.href='/myclass/notice/regist?${pageDTO.linkUrl}'">등록</button>
        </div>
    </div>
</div>
</body>
</html>
