
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>자료실 상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <div class="card">
                <div class="card-body">
                    <div class="mb-3">
                        <div class="d-flex gap-2 align-items-center mb-2">
                            <c:choose>
                                <c:when test="${teacherFileDTO.teacherProfileImg != null}">
                                    <img src="${teacherFileDTO.teacherProfileImg}" width="32" height="32" class="rounded-circle">
                                </c:when>
                                <c:otherwise>
                                    <img src="<c:url value='/resources/img/default_profileImg.png'/>" width="32" height="32" class="rounded-circle">
                                </c:otherwise>
                            </c:choose>
                            <div>
                                <div class="small">${teacherFileDTO.teacherName} 선생님</div>
                                <div class="text-muted small">
                                    등록일: ${fn:replace(teacherFileDTO.teacherFileCreatedAt, 'T', ' ')}
                                    <c:if test="${teacherFileDTO.teacherFileUpdatedAt != null}">
                                        | 수정일: ${fn:replace(teacherFileDTO.teacherFileUpdatedAt, 'T', ' ')}
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr/>
                    <p><h1 class="h4 my-0">${teacherFileDTO.teacherFileTitle}</h1></p>
                    <p>${teacherFileDTO.teacherFileContent}</p>
                    <div class="card-footer">
                        <i class="bi bi-floppy2-fill"></i>
                        첨부파일:
                        <a href="/file/download/library/${file.fileDTO.fileIdx}"
                                 class="btn btn-sm btn-link text-decoration-none text-secondary">
                            ${teacherFileDTO.fileDTO.fileOrgName}
                        </a>
                    </div>
                </div>
            </div>

            <form name="frmButton" method="post">
                <div class="gap-2 my-4 d-flex justify-content-between">
                    <input type="hidden" name="teacherFileIdx" value="${teacherFileDTO.teacherFileIdx}" />
                    <div>
                        <button type="button" class="btn btn-secondary btn-sm" onclick="location.href='/teacher/personal/library?${pageDTO.linkUrl}'">목록</button>
                    </div>

                    <div>
                        <c:if test="${sessionScope.memberGrade eq 0 or sessionScope.memberId eq teacherFileDTO.teacherFileMemberId}">
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
            const frm = document.querySelector("form[name='frmButton']");
            frm.action = "/myclass/library/modify?" + urlParams;
            frm.submit();
        });

        document.getElementById('btnDelete').addEventListener('click', () => {
            const frm = document.querySelector("form[name='frmButton']");
            frm.action = "/myclass/library/delete?" + urlParams;
            frm.submit();
        });
    </script>
</body>
</html>
