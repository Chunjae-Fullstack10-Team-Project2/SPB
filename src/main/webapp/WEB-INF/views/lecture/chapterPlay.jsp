<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${chapter.chapterName}</title>
    <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
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
    <video id="lectureVideo" width="100%" controls>
        <source src="/upload/${chapter.chapterVideo}" type="video/mp4">
        브라우저가 video 태그를 지원하지 않습니다.
    </video>
</div>

<script>
    const video = document.getElementById("lectureVideo");
    const memberId = "${sessionScope.memberId}";
    const chapterId = "${chapter.chapterIdx}";
    let saveInterval = null;
    let lastSaveTime = 0;

    // 메타데이터 로드 시 마지막 시청 위치로 이동
    video.addEventListener("loadedmetadata", function () {
        $.ajax({
            url: "/video/progress",
            type: "GET",
            data: {
                lectureMemberId: memberId,
                lectureHistoryChapterIdx: chapterId
            },
            success: function (res) {
                const savedSeconds = res.lastTime;
                if (!isNaN(savedSeconds) && savedSeconds > 0) {
                    video.currentTime = savedSeconds;
                    console.log("✅ 불러온 진도 위치로 이동:", savedSeconds);
                }
            },
            error: function () {
                console.warn("❌ 진도 조회 실패");
            }
        });
    });

    // 영상 재생 시 → 5초마다 진도 저장
    video.addEventListener("play", function () {
        lastSaveTime = video.currentTime;
        if (saveInterval !== null) return;

        saveInterval = setInterval(function () {
            saveProgress(false);
        }, 5000);
    });

    function getWatchedSecondsSinceLastSave() {
        const now = Math.floor(video.currentTime || 0);
        const watched = now - lastSaveTime;
        lastSaveTime = now;
        return watched > 0 ? watched : 0;
    }

    // 영상 일시정지 or 페이지 이탈 시 → 진도 저장 후 타이머 해제
    video.addEventListener("pause", function () {
        stopSaving();
        saveProgress(false);
    });

    window.addEventListener("beforeunload", function () {
        stopSaving();
        saveProgress(false);
    });

    // 영상 끝까지 본 경우 → 완료 처리
    video.addEventListener("ended", function () {
        stopSaving();
        saveProgress(true); // ✅ 완료 상태로 저장
    });

    function stopSaving() {
        if (saveInterval !== null) {
            clearInterval(saveInterval);
            saveInterval = null;
        }
    }

    // 진도 저장 함수 (completed 여부 포함)
    function saveProgress(completed) {
        const seconds = Math.floor(video.currentTime || 0);
        const formatted = secondsToHHMMSS(seconds);
        const watchedSeconds = getWatchedSecondsSinceLastSave();
        const watchTimeFormatted = secondsToHHMMSS(watchedSeconds);

        if (isNaN(seconds)) {
            console.warn("⛔ currentTime이 NaN입니다. 저장 중단");
            return;
        }

        console.log("📦 저장 요청:", formatted, "| 완료 여부:", completed);
        console.log({
            lectureMemberId: memberId,
            lectureHistoryChapterIdx: chapterId,
            lectureHistoryWatchTime: watchTimeFormatted,
            lectureHistoryLastPosition: formatted,
            lectureHistoryCompleted: completed
        });
        $.ajax({
            url: "/video/progress",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({
                lectureMemberId: memberId,
                lectureHistoryChapterIdx: chapterId,
                lectureHistoryWatchTime: watchTimeFormatted,
                lectureHistoryLastPosition: formatted,
                lectureHistoryCompleted: completed
            }),
            success: function () {
                console.log("✅ 저장 완료");
            },
            error: function (request,status,error) {
                console.warn("❌ 저장 실패");
                console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
    }

    // 초를 HH:mm:ss로 변환
    function secondsToHHMMSS(seconds) {
        const sec = parseInt(seconds, 10);
        if (isNaN(sec) || sec < 0) return "00:00:00";

        const hrs = String(Math.floor(sec / 3600)).padStart(2, '0');
        const mins = String(Math.floor((sec % 3600) / 60)).padStart(2, '0');
        const secs = String(sec % 60).padStart(2, '0');

        return hrs + ":" + mins + ":" + secs;
    }
</script>
</body>
</html>
