<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>QnA 답변</title>
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

        <div class="card mt-3 mb-5">
            <div class="card-header p-4">
                <form class="mb-0" method="post" action="/teacher/personal/qna/answer?${pageDTO.linkUrl}">
                    <input type="hidden" name="teacherQnaIdx" value="${teacherQnaDTO.teacherQnaIdx}" />
                    <input type="hidden" name="teacherQnaAMemberId" value="${teacherQnaDTO.teacherQnaAMemberId}" />

                    <div class="mb-3">
                        <label for="teacherQnaAContent" class="form-label">답변 내용</label>
                        <textarea class="form-control" rows="10" name="teacherQnaAContent" id="teacherQnaAContent"
                                  placeholder="내용을 입력하세요" required style="resize: none;">${teacherQnaDTO.teacherQnaAContent}</textarea>
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary">등록</button>
                        <button type="button" class="btn btn-outline-secondary" onclick="history.back();">취소</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        document.querySelector('button[type="submit"]').addEventListener('click', (e) => {
            e.preventDefault();

            const frm = document.forms[0];
            const content = frm.teacherQnaAContent.value;

            if (content == null) {
                alert("내용은 필수 항목입니다.");
                frm.teacherQnaAContent.focus();
                return;
            }

            frm.submit();
        });
    </script>
</body>
</html>
