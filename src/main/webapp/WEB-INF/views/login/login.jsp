<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        html, body {
            height: 100%;
        }

        .warning-text {
            color: red;
            font-size: 0.85rem;
            margin-top: 0.25rem;
            text-align: left;
            padding-left: 0.25rem;
        }

        .login-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            max-width: 530px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin: 20vh auto;
            /*  수정해야 될 수도  */
        }


        .login-container .form-signup .form-floating:focus-within {
            z-index: 2;
        }

        .login-container .form-signup input[type="text"] {
            margin-bottom: -1px;
            border-bottom-right-radius: 0;
            border-bottom-left-radius: 0;
        }

        .login-container .form-signup #memberPwd {
            margin-bottom: 10px;
            border-top-left-radius: 0;
            border-top-right-radius: 0;
        }

        .login-container .login-divider {
            text-align: center;
            margin: 20px 0;
            position: relative;
        }

        .login-container .login-divider::before,
        .login-container .login-divider::after {
            content: "";
            position: absolute;
            top: 50%;
            width: 40%;
            border-top: 1px solid #ddd;
        }

        .login-container .login-divider::before {
            left: 0;
        }

        .login-container .login-divider::after {
            right: 0;
        }

        .login-container .login-divider span {
            background-color: white;
            padding: 0 10px;
            position: relative;
            top: -12px;
        }

        .login-container .naver-login-button {
            display: block;
            margin: auto;
            background-color: #03C75A;
            color: white;
            border-radius: 5px;
            padding: 10px;
            text-align: center;
            text-decoration: none;
        }

        .login-container .naver-login-button:hover {
            background-color: #01A44A;
        }

        .login-container .form-check-label {
            font-size: 0.875rem;
        }

        .pr-icon {
            padding-right: 3rem;
        }

        .btn-eye {
            position: absolute;
            top: 50%;
            right: 0.75rem;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            z-index: 2;
            padding: 0;
            color: #6c757d;
        }

        .btn-eye:hover {
            color: #000;
        }

    </style>
</head>
<body class="bg-light-subtle">
<%@ include file="../common/header.jsp" %>

<div class="login-container d-flex align-items-center py-4 bg-light text-center">
    <c:if test="${empty sessionScope.memberId}">
        <main class="form-signup w-100 m-auto">
            <form name="frmLogin" method="post">
                <img class="mb-4" src="/resources/img/spb_logo_transparent.png" alt="로고 이미지" width="150">

                <div class="form-floating">
                    <input type="text" class="form-control" id="memberId" name="memberId" autocomplete="off"
                           placeholder="아이디"
                           value="${not empty cookie.saveId.value ? cookie.saveId.value : (not empty cookie.autoLogin.value ? cookie.autoLogin.value : '')}"
                    > <label for="memberId">아이디</label>

                </div>

                <div class="form-floating position-relative mb-3">
                    <input type="password" class="form-control pr-icon" name="memberPwd" id="memberPwd"
                           placeholder="비밀번호" maxlength="15">
                    <label for="memberPwd">비밀번호</label>

                    <button type="button" class="btn-eye" onclick="togglePasswordVisibility('memberPwd', this)">
                        <i class="bi bi-eye"></i>
                    </button>
                </div>

                <div>
                    <div id="pwdWarning" class="warning-text d-none">비밀번호는 대소문자와 숫자를 포함한 4~15자여야 합니다.</div>
                    <div id="idWarning" class="warning-text d-none mt-1">
                        아이디는 4~20자, 알파벳과 숫자만 가능합니다.
                    </div>
                </div>

                <div class="form-check text-start my-3 d-flex justify-content-between">
                    <div>
                        <input class="form-check-input" type="checkbox" name="checkIdSave" id="checkIdSave"
                               <c:if test="${not empty cookie.saveId.value}">checked</c:if>>
                        <label class="form-check-label" for="checkIdSave">아이디 저장</label>
                    </div>
                    <div>
                        <input class="form-check-input" type="checkbox" name="checkAutoLogin" id="checkAutoLogin"
                               <c:if test="${not empty cookie.autoLogin.value}">checked</c:if>>
                        <label class="form-check-label" for="checkAutoLogin">자동 로그인</label>
                    </div>
                </div>

                <button class="btn btn-primary w-100 py-2" type="submit" id="btnSubmit">로그인</button>
                <div class="mt-3 d-flex justify-content-center">
                    <a href="/findPwd">비밀번호 찾기</a>
                    &nbsp;
                    <label></label>
                    &nbsp;
                    <a href="/join">회원가입</a>
                </div>

                <div class="login-divider">
                    <label>OR</label>
                </div>

                <a href="https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=cnVwGS7uEm_5bo6jAIGr&redirect_uri=http://localhost:8080/naver/callback&state=randomState123"
                   class="naver-login-button d-flex align-items-center justify-content-center">
                    <img src="resources/img/btnW_icon_square.png" alt="네이버 로그인 버튼" width="25"
                         style="margin-right: 0.5rem"/>
                    네이버로 계속하기
                </a>
            </form>
        </main>
    </c:if>

    <c:if test="${not empty sessionScope.memberId}">
        <main class="form-signup w-100 m-auto">
            <h1 class="h3 mb-3 fw-normal">로그아웃</h1>
            <button class="btn btn-danger w-100 py-2" id="btnLogout">로그아웃</button>
        </main>
    </c:if>
