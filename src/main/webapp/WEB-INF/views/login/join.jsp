<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>회원가입</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css"/>

    <style>
        body {
            background-color: #f5f6f7;
        }

        .join-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            max-width: 700px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin: 0 auto;
        }

        .join-container h2 {
            font-weight: bold;
            color: gray;
            border-bottom: 2px solid #ccc;
            padding-bottom: 10px;
        }

        .join-container .form-control,
        .join-container .form-select {
            border-radius: 8px;
            height: 45px;
            font-size: 15px;
        }

        .join-container .btn {
            border-radius: 8px;
            font-size: 14px;
        }

        .join-container .btn-outline-secondary {
            border-radius: 8px;
        }

        .join-container label {
            font-size: 13px;
            color: gray;
        }

        .join-container .row.mb-3 {
            margin-bottom: 1.25rem;
        }

        .join-container .text-end {
            text-align: center;
            margin-top: 30px;
        }

        .join-container #memberIdCheck span {
            font-size: 13px;
            font-weight: 500;
        }

        .join-container .warning-text {
            color: red;
            font-size: 0.8rem;
            margin: 0.2rem 0 0 0.2rem;
        }

        .join-container #memberEmail2 {
            border-top-right-radius: 8px;
            border-bottom-right-radius: 8px;
        }

        .join-container .no-radius {
            border-radius: 0 !important;
        }
    </style>
</head>
<body>
<%@ include file="../common/header.jsp" %>

