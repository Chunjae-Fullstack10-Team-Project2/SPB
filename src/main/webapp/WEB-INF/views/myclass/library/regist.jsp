<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>자료실 등록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
<div class="content">
    <div class="container">
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
        <h1 class="h2 mb-4">자료실 등록</h1>

        <form name="frmRegist" action="/myclass/library/regist" method="post" enctype="multipart/form-data"
              class="border p-4 rounded bg-light shadow-sm mb-0">
            <div class="mb-3">
                <label for="teacherFileTitle" class="form-label">제목</label>
                <input type="text" class="form-control" name="teacherFileTitle" id="teacherFileTitle"
                       value="${teacherFileDTO.teacherFileTitle}" placeholder="제목을 입력하세요." maxlength="50" required />
            </div>

            <div class="mb-3">
                <label for="teacherFileContent" class="form-label">내용</label>
                <textarea class="form-control" rows="10" name="teacherFileContent" id="teacherFileContent"
                          placeholder="내용을 입력하세요" style="resize: none;">${teacherFileDTO.teacherFileContent}</textarea>
            </div>

            <div class="mb-4">
                <label for="file" class="form-label">파일 첨부</label>
                <input type="file" class="form-control" name="file" id="file">
            </div>

            <div>
                <button type="submit" class="btn btn-primary">등록</button>
                <button type="button" class="btn btn-outline-secondary" onclick="history.back();">취소</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.querySelector('button[type="submit"]').addEventListener('click', (e) => {
        e.preventDefault();

        const frm = document.forms[0];
        const title = frm.teacherFileTitle.value;
        const content = frm.teacherFileContent.value;
        const file = frm.file.files;

        if (title == null || title.length < 1 || title.length > 50) {
            alert("제목은 1자 이상 50자 이하로 입력해주세요.");
            frm.teacherFileTitle.focus();
            return;
        }
        if (file.length < 1) {
            alert("파일을 첨부해주세요.");
            return;
        }
        const maxFileSize = 10 * 1024 * 1024;
        if (file.size > maxFileSize) {
            alert("파일은 10MB 이하만 업로드할 수 있습니다.");
            return;
        }

        frm.submit();
    });
</script>
</body>
</html>
