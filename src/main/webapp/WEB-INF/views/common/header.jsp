<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<html>
<head>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .text-small {
            font-size: 85%;
        }

        .dropdown-toggle:not(:focus) {
            outline: 0;
        }
    </style>

</head>
<body>
<header class="p-3 mb-3 border-bottom">
    <div class="container">
        <div class="d-flex flex-wrap align-items-center justify-content-center justify-content-lg-start">
            <a href="/" class="d-flex align-items-center mb-2 mb-lg-0 link-body-emphasis text-decoration-none">
<%--                <svg class="bi me-2" width="40" height="32" role="img" aria-label="Bootstrap">--%>
<%--                    <use xlink:href="#bootstrap"/>--%>
<%--                </svg>--%>
    🌱
            </a>

            <ul class="nav col-12 col-lg-auto me-lg-auto mb-2 justify-content-center mb-md-0">
                <li><a href="/main" class="nav-link px-2 link-secondary">홈</a></li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle px-2 link-body-emphasis" href="#" id="listDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        게시판
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="listDropdown">
                        <li><a class="dropdown-item" href="/board/freeboard/list">자유게시판</a></li>
                        <li><a class="dropdown-item" href="/board/eduinfo/list">교육정보</a></li>
                        <li><a class="dropdown-item" href="/board/uniinfo/list">대학정보</a></li>
                        <li><a class="dropdown-item" href="/board/exactivity/list">대외활동</a></li>
                        <li><a class="dropdown-item" href="/board/reference/list">자료공유</a></li>
                    </ul>
                </li>
                <li><a href="/qna/list" class="nav-link px-2 link-body-emphasis">1:1 문의</a></li>
                <li><a href="/faq/list" class="nav-link px-2 link-body-emphasis">자주 묻는 질문</a></li>
            </ul>

<%--            <form class="col-12 col-lg-auto mb-3 mb-lg-0 me-lg-4" role="search">--%>
<%--                <input type="search" class="form-control" placeholder="Search..." aria-label="Search">--%>
<%--            </form>--%>

            <div class="d-flex align-items-center">
                <a href="#" class="me-4 link-body-emphasis text-decoration-none position-relative">
                    <i class="bi bi-cart" style="font-size: 1.4rem;"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">0</span>
                </a>

                <div class="dropdown text-end ms-2">
                    <a href="#" class="d-block link-body-emphasis text-decoration-none dropdown-toggle"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <img src="https://github.com/mdo.png" alt="mdo" width="32" height="32" class="rounded-circle">
                    </a>
                    <ul class="dropdown-menu text-small">
                        <c:if test="${empty sessionScope.memberId}">
                            <li><a class="dropdown-item" href="/login">로그인</a></li>
                        </c:if>
                        <c:if test="${not empty sessionScope.memberId}">
                            <li><a class="dropdown-item" href="/qna/myQna">나의 문의</a></li>
                            <li><a class="dropdown-item" href="/mypage">마이페이지</a></li>
                            <li>
                                <hr class="dropdown-divider">
                            </li>
                            <li><a class="dropdown-item" href="/login?action=logout">로그아웃</a></li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</header>
</body>
</html>