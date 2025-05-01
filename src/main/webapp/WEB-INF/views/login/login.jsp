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

        .login-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            max-width: 530px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin: 20vh auto;
            /*  수정해야 될 수도  */
        }

        .login-container a {
            text-decoration: none;
            color: gray;
        }

        .login-container label {
            color: gray;
        }

        .login-container .form-signin .form-floating:focus-within {
            z-index: 2;
        }

        .login-container .form-signin input[type="text"] {
            margin-bottom: -1px;
            border-bottom-right-radius: 0;
            border-bottom-left-radius: 0;
        }

        .login-container .form-signin input[type="password"] {
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

    </style>
</head>
<body>
<%@ include file="../common/header.jsp" %>

<div class="login-container d-flex align-items-center py-4 bg-light text-center">
    <c:if test="${empty sessionScope.memberId}">
        <main class="form-signin w-100 m-auto">
            <form name="frmLogin" method="post">
                    <%--            <img class="mb-4" src="https://getbootstrap.com/docs/5.3/assets/brand/bootstrap-logo.svg" alt="" width="72"--%>
                    <%--                 height="57">--%>

                <div class="form-floating">
                    <input type="text" class="form-control" id="memberId" name="memberId"
                           autocomplete="off"
                           placeholder="아이디"
                           value="${not empty cookie.saveId.value ? cookie.saveId.value : (not empty cookie.autoLogin.value ? cookie.autoLogin.value : '')}">
                    <label for="memberId">아이디</label>
                </div>

                <div class="form-floating">
                    <input type="password" class="form-control" id="memberPwd" name="memberPwd" placeholder="비밀번호">
                    <label for="memberPwd">비밀번호</label>
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
        <main class="form-signin w-100 m-auto">
            <h1 class="h3 mb-3 fw-normal">로그아웃</h1>
            <button class="btn btn-danger w-100 py-2" id="btnLogout">로그아웃</button>
        </main>
    </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js" type="text/javascript"></script>

<script>
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
        const naverLogoutWindow = window.open("https://nid.naver.com/nidlogin.logout", "_blank", "width=0,height=0");

        setTimeout(() => {
            naverLogoutWindow?.close();
            location.href = "/login?action=logout";
        }, 1000);
    });
</script>
</body>
</html>
