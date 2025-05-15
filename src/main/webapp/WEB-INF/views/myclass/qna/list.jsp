<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>QnA</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <h1 class="h2 mb-4">QnA</h1>

            <%
                List<Map<String, String>> dateSelect = new ArrayList<>();
                dateSelect.add(Map.of("value", "teacherQnaCreatedAt", "label", "문의 작성일"));
                dateSelect.add(Map.of("value", "teacherQnaAnsweredAt", "label", "문의 답변일"));

                List<Map<String, String>> searchSelect = new ArrayList<>();
                searchSelect.add(Map.of("value", "teacherQnaTitle", "label", "제목"));
                searchSelect.add(Map.of("value", "teacherQnaQContent", "label", "문의 내용"));
                searchSelect.add(Map.of("value", "teacherQnaAnsweredAt", "label", "답변 내용"));
                searchSelect.add(Map.of("value", "teacherQnaQMemberId", "label", "문의 작성자"));

                request.setAttribute("dateSelect", dateSelect);
                request.setAttribute("searchSelect", searchSelect);
                request.setAttribute("searchAction", "/myclass/qna");
            %>
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/searchBoxOnlyPage.jsp" />

            <c:if test="${not empty dtoList}">
                <form name="frmSubmit" method="post">
                    <input type="hidden" name="idx" value="" />
                    <table class="table table-hover text-center align-middle">
                        <thead class="table-light">
                        <colgroup>
                            <col style="width: 40px">
                            <col style="width: 40px">
                            <col>
                            <col style="width: 120px">
                            <col style="width: 120px">
                            <col style="width: 130px">
                            <col style="width: 90px">
                        </colgroup>
                        <tr>
                            <th><input type="checkbox" id="checkAll" onclick="toggleAll(this);"/></th>
                            <th>번호</th>
                            <th>
                                <a onclick="applySort('teacherQnaTitle')">
                                    제목
                                    <c:if test="${pageDTO['sort_by'] eq 'teacherQnaTitle'}">
                                        ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a onclick="applySort('questionMemberName')">
                                    작성자
                                    <c:if test="${pageDTO['sort_by'] eq 'questionMemberName'}">
                                        ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a onclick="applySort('teacherQnaCreatedAt')">
                                    작성일
                                    <c:if test="${pageDTO['sort_by'] eq 'teacherQnaCreatedAt'}">
                                        ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                            <th>답변/삭제</th>
                            <th>원문보기</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${dtoList}" var="dto" varStatus="status">
                            <tr class="clickable-row"
                                data-href="/myclass/qna/view?idx=${dto.teacherQnaIdx}">
                                <td><input type="checkbox" name="idxList" value="${dto.teacherQnaIdx}"/></td>
                                <td>${pageDTO.total_count - ((pageDTO.page_no - 1) * pageDTO.page_size) - status.index}</td>
                                <td class="text-start">
                                    <c:if test="${not empty dto.teacherQnaPwd}">
                                        <i class="bi bi-lock-fill"></i>
                                    </c:if>
                                        ${dto.teacherQnaTitle}
                                </td>
                                <td>${dto.questionMemberName}</td>
                                <td>${fn:substring(dto.teacherQnaCreatedAt, 0, 10)}</td>
                                <td>
                                    <c:if test="${dto.teacherQnaStatus eq 0}">
                                        <button type="button" id="btnRegist" class="btn btn-sm btn-success">답변</button>
                                    </c:if>
                                    <c:if test="${dto.teacherQnaStatus eq 1}">
                                        <button type="button" class="btn btn-sm btn-outline-secondary" disabled>답변완료</button>
                                    </c:if>
                                    <button type="button" id="btnDeleteOne" class="btn btn-sm btn-danger">삭제</button>
                                </td>
                                <td>
                                    <a href="/teacher/personal/qna/view?idx=${dto.teacherQnaIdx}"
                                       class="btn btn-sm btn-link text-decoration-none text-secondary">원문보기
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </form>
            </c:if>
            <c:if test="${empty dtoList}">
                <div class="alert alert-warning mt-4" role="alert">
                    게시글이 없습니다.
                </div>
            </c:if>

            <div class="mb-2 mb-md-0 text-center">
                <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/pagingOnlyPage.jsp" />
            </div>
            <c:if test="${not empty dtoList}">
                <div class="d-flex gap-2 mb-2 justify-content-end">
                    <button class="btn btn-sm btn-danger" type="submit" id="btnDeleteAll">선택삭제</button>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        document.querySelectorAll('.clickable-row').forEach(el => {
            el.addEventListener('mouseover', function () {
                this.style.cursor = "pointer";
            });
            el.addEventListener('click', function () {
                const url = this.dataset.href;
                if (url) window.location.href = url;
            });
        });

        function toggleAll(source) {
            const checkboxes = document.querySelectorAll('input[name="idxList"]');
            checkboxes.forEach(cb => cb.checked = source.checked);
        }

        document.querySelectorAll('#btnRegist').forEach(el => {
            el.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();

                const idx = this.closest("tr").querySelector("input[type='checkbox']").value;

                const params = new URLSearchParams(location.search);
                params.set("idx", idx);

                location.href = "/myclass/qna/regist?" + params.toString();
            });
        });

        document.querySelectorAll('#btnDeleteOne').forEach(el => {
            el.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();

                if (!confirm("해당 자료를 삭제하시겠습니까?\n삭제된 자료는 복구되지 않습니다.")) return;

                const idx = this.closest("tr").querySelector("input[type='checkbox']").value;

                const frm = document.querySelector("form[name='frmSubmit']");
                frm.idx.value = idx;

                const params = new URLSearchParams(location.search);

                frm.action = '/myclass/qna/delete?' + params.toString();
                frm.submit();
            });
        });

        document.querySelector('#btnDeleteAll').addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();

            const items = document.querySelectorAll("input[name='noticeIdxs']:checked");
            if (items.length === 0) {
                alert("삭제할 항목을 선택하세요.");
                return;
            }

            if (!confirm("선택하신 자료를 삭제하시겠습니까?\n삭제된 자료는 복구되지 않습니다.")) return;

            const frm = document.querySelector("form[name='frmSubmit']");

            const params = new URLSearchParams(location.search);

            frm.action = '/myclass/qna/delete-multiple?' + params.toString();
            frm.submit();
        });

        <c:if test="${not empty message}">
            alert("${message}");
        </c:if>
    </script>
</body>
</html>
