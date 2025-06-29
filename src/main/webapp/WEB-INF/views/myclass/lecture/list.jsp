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
                    <colgroup>
                        <col style="width: 40px">
                        <col>
                        <col style="width: 120px">
                        <col style="width: 120px">
                    </colgroup>
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
                        <tr class="clickable-row" data-href="/lecture/lectureDetail?lectureIdx=${lecture.lectureIdx}">
                            <td>${(pageDTO.page_no - 1) * pageDTO.page_size + status.index + 1}</td>
                            <td class="text-start">${lecture.lectureTitle}</td>
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
    <script>
        document.querySelectorAll('.clickable-row').forEach(el => {
            el.addEventListener('mouseover', function() {
                this.style.cursor = "pointer";
            });
            el.addEventListener('click', function () {
                const url = this.dataset.href;
                if (url) window.location.href = url;
            });
        });
    </script>
</body>
</html>
