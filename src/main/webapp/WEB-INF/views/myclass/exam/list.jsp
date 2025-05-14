<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>시험 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
<div class="content">
    <div class="container my-5">
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
        <div class="container my-5">
            <h1 class="h2 mb-4">시험 관리</h1>
            <%
                List<Map<String, String>> dateSelect = new ArrayList<>();
                dateSelect.add(Map.of("value", "examDate", "label", "시험기간"));
                dateSelect.add(Map.of("value", "examCreatedAt", "label", "등록일"));

                List<Map<String, String>> searchSelect = new ArrayList<>();
                searchSelect.add(Map.of("value", "examTitle", "label", "제목"));
                searchSelect.add(Map.of("value", "examDescription", "label", "내용"));

                request.setAttribute("dateSelect", dateSelect);
                request.setAttribute("searchSelect", searchSelect);
                request.setAttribute("searchAction", "/myclass/exam/");
            %>
            <jsp:include page="../../common/searchBoxOnlyPage.jsp" />

            <c:if test="${not empty examList}">
                <form name="frmSubmit" method="post">
                    <input type="hidden" name="examIdx" value="" />

                    <table class="table table-hover text-center align-middle">
                        <colgroup>
                            <col style="width: 40px">
                            <col style="width: 40px">
                            <col>
                            <col style="width: 220px">
                            <col style="width: 120px">
                            <col style="width: 60px">
                            <col style="width: 90px">
                        </colgroup>
                        <thead class="table-light">
                        <tr>
                            <th><input type="checkbox" id="checkAll" onclick="toggleAll(this);"/></th>
                            <th>번호</th>
                            <th>
                                <a onclick="applySort('examTitle')">
                                    제목
                                    <c:if test="${pageDTO['sort_by'] eq 'examTitle'}">
                                        ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a onclick="applySort('examStartDate')">
                                    시험기간
                                    <c:if test="${pageDTO['sort_by'] eq 'examStartDate'}">
                                        ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a onclick="applySort('examCreatedAt')">
                                    작성일
                                    <c:if test="${pageDTO['sort_by'] eq 'examCreatedAt'}">
                                        ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                            <th>삭제</th>
                            <th>원문보기</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${examList}" var="item" varStatus="status">
                            <tr>
                                <td><input type="checkbox" name="lectureIdxs" value="${item.examIdx}"/></td>
                                <td>${(pageDTO.page_no - 1) * pageDTO.page_size + status.index + 1}</td>
                                <td class="text-start">
                                    <p class="text-muted small mb-2">${item.lectureTitle}</p>
                                    ${item.examTitle}
                                </td>
                                <td><c:if test="${item.examStartDate != null and item.examEndDate != null}">${fn:substring(item.examStartDate, 0, 10)} ~ ${fn:substring(item.examEndDate, 0, 10)}</c:if></td>
                                <td>${fn:substring(item.examCreatedAt, 0, 10)}</td>
                                <td><button type="button" id="btnDeleteOne" class="btn btn-sm btn-danger">삭제</button></td>
                                <td>
                                    <a href=""
                                       class="btn btn-sm btn-link text-decoration-none text-secondary">원문보기
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </form>
            </c:if>

            <c:if test="${empty examList}">
                <div class="alert alert-warning mt-4" role="alert">
                    게시글이 없습니다.
                </div>
            </c:if>

            <div class="mb-2 mb-md-0 text-center">
                <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/pagingOnlyPage.jsp" />
            </div>

            <div class="d-flex gap-2 mb-2 justify-content-end">
                <button class="btn btn-sm btn-danger" type="submit" id="btnDeleteAll">선택삭제</button>
                <button class="btn btn-sm btn-primary" type="button" id="btnRegist" onclick="location.href='/myclass/exam/regist?${pageDTO.linkUrl}'">등록</button>
            </div>
        </div>
    </div>
</div>

<script>
    function toggleAll(source) {
        const checkboxes = document.querySelectorAll('input[name="lectureIdxs"]');
        checkboxes.forEach(cb => cb.checked = source.checked);
    }

    document.querySelectorAll('#btnModify').forEach(el => {
        el.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            const idx = this.closest("tr").querySelector("input[type='checkbox']").value;

            const frm = document.querySelector("form[name='frmSubmit']");
            frm.examLectureIdx.value = idx;

            frm.action = '/myclass/exam/modify';
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
            frm.examLectureIdx.value = idx;

            frm.action = '/myclass/exam/delete';
            frm.submit();
        });
    });

    document.querySelector('#btnDeleteAll').addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();

        const items = document.querySelectorAll("input[name='lecutreIdxs']:checked");
        if (items.length === 0) {
            alert("삭제할 항목을 선택하세요.");
            return;
        }

        if (!confirm("선택하신 자료를 삭제하시겠습니까?\n삭제된 자료는 복구되지 않습니다.")) return;

        const frm = document.querySelector("form[name='frmSubmit']");
        frm.action = '/myclass/exam/delete-multiple';
        frm.submit();
    });
</script>
</body>
</html>
