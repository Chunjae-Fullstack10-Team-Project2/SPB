<%--
  Created by IntelliJ IDEA.
  User: sinjihye
  Date: 2025. 5. 15.
  Time: 23:15
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>선생님 페이지 관리</title>
</head>
<body>
<div class="container mt-5 mb-2 d-flex justify-content-between">
    <h2 class="h4 fw-bold">선생님 요청 목록</h2>
    <select class="form-select form-select-sm w-auto" name="page_size" id="selectPageSize">
        <option value="5" ${search.page_size == 5 ? "selected":""}>5개씩</option>
        <option value="10" ${search.page_size == 10 ? "selected":""}>10개씩</option>
        <option value="15" ${search.page_size == 15 ? "selected":""}>15개씩</option>
        <option value="20" ${search.page_size == 20 ? "selected":""}>20개씩</option>
        <option value="30" ${search.page_size == 30 ? "selected":""}>30개씩</option>
    </select>
</div>
<c:if test="${not empty teacher2}">
    <div class="container my-4">
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
            <b>선생님 등록 요청 ${requestTotalCount}건 있습니다.</b>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </div>
</c:if>

<div class="container my-2 pb-5" style="min-height: 100vh;">
    <table class="table table-hover text-center align-middle">
        <thead class="table-light">
        <tr id="teacherRow-${memberId}">
            <th scope="col">No</th>
            <th scope="col">아이디</th>
            <th scope="col">이름</th>
            <th scope="col">생년월일</th>
            <th scope="col">회원 가입일</th>
            <th scope="col">정보 등록</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty teacher2}">
                <c:forEach items="${teacher2}" var="member" varStatus="status">
                    <tr>
                        <td>${status.count} </td>
                        <td>${member.memberId}</td>
                        <td>${member.memberName}</td>
                        <td>
                            <c:set var="rawDate" value="${member.memberBirth}" />
                                ${fn:substring(rawDate, 0, 4)}-${fn:substring(rawDate, 4, 6)}-${fn:substring(rawDate, 6, 8)}
                        </td>
                        <td>${member.memberCreatedAt}</td>
                        <td><button type="button" data-member-id="${member.memberId}" class="btnRegistTeacher btn btn-sm btn-outline-success">등록</button>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
        </c:choose>
        </tbody>
    </table>
    <div class="text-center">${paging2}</div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const registButtons = document.querySelectorAll('.btnRegistTeacher');

        registButtons.forEach(function (btn) {
            btn.addEventListener('click', function () {
                const memberId = btn.getAttribute('data-member-id');
                window.location.href = 'regist?memberId=' + memberId;
            });
        });
    });
</script>

</body>
</html>
