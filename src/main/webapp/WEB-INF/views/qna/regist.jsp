<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>문의사항 등록</title>
</head>
<body>
<div class="qna-regist-container">
    <form name="frmRegist" method="post" class="needs-validation" novalidate>
        <div class="mb-3">
            <label for="qnaTitle" class="form-label">제목</label>
            <input type="text" class="form-control" id="qnaTitle" name="qnaTitle" placeholder="제목을 입력하세요.">
        </div>
        <div class="mb-3">
            <label for="qnaQMemberId" class="form-label">작성자</label>
            <input type="text" class="form-control" id="qnaQMemberId" value="${qnaDTO.qnaQMemberId}" name="qnaQMemberId">
        </div>
        <div class="mb-3">
            <label for="qnaQContent" class="form-label">내용</label>
            <textarea class="form-control" id="qnaQContent" name="qnaQContent" rows="10"
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