</div>
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 1100">
    <div id="loginToast" class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive"
         aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body" id="loginToastMessage">오류 메시지 출력</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto"
                    data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>

    <div class="toast align-items-center text-bg-warning border-0" role="alert"
         aria-live="assertive" aria-atomic="true" id="inputBlockToast">
        <div class="d-flex">
            <div class="toast-body" id="inputBlockToastMessage">입력 제한 안내</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto"
                    data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js" type="text/javascript"></script>

<script>
    function showInputToast(message) {
        const toastEl = document.getElementById('inputBlockToast');
        const toastMsg = document.getElementById('inputBlockToastMessage');
        toastMsg.textContent = message;
        const toast = new bootstrap.Toast(toastEl, {delay: 2500});
        toast.show();
    }

    document.getElementById("memberId")?.addEventListener("input", function () {
        const origin = this.value;
        const filtered = origin.replace(/[^a-zA-Z0-9]/g, '');
        if (origin !== filtered) {
            this.value = filtered;
            showInputToast("아이디는 영문과 숫자만 입력 가능합니다.");
        }
    });

    document.getElementById("memberPwd")?.addEventListener("input", function () {
        const origin = this.value;
        const filtered = origin.replace(/[^a-zA-Z0-9]/g, '');
        if (origin !== filtered) {
            this.value = filtered;
            showInputToast("비밀번호는 영문과 숫자만 입력 가능합니다.");
        }
    });

    const idRegEx = /^[a-zA-Z0-9]{4,20}$/;
    const pwdRegEx = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{4,15}$/;

    $('#memberId').on('input', function () {
        const memberIdValue = $('#memberId').val().trim();
        if (!memberIdValue) {
            $('#btnCheckId').prop('disabled', true);
            $('#idWarning').addClass('d-none');
        } else if (idRegEx.test(memberIdValue)) {
            $('#idWarning').addClass('d-none');
            $('#btnCheckId').prop('disabled', false);
        } else {
            $('#idWarning').removeClass('d-none');
            $('#btnCheckId').prop('disabled', true);
        }
    });

    $('#memberPwd').on('input', function () {
        const memberPwdValue = $('#memberPwd').val();
        if (pwdRegEx.test(memberPwdValue)) {
            $('#pwdWarning').addClass('d-none');
        } else {
            $('#pwdWarning').removeClass('d-none');
        }
        checkPasswordMatch();
    });

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

    <c:if test="${not empty errorMessage}">
    const toastEl = document.getElementById('loginToast');
    const toastMessage = document.getElementById('loginToastMessage');
    const toast = new bootstrap.Toast(toastEl);

    toastMessage.textContent = "${errorMessage}";
    toast.show();
    </c:if>


    document.getElementById("btnSubmit")?.addEventListener("click", function (e) {
        e.preventDefault();
        const memberId = document.getElementById("memberId");
        const memberPwd = document.getElementById("memberPwd");

        if (memberId.value.trim() === "") {
            alert("아이디를 입력하세요.");
            memberId.focus();
            return;
        }
        if (memberPwd.value.trim() === "") {
            alert("비밀번호를 입력하세요.");
            memberPwd.focus();
            return;
        }

        document.frmLogin.submit();
    });

    document.getElementById("btnLogout")?.addEventListener("click", () => {
        const naverLogoutWindow = window.open("https://nid.naver.com/nidlogin.logout", "_blank", "width=1,height=1");

        setTimeout(() => {
            naverLogoutWindow?.close();
            location.href = "/login?action=logout";
        }, 1000);
    });
</script>
</body>
</html>
