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
                <%--            <c:set var="baseUrl" value="${baseUrl}?sortOrder=${searchDTO.sortOrder}&sortColumn=${searchDTO.sortColumn}pageSize=${responseDTO.pageSize}&dateType=${searchDTO.dateType}&startDate=${searchDTO.startDate}&endDate=${searchDTO.endDate}&searchType=${searchDTO.searchType}&searchWord=${searchDTO.searchWord}&pageNo=" />--%>
            <c:url var="baseQuery" value="${baseUrl}">
                <c:if test="${not empty responseDTO.pageSize}">
                    <c:param name="pageSize" value="${responseDTO.pageSize}"/>
                </c:if>
                <c:if test="${not empty searchDTO.searchWord}">
                    <c:param name="searchWord" value="${searchDTO.searchWord}"/>
                </c:if>
                <c:if test="${not empty searchDTO.searchType}">
                    <c:param name="searchType" value="${searchDTO.searchType}"/>
                </c:if>
                <c:if test="${not empty searchDTO.dateType}">
                    <c:param name="dateType" value="${searchDTO.dateType}"/>
                </c:if>
                <c:if test="${not empty searchDTO.sortColumn}">
                    <c:param name="sortColumn" value="${searchDTO.sortColumn}"/>
                </c:if>
                <c:if test="${not empty searchDTO.sortOrder}">
                    <c:param name="sortOrder" value="${searchDTO.sortOrder}"/>
                </c:if>
                <c:if test="${not empty searchDTO.startDate}">
                    <c:param name="startDate" value="${searchDTO.startDate}"/>
                </c:if>
                <c:if test="${not empty searchDTO.endDate}">
                    <c:param name="endDate" value="${searchDTO.endDate}"/>
                </c:if>
                <c:if test="${not empty param.reportState}">
                    <c:param name="reportState" value="${param.reportState}" />
                </c:if>

                <c:if test="${not empty param.answered}">
                    <c:param name="answered" value="${param.answered}" />
                </c:if>
            </c:url>
            <c:set var="baseUrl" value="${baseQuery}&pageNo="/>

            <!-- << (첫 페이지) -->
            <c:choose>
                <c:when test="${responseDTO.pageNo > 1}">
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
                <c:when test="${responseDTO.prevPageFlag}">
                    <li class="page-item">
                        <a class="page-link" href="${baseUrl}${responseDTO.pageNo - 1}" aria-label="Previous">
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
            <c:forEach begin="${responseDTO.pageBlockStart}" end="${responseDTO.pageBlockEnd}" var="i">
                <c:choose>
                    <c:when test="${i == responseDTO.pageNo}">
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
                <c:when test="${responseDTO.nextPageFlag}">
                    <li class="page-item">
                        <a class="page-link" href="${baseUrl}${responseDTO.pageNo + 1}" aria-label="Next">
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
                <c:when test="${responseDTO.pageNo < responseDTO.totalPage}">
                    <li class="page-item">
                        <a class="page-link" href="${baseUrl}${responseDTO.totalPage}" aria-label="Last">
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
