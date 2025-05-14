<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>선생님 메인</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="bg-light-subtle">
<%@ include file="../common/sidebarHeader.jsp" %>
<div class="content">
<div class="container my-5">
    <div class="d-flex align-items-center mb-4">
        <img src="/upload/${teacherDTO.teacherProfileImg}" alt="프로필" class="rounded-circle me-3" style="width:100px;height:100px;object-fit:cover;"
             onerror="this.src='${cp}/resources/img/default_profileImg.png';">
        <div>
            <h3 class="mb-0">${teacherDTO.teacherName} 선생님</h3>
            <p class="text-muted">${teacherDTO.teacherSubject} 전문 강사</p>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-body">
            <h5 class="card-title">선생님 설명</h5>
            <p class="card-text mb-0">${teacherDTO.teacherIntro}</p>
        </div>
    </div>

    <div class="mb-3">
        <h4 class="fw-semibold">개설 강좌</h4>
    </div>

    <c:if test="${not empty lectureList}">
        <div class="table-responsive">
            <table class="table table-hover text-center align-middle">
                <thead class="table-light">
                <tr>
                    <th></th>
                    <th>강좌명</th>
                    <th>가격</th>
                    <th>북마크/장바구니</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="lecture" items="${lectureList}">
                    <tr>
                        <td>
                            <img src="/upload/${lecture.lectureThumbnailImg}" alt="썸네일" class="img-fluid rounded" width="130" height="80"
                                 onerror="this.src='${cp}/resources/img/default_profileImg.png';">
                        </td>
                        <td class="text-start">
                            <a href="/lecture/lectureDetail?lectureIdx=${lecture.lectureIdx}" class="text-decoration-none text-dark fw-semibold">${lecture.lectureTitle}</a>
                        </td>
                        <td>
                            <fmt:formatNumber value="${lecture.lectureAmount}" type="number" groupingUsed="true"/>원
                        </td>
                        <td>
                            <div class="d-flex justify-content-center gap-2">
                                <c:set var="isBookmarked" value="false" />
                                <c:forEach var="b" items="${bookmarked}">
                                    <c:if test="${b eq lecture.lectureIdx}">
                                        <c:set var="isBookmarked" value="true" />
                                    </c:if>
                                </c:forEach>

                                <button class="btn btn-outline-secondary bookmark-btn" data-lecture-idx="${lecture.lectureIdx}" data-bookmarked="${isBookmarked}">
                                    <i class="bi ${isBookmarked ? 'bi-bookmark-fill text-primary' : 'bi-bookmark'}"></i>
                                </button>

                                <button class="btn btn-sm btn-primary" onclick="addCart(${lecture.lectureIdx})">장바구니</button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <c:if test="${empty lectureList}">
        <div class="alert alert-warning mt-4" role="alert">
            등록된 강좌가 없습니다.
        </div>
    </c:if>
</div>
</div>

<script>
    $(document).ready(function () {
        const memberId = '<c:out value="${sessionScope.memberId}" default="" />';

        $('.bookmark-btn').on('click', function () {
            if (!memberId || memberId.trim() === "") {
                alert("로그인이 필요합니다.");
                window.location.href = "/login";
                return;
            }

            const button = $(this);
            const lectureIdx = button.data('lecture-idx');
            const isBookmarked = button.data('bookmarked');
            const icon = button.find('i');

            const url = isBookmarked
                ? '/lecture/deleteBookmark?lectureIdx=' + lectureIdx
                : '/lecture/addBookmark?lectureIdx=' + lectureIdx;

            $.ajax({
                url: url,
                type: 'POST',
                success: function () {
                    button.data('bookmarked', !isBookmarked);
                    if (isBookmarked) {
                        icon.removeClass('bi-bookmark-fill text-primary').addClass('bi-bookmark');
                        alert('북마크 해제하셨습니다.');
                    } else {
                        icon.removeClass('bi-bookmark').addClass('bi-bookmark-fill text-primary');
                        alert('북마크 추가하셨습니다.');
                    }
                },
                error: function (xhr) {
                    alert('오류 발생: ' + xhr.responseText);
                }
            });
        });
    });

    function addCart(lectureIdx) {
        const memberId = '<c:out value="${sessionScope.memberId}" default="" />';
        if (!memberId || memberId.trim() === "") {
            alert("로그인이 필요합니다.");
            window.location.href = "/login";
            return;
        }

        $.ajax({
            url: '/payment/addCart',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({cartLectureIdx: lectureIdx, cartMemberId: memberId}),
            success: function (response) {
                if (response == 999) {
                    alert("이미 장바구니에 존재합니다.");
                } else {
                    alert("장바구니에 추가되었습니다.");
                }

                if (confirm("장바구니로 이동하시겠습니까?")) {
                    window.location.href = "/payment/cart?memberId=" + memberId;
                }
            },
            error: function (xhr) {
                alert("추가 실패: " + xhr.responseText);
            }
        });
    }
</script>
</body>
</html>