<div class="join-container mt-5 mb-5">
    <h2 class="mb-4">회원가입</h2>
    <form name="frmJoin" id="frmJoin" action="/join" method="post">

        <div class="mb-3 row">
            <div class="col-sm-10 input-group">
                <c:choose>
                    <c:when test="${memberDTO.memberJoinPath eq '2'}">
                        <input type="hidden" name="memberJoinPath" value="2"/>
                        <input type="hidden" class="form-control" id="memberId" name="memberId"
                               value="${memberDTO.memberId != null ? memberDTO.memberId : ''}">
                        <input type="hidden" class="form-control" name="memberPhone" id="memberPhone"
                               value="${memberDTO.memberPhone != null ? memberDTO.memberPhone : ''}">
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="memberJoinPath" value="1"/>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="mb-3 row">
            <div class="col-sm-10 input-group">
                <c:choose>
                    <c:when test="${memberDTO.memberJoinPath eq '2'}">
                        <!-- Naver 로그인 사용자: disabled 처리 -->
                        <input type="text" class="form-control"
                               value="${memberDTO.memberId != null ? memberDTO.memberId : ''}"
                               placeholder="아이디" maxlength="20" disabled/>
                        <button class="btn btn-outline-secondary" type="button" id="btnCheckId" disabled>
                            중복 확인
                        </button>
                    </c:when>
                    <c:otherwise>
                        <!-- 일반 사용자: 입력 및 중복 확인 가능 -->
                        <input type="text" class="form-control" name="memberId" id="memberId"
                               value="${memberDTO.memberId != null ? memberDTO.memberId : ''}"
                               placeholder="아이디" maxlength="20" required
                               oninput="this.value=this.value.replace(/[^a-zA-Z0-9]/g, '')">
                        <button class="btn btn-outline-secondary" type="button" id="btnCheckId">
                            중복 확인
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>

            <div id="idWarning" class="warning-text d-none">
                아이디는 4~20자, 알파벳과 숫자만 가능합니다.
            </div>

            <div id="memberIdCheck">
                <c:if test="${not empty idCheckMessage}">
                    <span style="color:${idCheckSuccess ? 'green' : 'red'};">${idCheckMessage}</span>
                </c:if>
            </div>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-10 input-group">
                <input type="password" class="form-control" name="memberPwd" id="memberPwd"
                       value="${memberDTO.memberPwd != null ? memberDTO.memberPwd : ''}"
                       placeholder="비밀번호" maxlength="15" required
                       oninput="this.value=this.value.replace(/[^a-zA-Z0-9]/g, '')">
                <button class="btn btn-outline-secondary" type="button"
                        onclick="togglePasswordVisibility('memberPwd', this)">
                    <i class="bi bi-eye"></i>
                </button>
            </div>
            <div id="pwdWarning" class="warning-text d-none">비밀번호는 대소문자와 숫자를 포함한 4~15자여야 합니다.</div>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-10 input-group">
                <input type="password" class="form-control" name="memberPwdConfirm" id="memberPwdConfirm"
                       value="${memberPwdConfirm != null ? memberPwdConfirm : ''}"
                       placeholder="비밀번호 확인" maxlength="15" required
                       oninput="this.value=this.value.replace(/[^a-zA-Z0-9]/g, '')">
                <button class="btn btn-outline-secondary" type="button"
                        onclick="togglePasswordVisibility('memberPwdConfirm', this)">
                    <i class="bi bi-eye"></i>
                </button>
            </div>
            <div id="pwdMatchWarning" class="warning-text d-none">비밀번호가 일치하지 않습니다.</div>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-4">
                <input type="text" class="form-control" name="memberName" id="memberName"
                       value="${memberDTO.memberName != null ? memberDTO.memberName : ''}"
                       placeholder="이름" maxlength="30" required>
            </div>
            <div class="col-sm-4">
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

            <div class="col-sm-4">
                <input type="text" class="form-control" name="memberBirth" id="memberBirth"
                       value="${memberDTO.memberBirth != null ? memberDTO.memberBirth : ''}" maxlength="8"
                       placeholder="생년월일" required>
            </div>
        </div>


        <div class="mb-3 row">
            <div class="col-sm-10 input-group">
                <input type="text" class="form-control" id="memberZipCode" name="memberZipCode"
                       value="${memberDTO.memberZipCode != null ? memberDTO.memberZipCode : ''}"
                       placeholder="우편번호" required>
                <button class="btn btn-outline-secondary" type="button" onclick="sample6_execDaumPostcode()">
                    우편번호 찾기
                </button>
            </div>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-6">
                <input type="text" class="form-control" id="memberAddr1" name="memberAddr1"
                       value="${memberDTO.memberAddr1 != null ? memberDTO.memberAddr1 : ''}" placeholder="주소" required>
            </div>
            <div class="col-sm-6">
                <input type="text" class="form-control" id="memberAddr2" name="memberAddr2"
                       value="${memberDTO.memberAddr2 != null ? memberDTO.memberAddr2 : ''}" placeholder="상세주소">
            </div>
        </div>

        <input type="hidden" name="memberEmail" id="memberEmail">

        <div class="mb-3 row">
            <div class="col-sm-10 input-group">
                <c:set var="memberEmail1" value="${fn:split(memberDTO.memberEmail, '@')}"/>
                <c:choose>
                    <c:when test="${memberDTO.memberJoinPath eq '2'}">
                        <!-- 네이버 가입한 사용자: 이메일 입력 비활성화 -->
                        <input type="text" class="form-control" name="memberEmail1" id="memberEmail1"
                               value="${memberDTO.memberEmail != null ? memberEmail1[0] : ''}"
                               placeholder="이메일" required
                               oninput="this.value=this.value.replace(/[^a-zA-Z0-9]/g, '')" disabled>
                        <span class="input-group-text">@</span>
                        <select class="form-select" id="memberEmail2" name="memberEmail2"
                                onchange="toggleCustomEmailInput(this)" disabled>
                            <option>naver.com</option>
                            <option>gmail.com</option>
                            <option>hanmail.net</option>
                            <option value="custom">직접 입력</option>
                        </select>
                        <input type="text" class="form-control d-none" id="memberEmailCustom" placeholder="직접 입력"
                               maxlength="20" oninput="this.value=this.value.replace(/[^a-zA-Z0-9.]/g, '')" disabled>
                    </c:when>
                    <c:otherwise>
                        <!-- 일반 사용자: 입력 및 중복 확인 가능 -->
                        <input type="text" class="form-control" name="memberEmail1" id="memberEmail1"
                               value="${memberDTO.memberEmail != null ? memberEmail1[0] : ''}"
                               placeholder="이메일" required oninput="this.value=this.value.replace(/[^a-zA-Z0-9]/g, '')">
                        <span class="input-group-text">@</span>
                        <select class="form-select" id="memberEmail2" name="memberEmail2"
                                onchange="toggleCustomEmailInput(this)">
                            <option>naver.com</option>
                            <option>gmail.com</option>
                            <option>hanmail.net</option>
                            <option value="custom">직접 입력</option>
                        </select>
                        <input type="text" class="form-control d-none" id="memberEmailCustom" placeholder="직접 입력"
                               maxlength="20" oninput="this.value=this.value.replace(/[^a-zA-Z0-9.]/g, '')">
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="input-group mb-3 d-grid gap-2">
            <button type="button" class="btn btn-outline-secondary w-auto" id="btnMemberEmailCodeSend"
                    onclick="sendEmailCode()"
                    <c:if test="${memberDTO.memberJoinPath eq '2'}">disabled</c:if>
            >인증 코드 전송
            </button>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-10 input-group">
                <input type="text" class="form-control" id="memberEmailCode" name="memberEmailCode" placeholder="인증 코드"
                       maxlength="6" required value="${memberEmailCode != null ? memberEmailCode : ''}"
                       <c:if test="${memberDTO.memberJoinPath eq '2'}">disabled</c:if> >

                <button type="button" class="btn btn-outline-secondary" id="btnMemberEmailCodeAuth"
                        onclick="checkEmailCode()"
                        <c:if test="${memberDTO.memberJoinPath eq '2'}">disabled</c:if> >
                    인증 코드 확인
                </button>
            </div>
            <div class="mb-2">
                <span id="emailCountWarning" class="warning-text"></span>
                <span id="emailAuthTimeWarning" class="warning-text"></span>
            </div>
            <div class="col-sm-2">
                <c:if test="${not empty emailCheckMessage}">
                    <span style="color:${emailCheckSuccess ? 'green' : 'red'};">${emailCheckMessage}</span>
                </c:if>
            </div>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-10 input-group">
                <c:choose>
                    <c:when test="${memberDTO.memberJoinPath eq '2'}">
                        <input type="text" class="form-control"
                               value="${memberDTO.memberPhone != null ? memberDTO.memberPhone : ''}"
                               maxlength="11" disabled
                               placeholder="휴대전화번호" oninput="this.value=this.value.replace(/[^0-9]/g, '')">
                    </c:when>
                    <c:otherwise>
                        <input type="text" class="form-control" name="memberPhone" id="memberPhone"
                               value="${memberDTO.memberPhone != null ? memberDTO.memberPhone : ''}"
                               maxlength="11"
                               placeholder="휴대전화번호" required oninput="this.value=this.value.replace(/[^0-9]/g, '')">
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="text-end d-grid gap-2">
            <button type="submit" class="btn btn-primary" id="btnSubmitJoin">회원가입</button>
        </div>
    </form>
