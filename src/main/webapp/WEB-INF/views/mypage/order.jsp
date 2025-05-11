<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>강좌 주문 내역</title>
</head>
<body>
<%@ include file="../common/sidebarHeader.jsp" %>

<div class="content">
    <svg xmlns="http://www.w3.org/2000/svg" class="d-none">
        <symbol id="house-door-fill" viewBox="0 0 16 16">
            <path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5z"/>
        </symbol>
    </svg>
    <div class="container my-5">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb breadcrumb-chevron p-3 bg-body-tertiary rounded-3">
                <li class="breadcrumb-item">
                    <a class="link-body-emphasis" href="/">
                        <svg class="bi" width="16" height="16" aria-hidden="true">
                            <use xlink:href="#house-door-fill"></use>
                        </svg>
                        <span class="visually-hidden">Home</span>
                    </a>
                </li>
                <li class="breadcrumb-item">
                    <a class="link-body-emphasis fw-semibold text-decoration-none" href="/mypage">마이페이지</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    강좌 주문 내역
                </li>
            </ol>
        </nav>
    </div>
    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">강좌 주문 내역</h3>
        </div>
        <%
            List<Map<String, String>> dateOptions = new ArrayList<>();
            dateOptions.add(Map.of("value", "orderCreatedAt", "label", "결제일자"));
            dateOptions.add(Map.of("value", "lectureCreatedAt", "label", "강의 생성일자"));
            request.setAttribute("dateOptions", dateOptions);

            List<Map<String, String>> searchTypeOptions = new ArrayList<>();
            searchTypeOptions.add(Map.of("value", "lectureTitle", "label", "강의 제목"));
            searchTypeOptions.add(Map.of("value", "lectureDescription", "label", "강의 설명"));
            searchTypeOptions.add(Map.of("value", "lectureTeacherId", "label", "선생님"));
            request.setAttribute("searchTypeOptions", searchTypeOptions);
            request.setAttribute("searchAction", "/mypage/order");

        %>
        <jsp:include page="../common/searchBox.jsp"/>

        <c:if test="${not empty orderList}">
            <table class="table table-hover text-center align-middle">
                <thead class="table-light">
                <tr>
                    <th>주문번호</th>
                    <th>구매 강좌</th>
                    <th>
                        <a href="javascript:void(0);" onclick="applySort('orderAmount')">
                            총액
                            <c:if test="${searchDTO.sortColumn eq 'orderAmount'}">
                                ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
                    <th>
                        <a href="javascript:void(1);" onclick="applySort('orderCreatedAt')">
                            구매일
                            <c:if test="${searchDTO.sortColumn eq 'orderCreatedAt'}">
                                ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
                    <th>
                        구매 상태
                    </th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${orderList}" var="boardReportDTO" varStatus="status">
                    <tr>
                        <td>${status.index + 1}</td>
                        <td class="text-start">
                            <c:forEach items="${boardReportDTO.orderLectureList}" var="lectureTitle" varStatus="loop">
                                <div class="mb-1">
                                    <i class="bi bi-play-circle text-primary me-1"><a href="#"
                                                                                      class="text-decoration-none text-dark"></a></i>
                                        ${lectureTitle}
                                </div>
                            </c:forEach>
                        </td>
                        <td><fmt:setLocale value="ko_KR"/>
                            <fmt:formatNumber value="${boardReportDTO.orderAmount}" type="currency"/>
                        </td>
                        <td>${boardReportDTO.orderCreatedAt.toLocalDate()}</td>
                        <td>
                            <c:choose>
                                <c:when test="${boardReportDTO.orderStatus eq 's'}">
                                    <form method="post" action="/mypage/order/confirm" class="d-inline">
                                        <input type="hidden" name="orderIdx" value="${boardReportDTO.orderIdx}"/>
                                        <input type="hidden" name="orderStatus" value="${boardReportDTO.orderStatus}"/>
                                        <button type="submit" class="btn btn-success btn-sm">구매 확정</button>
                                    </form>
                                    <form method="post" action="/mypage/order/refund" class="d-inline">
                                        <input type="hidden" name="orderIdx" value="${boardReportDTO.orderIdx}"/>
                                        <input type="hidden" name="orderStatus" value="${boardReportDTO.orderStatus}"/>
                                        <button type="submit" class="btn btn-outline-danger btn-sm">환불 요청</button>
                                    </form>
                                </c:when>

                                <c:when test="${boardReportDTO.orderStatus eq 'p'}">
                                    <form method="post" action="/mypage/order/cancel" class="d-inline">
                                        <input type="hidden" name="orderIdx" value="${boardReportDTO.orderIdx}"/>
                                        <input type="hidden" name="orderStatus" value="${boardReportDTO.orderStatus}"/>
                                        <button type="submit" class="btn btn-warning btn-sm">주문 취소</button>
                                    </form>
                                </c:when>

                                <c:when test="${boardReportDTO.orderStatus eq 'r'}">
                                    <span class="badge bg-secondary">환불 완료</span>
                                </c:when>

                                <c:when test="${boardReportDTO.orderStatus eq 'f'}">
                                    <span class="badge bg-success">구매 확정</span>
                                </c:when>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>

        <c:if test="${empty orderList}">
            <div class="alert alert-warning mt-4" role="alert">
                주문 내역이 없습니다.
            </div>
        </c:if>

        <div class="mt-4 text-center">
            <%@ include file="../common/paging.jsp" %>
        </div>
    </div>
</div>
<script>
    <c:if test="${not empty message}">
    alert("${message}");
    </c:if>
</script>
</body>
</html>
