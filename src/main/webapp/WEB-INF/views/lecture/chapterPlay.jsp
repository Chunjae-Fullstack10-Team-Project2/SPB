<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${chapter.chapterName}</title>
    <style>
        body, html {
            margin: 0;
            padding: 0;
            background: black;
            height: 100%;
            width: 100%;
            overflow: hidden;
        }
        .video-wrapper {
            position: absolute;
            top: 0; left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        video {
            max-width: 100%;
            max-height: 100%;
        }
    </style>
</head>
<body>
<div class="video-wrapper">
    <video controls autoplay>
        <source src="/upload/${chapter.chapterVideo}" type="video/mp4">
        브라우저가 video 태그를 지원하지 않습니다.
    </video>
</div>
</body>
</html>
