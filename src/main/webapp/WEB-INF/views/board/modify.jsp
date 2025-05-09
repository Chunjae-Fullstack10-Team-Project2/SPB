<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Created by IntelliJ IDEA. User: sinjihye Date: 2025. 4. 29. Time: 11:22 To
change this template use File | Settings | File Templates. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    .content img {
      object-fit: cover;
    }
  </style>
</head>
<body>
<%@ include file="../common/sidebarHeader.jsp" %>

<div class="content p-4">
  <%@ include file="../common/breadcrumb.jsp" %>

  <h1>${category.displayName} 수정</h1>

  <form name="frmModify" action="/board/${category}/modify" method="post" enctype="multipart/form-data" class="border p-4 rounded bg-light shadow-sm">
    <input type="hidden" name="postCategory" value="${post.postCategory}"/>
    <input type="hidden" name="postIdx" value="${post.postIdx}"/>
    <input type="hidden" name="postMemberId" value="${post.postMemberId}"/>

    <!-- 제목 -->
    <div class="mb-3">
      <label for="postTitle" class="form-label">제목</label>
      <input type="text" class="form-control" id="postTitle" name="postTitle" value="${post.postTitle}" required>
    </div>

    <!-- 내용 -->
    <div class="mb-3">
      <label for="postContent" class="form-label">내용</label>
      <textarea class="form-control" rows="10" id="postContent" name="postContent" required>${post.postContent}</textarea>
    </div>

    <!-- 기존 파일 목록 -->
    <c:if test="${not empty post.postFiles}">
      <div class="mb-3">
        <label class="form-label">첨부된 파일</label>
        <div class="d-flex flex-wrap gap-3">
          <c:forEach items="${post.postFiles}" var="file">
            <div class="text-center">
              <img src="/upload/${file.fileName}" width="80" height="80" class="border rounded mb-1"/>
              <div>
                <input type="checkbox" name="deleteFile" value="${file.fileIdx}|${file.fileName}" id="del${file.fileIdx}">
                <label for="del${file.fileIdx}" class="form-check-label">삭제</label>
              </div>
            </div>
          </c:forEach>
        </div>
      </div>
    </c:if>

    <!-- 새 파일 업로드 -->
    <div class="mb-4">
      <label for="files" class="form-label">새 파일 추가</label>
      <input type="file" class="form-control" name="files" id="files" multiple>
    </div>

    <!-- 버튼 영역 -->
    <div class="d-flex justify-content-end gap-2">
      <button type="button" class="btn btn-outline-secondary" onclick="history.back();">
        <i class="bi bi-x-circle"></i> 취소
      </button>
      <button type="submit" class="btn btn-primary">
        <i class="bi bi-check-circle"></i> 수정 완료
      </button>
    </div>
  </form>
</div>

</body>
</html>

