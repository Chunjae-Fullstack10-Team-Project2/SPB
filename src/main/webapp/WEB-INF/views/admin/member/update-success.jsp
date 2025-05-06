<%--
  Created by IntelliJ IDEA.
  User: sinjihye
  Date: 2025. 5. 4.
  Time: 15:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- update-success.jsp -->
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>처리 완료</title>
</head>
<body>
<p>처리가 완료되었습니다. 창을 닫습니다...</p>
<script>
    window.onload = function () {
        if (window.opener && !window.opener.closed) {
            window.opener.location.reload();  // 부모창 새로고침
        }
        window.close();  // 현재 팝업 창 닫기
    };
</script>
</body>
</html>
