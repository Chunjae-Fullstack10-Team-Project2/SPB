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
<html>
<head>
    <title>Title</title>
</head>
<body>
<%@ include file="../../common/fixedHeader.jsp" %>
<%@ include file="../../common/sidebar.jsp" %>
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
          강좌 목록
        </li>
      </ol>
    </nav>
  </div>

  <div class="container my-5">
    <h4 class="mb-4">강좌 목록</h4>

    <div class="table-responsive">
      <table class="table table-hover align-middle text-center">
        <thead class="table-dark">
        <tr>
          <th>번호</th>
          <th>강좌명</th>
          <th>선생님</th>
          <th>강의 수</th>
          <th>등록일</th>
          <th>관리</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="lecture" items="${lectures}" varStatus="i">
          <tr>
            <td>${lecture.lectureIdx}</td>
            <td class="text-start">${lecture.lectureTitle}</td>
            <td>${lecture.lectureTeacherName}</td>
            <td>${lecture.lectureChapterCount}</td>
            <td><fmt:formatDate value="${lecture.lectureCreatedAt}" pattern="yyyy-MM-dd"/></td>
            <td>
              <a href="/teacher/lecture?lectureIdx=${lecture.lectureIdx}" class="btn btn-sm btn-outline-primary">보기</a>
              <a href="#" class="btn btn-sm btn-outline-secondary">수정</a>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>


</div>
</body>
</html>
