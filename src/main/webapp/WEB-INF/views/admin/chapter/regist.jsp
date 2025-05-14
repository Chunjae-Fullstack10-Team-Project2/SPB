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
      <div class="preloader" style="display: none;">
        <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
          <span class="visually-hidden">강의 영상 업로드 중...</span>
        </div>
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
    document.querySelector(".preloader").style.display = "flex";
    xhr.open("POST", "/admin/chapter/regist");
    xhr.onload = function () {
      document.querySelector(".preloader").style.display = "none";
      try {
        const response = JSON.parse(xhr.responseText);
        if (xhr.status === 200) {
          alert("성공: " + response.message);
          window.location.href = "/admin/chapter/list";
        } else {
          alert("업로드 실패: " + response.message);
        }
      } catch (e) {
        alert("응답 처리 중 오류 발생: " + xhr.responseText);
      }
    };
    xhr.onerror = function () {
      document.querySelector(".preloader").style.display = "none";
      alert("네트워크 오류 발생");
    };

    xhr.send(formData);
  }
</script>
</body>
</html>
