<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>공지사항 수정</title>
    <style>
        body {
            padding: 40px;
            margin: 0;
        }

        h2 {
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-spacing: 0;
            border-collapse: collapse;
        }

        td {
            padding: 12px 0;
            vertical-align: top;
        }

        td:first-child {
            width: 100px;
            font-weight: bold;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .form-actions {
            text-align: right;
            margin-top: 20px;
        }

        .form-actions button {
            display: inline-block;
            padding: 10px 18px;
            border: 1px solid #aaa;
            background: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 8px;
        }

        .form-actions button:hover {
            background: #f5f5f5;
        }
    </style>
</head>
<body>

<h2>공지사항 수정</h2>

<form method="post" action="${pageContext.request.contextPath}/notice/modify" onsubmit="return validateForm()">
    <input type="hidden" name="noticeIdx" value="${dto.noticeIdx}" />

    <table>
        <tr>
            <td>제목</td>
            <td><input type="text" name="noticeTitle" id="title" maxlength="100" value="${dto.noticeTitle}" required /></td>
        </tr>
        <tr>
            <td>내용</td>
            <td><textarea name="noticeContent" rows="10" required>${dto.noticeContent}</textarea></td>
        </tr>
    </table>

    <input type="hidden" name="noticeIsFixed" value="${dto.noticeIsFixed}" />

    <div class="form-actions">
        <button type="submit">수정</button>
        <button type="button" onclick="location.href='${pageContext.request.contextPath}/notice/list'">취소</button>
    </div>
</form>

<script>
    function validateForm() {
        const title = document.getElementById("title").value.trim();
        if (title.length > 100) {
            alert("제대로 된 형식으로 입력하시오 (제목은 100자 이하만 가능합니다).");
            return false;
        }
        return true;
    }
</script>

</body>
</html>
