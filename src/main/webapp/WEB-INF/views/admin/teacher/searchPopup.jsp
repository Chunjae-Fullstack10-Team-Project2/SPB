<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: sinjihye
  Date: 2025. 5. 7.
  Time: 17:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>선생님 검색 팝업</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
    </style>
</head>
<body>
<div class="container my-5">
    <h4 class="mb-4" onclick="clearSearch()">선생님 검색</h4>

    <!-- 검색 폼 -->
    <form method="get" id="searchForm">
        <div class="input-group mb-3">
            <input type="text" class="form-control" name="search_word" placeholder="아이디 또는 이름" value="${searchDTO.search_word}">
            <button type="submit" class="btn btn-primary">검색</button>
            <button type="button" class="btn btn-outline-secondary" id="btnSearchInit">초기화</button>
        </div>
    </form>

    <!-- 선생님 리스트 테이블 -->
    <div class="table-responsive">
        <table class="table table-hover align-middle text-center">
            <thead class="table-light">
            <tr>
                <th>번호</th>
                <th>아이디</th>
                <th>이름</th>
                <th>생년월일</th>
                <th>선택</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="teacher" items="${teachers}">
                <tr>
                    <td>${teacher.memberIdx}</td>
                    <td>${teacher.memberId}</td>
                    <td>${teacher.memberName}</td>
                    <td>${teacher.memberBirth}</td>
                    <td>
                        <button type="button" class="btn btn-sm btn-outline-primary"
                                onclick="selectTeacher('${teacher.memberId}', '${teacher.memberName}')">
                            선택
                        </button>
                    </td>
                </tr>
            </c:forEach>
            <tr>
                <td colspan="5">${paging}</td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="text-end my-3">
        <button type="button" class="btn btn-secondary btn-sm" onclick="window.close()">창 닫기</button>
    </div>
</div>

<script>
    function selectTeacher(id, name) {
        window.opener.selectTeacher(id, name); // 부모창 함수 호출
        window.close(); // 팝업 닫기
    }
    function clearSearch() {
        window.location.href="search";
    }

    // 초기화 버튼
    document.getElementById('btnSearchInit').addEventListener('click', function() {
        document.querySelector('input[name="search_word"]').value = '';
        document.getElementById('searchForm').submit();
    });
</script>
</body>
</html>
