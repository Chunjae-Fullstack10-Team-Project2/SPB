<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cp" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <title>매출 대시보드</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/moment@2.29.4/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

</head>
<body class="bg-light">
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
    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">매출 대시보드</h3>
        </div>

        <section class="mb-5">
            <h4>날짜별 매출</h4>
            <div class="mb-2">
                <select id="timeType" class="form-select w-auto d-inline-block">
                    <option value="YEAR">연도별</option>
                    <option value="MONTH" selected>월별</option>
                    <option value="DAY">날짜별</option>
                </select>
            </div>
            <div class="mb-2">
                <input type="date" id="monthlyStartDate" class="form-control w-auto d-inline-block"/>
                <input type="date" id="monthlyEndDate" class="form-control w-auto d-inline-block"/>
                <button type="button" id="btnLoadMonthlyChart" class="btn btn-secondary ms-2">조회</button>
            </div>
            <canvas id="monthlyChart" height="100"></canvas>
        </section>

        <section class="mb-5">
            <h4>강좌별 매출</h4>
            <div class="mb-2">
                <input type="date" id="lectureStartDate" class="form-control w-auto d-inline-block"/>
                <input type="date" id="lectureEndDate" class="form-control w-auto d-inline-block"/>
                <button type="button" id="btnLoadLectureChart" class="btn btn-secondary ms-2">조회</button>
            </div>
            <canvas id="lectureChart" height="80" class="w-100" style="max-height:300px;"></canvas>
        </section>

        <section>
            <h4>전체 매출 내역</h4>
            <div class="search-box">
                <form id="filterForm" name="frmSearch" method="get" class="mb-1 p-4">
                    <!-- 날짜 검색 -->
                    <div class="row g-2 align-items-center mb-3">
                        <div class="col-md-3">
                            <input type="date" name="startDate" class="form-control" placeholder="시작일" />
                        </div>
                        <div class="col-md-3">
                            <input type="date" name="endDate" class="form-control" placeholder="종료일" />
                        </div>
                    </div>

                    <!-- 조건 검색 -->
                    <div class="row g-2 align-items-center mb-3">
                        <div class="col-md-2">
                            <select name="searchType" class="form-select">
                                <option value="" selected disabled>검색 조건</option>
                                <option value="lectureTitle">강좌명</option>
                                <option value="memberId">회원 아이디</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <input type="text" name="searchWord" class="form-control" placeholder="검색어" />
                        </div>
                        <div class="col-md-3 d-flex gap-2">
                            <button type="submit" class="btn btn-primary flex-fill">검색</button>
                            <button type="button" class="btn btn-success flex-fill" id="btnDownloadExcel">엑셀 다운로드</button>
                        </div>
                    </div>
                </form>
            </div>

            <div>
                <table class="table table-bordered table-hover table-striped text-center align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>
                            <a href="javascript:void(0);" onclick="applySort('orderIdx')">
                                주문번호
                                <c:if test="${param.sortColumn == 'orderIdx'}">
                                    <c:choose>
                                        <c:when test="${param.sortOrder == 'asc'}">▲</c:when>
                                        <c:otherwise>▼</c:otherwise>
                                    </c:choose>
                                </c:if>
                            </a>
                        </th>
                        <th>
                            <a href="javascript:void(0);" onclick="applySort('orderMemberId')">
                                회원 ID
                                <c:if test="${param.sortColumn == 'orderMemberId'}">
                                    <c:choose>
                                        <c:when test="${param.sortOrder == 'asc'}">▲</c:when>
                                        <c:otherwise>▼</c:otherwise>
                                    </c:choose>
                                </c:if>
                            </a>
                        </th>
                        <th>
                            <a href="javascript:void(0);" onclick="applySort('lectureTitle')">
                                강좌명
                                <c:if test="${param.sortColumn == 'lectureTitle'}">
                                    <c:choose>
                                        <c:when test="${param.sortOrder == 'asc'}">▲</c:when>
                                        <c:otherwise>▼</c:otherwise>
                                    </c:choose>
                                </c:if>
                            </a>
                        </th>
                        <th>
                            <a href="javascript:void(0);" onclick="applySort('orderAmount')">
                                금액
                                <c:if test="${param.sortColumn == 'orderAmount'}">
                                    <c:choose>
                                        <c:when test="${param.sortOrder == 'asc'}">▲</c:when>
                                        <c:otherwise>▼</c:otherwise>
                                    </c:choose>
                                </c:if>
                            </a>
                        </th>
                        <th>
                            <a href="javascript:void(0);" onclick="applySort('orderCreatedAt')">
                                주문일자
                                <c:if test="${param.sortColumn == 'orderCreatedAt'}">
                                    <c:choose>
                                        <c:when test="${param.sortOrder == 'asc'}">▲</c:when>
                                        <c:otherwise>▼</c:otherwise>
                                    </c:choose>
                                </c:if>
                            </a>
                        </th>
                    </tr>
                    </thead>
                    <tbody id="salesDetailTable">
                    </tbody>
                </table>
                <div class="mt-3 d-flex justify-content-center">
                    <ul class="pagination" id="salesPagination"></ul>
                </div>
            </div>
        </section>
    </div>
