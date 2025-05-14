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
    <title>강좌 목록</title>
  <style>
    td {
      font-size: 13.5px;
    }
  </style>
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
        <th scope="col">상태</th>
        <th scope="col">관리</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="lecture" items="${lectures}" varStatus="status">
        <tr class="clickable-row" id="lectureRow-${lecture.lectureIdx}" data-href="/admin/chapter/list?lectureIdx=${lecture.lectureIdx}">
          <td>${status.index + 1}</td>
          <td>
            <img src="/upload/${lecture.lectureThumbnailImg}" alt="강좌 썸네일" style="width: 50px; height: auto; border-radius: 6px;"
            onerror="this.src='${cp}/resources/img/spb_single_logo.png';">
          </td>
          <td>${lecture.lectureTitle}</td>
          <td class="text-truncate" style="max-width: 200px;">${lecture.lectureDescription}</td>
          <td class="text-center">${lecture.lectureTeacherName}<br><span class="text-muted small">(${lecture.lectureTeacherId})</span></td>
          <td><fmt:formatNumber value="${lecture.lectureAmount}" type="number" />원</td>
          <td class="text-center">${lecture.lectureCreatedAt}</td>
          <td class="text-center">
            <c:choose>
              <c:when test="${lecture.lectureState == 1}"><span class="badge bg-success">정상</span></c:when>
              <c:otherwise><span class="badge bg-secondary">삭제됨</span></c:otherwise>
            </c:choose>
          </td>
          <td class="text-center">
            <c:choose>
              <c:when test="${lecture.lectureState == 1}">
                <a href="modify?lectureIdx=${lecture.lectureIdx}" class="btn btn-sm btn-warning"><i class="bi bi-pencil"></i> 수정</a>
                <button type="button" class="btn btn-sm btn-danger btnDelete" data-lecture-idx="${lecture.lectureIdx}"><i class="bi bi-trash"></i> 삭제</button>
              </c:when>
              <c:otherwise>
                <button type="button" class="btn btn-sm btn-danger btnRestoreLecture"
                        data-lecture-idx="${lecture.lectureIdx}">
                  <i class="bi bi-arrow-counterclockwise"></i> 복구
                </button>
              </c:otherwise>
            </c:choose>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</div>
<jsp:include page="/WEB-INF/views/common/toast.jsp" />
<script src="${pageContext.request.contextPath}/resources/js/toast.js"></script>
<script>

  const rows = document.querySelectorAll('.clickable-row');
  rows.forEach(row => {
    row.addEventListener('mouseover', function() {
      row.style.cursor = "pointer";
    })
    row.addEventListener('click', function (e) {
      if (e.target.closest('.btn')) return;
      const url = this.dataset.href;
      if (url) window.location.href = url;
    });
  });

  $(document).on('click', '.btnDelete', function(e) {
    e.preventDefault();
    e.stopPropagation();
    const lectureIdx = $(this).data('lecture-idx');
    if (confirm('삭제하시겠습니까?')) {
      $.ajax({
        url: 'delete',
        type: 'POST',
        data: {lectureIdx: lectureIdx},
        success: function () {
          showToast('삭제되었습니다.');
          const row = $('#lectureRow-' + lectureIdx);
          const badgeCell = row.find('td').eq(7);
          const controlCell = row.find('td').eq(8);
          badgeCell.html('<span class="badge bg-secondary">삭제됨</span>');
          controlCell.html('<button type="button" class="btn btn-sm btn-danger btnRestoreLecture" data-lecture-idx="' +
                  lectureIdx +
                  '"><i class="bi bi-arrow-counterclockwise"></i> 복구</button>');
        },
        error: function () {
          showToast('삭제 중 오류가 발생했습니다.', true);
        }
      });
    }
  });
  $(document).on('click', '.btnRestoreLecture', function (e) {
    e.preventDefault();
    e.stopPropagation();
    const lectureIdx = $(this).data('lecture-idx');

    if (confirm('복구하시겠습니까?')) {
      $.ajax({
        url: 'restore',
        type: 'POST',
        data: { lectureIdx: lectureIdx },
        success: function () {
          showToast('복구되었습니다.');
          const row = $('#lectureRow-' + lectureIdx);
          const badgeCell = row.find('td').eq(7);
          const controlCell = row.find('td').eq(8);
          badgeCell.html('<span class="badge bg-success">정상</span>');
          controlCell.html('<a href="modify?lectureIdx=' + lectureIdx +
                  '" class="btn btn-sm btn-warning"><i class="bi bi-pencil"></i> 수정</a>&nbsp;<button type="button" class="btn btn-sm btn-danger btnDelete" data-lecture-idx="' +
                  lectureIdx + '"><i class="bi bi-trash"></i> 삭제</button>');
        },
        error: function () {
          showToast('삭제 중 오류가 발생했습니다.', true);
        }
      });
    }
  });
</script>
</body>
</html>
