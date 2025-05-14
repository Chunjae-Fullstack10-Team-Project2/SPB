<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>강좌 페이지</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="bg-light-subtle">
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
                     onerror="this.src='${cp}/resources/img/default_profileImg.png';"
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
    <!-- 평균 평점 -->
    <div class="mb-4 p-4 bg-light border rounded">
        <h5 class="mb-2">수강후기</h5>
        <div class="d-flex align-items-center">
            <h2 class="text-warning mb-0 me-2">★ ${averageRating}</h2>
            <small class="text-muted">총 ${fn:length(reviewList)}개의 리뷰</small>
        </div>
    </div>

    <!-- 수강 후기 리스트 -->
    <c:forEach var="review" items="${reviewList}">
        <div class="mb-3 p-3 border rounded bg-white shadow-sm">

            <div class="d-flex justify-content-between mb-2">
                <div>
                    <!-- 별점 -->
                    <div class="text-warning mb-1">
                        <c:forEach begin="1" end="${review.lectureReviewGrade}" var="i">★</c:forEach>
                        <c:forEach begin="1" end="${5 - review.lectureReviewGrade}" var="i">☆</c:forEach>
                    </div>
                    <!-- 아이디 -->
                    <small class="badge bg-secondary">
                        <i class="bi bi-person-circle me-1"></i>
                        <c:choose>
                            <c:when test="${fn:length(review.lectureReviewMemberId) > 4}">
                                ${fn:substring(review.lectureReviewMemberId, 0, fn:length(review.lectureReviewMemberId) - 4)}****님
                            </c:when>
                            <c:otherwise>****님</c:otherwise>
                        </c:choose>
                    </small>
                </div>

                <!-- 신고 버튼 -->
                <div>
                    <button class="btn btn-outline-danger btn-sm"
                            onclick="reportReview(${review.lectureReviewIdx}, '${review.lectureReviewMemberId}')">
                        <i class="bi bi-flag"></i> 신고
                    </button>
                </div>
            </div>

            <!-- 후기 내용 -->
            <p class="mb-0 text-muted">
                <i class="bi bi-chat-left-text me-1"></i>
                    ${review.lectureReviewContent}
            </p>
        </div>
    </c:forEach>
</div>
</div>
</div>
</div>
<script>
    function openPlayer(chapterIdx) {
        const lectureIdx = '${lectureDTO.lectureIdx}';

        window.open(
            '/lecture/chapter/play?chapterLectureIdx=' + lectureIdx + '&chapterIdx=' + chapterIdx,
            '_blank',
            'width=' + screen.width + ',height=' + screen.height + ',top=0,left=0'
        );
    }

    function reportReview(lectureReviewIdx,lectureReviewId){
        const memberId = '${sessionScope.memberId}';
        if (!memberId || memberId.trim() === "") {
            alert("로그인이 필요합니다.");
            window.location.href = "/login";
            return;
        }
        if(memberId == lectureReviewId){
            alert("자신의 수강후기는 신고할 수 없습니다.");
            location.reload();
            return;
        }
        $.ajax({
            url: '/lecture/report',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                postMemberId: "",
                lectureReviewIdx : lectureReviewIdx,
                lectureReviewMemberId : '${sessionScope.memberId}'
            }),
            success: function (response) {
                alert(response.message);
                location.reload();
            },
            error: function (xhr) {
                console.error('삭제 실패:', xhr.responseText);
                alert("신고 중 오류가 발생했습니다.");
            }
        });
    }
</script>
<c:if test="${param.denied eq 'true'}">
    <script>
        alert("강좌 구매 후 시청 하실 수 있습니다.");
        window.close();
    </script>
</c:if>
</body>
</html>