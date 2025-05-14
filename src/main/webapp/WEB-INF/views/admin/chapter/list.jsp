<%--
  Created by IntelliJ IDEA.
  User: sinjihye
  Date: 2025. 5. 11.
  Time: 22:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
  <title>강의 목록 - 관리자</title>
</head>
<body>
<%@ include file="../../common/sidebarHeader.jsp" %>
<div class="content">
  <div class="container">
    <%@ include file="../../common/breadcrumb.jsp" %>
  </div>
  <div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="h4 fw-bold mb-4">강좌 강의 목록</h2>
      <c:choose>
        <c:when test="${not empty lectureIdx}">
          <a href="regist?lectureIdx=${lectureIdx}" class="btn btn-primary"><i class="bi bi-clipboard-plus-fill"></i> 강의 추가</a>
        </c:when>
        <c:otherwise>
          <a href="regist" class="btn btn-primary"><i class="bi bi-clipboard-plus-fill"></i> 강의 추가</a>
        </c:otherwise>
      </c:choose>
    </div>
    <c:choose>
      <c:when test="${not empty chapters}">
        <table class="table table-hover text-center align-middle">
          <thead class="table-light">
          <tr>
            <th scope="col">#</th>
            <th scope="col">강좌명</th>
            <th scope="col">강의명</th>
            <th scope="col">강의 파일</th>
            <th scope="col">런타임</th>
            <th scope="col">상태</th>
            <th scope="col">관리</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${chapters}" var="chapter" varStatus="status">
            <tr id="chapterRow-${chapter.chapterIdx}">
              <td>${status.index + 1}</td>
              <td>${chapter.lectureTitle}</td>
              <td>${chapter.chapterName}</td>
              <td><a href="/upload/${chapter.chapterVideo}" target="_blank"><i class="bi bi-play-circle"></i></a></td>
              <td>${chapter.chapterRuntime}</td>
              <td>
                <c:choose>
                  <c:when test="${chapter.chapterState == 1}"><span class="badge bg-success">정상</span></c:when>
                  <c:otherwise><span class="badge bg-secondary">삭제됨</span></c:otherwise>
                </c:choose>
              </td>
              <td>
                <a href="modify?chapterIdx=${chapter.chapterIdx}" class="btn btn-sm btn-warning">
                  <i class="bi bi-pencil"></i> 수정
                </a>
                <button type="button" class="btn btn-sm btn-danger btnDeleteChapter"
                        data-chapter-idx="${chapter.chapterIdx}" data-lecture-idx="${chapter.chapterLectureIdx}">
                  <i class="bi bi-trash"></i> 삭제
                </button>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
        <div class="text-center">${paging}</div>
      </c:when>
      <c:otherwise>
        <div class="alert alert-warning" role="alert">
          등록된 강의가 없습니다.
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<script>
  $(document).on('click', '.btnDeleteChapter', function () {
    if (!confirm('정말 삭제하시겠습니까?')) return;

    const chapterIdx = $(this).data('chapter-idx');
    const lectureIdx = $(this).data('lecture-idx');

    $.ajax({
      url: '/admin/lecture/chapter/delete',
      method: 'POST',
      data: {
        chapterIdx: chapterIdx,
        chapterLectureIdx: lectureIdx
      },
      success: function (res) {
        if (res.success) {
          alert(res.message);
          $('#chapterRow-' + chapterIdx).remove();
        } else {
          alert(res.message);
        }
      },
      error: function () {
        alert('삭제 요청 중 오류가 발생했습니다.');
      }
    });
  });
</script>
</body>
</html>
