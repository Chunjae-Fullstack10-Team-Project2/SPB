<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>QnA</title>
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <h1 class="h2 mb-4">QnA</h1>

            <%
                List<Map<String, String>> dateSelect = new ArrayList<>();
                dateSelect.add(Map.of("value", "teacherQnaCreatedAt", "label", "문의 작성일"));
                dateSelect.add(Map.of("value", "teacherQnaAnsweredAt", "label", "문의 답변일"));

                List<Map<String, String>> searchSelect = new ArrayList<>();
                searchSelect.add(Map.of("value", "teacherQnaTitle", "label", "제목"));
                searchSelect.add(Map.of("value", "teacherQnaQContent", "label", "문의 내용"));
                searchSelect.add(Map.of("value", "teacherQnaAnsweredAt", "label", "답변 내용"));
                searchSelect.add(Map.of("value", "teacherQnAMemberId", "label", "문의 답변자"));

                request.setAttribute("dateSelect", dateSelect);
                request.setAttribute("searchSelect", searchSelect);
                request.setAttribute("searchAction", "/mystudy/qna");
            %>
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/searchBoxOnlyPage.jsp" />

            <c:if test="${not empty dtoList}">
                <table class="table table-hover text-center align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>번호</th>
                        <th>
                            <a onclick="applySort('teacherQnaTitle')">
                                제목
                                <c:if test="${pageDTO['sort_by'] eq 'teacherQnaTitle'}">
                                    ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                        <th>
                            <a onclick="applySort('questionMemberName')">
                                작성자
                                <c:if test="${pageDTO['sort_by'] eq 'questionMemberName'}">
                                    ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                        <th>
                            <a onclick="applySort('teacherQnaCreatedAt')">
                                작성일
                                <c:if test="${pageDTO['sort_by'] eq 'teacherQnaCreatedAt'}">
                                    ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                        <th>
                            <a onclick="applySort('teacherQnaStatus')">
                                문의 상태
                                <c:if test="${pageDTO['sort_by'] eq 'teacherQnaStatus'}">
                                    ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${dtoList}" var="qna" varStatus="status">
                        <tr class="clickable-row"
                            data-href="/teacher/personal/qna/view?idx=${qna.teacherQnaIdx}&teacherId=${qna.teacherQnaAMemberId}">
                            <td>${(pageDTO.page_no - 1) * pageDTO.page_size + status.index + 1}</td>
                            <td class="text-start">
                                <c:if test="${not empty qna.teacherQnaPwd}">
                                    <i class="bi bi-lock-fill"></i>
                                </c:if>${qna.teacherQnaTitle}
                            </td>
                            <td>${qna.questionMemberName}</td>
                            <td>${fn:substring(qna.teacherQnaCreatedAt, 0, 10)}</td>
                            <td>
                                <c:if test="${qna.teacherQnaStatus eq 0}">
                                    <span class="badge bg-secondary mb-1">미답변</span>
                                </c:if>
                                <c:if test="${qna.teacherQnaStatus eq 1}">
                                    <span class="badge bg-success mb-1">답변완료</span>
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
        document.querySelectorAll('.clickable-row').forEach(el => {
            el.addEventListener('mouseover', function () {
                this.style.cursor = "pointer";
            });
            el.addEventListener('click', function () {
                const url = this.dataset.href;
                if (url) window.location.href = url;
            });
        });

        function toggleAll(source) {
            const checkboxes = document.querySelectorAll('input[name="noticeIdxs"]');
            checkboxes.forEach(cb => cb.checked = source.checked);
        }
    </script>
</body>
</html>
