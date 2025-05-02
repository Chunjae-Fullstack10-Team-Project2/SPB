<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%@ include file="../common/header.jsp" %>
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
                <a class="link-body-emphasis fw-semibold text-decoration-none" href="/qna/list">문의하기</a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">
                ${qnaDTO.qnaTitle}
            </li>
        </ol>
    </nav>
</div>
<div class="container mt-5 mb-5">
    <div class="card">
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

    <div class="card mt-3 mb-5">
        <c:if test="${not empty qnaDTO.qnaAContent}">
            <div class="card-header">
                <h4>A. ${qnaDTO.qnaTitle}</h4>
            </div>
            <div class="card-body">
                <div class="form-group">
                    <label for="qnaQContent">답변자</label>
                    <input type="text" class="form-control" id="qnaAMemberId" name="qnaAMemberId"
                           value="${qnaDTO.qnaAMemberId}" readonly>
                </div>
                <div class="form-group">
                    <label for="qnaQContent">답변일</label>
                    <fmt:formatDate var="qnaAnsweredAt" value="${qnaDTO.qnaAnsweredAt}" pattern="yyyy-MM-dd"/>
                    <input type="text" class="form-control" id="qnaAnsweredAt" name="qnaAnsweredAt"
                           value="${qnaAnsweredAt}" readonly>
                </div>
                <div class="form-group">
                    <label for="qnaQContent">답변 내용</label>
                    <textarea class="form-control" name="qnaAContent" id="qnaAContent" cols="50" rows="10"
                              readonly>${qnaDTO.qnaAContent}</textarea>
                </div>
            </div>
        </c:if>
        <c:if test="${empty qnaDTO.qnaAContent}">
            <div class="card-header">
                <h4>답변 내역이 없습니다.</h4>
            </div>
            <div class="card-body">
            </div>
        </c:if>
    </div>

    <div class="mt-3">
        <a href="/qna/list" class="btn btn-secondary">목록으로</a>

        <c:if test="${not empty sessionScope.memberGrade and (sessionScope.memberGrade == 0 or sessionScope.memberGrade == 13)}">
            <a href="/qna/regist/answer?qnaIdx=${qnaDTO.qnaIdx}" class="btn btn-primary">답변 등록</a>

            <form id="frmDelete" method="post" action="/qna/delete" style="display: inline;">
                <input type="hidden" name="qnaIdx" value="${qnaDTO.qnaIdx}"/>
                <button type="submit" class="btn btn-danger">문의 삭제</button>
            </form>
        </c:if>
    </div>
</div>

<script>
    <c:if test="${not empty param.message}">
    const message = "${param.message}";
    if (message === 'authorized') {
        alert("답변이 등록되었습니다.");
    } else if (message === 'unauthorized') {
        alert("답변 등록에 실패했습니다.");
    } else if (message === 'error') {
        alert("예외가 발생했습니다.");
    }
    </c:if>
</script>
</body>
</html>
