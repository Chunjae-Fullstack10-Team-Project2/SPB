<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<html>
<head>
    <%-- Bootstrap, Icons --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- moment.js -->
    <script src="https://cdn.jsdelivr.net/npm/moment@2.29.4/min/moment.min.js"></script>

    <!-- daterangepicker -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css"/>
    <script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>

    <%-- 기타 --%>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <link href="/resources/css/global.css" rel="stylesheet">

    <style>
        @font-face {
            font-family: 'NPSfontBold';
            src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_2310@1.0/NPSfontBold.woff2') format('woff2');
            font-weight: 700;
            font-style: normal;
        }

        header, header * {
            font-family: 'NPSfontBold', sans-serif !important;
        }

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

        .sidebar .btn-toggle-nav li {
            margin-bottom: 1rem;
        }

    </style>
</head>
<body>

<%-- Header --%>
<header class="p-3 border-bottom">
    <div class="container">
        <div class="d-flex flex-wrap align-items-center justify-content-between flex-column flex-lg-row">
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
                <li><a href="${cp}/notice/list" class="nav-link px-2 link-body-emphasis">공지사항</a></li>
            </ul>

            <div class="d-flex align-items-center gap-4 flex-wrap justify-content-end user-tools">
                <c:if test="${sessionScope.memberGrade eq 0}">
                    <a href="${cp}/admin/member/list" class="admin-link" title="관리자 페이지">
                        <i class="bi bi-gear-fill" style="font-size: 1.4rem;"></i>
                    </a>
                </c:if>
                <c:if test="${not empty sessionScope.memberId and sessionScope.memberGrade ne 0}">
                    <div class="greeting">${sessionScope.memberDTO.memberName} 님, 오늘도 즐거운 학습 되세요! 😊</div>
                </c:if>
                <c:if test="${not empty sessionScope.memberId}">
                    <div class="cart">
                        <a href="/payment/cart?memberId=${sessionScope.memberId}"
                           class="text-decoration-none position-relative">
                            <i class="bi bi-cart" style="font-size: 1.4rem;"></i>
                            <c:if test="${not empty sessionScope.memberId}">
                                <span id="cart-count-badge"
                                      class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                        ${cartCount}
                                </span>
                            </c:if>
                        </a>
                    </div>
                </c:if>

                <div class="dropdown text-end">
                    <a href="#" class="d-block text-decoration-none dropdown-toggle" data-bs-toggle="dropdown">
                        <img id="profilePreview" width="32" height="32" class="rounded-circle"
                             src="${pageContext.request.contextPath}/upload/${memberDTO.memberProfileImg}"
                             onerror="this.src='${cp}/resources/img/default_profileImg.png';"
                             alt="프로필 이미지">
                    </a>
                    <ul class="dropdown-menu text-small">
                        <c:if test="${empty sessionScope.memberId}">
                            <li><a class="dropdown-item" href="${cp}/login">로그인</a></li>
                        </c:if>
                        <c:if test="${not empty sessionScope.memberId}">
                            <c:if test="${sessionScope.memberGrade != 0}">
                                <li><a class="dropdown-item" href="${cp}/mypage">마이페이지</a></li>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                            </c:if>
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
    <ul class="list-unstyled ps-0">
        <li class="mb-3">
            <button class="btn btn-toggle d-inline-flex align-items-center collapsed mb-2" data-bs-toggle="collapse"
                    data-bs-target="#dashboard-collapse">
                게시판
            </button>
            <div class="collapse" id="dashboard-collapse">
                <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                    <li><a class="d-inline-flex text-decoration-none rounded text-dark"
                           href="${cp}/board/freeboard/list">자유게시판</a>
                    </li>
                    <li><a class=" d-inline-flex text-decoration-none rounded text-dark"
                           href="${cp}/board/eduinfo/list">교육정보</a>
                    </li>
                    <li><a class=" d-inline-flex text-decoration-none rounded text-dark"
                           href="${cp}/board/uniinfo/list">대학정보</a>
                    </li>
                    <li><a class=" d-inline-flex text-decoration-none rounded text-dark"
                           href="${cp}/board/exactivity/list">대외활동</a>
                    </li>
                    <li><a class=" d-inline-flex text-decoration-none rounded text-dark"
                           href="${cp}/board/reference/list">자료공유</a>
                    </li>
                    <li><a class=" d-inline-flex text-decoration-none rounded text-dark" href="${cp}/board/news">뉴스</a>
                    </li>
                </ul>
            </div>
        </li>
        <c:if test="${sessionScope.memberGrade eq 0}">
            <li class="mb-3">
                <button class="btn btn-toggle d-inline-flex align-items-center collapsed mb-2" data-bs-toggle="collapse"
                        data-bs-target="#admin-collapse">
                    관리 페이지
                </button>
                <div class="collapse" id="admin-collapse">
                    <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                        <li><a href="${cp}/admin/member/list"
                               class="d-inline-flex text-decoration-none rounded text-dark">회원 목록</a></li>
                        <li><a href="${cp}/admin/report/list/board"
                               class="d-inline-flex text-decoration-none rounded text-dark">게시글 신고 내역</a></li>
                        <li><a href="${cp}/admin/report/list/review"
                               class="d-inline-flex text-decoration-none rounded text-dark">강의평 신고 내역</a></li>
                        <li><a href="${cp}/admin/teacher/regist"
                               class="d-inline-flex text-decoration-none rounded text-dark">강의 등록</a></li>
                        <li><a href="${cp}/notice/regist" class="d-inline-flex text-decoration-none rounded text-dark">공지사항
                            등록</a></li>
                        <li><a href="${cp}/admin/sales/info"
                               class="d-inline-flex text-decoration-none rounded text-dark">매출 정보</a></li>
                    </ul>
                </div>
            </li>
        </c:if>
        <c:if test="${not empty sessionScope.memberId and sessionScope.memberGrade ne 0}">
            <li class="mb-3">
                <button class="btn btn-toggle d-inline-flex align-items-center collapsed mb-2" data-bs-toggle="collapse"
                        data-bs-target="#mypage-collapse">
                    마이 페이지
                </button>
                <div class="collapse" id="mypage-collapse">
                    <ul class="btn-toggle-nav list-unstyled fw-normal pb-1 small">
                        <li><a href="${cp}/mypage/post" class="d-inline-flex text-decoration-none rounded text-dark">작성한
                            게시글</a></li>
                        <li><a href="${cp}/mypage/likes" class="d-inline-flex text-decoration-none rounded text-dark">추천한
                            게시글</a></li>
                        <li><a href="${cp}/mypage/report" class="d-inline-flex text-decoration-none rounded text-dark">신고한
                            게시글</a></li>
                        <li><a href="${cp}/qna/myQna" class="d-inline-flex text-decoration-none rounded text-dark">나의
                            문의</a>
                        </li>
                        <li><a href="${cp}/mypage/bookmark"
                               class="d-inline-flex text-decoration-none rounded text-dark">북마크한 강좌</a></li>
                        <li><a href="${cp}/mypage/order" class="d-inline-flex text-decoration-none rounded text-dark">강좌
                            주문
                            내역</a></li>
                    </ul>
                </div>
            </li>
        </c:if>
    </ul>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const path = location.pathname;

        if (path.includes('/mypage')) {
            const myCollapse = document.querySelector('#mypage-collapse');
            const myToggle = document.querySelector('[data-bs-target="#mypage-collapse"]');
            myCollapse.classList.add('show');
            myToggle.setAttribute('aria-expanded', 'true');
        }

        if (path.includes('/admin')) {
            const adminCollapse = document.querySelector('#admin-collapse');
            const adminToggle = document.querySelector('[data-bs-target="#admin-collapse"]');
            adminCollapse.classList.add('show');
            adminToggle.setAttribute('aria-expanded', 'true');
        }

        if (path.includes('/board/')) {
            const boardCollapse = document.querySelector('#dashboard-collapse');
            const boardToggle = document.querySelector('[data-bs-target="#dashboard-collapse"]');
            boardCollapse.classList.add('show');
            boardToggle.setAttribute('aria-expanded', 'true');
        }
    });

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
        function adjustContentMargin() {
            const headerHeight = $('header').outerHeight();
            $('.content').css('margin-top', (headerHeight + 50) + 'px');
        }

        adjustContentMargin();
        $(window).on('resize', adjustContentMargin);
    });
</script>
</body>
</html>