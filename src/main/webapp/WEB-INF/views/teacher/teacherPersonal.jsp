<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>선생님 메인</title>
    <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Malgun Gothic', sans-serif;
        }

        body {
            background-color: #fff;
            color: #333;
            line-height: 1.5;
        }

        .container {
            display: flex;
            max-width: 1200px;
            margin: 0 auto;
        }

        .sidebar {
            width: 200px;
            border-right: 1px solid #ddd;
            padding: 20px;
        }

        .sidebar-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .sidebar-menu {
            list-style: none;
        }

        .sidebar-menu-item {
            margin-bottom: 5px;
        }

        .sidebar-menu-link {
            display: block;
            padding: 8px 10px;
            color: #333;
            text-decoration: none;
        }

        .sidebar-menu-link:hover {
            background-color: #f5f5f5;
        }

        .sidebar-menu-link.active {
            background-color: #eef2ff;
            color: #4a6fdc;
        }

        .main-content {
            flex: 1;
            padding: 20px;
        }

        .section {
            margin-bottom: 30px;
        }

        /* Teacher Profile */
        .teacher-profile {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 30px;
        }

        .profile-image {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 1px solid #ddd;
            overflow: hidden;
        }

        .profile-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-info h1 {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .profile-info p {
            color: #666;
        }

        .card {
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-bottom: 20px;
        }

        .card-body {
            padding: 15px;
        }

        .card-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .card-text {
            color: #666;
            margin-bottom: 15px;
        }

        .badges {
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
        }

        .badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            background-color: #f5f5f5;
            color: #666;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .section-title {
            font-size: 18px;
            font-weight: bold;
        }

        .separator {
            height: 1px;
            background-color: #ddd;
            margin: 10px 0;
        }

        .table-container {
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f5f5f5;
            font-weight: normal;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .course-title {
            display: flex;
            align-items: center;
        }

        .course-badge {
            margin-left: 8px;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 12px;
            background-color: #f5f5f5;
        }

        .course-badge.popular {
            background-color: #fff0f0;
            color: #e53e3e;
        }

        .course-badge.new {
            background-color: #eef2ff;
            color: #4a6fdc;
        }

        .actions {
            display: flex;
            justify-content: flex-end;
            gap: 5px;
        }

        .btn-icon {
            width: 50px;
            height: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            background-color: transparent;
            border: 1px solid #ddd;
            cursor: pointer;
        }

        .btn-sm {
            padding: 4px 8px;
            font-size: 12px;
        }

        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid #ddd;
            }

            .teacher-profile {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
<%@ include file="../common/header.jsp" %>
<div class="container">
    <aside class="sidebar">
        <div class="sidebar-title">SIDEMENU</div>
        <ul class="sidebar-menu">
            <li class="sidebar-menu-item">
                <a href="#" class="sidebar-menu-link active">공지</a>
            </li>
            <li class="sidebar-menu-item">
                <a href="#" class="sidebar-menu-link">Q&A</a>
            </li>
            <li class="sidebar-menu-item">
                <a href="#" class="sidebar-menu-link">자료실</a>
            </li>
        </ul>
    </aside>

    <main class="main-content">
        <div class="teacher-profile">
            <div class="profile-image">
                <img src="${teacherDTO.teacherProfileImg}" alt="선생님 프로필">
            </div>
            <div class="profile-info">
                <h1>${teacherDTO.teacherName} 선생님</h1>
                <p>${teacherDTO.teacherSubject} 전문 강사</p>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <h2 class="card-title">선생님 설명</h2>
                <p class="card-text">
                    ${teacherDTO.teacherIntro}
                </p>
            </div>
        </div>

        <div class="section">
            <div class="section-header">
                <h2 class="section-title">개설강좌</h2>
            </div>
            <div class="separator"></div>

            <div class="table-container">
                <table>
                    <thead>
                    <tr>
                        <th>no</th>
                        <th>제목</th>
                        <th style="text-align: right;"></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="lecture" items="${lectureList}">
                        <tr>
                            <td>${lecture.lectureIdx}</td>
                            <td>
                                <div class="course-title">
                                    <a href="/teacher/lecture?lectureIdx=${lecture.lectureIdx}">${lecture.lectureTitle}</a>
                                </div>
                            </td>
                            <td>
                                <div class="actions">
                                        <button class="btn-icon" >
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
                                            </svg>
                                        </button>
                                        <button class="btn btn-primary btn-sm" id="btnAddCart" onclick="addCart(${lecture.lectureIdx})">장바구니</button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<script>
    // 북마크 버튼 기능
    document.querySelectorAll('.btn-icon').forEach(button => {
        button.addEventListener('click', function() {
            this.classList.toggle('active');
            if (this.classList.contains('active')) {
                this.style.color = '#e53e3e';
            } else {
                this.style.color = 'inherit';
            }
        });
    });

    function addCart(lectureIdx) {
        const data = {
            cartLectureIdx: lectureIdx,
            cartMemberId: "dog109"
        };
        $.ajax({
            url: '/payment/addCart',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function (response) {
                // ✅ 성공 시 콜백
                console.log('서버 응답:', response);
                if(response == 999){
                    alert("해당 강좌가 이미 장바구니에 존재합니다.");
                } else {
                    alert("해당 강좌를 장바구니에 담았습니다.")
                }
                const goCart = confirm("장바구니로 이동하시겠습니까?");
                if(goCart){
                    window.location.href = "/payment/cart?memberId=dog109";
                }
            },
            error: function (xhr, status, error) {
                console.error('오류 발생:', error);
                console.error('상태 코드:', xhr.status); // 예: 400, 404, 500
                console.error('서버 응답 텍스트:', xhr.responseText); // ← 실제 에러 메시지 (HTML/JSON 등)
                console.error('status:', status); // 예: "error"
            }
        });
    }

</script>
</body>
</html>
