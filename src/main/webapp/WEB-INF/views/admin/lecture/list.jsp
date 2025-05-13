<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  Created by IntelliJ IDEA.
  User: sinjihye
  Date: 2025. 5. 7.
  Time: 13:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="cp" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%@ include file="../../common/sidebarHeader.jsp" %>
<div class="content">
  <div class="container my-5">
    <%@include file="../../common/breadcrumb.jsp"%>
  </div>

  <div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="h4 fw-bold">강좌 관리</h2>
      <a href="regist" class="btn btn-primary"><i class="bi bi-clipboard-plus-fill"></i> 강좌 추가</a>
    </div>

    <table class="table table-hover align-middle">
      <thead class="table-light text-center">
      <tr>
        <th scope="col">No</th>
        <th scope="col">썸네일</th>
        <th scope="col">제목</th>
        <th scope="col">소개</th>
        <th scope="col">선생님</th>
        <th scope="col">금액</th>
        <th scope="col">생성일</th>
        <th scope="col">관리</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="lecture" items="${lectures}" varStatus="status">
        <tr>
          <td>${status.index + 1}</td>
          <td>
            <img src="/upload/${lecture.lectureThumbnailImg}" alt="강좌 썸네일" style="width: 80px; height: auto; border-radius: 6px;"
            onerror="this.src='${cp}/resources/img/spb_single_logo.png';">
          </td>
          <td>${lecture.lectureTitle}</td>
          <td class="text-truncate" style="max-width: 200px;">${lecture.lectureDescription}</td>
          <td class="text-center">${lecture.lectureTeacherName}<br><span class="text-muted small">(${lecture.lectureTeacherId})</span></td>
          <td class="text-center"><fmt:formatNumber value="${lecture.lectureAmount}" type="number" />원</td>
          <td class="text-center"><fmt:formatDate value="${lecture.lectureCreatedAt}" pattern="yyyy-MM-dd" /></td>
          <td>
            <a href="modify?lectureIdx=${lecture.lectureIdx}" class="btn btn-sm btn-warning"><i class="bi bi-pencil"></i> 수정</a>
            <button type="button" class="btn btn-sm btn-danger btnDelete" data-lecture-idx="${lecture.lectureIdx}"><i class="bi bi-trash"></i> 삭제</button>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
  <div id="toastMessage" class="toast align-items-center text-bg-dark border-0" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="d-flex">
      <div class="toast-body" id="toastText">알림 메시지</div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
    </div>
  </div>
</div>
<script>
  document.querySelectorAll('.btnDelete').forEach(btn => {
    btn.addEventListener('click', function() {
      const lectureIdx = $(this).data('lecture-idx');
      const $row = $(this).closest('tr'); // 삭제할 <tr> 참조

      if (confirm('삭제하시겠습니까?')) {
        $.ajax({
          url: 'delete',
          type: 'POST',
          data: { lectureIdx: lectureIdx },
          success: function () {
            $row.remove();
            showToast('삭제되었습니다.');
          },
          error: function () {
            showToast('삭제 중 오류가 발생했습니다.', true);
          }
        });
      }
    })
  })

  function showToast(message, isError = false) {
    const toastEl = document.getElementById("toastMessage");
    const toastText = document.getElementById("toastText");
    toastText.innerText = message;
    toastEl.classList.remove("text-bg-success", "text-bg-danger");
    toastEl.classList.add(isError ? "text-bg-danger" : "text-bg-success");
    new bootstrap.Toast(toastEl).show();
  }
</script>
</body>
</html>
