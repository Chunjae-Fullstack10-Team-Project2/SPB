<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .error-icon {
            font-size: 7rem;
        }
    </style>
</head>
<body class="bg-light-subtle d-flex justify-content-center align-items-center" style="min-height: 90%;">
<%@ include file="../common/header.jsp" %>

<div class="content-nonside">
    <div class="container text-center mb-5">
        <div class="error-icon mb-3">
            <i class="bi bi-exclamation-triangle-fill text-danger"></i>
        </div>
        <h1 class="display-5 fw-bold">${heading}</h1>
        <p class="lead">${message}</p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary mt-4">홈으로 돌아가기</a>
    </div>
</div>
</body>
</html>
