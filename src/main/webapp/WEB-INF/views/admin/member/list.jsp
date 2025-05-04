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
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>봄콩이 회원 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .main-container {
            display:flex;
        }
        .content {
            flex: 1;
            margin-left: 10px;
        }
        .table td {
            font-size: 13px;
            vertical-align: middle;
        }
    </style>
</head>
<body>
<c:set var="memberUtil" value="<%= new MemberUtil()%>"/>
<%@ include file="../../common/header.jsp" %>
<div class="container">

    <div class="main-container">
        <%@ include file="../sidebar.jsp" %>
        <div class="content">
            <h1>봄콩이 회원 목록</h1>
            <table class="table">
                <colgroup>
                    <col span="1" style="width: 50px">
                    <col span="1">
                    <col span="1" style="width: 118px">
                    <col span="1" style="width: 118px">
                    <col span="1" style="width: 118px">
                    <col span="1" style="width: 118px">
                    <col span="1" style="width: 150px">
                    <col span="1" style="width: 118px">
                </colgroup>
                <thead>
                <tr>
                    <th scope="col">No</th>
                    <th scope="col">아이디</th>
                    <th scope="col">이름</th>
                    <th scope="col">학년</th>
                    <th scope="col">생년월일</th>
                    <th scope="col">회원 가입일</th>
                    <th scope="col">상태</th>
                    <th scope="col">삭제</th>
                </tr>
                </thead>
                <tbody>
                    <c:forEach items="${list}" var="member">
                        <tr>
                            <td>${member.memberIdx} </td>
                            <td><a href="javascript:void(0);" onclick="openMemberDetail('${member.memberId}')">
                                    ${member.memberId}
                            </a></td>
                            <td>${member.memberName}</td>
                            <td>${memberUtil.getMemberGrade(member.memberGrade)}</td>
                            <td>
                                <c:set var="rawDate" value="${member.memberBirth}" />
                                    ${fn:substring(rawDate, 0, 4)}-${fn:substring(rawDate, 4, 6)}-${fn:substring(rawDate, 6, 8)}
                            </td>
                            <td>${member.memberCreatedAt}</td>
                            <td>
                                ${memberUtil.getMemberState(member.memberState)}
                            </td>
                            <td>
                                <form action="/admin/member/state" method="post" class="frmMemberState" onsubmit="return confirm('정말 상태를 변경하시겠습니까?');" style="display:inline;">
                                    <input type="hidden" name="memberId" value="${member.memberId}"/>
                                    <input type="hidden" name="memberIdx" value="${member.memberIdx}"/>
                                    <c:choose>
                                        <c:when test="${member.memberState eq '1'}">
                                            <input type="hidden" name="memberState" value="2"/>
                                            <button type="submit" class="btn btn-outline-danger btnDelete" style="font-size:13px">정지</button>
                                        </c:when>
                                        <c:when test="${member.memberState eq '2'}">
                                            <input type="hidden" name="memberState" value="1"/>
                                            <button type="submit" class="btn btn-outline-primary btnDelete" style="font-size:13px">활성화</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="submit" class="btn btn-outline-secondary" style="font-size:13px" disabled>변경불가</button>
                                        </c:otherwise>
                                    </c:choose>
                                </form>
                            </td>

                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script>
    function openMemberDetail(memberId) {
        const url = '/admin/member/view?memberId=' + encodeURIComponent(memberId);
        window.open(url, 'memberDetail', 'width=600,height=500,scrollbars=yes,resizable=no');
    }
</script>
</body>
</html>
