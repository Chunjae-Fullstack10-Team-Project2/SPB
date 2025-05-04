<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>나의 1:1 문의</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/moment/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css"/>
</head>
<body>
<%@ include file="../../common/header.jsp" %>
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
                <a class="link-body-emphasis fw-semibold text-decoration-none" href="/qna/list">1:1 문의</a>
            </li>
        </ol>
    </nav>
</div>
<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="mb-0">나의 문의 목록</h3>
        <a href="/qna/regist" class="btn btn-primary">
            <i class="bi bi-pencil-square"></i> 문의 등록
        </a>
    </div>
    <div class="search-box" style="max-width: 700px;">
        <form name="frmSearch" method="get" action="/qna/list" class="mb-1 p-4">
            <%--            border rounded shadow-sm bg-light--%>
            <div class="row g-2 align-items-center mb-3">
                <div class="col-md-8">
                    <input type="text" name="datefilter" id="datefilter" class="form-control" placeholder="기간 선택"
                           autocomplete="off"
                           value="${not empty param.datefilter ? param.datefilter : ''}"/>
                </div>
            </div>

            <div class="row g-2 align-items-center mb-3">
                <div class="col-md-3">
                    <select name="searchType" class="form-select">
                        <option value="qnaTitle" ${searchDTO.searchType eq "qnaTitle" ? "selected":""}>제목</option>
                        <option value="qnaQContent" ${searchDTO.searchType eq "qnaQContent" ? "selected":""}>질문 내용
                        </option>
                        <option value="qnaQMemberId" ${searchDTO.searchType eq "qnaQMemberId" ? "selected":""}>질문 작성자
                        </option>
                        <option value="qnaAContent" ${searchDTO.searchType eq "qnaAContent" ? "selected":""}>답변 내용
                        </option>
                        <option value="qnaAMemberId" ${searchDTO.searchType eq "qnaAMemberId" ? "selected":""}>답변 작성자
                        </option>
                    </select>
                </div>
                <div class="col-md-5">
                    <input type="text" name="searchWord" class="form-control" placeholder="검색어 입력"
                           value="${searchDTO.searchWord}"/>
                </div>
                <div class="col-md-3 d-flex gap-1">
                    <button type="submit" class="btn btn-primary flex-fill" id="btnSearch">검색</button>
                    <button type="button" class="btn btn-link text-decoration-none" id="btnReset">초기화</button>
                </div>
            </div>
        </form>
    </div>
    <c:if test="${not empty qnaList}">
        <div class="list-group">
            <c:forEach var="qnaDTO" items="${qnaList}">
                <a href="/qna/view?qnaIdx=${qnaDTO.qnaIdx}"
                   class="list-group-item list-group-item-action d-flex justify-content-between align-items-start">
                    <div class="ms-2 me-auto">
                        <div class="fw-bold">${qnaDTO.qnaTitle}</div>
                        <small class="text-muted">작성자: ${qnaDTO.qnaQMemberId}</small>
                    </div>
                    <div class="d-flex flex-column align-items-end">
                        <c:choose>
                            <c:when test="${not empty qnaDTO.qnaAnsweredAt}">
                                <span class="badge bg-success mb-1">답변</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger mb-1">미답변</span>
                            </c:otherwise>
                        </c:choose>
                        <small class="text-muted"><fmt:formatDate value="${qnaDTO.qnaCreatedAt}"
                                                                  pattern="yyyy-MM-dd"/></small>
                    </div>
                </a>
            </c:forEach>
        </div>
    </c:if>

    <c:if test="${empty qnaList}">
        <div class="alert alert-warning mt-4" role="alert">
            등록된 문의가 없습니다.
        </div>
    </c:if>

    <div class="mt-4 text-center">
        <%@ include file="../../common/paging.jsp" %>
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
