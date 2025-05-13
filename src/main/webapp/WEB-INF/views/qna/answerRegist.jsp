<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>QnA 답변 등록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/resources/js/textCounter.js"></script>
</head>
<body>
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
                    <a class="link-body-emphasis fw-semibold text-decoration-none" href="/qna/list">1:1 문의</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    답변하기
                </li>
            </ol>
        </nav>
    </div>
    <div class="container my-5">
        <div class="card mb-5">
            <div class="card-header">
                <h4>Q. ${qnaDTO.qnaTitle}</h4>
            </div>
            <div class="card-body">
                <%--      <form id="frmDelete" method="post" action="/qna/delete">--%>
                <%--        <input type="hidden" name="idx" value="${qnaDTO.qnaIdx}">--%>
                <%--      </form>--%>
                <input type="hidden" id="idx" value="${qnaDTO.qnaIdx}">
                <div class="form-group">
                    <label for="qnaQMemberId">작성자</label>
                    <input type="text" class="form-control" id="qnaQMemberId" name="qnaQMemberId"
                           value="${qnaDTO.qnaQMemberId}" readonly>
                </div>
                <div class="form-group">
                    <label for="qnaCreatedAt">등록일</label>
                    <fmt:formatDate var="qnaCreatedAt" value="${qnaDTO.qnaCreatedAt}" pattern="yyyy-MM-dd"/>
                    <input type="text" class="form-control" id="qnaCreatedAt" name="qnaCreatedAt"
                           value="${qnaCreatedAt}" readonly>
                </div>
                <div class="form-group">
                    <label for="qnaQContent">질문 내용</label>
                    <textarea class="form-control" name="qnaQContent" id="qnaQContent" cols="50" rows="10"
                              readonly>${qnaDTO.qnaQContent}</textarea>
                </div>
            </div>
        </div>

        <div class="card shadow rounded">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">답변 등록</h5>
            </div>
            <div class="card-body">
                <form name="frmRegist" method="post" class="needs-validation" novalidate>
                    <div class="mb-3">
                        <label for="qnaAMemberId" class="form-label">작성자</label>
                        <input type="text" class="form-control" id="qnaAMemberId" name="qnaAMemberId"
                               value="${qnaDTO.qnaAMemberId}" readonly>
                    </div>

                    <div class="mb-3">
                        <label for="qnaAContent" class="form-label">내용</label>
                        <textarea class="form-control char-limit" id="qnaAContent" name="qnaAContent" rows="10"
                                  data-maxlength="19000" data-target="#qnaACount"
                                  placeholder="답변 내용을 입력하세요." style="resize: none;" required></textarea>
                    </div>
                    <div class="text-end small text-muted mt-1 mb-3">
                        <span id="qnaACount">0</span> / 19000
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <a href="/qna/view?qnaIdx=${qnaDTO.qnaIdx}" class="btn btn-outline-secondary">취소</a>
                        <input type="submit" class="btn btn-primary" id="btnSubmit" name="btnSubmit" value="등록">
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
