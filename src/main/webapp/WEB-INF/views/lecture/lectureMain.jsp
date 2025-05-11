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

        .curriculum-header {
            display: flex;
            align-items: baseline;
            gap: 10px;
            margin-bottom: 10px;
        }

        @media (max-width: 768px) {
            .lecture-runtime {
                width: 80px;
            }
        }
    </style>
</head>
<body>
<%@ include file="../common/sidebarHeader.jsp" %>
<div class="content">
<div class="lecture-container">
    <div class="course-info d-flex justify-content-between gap-4">
        <div class="course-text flex-grow-1">
            <div class="course-name">${lectureDTO.lectureTitle}</div>
            <div class="course-intro">${lectureDTO.lectureDescription}</div>
        </div>
        <div class="course-thumbnail">
            <img src="/upload/${lectureDTO.lectureThumbnailImg}" alt="강좌 썸네일" style="width: 130px; height: 80px; border-radius: 5px; border: 1px solid #ccc;">
        </div>
    </div>
    <div class="curriculum-header">
        <div class="course-name">강의 목차</div>
        <div style="color: #666; font-size: 14px;">전체 ${chapterCount}개</div>
    </div>
        <table class="lecture-list">
            <thead>
            <tr>
                <th class="lecture-number">강의</th>
                <th>제목</th>
                <th class="lecture-runtime">런타임</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty chapterList}">
                <c:forEach var="chapter" items="${chapterList}" varStatus="status">
                    <tr>
                        <td class="lecture-number">${status.index + 1}강</td>
                        <td class="lecture-title"><a href="javascript:void(0);" onclick="openPlayer(${chapter.chapterIdx})">${chapter.chapterName}</a></td>
                        <td class="lecture-runtime">${chapter.chapterRuntime}</td>
                    </tr>
                </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="3" style="text-align: center">등록된 강의가 없습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>
<script>
    function openPlayer(chapterIdx) {
        window.open(
            '/lecture/chapter/play?chapterLectureIdx=${lectureDTO.lectureIdx}&chapterIdx=' + chapterIdx,
            '_blank',
            'width=' + screen.width + ',height=' + screen.height + ',top=0,left=0'
        );
    }
</script>
</body>
</html>