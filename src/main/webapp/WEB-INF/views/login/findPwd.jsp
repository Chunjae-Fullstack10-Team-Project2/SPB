<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
    <%-- Bootstrap, Icons --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .form-container {
            max-width: 400px;
            margin: 100px auto;
            background: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body class="bg-light-subtle">
<%@ include file="../common/header.jsp" %>

<div class="form-container content-nonside">
    <h4 class="mb-4 text-center">비밀번호 찾기</h4>
    <form method="post" action="${pageContext.request.contextPath}/email/sendTempPassword">
        <div class="mb-3">
            <label for="memberEmail" class="form-label">이메일 주소</label>
            <input type="email" class="form-control" id="memberEmail" name="memberEmail" placeholder="이메일 입력" required>
        </div>
        <button type="submit" class="btn btn-primary w-100">임시 비밀번호 전송</button>
    </form>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success mt-4" role="alert">
                ${successMessage}
        </div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger mt-4" role="alert">
                ${errorMessage}
        </div>
    </c:if>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
