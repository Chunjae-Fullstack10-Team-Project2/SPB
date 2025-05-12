<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>자유게시판 관리</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/moment/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<c:choose>
    <c:when test="${not empty search.search_date1 and not empty search.search_date2}">
        <c:set var="dateRangeValue" value="${search.search_date1} - ${search.search_date2}" />
    </c:when>
    <c:otherwise>
        <c:set var="dateRangeValue" value="" />
    </c:otherwise>
</c:choose>
<%@ include file="../../common/sidebarHeader.jsp" %>
<div class="content">
    <div class="container my-5">
        <%@ include file="../../common/breadcrumb.jsp" %>
        <div class="container my-5">
            <h2 class="mb-4">자유게시판 관리</h2>
            <form name="frmSearch" method="get" action="${searchAction}" class="mb-1 p-4">
                <input type="hidden" name="search_date1" id="search_date1" value="${search.search_date1}" />
                <input type="hidden" name="search_date2" id="search_date2" value="${search.search_date2}" />

                <div class="row g-2 align-items-center mb-3">
                    <div class="col-md-3">
                        <input type="text" name="datefilter" id="datefilter" class="form-control" placeholder="기간 선택"
                               autocomplete="off"
                               value="${dateRangeValue}" />
                    </div>
                </div>

                <div class="row g-2 align-items-center mb-3">
                    <div class="col-md-2">
                        <select name="search_type" class="form-select">
                            <option value="">선택</option>
                            <option value="title" ${search.search_type eq "postTitle" ? "selected":""}>제목</option>
                            <option value="content" ${search.search_type eq "postContent" ? "selected":""}>내용</option>
                            <option value="author" ${search.search_type eq "postMemberId" ? "selected":""}>작성자</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <input type="text" name="search_word" class="form-control" placeholder="검색어 입력"
                               value="${search.search_word != null ? search.search_word : ''}" />
                    </div>

                    <div class="col-md-3 d-flex gap-1">
                        <button type="submit" class="btn btn-primary flex-fill" id="btnSearch">검색</button>
                        <button type="button" class="btn btn-link text-decoration-none" id="btnSearchInit">초기화</button>
                    </div>
                </div>
            </form>

            <!-- 상단 글 개수 및 페이지 사이즈 선택 -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <span>${postTotalCount}개의 글</span>
                <select class="form-select form-select-sm w-auto" name="page_size" id="selectPageSize">
                    <option value="5" ${search.page_size eq "5" ? "selected":""}>5개씩</option>
                    <option value="10" ${search.page_size eq "10" ? "selected":""}>10개씩</option>
                    <option value="15" ${search.page_size eq "15" ? "selected":""}>15개씩</option>
                    <option value="20" ${search.page_size eq "20" ? "selected":""}>20개씩</option>
                    <option value="30" ${search.page_size eq "30" ? "selected":""}>30개씩</option>
                </select>
            </div>

            <!-- 게시판 테이블 -->
            <c:choose>
                <c:when test="${not empty posts}">
                    <table class="table table-hover align-middle text-center small">
                        <colgroup>
                            <col style="width: 80px">
                            <col>
                            <col style="width: 118px">
                            <col style="width: 118px">
                            <col style="width: 68px">
                            <col style="width: 68px">
                            <col style="width: 118px">
                        </colgroup>
                        <thead class="table-light">
                        <tr>
                            <th>글번호</th>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>작성일</th>
                            <th>조회수</th>
                            <th>신고수</th>
                            <th>상태</th>
                        </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="post" items="${posts}">
                                <tr>
                                    <td>${post.postIdx}</td>
                                    <td class="text-start">
                                        <a href="#" class="text-decoration-none link-primary btn-show-modal" data-id="${post.postIdx}">
                                                ${post.postTitle}
                                        </a>
                                    </td>
                                    <td>${post.postMemberId}</td>
                                    <td>${fn:substringBefore(post.postCreatedAt, 'T')}</td>
                                    <td>${post.postReadCnt}</td>
                                    <td>${post.postReportCnt}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${post.postState == 1}">
                                                <i class="bi bi-eye text-success me-1"></i> 공개
                                            </c:when>
                                            <c:when test="${post.postState == 2}">
                                                <i class="bi bi-person-x text-secondary me-1"></i> 작성자 삭제
                                            </c:when>
                                            <c:when test="${post.postState == 3}">
                                                <i class="bi bi-shield-x text-danger me-1"></i> 관리자 삭제
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">알 수 없음</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <!-- 페이징 -->
                    <div class="d-flex justify-content-center my-3">
                            ${paging}
                    </div>
                </c:when>
                <c:when test="${not empty search and empty posts}">
                    <div class="alert alert-warning" role="alert">
                        검색 결과가 없습니다.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-warning" role="alert">
                        신고된 게시글이 없습니다.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <!-- 게시글 상세 모달 -->
    <div class="modal fade" id="postDetailModal" tabindex="-1" aria-labelledby="postDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="postDetailModalLabel">게시글 상세 보기</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
                </div>
                <div class="modal-body">
                    <h5 id="modalPostTitle" class="fw-bold mb-2"></h5>
                    <div class="text-muted small mb-3">
                        <span id="modalPostAuthor"></span> |
                        <span id="modalPostDate"></span> |
                        조회수: <span id="modalPostViews"></span>
                    </div>
                    <div id="modalPostContent" class="border-top pt-3"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" id="btnAdminDelete" data-id="">관리자 삭제</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Toast 메시지 -->
    <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
        <div id="toastMessage" class="toast align-items-center text-bg-dark border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body" id="toastText">알림 메시지</div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>