</div>
<script>
    const cp = '<c:out value="${pageContext.request.contextPath}"/>';

    $('#btnDownloadExcel').click(function () {
        const params = {
            searchType: $('select[name=searchType]').val(),
            searchWord: $('input[name=searchWord]').val(),
            startDate: $('input[name=startDate]').val(),
            endDate: $('input[name=endDate]').val()
        };

        // 쿼리스트링 생성
        const query = Object.entries(params)
            .filter(([_, v]) => v !== '' && v !== null && v !== undefined)
            .map(([k, v]) => encodeURIComponent(k) + '=' + encodeURIComponent(v))
            .join('&');

        const downloadUrl = cp + '/admin/sales/export' + (query ? ('?' + query) : '');
        location.href = downloadUrl;
    });

    function formatOrderCreatedAtArray(arr) {
        if (!Array.isArray(arr) || arr.length < 5) return '-';

        const [y, mo, d, h, mi, s = 0] = arr;  // s가 없으면 0으로 기본값 설정
        const pad = n => String(n).padStart(2, '0');

        return y + '-' + pad(mo) + '-' + pad(d) + ' ' + pad(h) + ':' + pad(mi) + ':' + pad(s);
    }

    function loadSalesDetail(pageNo = 1) {
        const params = {
            pageNo: pageNo,
            searchWord: $('input[name=searchWord]').val(),
            searchType: $('select[name=searchType]').val(),
            startDate: $('input[name=startDate]').val(),
            endDate: $('input[name=endDate]').val()
        };

        // 빈 문자열 제거
        Object.keys(params).forEach(key => {
            if (params[key] === "") {
                delete params[key];
            }
        });

        // 정렬 정보
        const url = new URL(window.location.href);
        const sortColumn = url.searchParams.get('sortColumn');
        const sortOrder = url.searchParams.get('sortOrder');
        if (sortColumn) params.sortColumn = sortColumn;
        if (sortOrder) params.sortOrder = sortOrder;

        $.get(cp + "/admin/sales/detail", params, function (response) {
            const rowsHtml = (response.dtoList || []).map(row => {
                return (
                    '<tr>' +
                    '<td>' + row.orderIdx + '</td>' +
                    '<td>' + row.orderMemberId + '</td>' +
                    '<td>' + (row.lectureTitle || '-') + '</td>' +
                    '<td>' + (row.orderAmount != null ? row.orderAmount.toLocaleString() + '원' : '-') + '</td>' +
                    '<td>' + formatOrderCreatedAtArray(row.orderCreatedAt) + '</td>' +  // ✅ 추가
                    '</tr>'
                );
            }).join("");

            if ((response.dtoList || []).length === 0) {
                $('#salesDetailTable').html(
                    '<tr><td colspan="4"><div class="alert alert-warning mt-4" role="alert">게시글이 없습니다.</div></td></tr>'
                );
                $('#salesPagination').empty();
            }

            $('#salesDetailTable').html(rowsHtml);
            renderPagination(response);
        });
    }

    function renderPagination(data) {
        const $pagination = $('#salesPagination');
        $pagination.empty();

        const pageNo = data.pageNo;
        const startPage = data.pageBlockStart;
        const endPage = data.pageBlockEnd;
        const totalPage = data.totalPage;
        const prev = data.prevPageFlag;
        const next = data.nextPageFlag;

        if (totalPage <= 1) return;

        // << 첫 페이지
        $pagination.append(
            '<li class="page-item ' + (pageNo === 1 ? 'disabled' : '') + '">' +
            '<a class="page-link" href="#" data-page="1">&laquo;&laquo;</a>' +
            '</li>'
        );

        // < 이전 블록
        $pagination.append(
            '<li class="page-item ' + (!prev ? 'disabled' : '') + '">' +
            '<a class="page-link" href="#" data-page="' + (startPage - 1) + '">&laquo;</a>' +
            '</li>'
        );

        // 페이지 숫자
        for (let i = startPage; i <= endPage; i++) {
            $pagination.append(
                '<li class="page-item ' + (i === pageNo ? 'active' : '') + '">' +
                '<a class="page-link" href="#" data-page="' + i + '">' + i + '</a>' +
                '</li>'
            );
        }

        // > 다음 블록
        $pagination.append(
            '<li class="page-item ' + (!next ? 'disabled' : '') + '">' +
            '<a class="page-link" href="#" data-page="' + (endPage + 1) + '">&raquo;</a>' +
            '</li>'
        );

        // >> 마지막 페이지
        $pagination.append(
            '<li class="page-item ' + (pageNo === totalPage ? 'disabled' : '') + '">' +
            '<a class="page-link" href="#" data-page="' + totalPage + '">&raquo;&raquo;</a>' +
            '</li>'
        );
    }

    $(document).on('click', '#salesPagination .page-link', function (e) {
        e.preventDefault();
        const page = Number($(this).data('page'));
        if (page) {
            loadSalesDetail(page);
        }
    });

    function applySort(column) {
        const url = new URL(window.location.href);
        const currentSortColumn = url.searchParams.get("sortColumn");
        const currentSortOrder = url.searchParams.get("sortOrder") || "desc";

        let newSortOrder = "asc";
        if (currentSortColumn === column && currentSortOrder === "asc") {
            newSortOrder = "desc";
        }

        url.searchParams.set("sortColumn", column);
        url.searchParams.set("sortOrder", newSortOrder);
        //url.searchParams.set("pageNo", 1); // 정렬 시 첫 페이지로

        location.href = url.toString();
    }

    $(function () {
        const now = moment();

        $('#lectureDateRange').daterangepicker({
            locale: {format: 'YYYY-MM-DD'},
            startDate: now.clone().subtract(29, 'days'),
            endDate: now,
            opens: 'left'
        }, loadLectureChart);

        let monthlyChartInstance = null;
        $('#monthlyStartDate').val(moment().subtract(1, 'months').format('YYYY-MM-DD'));
        $('#monthlyEndDate').val(moment().format('YYYY-MM-DD'));

        function loadMonthlyChart() {
            const type = $('#timeType').val();
            const startDate = $('#monthlyStartDate').val();
            const endDate = $('#monthlyEndDate').val();

            const params = {timeType: type};
            if (startDate) params.startDate = startDate;
            if (endDate) params.endDate = endDate;

            $.get(cp + "/admin/sales/monthly", params, function (data) {
                const labels = data.map(item => item.label);
                const values = data.map(item => item.total);

                if (monthlyChartInstance) monthlyChartInstance.destroy();

                monthlyChartInstance = new Chart($('#monthlyChart'), {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: '총 매출',
                            data: values
                        }]
                    }
                });
            });
        }

        function updateMonthlyInputs() {
            const type = $('#timeType').val();
            const $start = $('#monthlyStartDate');
            const $end = $('#monthlyEndDate');

            if (type === 'YEAR') {
                $start.attr('type', 'number').attr('placeholder', '예: 2020').val('');
                $end.attr('type', 'number').attr('placeholder', '예: 2024').val('');
            } else if (type === 'MONTH') {
                $start.attr('type', 'month').val('');
                $end.attr('type', 'month').val('');
            } else {
                $start.attr('type', 'date').val('');
                $end.attr('type', 'date').val('');
            }

            setDefaultMonthlyDates(type);
        }

        $(function () {
            $('#timeType').on('change', function () {
                const type = $(this).val();
                updateMonthlyInputs();

                if (type === 'DAY') {
                    $('#monthlyStartDate, #monthlyEndDate').daterangepicker({
                        locale: { format: 'YYYY-MM-DD' },
                        startDate: moment().subtract(1, 'months'),
                        endDate: moment(),
                        opens: 'left'
                    }, function(start, end) {
                        $('#monthlyStartDate').val(start.format('YYYY-MM-DD'));
                        $('#monthlyEndDate').val(end.format('YYYY-MM-DD'));
                    });
                } else {
                    $('#monthlyStartDate, #monthlyEndDate').daterangepicker('destroy');
                }

                loadMonthlyChart();
            });

            updateMonthlyInputs(); // 초기 로딩 시에도 맞게 설정
        });

        let lectureChartInstance = null;
        $('#lectureStartDate').val(moment().subtract(1, 'months').format('YYYY-MM-DD'));
        $('#lectureEndDate').val(moment().format('YYYY-MM-DD'));

        function loadLectureChart() {
            const startDate = $('#lectureStartDate').val();
            const endDate = $('#lectureEndDate').val();

            if (!startDate || !endDate) return;

            $.get(cp + "/admin/sales/lecture", {
                timeType: "DAY",
                startDate: startDate,
                endDate: endDate
            }, function (data) {
                const labels = data.map(item => item.lectureTitle);
                const values = data.map(item => item.total);

                // 기존 차트 제거
                if (lectureChartInstance) {
                    lectureChartInstance.destroy();
                }

                lectureChartInstance = new Chart($('#lectureChart'), {
                    type: 'pie',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: '강좌 매출',
                            data: values
                        }]
                    }
                });
            });
        }

        $(function () {
            $('#btnLoadLectureChart').click(function () {
                loadLectureChart();
            });
        });

        $('#timeType').change(loadMonthlyChart);
        $('#filterForm').submit(function (e) {
            e.preventDefault();
            loadSalesDetail();
        });

        $(function () {
            $('#btnLoadMonthlyChart').click(function () {
                loadMonthlyChart();
            });

            $('#timeType').on('change', function () {
                updateMonthlyInputs(); // 입력 타입만 바꾸고 조회는 안 함
            });

            updateMonthlyInputs(); // 초기 설정
            loadMonthlyChart(); // 첫 차트 로딩
        });

        loadMonthlyChart();
        loadLectureChart();
        loadSalesDetail();
    });
</script>
</body>
</html>
