<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>비밀번호 변경</title>
    <script src="${pageContext.request.contextPath}/resources/js/textCounter.js"></script>

</head>
<body class="bg-light-subtle">
<%@ include file="../common/sidebarHeader.jsp" %>

<div class="content">
    <div class="container my-5">
        <%@ include file="../common/breadcrumb.jsp" %>
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
                    <input type="password" class="form-control char-limit" name="newPwd" id="newPwd"
                           placeholder="새 비밀번호" maxlength="15" required
                           oninput="validatePassword()"
                           data-maxlength="15" data-target="#memberNewPwdCount"
                    />
                    <button class="btn btn-outline-secondary" type="button"
                            onclick="togglePasswordVisibility('newPwd', this)">
                        <i class="bi bi-eye"></i>
                    </button>
                </div>
                <div class="d-flex justify-content-between align-items-center mt-1 small text-muted">
                    <div class="form-text warning-text d-none" id="pwdWarning">
                        비밀번호는 영문 대소문자와 숫자를 포함한 4~15자여야 합니다.
                    </div>
                    <div class="char-counter ms-auto">
                        <span id="memberNewPwdCount">0</span> / 15
                    </div>
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
                message.className = "form-text success-text";
            } else {
                message.textContent = "비밀번호가 일치하지 않습니다.";
                message.className = "form-text warning-text";
            }
            message.classList.remove("d-none");
        } else {
            message.classList.add("d-none");
        }
    }

    document.getElementById("frmChangePwd").addEventListener("submit", function (event) {
        event.preventDefault();

        const form = this;
        const memberId = "${sessionScope.memberDTO.memberId}";

        fetch('/updatePwdChangeDate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({memberId: memberId})
        })
            .then(response => response.json())
            .then(data => {
                if (!data.success) {
                    alert("비밀번호 변경일 업데이트에 실패했습니다.");
                }
                form.submit(); // Ajax 완료 후 실제 form 제출
            })
            .catch(error => {
                console.error('Error:', error);
                alert("비밀번호 변경 요청 중 오류 발생");
                form.submit();
            });
    });
</script>
<c:if test="${not empty message}">
    <script>
        alert("${message}");
    </script>
</c:if>

</body>
</html>