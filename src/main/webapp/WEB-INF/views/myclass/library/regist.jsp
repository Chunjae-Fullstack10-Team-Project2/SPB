<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>자료실 등록</title>
    <script src="${pageContext.request.contextPath}/resources/js/textCounter.js"></script>
</head>
<body>
<c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
<div class="content">
    <div class="container my-5">
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
        <h1 class="h2 mb-4">자료실 등록</h1>

        <form name="frmRegist" action="/myclass/library/regist?${pageDTO.linkUrl}" method="post" enctype="multipart/form-data"
              class="border p-4 rounded bg-light shadow-sm mb-0">
            <div class="mb-3">
                <label for="teacherFileTitle" class="form-label">제목</label>
                <input type="text" class="form-control char-limit" name="teacherFileTitle" id="teacherFileTitle"
                       data-maxlength="50" data-target="#titleCount"
                       value="${teacherFileDTO.teacherFileTitle}" placeholder="제목을 입력하세요." maxlength="50" required />
                <div class="text-end small text-muted mt-1 mb-3">
                    <span id="titleCount">0</span> / 50
                </div>
            </div>

            <div class="mb-3">
                <label for="teacherFileContent" class="form-label">내용</label>
                <textarea class="form-control char-limit" rows="10" name="teacherFileContent" id="teacherFileContent"
                          data-maxlength="19000" data-target="#contentCount"
                          placeholder="내용을 입력하세요" style="resize: none;">${teacherFileDTO.teacherFileContent}</textarea>
                <div class="text-end small text-muted mt-1 mb-3">
                    <span id="contentCount">0</span> / 19000
                </div>
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
    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll("textarea.char-limit, input[type='text'].char-limit").forEach(function (el) {
            const maxLength = parseInt(el.dataset.maxlength || "1000", 10);
            const counterSelector = el.dataset.target;
            const counterEl = counterSelector ? document.querySelector(counterSelector) : null;

            el.addEventListener("input", function () {
                let text = el.value;
                if (text.length > maxLength) {
                    el.value = text.substring(0, maxLength);
                }
                if (counterEl) {
                    counterEl.textContent = el.value.length;
                }
            });
        });
    });

    document.querySelector('button[type="submit"]').addEventListener('click', (e) => {
        e.preventDefault();

        const frm = document.forms[0];
        const file = frm.file.files;

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

    <c:if test="${not empty message}">
        alert("${message}");
    </c:if>
</script>
</body>
</html>
