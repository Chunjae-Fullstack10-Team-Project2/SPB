<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/moment/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css"/>
    <style>
        * {
            white-space: nowrap;
        }
    </style>
</head>
<body>
    <%
        String uri = request.getRequestURI();
        request.setAttribute("currentURI", uri);
    %>
    <div class="search-box">
        <form name="frmSearch" method="get" action="${searchAction}" class="mb-1 p-4">
            <c:if test="${fn:contains(currentURI, '/grade')}">
                <div class="row g-2 align-items-center mb-3">
                    <div class="col-md-6">
                        <select name="lectureIdx" class="form-select">
                            <option value="" ${param.lectureIdx eq null ? "selected" : ""}>강좌를 선택하세요.</option>
                            <c:forEach var="item" items="${lectureList}">
                                <option value="${item.lectureIdx}" ${param.lectureIdx != null and param.lectureIdx == item.lectureIdx ? "selected" : ""}>
                                        ${item.lectureTitle}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </c:if>
            <div class="row g-2 align-items-center mb-3">
                <c:if test="${param['start_date'] != null and param['end_date'] != null}">
                    <c:set var="date_value" value="${param['start_date']} - ${param['end_date']}" />
                </c:if>
                <c:if test="${not empty dateSelect}">
                    <div class="col-md-2">
                        <select name="date_type" class="form-select">
                            <c:forEach var="item" items="${dateSelect}">
                                <option value="${item.value}" ${param.date_type eq item.value ? "selected" : ""}>
                                    ${item.label}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </c:if>
                <div class="col-md-${not empty dateSelect ? '4' : '6'}">
                    <input type="text" name="date_value" class="form-control" placeholder="기간 선택" autocomplete="off"
                           value="${date_value != null ? date_value : ""}">
                </div>
            </div>
            <div class="row g-2 align-items-center mb-3">
                <div class="col-md-2">
                    <select name="search_category" class="form-select">
                        <c:forEach var="item" items="${searchSelect}">
                            <option value="${item.value}" ${param['search_category'] eq item.value ? "selected" : ""}>
                                ${item.label}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <input type="text" name="search_word" class="form-control" placeholder="검색어 입력"
                           value="${param['search_word']}"/>
                </div>
                <div class="col-md-3 d-flex gap-1">
                    <button type="button" class="btn btn-primary flex-fill" id="btnSearch" onclick="submitSearch();">검색</button>
                    <button type="button" class="btn btn-link flex-fill text-decoration-none" id="btnReset">초기화</button>
                </div>
            </div>
        </form>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <span>${totalCount}개의 글</span>
            <div class="d-flex align-items-center gap-3">
                <c:if test="${fn:contains(currentURI, '/qna')}">
                    <div class="d-flex flex-wrap gap-3">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="qna_status" id="status_2" value="2"
                                ${param.qna_status eq null or param.qna_status eq 2 ? "checked" : ""} onchange="submitSearch();"/>
                            <label for="status_2">전체</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="qna_status" id="status_0" value="0"
                                ${param.qna_status eq 0 ? "checked" : ""} onchange="submitSearch();"/>
                            <label for="status_0">미답변</label>
                        </div>
                        <div class="form-check" >
                            <input class="form-check-input" type="radio" name="qna_status" id="status_1" value="1"
                                ${param.qna_status eq 1 ? "checked" : ""} onchange="submitSearch();"/>
                            <label for="status_1">답변완료</label>
                        </div>
                    </div>
                </c:if>

                <select class="form-select form-select-sm w-auto" name="page_size" onchange="submitSearch();">
                    <option value="5" ${param.page_size eq "5" ? "selected":""}>5개씩</option>
                    <option value="10" ${param.page_size eq "10" ? "selected":""}>10개씩</option>
                    <option value="15" ${param.page_size eq "15" ? "selected":""}>15개씩</option>
                    <option value="20" ${param.page_size eq "20" ? "selected":""}>20개씩</option>
                    <option value="30" ${param.page_size eq "30" ? "selected":""}>30개씩</option>
                </select>
            </div>
        </div>
    </div>

    <script>
        $(function() {
            $('input[name="date_value"]').daterangepicker({
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

            $('input[name="date_value"]').on('apply.daterangepicker', function (ev, picker) {
                $(this).val(picker.startDate.format('YYYY-MM-DD') + ' - ' + picker.endDate.format('YYYY-MM-DD'));
            });

            $('#btnReset').click(function () {
                $('select[name="search_category"]').val('${searchSelect[0].value}');
                $('input[name="search_word"]').val('');
                $('input[name="date_value"]').val('');

                const url = new URL(location.href);
                const params = url.searchParams;
                params.delete('start_date');
                params.delete('end_date');
                params.delete('search_category');
                params.delete('search_word');

                location.href = url.toString();
            });
        });

        function submitSearch() {
            const url = new URL(location.href);
            const params = url.searchParams;

            const lectureEL = document.querySelector('select[name="lectureIdx"]');
            if (lectureEL) {
                const lectureIdx = lectureEL.value;
                if (lectureIdx) {
                    params.set('lectureIdx', lectureIdx);
                } else {
                    params.delete('lectureIdx');
                }
            }

            const dateTypeEl = document.querySelector('select[name="date_type"]');
            if (dateTypeEl) {
                const date_type = dateTypeEl.value;
                if (date_type) {
                    params.set('date_type', date_type);
                } else {
                    params.delete('date_type');
                }
            }

            const dateValueEl = document.querySelector('input[name="date_value"]');
            if (dateValueEl) {
                const date_value = dateValueEl.value;
                if (date_value) {
                    const dates = date_value.split(' - ');
                    params.set('start_date', dates[0]);
                    params.set('end_date', dates[1]);
                } else {
                    params.delete('start_date');
                    params.delete('end_date');
                }
            }

            const searchCategoryEl = document.querySelector('select[name="search_category"]');
            const searchWordEl = document.querySelector('input[name="search_word"]');
            if (searchCategoryEl && searchWordEl) {
                const search_category = searchCategoryEl.value;
                const search_word = searchWordEl.value;
                if (search_word && search_word.length > 0) {
                    params.set('search_category', search_category);
                    params.set('search_word', search_word);
                } else {
                    params.delete('search_category');
                    params.delete('search_word');
                }
            }

            const pageSizeEl = document.querySelector('select[name="page_size"]');
            if (pageSizeEl) {
                const page_size = pageSizeEl.value;
                if (page_size) {
                    params.set('page_size', page_size);
                } else {
                    params.delete('page_size');
                }
            }

            const qnaStatusEl = document.querySelector('input[name="qna_status"]:checked');
            if (qnaStatusEl) {
                params.set('qna_status', qnaStatusEl.value);
            } else {
                params.delete('qna_status');
            }


            location.href = url.toString();
        }

        function applySort(column) {
            const currentColumn = '${param["sort_by"]}';
            const currentOrder = '${param["sort_direction"]}';
            const nextOrder = (currentColumn === column && currentOrder === 'asc') ? 'desc' : 'asc';

            const url = new URL(location.href);
            const params = url.searchParams;
            params.set('sort_by', column);
            params.set('sort_direction', nextOrder);

            location.href = url.toString();
        }
    </script>
</body>
</html>
