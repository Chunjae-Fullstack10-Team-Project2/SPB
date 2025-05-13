<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>자료실</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
        <div class="container my-5">
            <h1 class="h2 mb-4">자료실</h1>

            <%
                List<Map<String, String>> searchSelect = new ArrayList<>();
                searchSelect.add(Map.of("value", "teacherFileTitle", "label", "제목"));
                searchSelect.add(Map.of("value", "teacherFileContent", "label", "내용"));
                request.setAttribute("searchSelect", searchSelect);
                request.setAttribute("searchAction", "/myclass/library");
            %>

            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/searchBoxOnlyPage.jsp" />

            <c:if test="${not empty fileList}">
                <table class="table table-hover text-center align-middle">
                    <thead class="table-light">
                        <th>번호</th>
                        <th>
                            <a onclick="applySort('teacherFileTitle')">제목
                                <c:if test="${pageDTO['sort_by'] eq 'teacherFileTitle'}">
                                    ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                        <th>
                            <a onclick="applySort('teacherFileCreatedAt')">등록일
                                <c:if test="${pageDTO['sort_by'] eq 'teacherFileCreatedAt'}">
                                    ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                    </thead>
                    <tbody>
                        <c:forEach items="${fileList}" var="file" varStatus="status">
                            <tr>
                                <td>${pageDTO.total_count - ((pageDTO.page_no - 1) * pageDTO.page_size) - status.index}</td>
                                <td class="text-start">
                                    <a href="/teacher/personal/library/view?idx=${file.teacherFileIdx}&${pageDTO.linkUrl}"
                                       class="text-decoration-none text-dark">
                                            ${file.teacherFileTitle}
                                    </a>
                                </td>
                                <td>${fn:substring(file.teacherFileCreatedAt, 0, 10)}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${empty fileList}">
                <div class="alert alert-warning mt-4" role="alert">
                    게시글이 없습니다.
                </div>
            </c:if>
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/pagingOnlyPage.jsp" />
        </div>
    </div>
</body>
</html>
