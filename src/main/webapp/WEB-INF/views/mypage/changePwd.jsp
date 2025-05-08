<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>비밀번호 변경</title>
</head>
<body>
<%@ include file="../common/sidebarHeader.jsp" %>

<div class="content">
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
                <li class="breadcrumb-item">
                    <a class="link-body-emphasis fw-semibold text-decoration-none" href="/mypage">마이페이지</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    비밀번호 변경
                </li>
            </ol>
        </nav>
    </div>

    <div class="container mt-5 mb-5">
        <h2 class="mb-4">비밀번호 변경</h2>
        <form name="frmChangePwd" id="frmChangePwd" action="/mypage/changePwd" method="post">
            <div class="mb-3">
                <label for="currentPwd" class="form-label">현재 비밀번호</label>
                <input type="password" class="form-control" id="currentPwd" name="currentPwd" required
                       placeholder="현재 비밀번호">
            </div>
            <div class="mb-3 row">
                <label for="newPwd" class="form-label">새 비밀번호</label>
                <div class="col-sm-10 input-group">
                    <input type="password" class="form-control" name="newPwd" id="newPwd"
                           placeholder="새 비밀번호" maxlength="15" required
                           oninput="validatePassword()"/>
                    <button class="btn btn-outline-secondary" type="button"
                            onclick="togglePasswordVisibility('newPwd', this)">
                        <i class="bi bi-eye"></i>
                    </button>
                </div>
                <div id="pwdWarning" class="form-text text-danger d-none">
                    비밀번호는 영문 대소문자와 숫자를 포함한 4~15자여야 합니다.
                </div>
            </div>
            <div class="mb-3 row">
                <label for="confirmPwd" class="form-label">비밀번호 확인</label>
                <div class="col-sm-10 input-group">
                    <input type="password" class="form-control" name="confirmPwd" id="confirmPwd"
                           placeholder="비밀번호 확인" maxlength="15" required
                           oninput="checkPasswordMatch()"/>
                    <button class="btn btn-outline-secondary" type="button"
                            onclick="togglePasswordVisibility('confirmPwd', this)">
                        <i class="bi bi-eye"></i>
                    </button>
                </div>
                <div id="pwdMatchWarning" class="form-text d-none"></div>
            </div>

            <div class="text-end d-grid gap-2">
                <button type="submit" class="btn btn-primary" id="btnChangePwd">비밀번호 변경</button>
            </div>
        </form>
    </div>
</div>
<script>
    function togglePasswordVisibility(inputId, btnElement) {
        const input = document.getElementById(inputId);
        const icon = btnElement.querySelector('i');
        if (input.type === "password") {
            input.type = "text";
            icon.classList.remove("bi-eye");
            icon.classList.add("bi-eye-slash");
        } else {
            input.type = "password";
            icon.classList.remove("bi-eye-slash");
            icon.classList.add("bi-eye");
        }
    }

    function validatePassword() {
        const password = document.getElementById("newPwd").value;
        const warning = document.getElementById("pwdWarning");
        const pattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{4,15}$/;

        if (password && !pattern.test(password)) {
            warning.classList.remove("d-none");
        } else {
            warning.classList.add("d-none");
        }
    }

    function checkPasswordMatch() {
        const password = document.getElementById("newPwd").value;
        const confirm = document.getElementById("confirmPwd").value;
        const message = document.getElementById("pwdMatchWarning");

        if (password && confirm) {
            if (password === confirm) {
                message.textContent = "비밀번호가 일치합니다.";
                message.className = "form-text text-success";
            } else {
                message.textContent = "비밀번호가 일치하지 않습니다.";
                message.className = "form-text text-danger";
            }
            message.classList.remove("d-none");
        } else {
            message.classList.add("d-none");
        }
    }
</script>
<c:if test="${not empty message}">
    <script>
        alert("${message}");
    </script>
</c:if>

</body>
</html>
