<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>과목별 선생님</title>
    <style>
        .subject-tab {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            border-bottom: 2px solid #ddd;
            margin-bottom: 30px;
        }
        .subject-tab a {
            padding: 8px 16px;
            border: 1px solid #ddd;
            border-bottom: none;
            background: #f9f9f9;
            color: #333;
            text-decoration: none;
            transition: background-color 0.2s ease;
        }
        .subject-tab a.active {
            color: #6f42c1;
            background-color: white;
            border-color: #6f42c1;
            font-weight: bold;
        }
        .subject-tab a:hover {
            background-color: #eee;
        }

        .teacher-list {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .teacher-card {
            width: 23%;
            padding: 15px;
            border: 1px solid #ddd;
            text-align: center;
            background-color: #fff;
            cursor: pointer;
            transition: box-shadow 0.2s ease;
        }
        .teacher-card:hover {
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .teacher-card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            margin-bottom: 10px;
        }
        .teacher-card .name {
            font-weight: bold;
        }
        @media (max-width: 768px) {
            .teacher-card { width: 48%; }
        }
        @media (max-width: 480px) {
            .teacher-card { width: 100%; }
        }
    </style>
</head>
<body class="bg-light-subtle">
<%@ include file="../common/sidebarHeader.jsp" %>
<div class="content">
    <div class="container my-5">
        <h3 class="mb-4">과목별 선생님</h3>
            <%
            List<Map<String, String>> searchTypeOptions = new ArrayList<>();
            searchTypeOptions.add(Map.of("value", "lectureTeacherId", "label", "선생님"));
            request.setAttribute("searchTypeOptions", searchTypeOptions);
            request.setAttribute("searchAction", "/teacher/main");
            request.setAttribute("isTeacher", "Y");
        %>
        <jsp:include page="../common/searchBox.jsp"/>
        <div class="d-flex flex-wrap gap-2 border-bottom pb-2 mb-4">
            <a href="/teacher/main"
               class="btn btn-outline-secondary rounded-pill
              ${empty param.subject ? 'active btn-primary text-white border-primary' : ''}">
                전체
            </a>
            <c:forEach var="subject" items="${subjectList}">
                <a href="?subject=<c:out value='${subject}'/>"
                   class="btn btn-outline-secondary rounded-pill
                      ${param.subject eq subject ? 'active btn-primary text-white border-primary' : ''}">
                        <c:out value='${subject}'/>
                </a>
            </c:forEach>
        </div>

        <div class="row row-cols-2 row-cols-md-4 g-4">
            <c:choose>
                <c:when test="${not empty teacherDTO}">
                    <c:forEach var="teacher" items="${teacherDTO}">
                        <div class="col">
                            <div class="card text-center h-100 border-0 shadow-sm" role="button"
                                 onclick="location.href='/teacher/personal?teacherId=${teacher.teacherId}'">
                                <div class="card-body d-flex flex-column align-items-center">
                                    <div class="rounded-circle overflow-hidden border mb-3"
                                         style="width: 120px; height: 120px;">
                                        <img src="/upload/<c:out value='${teacher.teacherProfileImg}'/>" alt="<c:out value='${teacher.teacherName}'/>"
                                             class="img-fluid w-100 h-100" style="object-fit: cover;"
                                             onerror="this.src='${cp}/resources/img/default_profileImg.png';">
                                    </div>
                                    <div class="fw-semibold"><c:out value='${teacher.teacherName}'/> 선생님</div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div>검색 결과가 없습니다.</div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="mt-4 text-center">
            <%@ include file="../common/paging.jsp" %>
        </div>
    </div>
</div>
<script>
    document.querySelectorAll(".teacher-card").forEach(card => {
        card.addEventListener("click", () => {
            const teacherId = card.getAttribute("data-id");
            window.location.href = "/teacher/personal?teacherId=" + teacherId;
        });
    });
</script>
</body>
</html>