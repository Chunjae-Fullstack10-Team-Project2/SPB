<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>시험 등록</title>
    <script src="${pageContext.request.contextPath}/resources/js/textCounter.js"></script
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
        <h1 class="h2 mb-4">시험 등록</h1>

        <form name="frmRegist" action="/myclass/exam/regist" method="post"
              class="border p-4 rounded bg-light shadow-sm">
            <div class="mb-3">
                <label for="lectureIdx" class="form-label">강좌</label>
                <select name="examLectureIdx" id="lectureIdx" class="form-select">
                    <option value="" ${pageDTO.lectureIdx eq null ? "selected" : ""}>강좌를 선택하세요.</option>
                    <c:forEach var="item" items="${lectureList}">
                        <option value="${item.lectureIdx}" ${param.lectureIdx != null and pageDTO.lectureIdx == item.lectureIdx ? "selected" : ""}>
                                ${item.lectureTitle}
                        </option>
                    </c:forEach>
                </select>
                <div class="small text-danger mt-1 mb-3">
                    <span id="examLectureMessage"></span>
                </div>
            </div>
            <div class="mb-3">
                <label for="examTitle" class="form-label">제목</label>
                <input type="text" class="form-control char-limit" name="examTitle" id="examTitle"
                       data-maxlength="50" data-target="#titleCount"
                       value="${examDTO.examTitle}" placeholder="제목을 입력하세요." maxlength="50" required />
                <div class="text-end small text-muted mt-1 mb-3">
                    <span id="titleCount">0</span> / 50
                </div>
            </div>

            <div class="mb-3">
                <label for="examDescription" class="form-label">내용</label>
                <textarea class="form-control char-limit" rows="10" name="examDescription" id="examDescription"
                          data-maxlength="19000" data-target="#examDescriptionCount"
                          placeholder="내용을 입력하세요" required style="resize: none;">${examDTO.examDescription}</textarea>
                <div class="text-end small text-muted mt-1 mb-3">
                    <span id="contentCount">0</span> / 19000
                </div>
            </div>

            <div>
                <button type="submit" class="btn btn-primary">등록</button>
                <button type="button" class="btn btn-outline-secondary" onclick="history.back();">취소</button>
            </div>
        </form>
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

            const frm = document.querySelector('form[name="frmRegist"]');
            const lecture = frm.examLectureIdx.value;

            if (!lecture) {
                alert("강좌를 선택해주세요.");
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
