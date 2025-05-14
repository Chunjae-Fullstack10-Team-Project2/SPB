<%--
  Created by IntelliJ IDEA.
  User: sinjihye
  Date: 2025. 5. 11.
  Time: 02:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>강좌 수정</title>
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
        <h5 class="mb-0">강좌 수정</h5>
      </div>
      <div class="card-body">
        <form name="frmRegist" method="post" action="/admin/lecture/modify" id="frmRegist"
              class="needs-validation" novalidate enctype="multipart/form-data">
          <c:if test="${not empty errorMessages}">
            <c:forEach items="${errorMessages}" var="errorMessage">
              <div class="alert alert-danger alert-dismissible fade show" role="alert">
                  ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
              </div>
            </c:forEach>
          </c:if>
          <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                ${errorMessage}
            </div>
          </c:if>

          <input type="hidden" name="lectureIdx" value="${lectureDTO.lectureIdx}"/>

          <div class="mb-3">
            <label for="lectureTitle" class="form-label">강좌명</label>
            <input type="text" class="form-control" id="lectureTitle" name="lectureTitle"
                   placeholder="강좌명을 입력하세요." required
                   value="${lectureDTO.lectureTitle != null ? lectureDTO.lectureTitle : ''}">
            <div class="form-text text-end" id="lectureTitleCharCountWrapper"><span id="lectureTitleCharCount">0</span> / 50자</div>
            <div class="invalid-feedback">강좌명을 입력해주세요.</div>
          </div>

          <div class="mb-3">
            <label for="lectureTeacherName" class="form-label">담당 선생님</label>
            <input type="hidden" class="form-control" id="lectureTeacherId" name="lectureTeacherId"
                   value="${lectureDTO.lectureTeacherId}" required>
            <div class="input-group">
              <input type="text" class="form-control" id="lectureTeacherName" name="lectureTeacherName"
                     value="${lectureDTO.lectureTeacherName}" placeholder="담당 선생님을 입력하세요." required disabled>
              <button type="button" class="btn btn-outline-primary" onclick="openTeacherSearch()">선생님 검색</button>
            </div>
            <div class="invalid-feedback">선생님을 입력해주세요.</div>
          </div>

          <div class="mb-3">
            <label for="lectureAmount" class="form-label">강좌 가격</label>
            <input type="text" class="form-control" id="lectureAmount" name="lectureAmount"
                   placeholder="강좌 가격을 입력하세요. (최대 5,000,000원)"
                   value="${lectureDTO.lectureAmount}" required maxlength="10">
            <div class="invalid-feedback">강좌 가격을 입력해주세요.</div>
          </div>

          <div class="mb-3">
            <label for="file1" class="form-label">강좌 썸네일 이미지</label>
            <input type="file" class="form-control" id="file1" name="file1" accept="image/*">
            <input type="hidden" name="lectureThumbnailImg" value="${lectureDTO.lectureThumbnailImg}"/>
          </div>

          <div class="mb-3">
            <label for="lectureDescription" class="form-label">강좌 설명</label>
            <textarea class="form-control" id="lectureDescription" name="lectureDescription" rows="3"
                      placeholder="강좌 설명을 입력하세요." style="resize: none;"
                      maxlength="100" required>${lectureDTO.lectureDescription != null ? lectureDTO.lectureDescription : ''}</textarea>
            <div class="d-flex justify-content-between">
              <div class="form-text invalid-feedback">강좌 설명을 입력해주세요.</div>
              <div class="form-text text-end w-100" id="lectureDescriptionCharCountWrapper"><span id="lectureDescriptionCharCount">0</span> / 100자</div>
            </div>
          </div>

          <div class="d-flex justify-content-end gap-2">
            <a href="/admin/lecture/list" class="btn btn-outline-secondary">취소</a>
            <button type="submit" class="btn btn-primary" id="btnSubmit">등록</button>
          </div>
        </form>
      </div>
    </div>
  </div>

</div>
<script src="${pageContext.request.contextPath}/resources/js/bindCharCount.js"></script>
<script>

  bindCharCount(
          document.getElementById('lectureTitle'),
          document.getElementById('lectureTitleCharCount'),
          document.getElementById('lectureTitleCharCountWrapper'),
          50
  );

  bindCharCount(
          document.getElementById('lectureDescription'),
          document.getElementById('lectureDescriptionCharCount'),
          document.getElementById('lectureDescriptionCharCountWrapper'),
          450
  );

  function openTeacherSearch() {
    window.open('/admin/teacher/search','teacherSearch', 'width=600,height=500,scrollbars=yes,resizable=no');
  }

  function selectTeacher(id, name) {
    document.getElementById('lectureTeacherId').value = id;
    document.getElementById('lectureTeacherName').value = name+"("+id+")";
  }

  const amountInput = document.getElementById('lectureAmount');
  amountInput.addEventListener('input', function (e) {
    const value = e.target.value.replace(/,/g, '');
    if (!isNaN(value)) {
      const formatted = Number(value).toLocaleString('ko-KR');
      e.target.value = formatted;
    } else {
      e.target.value = value.replace(/\D/g, '').replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
  });

  document.getElementById('btnSubmit').addEventListener('click', function (e) {
    e.preventDefault();
    const form = document.forms['frmRegist'];

    const fileInput = document.getElementById('file1');
    const maxFileSize = 10 * 1024 * 1024; // 10MB
    const teacherIdInput = document.getElementById('lectureTeacherId');
    const teacherNameInput = document.getElementById('lectureTeacherName');
    let isValid = true;

    if (!teacherIdInput.value) {
      teacherNameInput.classList.add('is-invalid');
      const feedback = teacherNameInput.closest('.mb-3')?.querySelector('.invalid-feedback');
      if (feedback) feedback.innerText = '선생님을 선택해주세요.';
      teacherNameInput.focus();
      isValid = false;
    } else {
      teacherNameInput.classList.remove('is-invalid');
    }

    const rawAmount = amountInput.value.replace(/,/g, '');
    amountInput.value = rawAmount;
    if (isNaN(rawAmount) || Number(rawAmount) > 5000000) {
      alert("강좌 가격은 숫자만 입력하며, 최대 5,000,000원까지 가능합니다.");
      amountInput.focus();
      amountInput.classList.add('is-invalid');
      amountInput.nextElementSibling.innerText = '강좌 가격은 5,000,000원 이하로 입력해주세요.';
      form.classList.add('was-validated');
      return false;
    }

    // 파일 사이즈 처리
    if (fileInput.files.length > 0 && fileInput.files[0].size > maxFileSize) {
      fileInput.classList.add('is-invalid');
      const feedback = fileInput.closest('.form-group')?.querySelector('.invalid-feedback');
      if (feedback) feedback.innerText = '파일은 10MB 이하만 업로드할 수 있습니다.';
      fileInput.focus();
      isValid = false;
    } else {
      fileInput.classList.remove('is-invalid');
    }

    // 부트스트랩 검증 표시
    form.classList.add('was-validated');

    if (isValid && form.checkValidity()) {
      form.submit();
    }
  });
</script>
</body>
</html>
