<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>수강후기 수정</title>
    <script src="${pageContext.request.contextPath}/resources/js/textCounter.js"></script>
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <h1 class="h2 mb-4">수강후기 수정</h1>

            <form name="frmRegist" action="/mystudy/review/modify" method="post"
                  class="border p-4 rounded bg-light shadow-sm">

                <input type="hidden" name="lectureReviewIdx" value="${review.lectureReviewIdx}"/>
                <input type="hidden" name="lectureReviewMemberId" value="${review.lectureReviewMemberId}"/>

                <div class="mb-3">
                    <label for="lectureReviewRefIdx" class="form-label">강좌 선택</label>
                    <select class="form-select" name="lectureReviewRefIdx" id="lectureReviewRefIdx">
                        <option value=""}>강좌를 선택하세요.</option>
                        <c:forEach items="${lectureList}" var="lecture">
                            <option value="${lecture.lectureIdx}"
                                ${review.lectureReviewRefIdx eq lecture.lectureIdx ? "selected" : ""}>
                                    ${lecture.lectureTitle}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    만족도
                    <div class="d-flex flex-wrap gap-3">
                        <c:forEach var="i" begin="0" end="5">
                            <div class="form-check text-center">
                                <input class="form-check-input" type="radio" name="lectureReviewGrade" id="grade${i}" value="${i}"
                                    ${review.lectureReviewGrade == i ? "checked" : ""}/>&nbsp;
                                <label for="grade${i}">
                                    <c:forEach var="j" begin="1" end="5">
                                        <c:if test="${i >= j}">
                                            <i class="bi bi-star-fill text-warning"></i>
                                        </c:if>
                                        <c:if test="${i < j}">
                                            <i class="bi bi-star text-warning"></i>
                                        </c:if>
                                    </c:forEach>
                                </label>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="lectureReviewContent" class="form-label">수강후기</label>
                    <textarea class="form-control char-limit" rows="10" name="lectureReviewContent" id="lectureReviewContent"
                              data-maxlength="19000" data-target="#contentCount"
                              placeholder="내용을 입력하세요" required style="resize: none;">${review.lectureReviewContent}</textarea>
                    <div class="text-end small text-muted mt-1 mb-3">
                        <span id="contentCount">0</span> / 19000
                    </div>
                </div>

                <div class="mb-3 d-flex justify-content-center">
                    <div>
                        <button type="submit" class="btn btn-primary">수정</button>
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

        document.querySelector('button[type="submit"]').addEventListener('click', (e) => {
            e.preventDefault();

            const frm = document.forms[0];
            const lectureIdx = frm.lectureReviewRefIdx.value;
            const grade = frm.lectureReviewGrade.value;
            const content = frm.lectureReviewContent.value;

            if (lectureIdx == null) {
                alert("내용은 필수 항목입니다.");
                frm.lectureReviewRefIdx.focus();
                return;
            }
            if (grade == null) {
                alert("만족도는 필수 항목입니다.");
                frm.lectureReviewGrade.focus();
                return;
            }
            if (content == null) {
                alert("내용은 필수 항목입니다.");
                frm.lectureReviewContent.focus();
                return;
            }

            frm.submit();
        });
    </script>
</body>
</html>
