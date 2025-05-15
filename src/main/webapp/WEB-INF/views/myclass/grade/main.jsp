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
        <div class="col-md-6">
            <select name="lectureIdx" class="form-select">
                <option value="" ${param.idx eq null ? "selected" : ""}>강좌를 선택하세요.</option>
                <c:forEach var="item" items="${lectureList}">
                    <option value="${item.lectureIdx}" ${param.idx != null and param.idx == item.lectureIdx ? "selected" : ""}>
                            ${item.lectureTitle}
                    </option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-2">
            <button type="button" id="btnSearch" class="btn btn-primary">조회</button>
        </div>
    </div>
</div>

<script>
    document.getElementById("btnSearch").addEventListener('click', function() {
        const idx = document.querySelector('select[name="lectureIdx"]').value;

        const param = new URLSearchParams(location.search);
        param.set("idx", idx);

        location.href = "/myclass/grade/student?" + param.toString();
    });

    <c:if test="${not empty message}">
        alert("${message}");
    </c:if>
</script>
</body>
</html>
