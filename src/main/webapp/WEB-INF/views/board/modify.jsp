<%-- Created by IntelliJ IDEA. User: sinjihye Date: 2025. 4. 29. Time: 11:22 To
change this template use File | Settings | File Templates. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>봄콩이 자유게시판</title>
  </head>
  <body>
    <div class="container">
      <h1>자유게시판 수정</h1>
      <form name="frmModify" action="/board/freeboard/modify" method="post">
        <input type="hidden" name="postCategory" value="${post.postCategory}"/>
        <input type="hidden" name="postIdx" value="${post.postIdx}"/>
        <div class="title">
          <input type="text" value="${post.postTitle}" name="postTitle"/>
        </div>
        <div class="content">
          <textarea rows="10" cols="100" name="postContent">${post.postContent}</textarea>
        </div>
        <div class="file">
          <input type="file" />
        </div>
        <div class="btn">
          <button type="button">취소</button>
          <button type="submit">등록</button>
        </div>
      </form>
    </div>
  </body>
</html>
