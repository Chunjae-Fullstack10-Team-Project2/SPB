<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>공지사항 등록</title>
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

<h2>공지사항 등록</h2>


<form method="post" action="${pageContext.request.contextPath}/notice/regist">
    <table>
        <tr>
            <td>제목</td>
            <td><input type="text" name="noticeTitle" maxlength="100" required></td>
        </tr>
        <tr>
            <td>내용</td>
            <td><textarea name="noticeContent" rows="10" required></textarea></td>
        </tr>
    </table>

    <input type="hidden" name="noticeIsFixed" value="0" />

    <div class="form-actions">
        <button type="submit">등록</button>
        <button type="button" onclick="location.href='${pageContext.request.contextPath}/notice/list'">취소</button>
    </div>
</form>

</body>
</html>
