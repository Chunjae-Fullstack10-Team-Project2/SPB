<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Created by IntelliJ IDEA. User: sinjihye Date: 2025. 4. 29. Time: 11:22 To
change this template use File | Settings | File Templates. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>봄콩이 자유게시판</title>
  </head>
  <body>
  <%@ include file="../common/header.jsp" %>
    <div class="container">
      <h1>${category.displayName} 수정</h1>
      <form name="frmModify" action="/board/${category}/modify" method="post" enctype="multipart/form-data">
        <input type="hidden" name="postCategory" value="${post.postCategory}"/>
        <input type="hidden" name="postIdx" value="${post.postIdx}"/>
        <div class="title">
          <input type="text" value="${post.postTitle}" name="postTitle"/>
        </div>
        <div class="content">
          <textarea rows="10" cols="100" name="postContent">${post.postContent}</textarea>
        </div>
        <c:if test="${not empty post.postFiles}">
        <div class="file">
          <c:forEach items="${post.postFiles}" var="file">
            <img src="/upload/${file.fileName}" width="50" height="50">
            <input type="checkbox" name="deleteFile" value="${file.fileIdx}|${file.fileName}">삭제
          </c:forEach>
        </div>
        </c:if>
        <div class="file">
          <input type="file" name="files" id="files" multiple/>
        </div>
        <div class="btn">
          <button type="button" class="btn btn-secondary">취소</button>
          <button type="submit" class="btn btn-primary">등록</button>
        </div>
      </form>
    </div>
  </body>
</html>
