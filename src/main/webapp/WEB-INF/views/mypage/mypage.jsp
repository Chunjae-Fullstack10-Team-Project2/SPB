<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>마이페이지</title>
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

        .my-page-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            max-width: 700px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin: 0 auto;
        }

        .my-page-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            max-width: 700px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .my-page-container h2 {
            font-weight: bold;
            color: gray;
            border-bottom: 2px solid #ccc;
            padding-bottom: 10px;
        }

        .my-page-container .form-control,
        .my-page-container .form-select {
            border-radius: 8px;
            height: 45px;
            font-size: 15px;
        }

        .my-page-container label {
            font-size: 13px;
            color: gray;
        }

        .my-page-container .text-end {
            text-align: center !important;
            margin-top: 30px;
        }

        .my-page-container #memberIdCheck span {
            font-size: 13px;
            font-weight: 500;
        }

        .no-radius {
            border-radius: 0 !important;
        }
    </style>
</head>
<body>
<%@ include file="../common/fixedHeader.jsp" %>
<%@ include file="../common/sidebar.jsp" %>

<div class="content" style="margin-left: 280px; margin-top: 100px;">
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
                <li class="breadcrumb-item active" aria-current="page">
                    마이페이지
                </li>
            </ol>
        </nav>
    </div>

    <div class="my-page-container mt-5 mb-5">
        <h2 class="mb-4">마이페이지</h2>
        <form name="frmMyPage" id="frmMyPage" action="/mypage" method="post">

            <div class="form-floating mb-3">
                <input type="text" class="form-control" id="memberId" name="memberId" value="${memberDTO.memberId}"
                       disabled>
                <label for="memberId">아이디</label>
            </div>

            <div class="form-floating mb-3">
                <input type="text" class="form-control" id="memberName" name="memberName"
                       value="${memberDTO.memberName}"
                       placeholder="이름" maxlength="30" required>
                <label for="memberName">이름</label>
            </div>

            <div class="form-floating mb-3">
                <select class="form-select" id="memberGrade" name="memberGrade" aria-label="학년 선택">
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
                <label for="memberGrade">학년</label>
            </div>

            <div class="form-floating mb-3">
                <input type="text" class="form-control" id="memberBirth" name="memberBirth"
                       value="${memberDTO.memberBirth}"
                       maxlength="8" placeholder="생년월일" required>
                <label for="memberBirth">생년월일</label>
            </div>

            <div class="form-floating mb-3">
                <input type="email" class="form-control" id="memberEmail" name="memberEmail"
                       value="${memberDTO.memberEmail}" placeholder="이메일" disabled>
                <label for="memberEmail">이메일</label>
            </div>

            <div class="form-floating mb-3">
                <input type="text" class="form-control" id="memberPhone" name="memberPhone"
                       value="${memberDTO.memberPhone}"
                       placeholder="휴대전화번호" disabled>
                <label for="memberPhone">휴대전화번호</label>
            </div>

            <div class="form-floating mb-3">
                <input type="text" class="form-control" id="memberZipCode" name="memberZipCode"
                       value="${memberDTO.memberZipCode}" placeholder="우편번호" required>
                <label for="memberZipCode">우편번호</label>
            </div>
            <div class="d-grid gap-2 mb-3">
                <button class="btn btn-outline-secondary" type="button" onclick="sample6_execDaumPostcode()">우편번호 찾기
                </button>
            </div>

            <div class="form-floating mb-3">
                <input type="text" class="form-control" id="memberAddr1" name="memberAddr1"
                       value="${memberDTO.memberAddr1}"
                       placeholder="주소" required>
                <label for="memberAddr1">주소</label>
            </div>

            <div class="form-floating mb-3">
                <input type="text" class="form-control" id="memberAddr2" name="memberAddr2"
                       value="${memberDTO.memberAddr2}"
                       placeholder="상세주소">
                <label for="memberAddr2">상세주소</label>
            </div>

            <div class="text-end d-grid gap-2">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#pwdModal">정보 수정
                </button>
            </div>
        </form>
    </div>
    <div class="modal fade" id="pwdModal" tabindex="-1" aria-labelledby="pwdModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content p-3">
                <div class="modal-header">
                    <h5 class="modal-title" id="pwdModalLabel">비밀번호 확인</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="password" class="form-control" id="memberPwdConfirm" placeholder="비밀번호를 입력하세요.">
                    <div class="text-danger mt-2" id="pwdError" style="display: none;">비밀번호가 일치하지 않습니다.</div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" onclick="verifyPassword()">확인</button>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $(function () {
        $('input[name="memberBirth"]').daterangepicker({
            singleDatePicker: true,
            showDropdowns: true,
            minYear: 1901,
            maxYear: parseInt(moment().format('YYYY'), 10),
            locale: {
                format: 'YYYYMMDD'
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

    function verifyPassword() {
        const inputPwd = $('#memberPwdConfirm').val();
        $.post('/mypage/checkPwd', {memberPwd: inputPwd})
            .done(function () {
                $('#pwdError').hide();
                $('#pwdModal').modal('hide');
                $('#frmMyPage').submit();
            })
            .fail(function () {
                $('#pwdError').show();
            });
    }
</script>
</body>
</html>
