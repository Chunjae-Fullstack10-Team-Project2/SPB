<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <title>Title</title>
</head>
<body class="bg-light-subtle">
<%@ include file="../common/header.jsp" %>
<div class="content-nonside">
    <div class="container my-5">
        <%@ include file="../common/breadcrumb.jsp" %>
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
                <a href="/qna/regist/answer?qnaIdx=${qnaDTO.qnaIdx}" class="btn btn-primary">답변하기</a>

                <form id="frmDelete" method="post" action="/qna/delete" style="display: inline;">
                    <input type="hidden" name="qnaIdx" value="${qnaDTO.qnaIdx}"/>
                    <button type="submit" id="btnDelete" class="btn btn-danger">문의 삭제</button>
                </form>
            </c:if>
        </div>
    </div>
</div>
<script>
    document.getElementById("btnDelete").addEventListener("click", (e) => {
        e.preventDefault();
        e.stopPropagation();

        if (window.confirm('문의를 삭제하시겠습니까?')) {
            document.getElementById("frmDelete").submit();
        } else {
            return;
        }
    });

    <c:if test="${not empty param.message}">
    const message = "${param.message}";
    if (message === 'authorized') {
        alert("답변이 등록되었습니다.");
    } else if (message === 'unauthorized') {
        alert("권한이 없습니다.");
    } else if (message === 'error') {
        alert("예외가 발생했습니다.");
    }
    </c:if>
</script>
</body>
</html>
