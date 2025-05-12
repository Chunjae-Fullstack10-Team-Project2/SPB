<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>QnA 상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <div class="card">
                <div class="card-header">
                    <h1 class="h4 my-0">Q. ${teacherQnaDTO.teacherQnaTitle}</h1>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <div class="d-flex gap-2 align-items-center mb-2">
                            <c:choose>
                                <c:when test="${teacherQnaDTO.questionMemberProfileImg != null}">
                                    <img src="${teacherQnaDTO.questionMemberProfileImg}" width="32" height="32" class="rounded-circle">
                                </c:when>
                                <c:otherwise>
                                    <img src="<c:url value='/resources/img/default_profileImg.png'/>" width="32" height="32" class="rounded-circle">
                                </c:otherwise>
                            </c:choose>
                            <div>
                                <div class="small">${teacherQnaDTO.teacherQnaQMemberId}</div>
                                <div class="text-muted small">등록일: ${fn:replace(teacherQnaDTO.teacherQnaCreatedAt, 'T', ' ')}</div>
                            </div>
                        </div>
                    </div>
                    <hr/>
                    <p style="height: 100px;">${teacherQnaDTO.teacherQnaQContent}</p>
                </div>
            </div>

            <c:if test="${teacherQnaDTO.teacherQnaStatus eq 1}">
                <div class="card mt-3 mb-5">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center gap-2">
                                <c:choose>
                                    <c:when test="${teacherQnaDTO.answerMemberProfileImg != null}">
                                        <img src="${teacherQnaDTO.answerMemberProfileImg}" width="32" height="32" class="rounded-circle">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="<c:url value='/resources/img/default_profileImg.png'/>" width="32" height="32" class="rounded-circle">
                                    </c:otherwise>
                                </c:choose>
                                <div class="small ml-5">${teacherQnaDTO.answerMemberName} 선생님</div>
                            </div>
                            <div class="text-muted small">답변일: ${fn:replace(teacherQnaDTO.teacherQnaAnsweredAt, 'T', ' ')}</div>
                        </div>
                    </div>
                    <div class="card-body">
                        <p style="height: 100px;">${teacherQnaDTO.teacherQnaAContent}</p>
                    </div>
                </div>
            </c:if>
            <div class="mt-3 d-flex justify-content-between">
                <div>
                    <a href="/teacher/personal/qna?${pageDTO.linkUrl}" class="btn btn-secondary">목록</a>
                    <!-- 관리자, 문의 답변자(선생님), 문의 작성자(학생) 삭제 가능 -->
                    <c:if test="${not empty sessionScope.memberGrade and (sessionScope.memberGrade == 0 or sessionScope.memberId == teacherQnaDTO.teacherQnaQMemberId or sessionScope.memberId == teacherQnaDTO.teacherQnaAMemberId)}">
                        <a href="/teacher/personal/qna/delete?idx=${teacherQnaDTO.teacherQnaIdx}&${pageDTO.linkUrl}" class="btn btn-danger">삭제</a>
                    </c:if>
                </div>
                <!-- 관리자, 문의 답변자(선생님) 답변 등록 가능 -->
                <c:if test="${teacherQnaDTO.teacherQnaStatus eq 0 and not empty sessionScope.memberGrade and (sessionScope.memberGrade == 0 or sessionScope.memberId == teacherQnaDTO.teacherQnaAMemberId)}">
                    <a href="/teacher/personal/qna/answer?idx=${teacherQnaDTO.teacherQnaIdx}&${pageDTO.linkUrl}" class="btn btn-primary">답변</a>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>
