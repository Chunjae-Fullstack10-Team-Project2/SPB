<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>봄콩이 ${category.displayName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<%@ include file="../common/sidebarHeader.jsp" %>
<div class="content">
    <div class="container my-5">
        <%@ include file="../common/breadcrumb.jsp" %>

        <div class="container my-5">
    <h2 class="mb-4">${category.displayName} 🌱</h2>

    <!-- 상단 글 개수 및 페이지 사이즈 선택 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <span>${postTotalCount}개의 글</span>
        <select class="form-select form-select-sm w-auto" name="page_size" id="selectPageSize">
            <option value="5" ${search.page_size eq "5" ? "selected":""}>5개씩</option>
            <option value="10" ${search.page_size eq "10" ? "selected":""}>10개씩</option>
            <option value="15" ${search.page_size eq "15" ? "selected":""}>15개씩</option>
            <option value="20" ${search.page_size eq "20" ? "selected":""}>20개씩</option>
            <option value="30" ${search.page_size eq "30" ? "selected":""}>30개씩</option>
        </select>
    </div>

    <!-- 게시판 테이블 -->
    <table class="table table-hover align-middle text-center small">
        <colgroup>
            <col style="width: 80px">
            <col>
            <col style="width: 118px">
            <col style="width: 118px">
            <col style="width: 68px">
            <col style="width: 68px">
        </colgroup>
        <thead class="table-light">
        <tr>
            <th>글번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th>작성일</th>
            <th>조회수</th>
            <th>좋아요</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty posts}">
                <c:forEach var="post" items="${posts}">
                    <tr>
                        <td>${post.postIdx}</td>
                        <td class="text-start">
                            <a href="view?idx=${post.postIdx}" class="text-dark text-decoration-none">
                                    ${post.postTitle}
                            </a>
                        </td>
                        <td>${post.postMemberId}</td>
                        <td>${fn:substringBefore(post.postCreatedAt, 'T')}</td>
                        <td>${post.postReadCnt}</td>
                        <td>${post.postLikeCnt}</td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="6">등록된 게시글이 없습니다.</td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>

    <!-- 페이징 -->
    <div class="d-flex justify-content-center my-3">
        ${paging}
    </div>

    <!-- 글 작성 버튼 -->
    <div class="d-flex justify-content-end mb-4">
        <button type="button" class="btn btn-outline-dark btn-sm" id="btnRegist">
            <i class="bi bi-pencil-square"></i> 글 작성
        </button>
    </div>

    <!-- 검색창 -->
    <form name="frmSearch" action="" method="get" class="row gy-2 gx-3 align-items-end justify-content-center">
        <div class="col-auto">
            <label class="form-label">날짜</label>
            <div class="d-flex align-items-center gap-1">
                <input type="date" class="form-control form-control-sm" name="search_date1" value="${search.search_date1}"/>
                ~
                <input type="date" class="form-control form-control-sm" name="search_date2" value="${search.search_date2}"/>
            </div>
        </div>
        <div class="col-auto">
            <select class="form-select form-select-sm" name="search_type">
                <option value="titlecontent">제목+내용</option>
                <option value="title" ${search.search_type eq "postTitle" ? "selected":""}>제목</option>
                <option value="content" ${search.search_type eq "postContent" ? "selected":""}>내용</option>
                <option value="author" ${search.search_type eq "postMemberId" ? "selected":""}>작성자</option>
            </select>
        </div>
        <div class="col-auto">
            <input type="text" class="form-control form-control-sm" name="search_word" value="${search.search_word}"/>
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-dark btn-sm">검색</button>
            <button type="button" class="btn btn-outline-secondary btn-sm" id="btnSearchInit">초기화</button>
        </div>
    </form>
    </div>
    </div>
</div>

<!-- 스크립트 -->
<script>
    document.getElementById('btnRegist').addEventListener('click', function () {
        window.location.href = "write";
    });

    document.getElementById('btnSearchInit').addEventListener('click', function () {
        window.location.href = "list";
    });

    document.getElementById("selectPageSize").addEventListener('change', function () {
        const pageSize = this.value;
        const url = new URL(window.location.href);
        url.searchParams.set("page_size", pageSize);
        window.location.href = url.toString();
    });
</script>
</body>
</html>
