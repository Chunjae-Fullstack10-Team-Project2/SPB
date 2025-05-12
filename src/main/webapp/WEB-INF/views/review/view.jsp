<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>수강후기 상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
        <div class="container">
            <p>[${lectureReviewDTO.teacherName} 선생님] ${lectureReviewDTO.lectureTitle}</p>
            <div class="d-flex gap-2 align-items-center mb-2">
                <c:if test="${lectureReviewDTO.memberProfileImg != null}">
                    <img src="${lectureReviewDTO.memberProfileImg}" width="32" height="32" class="rounded-circle">
                </c:if>
                <div>
                    <div class="small">${lectureReviewDTO.lectureReviewMemberId}</div>
                    <div class="text-muted small">
                        등록일: ${fn:replace(lectureReviewDTO.lectureReviewCreatedAt, 'T', ' ')}&nbsp;
                        <c:if test="${lectureReviewDTO.lectureReviewUpdatedAt != null}">
                            &nbsp;| 수정일: ${fn:replace(lectureReviewDTO.lectureReviewUpdatedAt, 'T', ' ')}&nbsp;
                        </c:if>
                        <c:set var="rating" value="${lectureReviewDTO.lectureReviewGrade}" />
                        | 만족도:
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
                    </div>
                </div>
            </div>

            <p>${lectureReviewDTO.lectureReviewContent}</p>

            <form>
                <div class="gap-2 my-4 d-flex justify-content-between">
                    <input type="hidden" name="idx" value="${lectureReviewDTO.lectureReviewIdx}" />
                    <div>
                        <button type="button" class="btn btn-secondary btn-sm" onclick="location.href='/mystudy/review?${pageDTO.linkUrl}'">목록</button>
                    </div>
                    <div>
                        <c:if test="${sessionScope.memberId eq lectureReviewDTO.lectureReviewMemberId}">
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
