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
    <title>강좌 검색 팝업</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .input-fixed-2 {
            flex: 0 0 10%;
            max-width: 120px;
        }
    </style>
</head>
<body>
<div class="container my-5">
    <h4 class="mb-4" onclick="clearSearch()">강좌 검색</h4>
    <form method="get" id="searchForm">
        <div class="input-group mb-3">
            <select class="form-select input-fixed-2" name="search_type">
                <option value="">선택</option>
                <option value="teacherName" ${searchDTO.search_type == 'teacherName' ? 'selected':''}>강사 이름</option>
                <option value="lectureTitle" ${searchDTO.search_type == 'lectureTitle' ? 'selected':''}>강좌명</option>
            </select>
            <input type="text" class="form-control" name="search_word" placeholder="검색어 입력" value="${searchDTO.search_word}">
            <button type="submit" class="btn btn-primary">검색</button>
            <button type="button" class="btn btn-outline-secondary" id="btnSearchInit">초기화</button>
        </div>
    </form>
    <div class="table-responsive">
        <table class="table table-hover align-middle text-center">
            <thead class="table-light">
            <tr>
                <th>번호</th>
                <th>강좌명</th>
                <th>선생님</th>
                <th>선택</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="lecture" items="${lectures}">
                <tr>
                    <td>${lecture.lectureIdx}</td>
                    <td class="text-truncate" style="max-width: 300px;">${lecture.lectureTitle}</td>
                    <td>${lecture.lectureTeacherName}</td>
                    <td>
                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="selectLecture('${lecture.lectureIdx}', '${lecture.lectureTitle}')">선택</button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <div class="text-center">${paging}</div>
        <div class="text-end my-3">
            <button type="button" class="btn btn-secondary btn-sm" onclick="window.close()">창 닫기</button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function selectLecture(idx, title) {
        window.opener.setLecture(idx, title); // 부모창 함수 호출
        window.close(); // 팝업 닫기
    }

    function clearSearch() {
        window.location.href="search";
    }

    // 초기화 버튼
    document.getElementById('btnSearchInit').addEventListener('click', function() {
        document.querySelector('select[name="search_type"]').value = '';
        document.querySelector('input[name="search_word"]').value = '';
        document.getElementById('searchForm').submit();
    });
</script>
</body>
</html>
