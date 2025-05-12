<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>공지사항 수정하기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
        <h1 class="mb-4">공지사항 등록</h1>

        <form name="frmModify" action="/myclass/notice/modify?${pageDTO.linkUrl}" method="post" class="border p-4 rounded bg-light shadow-sm">
            <input type="hidden" name="teacherNoticeIdx" value="${teacherNoticeDTO.teacherNoticeIdx}"/>
            <input type="hidden" name="teacherNoticeMemberId" value="${teacherNoticeDTO.teacherNoticeMemberId}"/>

            <div class="mb-3">
                <label for="teacherNoticeTitle" class="form-label">제목</label>
                <input type="text" class="form-control" name="teacherNoticeTitle" id="teacherNoticeTitle"
                       value="${teacherNoticeDTO.teacherNoticeTitle}" placeholder="제목을 입력하세요." maxlength="50" required />
            </div>

            <div class="mb-3">
                <label for="teacherNoticeContent" class="form-label">내용</label>
                <textarea class="form-control" rows="10" name="teacherNoticeContent" id="teacherNoticeContent"
                          placeholder="내용을 입력하세요" required>${teacherNoticeDTO.teacherNoticeContent}</textarea>
            </div>

            <div class="mb-3 form-check d-flex justify-content-between">
                <div>
                    <input class="form-check-input" type="checkbox" value="1" name="teacherNoticeFixed" id="teacherNoticeFixed"
                    ${teacherNoticeDTO.teacherNoticeFixed == 1 ? "checked" : ""}>
                    <label class="form-check-label" for="teacherNoticeFixed">이 공지사항을 상단에 고정합니다</label>
                </div>
                <div>
                    <button type="submit" class="btn btn-primary">수정</button>
                    <button type="button" class="btn btn-outline-secondary" onclick="history.back();">취소</button>
                </div>
            </div>
        </form>
    </div>

    <script>
        document.querySelector('button[type="submit"]').addEventListener('click', (e) => {
            e.preventDefault();

            const frm = document.forms[0];
            const title = frm.teacherNoticeTitle.value;
            const content = frm.teacherNoticeContent.value;

            if (title == null || title.length < 1 || title.length > 50) {
                alert("제목은 1자 이상 50자 이하로 입력해주세요.");
                frm.teacherNoticeTitle.focus();
                return;
            }
            if (content == null) {
                alert("내용은 필수 항목입니다.");
                frm.teacherNoticeContent.focus();
                return;
            }

            frm.submit();
        });
    </script>
</body>
</html>
