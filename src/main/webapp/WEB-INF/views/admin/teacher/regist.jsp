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
          <div class="mb-3">
            <label for="teacherId" class="form-label">선생님 아이디</label>
            <input type="text" class="form-control" id="teacherId" name="teacherId"
                   placeholder="선생님 아이디를 입력하세요." required
                   value="${memberDTO.memberId != null ? memberDTO.memberId : ''}" readonly>
          </div>

          <div class="mb-3">
            <label for="teacherName" class="form-label">선생님 성함</label>
            <input type="text" class="form-control" id="teacherName" name="teacherName"
                   placeholder="선생님 성함을 입력하세요."
                   value="${memberDTO.memberName}" readonly>
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
