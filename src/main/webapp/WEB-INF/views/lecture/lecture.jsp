<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>강좌 목록</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            font-family: 'Malgun Gothic', sans-serif;
            background-color: #f8f9fa;
        }

        .card:hover {
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
            transition: box-shadow 0.2s ease-in-out;
        }

        .card-img-top {
            height: 160px;
            object-fit: cover;
        }

        .btn.active {
            pointer-events: none;
        }

        @media (max-width: 576px) {
            .card-img-top {
                height: 140px;
            }
        }
    </style>
</head>
<body class="bg-light-subtle">
<%@ include file="../common/sidebarHeader.jsp" %>
<div class="content">
    <div class="container my-5">
        <h3 class="mb-4">강좌 목록</h3>

        <%-- 검색박스 설정 --%>
        <%
            List<Map<String, String>> searchTypeOptions = new ArrayList<>();
            searchTypeOptions.add(Map.of("value", "lectureTitle", "label", "제목"));
            request.setAttribute("searchTypeOptions", searchTypeOptions);
            request.setAttribute("searchAction", "/lecture/main");
            request.setAttribute("isTeacher", "Y");
        %>
        <jsp:include page="../common/searchBox.jsp"/>

        <%-- 과목 탭 필터 --%>
        <div class="d-flex flex-wrap gap-2 border-bottom pb-2 mb-4">
            <a href="/lecture/main"
               class="btn rounded-pill
               ${empty param.subject ? 'btn-primary text-white' : 'btn-outline-secondary'}">
                전체
            </a>
            <c:forEach var="subject" items="${subjectList}">
                <a href="?subject=${subject}"
                   class="btn rounded-pill
                   ${param.subject eq subject ? 'btn-primary text-white' : 'btn-outline-secondary'}">
                        ${subject}
                </a>
            </c:forEach>
        </div>

        <%-- 강좌 카드 목록 --%>
        <div class="row row-cols-2 row-cols-md-4 g-4">
            <c:choose>
                <c:when test="${not empty lectureDTO}">
                    <c:forEach var="lecture" items="${lectureDTO}">
                        <div class="col">
                            <div class="card h-100 shadow-sm border-0"
                                 onclick="location.href='/lecture/lectureDetail?lectureIdx=${lecture.lectureIdx}'"
                                 style="cursor: pointer;">
                                <img src="/upload/${lecture.lectureThumbnailImg}" alt="${lecture.lectureTitle}"
                                     class="card-img-top">
                                <div class="card-body">
                                    <h6 class="card-title fw-semibold">${lecture.lectureTitle}</h6>
                                    <p class="mb-1 text-muted">${lecture.lectureTeacherName} 선생님</p>
                                    <p class="text-primary fw-bold">
                                        <fmt:formatNumber value="${lecture.lectureAmount}" type="number"/>원
                                    </p>
                                </div>
                                <div class="d-flex justify-content-center gap-2">
                                    <c:set var="isBookmarked" value="false" />
                                    <c:forEach var="b" items="${bookmarked}">
                                        <c:if test="${b eq lecture.lectureIdx}">
                                            <c:set var="isBookmarked" value="true" />
                                        </c:if>
                                    </c:forEach>

                                    <button class="btn btn-outline-secondary bookmark-btn" data-lecture-idx="${lecture.lectureIdx}" data-bookmarked="${isBookmarked}" onclick="event.stopPropagation();">
                                        <i class="bi ${isBookmarked ? 'bi-bookmark-fill text-primary' : 'bi-bookmark'}"></i>
                                    </button>

                                    <button class="btn btn-sm btn-primary" onclick="event.stopPropagation(); addCart(${lecture.lectureIdx});">장바구니</button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col text-center text-muted">검색 결과가 없습니다.</div>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- 페이징 --%>
        <div class="mt-4 text-center">
            <%@ include file="../common/paging.jsp" %>
        </div>
    </div>
</div>
<script>
    document.querySelectorAll(".teacher-card").forEach(card => {
        card.addEventListener("click", () => {
            const teacherId = card.getAttribute("data-id");
            window.location.href = "/teacher/personal?teacherId=" + teacherId;
        });
    });

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