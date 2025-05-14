<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String uri = request.getRequestURI();
    request.setAttribute("currentURI", uri);
%>
<html>
<head>
    <title>1:1 문의</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/moment/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body class="bg-light-subtle">
<%@ include file="../common/header.jsp" %>

<div class="content-nonside">
    <div class="container my-5">
        <%@ include file="../common/breadcrumb.jsp" %>
    </div>

    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">문의 목록</h3>
            <a href="/qna/regist" class="btn btn-primary">
                <i class="bi bi-pencil-square"></i> 문의 등록
            </a>
        </div>
        <%
            List<Map<String, String>> searchTypeOptions = new ArrayList<>();
            searchTypeOptions.add(Map.of("value", "qnaTitle", "label", "제목"));
            searchTypeOptions.add(Map.of("value", "qnaQContent", "label", "문의 내용"));
            searchTypeOptions.add(Map.of("value", "qnaQMemberId", "label", "문의 작성자"));
            searchTypeOptions.add(Map.of("value", "qnaAContent", "label", "답변 내용"));
            searchTypeOptions.add(Map.of("value", "qnaAMemberId", "label", "답변 작성자"));
            request.setAttribute("searchTypeOptions", searchTypeOptions);
            request.setAttribute("searchAction", "/qna/list");
        %>
        <jsp:include page="../common/searchBox.jsp"/>
        <c:if test="${not empty qnaList}">
            <div class="list-group">
                <c:forEach var="qnaDTO" items="${qnaList}">
                    <div class="list-group-item list-group-item-action d-flex justify-content-between align-items-start"
                         style="cursor: pointer;"
                         onclick="handleQnaClick(${qnaDTO.qnaIdx}, '${qnaDTO.qnaQPwd ne 0 ? 'Y' : 'N'}', ${sessionScope.memberGrade})">
                        <div class="ms-2 me-auto">
                            <c:choose>
                                <c:when test="${sessionScope.memberGrade ne 0}">
                                    <div class="fw-bold"><a
                                            href="${pageContext.request.contextPath}/qna/view?qnaIdx=${qnaDTO.qnaIdx}"
                                            class="fw-bold text-decoration-none text-dark">${qnaDTO.qnaTitle}</a></div>
                                </c:when>
                                <c:otherwise>
                                    <div class="fw-bold">${qnaDTO.qnaTitle}</div>
                                </c:otherwise>
                            </c:choose>
                            <small class="text-muted">작성자: ${qnaDTO.qnaQMemberId}</small>
                        </div>
                        <div class="d-flex flex-column align-items-end">
                            <c:choose>
                                <c:when test="${not empty qnaDTO.qnaAnsweredAt}">
                                    <span class="badge bg-success mb-1">답변</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger mb-1">미답변</span>
                                </c:otherwise>
                            </c:choose>
                            <small class="text-muted">
                                <fmt:formatDate value="${qnaDTO.qnaCreatedAt}" pattern="yyyy-MM-dd"/>
                            </small>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <c:if test="${sessionScope.memberGrade ne 0}">
                <div class="modal fade" id="pwdModal" tabindex="-1" aria-labelledby="pwdModalLabel" aria-hidden="true">
                    <input type="hidden" id="selectedQnaIdx">
                    <div class="modal-dialog">
                        <div class="modal-content p-3">
                            <div class="modal-header">
                                <h5 class="modal-title" id="pwdModalLabel">비밀번호 확인</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <input type="password" class="form-control" id="qnaQPwdConfirm"
                                       placeholder="비밀번호를 입력하세요.">
                                <div class="text-danger mt-2" id="pwdError" style="display: none;">비밀번호가 일치하지 않습니다.
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                                <button type="button" class="btn btn-primary" onclick="verifyPassword()">확인</button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
        </c:if>

        <c:if test="${empty qnaList}">
            <div class="alert alert-warning mt-4" role="alert">
                등록된 문의가 없습니다.
            </div>
        </c:if>

        <div class="mt-4 text-center">
            <%@ include file="../common/paging.jsp" %>
        </div>
    </div>
</div>
<script>
    function handleQnaClick(qnaIdx, hasPwd, memberGrade) {
        if (hasPwd === 'Y' && memberGrade !== 0) {
            $('#selectedQnaIdx').val(qnaIdx);
            $('#qnaQPwdConfirm').val('');
            $('#pwdError').hide();
            $('#pwdModal').modal('show');
        } else {
            window.location.href = '/qna/view?qnaIdx=' + qnaIdx;
        }
    }

    function verifyPassword() {
        const qnaIdx = $('#selectedQnaIdx').val();
        const inputPwd = $('#qnaQPwdConfirm').val();

        $.post('/qna/checkPwd', {
            qnaIdx: qnaIdx,
            qnaQPwd: inputPwd
        }).done(function () {
            $('#pwdError').hide();
            $('#pwdModal').modal('hide');
            window.location.href = '/qna/view?qnaIdx=' + qnaIdx;
        }).fail(function () {
            $('#pwdError').show();
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
