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
<body class="container my-5">
<h2 class="mb-4">매출 대시보드</h2>

<!-- 날짜별 매출 -->
<section class="mb-5">
    <h4>날짜별 매출</h4>
    <div class="mb-2">
        <select id="timeType" class="form-select w-auto d-inline-block">
            <option value="YEAR">연도별</option>
            <option value="MONTH" selected>월별</option>
        </select>
    </div>
    <canvas id="monthlyChart" height="100"></canvas>
</section>

<!-- 강좌별 매출 -->
<section class="mb-5">
    <h4>강좌별 매출</h4>
    <div class="mb-2">
        <input type="text" id="lectureDateRange" class="form-control w-auto d-inline-block"/>
    </div>
    <canvas id="lectureChart" height="100"></canvas>
</section>

<!-- 전체 매출 내역 -->
<section>
    <h4>전체 매출 내역</h4>
    <form id="filterForm" class="row g-2 mb-3">
        <div class="col-md-2">
            <select name="searchType" class="form-select">
                <option value="" selected disabled>검색 조건</option>
                <option value="lectureTitle">강좌명</option>
                <option value="memberId">회원 아이디</option>
            </select>
        </div>
        <div class="col-md-3">
            <input type="text" name="searchWord" class="form-control" placeholder="검색어">
        </div>
        <div class="col-md-3">
            <input type="text" name="dateRange" id="detailDateRange" class="form-control" placeholder="구매일 범위">
        </div>
        <div class="col-md-2">
            <button type="submit" class="btn btn-primary">검색</button>
        </div>
    </form>
    <div>
        <table class="table table-bordered table-hover table-striped text-center align-middle">
            <thead class="table-light">
            <tr>
                <th>주문번호</th>
                <th>회원 ID</th>
                <th>강좌명</th>
                <th>금액</th>
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

<script>
    const cp = '${pageContext.request.contextPath}';

    function loadSalesDetail(pageNo = 1) {
        const formData = $('#filterForm').serializeArray();
        const params = {};
        $.each(formData, (i, field) => {
            params[field.name] = field.value;
        });
        params.pageNo = pageNo;

        $.get(cp + "/admin/sales/detail", params, function (response) {
            const rowsHtml = (response.dtoList || []).map(row => {
                return (
                    '<tr>' +
                    '<td>' + row.orderIdx + '</td>' +
                    '<td>' + row.orderMemberId + '</td>' +
                    '<td>' + (row.lectureTitle || '-') + '</td>' +
                    '<td>' + (row.orderAmount != null ? row.orderAmount.toLocaleString() + '원' : '-') + '</td>' +
                    '</tr>'
                );
            }).join("");

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

        if (prev) {
            $pagination.append(
                '<li class="page-item">' +
                '<a class="page-link" href="#" data-page="' + (startPage - 1) + '">&laquo;</a>' +
                '</li>'
            );
        }

        for (let i = startPage; i <= endPage; i++) {
            $pagination.append(
                '<li class="page-item ' + (i === pageNo ? 'active' : '') + '">' +
                '<a class="page-link" href="#" data-page="' + i + '">' + i + '</a>' +
                '</li>'
            );
        }

        if (next) {
            $pagination.append(
                '<li class="page-item">' +
                '<a class="page-link" href="#" data-page="' + (endPage + 1) + '">&raquo;</a>' +
                '</li>'
            );
        }
    }

    $(document).on('click', '#salesPagination .page-link', function (e) {
        e.preventDefault();
        const page = Number($(this).data('page'));
        if (page) {
            loadSalesDetail(page);
        }
    });

    $(function () {
        const now = moment();

        $('#lectureDateRange').daterangepicker({
            locale: {format: 'YYYY-MM-DD'},
            startDate: now.clone().subtract(29, 'days'),
            endDate: now,
            opens: 'left'
        }, loadLectureChart);

        let monthlyChartInstance = null; // 전역 변수로 Chart 인스턴스 저장

        function loadMonthlyChart() {
            const type = $('#timeType').val();

            $.get(cp + "/admin/sales/monthly", {timeType: type}, function (data) {
                const labels = data.map(item => item.label);
                const values = data.map(item => item.total);

                // 이미 차트가 있으면 먼저 제거
                if (monthlyChartInstance) {
                    monthlyChartInstance.destroy();
                }

                // 새 차트 생성 및 저장
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

        function loadLectureChart() {
            const range = $('#lectureDateRange').val().split(' - ');
            $.get(cp + "/admin/sales/lecture", {
                timeType: "DAY",
                startDate: range[0],
                endDate: range[1]
            }, function (data) {
                const labels = data.map(item => item.lectureTitle);
                const values = data.map(item => item.total);

                new Chart($('#lectureChart'), {
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

        $('#timeType').change(loadMonthlyChart);
        $('#lectureDateRange').on('apply.daterangepicker', loadLectureChart);
        $('#filterForm').submit(function (e) {
            e.preventDefault();
            loadSalesDetail();
        });

        loadMonthlyChart();
        loadLectureChart();
        loadSalesDetail();
    });
</script>
</body>
</html>
