<%-- Created by IntelliJ IDEA. User: sinjihye Date: 2025. 4. 29. Time: 10:42 To
change this template use File | Settings | File Templates. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>봄콩이 자유게시판</title>
  </head>
  <body>
  <%@ include file="../common/header.jsp" %>
    <div class="container">
      <h1>${category.displayName} 글쓰기</h1>
      <form name="frmRegist" action="/board/${category}/write" method="post" enctype="multipart/form-data">
        <div class="title">
          <input type="text" name="postTitle"/>
        </div>
        <div class="content">
          <textarea rows="10" cols="100" name="postContent"></textarea>
        </div>
        <div class="file">
          <input type="file" name="files" id="files" multiple/>
        </div>
        <div class="btn">
          <button type="button">취소</button>
          <button type="submit">등록</button>
        </div>
      </form>
    </div>
  </body>
</html>
