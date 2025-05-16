<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>수강후기 상세보기</title>
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />

            <div class="border p-4 rounded bg-light shadow-sm">
                <div class="mb-3">
                    <p class="form-label">작성자</p>
                    <p class="form-control">${review.lectureReviewMemberId}</p>
                </div>

                <div class="mb-3">
                    <p class="form-label">만족도</p>
                    <p class="form-control">
                        <c:set var="rating" value="${review.lectureReviewGrade}" />
                        <span class="text-warning">
                            <c:forEach var="i" begin="1" end="5">
                                <c:choose>
                                    <c:when test="${rating >= i}">
                                        <i class="bi bi-star-fill"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-star"></i>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </span>
                    </p>
                </div>

                <div class="mb-3">
                    <p class="form-label">내용</p>
                    <p class="form-control" style="height: 254px;">${review.lectureReviewContent}</p>
                </div>

                <div class="d-flex justify-content-between text-muted small">
                    <p>
                        등록일: ${fn:replace(review.lectureReviewCreatedAt, 'T', ' ')}
                        <c:if test="${review.lectureReviewUpdatedAt != null}">
                            &nbsp;/ 수정일: ${fn:replace(review.lectureReviewUpdatedAt, 'T', ' ')}
                        </c:if>
                    </p>
                </div>
            </div>

            <form>
                <div class="gap-2 my-4 d-flex justify-content-between">
                    <input type="hidden" name="idx" value="${review.lectureReviewIdx}" />
                    <div>
                        <button type="button" class="btn btn-secondary btn-sm" onclick="location.href='/mystudy/review?${pageDTO.linkUrl}'">목록</button>
                    </div>
                    <div>
                        <c:if test="${sessionScope.memberId eq review.lectureReviewMemberId}">
                            <button type="button" class="btn btn-warning btn-sm" id="btnModify">수정</button>
                            <button type="button" class="btn btn-danger btn-sm" id="btnDelete">삭제</button>
                        </c:if>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script>
        const urlParams = "${pageDTO.linkUrl}";

        document.getElementById('btnModify').addEventListener('click', () => {
            const frm = document.forms[0];
            frm.action = "/mystudy/review/modify?" + urlParams;
            frm.method = "get";
            frm.submit();
        });

        document.getElementById('btnDelete').addEventListener('click', () => {
            const frm = document.forms[0];
            frm.action = "/mystudy/review/delete?" + urlParams;
            frm.method = "get";
            frm.submit();
        });
    </script>
</body>
</html>
