<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>봄콩이 ${category.displayName}</title>
  </head>
  <body>
    <div class="container">
      <h1>${category.displayName} 🌱</h1>
      <!-- 검색 영역 -->
      <div class="search-box">
        <div class="search-box-date">
          날짜 <input type="date" /> ~ <input type="date" />
        </div>
        <div class="search-box-word">
          구분 <input type="text" /> <button type="button">검색</button>
          <button type="button">초기화</button>
        </div>
      </div>

      <!-- 게시판 영역 -->
      <div class="container-post">
        <table>
          <thead>
            <tr>
              <th>글번호</th>
              <th>제목</th>
              <th>작성자</th>
              <th>작성일</th>
              <th>조회수</th>
              <th>좋아요</th>
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
                    <td>${post.postCreatedAt}</td>
                    <td>${post.postReadCnt}</td>
                    <td>0</td>
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
              <td colspan="6"><button type="button" class="btn" id="btnRegist">글 작성</button></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  <script>
    document.getElementById('btnRegist').addEventListener('click', function() {
      window.location.href="write";
    })

  </script>
  </body>
</html>
