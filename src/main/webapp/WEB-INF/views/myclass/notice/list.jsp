<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>공지사항</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <div class="container my-5">
                <h1 class="h2 mb-4">공지사항</h1>
                <%
                    List<Map<String, String>> searchSelect = new ArrayList<>();
                    searchSelect.add(Map.of("value", "teacherNoticeTitle", "label", "제목"));
                    searchSelect.add(Map.of("value", "teacherNoticeContent", "label", "내용"));
                    request.setAttribute("searchSelect", searchSelect);
                    request.setAttribute("searchAction", "/myclass/notice/");
                %>
                <jsp:include page="../../common/searchBoxOnlyPage.jsp" />
                <c:if test="${not empty noticeList}">
                    <form name="frmSubmit" method="post">
                        <input type="hidden" name="teacherNoticeIdx" value="" />

                        <table class="table table-hover text-center align-middle">
                            <colgroup>
                                <col style="width: 40px">
                                <col style="width: 40px">
                                <col>
                                <col style="width: 120px">
                                <col style="width: 120px">
                                <col style="width: 90px">
                            </colgroup>
                            <thead class="table-light">
                                <tr>
                                    <th><input type="checkbox" id="checkAll" onclick="toggleAll(this);"/></th>
                                    <th>번호</th>
                                    <th>
                                        <a onclick="applySort('teacherNoticeTitle')">
                                            제목
                                            <c:if test="${pageDTO['sort_by'] eq 'teacherNoticeTitle'}">
                                                ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                            </c:if>
                                        </a>
                                    </th>
                                    <th>
                                        <a onclick="applySort('teacherNoticeCreatedAt')">
                                            작성일
                                            <c:if test="${pageDTO['sort_by'] eq 'teacherNoticeCreatedAt'}">
                                                ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                            </c:if>
                                        </a>
                                    </th>
                                    <th>수정/삭제</th>
                                    <th>원문보기</th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${noticeList}" var="notice" varStatus="status">
                                <tr>
                                    <td><input type="checkbox" name="noticeIdxs" value="${notice.teacherNoticeIdx}"/></td>
                                    <td>${pageDTO.total_count - ((pageDTO.page_no - 1) * pageDTO.page_size) - status.index}</td>
                                    <td class="text-start">${notice.teacherNoticeTitle}</td>
                                    <td>${fn:substring(notice.teacherNoticeCreatedAt, 0, 10)}</td>
                                    <td>
                                        <button type="button" id="btnModify" class="btn btn-sm btn-success">수정</button>
                                        <button type="button" id="btnDeleteOne" class="btn btn-sm btn-danger">삭제</button>
                                    </td>
                                    <td>
                                        <a href="/teacher/personal/library/view?idx=${notice.teacherNoticeIdx}"
                                           class="btn btn-sm btn-link text-decoration-none text-secondary">원문보기
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </form>
                </c:if>
                <c:if test="${empty noticeList}">
                    <div class="alert alert-warning mt-4" role="alert">
                        게시글이 없습니다.
                    </div>
                </c:if>

                <div class="mb-2 mb-md-0 text-center">
                    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/pagingOnlyPage.jsp" />
                </div>

                <div class="d-grid float-md-end">
                    <button class="btn btn-primary" type="button" id="btnRegist" onclick="location.href='/myclass/notice/regist?${pageDTO.linkUrl}'">등록</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function toggleAll(source) {
            const checkboxes = document.querySelectorAll('input[name="noticeIdxs"]');
            checkboxes.forEach(cb => cb.checked = source.checked);
        }

        document.querySelectorAll('#btnModify').forEach(el => {
            el.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                const idx = this.closest("tr").querySelector("input[type='checkbox']").value;

                const frm = document.querySelector("form[name='frmSubmit']");
                frm.teacherNoticeIdx.value = idx;

                frm.action = '/myclass/notice/modify';
                frm.submit();
            });
        });

        document.querySelectorAll('#btnDeleteOne').forEach(el => {
            el.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                if (!confirm("해당 자료를 삭제하시겠습니까?\n삭제된 자료는 복구되지 않습니다.")) return;

                const idx = this.closest("tr").querySelector("input[type='checkbox']").value;

                const frm = document.querySelector("form[name='frmSubmit']");
                frm.teacherNoticeIdx.value = idx;

                frm.action = '/myclass/notice/delete';
                frm.submit();
            });
        });

        document.querySelector('#btnDeleteAll').addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            const items = document.querySelectorAll("input[name='noticeIdxs']:checked");
            if (items.length === 0) {
                alert("삭제할 항목을 선택하세요.");
                return;
            }

            if (!confirm("선택하신 자료를 삭제하시겠습니까?\n삭제된 자료는 복구되지 않습니다.")) return;

            const frm = document.querySelector("form[name='frmSubmit']");
            frm.action = '/myclass/notice/delete-multiple';
            frm.submit();
        });
    </script>
</body>
</html>
