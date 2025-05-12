<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/moment/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css"/>
</head>
<body>
<div class="search-box">
    <form name="frmSearch" method="get" action="${searchAction}" class="mb-1 p-4">
        <div class="row g-2 align-items-center mb-3">
            <c:if test="${param.startDate != null and param.endDate != null}">
                <c:set var="datefilter" value="${param.startDate} - ${param.endDate}" />
            </c:if>
            <c:if test="${not empty dateOptions}">
                <div class="col-md-2">
                    <select name="dateType" class="form-select">
                        <c:forEach var="item" items="${dateOptions}">
                            <option value="${item.value}" ${param.dateType eq item.value ? 'selected' : ''}>
                                    ${item.label}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </c:if>
            <c:if test="${empty isTeacher}">
                <div class="col-md-${not empty dateOptions ? '4' : '6'}">
                    <input type="text" name="datefilter" id="datefilter" class="form-control" placeholder="기간 선택" autocomplete="off"
                           value="${datefilter != null ? datefilter : ''}"/>
                </div>
            </c:if>
        </div>

        <div class="row g-2 align-items-center mb-3">
            <div class="col-md-2">
                <select name="searchType" class="form-select">
                    <c:forEach var="item" items="${searchTypeOptions}">
                        <option value="${item.value}" ${searchDTO.searchType eq item.value ? "selected" : ""}>
                                ${item.label}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-4">
                <input type="text" name="searchWord" class="form-control" placeholder="검색어 입력"
                       value="${searchDTO.searchWord != null ? searchDTO.searchWord : ''}"/>
            </div>
            <div class="col-md-3 d-flex gap-1">
                <button type="button" class="btn btn-primary flex-fill" id="btnSearch" onclick="submitSearch();">검색</button>
                <button type="button" class="btn btn-link flex-fill text-decoration-none" id="btnReset">초기화</button>
            </div>
        </div>
        <div class="row g-2 align-items-center">
            <div class="col-md-2">
                <select name="pageSize" class="form-select" onchange="submitSearch();">
                    <option value="" disabled ${empty pageDTO.pageSize ? 'selected' : ''}>선택</option>
                    <option value="1" ${pageDTO.pageSize == 1 ? "selected" : ""}>1개씩 보기</option>
                    <option value="5" ${pageDTO.pageSize == 5 ? "selected" : ""}>5개씩 보기</option>
                    <option value="10" ${pageDTO.pageSize == 10 ? "selected" : ""}>10개씩 보기</option>
                    <option value="15" ${pageDTO.pageSize == 15 ? "selected" : ""}>15개씩 보기</option>
                    <option value="100" ${pageDTO.pageSize == 100 ? "selected" : ""}>100개씩 보기</option>
                </select>
            </div>
        </div>
        <c:if test="${fn:contains(currentURI, '/qna') or fn:contains(currentURI, '/mypage/myQna')}">
            <div class="d-flex flex-wrap gap-3 justify-content-end">
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="answered" id="status_1" value="1"
                        ${param.answered eq 1 ? "checked" : ""} onchange="submitSearch();"/>
                    <label for="status_1">답변완료</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="answered" id="status_2" value="2"
                        ${param.answered eq 2 ? "checked" : ""} onchange="submitSearch();"/>
                    <label for="status_2">미답변</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="answered" id="status_3" value="3"
                        ${param.answered eq 3 ? "checked" : ""} onchange="submitSearch();"/>
                    <label for="status_3">전체</label>
                </div>
            </div>
        </c:if>
    </form>
</div>

<script>
    $(function () {
        $('input[name="datefilter"]').daterangepicker({
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

        $('#btnReset').click(function () {
            $('input[name="searchWord"]').val('');
            $('select[name="searchType"]').val('${searchTypeOptions[0].value}');
            $('input[name="datefilter"]').val('');

            const url = new URL(window.location.href);
            const params = url.searchParams;
            params.delete('startDate');
            params.delete('endDate');
            params.delete('searchType');
            params.delete('searchWord');

            window.location.href = url.toString();
        });
    });

    function submitSearch() {
        const url = new URL(location.href);
        const params = url.searchParams;

        const datefilterInput = document.querySelector('input[name="datefilter"]');
        const datefilter = datefilterInput ? datefilterInput.value : '';

        if (datefilter) {
            const dates = datefilter.split(' - ');
            params.set('startDate', dates[0]);
            params.set('endDate', dates[1]);
        } else {
            params.delete('startDate');
            params.delete('endDate');
        }

        const searchType = document.querySelector('select[name="searchType"]').value;
        const searchWord = document.querySelector('input[name="searchWord"]').value;
        if (searchWord && searchWord.length > 0) {
            params.set('searchType', searchType);
            params.set('searchWord', searchWord);
        } else {
            params.delete('searchType', searchType);
            params.delete('searchWord', searchWord);
        }

        const pageSize = document.querySelector('select[name="pageSize"]').value;
        if (pageSize) {
            params.set('pageSize', pageSize);
        } else {
            params.delete('pageSize');
        }

        const answered = document.querySelector('input[name="answered"]:checked');
        if (answered) {
            params.set('answered', answered.value);
        } else {
            params.delete('answered');
        }
        console.log("url: "+url.toString());
        location.href = url.toString();
    }

    function applySort(column) {
        const currentColumn = '${searchDTO.sortColumn}';
        const currentOrder = '${searchDTO.sortOrder}';
        const nextOrder = (currentColumn === column && currentOrder === 'asc') ? 'desc' : 'asc';

        const url = new URL(location.href);
        const params = url.searchParams;
        params.set('sortColumn', column);
        params.set('sortOrder', nextOrder);

        location.href = url.toString();
    }
</script>
</body>
</html>
