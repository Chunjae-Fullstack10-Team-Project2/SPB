<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>과목별 선생님</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
<body>
<%@ include file="../common/sidebarHeader.jsp" %>
<div class="content">
    <div class="container my-5">
        <h3 class="mb-4">과목별 선생님</h3>

        <!-- 과목 탭 -->
        <div class="subject-tab">
            <c:forEach var="subject" items="${subjectList}">
                <a href="?subject=${subject}" class="${param.subject eq subject ? 'active' : ''}">
                        ${subject}
                </a>
            </c:forEach>
        </div>

        <!-- 선생님 리스트 -->
        <div class="teacher-list">
            <c:forEach var="teacher" items="${teacherDTO}">
                <div class="teacher-card" data-id="${teacher.teacherId}">
                    <img src="${teacher.teacherProfileImg}" alt="${teacher.teacherName}">
                    <div class="name">${teacher.teacherName} 선생님</div>
                </div>
            </c:forEach>
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