<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        html, body {
            height: 100%;
        }

        .form-signin {
            max-width: 330px;
            padding: 1rem;
        }

        .form-signin .form-floating:focus-within {
            z-index: 2;
        }

        .form-signin input[type="text"] {
            margin-bottom: -1px;
            border-bottom-right-radius: 0;
            border-bottom-left-radius: 0;
        }

        .form-signin input[type="password"] {
            margin-bottom: 10px;
            border-top-left-radius: 0;
            border-top-right-radius: 0;
        }
    </style>
</head>
<body class="d-flex align-items-center py-4 bg-body-tertiary text-center">

<c:if test="${empty sessionScope.memberId}">
    <main class="form-signin w-100 m-auto">
        <form name="frmLogin" method="post">
            <img class="mb-4" src="https://getbootstrap.com/docs/5.3/assets/brand/bootstrap-logo.svg" alt="" width="72" height="57">
            <h1 class="h3 mb-3 fw-normal">로그인</h1>

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

            <div class="form-check text-start my-3">
                <input class="form-check-input" type="checkbox" name="checkIdSave" id="checkIdSave"
                       <c:if test="${not empty cookie.saveId.value}">checked</c:if>>
                <label class="form-check-label" for="checkIdSave">아이디 저장</label>
                <br>
                <input class="form-check-input" type="checkbox" name="checkAutoLogin" id="checkAutoLogin"
                       <c:if test="${not empty cookie.autoLogin.value}">checked</c:if>>
                <label class="form-check-label" for="checkAutoLogin">자동 로그인</label>
            </div>

            <button class="btn btn-primary w-100 py-2" type="submit" id="btnSubmit">로그인</button>

            <div class="mt-3 d-flex justify-content-between">
                <button type="button" class="btn btn-link p-0" id="btnFindId">아이디 찾기</button>
                <button type="button" class="btn btn-link p-0" id="btnFindPwd">비밀번호 찾기</button>
                <button type="button" class="btn btn-link p-0" id="btnJoin">회원가입</button>
            </div>

            <p class="mt-5 mb-3 text-body-secondary">&copy; 2025</p>
        </form>
    </main>
</c:if>

<c:if test="${not empty sessionScope.memberId}">
    <main class="form-signin w-100 m-auto">
        <h1 class="h3 mb-3 fw-normal">로그아웃</h1>
        <button class="btn btn-danger w-100 py-2" id="btnLogout">로그아웃</button>
    </main>
</c:if>

<!-- Bootstrap Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.getElementById("btnSubmit")?.addEventListener("click", function (e) {
        e.preventDefault();
        e.stopPropagation()

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
        location.href = "/login?action=logout";
    });

    document.getElementById("btnFindId")?.addEventListener("click", () => {
        location.href = "/findId.jsp";
    });
    document.getElementById("btnFindPwd")?.addEventListener("click", () => {
        location.href = "/findPwd.jsp";
    });
    document.getElementById("btnJoin")?.addEventListener("click", () => {
        location.href = "/join.jsp";
    });
</script>
</body>
</html>
