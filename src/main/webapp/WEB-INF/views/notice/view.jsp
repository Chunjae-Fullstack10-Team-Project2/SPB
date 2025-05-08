<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>공지사항 상세보기</title>
    <style>
        body {
            padding: 40px;
            margin: 0;
        }

        .title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .view-header {
            color: #555;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .content-box {
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 16px;
            min-height: 300px;
            max-height: 500px;
            overflow-y: auto;
            white-space: pre-line;
            background-color: #fafafa;
            margin-top: 20px;
        }

        .btn-container {
            margin-top: 30px;
            text-align: right;
        }

        .btn-container button {
            display: inline-block;
            padding: 10px 18px;
            border: 1px solid #aaa;
            background: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 8px;
        }

        .btn-container button:hover {
            background: #f5f5f5;
        }
    </style>
</head>

<body>

<div class="title">${dto.noticeTitle}</div>

<div class="view-header">
    <div>
        작성자 : ${dto.noticeMemberId}
    </div>
    <div style="margin-top: 5px">
        작성일 : ${createdAtStr}
        <c:if test="${not empty updatedAtStr}">
            &nbsp;&nbsp; 수정일 : ${updatedAtStr}
        </c:if>
    </div>


<div class="content-box">
    ${dto.noticeContent}
</div>

<div class="btn-container">
    <button type="button" onclick="location.href='${pageContext.request.contextPath}/notice/list'">목록</button>
    <button type="button" id="btnModify">수정</button>
</div>

<script>
    document.getElementById('btnModify').addEventListener('click', function () {
        const idx = "${dto.noticeIdx}";
        window.location.href = "${pageContext.request.contextPath}/notice/modify?noticeIdx=" + idx;
    });
</script>

</body>
</html>
