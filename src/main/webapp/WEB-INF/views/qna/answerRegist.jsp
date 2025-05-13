<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>QnA 답변 등록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/resources/js/textCounter.js"></script>
</head>
<body class="bg-light-subtle">
<%@ include file="../common/header.jsp" %>
<div class="content-nonside">
    <div class="container my-5">
        <%@ include file="../common/breadcrumb.jsp" %>
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
