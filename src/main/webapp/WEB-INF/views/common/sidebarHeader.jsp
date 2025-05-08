<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="cp" value="${pageContext.request.contextPath}" />

<html>
<head>
    <%-- Bootstrap, Icons --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <%-- jQuery, daterangepicker (선택) --%>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/moment/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css"/>

    <%-- 기타 --%>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <link href="../resources/css/global.css" rel="stylesheet">

    <style>
        header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 11;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 280px;
            height: 100vh;
            background-color: #f8f9fa;
            z-index: 10;
        }

        body {
            min-height: 100vh;
            min-height: -webkit-fill-available;
        }

        html {
            height: -webkit-fill-available;
        }

        main {
            height: 100vh;
            max-height: 100vh;
            overflow-x: auto;
            overflow-y: hidden;
        }

        .dropdown-toggle:not(:focus) {
            outline: 0;
        }

        .btn-toggle {
            padding: .25rem .5rem;
            font-weight: 600;
            color: var(--bs-emphasis-color);
            background-color: transparent;
        }

        .btn-toggle:hover,
        .btn-toggle:focus {
            color: rgba(var(--bs-emphasis-color-rgb), .85);
            background-color: var(--bs-tertiary-bg);
        }

        .btn-toggle::before {
            width: 1.25em;
            line-height: 0;
            content: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='rgba%280,0,0,.5%29' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M5 14l6-6-6-6'/%3e%3c/svg%3e");
            transition: transform .35s ease;
            transform-origin: .5em 50%;
        }

        .btn-toggle[aria-expanded="true"]::before {
            transform: rotate(90deg);
        }

        .btn-toggle-nav a {
            padding: .1875rem .5rem;
            margin-top: .125rem;
            margin-left: 1.25rem;
        }

        .btn-toggle-nav a:hover {
            background-color: var(--bs-tertiary-bg);
        }
    </style>
</head>
<body>

<%-- Header --%>
<header class="p-3 border-bottom">
    <div class="container">
        <div class="d-flex flex-wrap align-items-center justify-content-between">
            <a href="${cp}/main" class="d-flex align-items-center mb-2 mb-lg-0 text-decoration-none">
                <img width="40" src="${cp}/resources/img/spb_single_logo.png" alt="로고">
            </a>

            <ul class="nav col-12 col-lg-auto me-lg-auto mb-2 justify-content-center mb-md-0">
                <li><a href="${cp}/main" class="nav-link px-2 link-secondary">봄콩이</a></li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle px-2 link-body-emphasis" href="#" id="listDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        게시판
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${cp}/board/freeboard/list">자유게시판</a></li>
                        <li><a class="dropdown-item" href="${cp}/board/eduinfo/list">교육정보</a></li>
                        <li><a class="dropdown-item" href="${cp}/board/uniinfo/list">대학정보</a></li>
                        <li><a class="dropdown-item" href="${cp}/board/exactivity/list">대외활동</a></li>
                        <li><a class="dropdown-item" href="${cp}/board/reference/list">자료공유</a></li>
                        <li><a class="dropdown-item" href="${cp}/board/news">뉴스</a></li>
                    </ul>
                </li>
                <li><a href="${cp}/qna/list" class="nav-link px-2 link-body-emphasis">1:1 문의</a></li>
                <li><a href="${cp}/faq/list" class="nav-link px-2 link-body-emphasis">자주 묻는 질문</a></li>
            </ul>

            <div class="d-flex align-items-center">

                <a href="/payment/cart?memberId=${sessionScope.memberId}" class="me-4 text-decoration-none position-relative">
                    <i class="bi bi-cart" style="font-size: 1.4rem;"></i>
                    <c:if test="${not empty sessionScope.memberId}">
                        <span id="cart-count-badge" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">0</span>
                    </c:if>
                    <c:if test="${empty sessionScope.memberId}">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">0</span>
                    </c:if>
                </a>

                <div class="dropdown text-end">
                    <a href="#" class="d-block text-decoration-none dropdown-toggle"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <img src="https://github.com/mdo.png" alt="프로필" width="32" height="32" class="rounded-circle">
                    </a>
                    <ul class="dropdown-menu text-small">
                        <c:if test="${empty sessionScope.memberId}">
                            <li><a class="dropdown-item" href="${cp}/login">로그인</a></li>
                        </c:if>
                        <c:if test="${not empty sessionScope.memberId}">
                            <li><a class="dropdown-item" href="${cp}/mypage">마이페이지</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${cp}/login?action=logout">로그아웃</a></li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</header>

<%-- Sidebar --%>
<div class="flex-shrink-0 p-3 sidebar" id="sidebar">
    <a href="${cp}/" class="d-flex align-items-center pb-3 mb-3 text-decoration-none border-bottom text-dark">
        <span class="fs-5 fw-semibold">봄콩이</span>
    </a>
    <ul class="list-unstyled ps-0">
        <li class="mb-1">
            <button class="btn btn-toggle d-inline-flex align-items-center collapsed" data-bs-toggle="collapse" data-bs-target="#home-collapse">
                Home
            </button>
            <div class="collapse show" id="home-collapse">
                <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                    <li><a href="#" class="d-inline-flex text-decoration-none rounded text-dark">어쩌구</a></li>
                    <li><a href="#" class="d-inline-flex text-decoration-none rounded text-dark">Reports</a></li>
                </ul>
            </div>
        </li>
        <li class="mb-1">
            <button class="btn btn-toggle d-inline-flex align-items-center collapsed" data-bs-toggle="collapse" data-bs-target="#dashboard-collapse">
                Dashboard
            </button>
            <div class="collapse" id="dashboard-collapse">
                <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                    <li><a href="${cp}/board/freeboard/list" class="d-inline-flex text-decoration-none rounded text-dark">자유게시판</a></li>
                </ul>
            </div>
        </li>
        <li class="mb-1">
            <button class="btn btn-toggle d-inline-flex align-items-center collapsed" data-bs-toggle="collapse" data-bs-target="#orders-collapse">
                마이페이지
            </button>
            <div class="collapse" id="orders-collapse">
                <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                    <li><a href="${cp}/mypage/likes" class="d-inline-flex text-decoration-none rounded text-dark">좋아요 목록</a></li>
                    <li><a href="${cp}/mypage/report" class="d-inline-flex text-decoration-none rounded text-dark">게시글 신고</a></li>
                    <li><a href="${cp}/qna/myQna" class="d-inline-flex text-decoration-none rounded text-dark">나의 문의</a></li>
                    <li><a href="${cp}/mypage/order" class="d-inline-flex text-decoration-none rounded text-dark">강좌 주문 내역</a></li>
                </ul>
            </div>
        </li>
    </ul>
</div>


<script>
    function adjustSidebarPadding() {
        const header = document.querySelector('header');
        const sidebar = document.getElementById('sidebar');
        if (header && sidebar) {
            const headerHeight = header.offsetHeight;
            sidebar.style.marginTop = headerHeight + 'px';
        }
    }
    window.addEventListener('load', adjustSidebarPadding);
    window.addEventListener('resize', adjustSidebarPadding);

    $(document).ready(function () {
        if("${sessionScope.memberId}" != null) {
            $.ajax({
                url: '/payment/cartCount',
                type: 'GET',
                success: function (count) {
                    $('#cart-count-badge').text(count);
                },
                error: function () {
                    console.warn("장바구니 수량 조회 실패");
                }
            });
        }
    });
</script>
</body>
</html>