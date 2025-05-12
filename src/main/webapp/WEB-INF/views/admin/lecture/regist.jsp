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
<%@ include file="../../common/sidebarHeader.jsp" %>
<div class="content">
  <div class="container my-5">
    <%@ include file="../../common/breadcrumb.jsp"%>
  </div>

  <div class="container my-5">
    <div class="card shadow rounded">
      <div class="card-header bg-primary text-white">
        <h5 class="mb-0">강좌 등록</h5>
      </div>
      <div class="card-body">
        <form name="frmRegist" method="post" id="frmRegist" class="needs-validation"  enctype="multipart/form-data">
          <div class="mb-3">
            <label for="lectureTitle" class="form-label">강좌명</label>
            <input type="text" class="form-control" id="lectureTitle" name="lectureTitle"
                   placeholder="강좌명을 입력하세요." required
                   value="${lectureDTO.lectureTitle != null ? lectureDTO.lectureTitle : ''}">
          </div>

          <div class="mb-3">
            <label for="lectureTeacherName" class="form-label" >담당 선생님</label>
            <input type="hidden" class="form-control" id="lectureTeacherId" name="lectureTeacherId"
                   value="${lectureDTO.lectureTeacherId}" required>
            <div class="input-group">
              <input type="text" class="form-control" id="lectureTeacherName" name="lectureTeacherName"
                     value="${lectureDTO.lectureTeacherName}" placeholder="담당 선생님을 입력하세요." required disabled>
              <button type="button" class="btn btn-outline-primary" onclick="openTeacherSearch()">선생님 검색</button>
            </div>
          </div>

          <div class="mb-3">
            <label for="lectureAmount" class="form-label">강좌 가격</label>
            <input type="text" class="form-control" id="lectureAmount" name="lectureAmount"
                   placeholder="강좌 가격을 입력하세요."
                   value="${lectureDTO.lectureAmount}" required  maxlength="10" >
          </div>

          <div class="mb-3">
            <label for="file1" class="form-label">강좌 썸네일 이미지</label>
            <input type="file" class="form-control" id="file1" name="file1" accept="image/*" required>
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
    window.open('/admin/teacher/search','teacherSearch', 'width=600,height=500,scrollbars=yes,resizable=no');
  }

  function selectTeacher(id, name) {
    document.getElementById('lectureTeacherId').value = id;
    document.getElementById('lectureTeacherName').value = name+"("+id+")";

  }

  document.getElementById('lectureAmount').addEventListener('input', function (event) {
    const value = event.target.value;
    event.target.value = value.replace(/[^0-9]/g, '');
  });

</script>
</body>
</html>
