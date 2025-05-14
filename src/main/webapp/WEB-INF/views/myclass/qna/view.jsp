<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>QnA 상세보기</title>
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <h1 class="h2 mb-4">QnA 상세보기</h1>

            <div class="border p-4 rounded bg-light shadow-sm mb-3">
                <div class="mb-3">
                    <p class="form-label">문의자</p>
                    <p class="form-control">${dto.teacherQnaQMemberId}</p>
                </div>

                <div class="mb-3">
                    <p class="form-label">문의제목</p>
                    <p class="form-control">${dto.teacherQnaTitle}</p>
                </div>

                <div class="mb-3">
                    <p class="form-label">문의내용</p>
                    <p class="form-control" style="height: 254px;">${dto.teacherQnaQContent}</p>
                </div>

                <div class="d-flex justify-content-between text-muted small">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="checkDefault" readonly
                               ${dto.teacherQnaPwd != null ? "checked" : ""}>
                        <label class="form-check-label" for="checkDefault">
                            비밀글
                        </label>
                    </div>
                    <p>등록일: ${fn:replace(dto.teacherQnaCreatedAt, 'T', ' ')}</p>
                </div>
            </div>

            <c:if test="${dto.teacherQnaStatus eq 1}">
                <div class="border p-4 rounded bg-light shadow-sm mb-3">
                    <div class="mb-3">
                        <p class="form-label">답변자</p>
                        <p class="form-control">${dto.teacherQnaAMemberId}</p>
                    </div>

                    <div class="mb-3">
                        <p class="form-label">답변내용</p>
                        <p class="form-control" style="height: 254px;">${dto.teacherQnaAContent}</p>
                    </div>

                    <div class="text-muted small">
                        등록일: ${fn:replace(dto.teacherQnaAnsweredAt, 'T', ' ')}
                    </div>
                </div>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mt-3">
                <div>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="location.href='/myclass/qna?${pageDTO.linkUrl}'">목록</button>
                </div>

                <div>
                    <c:if test="${sessionScope.memberId eq dto.teacherQnaAMemberId}">
                        <form name="frmSubmit">
                            <input type="hidden" name="idx" value="${dto.teacherQnaIdx}" />
                            <c:if test="${dto.teacherQnaStatus eq 0}">
                                <button type="button" class="btn btn-success btn-sm" id="btnRegist">답변</button>
                            </c:if>
                            <button type="button" class="btn btn-danger btn-sm" id="btnDelete">삭제</button>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script>
        const urlParams = "${pageDTO.linkUrl}";

        document.getElementById('btnRegist').addEventListener('click', () => {
            const frm = document.querySelector('form[name="frmSubmit"]');
            frm.action = "/myclass/qna/regist?" + urlParams;
            frm.method = "get";
            frm.submit();
        });

        document.getElementById('btnDelete').addEventListener('click', () => {
            const frm = document.querySelector('form[name="frmSubmit"]');
            frm.action = "/myclass/qna/delete?" + urlParams;
            frm.method = "post";
            frm.submit();
        });

        <c:if test="${not empty message}">
            alert("${message}");
        </c:if>
    </script>
</body>
</html>
