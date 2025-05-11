<%--
  Created by IntelliJ IDEA.
  User: sinjihye
  Date: 2025. 5. 10.
  Time: 12:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>관리자 메인 페이지</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8f9fa;
    }

    .btn-admin {
      width: 100%;
      height: 140px;
      font-size: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      text-decoration: none;
      border: 2px solid #dee2e6;
      border-radius: 12px;
      background-color: white;
      color: #333;
      transition: all 0.2s;
    }

    .btn-admin:hover {
      background-color: #e9ecef;
      text-decoration: none;
      transform: translateY(-2px);
    }

    .btn-admin i {
      font-size: 40px;
    }
  </style>
</head>
<body>
<%@ include file="../common/sidebarHeader.jsp" %>
<div class="content">
  <%@ include file="../common/breadcrumb.jsp" %>
  <div class="container my-5">
    <div class="my-5">
      <h1 class="h4 fw-bold">관리자 메인 페이지</h1>
    </div>
    <div class="row g-4">
      <div class="col-md-6">
        <a href="${cp}/admin/member/list" class="btn-admin">
          <i class="bi bi-person-lines-fill"></i> 회원 관리
        </a>
      </div>
      <div class="col-md-6">
        <a href="${cp}/admin/teacher/list" class="btn-admin">
          <i class="bi bi-person-workspace"></i> 선생님 관리
        </a>
      </div>
      <div class="col-md-6">
        <a href="${cp}/admin/lecture/list" class="btn-admin">
          <i class="bi bi-book"></i> 강좌 관리
        </a>
      </div>
      <div class="col-md-6">
        <a href="${cp}/admin/chapter/list" class="btn-admin">
          <i class="bi bi-journals"></i> 강의 관리
        </a>
      </div>
      <div class="col-md-6">
        <a href="${cp}/admin/report/list" class="btn-admin">
          <i class="bi bi-flag-fill"></i> 신고 관리
        </a>
      </div>
      <div class="col-md-6">
        <a href="${cp}/admin/board/manage" class="btn-admin">
          <i class="bi bi-layout-text-window"></i> 게시판 관리
        </a>
      </div>
   </div>
  </div>
</div>
</body>
</html>
