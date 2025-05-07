<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>메인 페이지</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <link rel="stylesheet" href="assets/css/bootstrap-5.0.0-alpha.min.css">
    <link rel="stylesheet" href="assets/css/LineIcons.2.0.css">
    <link rel="stylesheet" href="assets/css/animate.css">
    <link rel="stylesheet" href="assets/css/main.css">

    <style>
        .warning-text {
            color: red;
            font-size: 0.8rem;
            margin: 0.2rem 0 0 0.2rem;
        }
    </style>
</head>
<body>
<%@include file="fixedHeader.jsp" %>
<%@include file="sidebar.jsp" %>
<div class="content" style="margin-left: 280px; margin-top: 100px;">

    <div class="modal fade" id="pwdChangeModal" tabindex="-1" aria-labelledby="pwdChangeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="pwdChangeModalLabel">비밀번호 변경 안내</h5>
                </div>
                <div class="modal-body">
                    <p>비밀번호를 변경하신지 90일이 지났습니다.<br>비밀번호를 변경하시겠습니까?</p>
                </div>
                <div class="modal-footer">
                    <a href="/changePwd" class="btn btn-primary">예</a>
                    <button type="button" class="btn btn-secondary" id="btnRemindLater">90일 후 다시 알림</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="emailVerifyModal" tabindex="-1" aria-labelledby="emailVerifyModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">이메일 인증 필요</h5>
                </div>
                <div class="modal-body">
                    <p>휴면 상태입니다. 이메일 인증 후 서비스를 이용해주세요.</p>
                    <div class="mb-3">
                        <input type="email" class="form-control" id="emailInput"
                               value="${sessionScope.memberDTO.memberEmail}" readonly>
                    </div>
                    <button id="btnSendEmail" class="btn btn-primary w-100 mb-2">인증코드 전송</button>

                    <div class="mb-3">
                        <input type="text" class="form-control" id="codeInput" placeholder="인증코드 입력" maxlength="6">
                    </div>
                    <div class="mb-2">
                        <span id="emailCountWarning" class="warning-text text-danger"></span>
                        <span id="emailAuthTimeWarning" class="warning-text text-danger"></span>
                    </div>
                    <button id="btnCheckCode" class="btn btn-success w-100">인증 확인</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    <c:if test="${sessionScope.memberDTO.memberState == '3'}">
    const modal = new bootstrap.Modal(document.getElementById('pwdChangeModal'), {
        backdrop: 'static',
        keyboard: false
    });
    window.onload = () => modal.show();
    </c:if>

    document.getElementById("btnRemindLater").addEventListener("click", function () {
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
                if (data.success) {
                    alert("알림이 설정되었습니다. 비밀번호 변경 알림이 연기되었습니다.");

                    modal.hide();
                } else {
                    alert("알림 설정에 실패했습니다.");
                }
            })
            .catch(error => console.error('Error:', error));
    });

    <c:if test="${sessionScope.memberDTO.memberState == '5'}">
    const emailModal = new bootstrap.Modal(document.getElementById('emailVerifyModal'), {
        backdrop: 'static',
        keyboard: false
    });
    window.onload = () => emailModal.show();
    </c:if>

    let emailAuthTimer;
    let emailAuthTimeLimit = 300;

    function startEmailAuthTimer() {
        clearInterval(emailAuthTimer);
        emailAuthTimeLimit = 300;

        emailAuthTimer = setInterval(function () {
            const minutes = Math.floor(emailAuthTimeLimit / 60);
            const seconds = emailAuthTimeLimit % 60;

            const timeDisplay = "남은 인증 시간: " + minutes + ":" + (seconds < 10 ? '0' + seconds : seconds);
            document.getElementById('emailAuthTimeWarning').textContent = timeDisplay;

            if (emailAuthTimeLimit <= 0) {
                clearInterval(emailAuthTimer);
                document.getElementById('emailAuthTimeWarning').textContent = '인증 시간이 만료되었습니다.';
                document.getElementById('codeInput').disabled = true;
                document.getElementById('btnCheckCode').disabled = true;

                // 다시 메일 보낼 수 있도록 버튼 활성화
                document.getElementById('btnSendEmail').disabled = false;
            }

            emailAuthTimeLimit--;
        }, 1000);
    }

    document.getElementById("btnSendEmail").addEventListener("click", () => {
        const emailInput = document.getElementById("emailInput");
        emailInput.value = emailInput.value.trim();

        if (!emailInput.value) {
            alert("이메일을 입력해주세요.");
            return;
        }

        fetch("/email/verify", {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify({memberEmail: emailInput.value})
        })
            .then(res => res.json())
            .then(data => {
                alert(data.message);

                if (data.success) {
                    const count = data.emailTryCount || 1;
                    document.getElementById('emailCountWarning').innerHTML = "<strong>인증 횟수 " + count + "/3회</strong>";

                    document.getElementById('btnSendEmail').disabled = true;
                    document.getElementById('codeInput').disabled = false;
                    document.getElementById('btnCheckCode').disabled = false;
                    startEmailAuthTimer();
                }
            });
    });

    document.getElementById("btnCheckCode").addEventListener("click", () => {
        const code = document.getElementById("codeInput").value.trim();
        const email = document.getElementById("emailInput").value.trim();

        fetch("/email/codeCheck", {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify({
                memberEmailCode: code,
                memberEmail: email
            })
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert("이메일 인증이 완료되었습니다.");
                    fetch("/email/reactivate", {
                        method: "POST",
                        headers: {"Content-Type": "application/json"},
                        body: JSON.stringify({memberId: "${sessionScope.memberDTO.memberId}"})
                    }).then(() => location.reload());
                } else {
                    alert(data.message);
                }
            });
    });
</script>
</body>
</html>