</div>

<script>
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
                document.getElementById('memberEmailCode').disabled = true;
                document.getElementById('btnMemberEmailCodeAuth').disabled = true;

                // 다시 메일 보낼 수 있도록 버튼 활성화
                document.getElementById('btnMemberEmailCodeSend').disabled = false;
                document.getElementById('memberEmail1').readOnly = false;
            }

            emailAuthTimeLimit--;
        }, 1000);
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
            contentType: 'application/json',
            data: JSON.stringify({ memberEmail: memberEmail }),
            success: function (response) {
                if (response.success) {
                    alert('인증 코드가 전송되었습니다.');
                    document.getElementById('memberEmail1').readOnly = true;
                    document.getElementById('btnMemberEmailCodeSend').disabled = true;

                    const count = response.emailTryCount;
                    const emailCountWarning = document.getElementById('emailCountWarning');
                    emailCountWarning.innerHTML = "<strong>인증 횟수 " + count + "/3회</strong>";

                    startEmailAuthTimer();
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
        const memberEmail = document.getElementById('memberEmail').value.trim();

        if (!memberEmailCode) {
            alert('인증 코드를 입력하세요.');
            document.getElementById('memberEmailCode').focus();
            return;
        }

        $.ajax({
            type: 'POST',
            url: '/email/codeCheck',
            contentType: 'application/json',
            data: JSON.stringify({
                memberEmailCode: memberEmailCode,
                memberEmail: memberEmail
            }),
            success: function (response) {
                if (response.success) {
                    alert('인증 코드 확인에 성공하였습니다.');
                    document.getElementById('memberEmailCode').readOnly = true;
                    document.getElementById('btnMemberEmailCodeAuth').disabled = true;
                } else {
                    alert('인증 코드 확인 실패: ' + response.message);
                }
            },
            error: function (xhr) {
                alert("인증 코드 확인 실패: " + xhr.status);
            }
        });
    }

    // function sendEmailCode() {
    //     let memberEmail1 = document.getElementById("memberEmail1").value.trim();
    //     let memberEmail2 = document.getElementById("memberEmail2").value;
    //
    //     if (memberEmail2 === "custom") {
    //         memberEmail2 = document.getElementById("memberEmailCustom").value.trim();
    //     }
    //
    //     let memberEmail = memberEmail1 + '@' + memberEmail2;
    //     document.querySelector('input[name="memberEmail"]').value = memberEmail;
    //
    //     if (!memberEmail || memberEmail.indexOf('@') === -1) {
    //         alert('이메일을 올바르게 입력하세요.');
    //         document.getElementById('memberEmail1').focus();
    //         return;
    //     }
    //
    //     $.ajax({
    //         type: 'POST',
    //         url: '/email/verify',
    //         data: {memberEmail: memberEmail},
    //         success: function (response) {
    //             if (response.success) {
    //                 alert('인증 코드가 전송되었습니다.');
    //
    //                 document.getElementById('memberEmail1').readOnly = true;
    //                 document.getElementById('btnMemberEmailCodeSend').disabled = true;
    //
    //                 const count = response.emailTryCount;
    //                 const emailCountWarning = document.getElementById('emailCountWarning');
    //                 emailCountWarning.innerHTML = "<strong>인증 횟수 " + count + "/3회</strong>";
    //
    //                 startEmailAuthTimer();
    //             } else {
    //                 alert('이메일 인증 코드 전송 실패: ' + response.message);
    //             }
    //         },
    //         error: function (xhr) {
    //             alert("인증 코드 전송 실패: " + xhr.status);
    //         }
    //     });
    // }
    //
    // function checkEmailCode() {
    //     const memberEmailCode = document.getElementById('memberEmailCode').value.trim();
    //
    //     if (!memberEmailCode) {
    //         alert('인증 코드를 입력하세요.');
    //         document.getElementById('memberEmailCode').focus();
    //         return;
    //     }
    //
    //     $.ajax({
    //         type: 'POST',
    //         url: '/email/codeCheck',
    //         data: {memberEmailCode: memberEmailCode},
    //         success: function (response) {
    //             if (response.success) {
    //                 alert('인증 코드 확인에 성공하였습니다.');
    //                 document.getElementById('memberEmailCode').readOnly = true;
    //                 document.getElementById('btnMemberEmailCodeAuth').disabled = true;
    //             } else {
    //                 alert('인증 코드 확인 실패: ' + response.message);
    //             }
    //         },
    //         error: function (xhr) {
    //             alert("인증 코드 확인 실패: " + xhr.status);
    //         }
    //     });
    // }

    <c:if test="${not empty errorMessage}">
    alert("${errorMessage}");
    </c:if>

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

    $('#memberPwdConfirm').on('input', function () {
        const password = $('#memberPwd').val();
        const confirmPassword = $('#memberPwdConfirm').val();

        if (password && confirmPassword) {
            if (password === confirmPassword) {
                $('#pwdMatchWarning').addClass('d-none');
            } else {
                $('#pwdMatchWarning').removeClass('d-none');
            }
        }
    });

    $(function () {
        $('input[name="memberBirth"]').daterangepicker({
            singleDatePicker: true,
            showDropdowns: true,
            minYear: 1901,
            maxYear: parseInt(moment().format('YYYY'), 10),
            locale: {
                format: 'YYYYMMDD',
                applyLabel: "확인",
                cancelLabel: "취소",
                daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
                monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                firstDay: 0 // 일요일부터
            }
        });
    });

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
        const memberEmailCustom = document.getElementById("memberEmailCustom");
        const memberEmail2 = document.getElementById("memberEmail2");

        if (selectEl.value === "custom") {
            memberEmailCustom.classList.remove("d-none");
            memberEmail2.classList.add("no-radius");
            memberEmailCustom.focus();
        } else {
            memberEmailCustom.classList.add("d-none");
            memberEmail2.classList.remove("no-radius");
            memberEmailCustom.value = '';
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

    const btnSubmitJoin = document.getElementById("btnSubmitJoin");
    btnSubmitJoin?.addEventListener("click", (e) => {
        const memberIdValue = document.getElementById('memberId').value.trim();
        let memberEmailValue = document.getElementById('memberEmail').value.trim();
        const memberPhoneValue = document.getElementById("memberPhone").value.trim();
        const memberBirthValue = document.getElementById("memberBirth").value.trim();
        const memberZipCodeValue = document.getElementById("memberZipCode").value.trim();
        const memberAddr1Value = document.getElementById("memberAddr1").value.trim();
        const memberNameValue = document.getElementById("memberName").value.trim();
        const memberPwdConfirmValue = document.getElementById("memberPwdConfirm").value.trim();
        const memberPwdValue = document.getElementById("memberPwd").value.trim();

        const memberIdInput = document.getElementById('memberId');
        const memberEmailInput = document.getElementById('memberEmail');
        const memberPhoneInput = document.getElementById("memberPhone");
        const memberBirthInput = document.getElementById("memberBirth");
        const memberZipCodeInput = document.getElementById("memberZipCode");
        const memberAddr1Input = document.getElementById("memberAddr1");
        const memberNameInput = document.getElementById("memberName");
        const memberPwdConfirmInput = document.getElementById("memberPwdConfirm");
        const memberPwdInput = document.getElementById("memberPwd");

        e.preventDefault();
        e.stopPropagation();

        const idRegEx = /^[a-zA-Z0-9]{4,20}$/;
        const pwdRegEx = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{4,15}$/;

        if (!memberIdValue || !idRegEx.test(memberIdValue)) {
            alert('아이디는 4~20자, 알파벳과 숫자만 가능합니다.');
            memberIdInput.focus();
            return;
        }

        if (!memberPwdValue || !pwdRegEx.test(memberPwdValue)) {
            alert('비밀번호는 대소문자와 숫자를 포함한 4~15자여야 합니다.');
            memberPwdInput.focus();
            return;
        }

        let memberEmail1Value = document.getElementById("memberEmail1").value.trim();
        let memberEmail2Value = document.getElementById("memberEmail2").value;
        if (memberEmail2Value === "custom") {
            memberEmail2Value = document.getElementById("memberEmailCustom").value.trim();
        }
        memberEmailValue = memberEmail1Value + '@' + memberEmail2Value;

        if (!memberPwdValue || memberPwdValue !== memberPwdConfirmValue) {
            alert('비밀번호와 비밀번호 확인이 일치하지 않습니다.');
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

        document.querySelector('input[name="memberEmail"]').value = memberEmailValue;
        document.getElementById('frmJoin').submit();
    });
</script>
</body>
</html>