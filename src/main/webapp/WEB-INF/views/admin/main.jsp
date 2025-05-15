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
<div class="content mr-5">
  <div class="container my-5 mr-5">
    <%@ include file="../common/breadcrumb.jsp" %>
  </div>
  <div class="container my-5 mr-5">
    <div class="my-5">
      <h1 class="h4 fw-bold">관리자 메인 페이지</h1>
    </div>
    <div class="row g-4">
      <div class="col-md-3">
        <a href="${cp}/admin/member/list" class="d-block p-3 bg-primary bg-opacity-10 rounded shadow-sm text-decoration-none">
          <i class="bi bi-people-fill text-primary fs-4 me-2"></i> <strong class="text-dark">회원 관리</strong>
        </a>
      </div>
      <div class="col-md-3">
        <a href="${cp}/admin/teacher/list" class="d-block p-3 bg-success bg-opacity-10 rounded shadow-sm text-decoration-none">
          <i class="bi bi-person-badge-fill text-success fs-4 me-2"></i> <strong class="text-dark">선생님 관리</strong>
        </a>
      </div>
      <div class="col-md-3">
        <a href="${cp}/admin/lecture/list" class="d-block p-3 bg-warning bg-opacity-10 rounded shadow-sm text-decoration-none">
          <i class="bi bi-easel2-fill text-warning fs-4 me-2"></i> <strong class="text-dark">강좌 관리</strong>
        </a>
      </div>
      <div class="col-md-3">
        <a href="${cp}/admin/chapter/list" class="d-block p-3 bg-info bg-opacity-10 rounded shadow-sm text-decoration-none">
          <i class="bi bi-collection-play-fill text-info fs-4 me-2"></i> <strong class="text-dark">강의 관리</strong>
        </a>
      </div>
      <div class="col-md-3">
        <a href="${cp}/admin/report/list/board" class="d-block p-3 bg-danger bg-opacity-10 rounded shadow-sm text-decoration-none">
          <i class="bi bi-shield-exclamation text-danger fs-4 me-2"></i> <strong class="text-dark">신고 관리</strong>
        </a>
      </div>
      <div class="col-md-3">
        <a href="${cp}/admin/board/manage" class="d-block p-3 bg-secondary bg-opacity-10 rounded shadow-sm text-decoration-none">
          <i class="bi bi-card-text text-secondary fs-4 me-2"></i> <strong class="text-dark">게시판 관리</strong>
        </a>
      </div>
      <div class="col-md-3">
        <a href="${cp}/admin/qna/list" class="d-block p-3 bg-dark bg-opacity-10 rounded shadow-sm text-decoration-none">
          <i class="bi bi-question-circle-fill text-dark fs-4 me-2"></i> <strong class="text-dark">Q & A</strong>
        </a>
      </div>
      <div class="col-md-3">
        <a href="${cp}/admin/sales/info" class="d-block p-3 bg-primary bg-opacity-10 rounded shadow-sm text-decoration-none">
          <i class="bi bi-bar-chart-fill text-primary fs-4 me-2"></i> <strong class="text-dark">매출 정보</strong>
        </a>
      </div>
    </div>


  </div>
</div>
</body>
</html>
