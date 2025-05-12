<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>신고한 게시글</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/moment/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css"/>
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
                    신고 목록
                </li>
            </ol>
        </nav>
    </div>
    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">신고 목록</h3>
        </div>
        <%
            List<Map<String, String>> dateOptions = new ArrayList<>();
            dateOptions.add(Map.of("value", "reportCreatedAt", "label", "신고일자"));
            dateOptions.add(Map.of("value", "postCreatedAt", "label", "게시글 작성일자"));
            request.setAttribute("dateOptions", dateOptions);

            List<Map<String, String>> searchTypeOptions = new ArrayList<>();
            searchTypeOptions.add(Map.of("value", "postTitle", "label", "제목"));
            searchTypeOptions.add(Map.of("value", "postContent", "label", "내용"));
            searchTypeOptions.add(Map.of("value", "postMemberId", "label", "작성자"));
            request.setAttribute("searchTypeOptions", searchTypeOptions);
        %>
        <jsp:include page="../common/searchBox.jsp">
            <jsp:param name="searchAction" value="/mypage/report"/>
        </jsp:include>

        <c:if test="${not empty reportList}">
            <table class="table table-hover text-center align-middle">
                <thead class="table-light">
                <tr>
                    <td>번호</td>
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
                    <th>신고 상태</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${reportList}" var="postDTO" varStatus="status">
                    <tr>
                        <td>${status.index + 1}</td>
                        <td class="text-start">
                            <a href="/post/detail?postIdx=${postDTO.postIdx}"
                               class="text-decoration-none text-dark">
                                    ${postDTO.postTitle}
                            </a>
                        </td>
                        <td>${postDTO.postMemberId}</td>
                        <td>${postDTO.postCreatedAt.toLocalDate()}</td>
                        <td>
                            <c:choose>
                                <c:when test="${postDTO.reportState == 1}">
                                    <button type="button" class="btn btn-sm btn-danger"
                                            onclick="deleteReport(${postDTO.reportIdx})">
                                        삭제
                                    </button>
                                </c:when>
                                <c:when test="${postDTO.reportState == 2}">
                                    <span class="badge bg-secondary">취소 완료</span>
                                </c:when>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>

        <c:if test="${empty reportList}">
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
    function deleteReport(reportIdx) {
        if (!confirm("정말 삭제하시겠습니까?")) return;

        $.ajax({
            url: "/mypage/report/delete",
            type: "POST",
            data: {reportIdx: reportIdx},
            success: function (response) {
                alert(response);
                location.reload();
            },
            error: function (xhr) {
                alert(xhr.responseText || "삭제 중 오류가 발생했습니다.");
            },
        });
    }

    $(function () {
        $('input[name="datefilter"]')
            .daterangepicker({
                autoUpdateInput: false,
                locale: {
                    format: "YYYY-MM-DD",
                    separator: " - ",
                    applyLabel: "확인",
                    cancelLabel: "취소",
                    customRangeLabel: "Custom",
                    weekLabel: "주",
                    daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
                    monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                    firstDay: 1
                }
            });

        $('input[name="datefilter"]').on('apply.daterangepicker', function (ev, picker) {
            $(this).val(picker.startDate.format('YYYY-MM-DD') + ' - ' + picker.endDate.format('YYYY-MM-DD'));
        });

        $('#btnSearch').click(function (e) {
            e.preventDefault();

            var url = new URL(window.location.href);
            var params = url.searchParams;

            var datefilter = $('input[name="datefilter"]').val();
            if (datefilter) {
                var dates = datefilter.split(' - ');
                params.set('startDate', dates[0]);
                params.set('endDate', dates[1]);
            } else {
                params.delete('startDate');
                params.delete('endDate');
            }

            params.set('searchType', $('select[name="searchType"]').val());
            params.set('searchWord', $('input[name="searchWord"]').val());

            window.location.href = url.toString();
        });

        $('#btnReset').click(function () {
            $('input[name="searchWord"]').val('');
            $('select[name="searchType"]').val('qnaTitle');
            $('input[name="datefilter"]').val('');

            var url = new URL(window.location.href);
            var params = url.searchParams;
            params.delete('datefilter');
            params.delete('startDate');
            params.delete('endDate');
            params.delete('searchType');
            params.delete('searchWord');

            window.location.href = url.toString();
        });
    });

    <c:if test="${not empty message}">
    alert("${message}");
    </c:if>
</script>
</body>
</html>
