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
        .notice-input-section{
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
        a {
            text-decoration: none;
        }
        .list-title {
            display: inline-block;
            max-width: 250px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            vertical-align: middle;
        }
        .date-delete-button {
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
        }
        .bar-img {
            margin-left: 5px;
            width: 20px;
            cursor: pointer;
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
            min-width: 100px;
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
        #fixedNoticeArea {
            margin-bottom: 20px;
        }
        #fixedList li {
            list-style: none;
            margin: 4px 0;
        }
        .paging {
            margin-top: 20px;
            text-align: center;
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


<!-- 고정 공지 섹션 -->
<div id="fixedNoticeArea">
    <strong>📌 고정된 공지사항</strong>
    <ul id="fixedList">
        <c:forEach var="fixed" items="${fixedList}">
            <li>
                <a href="${pageContext.request.contextPath}/notice/view?noticeIdx=${fixed.noticeIdx}">
                        ${fixed.noticeTitle}
                </a>
            </li>
        </c:forEach>
    </ul>
</div>

<form id="sizeForm" method="get" action="${pageContext.request.contextPath}/notice/list">
    <select id="sizeSelect" name="size" onchange="document.getElementById('sizeForm').submit();">
        <option value="5" ${param.size == '5' ? 'selected' : ''}>5</option>
        <option value="10" ${param.size == '10' ? 'selected' : ''}>10</option>
        <option value="15" ${param.size == '15' ? 'selected' : ''}>15</option>
    </select>
</form>

<table>
    <thead>
    <tr>
        <th>번호</th>
        <th>제목</th>
        <th>작성일</th>
    </tr>
    </thead>
    <tbody>
    <c:set var="currentNumber" value="${listNumber}" />
    <c:set var="counter" value="0" />
    <c:forEach var="notice" items="${list}">
        <tr>
            <td>${currentNumber - counter}</td> <!-- 감소된 값 출력 -->
            <td>
                <a href="${pageContext.request.contextPath}/notice/view?noticeIdx=${notice.noticeIdx}" class="list-title">
                        ${notice.noticeTitle}
                </a>
            </td>
            <td>
                <div class="date-delete-button">
                    <span>${notice.noticeCreatedAt.toLocalDate()}</span>
                    <div class="dropdown-section">
                        <img class="bar-img" src="${pageContext.request.contextPath}/resources/images/bar.svg" onclick="toggleDropdown(this)" />
                        <div class="dropdown-menu">
                            <form method="post" action="${pageContext.request.contextPath}/notice/delete"
                                  onsubmit="return confirm('정말 삭제하시겠습니까?');">
                                <input type="hidden" name="noticeIdx" value="${notice.noticeIdx}" />
                                <button type="submit" class="dropdown-button">삭제</button>
                            </form>
                            <c:choose>
                                <c:when test="${notice.noticeIsFixed}">
                                    <button type="button" class="dropdown-button" onclick="unfix('${notice.noticeIdx}')">고정 해제</button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="dropdown-button" onclick="fix('${notice.noticeIdx}')">고정</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
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

<!-- 페이징 -->
<div class="paging">
    ${pagination}
</div>

<div class="btn-container">
    <button type="button" class="btn" id="btnRegist">글 작성</button>
</div>



<script>
    document.getElementById('btnRegist').addEventListener('click', function () {
        window.location.href = "regist";
    });

    function toggleDropdown(imgElement) {
        const dropdown = imgElement.nextElementSibling;
        document.querySelectorAll('.dropdown-menu').forEach(menu => {
            if (menu !== dropdown) {
                menu.style.display = 'none';
            }
        });
        dropdown.style.display = (dropdown.style.display === 'block') ? 'none' : 'block';
    }



    function fix(noticeIdx) {
        fetch('${pageContext.request.contextPath}/notice/fix', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'noticeIdx=' + noticeIdx
        }).then(res => res.text()).then(result => {
            if (result === 'OK') {
                alert('고정되었습니다.');
                location.reload();
            } else if (result === 'LIMIT') {
                alert('고정 공지사항은 최대 3개까지만 가능합니다.');
            }
        });
    }

    function unfix(noticeIdx) {
        fetch('${pageContext.request.contextPath}/notice/unfix', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'noticeIdx=' + noticeIdx
        }).then(res => res.text()).then(() => {
            alert('고정 해제되었습니다.');
            location.reload();
        });
    }

    document.addEventListener('click', function (event) {
        if (!event.target.matches('.bar-img')) {
            document.querySelectorAll('.dropdown-menu').forEach(menu => {
                menu.style.display = 'none';
            });
        }
    });
</script>

</body>
</html>
