<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>성적 관리</title>
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <div class="container my-5">
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
            <h1 class="h2 mb-4">성적 관리</h1>
            <%
                List<Map<String, String>> searchSelect = new ArrayList<>();
                searchSelect.add(Map.of("value", "lectureRegisterMemberId", "label", "회원ID"));
                searchSelect.add(Map.of("value", "lectureGradeFeedback", "label", "내용"));

                request.setAttribute("searchSelect", searchSelect);
                request.setAttribute("searchAction", "/myclass/grade");
            %>
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/searchBoxOnlyPage.jsp" />

            <c:if test="${not empty studentList}">
                <form name="frmSubmit" method="post">
                    <input type="hidden" name="idx" value="" />
                    <table class="table table-hover text-center align-middle">
                        <colgroup>
                            <col style="width: 40px;">
                            <col style="width: 40px;">
                            <col style="width: 120px;">
                            <col>
                            <col style="width: 120px;">
                            <col style="width: 40px;">
                            <col style="width: 100px;">
                        </colgroup>
                        <thead class="table-light">
                            <tr>
                                <th><input type="checkbox" id="checkAll" onclick="toggleAll(this);"/></th>
                                <th>번호</th>
                                <th>
                                    <a onclick="applySort('lectureRegisterMemberId')">
                                        회원ID
                                        <c:if test="${pageDTO['sort_by'] eq 'lectureRegisterMemberId'}">
                                            ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                        </c:if>
                                    </a>
                                </th>
                                <th>
                                    <a onclick="applySort('lectureTitle')">
                                        강좌명
                                        <c:if test="${pageDTO['sort_by'] eq 'lectureTitle'}">
                                            ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                        </c:if>
                                    </a>
                                </th>
                                <th>
                                    <a onclick="applySort('lectureRegisterStartedAt')">
                                        수강시작일
                                        <c:if test="${pageDTO['sort_by'] eq 'lectureRegisterStartedAt'}">
                                            ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                        </c:if>
                                    </a>
                                </th>
                                <th>
                                    <a onclick="applySort('lectureGradeScore')">
                                        점수
                                        <c:if test="${pageDTO['sort_by'] eq 'lectureGradeScore'}">
                                            ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                        </c:if>
                                    </a>
                                </th>
                                <th>성적입력</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${studentList}" var="student" varStatus="status">
                                <tr class="clickable-row"
                                    <c:if test="${student.lectureGradeIdx != null}">
                                        data-href="/myclass/grade/view?idx=${student.lectureGradeIdx}&${pageDTO.linkUrl}"
                                    </c:if>>

                                    <td>
                                        <input type="checkbox" name="idxList"
                                               value="${student.lectureGradeIdx != null ? student.lectureGradeIdx : ""}"
                                               ${student.lectureGradeScore == null ? "disabled" : ""}/>
                                    </td>
                                    <td>${(pageDTO.page_no - 1) * pageDTO.page_size + status.index + 1}</td>
                                    <td>${student.lectureRegisterMemberId}</td>
                                    <td class="text-start">
                                        <p class="text-muted small mb-1">[ ${student.teacherName} 선생님 ]</p>
                                            ${student.lectureTitle}
                                    </td>
                                    <td>${fn:substring(student.lectureRegisterStartedAt, 0, 10)}</td>
                                    <td>${student.lectureGradeScore != null ? student.lectureGradeScore : "-" }</td>
                                    <td>
                                        <c:if test="${student.lectureGradeScore != null}">
                                            <button type="button" class="btn btn-sm btn-success btnModify">수정</button>
                                            <button type="button" class="btn btn-sm btn-danger btnDeleteOne">삭제</button>
                                        </c:if>
                                        <c:if test="${student.lectureGradeScore == null}">
                                            <button type="button" class="btn btn-sm btn-primary btnRegist">성적등록</button>
                                        </c:if>
                                    </td>
                                    <input type="hidden" name="lectureIdx" value="${student.lectureRegisterRefIdx}" />
                                    <input type="hidden" name="memberId" value="${student.lectureRegisterMemberId}" />
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </form>
            </c:if>
            <c:if test="${empty studentList}">
                <div class="alert alert-warning mt-4" role="alert">
                    게시글이 없습니다.
                </div>
            </c:if>

            <div class="mb-2 mb-md-0 text-center">
                <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/pagingOnlyPage.jsp" />
            </div>

            <c:if test="${not empty studentList}">
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
            const checkboxes = document.querySelectorAll('input[name="idxList"]:not(:disabled)');
            checkboxes.forEach(cb => cb.checked = source.checked);
        }

        document.querySelectorAll('input[type="checkbox"]').forEach(el => {
            el.addEventListener('click', function (e) {
                e.stopPropagation();
            });
        });

        document.querySelectorAll('.btnRegist').forEach(el => {
           el.addEventListener('click', function (e) {
               e.preventDefault();
               e.stopPropagation();

               const lectureIdx = this.closest("tr").querySelector("input[name='lectureIdx']").value;
               const memberId = this.closest("tr").querySelector("input[name='memberId']").value;

               const params = new URLSearchParams(location.search);
               params.set("lectureIdx", lectureIdx);
               params.set("memberId", memberId);

               location.href = "/myclass/grade/regist?" + params.toString();
           });
        });

        document.querySelectorAll('.btnModify').forEach(el => {
           el.addEventListener('click', function (e) {
              e.preventDefault();
              e.stopPropagation();

               const idx = this.closest("tr").querySelector("input[type='checkbox']").value;
               const params = new URLSearchParams(location.search);
               params.set("idx", idx);

               location.href = "/myclass/grade/modify?" + params.toString();
           });
        });

        document.querySelectorAll('.btnDeleteOne').forEach(el => {
           el.addEventListener('click', function (e) {
               e.preventDefault();
               e.stopPropagation();

               if (!confirm("해당 성적표를 삭제하시겠습니까?\n삭제된 성적표는 복구되지 않습니다.")) return;

               const idx = this.closest("tr").querySelector("input[type='checkbox']").value;

               const frm = document.querySelector("form[name='frmSubmit']");
               frm.idx.value = idx;

               const params = new URLSearchParams(location.search);
               frm.action = '/myclass/grade/delete?' + params.toString();
               frm.method = 'post';
               frm.submit();
           });
        });

        document.getElementById('btnDeleteAll').addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();

                const items = document.querySelectorAll('input[name="idxList"]:checked');
                if (items.length === 0) {
                    alert("삭제할 항목을 선택하세요.");
                    return;
                }
                if (!confirm("선택하신 성적표를 삭제하시겠습니까?\n삭제된 성적표는 복구되지 않습니다.")) return;

                const frm = document.querySelector("form[name='frmSubmit']");

                const params = new URLSearchParams(location.search);
                frm.action = '/myclass/grade/delete-multiple?' + params.toString();
                frm.submit();
        });

        <c:if test="${not empty message}">
            alert("${message}");
        </c:if>
    </script>
</body>
</html>
