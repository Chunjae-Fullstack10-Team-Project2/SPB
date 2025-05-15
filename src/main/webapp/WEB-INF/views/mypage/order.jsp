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
<body class="bg-light-subtle">
<%@ include file="../common/sidebarHeader.jsp" %>

<div class="content">
    <div class="container my-5">
        <%@ include file="../common/breadcrumb.jsp" %>
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
                    <th>
                        구매 내역 상세
                    </th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${orderList}" var="reportDTO" varStatus="status">
                    <tr>
                        <td>${reportDTO.orderIdx}</td>
                            <%-- <a href="/lecture/lectureDetail?lectureIdx=${orderDTO.lectureIdx}" class="text-decoration-none text-dark">--%>
                        <td class="text-start">
                            <c:forEach items="${reportDTO.orderLectureDTOList}" var="lecture" varStatus="loop">
                                <div class="mb-1">
                                    <i class="bi bi-play-circle text-primary me-1"></i>
                                    <a href="/lecture/lectureDetail?lectureIdx=${lecture.lectureIdx}" class="text-decoration-none text-dark">
                                            ${lecture.lectureTitle}
                                    </a>
                                </div>
                            </c:forEach>
                        </td>
                        <td><fmt:setLocale value="ko_KR"/>
                            <fmt:formatNumber value="${reportDTO.orderAmount}" type="number"/>원
                        </td>
                        <td>${reportDTO.orderCreatedAt.toLocalDate()}</td>
                        <td>
                            <c:choose>
                                <c:when test="${reportDTO.orderStatus eq 's'}">
                                    <form method="post" action="/mypage/order/confirm" class="d-inline">
                                        <input type="hidden" name="orderIdx" value="${reportDTO.orderIdx}"/>
                                        <input type="hidden" name="orderStatus" value="${reportDTO.orderStatus}"/>
                                        <button type="submit" class="btn btn-success btn-sm"
                                                onclick="return confirm('정말로 구매를 확정하시겠습니까?')">구매 확정
                                        </button>
                                    </form>
                                    <form method="post" action="/mypage/order/refund" class="d-inline">
                                        <input type="hidden" name="orderIdx" value="${reportDTO.orderIdx}"/>
                                        <input type="hidden" name="orderStatus" value="${reportDTO.orderStatus}"/>
                                        <button type="submit" class="btn btn-outline-secondary btn-sm"
                                                onclick="return confirm('정말로 환불을 요청하시겠습니까?')">환불 요청
                                        </button>
                                    </form>
                                </c:when>

                                <c:when test="${reportDTO.orderStatus eq 'p'}">
                                    <form method="post" action="/mypage/order/cancel" class="d-inline">
                                        <input type="hidden" name="orderIdx" value="${reportDTO.orderIdx}"/>
                                        <input type="hidden" name="orderStatus" value="${reportDTO.orderStatus}"/>
                                        <button type="submit" class="btn btn-warning btn-sm"
                                                onclick="return confirm('정말로 주문을 취소하시겠습니까?')">주문 취소
                                        </button>
                                    </form>
                                </c:when>

                                <c:when test="${reportDTO.orderStatus eq 'r'}">
                                    <span class="badge bg-secondary">환불 완료</span>
                                </c:when>

                                <c:when test="${reportDTO.orderStatus eq 'f'}">
                                    <span class="badge bg-success">구매 확정</span>
                                </c:when>
                            </c:choose>
                        </td>
                        <td>
                            <button type="submit" class="btn btn-secondary btn-sm"
                                    onclick="window.location.href='/payment/paymentDetail?orderIdx=${reportDTO.orderIdx}'"/>구매 내역 상세
                            </button>
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
