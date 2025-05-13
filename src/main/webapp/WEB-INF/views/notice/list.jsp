<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String uri = request.getRequestURI();
    request.setAttribute("currentURI", uri);
%>
<!DOCTYPE html>
<html>
<head>
    <title>공지사항 목록</title>
    <style>
        .list-title {
            display: inline-block;
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .fix-icon {
            width: 20px;
            height: 20px;
            background-color: #DDEB9D;
            border: 4px #DDEB9D;
            border-radius: 100%;
        }

    </style>
</head>
<body>
<%@ include file="../common/header.jsp" %>

<div class="content-nonside">
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
                <li class="breadcrumb-item active" aria-current="page">공지사항</li>
            </ol>
        </nav>
    </div>

    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">공지사항 목록</h3>
            <c:if test="${not empty sessionScope.memberGrade and sessionScope.memberGrade == '0'}">
                <a href="${pageContext.request.contextPath}/notice/regist" class="btn btn-primary">
                    <i class="bi bi-pencil-square"></i> 글 작성
                </a>
            </c:if>
        </div>

        <!-- 서치박스 -->
        <form name="frmSearch" id="frmSearch" method="get" action="/notice/list" class="mb-1 p-4">
            <div class="row g-2 align-items-center mb-3">
                <div class="col-md-3">
                    <input type="text" class="form-control" id="datefilter" name="datefilter"
                           value="${not empty param.startDate and not empty param.endDate ? param.startDate.concat(' - ').concat(param.endDate) : ''}"
                           placeholder="기간 선택" autocomplete="off">
                </div>
            </div>

            <div class="row g-2 align-items-center mb-3">
                <div class="col-md-2">
                    <select id="searchType" name="searchType" class="form-select">
                        <option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
                        <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
                    </select>
                </div>

                <div class="col-md-5">
                    <input type="text" id="keyword" name="keyword" class="form-control" value="${keyword}" placeholder="검색어 입력">
                </div>

                <div class="col-md-2 d-flex gap-1">
                    <button type="submit" class="btn btn-primary flex-fill" id="btnSearch">검색</button>
                    <button type="button" id="btnReset" class="btn btn-link text-decoration-none">초기화</button>
                </div>
            </div>

            <div class="row g-2 align-items-center mb-3">
                <div class="col-md-3">
                    <select id="sizeSelect" name="size" class="form-select">
                        <option value="5" ${size == 5 ? 'selected' : ''}>5개씩 보기</option>
                        <option value="10" ${size == 10 ? 'selected' : ''}>10개씩 보기</option>
                        <option value="15" ${size == 15 ? 'selected' : ''}>15개씩 보기</option>
                    </select>
                </div>
            </div>
        </form>





        <div class="list-group">
            <c:forEach var="notice" items="${fixedList}">
                <div class="list-group-item d-flex justify-content-between align-items-start">
                    <div class="ms-2 me-auto">
                        <div class="d-flex align-items-center">
                            <img src="${pageContext.request.contextPath}/resources/images/fix.svg" class="fix-icon me-2" alt="고정">
                            <a href="${pageContext.request.contextPath}/notice/view?noticeIdx=${notice.noticeIdx}"
                               class="fw-bold text-decoration-none list-title">${notice.noticeTitle}</a>
                        </div>
                        <small class="text-muted">${notice.noticeCreatedAt.toLocalDate()}</small>
                    </div>

                    <c:if test="${sessionScope.memberGrade == '0'}">
                        <div class="dropdown">
                            <a href="#" class="dropdown-toggle" data-bs-toggle="dropdown">

                            </a>
                            <ul class="dropdown-menu text-small">
                                <li>
                                    <form method="post" action="${pageContext.request.contextPath}/notice/unfix">
                                        <input type="hidden" name="noticeIdx" value="${notice.noticeIdx}" />
                                        <button type="submit" class="dropdown-item">고정 해제</button>
                                    </form>
                                </li>
                            </ul>
                        </div>
                    </c:if>
                </div>
            </c:forEach>

            <c:forEach var="notice" items="${list}">
                <div class="list-group-item d-flex justify-content-between align-items-start">
                    <div class="ms-2 me-auto">
                        <a href="${pageContext.request.contextPath}/notice/view?noticeIdx=${notice.noticeIdx}"
                           class="fw-bold text-decoration-none list-title">${notice.noticeTitle}</a>
                        <div><small class="text-muted">${notice.noticeCreatedAt.toLocalDate()}</small></div>
                    </div>

                    <c:if test="${sessionScope.memberGrade == '0'}">
                        <div class="dropdown">
                            <a href="#" class="dropdown-toggle" data-bs-toggle="dropdown">

                            </a>
                            <ul class="dropdown-menu text-small">
                                <li>
                                    <form method="post" action="${pageContext.request.contextPath}/notice/delete">
                                        <input type="hidden" name="noticeIdx" value="${notice.noticeIdx}" />
                                        <button type="submit" class="dropdown-item" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
                                    </form>
                                </li>
                                <li>
                                    <form method="post" action="${pageContext.request.contextPath}/notice/fix">
                                        <input type="hidden" name="noticeIdx" value="${notice.noticeIdx}" />
                                        <button type="submit" class="dropdown-item">고정 공지</button>
                                    </form>
                                </li>
                            </ul>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>

        <c:if test="${list == null || list.isEmpty()}">
            <div class="alert alert-warning mt-4" role="alert">
                등록된 공지사항이 없습니다!
            </div>
        </c:if>

        <div class="mt-4 text-center">
            ${pagination}
        </div>
    </div>
</div>

<script>
    $(function() {
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


        $('input[name="datefilter"]').on('apply.daterangepicker', function(ev, picker) {
            var startDate = picker.startDate.format('YYYY-MM-DD');
            var endDate = picker.endDate.format('YYYY-MM-DD');
            console.log("선택된 시작 날짜:", startDate);
            console.log("선택된 종료 날짜:", endDate);
            $(this).val(startDate + ' - ' + endDate);
        });


        $('input[name="datefilter"]').on('cancel.daterangepicker', function(ev, picker) {
            $(this).val('');
        });

        // 검색 버튼
        $('#btnSearch').click(function(e) {
            e.preventDefault();
            search();
        });


        $('#keyword').keypress(function(e) {
            if (e.which === 13) {
                e.preventDefault();
                search();
            }
        });

        // 초기화 버튼
        $('#btnReset').click(function() {
            $('input[name="datefilter"]').val('');
            $('#searchType').val('title');
            $('#keyword').val('');
            search();
        });


        $('#frmSearch').submit(function(e) {
            e.preventDefault();
            search();
        });
    });

    // 검색
    function search() {
        var params = new URLSearchParams();
        params.append('page', '1');


        var datefilter = $('input[name="datefilter"]').val();
        console.log("날짜 필터 값:", datefilter);

        if (datefilter && datefilter.trim() !== '') {
            var dates = datefilter.split(' - ');
            if (dates.length === 2) {
                console.log("시작 날짜:", dates[0]);
                console.log("종료 날짜:", dates[1]);


                if (isValidDate(dates[0]) && isValidDate(dates[1])) {
                    params.append('startDate', dates[0]);
                    params.append('endDate', dates[1]);
                } else {
                    console.error("날짜 형식이 올바르지 않습니다.");
                }
            } else {
                console.error("날짜 범위 형식이 올바르지 않습니다:", datefilter);
            }
        }

        // 검색
        var searchType = $('#searchType').val();
        if (searchType) {
            params.append('searchType', searchType);
        }

        // 키워드
        var keyword = $('#keyword').val();
        if (keyword) {
            params.append('keyword', keyword);
        }

        // 개수
        var size = $('#sizeSelect').val();
        if (size) {
            params.append('size', size);
        }


        var url = '${pageContext.request.contextPath}/notice/list';
        if (params.toString()) {
            url += '?' + params.toString();
        }

        console.log("이동할 URL:", url);
        window.location.href = url;
    }


    function isValidDate(dateString) {

        var regex = /^\d{4}-\d{2}-\d{2}$/;
        if (!regex.test(dateString)) return false;


        var parts = dateString.split("-");
        var year = parseInt(parts[0], 10);
        var month = parseInt(parts[1], 10) - 1;
        var day = parseInt(parts[2], 10);

        var date = new Date(year, month, day);

        return (
            date.getFullYear() === year &&
            date.getMonth() === month &&
            date.getDate() === day
        );
    }


    document.getElementById("sizeSelect").addEventListener('change', function () {
        const size = this.value;
        const url = new URL(window.location.href);
        url.searchParams.set("size", size);
        url.searchParams.set("page", 1);
        console.log("표시 개수 변경 URL:", url.toString());
        window.location.href = url.toString();
    });
</script>
</body>
</html>
