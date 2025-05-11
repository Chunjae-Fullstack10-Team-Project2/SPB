<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>강좌 페이지</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<%@ include file="../common/sidebarHeader.jsp" %>
<div class="content">
<div class="container-lg my-5 px-4">
    <!-- 강좌 정보 -->
    <div class="row mb-4">
        <div class="col-md-12 d-flex align-items-start">
            <div class="flex-grow-1">
                <h4 class="fw-bold mb-3">${lectureDTO.lectureTitle}</h4>
                <div class="p-3 bg-light rounded border mb-0 text-muted">
                    ${lectureDTO.lectureDescription}
                </div>
            </div>
            <div class="ms-4" style="flex-shrink: 0;">
                <img src="/upload/${lectureDTO.lectureThumbnailImg}" alt="강좌 썸네일"
                     class="rounded border"
                     style="width: 200px; height: 120px; object-fit: cover;">
            </div>
        </div>
    </div>

    <!-- 강의 목차 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-semibold mb-0">강의 목차</h5>
        <small class="text-muted">전체 ${chapterCount}개</small>
    </div>

    <!-- 강의 리스트 -->
    <div class="table-responsive">
        <table class="table table-hover align-middle text-center">
            <thead class="table-light">
            <tr>
                <th style="width: 80px;">강의</th>
                <th class="text-start">제목</th>
                <th style="width: 100px;">런타임</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty chapterList}">
                    <c:forEach var="chapter" items="${chapterList}" varStatus="status">
                        <tr>
                            <td>${status.index + 1}강</td>
                            <td class="text-start">
                                <a href="javascript:void(0);" class="text-decoration-none text-dark fw-semibold"
                                   onclick="openPlayer('${chapter.chapterIdx}')">
                                        ${chapter.chapterName}
                                </a>
                            </td>
                            <td>${chapter.chapterRuntime}</td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="3" class="text-center text-muted">등록된 강의가 없습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>
</div>
<script>
    function openPlayer(chapterIdx) {
        const lectureIdx = '${lectureDTO.lectureIdx}';
        console.log("▶ openPlayer URL: /lecture/chapter/play?chapterLectureIdx=" + ${lectureDTO.lectureIdx} + "&chapterIdx=" + chapterIdx);

        window.open(
            '/lecture/chapter/play?chapterLectureIdx=' + lectureIdx + '&chapterIdx=' + chapterIdx,
            '_blank',
            'width=' + screen.width + ',height=' + screen.height + ',top=0,left=0'
        );
    }
</script>
<c:if test="${param.denied eq 'true'}">
    <script>
        alert("해당 강좌에 대한 수강 권한이 없습니다.");
        history.back();
    </script>
</c:if>
</body>
</html>