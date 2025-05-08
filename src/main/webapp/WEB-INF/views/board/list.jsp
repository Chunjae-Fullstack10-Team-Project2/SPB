<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>봄콩이 ${category.displayName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .article-board, .article-board td {
            font-size: 13px;
        }

        .article-board a {
            text-decoration: none;
            color: black;
        }

        .article-board a:hover {
            text-decoration: underline;
            color: black;
        }

        .article-paging {
            text-align: center;
        }

        .article-paging a, .article-paging strong, .article-paging span {
            border: 1px solid black;
            border-radius: 5px;
            padding: 2px 5px;
        }

        .search-box {
            text-align: center;
            font-size: 13px;
        }

        .btn {
            font-size: 13px;
        }
    </style>
</head>
<body>
<%@ include file="../common/header.jsp" %>
<div class="container content-nonside">
    <h1>${category.displayName} 🌱</h1>

    <!-- 게시판 영역 -->
    <div class="article-board">
        <div>
            ${postTotalCount}개의 글
            <select name="page_size" id="selectPageSize">
                <option value="5" ${search.page_size eq "5" ? "selected":""}>5개씩</option>
                <option value="10" ${search.page_size eq "10" ? "selected":""}>10개씩</option>
                <option value="15" ${search.page_size eq "15" ? "selected":""}>15개씩</option>
                <option value="20" ${search.page_size eq "20" ? "selected":""}>20개씩</option>
                <option value="30" ${search.page_size eq "30" ? "selected":""}>30개씩</option>
            </select>
        </div>
        <table class="table">
            <colgroup>
                <col span="1" style="width: 80px">
                <col span="1">
                <col span="1" style="width: 118px">
                <col span="1" style="width: 118px">
                <col span="1" style="width: 68px">
                <col span="1" style="width: 68px">
            </colgroup>

            <thead>
            <tr>
                <th scope="col">글번호</th>
                <th scope="col">제목</th>
                <th scope="col">작성자</th>
                <th scope="col">작성일</th>
                <th scope="col">조회수</th>
                <th scope="col">좋아요</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty posts}">
                    <c:forEach var="post" items="${posts}">
                        <tr>
                            <td>${post.postIdx}</td>
                            <td><a href="view?idx=${post.postIdx}">${post.postTitle}</a></td>
                            <td>${post.postMemberId}</td>
                            <td>${fn:substringBefore(post.postCreatedAt, 'T')}</td>
                            <td>${post.postReadCnt}</td>
                            <td>${post.postLikeCnt}</td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="6">등록된 게시글이 없습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            <tr>
                <td colspan="6">
                    <div class="article-paging">${paging}</div>
                </td>
            </tr>
            <tr>
                <td colspan="6">
                    <button type="button" class="btn btn-outline-dark" id="btnRegist">글 작성</button>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="search-box">
        <form name="frmSearch" action="" method="get">
            <div class="search-box-date">
                날짜 <input type="date" name="search_date1" value="${search.search_date1}"/> ~ <input type="date"
                                                                                                    name="search_date2"
                                                                                                    value="${search.search_date2}"/>
            </div>
            <div class="search-box-word">
                <select name="search_type">
                    <option value="titlecontent">제목+내용</option>
                    <option value="title" ${search.search_type eq "postTitle" ? "selected":""}>제목</option>
                    <option value="content" ${search.search_type eq "postContent" ? "selected":""}>내용</option>
                    <option value="author" ${search.search_type eq "postMemberId" ? "selected":""}>작성자</option>
                </select>
                <input type="text" name="search_word" value="${search.search_word}"/>
                <button type="submit" class="btn" id="btnSearch">검색</button>
                <button type="button" class="btn" id="btnSearchInit">초기화</button>
            </div>
        </form>
    </div>
</div>
<script>
    document.getElementById('btnRegist').addEventListener('click', function () {
        window.location.href = "write";
    });
    document.getElementById('btnSearchInit').addEventListener('click', function () {
        window.location.href = "list";
    });
    const selectPageSize = document.getElementById("selectPageSize");
    selectPageSize.addEventListener('change', function () {
        let pageSize = selectPageSize.value;
        let currentUrl = window.location.href;
        let newUrl = currentUrl.split('?')[0];
        let newLocation = newUrl + "?page_size=" + pageSize;
        window.location.href = newLocation;
    });
</script>
</body>
</html>
