<%@ page import="net.spb.spb.util.MemberUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: sinjihye
  Date: 2025. 5. 3.
  Time: 20:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<c:set var="memberUtil" value="<%= new MemberUtil()%>"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 상세 정보</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">

<div class="join-container mt-5 mb-5">
    <h2 class="mb-4">회원가입</h2>
    <form action="/admin/member/update" method="post" onsubmit="return confirm('정말 상태를 변경하시겠습니까?');" >
        <input type="hidden" name="memberId" value="${memberDTO.memberId}"/>
        <div class="mb-3 row">
            <div class="col-sm-10 input-group">
                        <input type="text" class="form-control"
                               value="${memberDTO.memberId != null ? memberDTO.memberId : ''}"
                               placeholder="아이디" maxlength="20" disabled/>
            </div>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-4">
                <input type="text" class="form-control" name="memberName" id="memberName"
                       value="${memberDTO.memberName != null ? memberDTO.memberName : ''}"
                       placeholder="이름" maxlength="30" required>
            </div>
            <div class="col-sm-4">
                <select class="form-select" id="memberGrade" name="memberGrade">
                    <option value="1" ${memberDTO.memberGrade == '0' ? 'selected' : ''}>관리자</option>
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
                       placeholder="우편번호" >
                <button class="btn btn-outline-secondary" type="button" onclick="sample6_execDaumPostcode()" >
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

        <div class="mb-3 row">
            <div class="col-sm-10 input-group">
                <input type="text" class="form-control" name="memberPhone" id="memberPhone"
                       value="${memberDTO.memberPhone != null ? memberDTO.memberPhone : ''}"
                       maxlength="11"
                       placeholder="휴대전화번호" required oninput="this.value=this.value.replace(/[^0-9]/g, '')">
            </div>
        </div>

        <div class="mb-3 row">
            <div class="col-sm-10 input-group">
                <select class="form-select" id="memberState" name="memberState">
                        <option value="1" ${memberDTO.memberState == '1' ? 'selected' : ''}>${memberUtil.getMemberState(1)}</option>
                        <option value="2" ${memberDTO.memberState == '2' ? 'selected' : ''}>${memberUtil.getMemberState(2)}</option>
                        <option value="3" ${memberDTO.memberState == '3' ? 'selected' : ''} disabled>${memberUtil.getMemberState(3)}</option>
                        <option value="4" ${memberDTO.memberState == '4' ? 'selected' : ''} disabled>${memberUtil.getMemberState(4)}</option>
                        <option value="5" ${memberDTO.memberState == '5' ? 'selected' : ''} disabled>${memberUtil.getMemberState(5)}</option>
                        <option value="6" ${memberDTO.memberState == '6' ? 'selected' : ''}>${memberUtil.getMemberState(6)}</option>
                </select>
            </div>
        </div>

        <div class="text-end d-grid gap-2">
            <button type="submit" class="btn btn-success" id="btnSubmitJoin">회원 정보 수정</button>
        </div>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
</script>
</body>
</html>
