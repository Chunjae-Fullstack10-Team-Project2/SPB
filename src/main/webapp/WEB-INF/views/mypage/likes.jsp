<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>좋아요 누른 게시글</title>
</head>
<body class="bg-light-subtle">
<%@ include file="../common/sidebarHeader.jsp" %>

<div class="content">
    <div class="container my-5">
        <%@ include file="../common/breadcrumb.jsp" %>
    </div>
    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">좋아요 누른 게시글</h3>
        </div>
        <%
            List<Map<String, String>> dateOptions = new ArrayList<>();
            dateOptions.add(Map.of("value", "postLikeCreatedAt", "label", "좋아요 누른 날짜"));
            dateOptions.add(Map.of("value", "postCreatedAt", "label", "게시글 작성일자"));
            request.setAttribute("dateOptions", dateOptions);

            List<Map<String, String>> searchTypeOptions = new ArrayList<>();
            searchTypeOptions.add(Map.of("value", "postTitle", "label", "제목"));
            searchTypeOptions.add(Map.of("value", "postContent", "label", "내용"));
            searchTypeOptions.add(Map.of("value", "postMemberId", "label", "작성자"));
            request.setAttribute("searchTypeOptions", searchTypeOptions);
            request.setAttribute("searchAction", "/mypage/likes");
        %>
        <jsp:include page="../common/searchBox.jsp" />

        <c:if test="${not empty likesList}">
            <table class="table table-hover text-center align-middle">
                <thead class="table-light">
                <tr>
                    <th>번호</th>
                    <th>
                        <a href="javascript:void(0);" onclick="applySort('postTitle')">
                            제목
                            <c:if test="${searchDTO.sortColumn eq 'postTitle'}">
                                ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
                    <th>
                        <a href="javascript:void(0);" onclick="applySort('postMemberId')">
                            작성자
                            <c:if test="${searchDTO.sortColumn eq 'postMemberId'}">
                                ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
                    <th>
                        <a href="javascript:void(0);" onclick="applySort('postCreatedAt')">
                            작성일
                            <c:if test="${searchDTO.sortColumn eq 'postCreatedAt'}">
                                ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                            </c:if>
                        </a>
                    </th>
                    <th>좋아요 상태</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${likesList}" var="reportDTO" varStatus="status">
                    <tr>
                        <td>${status.index + 1}</td>
                        <td class="text-start">
                            <a href="/post/detail?postIdx=${reportDTO.postLikeRefIdx}"
                               class="text-decoration-none text-dark">
                                    ${reportDTO.postTitle}
                            </a>
                        </td>
                        <td>${reportDTO.postMemberId}</td>
                        <td>${reportDTO.postCreatedAt.toLocalDate()}</td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-danger"
                                    onclick="cancelLike(${reportDTO.postLikeRefIdx})">
                                좋아요 취소
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>

        <c:if test="${empty likesList}">
            <div class="alert alert-warning mt-4" role="alert">
                게시글이 없습니다.
            </div>
        </c:if>

        <div class="mt-4 text-center">
            <%@ include file="../common/paging.jsp" %>
        </div>
    </div>
</div>
<script>
    function cancelLike(postLikeRefIdx) {
        if (!confirm("정말 좋아요를 취소하시겠습니까?")) return;

        $.ajax({
            url: "/mypage/likes/delete",
            type: "POST",
            data: {postLikeRefIdx: postLikeRefIdx},
            success: function (response) {
                alert(response);
                location.reload();
            },
            error: function (xhr) {
                alert(xhr.responseText || "좋아요 취소 중 오류가 발생했습니다.");
            }
        });
    }

    <c:if test="${not empty message}">
    alert("${message}");
    </c:if>
</script>
</body>
</html>
