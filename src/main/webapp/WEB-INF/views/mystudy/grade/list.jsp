<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>나의 성적</title>
</head>
<body>
<c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
<div class="content">
    <div class="container my-5">
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
        <h1 class="h2 mb-4">나의 성적</h1>
        <%
            List<Map<String, String>> searchSelect = new ArrayList<>();
            searchSelect.add(Map.of("value", "teacherName", "label", "선생님"));
            searchSelect.add(Map.of("value", "lectureGradeFeedback", "label", "내용"));

            request.setAttribute("searchSelect", searchSelect);
            request.setAttribute("searchAction", "/mystudy/grade");
        %>
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/searchBoxOnlyPage.jsp" />

        <c:if test="${not empty dtoList}">
            <table class="table table-hover text-center align-middle">
                <colgroup>
                    <col style="width: 40px;">
                    <col style="width: 120px;">
                    <col>
                    <col style="width: 120px;">
                    <col style="width: 40px;">
                    <col style="width: 100px;">
                </colgroup>
                <thead class="table-light">
                <tr>
                    <th>번호</th>
                    <th>
                        <a onclick="applySort('teacherName')">
                            선생님
                            <c:if test="${pageDTO['sort_by'] eq 'teacherName'}">
                                ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
                    <th>
                        <a onclick="applySort('lectureTitle')">
                            강좌명
                            <c:if test="${pageDTO['sort_by'] eq 'lectureTitle'}">
                                ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
                    <th>
                        <a onclick="applySort('lectureRegisterStartedAt')">
                            수강시작일
                            <c:if test="${pageDTO['sort_by'] eq 'lectureRegisterStartedAt'}">
                                ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
                    <th>
                        <a onclick="applySort('lectureGradeScore')">
                            점수
                            <c:if test="${pageDTO['sort_by'] eq 'lectureGradeScore'}">
                                ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
                    <th>성적표보기</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${dtoList}" var="dto" varStatus="status">
                    <tr>
                        <td>${(pageDTO.page_no - 1) * pageDTO.page_size + status.index + 1}</td>
                        <td>${dto.teacherName} 선생님</td>
                        <td class="text-start">${dto.lectureTitle}</td>
                        <td>${fn:substring(dto.lectureRegisterStartedAt, 0, 10)}</td>
                        <td>${dto.lectureGradeScore != null ? dto.lectureGradeScore : "-" }</td>
                        <td>
                            <c:if test="${dto.lectureGradeScore != null}">
                                <a href="/mystudy/grade/view?idx=${dto.lectureGradeIdx}&${pageDTO.linkUrl}"
                                   class="btn btn-sm btn-primary text-decoration-none">성적표
                                </a>
                            </c:if>
                            <c:if test="${dto.lectureGradeScore == null}">
                                <a href=""
                                   class="btn btn-sm btn-link text-decoration-none text-secondary disabled">성적표
                                </a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
        <c:if test="${empty dtoList}">
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
    function toggleAll(source) {
        const checkboxes = document.querySelectorAll('input[name="idxList"]:not(:disabled)');
        checkboxes.forEach(cb => cb.checked = source.checked);
    }

    <c:if test="${not empty message}">
    alert("${message}");
    </c:if>
</script>
</body>
</html>
