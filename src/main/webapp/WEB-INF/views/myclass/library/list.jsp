<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>자료실</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
        <div class="container my-5">
            <h1 class="h2 mb-4">자료실</h1>

            <%
                List<Map<String, String>> searchSelect = new ArrayList<>();
                searchSelect.add(Map.of("value", "teacherFileTitle", "label", "제목"));
                searchSelect.add(Map.of("value", "teacherFileContent", "label", "내용"));
                request.setAttribute("searchSelect", searchSelect);
                request.setAttribute("searchAction", "/myclass/library");
            %>

            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/searchBoxOnlyPage.jsp" />

            <div class="d-flex gap-2 mb-2 justify-content-end">
                <button class="btn btn-sm btn-danger" type="submit" id="btnDeleteAll">선택삭제</button>
                <button class="btn btn-sm btn-primary" type="button" id="btnRegist" onclick="location.href='/myclass/library/regist?${pageDTO.linkUrl}'">등록</button>
            </div>

            <form name="frmDelete" method="post">
                <input type="hidden" name="teacherFileIdx" value="" />

                <table class="table table-hover text-center align-middle">
                    <thead class="table-light">
                        <tr>
                            <th><input type="checkbox" id="checkAll" onclick="toggleAll(this);"/></th>
                            <th>
                                <a onclick="applySort('teacherFileTitle')">제목
                                    <c:if test="${pageDTO['sort_by'] eq 'teacherFileTitle'}">
                                        ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a onclick="applySort('teacherFileCreatedAt')">등록일
                                    <c:if test="${pageDTO['sort_by'] eq 'teacherFileCreatedAt'}">
                                        ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                            <th>첨부파일</th>
                            <th>삭제</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty fileList}">
                            <tr>
                                <td colspan="5">등록된 자료가 없습니다.</td>
                            </tr>
                        </c:if>
                        <c:forEach items="${fileList}" var="file" varStatus="status">
                            <tr>
                                <td>
                                    <input type="checkbox" name="fileIdxs" value="${file.teacherFileIdx}"/>
                                </td>
                                <td class="text-start">
                                    <a href="/teacher/personal/library/view?idx=${file.teacherFileIdx}&${pageDTO.linkUrl}"
                                       class="text-decoration-none text-dark">
                                            ${file.teacherFileTitle}
                                    </a>
                                </td>
                                <td>${fn:substring(file.teacherFileCreatedAt, 0, 10)}</td>
                                <td>
                                    <a href="/file/download/library/${file.fileDTO.fileIdx}"
                                       class="btn btn-sm btn-link text-decoration-none text-secondary">
                                        <i class="bi bi-download"></i> ${file.fileDTO.fileOrgName}
                                    </a>
                                </td>
                                <td><button type="submit" id="btnDeleteOne" class="btn btn-sm btn-outline-dark"><i class="bi bi-trash"></i></button></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </form>
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/pagingOnlyPage.jsp" />
        </div>
    </div>

    <script>
        function toggleAll(source) {
            const checkboxes = document.querySelectorAll('input[name="fileIdxs"]');
            checkboxes.forEach(cb => cb.checked = source.checked);
        }

        document.querySelectorAll('#btnDeleteOne').forEach(el => {
           el.addEventListener('click', function(e) {
               e.preventDefault();
               e.stopPropagation();

               if (!confirm("해당 자료를 삭제하시겠습니까?\n삭제된 자료는 복구되지 않습니다.")) return;

               const idx = this.closest("tr").querySelector("input[type='checkbox']").value;

               const frm = document.querySelector("form[name='frmDelete']");
               frm.teacherFileIdx.value = idx;

               frm.action = '/myclass/library/delete';
               frm.submit();
           });
        });

        document.querySelector('#btnDeleteAll').addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            const items = document.querySelectorAll("input[name='fileIdxs']:checked");
            if (items.length === 0) {
                alert("삭제할 항목을 선택하세요.");
                return;
            }

            if (!confirm("선택하신 자료를 삭제하시겠습니까?\n삭제된 자료는 복구되지 않습니다.")) return;

            const frm = document.querySelector("form[name='frmDelete']");
            frm.action = '/myclass/library/delete-multiple';
            frm.submit();
        });
    </script>
</body>
</html>
