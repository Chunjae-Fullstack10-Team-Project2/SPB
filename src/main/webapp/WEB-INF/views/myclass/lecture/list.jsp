<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>내 강의 목록</title>
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <div class="container my-5">
                <h1 class="h2 mb-4">내 강의 목록</h1>
                <%
                    List<Map<String, String>> searchSelect = new ArrayList<>();
                    searchSelect.add(Map.of("value", "lectureTitle", "label", "제목"));
                    searchSelect.add(Map.of("value", "lectureDescription", "label", "내용"));
                    request.setAttribute("searchSelect", searchSelect);
                    request.setAttribute("searchAction", "/myclass/lecture/");
                %>
                <jsp:include page="../../common/searchBoxOnlyPage.jsp" />
                <c:if test="${not empty lectureList}">
                    <table class="table table-hover text-center align-middle">
                        <thead class="table-light">
                        <tr>
                            <th>번호</th>
                            <th>
                                <a onclick="applySort('lectureTitle')">
                                    제목
                                    <c:if test="${pageDTO['sort_by'] eq 'lectureTitle'}">
                                        ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a onclick="applySort('lectureAmount')">
                                    가격
                                    <c:if test="${pageDTO['sort_by'] eq 'lectureAmount'}">
                                        ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a onclick="applySort('lectureCreatedAt')">
                                    등록일
                                    <c:if test="${pageDTO['sort_by'] eq 'lectureCreatedAt'}">
                                        ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${lectureList}" var="lecture" varStatus="status">
                            <tr ${notice.teacherNoticeFixed == 1 ? "class='table-secondary'" : ""}>
                                <td>${pageDTO.total_count - ((pageDTO.page_no - 1) * pageDTO.page_size) - status.index}</td>
                                <td class="text-start">
                                    <a href="/lecture/lectureDetail?lectureIdx=${lecture.lectureIdx}"
                                       class="text-decoration-none text-dark">
                                            ${lecture.lectureTitle}
                                    </a>
                                </td>
                                <td>${lecture.lectureAmount}₩</td>
                                <td>${fn:substring(lecture.lectureCreatedAt, 0, 10)}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:if>
                <c:if test="${empty lectureList}">
                    <div class="alert alert-warning mt-4" role="alert">
                        게시글이 없습니다.
                    </div>
                </c:if>

                <div class="mb-2 mb-md-0 text-center">
                    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/pagingOnlyPage.jsp" />
                </div>
            </div>
        </div>
    </div>
</body>
</html>
