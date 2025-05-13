<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>마이페이지</title>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

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

        .profile-img-container {
            position: relative;
            display: inline-block;
        }

        .profile-img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 1px solid #ccc;
        }

        .camera-icon {
            position: absolute;
            bottom: 5px;
            right: 5px;
            background-color: #fff;
            border-radius: 50%;
            padding: 5px;
            cursor: pointer;
            border: 1px solid #ccc;
        }

        .camera-icon i {
            font-size: 18px;
            color: #333;
        }

        #profileImgInput {
            display: none;
        }
    </style>
</head>
<body class="bg-light-subtle">
<%@ include file="../common/sidebarHeader.jsp" %>

<div class="content">
    <div class="container my-5">
        <%@ include file="../common/breadcrumb.jsp" %>
    </div>

    <div class="my-page-container mt-5 mb-5">
        <h2 class="mb-4">마이페이지</h2>
        <form name="frmMyPage" id="frmMyPage" action="/mypage" method="post" enctype="multipart/form-data">

            <div class="text-center mb-4">
                <div class="profile-img-container">
                    <c:choose>
                        <c:when test="${not empty memberDTO.memberProfileImg}">
                            <img id="mypageProfilePreview"
                                 src="${pageContext.request.contextPath}/upload/${memberDTO.memberProfileImg}"
                                 alt="프로필 이미지" class="profile-img">
                        </c:when>
                        <c:otherwise>
                            <img id="mypageProfilePreview"
                                 src="${pageContext.request.contextPath}/resources/img/default_profileImg.png"
                                 alt="기본 이미지" class="profile-img">
                        </c:otherwise>
                    </c:choose>
                    <div class="camera-icon" onclick="document.getElementById('profileImgInput').click();">
                        <i class="bi bi-camera-fill"></i>
                    </div>
                    <input type="file" id="profileImgInput" name="profileImgFile" accept="image/*"/>
                </div>
            </div>

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
                <select class="form-select" id="memberGrade" name="memberGrade" aria-label="학년 선택"
                        <c:if test="${memberDTO.memberGrade == '13' || memberDTO.memberGrade == '14'}">disabled</c:if>>>
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
                    <optgroup label="승인 대기 중">
                        <option value="14" ${memberDTO.memberGrade == '14' ? 'selected' : ''}>승인 대기 중</option>
                    </optgroup>
                </select>
                <label for="memberGrade">학년</label>

                <c:if test="${memberDTO.memberGrade == '13' || memberDTO.memberGrade == '14'}">
                    <input type="hidden" name="memberGrade" value="${memberDTO.memberGrade}" />
                </c:if>
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
                       value="${memberDTO.memberZipCode}" placeholder="우편번호" maxlength="5" required>
                <label for="memberZipCode">우편번호</label>
            </div>
            <div class="d-grid gap-2 mb-3">
                <button class="btn btn-outline-secondary" type="button" onclick="sample6_execDaumPostcode()">우편번호 찾기
                </button>
            </div>

            <div class="form-floating mb-3">
                <input type="text" class="form-control" id="memberAddr1" name="memberAddr1"
                       value="${memberDTO.memberAddr1}" maxlength="100"
                       placeholder="주소" required>
                <label for="memberAddr1">주소</label>
            </div>

            <div class="form-floating mb-3">
                <input type="text" class="form-control" id="memberAddr2" name="memberAddr2"
                       value="${memberDTO.memberAddr2}" maxlength="100"
                       placeholder="상세주소">
                <label for="memberAddr2">상세주소</label>
            </div>

            <div class="text-end gap-2">
                <button type="button" class="btn btn-primary" id="btnUpdate" data-bs-toggle="modal"
                        data-bs-target="#pwdModal">정보 수정
                </button>
                <button type="button" class="btn btn-danger" id="btnQuit" data-bs-toggle="modal"
                        data-bs-target="#pwdModal">탈퇴
                </button>
                <button type="button" class="btn btn-secondary" id="btnChangePwd"
                        onclick="location.href='/mypage/changePwd'">
                    비밀번호 변경
                </button>
                <button type="button" class="btn btn-secondary" id="btnCart"
                        onclick="location.href='/payment/cart?memberId=${sessionScope.memberId}'">
                    장바구니
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
    <c:if test="${not empty errorMessage}">
    alert("${errorMessage}");
    </c:if>

    <c:if test="${not empty message}">
    alert("${message}");
    </c:if>

    document.getElementById('profileImgInput').addEventListener('change', function () {
        const file = this.files[0];
        if (!file) return;

        const reader = new FileReader();
        reader.onload = function (e) {
            document.getElementById('mypageProfilePreview').src = e.target.result;
        };
        reader.readAsDataURL(file);
    });

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

    let modalAction = '';

    $('#btnUpdate').on('click', function () {
        modalAction = 'update';
    });

    $('#btnQuit').on('click', function () {
        modalAction = 'quit';
    });

    function verifyPassword() {
        const inputPwd = $('#memberPwdConfirm').val();
        $.post('/mypage/checkPwd', {memberPwd: inputPwd})
            .done(function () {
                $('#pwdError').hide();
                $('#pwdModal').modal('hide');

                if (modalAction === 'update') {
                    $('#frmMyPage').submit();
                } else if (modalAction === 'quit') {
                    if (confirm("정말 탈퇴하시겠습니까?")) {
                        $.post('/mypage/quit')
                            .done(function (res) {
                                alert("탈퇴가 완료되었습니다.");
                                window.location.href = '/main';
                            })
                            .fail(function () {
                                alert("탈퇴에 실패했습니다.");
                            });
                    }
                }
            })
            .fail(function () {
                $('#pwdError').show();
            });
    }
</script>
</body>
</html>
