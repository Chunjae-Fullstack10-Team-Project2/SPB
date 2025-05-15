<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String uri = request.getRequestURI();
    request.setAttribute("currentURI", uri);
%>
<html>
<head>
    <title>미답변 문의 관리</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/moment/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css"/>
</head>
<body>
<%@ include file="../../common/sidebarHeader.jsp" %>

<div class="content">
    <svg xmlns="http://www.w3.org/2000/svg" class="d-none">
        <symbol id="house-door-fill" viewBox="0 0 16 16">
            <path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5z"/>
        </symbol>
    </svg>
    <div class="container my-5">
        <%@ include file="../../common/breadcrumb.jsp" %>
    </div>

    <div class="container my-5" style="height: 100%; min-height: 100vh;">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">미답변 문의 관리</h3>
        </div>
        <%
            List<Map<String, String>> searchTypeOptions = new ArrayList<>();
            searchTypeOptions.add(Map.of("value", "qnaTitle", "label", "제목"));
            searchTypeOptions.add(Map.of("value", "qnaQContent", "label", "문의 내용"));
            searchTypeOptions.add(Map.of("value", "qnaQMemberId", "label", "문의 작성자"));
            searchTypeOptions.add(Map.of("value", "qnaAContent", "label", "답변 내용"));
            searchTypeOptions.add(Map.of("value", "qnaAMemberId", "label", "답변 작성자"));
            request.setAttribute("searchTypeOptions", searchTypeOptions);
            request.setAttribute("searchAction", "/qna/list");
        %>
        <jsp:include page="../../common/searchBox.jsp"/>
        <c:if test="${not empty notAnsweredQnaList}">
            <div class="list-group">
                <c:forEach var="qnaDTO" items="${notAnsweredQnaList}">
                    <div class="list-group-item list-group-item-action d-flex justify-content-between align-items-start"
                         style="cursor: pointer;"
                         onclick="handleQnaClick(${qnaDTO.qnaIdx}, '${qnaDTO.qnaQPwd ne 0 ? 'Y' : 'N'}')">
                        <div class="ms-2 me-auto">
                            <div class="fw-bold"><a
                                    href="${pageContext.request.contextPath}/qna/view?qnaIdx=${qnaDTO.qnaIdx}"
                                    class="fw-bold text-decoration-none text-dark">${qnaDTO.qnaTitle}</a></div>
                            <small class="text-muted">작성자: ${qnaDTO.qnaQMemberId}</small>
                        </div>
                        <div class="d-flex flex-column align-items-end">
                            <span class="badge bg-danger mb-1">미답변</span>
                            <small class="text-muted">
                                <fmt:formatDate value="${qnaDTO.qnaCreatedAt}" pattern="yyyy-MM-dd"/>
                            </small>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${empty notAnsweredQnaList}">
            <div class="alert alert-warning mt-4" role="alert">
                등록된 문의가 없습니다.
            </div>
        </c:if>

        <div class="mt-4 text-center">
            <%@ include file="../../common/paging.jsp" %>
        </div>
    </div>
</div>
<script>
    $(function () {
        $('input[name="datefilter"]')
            .daterangepicker({
                autoUpdateInput: false,
                locale: {
                    format: "YYYY-MM-DD",
                    separator: " - ",
                    applyLabel: "확인",
                    cancelLabel: "취소",
                    customRangeLabel: "Custom",
                    weekLabel: "주",
                    daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
                    monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                    firstDay: 1
                }
            });

        $('input[name="datefilter"]').on('apply.daterangepicker', function (ev, picker) {
            $(this).val(picker.startDate.format('YYYY-MM-DD') + ' - ' + picker.endDate.format('YYYY-MM-DD'));
        });

        $('#btnSearch').click(function (e) {
            e.preventDefault();

            var url = new URL(window.location.href);
            var params = url.searchParams;

            var datefilter = $('input[name="datefilter"]').val();
            if (datefilter) {
                var dates = datefilter.split(' - ');
                params.set('startDate', dates[0]);
                params.set('endDate', dates[1]);
            } else {
                params.delete('startDate');
                params.delete('endDate');
            }

            params.set('searchType', $('select[name="searchType"]').val());
            params.set('searchWord', $('input[name="searchWord"]').val());

            window.location.href = url.toString();
        });

        $('#btnReset').click(function () {
            $('input[name="searchWord"]').val('');
            $('select[name="searchType"]').val('qnaTitle');
            $('input[name="datefilter"]').val('');

            var url = new URL(window.location.href);
            var params = url.searchParams;
            params.delete('datefilter');
            params.delete('startDate');
            params.delete('endDate');
            params.delete('searchType');
            params.delete('searchWord');

            window.location.href = url.toString();
        });
    });

    <c:if test="${not empty message}">
    alert("${message}");
    </c:if>
</script>
</body>
</html>
