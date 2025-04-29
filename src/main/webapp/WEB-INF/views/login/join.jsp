<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<form name="frmJoin" id="frmJoin" action="/join" method="post">
    <table>
        <tr>
            <td>아이디</td>
            <td><input type="text" name="memberId" id="memberId"
                       value="${memberDTO.memberId != null ? memberDTO.memberId : ''}"></td>
            <td>
                <button type="button" id="btnCheckId">중복 확인</button>
            </td>
            <td>
                <span id="memberIdCheck">
                    <c:if test="${not empty idCheckMessage}">
                        <span style="color:${idCheckSuccess ? 'green' : 'red'};">${idCheckMessage}</span>
                    </c:if>
                </span>
            </td>
        </tr>
        <tr>
            <td>비밀번호</td>
            <td><input type="password" name="memberPwd" id="memberPwd"
                       value="${memberDTO.memberPwd != null ? memberDTO.memberPwd : ''}"></td>
        </tr>
        <tr>
            <td>비밀번호 확인</td>
            <td><input type="password" name="memberPwdConfirm" id="memberPwdConfirm"></td>
            <td><span id="memberPwdCheck"></span></td>
        </tr>
        <tr>
            <td>이름</td>
            <td><input type="text" name="memberName" id="memberName"
                       value="${memberDTO.memberName != null ? memberDTO.memberName : ''}"></td>
        </tr>
        <tr>
            <td>우편번호</td>
            <td><input type="text" id="memberZipCode" name="memberZipCode"
                       value="${memberDTO.memberZipCode != null ? memberDTO.memberZipCode : ''}" placeholder="우편번호">
            </td>
            <td><input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br></td>
        </tr>
        <tr>
            <td>주소</td>
            <td><input type="text" id="memberAddr1" name="memberAddr1"
                       value="${memberDTO.memberAddr1 != null ? memberDTO.memberAddr1 : ''}" placeholder="주소"><br></td>
        </tr>
        <tr>
            <td>상세주소</td>
            <td><input type="text" id="memberAddr2" name="memberAddr2"
                       value="${memberDTO.memberAddr2 != null ? memberDTO.memberAddr2 : ''}" placeholder="상세주소"></td>
        </tr>
        <tr>
            <td>생년월일</td>
            <td><input type="text" name="memberBirth" id="memberBirth"
                       value="${memberDTO.memberBirth != null ? memberDTO.memberBirth : ''}" maxlength="8"></td>
        </tr>
        <tr>
            <td>학년</td>
            <td>
                <select class="form-select" id="memberGrade" name="memberGrade">
                    <optgroup label="초등학교">
                        <option value="1" ${memberDTO.memberGrade == '1' ? 'selected' : ''}>1학년</option>
                        <option value="2" ${memberDTO.memberGrade == '2' ? 'selected' : ''}>2학년</option>
                        <option value="3" ${memberDTO.memberGrade == '3' ? 'selected' : ''}>3학년</option>
                        <option value="4" ${memberDTO.memberGrade == '4' ? 'selected' : ''}>4학년</option>
                        <option value="5" ${memberDTO.memberGrade == '5' ? 'selected' : ''}>5학년</option>
                        <option value="6" ${memberDTO.memberGrade == '6' ? 'selected' : ''}>6학년</option>
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
            </td>
        </tr>
        <tr>
            <td>이메일</td>
            <td><input type="text" name="memberEmail" id="memberEmail"
                       value="${memberDTO.memberEmail != null ? memberDTO.memberEmail : sessionScope.memberEmail}">
            </td>
            <td>
                <input type="button" id="btnMemberEmailCodeSend" onclick="sendEmailCode()" value="인증 코드 전송">
            </td>
        </tr>
        <tr>
            <td>인증 코드 확인</td>
            <td><input type="text" id="memberEmailCode"></td>
            <td>
                <input type="button" id="btnMemberEmailCodeAuth" onclick="checkEmailCode()" value="확인">
            </td>
            <td>
                <c:if test="${not empty emailCheckMessage}">
                    <span style="color:${emailCheckSuccess ? 'green' : 'red'};">${emailCheckMessage}</span>
                </c:if>
            </td>
        </tr>
        <tr>
            <td>핸드폰 번호</td>
            <td>
                <select id="memberPhone1" name="memberPhone1">
                    <option value="010">010</option>
                    <option value="011">011</option>
                </select>
            </td>
            <td><input type="text" name="memberPhone2" id="memberPhone2" maxlength="4"></td>
            <td><input type="text" name="memberPhone3" id="memberPhone3" maxlength="4"></td>
            <td><input hidden="hidden" name="memberPhone"> </td>
        </tr>
        <tr>
            <td>
                <input type="submit" id="btnSubmitJoin">
            </td>
        </tr>
    </table>
</form>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    const btnSubmitJoin = document.getElementById("btnSubmitJoin");
    btnSubmitJoin?.addEventListener("click", (e) => {
        const memberIdValue = document.getElementById('memberId').value.trim();
        const emailCodeValue = document.getElementById('memberEmailCode').value.trim();
        const memberEmailValue = document.getElementById('memberEmail').value.trim();
        const memberPhone2Value = document.getElementById("memberPhone2").value.trim();
        const memberPhone3Value = document.getElementById("memberPhone3").value.trim();
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
        const memberPhone2Input = document.getElementById("memberPhone2");
        const memberPhone3Input = document.getElementById("memberPhone3");
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
        if (!memberPhone2Value) {
            alert('전화번호를 입력하세요.');
            memberPhone2Input.focus();
            return;
        }
        if (!memberPhone3Value) {
            alert('전화번호를 입력하세요.');
            memberPhone3Input.focus();
            return;
        }

        document.querySelector('input[name="memberPhone"]').value = document.getElementById("memberPhone1").value + memberPhone2Value + memberPhone3Value;

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

        document.getElementById('frmJoin').submit();
    })

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
    // Function to send the email verification code via AJAX
    function sendEmailCode() {
        const memberEmail = document.getElementById('memberEmail').value.trim();

        if (!memberEmail) {
            alert('이메일을 입력하세요.');
            document.getElementById('memberEmail').focus();
            return;
        }

        $.ajax({
            type: 'POST',
            url: '/email/verify',
            data: { memberEmail: memberEmail },
            success: function(response) {
                if (response.success) {
                    alert('인증 코드가 전송되었습니다.');
                    document.getElementById('memberEmail').readOnly = true;
                    document.getElementById('btnMemberEmailCodeSend').disabled = true;
                } else {
                    alert('이메일 인증 코드 전송 실패: ' + response.message);
                }
            },
            error: function(xhr) {
                alert("인증 코드 전송 실패: " + xhr.status);
            }
        });
    }

    // Function to check the email verification code via AJAX
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
            data: { memberEmailCode: memberEmailCode },
            success: function(response) {
                if (response.success) {
                    alert('인증 코드 확인에 성공하였습니다.');
                } else {
                    alert('인증 코드 확인 실패: ' + response.message);
                }
            },
            error: function(xhr) {
                alert("인증 코드 확인 실패: " + xhr.status);
            }
        });
    }

</script>
</body>
</html>
