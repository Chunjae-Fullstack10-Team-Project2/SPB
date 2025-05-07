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
  <title>강좌 개설</title>
</head>
<body>
<%@ include file="../../common/header.jsp" %>
<%@ include file="../../common/sidebarHeader.jsp" %>
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
          강좌 등록
        </li>
      </ol>
    </nav>
  </div>

  <div class="container my-5">

    <div class="card shadow rounded">
      <div class="card-header bg-primary text-white">
        <h5 class="mb-0">강좌 등록</h5>
      </div>
      <div class="card-body">
        <form name="frmRegist" method="post" class="needs-validation" novalidate enctype="multipart/form-data">
          <div class="mb-3">
            <label for="lectureTitle" class="form-label">강좌명</label>
            <input type="text" class="form-control" id="lectureTitle" name="lectureTitle"
                   placeholder="강좌명을 입력하세요." required
                   value="${lectureDTO.lectureTitle != null ? lectureDTO.lectureTitle : ''}">
          </div>

          <div class="mb-3">
            <label for="lectureTeacherName" class="form-label">담당 선생님</label>
            <input type="hidden" class="form-control" id="lectureTeacherId" name="lectureTeacherId"
                   value="${lectureDTO.lectureTeacherId}">
            <div class="input-group">
              <input type="text" class="form-control" id="lectureTeacherName" name="lectureTeacherName"
                     value="${lectureDTO.lectureTeacherName}" placeholder="담당 선생님을 입력하세요." required>
              <button type="button" class="btn btn-outline-primary" onclick="openTeacherSearch()">선생님 검색</button>
            </div>
          </div>

          <div class="mb-3">
            <label for="lectureTeacherId" class="form-label">강좌 가격</label>
            <input type="text" class="form-control" id="lectureAmount" name="lectureAmount"
                   placeholder="강좌 가격을 입력하세요."
                   value="${lectureDTO.lectureAmount}">
          </div>

          <div class="mb-3">
            <label for="file1" class="form-label">강좌 썸네일 이미지</label>
            <input type="file" class="form-control" id="file1" name="file1" accept="image/*">
          </div>

          <div class="mb-3">
            <label for="lectureDescription" class="form-label">강좌 설명</label>
            <textarea class="form-control" id="lectureDescription" name="lectureDescription" rows="10"
                      placeholder="강좌 설명을 입력하세요." style="resize: none;"
                      required>${lectureDTO.lectureDescription != null ? lectureDTO.lectureDescription : ''}</textarea>
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
  function openTeacherSearch() {
    window.open('/admin/teacher/searchPopup','teacherSearch', 'width=600,height=800,scrollbars=yes,resizable=no');
  }

  function selectTeacher(id, name) {
    document.getElementById('lectureTeacherId').value = id;
    document.getElementById('lectureTeacherName').value = name+"("+id+")";
  }
</script>
</body>
</html>
