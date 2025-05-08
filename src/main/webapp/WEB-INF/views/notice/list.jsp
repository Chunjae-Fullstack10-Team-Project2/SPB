<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>공지사항 목록</title>
    <style>
        body {
            padding: 40px;
            margin: 0;
        }
        h2 {
            margin-bottom: 20px;
        }
        .notice-input-section {
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            white-space: nowrap;
            text-align: left;
        }
        th {
            font-weight: bold;
        }

        .list-title a {
            display: inline-block;
            max-width: 150px;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .dropdown-section {
            position: relative;
            display: inline-block;
        }
        .dropdown-menu {
            display: none;
            position: absolute;
            right: 0;
            top: 30px;
            background: #fff;
            border: 1px solid #ccc;
            border-radius: 4px;
            padding: 6px;
            z-index: 999;
            min-width: 120px;
        }
        .dropdown-menu form {
            margin: 0;
        }
        .dropdown-button {
            width: 100%;
            padding: 6px 10px;
            margin: 4px 0;
            border: 1px solid #aaa;
            background: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .dropdown-button:hover {
            background-color: #f2f2f2;
        }
        .bar-img {
            margin-left: 5px;
            width: 20px;
            cursor: pointer;
        }
        .fix-icon {
            width: 20px;
            height: 20px;
        }
        .btn-container {
            margin-top: 20px;
            text-align: right;
        }
        .btn {
            padding: 10px 20px;
            border: 1px solid #aaa;
            background: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn:hover {
            background: #f5f5f5;
        }
        .paging {
            margin-top: 20px;
            text-align: center;
        }
        .paging a {
            text-decoration: none;
            margin: 0 5px;
            color: #4A4A4A;
        }
        .paging strong {
            margin: 0 5px;
            font-weight: bold;
            color: #000;
        }

        .empty-list{
            margin-top: 10px;
            text-align: center;
        }
    </style>
</head>
<body>

<h2>공지사항 목록</h2>

<form method="get" action="${pageContext.request.contextPath}/notice/list" class="notice-input-section">
    <select name="searchType">
        <option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
        <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
    </select>
    <input type="text" name="keyword" value="${keyword}" placeholder="검색어 입력" />
    <input type="hidden" name="size" value="${size}" />
    <button type="submit">찾기</button>
    <button type="button" onclick="location.href='${pageContext.request.contextPath}/notice/list?size=${size}'">초기화</button>
</form>

<form method="get" action="${pageContext.request.contextPath}/notice/list">
    <select name="size" onchange="this.form.submit()">
        <option value="5" ${size == 5 ? 'selected' : ''}>5개</option>
        <option value="10" ${size == 10 ? 'selected' : ''}>10개</option>
        <option value="15" ${size == 15 ? 'selected' : ''}>15개</option>
    </select>
</form>

<table>
    <thead>
    <tr>
        <th>번호</th>
        <th>제목</th>
        <th>작성일</th>
        <th></th>
    </tr>
    </thead>
    <tbody>

    <!-- 고정된 공지사항 -->
    <c:forEach var="notice" items="${fixedList}">
        <tr>
            <td><img src="${pageContext.request.contextPath}/resources/images/fix.svg" class="fix-icon" alt="고정"></td>
            <td class="list-title">
                <a href="${pageContext.request.contextPath}/notice/view?noticeIdx=${notice.noticeIdx}"
                   title="${notice.noticeTitle}">
                        ${notice.noticeTitle}
                </a>
            </td>
            <td>${notice.noticeCreatedAt.toLocalDate()}</td>
            <td>
                <div class="dropdown-section">
                    <img class="bar-img" src="${pageContext.request.contextPath}/resources/images/bar.svg" onclick="toggleDropdown(this)" />
                    <div class="dropdown-menu">
                        <form method="post" action="${pageContext.request.contextPath}/notice/unfix">
                            <input type="hidden" name="noticeIdx" value="${notice.noticeIdx}" />
                            <button type="submit" class="dropdown-button">고정 해제</button>
                        </form>
                    </div>
                </div>
            </td>
        </tr>
    </c:forEach>

    <!-- 일반 공지사항 -->
    <c:set var="currentNumber" value="${listNumber}" />
    <c:set var="counter" value="0" />
    <c:forEach var="notice" items="${list}">
        <tr>
            <td>${currentNumber - counter}</td>
            <td>
                <a href="${pageContext.request.contextPath}/notice/view?noticeIdx=${notice.noticeIdx}">
                        ${notice.noticeTitle}
                </a>
            </td>
            <td>${notice.noticeCreatedAt.toLocalDate()}</td>
            <td>
                <div class="dropdown-section">
                    <img class="bar-img" src="${pageContext.request.contextPath}/resources/images/bar.svg" onclick="toggleDropdown(this)" />
                    <div class="dropdown-menu">
                        <form method="post" action="${pageContext.request.contextPath}/notice/delete">
                            <input type="hidden" name="noticeIdx" value="${notice.noticeIdx}" />
                            <button type="submit" class="dropdown-button">삭제</button>
                        </form>
                        <form method="post" action="${pageContext.request.contextPath}/notice/fix">
                            <input type="hidden" name="noticeIdx" value="${notice.noticeIdx}" />
                            <button type="submit" class="dropdown-button">상단 고정</button>
                        </form>
                    </div>
                </div>
            </td>
        </tr>
        <c:set var="counter" value="${counter + 1}" />
    </c:forEach>

    </tbody>
</table>

<c:if test="${list == null || list.isEmpty()}">
    <div class="empty-list">
        등록된 공지사항이 없습니다!
    </div>
</c:if>

<!-- 페이징 처리 -->
<div class="paging">
    ${pagination}
</div>

<div class="btn-container">
    <button type="button" class="btn" onclick="location.href='${pageContext.request.contextPath}/notice/regist'">글 작성</button>
</div>

<script>
    // toggle
    function toggleDropdown(imgElement) {
        const dropdown = imgElement.nextElementSibling;
        document.querySelectorAll('.dropdown-menu').forEach(menu => {
            if (menu !== dropdown) {
                menu.style.display = 'none';
            }
        });
        dropdown.style.display = (dropdown.style.display === 'block') ? 'none' : 'block';
    }

</script>

</body>
</html>
