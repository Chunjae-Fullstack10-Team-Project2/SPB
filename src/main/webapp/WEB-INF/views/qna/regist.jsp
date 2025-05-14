<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>문의사항 등록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/textCounter.js"></script>
</head>
<body class="bg-light-subtle">
<%@ include file="../common/header.jsp" %>

<div class="content-nonside">
    <div class="container my-5">
        <div class="container my-5">
            <%@ include file="../common/breadcrumb.jsp" %>
        </div>

        <div class="container my-5">
            <div class="card shadow rounded">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">문의사항 등록</h5>
                </div>
                <div class="card-body">
                    <form name="frmRegist" method="post" class="needs-validation" novalidate>
                        <div class="mb-3">
                            <label for="qnaTitle" class="form-label">제목</label>
                            <input type="text" class="form-control char-limit" id="qnaTitle" name="qnaTitle"
                                   placeholder="제목을 입력하세요." required
                                   data-maxlength="100" data-target="#qnaQTitleCount"
                                   value="${qnaDTO.qnaTitle != null ? qnaDTO.qnaTitle : ''}">
                        </div>
                        <div class="text-end small text-muted mt-1 mb-3">
                            <span id="qnaQTitleCount">0</span> / 100
                        </div>

                        <div class="mb-3">
                            <label for="qnaQMemberId" class="form-label">작성자</label>
                            <input type="text" class="form-control" id="qnaQMemberId" name="qnaQMemberId"
                                   value="${qnaDTO.qnaQMemberId}" readonly>
                        </div>

                        <div class="mb-3">
                            <label for="qnaQPwd" class="form-label">비밀번호(선택)</label>
                            <input type="text" class="form-control" id="qnaQPwd" name="qnaQPwd" maxlength="4"
                                   value="${qnaDTO.qnaQPwd}">
                        </div>

                        <div class="mb-3">
                            <label for="qnaQContent" class="form-label">내용</label>
                            <textarea class="form-control char-limit" id="qnaQContent" name="qnaQContent" rows="10"
                                      placeholder="문의 내용을 입력해주세요." style="resize: none;" required
                                      data-maxlength="15000" data-target="#qnaQCount"
                                      required>${qnaDTO.qnaQContent != null ? qnaDTO.qnaQContent : ''}</textarea>
                        </div>
                        <div class="text-end small text-muted mt-1 mb-3">
                            <span id="qnaQCount">0</span> / 15000
                        </div>

                        <div class="d-flex justify-content-end gap-2">
                            <input type="button" class="btn btn-outline-secondary" onclick="location.href='/qna/list'"
                                   value="취소">
                            <input type="submit" class="btn btn-primary" value="등록">
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 1100">
    <div id="toastPwdAlert" class="toast align-items-center text-bg-danger border-0"
         role="alert" aria-live="assertive" aria-atomic="true"
         data-bs-delay="2000" data-bs-autohide="true">
        <div class="d-flex">
            <div class="toast-body">
                비밀번호는 숫자 4자리만 입력 가능합니다.
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                    aria-label="Close"></button>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const pwdInput = document.getElementById("qnaQPwd");
        const toastElement = document.getElementById("toastPwdAlert");
        if (!pwdInput || !toastElement) return;

        const toastPwd = new bootstrap.Toast(toastElement);

        pwdInput.addEventListener("input", function () {
            const value = this.value;
            this.value = value.replace(/[^0-9]/g, '');

            if (this.value.length > 4) {
                this.value = this.value.slice(0, 4);
                toastPwd.show();
            }
        });
    });

    <c:if test="${not empty errorMessage}">
    alert("${errorMessage}");
    </c:if>

    <c:if test="${not empty message}">
    alert("${message}");
    </c:if>
</script>
</body>
</html>
