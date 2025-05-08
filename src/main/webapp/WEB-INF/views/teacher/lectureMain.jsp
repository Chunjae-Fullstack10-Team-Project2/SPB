<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>강좌 페이지</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Malgun Gothic', sans-serif;
        }

        .lecture-container {
            max-width: 1000px;
            margin: 0 auto;
            border: 1px solid #ccc;
        }

        .content {
            padding: 20px;
        }

        .title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .course-info {
            margin-bottom: 30px;
        }

        .course-name {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .course-intro {
            line-height: 1.6;
            color: #555;
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border: 1px solid #eee;
            border-radius: 5px;
        }

        .lecture-list {
            width: 100%;
            border-collapse: collapse;
        }

        .lecture-list th {
            background-color: #f5f5f5;
            padding: 10px;
            text-align: left;
            border-top: 1px solid #ddd;
            border-bottom: 1px solid #ddd;
        }

        .lecture-list td {
            padding: 12px 10px;
            border-bottom: 1px solid #eee;
        }

        .lecture-number {
            width: 60px;
            text-align: center;
        }

        .lecture-runtime {
            width: 100px;
            text-align: center;
        }

        .lecture-title {
            cursor: pointer;
        }

        .lecture-title:hover {
            color: #0066cc;
        }

        @media (max-width: 768px) {
            .lecture-runtime {
                width: 80px;
            }
        }
    </style>
</head>
<body>
<%@ include file="../common/header.jsp" %>
<div class="lecture-container">
    <div class="content">
        <div class="title">강좌 페이지</div>

        <div class="course-info">
            <div class="course-name">${lectureDTO.lectureTitle}</div>
            <div class="course-intro">
                ${lectureDTO.lectureDescription}
            </div>
        </div>

        <table class="lecture-list">
            <thead>
            <tr>
                <th class="lecture-number">번호</th>
                <th>제목</th>
                <th class="lecture-runtime">런타임</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="chapter" items="${chapterList}">
                <tr>
                    <td class="lecture-number">${chapter.chapterIdx}</td>
                    <td class="lecture-title">${chapter.chapterName}</td>
                    <td class="lecture-runtime">${chapter.chapterRuntime}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>