<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>공지사항 상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light-subtle">
<%@ include file="../common/header.jsp" %>

<svg xmlns="http://www.w3.org/2000/svg" class="d-none">
    <symbol id="house-door-fill" viewBox="0 0 16 16">
        <path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5z"/>
    </symbol>
</svg>

<div class="container my-5 pt-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb p-3 bg-body-tertiary rounded-3">
            <li class="breadcrumb-item">
                <a class="link-body-emphasis" href="/">
                    <svg class="bi" width="16" height="16" aria-hidden="true">
                        <use xlink:href="#house-door-fill"></use>
                    </svg>
                    <span class="visually-hidden">Home</span>
                </a>
            </li>
            <li class="breadcrumb-item">
                <a class="link-body-emphasis fw-semibold text-decoration-none" href="/notice/list">공지사항</a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">
                ${dto.noticeTitle}
            </li>
        </ol>
    </nav>

    <div class="card mb-4">
        <div class="card-header">
            <h4>${dto.noticeTitle}</h4>
        </div>
        <div class="card-body">
            <input type="hidden" id="idx" value="${dto.noticeIdx}">

            <div class="mb-3 row">
                <label class="col-sm-2 col-form-label">작성자</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" value="${dto.noticeMemberId}" readonly>
                </div>
            </div>

            <div class="mb-3 row">
                <label class="col-sm-2 col-form-label">등록일</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" value="${createdAtStr}" readonly>
                </div>
            </div>

            <c:if test="${not empty updatedAtStr}">
                <div class="mb-3 row">
                    <label class="col-sm-2 col-form-label">수정일</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" value="${updatedAtStr}" readonly>
                    </div>
                </div>
            </c:if>

            <div class="mb-3">
                <label class="form-label">내용</label>
                <textarea class="form-control" rows="10" readonly>${dto.noticeContent}</textarea>
            </div>
        </div>
    </div>


    <div class="mt-3">
        <a href="/notice/list" class="btn btn-secondary">목록으로</a>

        <c:if test="${not empty sessionScope.memberId and sessionScope.memberGrade == '0'}">
            <a href="/notice/modify?noticeIdx=${dto.noticeIdx}" class="btn btn-primary">수정하기</a>

            <form id="frmDelete" method="post" action="/notice/delete" style="display: inline;">
                <input type="hidden" name="noticeIdx" value="${dto.noticeIdx}"/>
                <button type="submit" id="btnDelete" class="btn btn-danger" onclick="return confirm('정말 삭제하시겠습니까?')">삭제하기</button>
            </form>
        </c:if>
    </div>
</div>

<script>
    document.getElementById('btnModify').addEventListener('click', function () {
        const idx = "${dto.noticeIdx}";
        window.location.href = "${pageContext.request.contextPath}/notice/modify?noticeIdx=" + idx;
    });


</script>

</body>
</html>
