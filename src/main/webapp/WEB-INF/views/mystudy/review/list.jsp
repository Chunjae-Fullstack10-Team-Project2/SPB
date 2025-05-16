<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>수강후기</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <h1 class="h2 mb-4">수강후기</h1>

            <%
                List<Map<String, String>> searchSelect = new ArrayList<>();
                searchSelect.add(Map.of("value", "lectureTitle", "label", "강좌명"));
                searchSelect.add(Map.of("value", "teacherName", "label", "선생님"));
                searchSelect.add(Map.of("value", "lectureReviewContent", "label", "내용"));
                request.setAttribute("searchSelect", searchSelect);
                request.setAttribute("searchAction", "/mystudy/review");
            %>
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/searchBoxOnlyPage.jsp" />

            <c:if test="${not empty reviewList}">
                <table class="table table-hover text-center align-middle">
                    <colgroup>
                        <col style="width: 40px">
                        <col style="width: 120px">
                        <col>
                        <col style="width: 120px">
                        <col style="width: 90px">
                    </colgroup>
                    <thead class="table-light">
                    <tr>
                        <th>번호</th>
                        <th>
                            <a onclick="applySort('lectureReviewGrade')">
                                만족도
                                <c:if test="${pageDTO['sort_by'] eq 'lectureReviewGrade'}">
                                    ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                        <th>
                            <a onclick="applySort('lectureReviewContent')">
                                내용
                                <c:if test="${pageDTO['sort_by'] eq 'lectureReviewContent'}">
                                    ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                        <th>
                            <a onclick="applySort('lectureReviewCreatedAt')">
                                작성일
                                <c:if test="${pageDTO['sort_by'] eq 'lectureReviewCreatedAt'}">
                                    ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                        <th>강좌상세</th>
                    </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${reviewList}" var="review" varStatus="status">
                            <tr class="clickable-row"
                                data-href="/mystudy/review/view?idx=${review.lectureReviewIdx}&${pageDTO.linkUrl}">
                                <td>${pageDTO.total_count - ((pageDTO.page_no - 1) * pageDTO.page_size) - status.index}</td>
                                <td>
                                    <c:set var="rating" value="${review.lectureReviewGrade}" />
                                    <span class="text-warning">
                                        <c:forEach var="i" begin="1" end="5">
                                            <c:choose>
                                                <c:when test="${rating >= i}">
                                                    <i class="bi bi-star-fill"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="bi bi-star"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </span>
                                </td>
                                <td class="text-start">
                                    <div>${review.lectureReviewContent}</div>
                                    <div class="text-secondary small">[${review.teacherName} 선생님] ${review.lectureTitle}</div>
                                </td>
                                <td>${fn:substring(review.lectureReviewCreatedAt, 0, 10)}</td>
                                <td>
                                    <a href="/lecture/lectureDetail?lectureIdx=${review.lectureReviewRefIdx}#review_${lectureReviewIdx}"
                                       class="btn btn-sm btn-link text-decoration-none text-secondary">강좌상세
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${empty reviewList}">
                <div class="alert alert-warning mt-4" role="alert">
                    수강후기가 없습니다.
                </div>
            </c:if>

            <div class="mb-2 mb-md-0 text-center">
                <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/pagingOnlyPage.jsp" />
            </div>

            <div class="d-flex gap-2 mb-2 justify-content-end">
                <button class="btn btn-sm btn-primary" type="button" id="btnRegist" onclick="location.href='/mystudy/review/regist?${pageDTO.linkUrl}'">등록</button>
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

        <c:if test="${not empty message}">
            alert("${message}");
        </c:if>
    </script>
</body>
</html>
