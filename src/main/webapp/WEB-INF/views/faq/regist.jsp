<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>문의사항 등록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/resources/js/textCounter.js"></script>

</head>
<body class="bg-light-subtle">
<%@ include file="../common/header.jsp" %>
<div class="content-nonside">

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
                    <a class="link-body-emphasis fw-semibold text-decoration-none" href="/faq/list">자주 묻는 질문</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    등록
                </li>
            </ol>
        </nav>
    </div>

    <div class="container my-5">
        <div class="card shadow rounded">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">자주 묻는 질문 등록</h5>
            </div>
            <div class="card-body">
                <form name="frmRegist" method="post" class="needs-validation" novalidate>
                    <div class="mb-3">
                        <label for="faqQuestion" class="form-label">질문</label>
                        <input type="text" class="form-control char-limit" id="faqQuestion" name="faqQuestion" maxlength="100"
                               placeholder="질문을 입력하세요."
                               data-maxlength="100"
                               data-target="#faqQCount"
                               value="<c:out value='${faqDTO.faqQuestion}' />"
                               required>
                    </div>
                    <div class="text-end small text-muted mt-1 mb-3">
                        <span id="faqQCount">0</span> / 100
                    </div>

                    <div class="mb-3">
                        <label for="faqAnswer" class="form-label">답변</label>

                        <textarea class="form-control char-limit"
                                  id="faqAnswer"
                                  name="faqAnswer"
                                  rows="10"
                                  data-maxlength="15000"
                                  data-target="#faqAnswerCount"
                                  placeholder="답변을 입력해주세요."
                                  style="resize: none;" required><c:out
                                    value="${faqDTO.faqAnswer}" /></textarea>
                    </div>
                    <div class="text-end small text-muted mt-1 mb-3">
                        <span id="faqAnswerCount">0</span> / 15,000
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
<script>
    <c:if test="${not empty message}">
    alert("${message}");
    </c:if>
</script>
</body>
</html>
