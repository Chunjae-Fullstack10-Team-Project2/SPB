<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>회원가입</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f6f7;
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
        }

        .container {
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            max-width: 700px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        h2 {
            font-weight: bold;
            color: #333;
            border-bottom: 2px solid #ccc;
            padding-bottom: 10px;
        }

        .form-control, .form-select {
            border-radius: 8px;
            height: 45px;
            font-size: 15px;
        }

        .btn {
            border-radius: 8px;
            font-size: 14px;
        }

        .btn-outline-secondary {
            border-radius: 8px;
        }

        label, .form-text {
            font-size: 13px;
            color: #555;
        }

        #passwordHelpBlock {
            margin-left: 2px;
            color: #999;
            font-size: 12px;
        }

        .row.mb-3 {
            margin-bottom: 1.25rem !important;
        }

        .text-end {
            text-align: center !important;
            margin-top: 30px;
        }

        #memberEmailCustom {
            margin-top: 8px;
        }

        #memberIdCheck span {
            font-size: 13px;
            font-weight: 500;
        }
    </style>

</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">회원가입</h2>
    <form name="frmJoin" id="frmJoin" action="/join" method="post">
        <div class="row mb-3">
            <div class="col-sm-4">
                <input type="text" class="form-control" name="memberId" id="memberId"
                       value="${memberDTO.memberId != null ? memberDTO.memberId : ''}"
                       placeholder="아이디">
            </div>
            <div class="col-sm-2">
                <button type="button" class="btn btn-secondary w-100" id="btnCheckId">중복 확인</button>
            </div>
            <div class="col-sm-4">
                <span id="memberIdCheck">
                    <c:if test="${not empty idCheckMessage}">
                        <span style="color:${idCheckSuccess ? 'green' : 'red'};">${idCheckMessage}</span>
                    </c:if>
                </span>
            </div>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-10 input-group">
                <input type="password" class="form-control" name="memberPwd" id="memberPwd"
                       value="${memberDTO.memberPwd != null ? memberDTO.memberPwd : ''}"
                       placeholder="비밀번호">
                <button class="btn btn-outline-secondary" type="button"
                        onclick="togglePasswordVisibility('memberPwd', this)">
                    <i class="bi bi-eye"></i>
                </button>
            </div>
        </div>

        <div class="mb-3 row">
            <div id="passwordHelpBlock" class="form-text">
                비밀번호는 대소문자와 숫자를 포함한 4~15자여야 합니다.
            </div>
            <div class="col-sm-10 input-group">
                <input type="password" class="form-control" name="memberPwdConfirm" id="memberPwdConfirm"
                       placeholder="비밀번호 확인">
                <button class="btn btn-outline-secondary" type="button"
                        onclick="togglePasswordVisibility('memberPwdConfirm', this)">
                    <i class="bi bi-eye"></i>
                </button>
            </div>
            <span id="memberPwdCheck" class="form-text ms-2"></span>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-10">
                <input type="text" class="form-control" name="memberName" id="memberName"
                       value="${memberDTO.memberName != null ? memberDTO.memberName : ''}"
                       placeholder="이름">
            </div>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-6">
                <input type="text" class="form-control" id="memberZipCode" name="memberZipCode"
                       value="${memberDTO.memberZipCode != null ? memberDTO.memberZipCode : ''}"
                       placeholder="우편번호">
            </div>
            <div class="col-sm-4">
                <button type="button" class="btn btn-outline-secondary w-100" onclick="sample6_execDaumPostcode()">우편번호
                    찾기
                </button>
            </div>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-10">
                <input type="text" class="form-control" id="memberAddr1" name="memberAddr1"
                       value="${memberDTO.memberAddr1 != null ? memberDTO.memberAddr1 : ''}" placeholder="주소">
            </div>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-10">
                <input type="text" class="form-control" id="memberAddr2" name="memberAddr2"
                       value="${memberDTO.memberAddr2 != null ? memberDTO.memberAddr2 : ''}" placeholder="상세주소">
            </div>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-10">
                <input type="text" class="form-control" name="memberBirth" id="memberBirth"
                       value="${memberDTO.memberBirth != null ? memberDTO.memberBirth : ''}" maxlength="8"
                       placeholder="생년월일">
            </div>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-10">
                <select class="form-select" id="memberGrade" name="memberGrade">
                    <optgroup label="초등학교">
                        <option value="1" ${memberDTO.memberGrade == '1' ? 'selected' : ''}>초1</option>
                        <option value="2" ${memberDTO.memberGrade == '2' ? 'selected' : ''}>초2</option>
                        <option value="3" ${memberDTO.memberGrade == '3' ? 'selected' : ''}>초3</option>
                        <option value="4" ${memberDTO.memberGrade == '4' ? 'selected' : ''}>초4</option>
                        <option value="5" ${memberDTO.memberGrade == '5' ? 'selected' : ''}>초5</option>
                        <option value="6" ${memberDTO.memberGrade == '6' ? 'selected' : ''}>초6</option>
                    </optgroup>
                    <optgroup label="중학교">
                        <option value="7" ${memberDTO.memberGrade == '7' ? 'selected' : ''}>중1</option>
                        <option value="8" ${memberDTO.memberGrade == '8' ? 'selected' : ''}>중2</option>
                        <option value="9" ${memberDTO.memberGrade == '9' ? 'selected' : ''}>중3</option>
                    </optgroup>
                    <optgroup label="고등학교">
                        <option value="10" ${memberDTO.memberGrade == '10' ? 'selected' : ''}>고1</option>
                        <option value="11" ${memberDTO.memberGrade == '11' ? 'selected' : ''}>고2</option>
                        <option value="12" ${memberDTO.memberGrade == '12' ? 'selected' : ''}>고3</option>
                    </optgroup>
                    <optgroup label="교사">
                        <option value="13" ${memberDTO.memberGrade == '13' ? 'selected' : ''}>교사</option>
                    </optgroup>
                </select>
            </div>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-6">
                <input type="text" class="form-control" name="memberEmail1" id="memberEmail1"
                       value="${memberDTO.memberEmail != null ? memberDTO.memberEmail : ''}"
                       placeholder="이메일">
            </div>
            <label class="col-sm-2 col-form-label">@</label>
            <div class="col-sm-10">
                <select class="form-select" id="memberEmail2" name="memberEmail2"
                        onchange="toggleCustomEmailInput(this)">
                    <option>naver.com</option>
                    <option>gmail.com</option>
                    <option>hanmail.net</option>
                    <option value="custom">직접 입력</option>
                </select>
                <input type="text" class="form-control mt-1 d-none" id="memberEmailCustom" placeholder="직접 입력"
                       maxlength="20">
            </div>
            <div class="col-sm-4">
                <button type="button" class="btn btn-outline-primary w-100" id="btnMemberEmailCodeSend"
                        onclick="sendEmailCode()">인증 코드 전송
                </button>
            </div>
        </div>

        <input type="hidden" name="memberEmail">

        <div class="mb-3 row">
            <div class="col-sm-6">
                <input type="text" class="form-control" id="memberEmailCode" placeholder="인증 코드 확인">
            </div>
            <div class="col-sm-2">
                <button type="button" class="btn btn-success w-100" id="btnMemberEmailCodeAuth"
                        onclick="checkEmailCode()">확인
                </button>
            </div>
            <div class="col-sm-2">
                <c:if test="${not empty emailCheckMessage}">
                    <span style="color:${emailCheckSuccess ? 'green' : 'red'};">${emailCheckMessage}</span>
                </c:if>
            </div>
        </div>

        <div class="mb-3 row">
            <input type="text" class="form-control" name="memberPhone" id="memberPhone" maxlength="11"
                   placeholder="휴대전화번호">
        </div>

        <div class="text-end">
            <button type="submit" class="btn btn-primary" id="btnSubmitJoin">회원가입</button>
        </div>
    </form>
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    function sample6_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function (data) {
                var addr = '';
                addr = data.roadAddress;

                document.getElementById('memberZipCode').value = data.zonecode;
                document.getElementById("memberAddr1").value = addr;
                document.getElementById("memberAddr2").focus();
            }
        }).open();
    }

    function toggleCustomEmailInput(selectEl) {
        const customInput = document.getElementById("memberEmailCustom");
        if (selectEl.value === "custom") {
            customInput.classList.remove("d-none");
            customInput.focus();
        } else {
            customInput.classList.add("d-none");
            customInput.value = '';
        }
    }

    $('#btnCheckId').on('click', function () {
        const memberId = $('#memberId').val();

        $.ajax({
            type: 'POST',
            url: '/checkIdDuplicate',
            contentType: 'application/json',
            data: JSON.stringify({memberId: memberId}),
            success: function (response) {
                alert(response.message);
            },
            error: function (xhr) {
                alert("중복체크 실패: " + xhr.status);
            }
        });
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

    function checkPasswordMatch() {
        const password = document.getElementById("password").value;
        const confirm = document.getElementById("confirmPassword").value;
        const message = document.getElementById("passwordMessage");

        if (password && confirm) {
            if (password === confirm) {
                message.textContent = "비밀번호가 일치합니다.";
                message.className = "form-text text-success";
            } else {
                message.textContent = "비밀번호가 일치하지 않습니다.";
                message.className = "form-text text-danger";
            }
        } else {
            message.textContent = "";
        }
    }

    function sendEmailCode() {
        let memberEmail1 = document.getElementById("memberEmail1").value.trim();
        let memberEmail2 = document.getElementById("memberEmail2").value;

        if (memberEmail2 === "custom") {
            memberEmail2 = document.getElementById("memberEmailCustom").value.trim();
        }

        let memberEmail = memberEmail1 + '@' + memberEmail2;
        document.querySelector('input[name="memberEmail"]').value = memberEmail;

        if (!memberEmail || memberEmail.indexOf('@') === -1) {
            alert('이메일을 올바르게 입력하세요.');
            document.getElementById('memberEmail1').focus();
            return;
        }

        $.ajax({
            type: 'POST',
            url: '/email/verify',
            data: {memberEmail: memberEmail},
            success: function (response) {
                if (response.success) {
                    alert('인증 코드가 전송되었습니다.');
                    document.getElementById('memberEmail1').readOnly = true;
                    document.getElementById('btnMemberEmailCodeSend').disabled = true;
                } else {
                    alert('이메일 인증 코드 전송 실패: ' + response.message);
                }
            },
            error: function (xhr) {
                alert("인증 코드 전송 실패: " + xhr.status);
            }
        });
    }

    function checkEmailCode() {
        const memberEmailCode = document.getElementById('memberEmailCode').value.trim();

        if (!memberEmailCode) {
            alert('인증 코드를 입력하세요.');
            document.getElementById('memberEmailCode').focus();
            return;
        }

        $.ajax({
            type: 'POST',
            url: '/email/codeCheck',
            data: {memberEmailCode: memberEmailCode},
            success: function (response) {
                if (response.success) {
                    alert('인증 코드 확인에 성공하였습니다.');
                } else {
                    alert('인증 코드 확인 실패: ' + response.message);
                }
            },
            error: function (xhr) {
                alert("인증 코드 확인 실패: " + xhr.status);
            }
        });
    }

    const btnSubmitJoin = document.getElementById("btnSubmitJoin");
    btnSubmitJoin?.addEventListener("click", (e) => {
        const memberIdValue = document.getElementById('memberId').value.trim();
        const emailCodeValue = document.getElementById('memberEmailCode').value.trim();
        const memberEmailValue = document.getElementById('memberEmail').value.trim();
        const memberPhoneValue = document.getElementById("memberPhone").value.trim();
        const memberBirthValue = document.getElementById("memberBirth").value.trim();
        const memberZipCodeValue = document.getElementById("memberZipCode").value.trim();
        const memberAddr1Value = document.getElementById("memberAddr1").value.trim();
        const memberAddr2Value = document.getElementById("memberAddr2").value.trim();
        const memberNameValue = document.getElementById("memberName").value.trim();
        const memberPwdConfirmValue = document.getElementById("memberPwdConfirm").value.trim();
        const memberPwdValue = document.getElementById("memberPwd").value.trim();

        const memberIdInput = document.getElementById('memberId');
        const emailCodeInput = document.getElementById('memberEmailCode');
        const memberEmailInput = document.getElementById('memberEmail');
        const memberPhoneInput = document.getElementById("memberPhone");
        const memberBirthInput = document.getElementById("memberBirth");
        const memberZipCodeInput = document.getElementById("memberZipCode");
        const memberAddr1Input = document.getElementById("memberAddr1");
        const memberAddr2Input = document.getElementById("memberAddr2");
        const memberNameInput = document.getElementById("memberName");
        const memberPwdConfirmInput = document.getElementById("memberPwdConfirm");
        const memberPwdInput = document.getElementById("memberPwd");

        e.preventDefault();
        e.stopPropagation();

        if (!memberIdValue) {
            alert('아이디를 입력하세요.');
            memberIdInput.focus();
            return;
        }
        if (!memberPwdValue) {
            alert('비밀번호를 입력하세요.');
            memberPwdInput.focus();
            return;
        }
        if (!memberPwdConfirmValue) {
            alert('비밀번호를 입력하세요.');
            memberPwdConfirmInput.focus();
            return;
        }
        if (!memberNameValue) {
            alert('이름을 입력하세요.');
            memberNameInput.focus();
            return;
        }
        if (!memberZipCodeValue) {
            alert('우편번호를 입력하세요.');
            memberZipCodeInput.focus();
            return;
        }
        if (!memberAddr1Value) {
            alert('주소를 입력하세요.');
            memberAddr1Input.focus();
            return;
        }
        if (!memberAddr2Value) {
            alert('상세 주소를 입력하세요.');
            memberAddr2Input.focus();
            return;
        }
        if (!memberBirthValue) {
            alert('생년월일을 입력하세요.');
            memberBirthInput.focus();
            return;
        }
        if (!memberPhoneValue) {
            alert('전화번호를 입력하세요.');
            memberPhoneInput.focus();
            return;
        }

        if (!memberEmailValue) {
            alert('이메일을 입력하세요.');
            memberEmailInput.focus();
            return;
        }
        if (!emailCodeValue) {
            alert('인증 코드를 입력하세요.');
            emailCodeInput.focus();
            return;
        }
        let memberEmail1 = document.getElementById("memberEmail1").value.trim();
        let memberEmail2 = document.getElementById("memberEmail2").value;

        if (memberEmail2 === "custom") {
            memberEmail2 = document.getElementById("memberEmailCustom").value.trim();
        }

        document.querySelector('input[name="memberEmail"]').value = memberEmail1 + '@' + memberEmail2;
        document.getElementById('frmJoin').submit();
    })

</script>
</body>
</html>