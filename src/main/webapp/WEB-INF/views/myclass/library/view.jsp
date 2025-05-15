<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>자료실 상세보기</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <h1 class="h2 mb-4">자료실 상세보기</h1>

            <div class="border p-4 rounded bg-light shadow-sm">
                <div class="mb-3">
                    <p class="form-label">제목</p>
                    <p class="form-control">${teacherFileDTO.teacherFileMemberId}</p>
                </div>

                <div class="mb-3">
                    <p class="form-label">내용</p>
                    <p class="form-control" style="height: 254px;">${teacherFileDTO.teacherFileTitle}</p>
                </div>

                <div class="mb-3">
                    <p class="form-label">첨부파일</p>
                    <p class="form-control">
                        <a href="/file/download/library/${teacherFileDTO.fileDTO.fileIdx}"
                           class="text-decoration-none text-muted">
                            <i class="bi bi-floppy2-fill"></i>&nbsp;&nbsp;${teacherFileDTO.fileDTO.fileOrgName}
                        </a>
                    </p>
                </div>

                <div class="d-flex justify-content-end text-muted small">
                    등록일: ${fn:replace(teacherFileDTO.teacherFileCreatedAt, 'T', ' ')}
                    <c:if test="${teacherFileDTO.teacherFileUpdatedAt != null}">
                        &nbsp;/ 수정일: ${fn:replace(teacherFileDTO.teacherFileUpdatedAt, 'T', ' ')}
                    </c:if>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center mt-3">
                <div>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="location.href='/myclass/library?${pageDTO.linkUrl}'">목록</button>
                </div>

                <div>
                    <c:if test="${sessionScope.memberId eq teacherFileDTO.teacherFileMemberId}">
                        <form name="frmSubmit" method="get">
                            <input type="hidden" name="idx" value="${teacherFileDTO.teacherFileIdx}" />
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
            frm.action = "/myclass/library/modify?" + urlParams;
            frm.submit();
        });

        document.getElementById('btnDelete').addEventListener('click', () => {
            const frm = document.querySelector('form[name="frmSubmit"]');
            frm.action = "/myclass/library/delete?" + urlParams;
            frm.submit();
        });

        <c:if test="${not empty message}">
            alert("${message}");
        </c:if>
    </script>
</body>
</html>
