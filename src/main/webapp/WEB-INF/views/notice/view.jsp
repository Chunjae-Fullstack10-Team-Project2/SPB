<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>공지사항 상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        /* 버튼 높이 통일 */
        .btn-custom {
            height: 38px ;
            padding-top: 5px ;
            padding-bottom: 5px ;
        }
    </style>
</head>
<body>

<%@ include file="../common/header.jsp" %>

<svg xmlns="http://www.w3.org/2000/svg" class="d-none">
    <symbol id="house-door-fill" viewBox="0 0 16 16">
        <path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5z"/>
    </symbol>
</svg>

<div class="container my-5 pt-5">
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
                <a class="link-body-emphasis fw-semibold text-decoration-none" href="/notice/list">공지사항</a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">
                ${dto.noticeTitle}
            </li>
        </ol>
    </nav>
</div>

<div class="container my-5">
    <div class="card shadow rounded">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">${dto.noticeTitle}</h5>
        </div>
        <div class="card-body">
            <input type="hidden" id="idx" value="${dto.noticeIdx}">

            <div class="mb-3">
                <label for="noticeMemberId" class="form-label">작성자</label>
                <input type="text" class="form-control" id="noticeMemberId" name="noticeMemberId"
                       value="${dto.noticeMemberId}" readonly>
            </div>

            <div class="mb-3">
                <label for="createdAt" class="form-label">등록일</label>
                <input type="text" class="form-control" id="createdAt" name="createdAt"
                       value="${createdAtStr}" readonly>
            </div>

            <c:if test="${not empty updatedAtStr}">
                <div class="mb-3">
                    <label for="updatedAt" class="form-label">수정일</label>
                    <input type="text" class="form-control" id="updatedAt" name="updatedAt"
                           value="${updatedAtStr}" readonly>
                </div>
            </c:if>

            <div class="mb-3">
                <label for="noticeContent" class="form-label">내용</label>
                <textarea class="form-control" name="noticeContent" id="noticeContent" rows="10" readonly>${dto.noticeContent}</textarea>
            </div>
        </div>
    </div>

    <div class="d-flex justify-content-end gap-2 mt-3">
        <a href="/notice/list" class="btn btn-outline-secondary btn-custom">
            <i class="bi bi-arrow-left me-1"></i> 목록으로
        </a>
        <c:if test="${not empty sessionScope.memberId and not empty sessionScope.memberGrade and sessionScope.memberGrade == '0'}">
            <button type="button" id="btnModify" class="btn btn-primary btn-custom">
                <i class="bi bi-pencil-square me-1"></i> 수정
            </button>
        </c:if>

        <c:if test="${not empty sessionScope.memberGrade and sessionScope.memberGrade == '0'}">
            <form id="frmDelete" method="post" action="/notice/delete" style="display: inline;">
                <input type="hidden" name="noticeIdx" value="${dto.noticeIdx}"/>
                <button type="submit" id="btnDelete" class="btn btn-danger btn-custom">
                    <i class="bi bi-trash me-1"></i> 삭제
                </button>
            </form>
        </c:if>
    </div>
</div>

<script>
    document.getElementById('btnModify').addEventListener('click', function () {
        const idx = "${dto.noticeIdx}";
        window.location.href = "${pageContext.request.contextPath}/notice/modify?noticeIdx=" + idx;
    });

    document.getElementById("btnDelete").addEventListener("click", (e) => {
        e.preventDefault();
        e.stopPropagation();

        if (window.confirm('공지사항을 삭제하시겠습니까?')) {
            document.getElementById("frmDelete").submit();
        }
    });
</script>


</body>
</html>