</div>

<script>


    document.addEventListener('DOMContentLoaded', function () {
        document.getElementById('btnSearchInit').addEventListener('click', function () {
            window.location.href = "list";
        });

        document.getElementById("selectPageSize").addEventListener('change', function () {
            const pageSize = this.value;
            const url = new URL(window.location.href);
            url.searchParams.set("page_size", pageSize);
            window.location.href = url.toString();
        });

        const rows = document.querySelectorAll('.clickable-row');
        rows.forEach(row => {
            row.addEventListener('click', function () {
                const url = this.dataset.href;
                if (url) window.location.href = url;
            });
        });
    });

    $(function () {
        $('input[name="datefilter"]').daterangepicker({
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

            const datefilter = $('input[name="datefilter"]').val();
            if (datefilter) {
                const dates = datefilter.split(' - ');
                $('#search_date1').val(dates[0]);
                $('#search_date2').val(dates[1]);
            } else {
                $('#search_date1').val('');
                $('#search_date2').val('');
            }

            $('form[name="frmSearch"]').submit();
        });


        $('#btnSearchInit').click(function () {
            $('input[name="search_word"]').val('');
            $('select[name="search_type"]').val('');
            $('input[name="datefilter"]').val('');

            const url = new URL(window.location.href);
            const params = url.searchParams;

            [
                'search_word', 'search_type', 'datefilter',
                'search_date1', 'search_date2',
                'page_size', 'page_no'
            ].forEach(p => params.delete(p));

            window.location.href = url.toString();
        });

    });

    $(document).ready(function () {
        $('.btn-show-modal').on('click', function (e) {
            e.preventDefault();
            const postIdx = $(this).data('id');

            $.ajax({
                url: '/admin/board/manage/view',
                method: 'GET',
                data: { idx: postIdx },
                success: function (data) {
                    $('#modalPostTitle').text(data.postTitle);
                    $('#modalPostAuthor').text("작성자: " + data.postMemberId);
                    $('#modalPostDate').text("작성일: " + moment(data.postCreatedAt).format('YYYY-MM-DD'));
                    $('#modalPostViews').text(data.postReadCnt);
                    $('#modalPostContent').html(data.postContent);
                    $('#btnAdminDelete').data('id', data.postIdx);


                    $('#btnAdminDelete').data('state', data.postState);


                    if (data.postState == 3) {
                        $('#btnAdminDelete').addClass('disabled').text('이미 삭제됨');
                    } else {
                        $('#btnAdminDelete').removeClass('disabled').text('관리자 삭제');
                    }

                    const modal = new bootstrap.Modal(document.getElementById('postDetailModal'));
                    modal.show();
                },
                error: function () {
                    alert('게시글 정보를 불러오지 못했습니다.');
                }
            });
        });
    });

    $('#btnAdminDelete').on('click', function () {
        const postIdx = $(this).data('id');
        const postState = $(this).data('state');


        if (postState == 3) {
            showToast("이미 삭제된 게시글입니다.", true);
            return;
        }

        console.log("삭제할 postIdx:", postIdx);
        if (!confirm("정말 이 게시글을 삭제하시겠습니까?")) return;

        $.ajax({
            url: '/admin/board/delete',
            method: 'POST',
            data: { postIdx: postIdx },
            success: function (res) {
                showToast(res.message, !res.success);
                if (res.success) {
                    const modal = bootstrap.Modal.getInstance(document.getElementById('postDetailModal'));
                    modal.hide();
                    window.location.reload();
                }
            },
            error: function () {
                showToast('삭제 중 오류가 발생했습니다.', true);
            }
        });
    });

    function showToast(message, isError = false) {
        const toastEl = document.getElementById("toastMessage");
        const toastText = document.getElementById("toastText");
        toastText.innerText = message;
        toastEl.classList.remove("text-bg-success", "text-bg-danger");
        toastEl.classList.add(isError ? "text-bg-danger" : "text-bg-success");
        new bootstrap.Toast(toastEl).show();
    }
</script>
</body>
</html>
