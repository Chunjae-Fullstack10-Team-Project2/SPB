<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

        .text-small {
            font-size: 85%;
        }

        .dropdown-toggle:not(:focus) {
            outline: 0;
        }
    </style>
</head>
<body>
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
                <c:if test="${sessionScope.memberGrade eq 13}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle px-2 link-body-emphasis" href="#" role="button"
                           data-bs-toggle="dropdown" aria-expanded="false">
                            나의강의실
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${cp}/myclass">내 강의 목록</a></li>
                            <li><a class="dropdown-item" href="${cp}/myclass/notice">공지사항</a></li>
                            <li><a class="dropdown-item" href="${cp}/myclass/qna">Q&A</a></li>
                            <li><a class="dropdown-item" href="${cp}/myclass/library">자료실</a></li>
                            <li><a class="dropdown-item" href="${cp}/myclass/grade">성적 관리</a></li>
                            <li><a class="dropdown-item" href="${cp}/myclass/review">수강후기</a></li>
                        </ul>
                    </li>
                </c:if>
<%--                <c:if test="${sessionScope.memberId ne null and sessionScope.memberGrade ne 13 and sessionScope.memberGrade ne 0}">--%>
<%--                    <li class="nav-item dropdown">--%>
<%--                        <a class="nav-link dropdown-toggle px-2 link-body-emphasis" href="#" role="button"--%>
<%--                           data-bs-toggle="dropdown" aria-expanded="false">--%>
<%--                            나의학습방--%>
<%--                        </a>--%>
<%--                        <ul class="dropdown-menu">--%>
<%--                            <li><a class="dropdown-item" href="${cp}/mystudy/lecture">내 강의 목록</a></li>--%>
<%--                            <li><a class="dropdown-item" href="${cp}/mystudy/qna">Q&A</a></li>--%>
<%--                            <li><a class="dropdown-item" href="${cp}/mystudy/grade">나의성적</a></li>--%>
<%--                            <li><a class="dropdown-item" href="${cp}/mystudy/review">수강후기</a></li>--%>
<%--                            <li><a class="dropdown-item" href="${cp}/mystudy/plan">학습계획표</a></li>--%>
<%--                        </ul>--%>
<%--                    </li>--%>
<%--                </c:if>--%>
                <li><a href="${cp}/teacher" class="nav-link px-2 link-body-emphasis">선생님</a></li>
                <li><a href="${cp}/lecture/main" class="nav-link px-2 link-body-emphasis">강좌</a></li>
                <li><a href="${cp}/faq/list" class="nav-link px-2 link-body-emphasis">자주 묻는 질문</a></li>
                <li><a href="${cp}/notice/list" class="nav-link px-2 link-body-emphasis">공지사항</a></li>
            </ul>

            <div class="d-flex align-items-center gap-4 flex-wrap justify-content-end user-tools">
                <c:if test="${sessionScope.memberGrade eq 0}">
                    <a href="${cp}/admin/" class="admin-link" title="관리자 페이지">
                        <i class="bi bi-gear-fill text-dark" style="font-size: 1.4rem;"></i>
                    </a>
                </c:if>
                <c:if test="${not empty sessionScope.memberId and sessionScope.memberGrade ne 0}">
                    <div class="greeting">${sessionScope.memberDTO.memberName} 님, 오늘도 즐거운 학습 되세요! 😊</div>
                    <div class="cart">
                        <a href="/payment/cart?memberId=${sessionScope.memberId}"
                           class="text-decoration-none position-relative">
                            <i class="bi bi-cart text-dark" style="font-size: 1.4rem;"></i>
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
                    <a href="#" class="d-block text-decoration-none dropdown-toggle text-dark" data-bs-toggle="dropdown">
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
                                <li><a class="dropdown-item" href="${cp}/qna/list">1:1 문의</a></li>
                                <li><a class="dropdown-item" href="${cp}/mypage">마이페이지</a></li>

                                <c:if test="${sessionScope.memberGrade ne 13}">
                                    <li><hr class="dropdown-divider"></li>
                                    <li class="dropdown-header">나의 학습방</li>
                                    <li><a class="dropdown-item" href="${cp}/mystudy">내 강의 목록</a></li>
                                    <li><a class="dropdown-item" href="${cp}/mystudy/qna">Q&A</a></li>
                                    <li><a class="dropdown-item" href="${cp}/mystudy/grade">나의성적</a></li>
                                    <li><a class="dropdown-item" href="${cp}/mystudy/review">수강후기</a></li>
                                    <li><a class="dropdown-item" href="${cp}/mystudy/plan">학습계획표</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                            </c:if>
                            <li><a class="dropdown-item" href="${cp}/login?action=logout">로그아웃</a></li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</header>
<script>
    $(document).ready(function () {
        function adjustContentMargin() {
            const headerHeight = $('header').outerHeight();
            $('.content-nonside').css('margin-top', (headerHeight + 50) + 'px');
        }

        adjustContentMargin();
        $(window).on('resize', adjustContentMargin);
    });

</script>
</body>
</html>
