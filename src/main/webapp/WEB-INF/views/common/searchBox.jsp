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
                <div class="col-md-3">
                    <input type="text" name="datefilter" id="datefilter" class="form-control" placeholder="기간 선택"
                           autocomplete="off"
                           value="${not empty param.datefilter ? param.datefilter : ''}"/>
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
            <div class="col-md-3">
                <input type="text" name="searchWord" class="form-control" placeholder="검색어 입력"
                       value="${searchDTO.searchWord}"/>
            </div>
            <div class="col-md-3 d-flex gap-1">
                <button type="submit" class="btn btn-primary flex-fill" id="btnSearch">검색</button>
                <button type="button" class="btn btn-link text-decoration-none" id="btnReset">초기화</button>
            </div>
        </div>
        <div class="row g-2 align-items-center mb-3">
            <div class="col-md-2">
                <select name="pageSize" class="form-select" onchange="this.form.submit()">
                    <option disabled ${empty pageDTO.pageSize ? 'selected' : ''}>선택</option>
                    <option value="1" ${pageDTO.pageSize == 1 ? "selected" : ""}>1개씩 보기</option>
                    <option value="5" ${pageDTO.pageSize == 5 ? "selected" : ""}>5개씩 보기</option>
                    <option value="10" ${pageDTO.pageSize == 10 ? "selected" : ""}>10개씩 보기</option>
                    <option value="15" ${pageDTO.pageSize == 15 ? "selected" : ""}>15개씩 보기</option>
                    <option value="100" ${pageDTO.pageSize == 100 ? "selected" : ""}>100개씩 보기</option>
                </select>
            </div>
            <c:if test="${fn:contains(currentURI, '/qna/')}">
                <div class="col-md-2">
                    <select name="answered" id="answered" class="form-select" onchange="this.form.submit()">
                        <option value="">답변 여부</option>
                        <option value="1" ${searchDTO.answered == 1 ? 'selected' : ''}>답변</option>
                        <option value="2" ${searchDTO.answered == 2 ? 'selected' : ''}>미답변</option>
                    </select>
                </div>
            </c:if>

        </div>
    </form>
</div>

<form id="frmSort" method="get" action="${searchAction}">
    <input type="hidden" name="pageSize" value="${responseDTO.pageSize}"/>
    <input type="hidden" name="searchWord" value="${searchDTO.searchWord}"/>
    <input type="hidden" name="searchType" value="${searchDTO.searchType}"/>
    <input type="hidden" name="dateType" value="${searchDTO.dateType}"/>
    <input type="hidden" name="startDate" value="${searchDTO.startDate}"/>
    <input type="hidden" name="endDate" value="${searchDTO.endDate}"/>
    <input type="hidden" name="sortColumn" id="sortColumn" value="${searchDTO.sortColumn}"/>
    <input type="hidden" name="sortOrder" id="sortOrder" value="${searchDTO.sortOrder}"/>
</form>

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

        $('#btnSearch').click(function (e) {
            e.preventDefault();

            const url = new URL(window.location.href);
            const params = url.searchParams;

            const datefilter = $('input[name="datefilter"]').val();
            if (datefilter) {
                const dates = datefilter.split(' - ');
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
            $('select[name="searchType"]').val('${searchTypeOptions[0].value}');
            $('input[name="datefilter"]').val('');

            const url = new URL(window.location.href);
            const params = url.searchParams;
            params.delete('datefilter');
            params.delete('startDate');
            params.delete('endDate');
            params.delete('searchType');
            params.delete('searchWord');

            window.location.href = url.toString();
        });
    });

    function applySort(column) {
        const currentColumn = '${searchDTO.sortColumn}';
        const currentOrder = '${searchDTO.sortOrder}';
        const nextOrder = (currentColumn === column && currentOrder === 'asc') ? 'desc' : 'asc';

        document.getElementById('sortColumn').value = column;
        document.getElementById('sortOrder').value = nextOrder;
        document.getElementById('frmSort').submit();
    }
</script>
</body>
</html>
