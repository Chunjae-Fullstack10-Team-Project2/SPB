<%-- Created by IntelliJ IDEA. User: sinjihye Date: 2025. 4. 29. Time: 10:42 To
change this template use File | Settings | File Templates. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>봄콩이 자유게시판</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <style>
    .content form .form-control,
    .content form .form-label {
      font-size: 14px;
    }
    .content h1 {
      font-size: 1.5rem;
      margin-bottom: 20px;
    }
  </style>
</head>
<body>
  <%@ include file="../common/sidebarHeader.jsp" %>
  <div class="content">
    <%@ include file="../common/breadcrumb.jsp" %>
    <h1>${category.displayName} 글쓰기</h1>
    <form name="frmRegist" action="/board/${category}/write" method="post" enctype="multipart/form-data" class="border p-4 rounded bg-light shadow-sm">
      <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
            ${errorMessage}
        </div>
      </c:if>

      <!-- 제목 입력 -->
      <div class="mb-3">
        <label for="postTitle" class="form-label">제목</label>
        <input type="text" class="form-control" name="postTitle" id="postTitle" placeholder="제목을 입력하세요" required>
      </div>

      <!-- 내용 입력 -->
      <div class="mb-3">
        <label for="postContent" class="form-label">내용</label>
        <textarea class="form-control" rows="10" name="postContent" id="postContent" placeholder="내용을 입력하세요" required></textarea>
      </div>

      <!-- 파일 첨부 -->
      <div class="mb-4">
        <label for="files" class="form-label">파일 첨부</label>
        <input type="file" class="form-control" name="files" id="files" multiple>
      </div>

      <!-- 버튼 영역 -->
      <div class="d-flex justify-content-end gap-2">
        <button type="button" class="btn btn-outline-secondary" onclick="history.back();">
          <i class="bi bi-x-circle"></i> 취소
        </button>
        <button type="submit" class="btn btn-primary">
          <i class="bi bi-check-circle"></i> 등록
        </button>
      </div>
    </form>
  </div>
</body>
</html>
