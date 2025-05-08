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
  </style>
</head>
<body>
<%@ include file="../../../common/fixedHeader.jsp" %>
<%@ include file="../../../common/sidebar.jsp" %>
<div class="content" style="margin-left: 280px; margin-top: 100px;">

  <svg xmlns="http://www.w3.org/2000/svg" class="d-none">
    <symbol id="house-door-fill" viewBox="0 0 16 16">
      <path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5z"/>
    </symbol>
  </svg>

  <div class="container my-5">
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb breadcrumb-chevron p-3 bg-body-tertiary rounded-3">
        <li class="breadcrumb-item">
          <a class="link-body-emphasis" href="/">
            <svg class="bi" width="16" height="16" aria-hidden="true">
              <use xlink:href="#house-door-fill"></use>
            </svg>
            <span class="visually-hidden">Home</span>
          </a>
        </li>
        <li class="breadcrumb-item">
          <a class="link-body-emphasis fw-semibold text-decoration-none" href="/admin/">관리자 페이지</a>
        </li>
        <li class="breadcrumb-item active" aria-current="page">
          강의 등록
        </li>
      </ol>
    </nav>
  </div>

  <div class="container my-5">

    <div class="card shadow rounded">
      <div class="card-header bg-primary text-white">
        <h5 class="mb-0">강의 등록</h5>
      </div>
      <div class="card-body">
        <form name="frmRegist" id="frmRegist" method="post" class="needs-validation" novalidate enctype="multipart/form-data">
          <div class="mb-3">
            <label for="lectureTitle" class="form-label">강좌 정보</label>
            <div class="input-group" style="width: 100%">
                <input type="text" class="form-control input-fixed-2" id="chapterLectureIdx" name="chapterLectureIdx"
                       placeholder="강좌 번호" required
                       value="${lectureDTO.lectureIdx != null ? lectureDTO.lectureIdx : ''}"
                       readonly>
                <input type="text" class="form-control " id="lectureTitle" name="lectureTitle"
                       placeholder="강좌 이름" required
                       value="${lectureDTO.lectureTitle != null ? lectureDTO.lectureTitle : ''}" readonly>
              <button type="button" class="btn btn-outline-primary" onclick="openLectureSearch()">강좌 검색</button>
            </div>
          </div>

          <div class="mb-3">
            <label for="chapterName" class="form-label">강의명</label>
            <input type="text" class="form-control" id="chapterName" name="chapterName"
                   value="${chapterDTO.chapterName}" placeholder="강의명을 입력하세요.">
          </div>

          <div class="mb-3">
            <label for="file1" class="form-label">강의 동영상</label>
            <input type="file" class="form-control" id="file1" name="file1" accept="video/*">
          </div>

          <div class="d-flex justify-content-end gap-2">
            <input type="reset" class="btn btn-outline-secondary" value="취소">
            <input type="button" class="btn btn-primary" onclick="uploadChapter()" value="등록">
          </div>
          <div class="progress" style="margin-top: 30px;display: none;">
            <div id="progressBar" class="progress-bar" style="width: 0%">0%</div>
          </div>
        </form>
      </div>
    </div>
  </div>

</div>
<script>

  function openLectureSearch() {
    window.open('/admin/lecture/searchPopup','lectureSearch', 'width=600,height=500,scrollbars=yes,resizable=no');
  }

  function setLecture(lectureIdx, lectureTitle) {
    document.getElementById('chapterLectureIdx').value = lectureIdx;
    document.getElementById('lectureTitle').value = lectureTitle;
  }

  function uploadChapter() {
    const form = document.getElementById("frmRegist");
    const formData = new FormData(form);
    const xhr = new XMLHttpRequest();
    xhr.open("POST", "/admin/lecture/chapter/regist");
    xhr.upload.onprogress = function(event) {
      if (event.lengthComputable) {
        const progress = document.querySelector('.progress');
                progress.style = "display: block";
                progress.style = "margin-top: 30px";
        const percent = Math.round((event.loaded / event.total) * 100);
        document.getElementById('progressText').innerText = `${percent}% 업로드 중...`;
        const progressBar = document.getElementById("progressBar");
        progressBar.style.width = percent + "%";
        progressBar.innerText = percent + "%";
      }
    };

    xhr.onload = function () {
      if (xhr.status === 200) {
        const response = JSON.parse(xhr.responseText);
        alert("성공: " + response.message);
      } else {
        alert("업로드 실패: " + xhr.responseText);
      }
    };
    xhr.onerror = function () {
      alert("네트워크 오류 발생");
    };

    xhr.send(formData);
  }
</script>
</body>
</html>
