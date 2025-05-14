<%--
  Created by IntelliJ IDEA.
  User: sinjihye
  Date: 2025. 5. 10.
  Time: 14:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>선생님 수정</title>
</head>
<body>
<%@ include file="../../common/sidebarHeader.jsp" %>
<div class="content" style="margin-left: 280px; margin-top: 100px;">
  <div class="container my-5">
    <%@ include file="../../common/breadcrumb.jsp" %>
  </div>

  <div class="container my-5">
    <div class="card shadow rounded">
      <div class="card-header bg-primary text-white">
        <h5 class="mb-0">선생님 수정</h5>
      </div>
      <div class="card-body">
        <form name="frmModify" method="post" class="needs-validation" novalidate enctype="multipart/form-data">
          <input type="hidden" name="teacherIdx" value="${teacherDTO.teacherIdx}">
          <input type="hidden" name="teacherProfileImg" value="${teacherDTO.teacherProfileImg}">
          <div class="mb-3">
            <label for="teacherId" class="form-label">선생님 아이디</label>
            <input type="text" class="form-control" id="teacherId" name="teacherId"
                   placeholder="선생님 아이디를 입력하세요." required
                   value="${teacherDTO.teacherId != null ? teacherDTO.teacherId : ''}" readonly>
          </div>

          <div class="mb-3">
            <label for="teacherName" class="form-label">선생님 성함</label>
            <input type="text" class="form-control" id="teacherName" name="teacherName"
                   placeholder="선생님 성함을 입력하세요."
                   value="${teacherDTO.teacherName != null ? teacherDTO.teacherName : ''}" readonly>
          </div>

          <div class="mb-3">
            <label for="teacherSubject" class="form-label">선생님 담당 과목</label>
            <input type="text" class="form-control" id="teacherSubject" name="teacherSubject"
                   placeholder="선생님 담당 과목을 입력하세요."
                   value="${teacherDTO.teacherSubject != null ? teacherDTO.teacherSubject : ''}" maxlength="50" required>
            <div class="form-text text-end" id="teacherSubjectCharCountWrapper"><span id="teacherSubjectCharCount">0</span> / 50자</div>
          </div>

          <div class="mb-3">
            <label for="file1" class="form-label">선생님 이미지</label>
            <input type="file" class="form-control" id="file1" name="file1" accept="image/*">
          </div>

          <div class="mb-3">
            <label for="teacherIntro" class="form-label">선생님 소개</label>
            <textarea class="form-control" id="teacherIntro" name="teacherIntro" rows="10"
                      placeholder="선생님 소개를 입력하세요." style="resize: none;"
                      required maxlength="450">${teacherDTO.teacherIntro != null ? teacherDTO.teacherIntro : ''}</textarea>
            <div class="form-text text-end" id="teacherIntroCharCountWrapper"><span id="teacherIntroCharCount">0</span> / 450자</div>
          </div>

          <div class="d-flex justify-content-end gap-2">
            <input type="button" id="btnCancel" class="btn btn-outline-secondary" value="취소">
            <input type="submit" class="btn btn-primary" value="완료">
          </div>
        </form>
      </div>
    </div>
  </div>
</div>
<script>
  const btnCancel = document.getElementById('btnCancel').addEventListener('click', () => {
    window.location.href="list";
  });

  const teacherSubjectInput = document.getElementById('teacherSubject');
  const teacherIntroInput = document.getElementById('teacherIntro');

  const teacherSubjectCharCount = document.getElementById('teacherSubjectCharCount');
  const teacherIntroCharCount = document.getElementById('teacherIntroCharCount');
  const teacherSubjectCharCountWrapper = document.getElementById('teacherSubjectCharCountWrapper');
  const teacherIntroCharCountWrapper = document.getElementById('teacherIntroCharCountWrapper');


  function updateSubjectCharCount() {
    const length = teacherSubjectInput.value.length;
    teacherSubjectCharCount.textContent = length;

    // 글자수 초과 시 빨간색
    if (length > 50) {
      teacherSubjectCharCountWrapper.classList.add('text-danger');
    } else {
      teacherSubjectCharCountWrapper.classList.remove('text-danger');
    }
  }
  function updateIntroCharCount() {
    const length = teacherIntroInput.value.length;
    teacherIntroCharCount.textContent = length;
    if (length>450) {
      teacherIntroCharCountWrapper.classList.add('text-danger');
    } else {
      teacherIntroCharCountWrapper.classList.remove('text-danger');
    }
  }

  teacherSubjectInput.addEventListener('input', updateSubjectCharCount);
  teacherIntroInput.addEventListener('input', updateIntroCharCount);
  document.addEventListener('DOMContentLoaded', ()=> {
    updateSubjectCharCount();
    updateIntroCharCount();
  });

  document.forms['frmRegist'].addEventListener('submit', function(e) {
    const teacherIntro = document.getElementById('teacherIntro');
    const teacherSubject = document.getElementById('teacherSubject');
    const file = document.getElementById('file1');
    let errors = [];

    if (!teacherIntro) {
      errors.push("선생님 소개글을 입력해주세요.");
    } else if (teacherIntro.length > 450) {
      errors.push("선생님 소개글을 450자 이하로 입력해주세요.");
    }

    if (!teacherSubject) {
      errors.push("선생님 담당 과목 입력해주세요.");
    } else if (teacherSubject.length > 50) {
      errors.push("선생님 담당 과목을 50자 이하로 입력해주세요.");
    }

    const maxFileSize = 10 * 1024 * 1024;
    if(file.size > maxFileSize) {
      errors.push('파일은 10MB이하만 업로드할 수 있습니다.');
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
