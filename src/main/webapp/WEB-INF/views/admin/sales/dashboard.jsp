<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>매출 정보</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>

    <style>
        body {
            background-color: #f4f6f9;
        }

        .dashboard-container {
            max-width: 1100px;

        }

        .chart-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            padding: 30px;
            margin-bottom: 40px;
        }

        .chart-title {
            font-size: 1.25rem;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .chart-controls {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .chart-wrapper {
            height: 400px;
        }

        @media (max-width: 768px) {
            .chart-wrapper {
                height: 300px;
            }
        }
    </style>
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
                    <a class="link-body-emphasis fw-semibold text-decoration-none" href="/admin/member/list">관리자 페이지</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    매출 정보
                </li>
            </ol>
        </nav>
    </div>
    <div>
        <div class="d-flex mb-4 dashboard-container">
            <h3 class="mb-0">매출 정보</h3>
            <div class="chart-card">
                <div class="chart-title">📊 매출 현황</div>
                <div class="chart-controls">
                    <select id="timeTypeSelect" class="form-select" style="width: 200px;">
                        <option value="month" selected>월별</option>
                        <option value="year">연도별</option>
                    </select>
                </div>
                <div class="chart-wrapper">
                    <canvas id="monthlySalesChart"></canvas>
                </div>
            </div>

            <div class="chart-card">
                <div class="chart-title">📈 강좌별 매출 분석</div>
                <div class="chart-controls">
                    <select id="lectureTimeTypeSelect" class="form-select" style="width: 200px;">
                        <option value="date">날짜별</option>
                        <option value="month" selected>월별</option>
                        <option value="year">연도별</option>
                    </select>
                    <input type="text" id="lectureDateRange" class="form-control" style="max-width: 250px;">
                </div>
                <div class="chart-wrapper">
                    <canvas id="lectureSalesChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let monthlyChart, lectureChart;
    const contextPath = '${pageContext.request.contextPath}';

    function loadMonthlySalesChart() {
        const timeType = $('#timeTypeSelect').val();

        $.ajax({
            url: contextPath + '/admin/sales/monthly',
            method: 'GET',
            data: {timeType},
            success: function (response) {
                const labels = response.map(e => e.period);
                const data = response.map(e => e.totalAmount);

                if (monthlyChart) monthlyChart.destroy();

                monthlyChart = new Chart(document.getElementById('monthlySalesChart'), {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: timeType === 'year' ? '연도별 매출 (₩)' : '월별 매출 (₩)',
                            data: data,
                            backgroundColor: 'rgba(75, 192, 192, 0.6)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: value => '₩' + value.toLocaleString()
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: true,
                                position: 'top'
                            }
                        }
                    }
                });
            }
        });
    }

    function loadLectureSalesChart() {
        const timeType = $('#lectureTimeTypeSelect').val();
        const dateRange = $('#lectureDateRange').val();

        if (!dateRange || !dateRange.includes(' - ')) {
            return; // 초기화 전이므로 실행하지 않음
        }

        const [startDate, endDate] = dateRange.split(' - ');

        $.ajax({
            url: contextPath + '/admin/sales/lecture',
            method: 'GET',
            data: {
                timeType,
                startDate,
                endDate
            },
            success: function (response) {
                const labels = response.map(e => e.lecture);
                const data = response.map(e => e.totalAmount);

                if (lectureChart) lectureChart.destroy();

                if (response.length === 0) {
                    if (lectureChart) lectureChart.destroy();
                    $('#lectureSalesChart').replaceWith('<p class="text-center text-muted">해당 기간에 강좌 매출 데이터가 없습니다.</p>');
                    return;
                }

                lectureChart = new Chart(document.getElementById('lectureSalesChart'), {
                    type: 'doughnut',
                    data: {
                        labels: labels,
                        datasets: [{
                            data: data,
                            backgroundColor: [
                                'lightpink', 'lightsalmon', 'lightseagreen', 'lightskyblue', 'lightslategray'
                                , 'lightyellow', 'lightgreen', 'lightgray'
                                , 'bisque', 'thistle', 'whitesmoke'
                            ]
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'bottom'
                            }
                        }
                    }
                });
            }
        });
    }

    $(function () {
        const defaultStart = moment().subtract(3, 'months').startOf('day');
        const defaultEnd = moment().endOf('day');

        $('#lectureDateRange').daterangepicker({
            locale: {format: 'YYYY-MM-DD'},
            startDate: defaultStart,
            endDate: defaultEnd
        });

        // 초기값 설정
        $('#lectureDateRange').val(
            defaultStart.format('YYYY-MM-DD') + ' - ' + defaultEnd.format('YYYY-MM-DD')
        );

        // 초기 로딩
        loadMonthlySalesChart();
        loadLectureSalesChart();

        $('#timeTypeSelect').on('change', loadMonthlySalesChart);
        $('#lectureTimeTypeSelect').on('change', loadLectureSalesChart);
        $('#lectureDateRange').on('apply.daterangepicker', loadLectureSalesChart);
    });
</script>
</body>
</html>