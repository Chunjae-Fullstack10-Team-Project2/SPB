<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Created by IntelliJ IDEA. User: sinjihye Date: 2025. 4. 29. Time: 11:22 To
change this template use File | Settings | File Templates. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>봄콩이 자유게시판</title>
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

  <form name="frmModify" action="/board/${category}/modify?${queryString}" method="post" enctype="multipart/form-data" class="border p-4 rounded bg-light shadow-sm">
    <input type="hidden" name="postCategory" value="${post.postCategory}"/>
    <input type="hidden" name="postIdx" value="${post.postIdx}"/>
    <input type="hidden" name="postMemberId" value="${post.postMemberId}"/>

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

    <!-- 제목 -->
    <div class="mb-3">
      <label for="postTitle" class="form-label">제목</label>
      <input type="text" class="form-control" id="postTitle" name="postTitle" value="${post.postTitle}" maxlength="50" required>
      <div class="form-text text-end" id="titleCharCountWrapper"><span id="titleCharCount">0</span> / 50자</div>
    </div>

    <!-- 내용 -->
    <div class="mb-3">
      <label for="postContent" class="form-label">내용</label>
      <textarea class="form-control" style="overflow:hidden; resize:none;"
                rows="10" id="postContent" name="postContent" maxlength="19000" required>${post.postContent}</textarea>
      <div class="form-text text-end" id="contentCharCountWrapper">
        <span id="contentCharCount">0</span> / 19000자
      </div>
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
      <button type="button" class="btn btn-outline-secondary" onclick="view?${queryString}">
        <i class="bi bi-x-circle"></i> 취소
      </button>
      <button type="submit" class="btn btn-primary">
        <i class="bi bi-check-circle"></i> 수정 완료
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
    if (length > 19000) {
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


  document.forms['frmModify'].addEventListener('submit', function(e) {
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
      errors.push("파일은 최대 10개까지 첨부할 수 있습니다.");
    }

    const maxFileSize = 10 * 1024 * 1024;
    for (let i = 0; i < files.length; i++) {
      if (files[i].size > maxFileSize) {
        errors.push(`"${files[i].name}" 파일은 10MB 이하만 업로드할 수 있습니다.`);
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
    const form = document.querySelector('form[name="frmModify"]');
    errors.forEach(msg => {
      const div = document.createElement('div');
      div.className = 'alert alert-danger js-validation-error';
      div.innerText = msg;
      form.insertBefore(div, form.firstChild);
    });
  }

  // textarea 크기
  function autoResizeTextarea(el) {
    el.style.height = 'auto';
    el.style.height = (el.scrollHeight) + 'px';
  }

  contentInput.addEventListener('input', () => {
    updateContentCharCount();
    autoResizeTextarea(contentInput);
  });

  document.addEventListener('DOMContentLoaded', () => {
    updateTitleCharCount();
    updateContentCharCount();
    autoResizeTextarea(contentInput);
  });

</script>
</body>
</html>

