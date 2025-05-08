<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>선생님 공지사항</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background-color: #fff;
            color: #333;
            line-height: 1.5;
        }

        .page-container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            border: 1px solid #ddd;
        }

        .main-container {
            display: flex;
        }

        .sidebar {
            width: 150px;
            border-right: 1px solid #ddd;
            padding: 15px;
        }

        .sidebar-title {
            font-weight: bold;
            margin-bottom: 15px;
        }

        .sidebar-menu {
            list-style: none;
        }

        .sidebar-menu li {
            margin-bottom: 10px;
        }

        .sidebar-menu a {
            text-decoration: none;
            color: #333;
        }

        .sidebar-menu a:hover {
            text-decoration: underline;
        }

        .content {
            flex: 1;
            padding: 20px;
        }

        .teacher-name {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .notice-title {
            font-weight: bold;
            margin-bottom: 15px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f5f5f5;
        }

        td.title {
            text-align: left;
        }

        @media (max-width: 768px) {
            .main-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid #ddd;
            }
        }
    </style>
</head>
<body>
<div class="page-container">
    <div class="main-container">
        <div class="sidebar">
            <div class="sidebar-title">SIDEMENU</div>
            <ul class="sidebar-menu">
                <li><strong><a href="#">공지</a></strong></li>
                <li><a href="#">Q&A</a></li>
                <li><a href="#">자료실</a></li>
            </ul>
        </div>

        <div class="content">
            <div class="teacher-name">OOO 선생님</div>

            <div class="notice-title">공지사항</div>

            <table>
                <thead>
                <tr>
                    <th width="10%">no</th>
                    <th width="50%">제목</th>
                    <th width="20%">등록일</th>
                    <th width="20%">조회수</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>1</td>
                    <td class="title">공지입니다</td>
                    <td>2025-04-28</td>
                    <td>100</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
