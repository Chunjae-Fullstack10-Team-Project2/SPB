<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>찜한 강의</title>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body class="bg-light-subtle">
<%@ include file="../common/sidebarHeader.jsp" %>

<div class="content">
    <div class="container my-5">
        <%@ include file="../common/breadcrumb.jsp" %>
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
                    <th>북마크 상태</th>
                    <th>장바구니 추가</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${bookmarkList}" var="bookmarkDTO" varStatus="status">
                    <tr>
                        <td>${status.index + 1}</td>
                        <td class="text-start">
                            <a href="/lecture/lectureDetail?lectureIdx=${bookmarkDTO.bookmarkLectureIdx}"
                               class="text-decoration-none text-dark">
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
                                <span class="badge bg-success">구매 완료</span>
                            </c:if>
                        </td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-primary"
                                    onclick="addCart('${bookmarkDTO.bookmarkLectureIdx}')">
                                장바구니
                            </button>
                        </td>
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
</script>
</body>
</html>