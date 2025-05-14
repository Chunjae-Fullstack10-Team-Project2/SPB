<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>공지사항 상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
        <div class="container">
            <h1 class="h4 fw-bold">${teacherNoticeDTO.teacherNoticeTitle}</h1>
            <div class="d-flex gap-2 align-items-center mb-2">
                <c:if test="${teacherNoticeDTO.memberProfileImg != null}">
                    <img src="${teacherNoticeDTO.memberProfileImg}" width="32" height="32" class="rounded-circle">
                </c:if>
                <div>
                    <div class="small">${teacherNoticeDTO.teacherNoticeMemberId}</div>
                    <div class="text-muted small">
                        등록일: ${fn:replace(teacherNoticeDTO.teacherNoticeCreatedAt, 'T', ' ')}
                        <c:if test="${teacherNoticeDTO.teacherNoticeUpdatedAt != null}">
                         &nbsp;| 수정일: ${fn:replace(teacherNoticeDTO.teacherNoticeUpdatedAt, 'T', ' ')}
                        </c:if>
                    </div>
                </div>
            </div>
            <hr/>

            <p>${teacherNoticeDTO.teacherNoticeContent}</p>

            <form>
                <div class="gap-2 my-4 d-flex justify-content-between">
                    <input type="hidden" name="idx" value="${teacherNoticeDTO.teacherNoticeIdx}" />

                    <div>
                        <button type="button" class="btn btn-secondary btn-sm" onclick="location.href='/myclass/notice?${pageDTO.linkUrl}'">목록</button>
                    </div>

                    <div>
                        <c:if test="${sessionScope.memberId eq teacherNoticeDTO.teacherNoticeMemberId}">
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
           frm.action = "/myclass/notice/modify?" + urlParams;
           frm.method = "get";
           frm.submit();
        });

        document.getElementById('btnDelete').addEventListener('click', () => {
            const frm = document.forms[0];
            frm.action = "/myclass/notice/delete?" + urlParams;
            frm.method = "get";
            frm.submit();
        });
    </script>
</body>
</html>
