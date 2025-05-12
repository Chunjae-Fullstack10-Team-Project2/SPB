<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>공지사항 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
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
                수정
            </li>
        </ol>
    </nav>
</div>

<div class="container my-5">
    <div class="card shadow rounded">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">공지사항 수정</h5>
        </div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/notice/modify" class="needs-validation" onsubmit="return validateForm()" >
                <input type="hidden" name="noticeIdx" value="${dto.noticeIdx}" />

                <div class="mb-3">
                    <label for="title" class="form-label">제목</label>
                    <input type="text" class="form-control" id="title" name="noticeTitle"
                           maxlength="100" value="${dto.noticeTitle}" required />
                    <div class="invalid-feedback">
                        제목을 입력해주세요. (100자 이하)
                    </div>
                </div>

                <div class="mb-3">
                    <label for="noticeContent" class="form-label">내용</label>
                    <textarea class="form-control" id="noticeContent" name="noticeContent"
                              rows="10" style="resize: none;" required>${dto.noticeContent}</textarea>
                    <div class="invalid-feedback">
                        내용을 입력해주세요.
                    </div>
                </div>

                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="noticeIsFixedCheckbox"
                           onchange="document.getElementById('noticeIsFixed').value = this.checked ? '1' : '0';" />
                    <input type="hidden" id="noticeIsFixed" name="noticeIsFixed" value="${dto.noticeIsFixed}" />
                    <label class="form-check-label" for="noticeIsFixedCheckbox">고정 공지</label>
                </div>

                <div class="d-flex justify-content-end gap-2">
                    <button type="button" class="btn btn-outline-secondary"
                            onclick="location.href='${pageContext.request.contextPath}/notice/list'">취소</button>
                    <button type="submit" class="btn btn-primary">수정</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // 체크박스 상태 설정
    window.onload = function() {
        const isFixedValue = "${dto.noticeIsFixed}";
        if(isFixedValue === "1" || isFixedValue === "true") {
            document.getElementById("noticeIsFixed").checked = true;
        }
    }

    function validateForm() {
        const title = document.getElementById("title").value.trim();
        if (title.length > 100) {
            alert("제목은 100자 이하만 입력 가능합니다.");
            return false;
        }
        return true;
    }


    <% if(request.getAttribute("message") != null) { %>
    alert("<%= request.getAttribute("message") %>");
    <% } %>



</script>
</body>
</html>