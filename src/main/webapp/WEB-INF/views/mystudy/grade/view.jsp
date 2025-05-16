<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>성적표 상세보기</title>
    <style>
        .no-click {
            pointer-events: none;
        }
    </style>
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <h1 class="h2 mb-4">성적표 상세보기</h1>
            <div class="border p-4 rounded bg-light shadow-sm">
                <!-- 섹션 1: 회원 정보 -->
                <div class="mb-4">
                    <h5 class="mb-3 border-bottom pb-2">회원 정보</h5>
                    <div class="row g-3">
                        <div class="col-md-4 d-flex justify-content-center align-items-center">
                            <c:choose>
                                <c:when test="${lectureGradeDTO.memberProfileImg != null}">
                                    <img src="${lectureGradeDTO.memberProfileImg}" width="120" height="120" class="rounded-circle">
                                </c:when>
                                <c:otherwise>
                                    <img src="<c:url value='/resources/img/default_profileImg.png'/>" width="120" height="120" class="rounded-circle">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col">
                            <div class="col-12 mb-3">
                                <div class="form-floating">
                                    <input readonly class="form-control no-click" id="memberId" value="${lectureGradeDTO.lectureGradeMemberId}">
                                    <label for="memberId">회원 ID</label>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-floating">
                                    <input readonly class="form-control no-click" id="memberName" value="${lectureGradeDTO.memberName}">
                                    <label for="memberName">이름</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- 섹션 2: 강의 정보 -->
                <div class="mb-4">
                    <h5 class="mb-3 border-bottom pb-2">강의 정보</h5>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="form-floating">
                                <input readonly class="form-control no-click" id="lectureTitle" value="${lectureGradeDTO.lectureTitle}">
                                <label for="lectureTitle">강의 제목</label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating">
                                <input readonly class="form-control no-click" id="teacherName" value="${lectureGradeDTO.teacherName}">
                                <label for="teacherName">담당 교사</label>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="form-floating">
                                <textarea style="resize: none; height: 100px;" readonly class="form-control no-click" id="lectureDescription" style="height: 100px">${lectureGradeDTO.lectureDescription}</textarea>
                                <label for="lectureDescription">강의 설명</label>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- 섹션 3: 성적 정보 -->
                <div class="mb-4">
                    <h5 class="mb-3 border-bottom pb-2">성적 정보</h5>
                    <div class="row g-3">
                        <div class="col-md-3">
                            <div class="form-floating">
                                <input readonly class="form-control no-click text-center" id="score" value="${lectureGradeDTO.lectureGradeScore}" style="height: 100px; font-size: 40px;">
                                <label for="score">성적</label>
                            </div>
                        </div>
                        <div class="col-md-9">
                            <div class="form-floating">
                                <textarea style="resize: none; height: 100px;" readonly class="form-control no-click" id="feedback" style="height: 100px">${lectureGradeDTO.lectureGradeFeedback}</textarea>
                                <label for="feedback">피드백</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="text-end">
                    <small class="text-muted">
                        등록일: ${fn:substring(lectureGradeDTO.lectureGradeCreatedAt, 0, 10)}
                        <c:if test="${lectureGradeDTO.lectureGradeUpdatedAt != null}">
                            / 수정일: ${fn:substring(lectureGradeDTO.lectureGradeUpdatedAt, 0, 10)}
                        </c:if>
                    </small>
                </div>
            </div>


            <div class="d-flex justify-content-between align-items-center mt-3">
                <div>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="location.href='/mystudy/grade?${pageDTO.linkUrl}'">목록</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        <c:if test="${not empty message}">
            alert("${message}");
        </c:if>
    </script>
</body>
</html>
