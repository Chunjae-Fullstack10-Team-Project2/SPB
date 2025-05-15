<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>성적 수정</title>
    <script src="${pageContext.request.contextPath}/resources/js/textCounter.js"></script>
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <h1 class="h2 mb-4">성적 수정</h1>
            <form name="frmModify" action="/myclass/grade/modify?${pageDTO.linkUrl}" method="post"
                  class="border p-4 rounded bg-light shadow-sm">
                <input type="hidden" name="lectureGradeIdx" value="${lectureGradeDTO.lectureGradeIdx}" />
                <input type="hidden" name="lectureGradeRefIdx" value="${lectureGradeDTO.lectureGradeRefIdx}" />
                <input type="hidden" name="lectureGradeMemberId" value="${lectureGradeDTO.lectureGradeMemberId}" />
                <div class="mb-3">
                    <p class="form-label">회원ID</p>
                    <input type="text" class="form-control" disabled value="${lectureGradeDTO.lectureGradeMemberId}"/>
                </div>

                <div class="mb-3">
                    <p class="form-label">강좌명</p>
                    <input type="text" class="form-control" disabled value="${lectureGradeDTO.lectureTitle}"/>
                </div>

                <div class="mb-3">
                    <label for="lectureGradeScore" class="form-label">점수</label>
                    <select class="form-select" name="lectureGradeScore" id="lectureGradeScore">
                        <option value="" ${lectureGradeDTO.lectureGradeScore == null ? 'selected' : ''}>점수를 선택해주세요.</option>
                        <option value="A" ${lectureGradeDTO.lectureGradeScore == 'A' ? 'selected' : ''}>A</option>
                        <option value="B" ${lectureGradeDTO.lectureGradeScore == 'B' ? 'selected' : ''}>B</option>
                        <option value="C" ${lectureGradeDTO.lectureGradeScore == 'C' ? 'selected' : ''}>C</option>
                        <option value="D" ${lectureGradeDTO.lectureGradeScore == 'D' ? 'selected' : ''}>D</option>
                        <option value="E" ${lectureGradeDTO.lectureGradeScore == 'E' ? 'selected' : ''}>E</option>
                        <option value="F" ${lectureGradeDTO.lectureGradeScore == 'F' ? 'selected' : ''}>F</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="lectureGradeFeedback" class="form-label">피드백</label>
                    <textarea class="form-control char-limit" rows="10" name="lectureGradeFeedback" id="lectureGradeFeedback"
                              data-maxlength="19000" data-target="#lectureGradeFeedback"
                              placeholder="내용을 입력하세요" required style="resize: none;">${lectureGradeDTO.lectureGradeFeedback}</textarea>
                    <div class="text-end small text-muted mt-1 mb-3">
                        <span id="contentCount">0</span> / 19000
                    </div>
                </div>

                <div>
                    <button type="submit" class="btn btn-primary">수정</button>
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

            const frm = document.querySelector('form[name="frmModify"]');
            const score = frm.lectureGradeScore.value;

            if (!score) {
                alert("점수를 선택해주세요.");
                frm.lectureGradeScore.focus();
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
