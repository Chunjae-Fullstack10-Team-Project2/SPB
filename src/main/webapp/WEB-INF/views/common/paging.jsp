<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<c:if test="${not empty responseDTO}">
    <nav aria-label="Page navigation">
        <ul class="pagination justify-content-center">
            <c:set var="baseUrl" value="${baseUrl}?searchType=${searchType}&searchWord=${searchWord}&orderField=${orderField}&orderSort=${orderSort}&page_no=" />

            <!-- << (첫 페이지) -->
            <c:choose>
                <c:when test="${responseDTO.page_no > 1}">
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
                <c:when test="${responseDTO.prev_page_flag}">
                    <li class="page-item">
                        <a class="page-link" href="${baseUrl}${responseDTO.page_no - 1}" aria-label="Previous">
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
            <c:forEach begin="${responseDTO.page_block_start}" end="${responseDTO.total_page}" var="i">
                <c:choose>
                    <c:when test="${i == responseDTO.page_no}">
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
                <c:when test="${responseDTO.next_page_flag}">
                    <li class="page-item">
                        <a class="page-link" href="${baseUrl}${responseDTO.page_no + 1}" aria-label="Next">
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
                <c:when test="${responseDTO.page_no < responseDTO.total_page}">
                    <li class="page-item">
                        <a class="page-link" href="${baseUrl}${responseDTO.total_page}" aria-label="Last">
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
