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

        <c:if test="${not empty studentList}">
            <form name="frmSubmit" method="post">
                <input type="hidden" name="idx" value="" />
                <table class="table table-hover text-center align-middle">
                    <thead class="table-light">
                    <tr>
                        <th><input type="checkbox" id="checkAll" onclick="toggleAll(this);"/></th>
                        <th>번호</th>
                        <th>
                            <a onclick="applySort('lectureRegisterMemberId')">
                                수강생 아이디
                                <c:if test="${pageDTO['sort_by'] eq 'lectureRegisterMemberId'}">
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
                        <th>점수</th>
                        <th>성적입력</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${studentList}" var="student" varStatus="status">
                        <tr class="clickable-row"
                            data-href="/myclass/grade/view?idx=${student.lectureRegisterIdx}&${pageDTO.linkUrl}">
                            <td><input type="checkbox" name="idxList" value="${student.lectureRegisterIdx}"/></td>
                            <td>${(pageDTO.page_no - 1) * pageDTO.page_size + status.index + 1}</td>
                            <td>${student.lectureRegisterMemberId}</td>
                            <td>${fn:substring(student.lectureRegisterStartedAt, 0, 10)}</td>
                            <td>${student.lectureGradeRegistered eq true ? student.lectureGradeScore + '점' : ''}</td>
                            <td>
                                <c:if test="${student.lectureGradeRegistered eq true}">
                                    <button type="button" class="btn btn-sm btn-success btnModify">수정</button>
                                    <button type="button" class="btn btn-sm btn-danger btnDeleteOne">삭제</button>
                                </c:if>
                                <c:if test="${student.lectureGradeRegistered eq false}">
                                    <button type="button" class="btn btn-sm btn-primary btnRegist">수정</button>
                                </c:if>
                            </td>
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
        const checkboxes = document.querySelectorAll('input[name="noticeIdxs"]');
        checkboxes.forEach(cb => cb.checked = source.checked);
    }

    function applySort(column) {
        const currentColumn = '${param["sort_by"]}';
        const currentOrder = '${param["sort_direction"]}';
        const nextOrder = (currentColumn === column && currentOrder === 'asc') ? 'desc' : 'asc';

        const url = new URL(location.href);
        const params = url.searchParams;
        params.set('sort_by', column);
        params.set('sort_direction', nextOrder);

        location.href = url.toString();
    }

    <c:if test="${not empty message}">
        alert("${message}");
    </c:if>
</script>
</body>
</html>
