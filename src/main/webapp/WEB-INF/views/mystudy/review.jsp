<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>수강후기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
        <div class="container my-5">
            <h1 class="mb-4">수강후기</h1>

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
                    </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${reviewList}" var="review" varStatus="status">
                            <tr>
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
                                    <a href="/mystudy/review/view?idx=${review.lectureReviewIdx}&${pageDTO.linkUrl}"
                                       class="text-decoration-none text-dark">
                                            <div>${review.lectureReviewContent}</div>
                                            <div class="text-secondary small">[${review.teacherName} 선생님] ${review.lectureTitle}</div>
                                    </a>
                                </td>
                                <td>${fn:substring(review.lectureReviewCreatedAt, 0, 10)}</td>
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

            <div class="d-grid float-md-end">
                <button class="btn btn-primary" type="button" id="btnRegist" onclick="location.href='/mystudy/review/regist?${pageDTO.linkUrl}'">등록</button>
            </div>
        </div>
    </div>
</body>
</html>
