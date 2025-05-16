<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <h1 class="h2 mb-4">나의 강의실</h1>

            <%
                List<Map<String, String>> searchSelect = new ArrayList<>();
                searchSelect.add(Map.of("value", "lectureTitle", "label", "강좌명"));
                searchSelect.add(Map.of("value", "teacherName", "label", "선생님"));

                request.setAttribute("searchSelect", searchSelect);
                request.setAttribute("searchAction", "/mystudy/lecture");
            %>
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/searchBoxOnlyPage.jsp" />
            <div class="d-flex flex-wrap gap-2 border-bottom pb-2 mb-4">
                <a onclick="setLectureStatus();"
                   class="btn rounded-pill
                   ${empty param.lecture_status ? 'active btn-primary text-white border-primary' : 'btn-outline-secondary'}">
                    전체
                </a>
                <a onclick="setLectureStatus(0);"
                   class="btn rounded-pill
                   ${param.lecture_status eq 0 ? 'active btn-primary text-white border-primary' : 'btn-outline-secondary'}">
                    수강전
                </a>
                <a onclick="setLectureStatus(1);"
                   class="btn rounded-pill
                   ${param.lecture_status eq 1 ? 'active btn-primary text-white border-primary' : 'btn-outline-secondary'}">
                    수강중
                </a>
                <a onclick="setLectureStatus(2);"
                   class="btn rounded-pill
                   ${param.lecture_status eq 2 ? 'active btn-primary text-white border-primary' : 'btn-outline-secondary'}">
                    수강완료
                </a>
            </div>
            <c:if test="${not empty lectureList}">
                <div class="lecture-list">
                    <c:forEach var="lecture" items="${lectureList}">
                        <div class="card mb-3 shadow-sm border-0 rounded-4 overflow-hidden" style="min-width: 440px;"
                             role="button" onclick="location.href='/lecture/lectureDetail?lectureIdx=${lecture.lectureRegisterRefIdx}'">
                            <div class="col px-4 py-3">
                                <c:if test="${lecture.hasLectureReview eq false}">
                                    <button type="button" class="btn btn-sm btn-outline-warning mb-3" class="btnReview"
                                            onclick="location.href='mystudy/review/regist?idx=${lecture.lectureRegisterRefIdx}&${pageDTO.linkUrl}'">
                                        <i class="bi bi-star"></i> 수강평 남기기
                                    </button>
                                </c:if>
                                <h6 class="mb-1 text-dark">${lecture.lectureTitle}</h6>
                                <p class="mb-1 text-muted">${lecture.teacherName} 선생님</p>
                                <div class="d-flex flex-md-row justify-content-md-between align-items-md-end
                                            flex-column align-items-start">
                                    <div class="d-flex flex-row align-items-center gap-2">
                                        <div class="fw-bold">진도율</div>
                                        <div class="progress" style="width: 300px; height: 8px;">
                                            <div class="progress-bar bg-success" role="progressbar"
                                                 style="width: ${lecture.lectureProgress != null ? lecture.lectureProgress : 0}%;">
                                            </div>
                                        </div>
                                        <div class="small">${lecture.lectureProgress != null ? lecture.lectureProgress : 0}%</div>
                                    </div>

                                    <p class="mb-0 text-secondary small">
                                        최종 학습일: ${lecture.lectureHistoryLastWatchDate != null ? fn:substring(lecture.lectureHistoryLastWatchDate, 0, 10) : '-'}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <c:if test="${empty lectureList}">
                <div class="alert alert-warning text-center" role="alert">
                    강좌가 없습니다.
                </div>
            </c:if>

            <div class="mb-2 mb-md-0 text-center">
                <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/pagingOnlyPage.jsp" />
            </div>
        </div>
    </div>

    <script>
        const setLectureStatus = (status) => {
            const params = new URLSearchParams(location.search);
            if(status != null) {
                params.set("lecture_status", status);
            } else {
                params.delete("lecture_status");
            }

            location.href = "/mystudy?" + params.toString();
        }

        document.querySelectorAll('button').forEach(el => {
            el.addEventListener('click', function(e) {
                e.stopPropagation();
            });
        });
    </script>
</body>
</html>
