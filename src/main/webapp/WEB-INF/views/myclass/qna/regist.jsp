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

            <div class="border p-4 rounded bg-light shadow-sm mb-3">
                <div class="mb-3">
                    <p class="form-label">문의자</p>
                    <p class="form-control">${dto.teacherQnaQMemberId}</p>
                </div>

                <div class="mb-3">
                    <p class="form-label">문의제목</p>
                    <p class="form-control">${dto.teacherQnaTitle}</p>
                </div>

                <div class="mb-3">
                    <p class="form-label">문의내용</p>
                    <p class="form-control" style="height: 254px;">${dto.teacherQnaQContent}</p>
                </div>

                <div class="text-muted small">
                    등록일: ${fn:replace(dto.teacherQnaCreatedAt, 'T', ' ')}
                </div>
            </div>

            <form name="frmRegist" action="/myclass/qna/regist?${pageDTO.linkUrl}" method="post"
                  class="border p-4 rounded bg-light shadow-sm">
                <input type="hidden" name="teacherQnaIdx" value="${dto.teacherQnaIdx}"/>
                <div class="mb-3">
                    <p class="form-label">답변자</p>
                    <p class="form-control">${sessionScope.memberId}</p>
                </div>

                <div>
                    <label for="teacherQnaAContent" class="form-label">답변내용</label>
                    <textarea class="form-control char-limit" rows="10" name="teacherQnaAContent" id="teacherQnaAContent"
                              data-maxlength="19000" data-target="#contentCount"
                              placeholder="내용을 입력하세요" required style="resize: none;">${examDTO.examDescription}</textarea>
                    <div class="text-end small text-muted mt-1 mb-3">
                        <span id="contentCount">0</span> / 19000
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

            frm.submit();
        });

        <c:if test="${not empty errorMessage}">
            alert("${errorMessage}");
        </c:if>
    </script>
</body>
</html>
