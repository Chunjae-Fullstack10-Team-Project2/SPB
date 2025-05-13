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
    <style>

        .profile-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-info h1 {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .profile-info p {
            color: #666;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f5f5f5;
            font-weight: normal;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .btn-sm {
            padding: 4px 8px;
            font-size: 12px;
        }

    </style>
</head>
<body>
    <%@ include file="../../common/sidebarHeader.jsp" %>
    <div class="content">

        <div class="container my-5">
            <%@ include file="../../common/breadcrumb.jsp" %>
        </div>
        <c:if test="${not empty teacher2}">
        <div class="container my-5">
            <div class="alert alert-warning" role="alert">
                <b>선생님 등록 요청 ${fn:length(teacher2)}건</b>
            </div>
        </div>
        </c:if>
        <div class="container my-5">
            <h2 class="h4 fw-bold">선생님 목록</h2>
        </div>

        <div class="container my-2">
            <h5>등록된 선생님</h5>
            <table class="table table-hover text-center align-middle">
                <colgroup>
                    <col span="1" style="width: 80px">
                    <col span="1">
                    <col span="1" style="width: 118px">
                    <col span="1" style="width: 118px">
                    <col span="1" style="width: 118px">
                    <col span="1" style="width: 118px">
                </colgroup>
                <thead class="table-light">
                <tr>
                    <th scope="col">
                        No
                    </th>
                    <th scope="col">
                        아이디
                    </th>
                    <th scope="col">
                        이름
                    </th>
                    <th scope="col">
                        생년월일
                    </th>
                    <th scope="col">
                        회원 가입일
                    </th>
                    <th scope="col">정보 수정</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty teacher1}">
                        <c:forEach items="${teacher1}" var="member" varStatus="status">
                            <tr class="clickable-row" data-href="/teacher/personal?teacherId=${member.memberId}">

                                <td>${status.count} </td>
                                <td>${member.memberId}</td>
                                <td>${member.memberName}</td>
                                <td>
                                    <c:set var="rawDate" value="${member.memberBirth}" />
                                        ${fn:substring(rawDate, 0, 4)}-${fn:substring(rawDate, 4, 6)}-${fn:substring(rawDate, 6, 8)}
                                </td>
                                <td>${member.memberCreatedAt}</td>
                                <td><button type="button" data-member-id="${member.memberId}" class="btnModifyTeacher btn btn-sm btn-outline-warning">수정</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="8" style="text-align: center;padding: 20px;">
                                등록된 회원 정보가 없습니다.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
        <div class="container my-2">
            <h5>선생님 등록 요청</h5>
            <table class="table table-hover text-center align-middle">
                <colgroup>
                    <col span="1" style="width: 80px">
                    <col span="1">
                    <col span="1" style="width: 118px">
                    <col span="1" style="width: 118px">
                    <col span="1" style="width: 118px">
                    <col span="1" style="width: 118px">
                </colgroup>
                <thead class="table-light">
                <tr>
                    <th scope="col">
                        No
                    </th>
                    <th scope="col">
                        아이디
                    </th>
                    <th scope="col">
                        이름
                    </th>
                    <th scope="col">
                        생년월일
                    </th>
                    <th scope="col">
                        회원 가입일
                    </th>
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
                    <c:otherwise>
                        <tr>
                            <td colspan="8" style="text-align: center;padding: 20px;">
                                등록된 회원 정보가 없습니다.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
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

            const modifyButtons = document.querySelectorAll('.btnModifyTeacher');

            modifyButtons.forEach(function (btn) {
                btn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    const memberId = btn.getAttribute('data-member-id');
                    window.location.href = 'modify?teacherId=' + memberId;
                });
            });

            const rows = document.querySelectorAll('.clickable-row');

            rows.forEach(row => {
                row.addEventListener('click', function () {
                    const url = this.dataset.href;
                    if (url) window.location.href = url;
                });
            });

        });
    </script>

</body>
</html>
