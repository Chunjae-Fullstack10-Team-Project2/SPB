<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>공지사항 상세보기</title>
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <h1 class="h2 mb-4">공지사항 상세보기</h1>

            <div class="border p-4 rounded bg-light shadow-sm">
                <div class="mb-3">
                    <p class="form-label">제목</p>
                    <p class="form-control">${teacherNoticeDTO.teacherNoticeTitle}</p>
                </div>

                <div class="mb-3">
                    <p class="form-label">내용</p>
                    <p class="form-control" style="height: 254px;">${teacherNoticeDTO.teacherNoticeContent}</p>
                </div>

                <div class="d-flex justify-content-between text-muted small">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="checkDefault" readonly
                               ${teacherNoticeDTO.teacherNoticeFixed == 1 ? "checked" : ""}>
                        <label class="form-check-label" for="checkDefault">
                            상단고정
                        </label>
                    </div>
                    <p>
                        등록일: ${fn:replace(teacherNoticeDTO.teacherNoticeCreatedAt, 'T', ' ')}
                        <c:if test="${teacherNoticeDTO.teacherNoticeUpdatedAt != null}">
                            &nbsp;/ 수정일: ${fn:replace(teacherNoticeDTO.teacherNoticeUpdatedAt, 'T', ' ')}
                        </c:if>
                    </p>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center mt-3">
                <div>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="location.href='/myclass/notice?${pageDTO.linkUrl}'">목록</button>
                </div>

                <div>
                    <c:if test="${sessionScope.memberId eq teacherNoticeDTO.teacherNoticeMemberId}">
                        <form name="frmSubmit" method="get">
                            <input type="hidden" name="idx" value="${teacherNoticeDTO.teacherNoticeIdx}" />
                            <button type="button" class="btn btn-warning btn-sm" id="btnModify">수정</button>
                            <button type="button" class="btn btn-danger btn-sm" id="btnDelete">삭제</button>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script>
        const urlParams = "${pageDTO.linkUrl}";

        document.getElementById('btnModify').addEventListener('click', () => {
            const frm = document.querySelector('form[name="frmSubmit"]');
            frm.action = "/myclass/notice/modify?" + urlParams;
            frm.submit();
        });

        document.getElementById('btnDelete').addEventListener('click', () => {
            const frm = document.querySelector('form[name="frmSubmit"]');
            frm.action = "/myclass/notice/delete?" + urlParams;
            frm.submit();
        });

        <c:if test="${not empty message}">
            alert("${message}");
        </c:if>
    </script>
</body>
</html>
