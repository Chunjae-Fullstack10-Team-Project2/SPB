<%--
  Created by IntelliJ IDEA.
  User: MAIN
  Date: 2025-05-11
  Time: 오후 7:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>공지사항 등록</title>
    <script src="${pageContext.request.contextPath}/resources/js/textCounter.js"></script
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />

            <h1 class="h2 mb-4">공지사항 등록</h1>

            <form name="frmRegist" action="/myclass/notice/regist" method="post"
                  class="border p-4 rounded bg-light shadow-sm">
                <div class="mb-3">
                    <label for="teacherNoticeTitle" class="form-label">제목</label>
                    <input type="text" class="form-control char-limit" name="teacherNoticeTitle" id="teacherNoticeTitle"
                           data-maxlength="50" data-target="#titleCount"
                           value="${teacherNoticeDTO.teacherNoticeTitle}" placeholder="제목을 입력하세요." maxlength="50" required />
                    <div class="text-end small text-muted mt-1 mb-3">
                        <span id="titleCount">0</span> / 50
                    </div>
                </div>

                <div class="mb-3">
                    <label for="teacherNoticeContent" class="form-label">내용</label>
                    <textarea class="form-control char-limit" rows="10" name="teacherNoticeContent" id="teacherNoticeContent"
                              data-maxlength="19000" data-target="#contentCount"
                              placeholder="내용을 입력하세요" required style="resize: none;">${teacherNoticeDTO.teacherNoticeContent}</textarea>
                    <div class="text-end small text-muted mt-1 mb-3">
                        <span id="contentCount">0</span> / 19000
                    </div>
                </div>

                <div class="mb-3 form-check d-flex justify-content-between">
                    <div>
                        <input class="form-check-input" type="checkbox" value="1" name="teacherNoticeFixed" id="teacherNoticeFixed"
                        ${teacherNoticeDTO.teacherNoticeFixed == 1 ? "checked" : ""}>
                        <label class="form-check-label" for="teacherNoticeFixed">이 공지사항을 상단에 고정합니다</label>
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary" id="btnRegist">등록</button>
                        <button type="button" class="btn btn-outline-secondary" onclick="history.back();">취소</button>
                    </div>
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

        document.querySelector('#btnRegist').addEventListener('click', (e) => {
            e.preventDefault();

            const frm = document.querySelector('form[name="frmRegist"]');

            frm.submit();
        });

        <c:if test="${not empty message}">
            alert("${message}");
        </c:if>
    </script>
</body>
</html>
