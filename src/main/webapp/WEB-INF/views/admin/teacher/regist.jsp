<%--
  Created by IntelliJ IDEA.
  User: sinjihye
  Date: 2025. 5. 7.
  Time: 10:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>선생님 등록</title>
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
        <h5 class="mb-0">선생님 등록</h5>
      </div>
      <div class="card-body">
        <form name="frmRegist" method="post" class="needs-validation" novalidate enctype="multipart/form-data">
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
          <div class="mb-3">
            <label for="teacherId" class="form-label">선생님 아이디</label>
            <input type="text" class="form-control" id="teacherId" name="teacherId"
                   placeholder="선생님 아이디를 입력하세요." required
                   value="${memberDTO.memberId != null ? memberDTO.memberId : ''}" readonly maxlength="20">
          </div>

          <div class="mb-3">
            <label for="teacherName" class="form-label">선생님 성함</label>
            <input type="text" class="form-control" id="teacherName" name="teacherName"
                   placeholder="선생님 성함을 입력하세요."
                   value="${memberDTO.memberName}" readonly maxlength="10">
          </div>

          <div class="mb-3">
            <label for="teacherSubject" class="form-label">선생님 담당 과목</label>
            <input type="text" class="form-control" id="teacherSubject" name="teacherSubject"
                   placeholder="선생님 담당 과목을 입력하세요."
                   value="${teacherDTO.teacherSubject}" maxlength="50">
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
                      required maxlength="5000">${teacherDTO.teacherIntro}</textarea>
            <div class="form-text text-end" id="teacherIntroCharCountWrapper"><span id="teacherIntroCharCount">0</span> / 50자</div>
          </div>

          <div class="d-flex justify-content-end gap-2">
            <input type="reset" class="btn btn-outline-secondary" value="취소">
            <input type="submit" class="btn btn-primary" value="등록">
          </div>
        </form>
      </div>
    </div>
  </div>
</div>
<script>

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
    if (length > 20000) {
      teacherSubjectCharCountWrapper.classList.add('text-danger');
    } else {
      teacherSubjectCharCountWrapper.classList.remove('text-danger');
    }
  }
  function updateIntroCharCount() {
    const length = teacherIntroInput.value.length;
    teacherIntroCharCount.textContent = length;
    if (length>50) {
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
    } else if (teacherIntro.length > 5000) {
      errors.push("선생님 소개글을 5,000자 이하로 입력해주세요.");
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
