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
  <title>강의 등록</title>
  <style>
    .input-fixed-2 {
      flex: 0 0 10%;
      max-width: 85px;
    }
    .preloader {
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background-color: rgba(255, 255, 255, 0.8);
      display: flex;
      justify-content: center;
      align-items: center;
      z-index: 9999;
    }
  </style>
</head>
<body>
<%@ include file="../../common/sidebarHeader.jsp" %>
<div class="content">
  <div class="container my-5">
    <%@ include file="../../common/breadcrumb.jsp" %>
  </div>

  <div class="container my-5">
    <div class="card shadow rounded">
      <div class="card-header bg-primary text-white">
        <h5 class="mb-0">강의 등록</h5>
      </div>
      <div class="card-body">
        <form name="frmRegist" method="post" action="/admin/chapter/regist"
              id="frmRegist" novalidate class="needs-validation" enctype="multipart/form-data">
          <input type="hidden" id="chapterLectureIdx" name="chapterLectureIdx"
                 value="${lectureDTO.lectureIdx != null ? lectureDTO.lectureIdx : '0'}">

          <div class="mb-3">
            <label for="lectureTitle" class="form-label">강좌 정보</label>
            <div class="input-group" style="width: 100%">
                <input type="text" class="form-control input-fixed-2" id="chapterLectureIdxVisible" name="chapterLectureIdxVisible"
                       placeholder="강좌 번호" required
                       value="${lectureDTO.lectureIdx != null ? lectureDTO.lectureIdx : ''}"
                       readonly>
                <input type="text" class="form-control" id="lectureTitle" name="lectureTitle"
                       placeholder="강좌 이름" required
                       value="${lectureDTO.lectureTitle != null ? lectureDTO.lectureTitle : ''}" readonly>
              <button type="button" class="btn btn-outline-primary" onclick="openLectureSearch()">강좌 검색</button>
            </div>
            <div class="invalid-feedback">강좌를 선택해주세요.</div>
          </div>

          <div class="mb-3">
            <label for="chapterName" class="form-label">강의명</label>
            <input type="text" class="form-control" id="chapterName" name="chapterName"
                   value="${chapterDTO.chapterName}" placeholder="강의명을 입력하세요." required maxlength="30">
            <div class="d-flex justify-content-between">
              <div class="invalid-feedback">강의명을 입력해주세요.</div>
              <div class="form-text text-end w-100" id="chapterNameCharCountWrapper"><span id="chapterNameCharCount">0</span> / 30자</div>
            </div>
          </div>

          <div class="mb-3">
            <label for="file1" class="form-label">강의 동영상</label>
            <input type="file" class="form-control" id="file1" name="file1" accept="video/*" required>
            <div class="form-text invalid-feedback">강의 동영상은 필수입니다.(100MB 이하의 동영상)</div>
          </div>

          <div class="d-flex justify-content-end gap-2">
            <input type="reset" id="btnCancel" class="btn btn-outline-secondary" value="취소">
            <input type="button" class="btn btn-primary" onclick="uploadChapter()" value="등록">
          </div>

          <div class="progress" style="margin-top: 30px;display: none;">
            <div id="progressBar" class="progress-bar" style="width: 0%">0%</div>
          </div>
        </form>
      </div>
      <div class="preloader" style="display: none;">
        <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
          <span class="visually-hidden">강의 영상 업로드 중...</span>
        </div>
      </div>
    </div>
  </div>

</div>
<jsp:include page="/WEB-INF/views/common/toast.jsp" />
<script src="${pageContext.request.contextPath}/resources/js/bindCharCount.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/toast.js"></script>
<script>
  document.getElementById('btnCancel').addEventListener('click', ()=> {
    history.back();
  })
  bindCharCount(
          document.getElementById('chapterName'),
          document.getElementById('chapterNameCharCount'),
          document.getElementById('chapterNameCharCountWrapper'),
          30
  );
  function openLectureSearch() {
    window.open('/admin/lecture/search','lectureSearch', 'width=600,height=500,scrollbars=yes,resizable=no');
  }

  function setLecture(lectureIdx, lectureTitle) {
    document.getElementById('chapterLectureIdx').value = lectureIdx;
    document.getElementById('chapterLectureIdxVisible').value = lectureIdx;
    document.getElementById('lectureTitle').value = lectureTitle;
  }

  function uploadChapter() {
    const form = document.getElementById("frmRegist");
    const fileInput = document.getElementById('file1');
    const maxFileSize = 100 * 1024 * 1024; // 100MB
    const lectureIdx = document.getElementById('chapterLectureIdx').value;
    let isValid = true;
    if (!lectureIdx || lectureIdx === "0") {
      document.getElementById('lectureTitle').classList.add('is-invalid');
      isValid = false;
      return;
    } else {
      document.getElementById('lectureTitle').classList.remove('is-invalid');
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

    if(!form.checkValidity() || !isValid) {
      form.classList.add("was-validated");
      form.reportValidity();
      return;
    }

    const formData = new FormData(form);
    const xhr = new XMLHttpRequest();
    document.querySelector(".preloader").style.display = "flex";
    xhr.open("POST", "/admin/chapter/regist");
    xhr.onload = function () {
      document.querySelector(".preloader").style.display = "none";
      try {
        const response = JSON.parse(xhr.responseText);
        if (xhr.status === 200) {
          showToast("업로드가 완료되었습니다.", true);
          window.location.href = "/admin/chapter/list";
        } else {
          showToast("업로드에 실패하였습니다.", true);
        }
      } catch (e) {
        showToast("응답 처리 중 오류 발생하였습니다. " + xhr.responseText, true);
      }
    };
    xhr.onerror = function () {
      document.querySelector(".preloader").style.display = "none";
      showToast("네트워크 오류가 발생하였습니다.", true);
    };

    xhr.send(formData);
  }
</script>
</body>
</html>
