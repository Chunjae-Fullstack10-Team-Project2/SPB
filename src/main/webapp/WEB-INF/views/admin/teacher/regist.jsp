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
          선생님 등록
        </li>
      </ol>
    </nav>
  </div>

  <div class="container my-5">

    <div class="card shadow rounded">
      <div class="card-header bg-primary text-white">
        <h5 class="mb-0">선생님 등록</h5>
      </div>
      <div class="card-body">
        <form name="frmRegist" method="post" class="needs-validation" novalidate enctype="multipart/form-data">
          <div class="mb-3">
            <label for="teacherId" class="form-label">선생님 아이디</label>
            <input type="text" class="form-control" id="teacherId" name="teacherId"
                   placeholder="선생님 아이디를 입력하세요." required
                   value="${memberDTO.memberId != null ? memberDTO.memberId : ''}">
          </div>

          <div class="mb-3">
            <label for="teacherName" class="form-label">선생님 성함</label>
            <input type="text" class="form-control" id="teacherName" name="teacherName"
                   placeholder="선생님 성함을 입력하세요."
                   value="${memberDTO.memberName}">
          </div>

          <div class="mb-3">
            <label for="teacherSubject" class="form-label">선생님 담당 과목</label>
            <input type="text" class="form-control" id="teacherSubject" name="teacherSubject"
                   placeholder="선생님 담당 과목을 입력하세요."
                   value="">
          </div>

          <div class="mb-3">
            <label for="file1" class="form-label">선생님 이미지</label>
            <input type="file" class="form-control" id="file1" name="file1" accept="image/*">
          </div>

          <div class="mb-3">
            <label for="teacherIntro" class="form-label">선생님 소개</label>
            <textarea class="form-control" id="teacherIntro" name="teacherIntro" rows="10"
                      placeholder="선생님 소개를 입력하세요." style="resize: none;"
                      required></textarea>
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
</body>
</html>
