<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>QnA</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
</head>
<body>
    <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/sidebarHeader.jsp" />
    <div class="content">
        <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/breadcrumb.jsp" />
        <div class="container my-5">
            <h1 class="mb-4">QnA</h1>

            <%
                List<Map<String, String>> dateSelect = new ArrayList<>();
                dateSelect.add(Map.of("value", "teacherQnaCreatedAt", "label", "문의 작성일"));
                dateSelect.add(Map.of("value", "teacherQnaAnsweredAt", "label", "문의 답변일"));

                List<Map<String, String>> searchSelect = new ArrayList<>();
                searchSelect.add(Map.of("value", "teacherQnaTitle", "label", "제목"));
                searchSelect.add(Map.of("value", "teacherQnaQContent", "label", "문의 내용"));
                searchSelect.add(Map.of("value", "teacherQnaAnsweredAt", "label", "답변 내용"));
                searchSelect.add(Map.of("value", "teacherQnaQMemberId", "label", "문의 작성자"));

                request.setAttribute("dateSelect", dateSelect);
                request.setAttribute("searchSelect", searchSelect);
                request.setAttribute("searchAction", "/teacher/personal/qna");
            %>
            <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/searchBoxOnlyPage.jsp" />

            <c:if test="${not empty qnaList}">
                <table class="table table-hover text-center align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>번호</th>
                        <th>
                            <a onclick="applySort('teacherQnaTitle')">
                                제목
                                <c:if test="${pageDTO['sort_by'] eq 'teacherQnaTitle'}">
                                    ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                        <th>
                            <a onclick="applySort('questionMemberName')">
                                작성자
                                <c:if test="${pageDTO['sort_by'] eq 'questionMemberName'}">
                                    ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                        <th>
                            <a onclick="applySort('teacherQnaCreatedAt')">
                                작성일
                                <c:if test="${pageDTO['sort_by'] eq 'teacherQnaCreatedAt'}">
                                    ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                        <th>
                            <a onclick="applySort('teacherQnaStatus')">
                                문의 상태
                                <c:if test="${pageDTO['sort_by'] eq 'teacherQnaStatus'}">
                                    ${pageDTO['sort_direction'] eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${qnaList}" var="qna" varStatus="status">
                        <tr>
                            <td>${pageDTO.total_count - ((pageDTO.page_no - 1) * pageDTO.page_size) - status.index}</td>
                            <td class="text-start">
                                <c:if test="${not empty qna.teacherQnaPwd}">
                                    <i class="bi bi-lock-fill"></i>
                                </c:if>
                                <a onclick="handleModal(${qna.teacherQnaIdx}, '${qna.teacherQnaPwd ne 0 ? 'Y' : 'N'}')"
                                   class="text-decoration-none text-dark">
                                        ${qna.teacherQnaTitle}
                                </a>
                            </td>
                            <td>${qna.questionMemberName}</td>
                            <td>${fn:substring(qna.teacherQnaCreatedAt, 0, 10)}</td>
                            <td>
                                <c:if test="${qna.teacherQnaStatus eq 0}">
                                    <span class="badge bg-secondary mb-1">미답변</span>
                                </c:if>
                                <c:if test="${qna.teacherQnaStatus eq 1}">
                                    <span class="badge bg-success mb-1">답변완료</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${empty qnaList}">
                <div class="alert alert-warning mt-4" role="alert">
                    게시글이 없습니다.
                </div>
            </c:if>

            <div class="mb-2 mb-md-0 text-center">
                <c:import url="${pageContext.request.contextPath}/WEB-INF/views/common/pagingOnlyPage.jsp" />
            </div>
        </div>
    </div>

    <div class="modal fade" id="pwdModal" tabindex="-1" aria-labelledby="pwdModalLabel" aria-hidden="true">
        <input type="hidden" id="selectedQnaIdx">
        <div class="modal-dialog">
            <div class="modal-content p-3">
                <div class="modal-header">
                    <h5 class="modal-title" id="pwdModalLabel">비밀번호 확인</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="password" class="form-control" id="qnaQPwdConfirm" placeholder="비밀번호를 입력하세요.">
                    <div class="text-danger mt-2" id="pwdError" style="display: none;">비밀번호가 일치하지 않습니다.</div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" onclick="verifyPassword()">확인</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function handleModal(idx, hasPwd) {
            if (hasPwd === 'Y') {
                $('#selectedQnaIdx').val(idx);
                $('#qnaQPwdConfirm').val('');
                $('#pwdError').hide();
                $('#pwdModal').modal('show');
            } else {
                const url = new URL(location.href);
                const params = url.searchParams;
                params.set('idx', idx);

                location.href = url.toString();
            }
        }

        function verifyPassword() {
            const idx = $('#selectedQnaIdx').val();
            const pwd = $('#qnaQPwdConfirm').val();

            $.post('/teacher/personal/qna/checkPwd', {
                idx: idx,
                pwd: pwd
            }).done(function () {
                $('#pwdError').hide();
                $('#pwdModal').modal('hide');

                const url = new URL(location.href);
                const params = url.searchParams;
                params.set('idx', idx);

                location.href = url.toString();
            }).fail(function () {
                $('#pwdError').show();
            });
        }
    </script>
</body>
</html>
