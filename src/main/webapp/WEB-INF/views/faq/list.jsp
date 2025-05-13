<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
</head>
<body>
<%@ include file="../common/header.jsp" %>
<div class="content-nonside">
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
                <li class="breadcrumb-item active">
                    자주 묻는 질문
                </li>
            </ol>
        </nav>
    </div>
    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">문의 목록</h3>
            <c:if test="${memberGrade eq '0'}">
                <a href="/faq/regist" class="btn btn-primary">
                    <i class="bi bi-pencil-square"></i> 문의 등록
                </a>
            </c:if>
        </div>
        <%
            List<Map<String, String>> searchTypeOptions = new ArrayList<>();
            searchTypeOptions.add(Map.of("value", "faqQuestion", "label", "질문"));
            searchTypeOptions.add(Map.of("value", "faqAnswer", "label", "답변"));
            request.setAttribute("searchTypeOptions", searchTypeOptions);
            request.setAttribute("searchAction", "/faq/list");
        %>
        <jsp:include page="../common/searchBox.jsp"/>
        <c:if test="${not empty faqList}">
            <div class="accordion" id="faqAccordion">
                <c:forEach var="faqDTO" items="${faqList}" varStatus="status">
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="heading${faqDTO.faqIdx}">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#collapse${faqDTO.faqIdx}" aria-expanded="false"
                                    aria-controls="collapse${faqDTO.faqIdx}">
                                <span class="faq-question-view">Q. ${faqDTO.faqQuestion}</span>
                                <input type="text" class="form-control faq-question-edit d-none"
                                       value="${faqDTO.faqQuestion}"/>
                            </button>
                        </h2>

                        <div id="collapse${faqDTO.faqIdx}" class="accordion-collapse collapse"
                             aria-labelledby="heading${faqDTO.faqIdx}" data-bs-parent="#faqAccordion">
                            <div class="accordion-body">
                                <div class="faq-view" data-id="${faqDTO.faqIdx}">
                                    <p class="mb-2"><strong>A.</strong></p>
                                    <p class="faq-answer">${faqDTO.faqAnswer}</p>
                                    <c:if test="${sessionScope.memberGrade eq '0'}">
                                        <div class="text-end">
                                            <button class="btn btn-sm btn-outline-secondary btn-edit">수정</button>
                                            <button class="btn btn-sm btn-outline-danger btn-delete">삭제</button>
                                        </div>
                                    </c:if>
                                    <div class="text-end text-muted mt-2">
                                        작성일: <fmt:formatDate value="${faqDTO.faqCreatedAt}" pattern="yyyy-MM-dd"/>
                                    </div>
                                </div>
                                <div class="faq-edit d-none" data-id="${faqDTO.faqIdx}">
                                    <textarea class="form-control mb-2 faq-answer-edit char-limit"
                                              data-maxlength="19000"
                                              data-target="#faqAnswerCount2_${faqDTO.faqIdx}"
                                              rows="4"
                                              style="resize: none;"
                                              required>${faqDTO.faqAnswer}</textarea>

                                    <div class="text-end small text-muted mt-1 mb-3">
                                        <span id="faqAnswerCount2_${faqDTO.faqIdx}">0</span> / 19000
                                    </div>

                                    <div class="d-flex justify-content-end gap-2">
                                        <button class="btn btn-sm btn-primary btn-save">저장</button>
                                        <button class="btn btn-sm btn-secondary btn-cancel">취소</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${empty faqList}">
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
    function bindTextCounter(textarea) {
        const maxLength = parseInt(textarea.dataset.maxlength || "1000", 10);
        const counterSelector = textarea.dataset.target;
        const counterEl = counterSelector ? document.querySelector(counterSelector) : null;

        textarea.removeEventListener('input', textarea._textCounterListener);

        const listener = function () {
            let text = textarea.value;
            if (text.length > maxLength) {
                textarea.value = text.substring(0, maxLength);
            }
            if (counterEl) {
                counterEl.textContent = textarea.value.length;
            }
        };

        // 바인딩하고 핸들러 저장
        textarea.addEventListener('input', listener);
        textarea._textCounterListener = listener;

        // 최초 상태 반영
        if (counterEl) {
            counterEl.textContent = textarea.value.length;
        }
    }

    $(document).on('click', '.btn-edit', function () {
        const container = $(this).closest('.accordion-body');
        const header = container.closest('.accordion-item').find('.accordion-button');

        container.find('.faq-view').addClass('d-none');
        container.find('.faq-edit').removeClass('d-none');

        header.find('.faq-question-view').addClass('d-none');
        header.find('.faq-question-edit').removeClass('d-none');

        container.find('textarea.char-limit').each(function () {
            bindTextCounter(this);
            this.dispatchEvent(new Event('input'));
        });
    });

    $(document).on('click', '.btn-cancel', function () {
        const container = $(this).closest('.accordion-body');
        const header = container.closest('.accordion-item').find('.accordion-button');

        container.find('.faq-edit').addClass('d-none');
        container.find('.faq-view').removeClass('d-none');

        header.find('.faq-question-edit').addClass('d-none');
        header.find('.faq-question-view').removeClass('d-none');
    });

    $(document).on('click', '.btn-save', function () {
        const container = $(this).closest('.accordion-body');
        const header = container.closest('.accordion-item').find('.accordion-button');

        const faqIdx = container.find('.faq-edit').data('id');
        const question = header.find('.faq-question-edit').val().trim();
        const answer = container.find('.faq-answer-edit').val().trim();

        $.ajax({
            url: '/faq/update',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                faqIdx: faqIdx,
                faqQuestion: question,
                faqAnswer: answer
            }),
            success: function (response) {
                // 업데이트된 내용으로 바로 화면에 반영
                container.find('.faq-answer').text(answer);
                header.find('.faq-question-view').text("Q. " + question);
                header.find('.faq-question-edit').val(question);

                container.find('.faq-edit').addClass('d-none');
                container.find('.faq-view').removeClass('d-none');
                header.find('.faq-question-edit').addClass('d-none');
                header.find('.faq-question-view').removeClass('d-none');
            },
            error: function () {
                alert("FAQ 수정에 실패했습니다. 다시 시도해주세요.");
            }
        });
    });

    $(document).on('click', '.btn-delete', function () {
        if (!confirm('정말 삭제하시겠습니까?')) return;

        const container = $(this).closest('.accordion-item');
        const faqIdx = container.find('.faq-edit').data('id');

        $.ajax({
            url: '/faq/delete',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(faqIdx),
            success: function (res) {
                if (res === 'success') {
                    container.remove();
                } else {
                    alert('삭제 실패');
                }
            },
            error: function () {
                alert('삭제 중 오류가 발생했습니다.');
            }
        });
    });

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
            $('select[name="searchType"]').val('faqQuestion');
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