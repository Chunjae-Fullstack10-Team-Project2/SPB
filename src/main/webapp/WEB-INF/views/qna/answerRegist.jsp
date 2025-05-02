<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%@ include file="../common/header.jsp" %>

<div class="qna-regist-container">
    <form name="frmRegist" method="post" class="needs-validation" novalidate>
        <div class="mb-3">
            <label for="qnaAMemberId" class="form-label">작성자</label>
            <input type="text" class="form-control" id="qnaAMemberId" value="${qnaDTO.qnaAMemberId}" name="qnaAMemberId">
        </div>
        <div class="mb-3">
            <label for="qnaAContent" class="form-label">내용</label>
            <textarea class="form-control" id="qnaAContent" name="qnaAContent" rows="10"
                      placeholder="내용을 입력하세요."></textarea>
        </div>
        <div class="btn-container mt-4">
            <input type="submit" class="btn btn-primary" id="btnSubmit" name="btnSubmit" value="등록">
            <input type="reset" class="btn btn-secondary" id="btnCancel" name="btnCancel" value="취소">
        </div>
    </form>
</div>

<script>
    <c:if test="${not empty message}">
    alert("${message}");
    </c:if>
</script>
</body>
</html>
