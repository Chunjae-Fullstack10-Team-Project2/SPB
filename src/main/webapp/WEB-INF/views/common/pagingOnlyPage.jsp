<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<c:if test="${not empty pageDTO and pageDTO.total_count > 0}">
    <%
        String url = request.getRequestURI().toString();
        request.setAttribute("baseUrl", url);
        System.out.println(url);
    %>
    <nav aria-label="Page navigation">
        <ul class="pagination justify-content-center mb-0">
            <c:url var="querystring" value="${url}">
                <c:param name="page_size" value="${pageDTO.page_size}" />
                <c:param name="page_block_size" value="${pageDTO.page_block_size}" />
                <c:if test="${pageDTO.search_category != null and pageDTO.search_word != null}">
                    <c:param name="search_category" value="${pageDTO.search_category}" />
                    <c:param name="search_word" value="${pageDTO.search_word}" />
                </c:if>
                <c:if test="${pageDTO.start_date != null and pageDTO.end_date != null}">
                    <c:param name="start_date" value="${pageDTO.start_date}" />
                    <c:param name="end_date" value="${pageDTO.end_date}" />
                </c:if>
                <c:if test="${pageDTO.sort_by != null and pageDTO.sort_direction != null}">
                    <c:param name="sort_by" value="${pageDTO.sort_by}" />
                    <c:param name="sort_direction" value="${pageDTO.sort_direction}" />
                </c:if>
            </c:url>
            <c:set var="baseUrl" value="${querystring}&page_no="/>

            <!-- << (첫 페이지) -->
            <c:choose>
                <c:when test="${pageDTO.page_no > 1}">
                    <li class="page-item">
                        <a class="page-link" href="${baseUrl}1" aria-label="First">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                </c:when>
                <c:otherwise>
                    <li class="page-item disabled">
                        <span class="page-link" aria-hidden="true">&laquo;</span>
                    </li>
                </c:otherwise>
            </c:choose>

            <!-- < (이전 페이지) -->
            <c:choose>
                <c:when test="${pageDTO.has_prev}">
                    <li class="page-item">
                        <a class="page-link" href="${baseUrl}${pageDTO.page_no - 1}" aria-label="Previous">
                            <span aria-hidden="true">&lt;</span>
                        </a>
                    </li>
                </c:when>
                <c:otherwise>
                    <li class="page-item disabled">
                        <span class="page-link" aria-hidden="true">&lt;</span>
                    </li>
                </c:otherwise>
            </c:choose>

            <!-- 페이지 번호 -->
            <c:forEach begin="${pageDTO.start_page}" end="${pageDTO.end_page}" var="i">
                <c:choose>
                    <c:when test="${i == pageDTO.page_no}">
                        <li class="page-item active">
                            <span class="page-link">${i}</span>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item">
                            <a class="page-link" href="${baseUrl}${i}">${i}</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <!-- > (다음 페이지) -->
            <c:choose>
                <c:when test="${pageDTO.has_next}">
                    <li class="page-item">
                        <a class="page-link" href="${baseUrl}${pageDTO.page_no + 1}" aria-label="Next">
                            <span aria-hidden="true">&gt;</span>
                        </a>
                    </li>
                </c:when>
                <c:otherwise>
                    <li class="page-item disabled">
                        <span class="page-link" aria-hidden="true">&gt;</span>
                    </li>
                </c:otherwise>
            </c:choose>

            <!-- >> (마지막 페이지) -->
            <c:choose>
                <c:when test="${pageDTO.page_no < pageDTO.total_page}">
                    <li class="page-item">
                        <a class="page-link" href="${baseUrl}${pageDTO.total_page}" aria-label="Last">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </c:when>
                <c:otherwise>
                    <li class="page-item disabled">
                        <span class="page-link" aria-hidden="true">&raquo;</span>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>
    </nav>
</c:if>
</body>
</html>
