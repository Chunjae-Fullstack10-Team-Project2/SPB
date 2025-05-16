<%--
  Created by IntelliJ IDEA.
  User: sinjihye
  Date: 2025. 5. 16.
  Time: 01:26
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="view" value="${param.view}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>선생님 페이지 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="../../common/sidebarHeader.jsp" %>

<div class="content">
    <div class="container my-5">
        <%@ include file="../../common/breadcrumb.jsp" %>
    </div>
    <!-- 라디오 버튼으로 목록 선택 -->
    <div class="mb-4">
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="viewSelector" id="radioList" value="list" ${view == 'request' ? '' : 'checked'}>
            <label class="form-check-label" for="radioList">선생님 목록</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="viewSelector" id="radioRequest" value="request" ${view == 'request' ? 'checked' : ''}>
            <label class="form-check-label" for="radioRequest">등록 요청 목록</label>
        </div>
    </div>
    <div class="search-box">
        <form name="frmSearch" method="get" action="/admin/teacher/manage" class="p-4">
            <input type="hidden" name="view" id="hiddenView" value="${view}" />
            <div class="row g-2 align-items-center mb-3">
                <div class="col-md-4">
                    <input type="text" name="search_word" class="form-control" placeholder="검색어 입력"
                           value="${search.search_word != null ? search.search_word : ''}"/>
                </div>
                <div class="col-md-3 d-flex gap-1">
                    <button type="submit" class="btn btn-primary flex-fill">검색</button>
                    <button type="button" class="btn btn-link flex-fill text-decoration-none" id="btnReset">초기화</button>
                </div>
            </div>
        </form>
    </div>
    <div id="teacherListSection" style="${view == 'request' ? 'display:none;' : ''}">
        <jsp:include page="teacher_list.jsp" />
    </div>

    <!-- 선생님 등록 요청 목록 -->
    <div id="teacherRequestSection" style="${view == 'request' ? '' : 'display:none;'}">
    <jsp:include page="teacher_request.jsp" />
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/toast.jsp" />
<script src="${pageContext.request.contextPath}/resources/js/toast.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.getElementById('btnReset').addEventListener('click', function() {
            window.location.href="manage";
        })
        const radioList = document.getElementById('radioList');
        const radioRequest = document.getElementById('radioRequest');
        const listSection = document.getElementById('teacherListSection');
        const requestSection = document.getElementById('teacherRequestSection');

        function toggleView() {
            if (radioList.checked) {
                listSection.style.display = 'block';
                requestSection.style.display = 'none';
                document.getElementById('hiddenView').value = 'list';
            } else {
                listSection.style.display = 'none';
                requestSection.style.display = 'block';
                document.getElementById('hiddenView').value = 'request';
            }
        }

        radioList.addEventListener('change', toggleView);
        radioRequest.addEventListener('change', toggleView);

        const pageSizeSelect = document.getElementById('selectPageSize');

        if (pageSizeSelect) {
            pageSizeSelect.addEventListener('change', function () {
                const url = new URL(window.location.href);
                const selectedValue = this.value;
                if (selectedValue && selectedValue !== "undefined") {
                    url.searchParams.set('page_size', selectedValue);
                }
                const currentView = document.querySelector('input[name="viewSelector"]:checked')?.value || 'list';
                url.searchParams.set('view', currentView);

                window.location.href = url.toString();
            });
        }
    });
</script>
</body>
</html>
