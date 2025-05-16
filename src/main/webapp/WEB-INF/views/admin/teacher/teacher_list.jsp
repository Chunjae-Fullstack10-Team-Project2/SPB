<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>선생님 페이지 관리</title>
</head>
<body>
<div>
    <div class="container mt-5 mb-2 d-flex justify-content-between">
        <h2 class="h4 fw-bold">선생님 요청 목록</h2>
    </div>

    <div class="container mb-2 d-flex justify-content-between">
        <div class="text-muted my-2">${totalCount}명의 선생님이 등록되어 있습니다.</div>
        <select class="form-select form-select-sm w-auto" name="page_size" id="selectPageSize">
            <option value="5" ${search.page_size == 5 ? "selected":""}>5개씩</option>
            <option value="10" ${search.page_size == 10 ? "selected":""}>10개씩</option>
            <option value="15" ${search.page_size == 15 ? "selected":""}>15개씩</option>
            <option value="20" ${search.page_size == 20 ? "selected":""}>20개씩</option>
            <option value="30" ${search.page_size == 30 ? "selected":""}>30개씩</option>
        </select>
    </div>

    <div class="container my-2" style="max-height: 100vh;">
        <table class="table table-hover text-center align-middle">
            <thead class="table-light">
                <tr>
                    <th scope="col">No</th>
                    <th scope="col">과목</th>
                    <th scope="col">이름</th>
                    <th scope="col">생년월일</th>
                    <th scope="col">회원 가입일</th>
                    <th scope="col">선생님 페이지</th>
                    <th scope="col">상태</th>
                    <th scope="col">정보 수정</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty teacher1}">
                    <c:forEach items="${teacher1}" var="member" varStatus="status">
                        <tr class="clickable-row" data-href="/teacher/personal?teacherId=${member.memberId}">
                            <td>${status.count} </td>
                            <td class="text-truncate" style="max-width: 60px;">${member.teacherSubject}</td>
                            <td>${member.memberName}(${member.memberId})</td>
                            <td>
                                <c:set var="rawDate" value="${member.memberBirth}" />
                                    ${fn:substring(rawDate, 0, 4)}-${fn:substring(rawDate, 4, 6)}-${fn:substring(rawDate, 6, 8)}
                            </td>
                            <td>${member.memberCreatedAt}</td>
                            <td>
                                <a href="/teacher/personal?teacherId=${member.memberId}" class="btnModifyTeacher btn btn-sm btn-secondary"><i class="bi bi-person-badge"></i> 이동</a>
                            <td>
                                <c:choose>
                                    <c:when test="${member.teacherState == 1}"><span class="badge bg-success">정상</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary">삭제됨</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${member.teacherState == 1}">
                                        <button type="button" data-member-id="${member.memberId}" class="btnModifyTeacher btn btn-sm btn-warning"><i class="bi bi-pencil"></i> 수정</button>
                                        <button type="button" class="btn btn-sm btn-danger btnDelete" data-teacher-id="${member.memberId}"><i class="bi bi-trash"></i> 삭제</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn btn-sm btn-danger btnRestoreTeacher"
                                                data-teacher-id="${member.memberId}">
                                            <i class="bi bi-arrow-counterclockwise"></i> 복구
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="8" style="text-align: center;padding: 20px;">
                            등록된 회원 정보가 없습니다.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
        <div class="text-center">${paging1}</div>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.addEventListener('click', function (e) {
            const btn = e.target.closest('.btnModifyTeacher');
            if (btn) {
                e.stopPropagation();
                const memberId = btn.getAttribute('data-member-id');
                window.location.href = 'modify?teacherId=' + memberId;
            }
        });
    });

    $(document).on('click', '.btnDelete', function(e) {
        const teacherId = $(this).data('teacher-id');
        const button = this;
        if (confirm('삭제하시겠습니까?')) {
            $.ajax({
                url: 'delete',
                type: 'POST',
                data: {teacherId: teacherId},
                success: function () {
                    showToast('삭제되었습니다.');
                    const row = $(button).closest('tr');
                    const badgeCell = row.find('td').eq(6);
                    const controlCell = row.find('td').eq(7);
                    badgeCell.html('<span class="badge bg-secondary">삭제됨</span>');
                    controlCell.html('<button type="button" class="btn btn-sm btn-danger btnRestoreTeacher" data-teacher-id="' +
                        teacherId +
                        '"><i class="bi bi-arrow-counterclockwise"></i> 복구</button>');
                },
                error: function () {
                    showToast('삭제 중 오류가 발생했습니다.', true);
                }
            });
        }
    });

    $(document).on('click', '.btnRestoreTeacher', function (e) {
        const teacherId = $(this).data('teacher-id');
        const button = this;
        if (confirm('복구하시겠습니까?')) {
            $.ajax({
                url: 'restore',
                type: 'POST',
                data: { teacherId: teacherId },
                success: function () {
                    showToast('복구되었습니다.');
                    const row = $(button).closest('tr');
                    const badgeCell = row.find('td').eq(6);
                    const controlCell = row.find('td').eq(7);
                    badgeCell.html('<span class="badge bg-success">정상</span>');
                    controlCell.html('<button type="button" data-member-id="' +
                        teacherId +
                        '" class="btnModifyTeacher btn btn-sm btn-warning"><i class="bi bi-pencil"></i> 수정</button>' +
                        '<button type="button" class="btn btn-sm btn-danger btnDelete" data-teacher-id="' +
                        teacherId +
                        '"><i class="bi bi-trash"></i> 삭제</button>'
                    );
                },
                error: function () {
                    showToast('삭제 중 오류가 발생했습니다.', true);
                }
            });
        }
    });
</script>
</body>
</html>
