<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>찜한 강의</title>
</head>
<body>
<%@ include file="../common/sidebarHeader.jsp" %>

<div class="content">
    <svg xmlns="http://www.w3.org/2000/svg" class="d-none">
        <symbol id="house-door-fill" viewBox="0 0 16 16">
            <path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5z"/>
        </symbol>
    </svg>
    <div class="container my-5">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb breadcrumb-chevron p-3 bg-body-tertiary rounded-3">
                <li class="breadcrumb-item">
                    <a class="link-body-emphasis" href="/">
                        <svg class="bi" width="16" height="16" aria-hidden="true">
                            <use xlink:href="#house-door-fill"></use>
                        </svg>
                        <span class="visually-hidden">Home</span>
                    </a>
                </li>
                <li class="breadcrumb-item">
                    <a class="link-body-emphasis fw-semibold text-decoration-none" href="/mypage">마이페이지</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    북마크한 강좌
                </li>
            </ol>
        </nav>
    </div>
    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">북마크한 강좌</h3>
        </div>
        <%
            List<Map<String, String>> dateOptions = new ArrayList<>();
            dateOptions.add(Map.of("value", "lectureCreatedAt", "label", "강좌 생성일"));
            dateOptions.add(Map.of("value", "bookmarkCreatedAt", "label", "북마크한 날짜"));
            request.setAttribute("dateOptions", dateOptions);

            List<Map<String, String>> searchTypeOptions = new ArrayList<>();
            searchTypeOptions.add(Map.of("value", "lectureTitle", "label", "강좌 제목"));
            searchTypeOptions.add(Map.of("value", "teacherName", "label", "선생님"));
            request.setAttribute("searchTypeOptions", searchTypeOptions);
            request.setAttribute("searchAction", "/mypage/bookmark");
        %>
        <jsp:include page="../common/searchBox.jsp"/>

        <c:if test="${not empty bookmarkList}">
            <table class="table table-hover text-center align-middle">
                <thead class="table-light">
                <tr>
                    <th>번호</th>
                    <th>
                        <a href="javascript:void(0);" onclick="applySort('lectureTitle')">
                            제목
                            <c:if test="${searchDTO.sortColumn eq 'lectureTitle'}">
                                ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
                    <th>
                        <a href="javascript:void(0);" onclick="applySort('teacherName')">
                            선생님
                            <c:if test="${searchDTO.sortColumn eq 'teacherName'}">
                                ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
                    <th>
                        <a href="javascript:void(0);" onclick="applySort('bookmarkCreatedAt')">
                            북마크 날짜
                            <c:if test="${searchDTO.sortColumn eq 'bookmarkCreatedAt'}">
                                ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
<<<<<<< HEAD
                    <th>북마크 상태</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${bookmarkList}" var="bookmarkDTO" varStatus="status">
=======
                    <th>강좌 상태</th>
                    <th>장바구니 추가</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${bookmarkList}" var="reportDTO" varStatus="status">
>>>>>>> develop
                    <tr>
                        <td>${status.index + 1}</td>
                        <td class="text-start">
                            <a href="#"
                               class="text-decoration-none text-dark">
<<<<<<< HEAD
                                    ${bookmarkDTO.lectureTitle}
                            </a>
                        </td>
                        <td>${bookmarkDTO.teacherName}</td>
                        <td><fmt:formatDate value="${bookmarkDTO.bookmarkCreatedAt}" pattern="yyyy-MM-dd" /></td>
                        <td>
                            <c:if test="${bookmarkDTO.bookmarkState == 1}">
                                <button type="button" class="btn btn-sm btn-outline-danger"
                                        onclick="cancelBookmark(${bookmarkDTO.bookmarkIdx})">
                                    북마크 취소
                                </button>
                            </c:if>
                            <c:if test="${bookmarkDTO.bookmarkState == 2}">
                                <span class="badge bg-secondary">취소 완료</span>
                            </c:if>
                        </td>
=======
                                    ${reportDTO.lectureTitle}
                            </a>
                        </td>
                        <td>${reportDTO.teacherName}</td>
                        <td><fmt:formatDate value="${reportDTO.bookmarkCreatedAt}" pattern="yyyy-MM-dd" /></td>
                        <td>
                            <c:if test="${reportDTO.bookmarkState == 1}">
                                <button type="button" class="btn btn-sm btn-outline-danger"
                                        onclick="cancelBookmark(${reportDTO.bookmarkIdx})">
                                    삭제
                                </button>
                            </c:if>
                            <c:if test="${reportDTO.bookmarkState == 2}">
                                <span class="badge bg-secondary">결제 완료</span>
                            </c:if>
                        </td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-primary"
                                    onclick="addCart('${reportDTO.bookmarkLectureIdx}')">
                                장바구니
                            </button>
                        </td>
>>>>>>> develop
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>

        <c:if test="${empty bookmarkList}">
            <div class="alert alert-warning mt-4" role="alert">
                북마크한 강좌가 없습니다.
            </div>
        </c:if>

        <div class="mt-4 text-center">
            <%@ include file="../common/paging.jsp" %>
        </div>
    </div>
</div>
<script>
    function cancelBookmark(bookmarkIdx) {
        if (!confirm("정말 북마크를 취소하시겠습니까?")) return;

        $.ajax({
            url: "/mypage/bookmark/delete",
            type: "POST",
            data: {bookmarkIdx: bookmarkIdx},
            success: function (response) {
                alert(response);
                location.reload();
            },
            error: function (xhr) {
                alert(xhr.responseText || "북마크 취소 중 오류가 발생했습니다.");
            }
        });
    }

    <c:if test="${not empty message}">
    alert("${message}");
    </c:if>
<<<<<<< HEAD
=======

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
                console.log(xhr.responseText);
            }
        });
    }
>>>>>>> develop
</script>
</body>
</html>
