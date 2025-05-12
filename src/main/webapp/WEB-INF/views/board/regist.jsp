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
      <c:if test="${not empty errorMessages}">
        <c:forEach items="${errorMessages}" var="errorMessage">
        <div class="alert alert-danger">
            ${errorMessage}
        </div>
        </c:forEach>
      </c:if>
      <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
            ${errorMessage}
        </div>
      </c:if>

      <!-- 제목 입력 -->
      <div class="mb-3">
        <label for="postTitle" class="form-label">제목</label>
        <input type="text" class="form-control" name="postTitle" id="postTitle" placeholder="제목을 입력하세요"
               value="${postDTO.postTitle != null and postDTO.postTitle != '' ? postDTO.postTitle : ''}" required maxlength="50">
        <div class="form-text text-end" id="titleCharCountWrapper"><span id="titleCharCount">0</span> / 50자</div>
      </div>

      <!-- 내용 입력 -->
      <div class="mb-3">
        <label for="postContent" class="form-label">내용</label>
        <textarea class="form-control" rows="10" name="postContent" id="postContent" placeholder="내용을 입력하세요" maxlength="20000" required>${postDTO.postContent != null and postDTO.postContent != '' ? postDTO.postContent : ''}</textarea>
        <div class="form-text text-end" id="contentCharCountWrapper">
          <span id="contentCharCount">0</span> / 20000자
        </div>
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
<script>

  const titleInput = document.getElementById('postTitle');
  const contentInput = document.getElementById('postContent');
  const titleCharCount = document.getElementById('titleCharCount');
  const contentCharCount = document.getElementById('contentCharCount');
  const titleCharCountWrapper = document.getElementById('titleCharCountWrapper');
  const contentCharCountWrapper = document.getElementById('contentCharCountWrapper');

  function updateContentCharCount() {
    const length = contentInput.value.length;
    contentCharCount.textContent = length;

    // 글자수 초과 시 빨간색
    if (length > 20000) {
      contentCharCountWrapper.classList.add('text-danger');
    } else {
      contentCharCountWrapper.classList.remove('text-danger');
    }
  }
  function updateTitleCharCount() {
    const length = titleInput.value.length;
    titleCharCount.textContent = length;
    if (length>50) {
      titleCharCountWrapper.classList.add('text-danger');
    } else {
      titleCharCountWrapper.classList.remove('text-danger');
    }
  }

  titleInput.addEventListener('input', updateTitleCharCount);
  contentInput.addEventListener('input', updateContentCharCount);
  document.addEventListener('DOMContentLoaded', ()=> {
    updateTitleCharCount();
    updateContentCharCount();
  });

  document.forms['frmRegist'].addEventListener('submit', function(e) {
    const title = document.getElementById('postTitle').value.trim();
    const content = document.getElementById('postContent').value.trim();
    const files = document.getElementById('files').files;
    let errors = [];

    if (!title) {
      errors.push("제목을 입력해주세요.");
    } else if (title.length > 50) {
      errors.push("제목은 50자 이하로 입력해주세요.");
    }

    if (!content) {
      errors.push("내용을 입력해주세요.");
    } else if (content.length > 19000) {
      errors.push("내용은 19,000자 이하로 입력해주세요.");
    }

    if (files.length > 10) {
      errors.push("파일은 한 번에 최대 10개까지 첨부할 수 있습니다.");
    }

    const maxFileSize = 10 * 1024 * 1024;
    for (let i = 0; i < files.length; i++) {
      if (files[i].size > maxFileSize) {
        errors.push(`파일은 10MB 이하만 업로드할 수 있습니다.`);
        break;
      }
    }

    if (errors.length > 0) {
      e.preventDefault();
      displayErrors(errors);
    }
  });

  function displayErrors(errors) {
    document.querySelectorAll('.alert.alert-danger.js-validation-error').forEach(el => el.remove());
    const form = document.querySelector('form[name="frmRegist"]');
    errors.forEach(msg => {
      const div = document.createElement('div');
      div.className = 'alert alert-danger js-validation-error';
      div.innerText = msg;
      form.insertBefore(div, form.firstChild);
    });
  }
</script>
</body>
</html>
