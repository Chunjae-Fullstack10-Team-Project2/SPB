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
  <title>강의 수정</title>
  <style>
    .input-fixed-2 {
      flex: 0 0 10%;
      max-width: 85px;
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
        <h5 class="mb-0">강의 수정</h5>
      </div>
      <div class="card-body">
        <form name="frmRegist" id="frmRegist" method="post" class="needs-validation" novalidate enctype="multipart/form-data">
          <div class="mb-3">
            <label for="lectureTitle" class="form-label">강좌 정보</label>
            <div class="input-group" style="width: 100%">
                <input type="text" class="form-control input-fixed-2" id="chapterLectureIdx" name="chapterLectureIdx"
                       placeholder="강좌 번호" required
                       value="${chapterDTO.chapterLectureIdx != null ? chapterDTO.chapterLectureIdx : ''}"
                       readonly>
                <input type="text" class="form-control " id="lectureTitle" name="lectureTitle"
                       placeholder="강좌 이름" required
                       value="${chapterDTO.lectureTitle != null ? chapterDTO.lectureTitle : ''}" readonly>
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
    window.open('/admin/lecture/search','lectureSearch', 'width=600,height=500,scrollbars=yes,resizable=no');
  }

  function setLecture(lectureIdx, lectureTitle) {
    document.getElementById('chapterLectureIdx').value = lectureIdx;
    document.getElementById('lectureTitle').value = lectureTitle;
  }

  function uploadChapter() {
    const form = document.getElementById("frmRegist");
    const formData = new FormData(form);
    const xhr = new XMLHttpRequest();
    xhr.open("POST", "/admin/chapter/modify");
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
