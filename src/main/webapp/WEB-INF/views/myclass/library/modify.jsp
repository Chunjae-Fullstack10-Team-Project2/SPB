<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>자료실 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        input[type="file"] {
            /*display: none;*/
        }
        .origin-file, .origin-file > input {
            cursor:pointer;
        }
        .origin-file > input:active {
            border: none;
        }
    </style>
</head>
<body>
<c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <h1 class="h2 mb-4">자료실 수정</h1>

            <form name="frmModify" action="/myclass/library/modify?${pageDTO.linkUrl}" method="post" enctype="multipart/form-data"
                  class="border p-4 rounded bg-light shadow-sm">
                <input type="hidden" name="teacherFileIdx" value="${teacherFileDTO.teacherFileIdx}"/>
                <input type="hidden" name="teacherFileMemberId" value="${teacherFileDTO.teacherFileMemberId}"/>

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

                <div class="mb-3">
                    <p class="form-label">기존 파일</p>
                    <p class="form-control">${teacherFileDTO.fileDTO.fileOrgName}</p>
                    <input type="hidden" name="deleteFile" value="${teacherFileDTO.fileDTO.fileName}" />
                </div>

                <div class="mb-3">
                    <label for="file" class="form-label">파일 첨부</label>
                    <input type="file" class="form-control" name="file" id="file">
                    <p class="text-danger small mb-0">* 새로운 파일 첨부 시, 기존 파일은 삭제됩니다.</p>
                </div>

                <div>
                    <button type="submit" class="btn btn-primary" id="btnModify">수정</button>
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

        document.querySelector('#btnModify').addEventListener('click', (e) => {
            e.preventDefault();

            const frm = document.querySelector('form[name="frmModify"]');
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
