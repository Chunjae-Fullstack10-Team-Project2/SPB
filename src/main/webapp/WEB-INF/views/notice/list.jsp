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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/moment/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css"/>
    <style>
        .list-title {
            display: inline-block;
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .dropdown-section {
            position: relative;
            display: inline-block;
        }
        .dropdown-menu {
            display: none;
            position: absolute;
            right: 0;
            top: 35px;
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 8px;
            z-index: 999;
            min-width: 140px;
        }
        .dropdown-menu form {
            margin: 0;
        }
        .dropdown-button {
            width: 100%;
            padding: 8px 12px;
            margin: 4px 0;
            border: none;
            background: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
        }
        .dropdown-button:hover {
            background-color: #f2f2f2;
        }
        .bar-img {
            margin-left: 5px;
            width: 20px;
            cursor: pointer;
        }
        .fix-icon {
            width: 20px;
            height: 20px;
            background-color: #DDEB9D;
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
                <li class="breadcrumb-item active" aria-current="page">
                    공지사항
                </li>
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

        <form method="get" action="${pageContext.request.contextPath}/notice/list" class="mb-1 p-4">
            <input type="hidden" name="size" value="${size}" />

            <div class="row g-2 align-items-center mb-3">
                <div class="col-md-2">
                    <select name="searchType" class="form-select">
                        <option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
                        <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
                    </select>
                </div>

                <div class="col-md-3">
                    <input type="text" name="keyword" value="${keyword}" placeholder="검색어 입력" class="form-control" />
                </div>

                <div class="col-md-3 d-flex gap-1">
                    <button type="submit" class="btn btn-primary flex-fill">검색</button>
                    <button type="button" class="btn btn-link text-decoration-none" onclick="location.href='${pageContext.request.contextPath}/notice/list?size=${size}'">초기화</button>
                </div>
            </div>
        </form>

        <div class="d-flex justify-content-end mb-3">
            <form method="get" action="${pageContext.request.contextPath}/notice/list" class="d-flex align-items-center">
                <select name="size" class="form-select form-select-sm" style="width: auto;" onchange="this.form.submit()">
                    <option value="5" ${size == 5 ? 'selected' : ''}>5개</option>
                    <option value="10" ${size == 10 ? 'selected' : ''}>10개</option>
                    <option value="15" ${size == 15 ? 'selected' : ''}>15개</option>
                </select>
            </form>
        </div>

        <div class="list-group">
            <!-- 고정된 공지사항 -->
            <c:forEach var="notice" items="${fixedList}">
                <div class="list-group-item list-group-item-action d-flex justify-content-between align-items-start">
                    <div class="ms-2 me-auto">
                        <div class="d-flex align-items-center">
                            <img src="${pageContext.request.contextPath}/resources/images/fix.svg" class="fix-icon me-2" alt="고정">
                            <a href="${pageContext.request.contextPath}/notice/view?noticeIdx=${notice.noticeIdx}"
                               class="fw-bold text-decoration-none list-title">${notice.noticeTitle}</a>
                        </div>
                        <small class="text-muted">${notice.noticeCreatedAt.toLocalDate()}</small>
                    </div>


                    <c:if test="${not empty sessionScope.memberGrade and sessionScope.memberGrade == '0'}">
                        <div class="dropdown-section">
                            <img class="bar-img" src="${pageContext.request.contextPath}/resources/images/bar.svg" onclick="toggleDropdown(this)" />
                            <div class="dropdown-menu">
                                <form method="post" action="${pageContext.request.contextPath}/notice/unfix">
                                    <input type="hidden" name="noticeIdx" value="${notice.noticeIdx}" />
                                    <button type="submit" class="dropdown-button">고정 해제</button>
                                </form>
                            </div>
                        </div>
                    </c:if>
                </div>
            </c:forEach>

            <!-- 일반 공지사항 -->
            <c:forEach var="notice" items="${list}">
                <div class="list-group-item list-group-item-action d-flex justify-content-between align-items-start">
                    <div class="ms-2 me-auto">
                        <div class="d-flex align-items-center">
                            <a href="${pageContext.request.contextPath}/notice/view?noticeIdx=${notice.noticeIdx}"
                               class="fw-bold text-decoration-none list-title">${notice.noticeTitle}</a>
                        </div>
                        <small class="text-muted">${notice.noticeCreatedAt.toLocalDate()}</small>
                    </div>


                    <c:if test="${not empty sessionScope.memberGrade and sessionScope.memberGrade == '0'}">
                        <div class="dropdown-section">
                            <img class="bar-img" src="${pageContext.request.contextPath}/resources/images/bar.svg" onclick="toggleDropdown(this)" />
                            <div class="dropdown-menu">
                                <form method="post" action="${pageContext.request.contextPath}/notice/delete">
                                    <input type="hidden" name="noticeIdx" value="${notice.noticeIdx}" />
                                    <button type="submit" class="dropdown-button" id="btnDelete">삭제</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/notice/fix">
                                    <input type="hidden" name="noticeIdx" value="${notice.noticeIdx}" />
                                    <button type="submit" class="dropdown-button">고정 공지</button>
                                </form>
                            </div>
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

        <!-- 페이징 처리 -->
        <div class="mt-4 text-center">
            ${pagination}
        </div>
    </div>
</div>



<script>

    document.addEventListener('DOMContentLoaded', function () {
        console.log("Bootstrap Dropdown Initialization");
        const dropdownElements = document.querySelectorAll('.dropdown-toggle');
        dropdownElements.forEach(function (dropdownToggleEl) {
            new bootstrap.Dropdown(dropdownToggleEl);
        });

    // toggle
    function toggleDropdown(imgElement) {
        const dropdown = imgElement.nextElementSibling;
        document.querySelectorAll('.dropdown-menu').forEach(menu => {
            if (menu !== dropdown) {
                menu.style.display = 'none';
            }
        });
        dropdown.style.display = (dropdown.style.display === 'block') ? 'none' : 'block';
    }

    document.addEventListener('click', function(event) {
        const isDropdownButton = event.target.closest('.bar-img');
        const isDropdownMenu = event.target.closest('.dropdown-menu');
        const isWriteButton = event.target.closest('.btn-primary');

        if (!isDropdownButton && !isDropdownMenu && !isWriteButton) {
            document.querySelectorAll('.dropdown-menu').forEach(menu => {
                menu.style.display = 'none';
            });
        }

        if (event.target.id === 'btnDelete') {
            event.preventDefault();
            event.stopPropagation();

            if (window.confirm('정말 삭제하시겠습니까?')) {
                event.target.closest("form").submit();
            }
        }
    });

</script>
</body>
</html>