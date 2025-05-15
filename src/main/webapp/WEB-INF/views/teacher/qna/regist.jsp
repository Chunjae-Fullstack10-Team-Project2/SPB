<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>QnA 답변하기</title>
    <script src="${pageContext.request.contextPath}/resources/js/textCounter.js"></script>
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <h1 class="h2 mb-4">시험 등록</h1>

            <form name="frmRegist" action="/mystudy/qna/regist?${pageDTO.linkUrl}" method="post"
                  class="border p-4 rounded bg-light shadow-sm">
                <div class="mb-3">
                    <label for="teacherQnaTitle" class="form-label">제목</label>
                    <input type="text" class="form-control char-limit" name="teacherQnaTitle" id="teacherQnaTitle"
                           data-maxlength="50" data-target="#titleCount"
                           value="${dto.teacherQnaTitle}" placeholder="제목을 입력하세요." maxlength="50" required />
                    <div class="text-end small text-muted mt-1 mb-3">
                        <span id="titleCount">0</span> / 50
                    </div>
                </div>

                <div class="mb-3">
                    <label for="teacherQnaQContent" class="form-label">내용</label>
                    <textarea class="form-control char-limit" rows="10" name="teacherQnaQContent" id="teacherQnaQContent"
                              data-maxlength="19000" data-target="#contentCount"
                              placeholder="내용을 입력하세요" required style="resize: none;">${dto.teacherQnaQContent}</textarea>
                    <div class="text-end small text-muted mt-1 mb-3">
                        <span id="contentCount">0</span> / 19000
                    </div>
                </div>

                <div class="mb-3">
                    <label for="qnaQPwd" class="form-label">비밀번호</label>
                    <input type="text" class="form-control char-limit" name="qnaQPwd" id="qnaQPwd"
                           data-maxlength="50" data-target="#pwdCount"
                           value="${dto.qnaQPwd}" placeholder="비밀번호를 입력하세요. (숫자 4자리)" maxlength="4" required />
                    <div class="text-end small text-muted mt-1 mb-3">
                        <span id="pwdCount">0</span> / 50
                    </div>
                </div>

                <div>
                    <button type="submit" class="btn btn-primary" id="btnRegist">등록</button>
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

        document.querySelector('#btnRegist').addEventListener('click', (e) => {
            e.preventDefault();

            const frm = document.querySelector('form[name="frmRegist"]');
            const pwd = frm.qnaQPwd.value.trim();
            const regex = /^\d{4}$/;

            if (!regex.test(pwd)) {
                alert("비밀번호는 숫자 4자리여야 합니다.");
                frm.qnaQPwd.focus();
                return;
            }
            frm.submit();
        });

        <c:if test="${not empty errorMessage}">
            alert("${errorMessage}");
        </c:if>
    </script>
</body>
</html>
