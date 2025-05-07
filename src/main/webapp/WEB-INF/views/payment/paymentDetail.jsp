<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>구매 내역 상세</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
</head>
<body class="bg-light">
<div class="container my-5">

    <!-- 상단 헤더 -->
    <div class="text-center mb-5">
        <h1 class="h3 fw-bold">
            <i class="bi bi-journal-text me-2"></i>구매 내역 상세
        </h1>
        <div class="text-muted">
            <i class="bi bi-receipt me-1"></i>주문번호: ${orderIdx}
        </div>
        <p class="text-secondary mt-2">구매하신 강의 내역입니다. 아래에서 확인하세요.</p>
    </div>

    <!-- 강의 카드 리스트 -->
    <div class="card mb-4">
        <div class="card-header fw-bold bg-white">구매한 강의수 ${lectureDTOSize}개</div>
        <div class="card-body p-0">
            <c:forEach var="lecture" items="${lectureDTO}">
                <div class="row g-0 border-bottom p-3 align-items-center">
                    <div class="col-md-3">
                        <img src="${lecture.lectureThumbnailImg}" class="img-fluid rounded" style="height: 120px; object-fit: cover;" alt="강의 썸네일">
                    </div>
                    <div class="col-md-7 ps-3">
                        <h5 class="mb-1">${lecture.lectureTitle}</h5>
                        <p class="text-muted mb-1">${lecture.lectureTeacherName}</p>
                        <p class="fw-semibold text-primary">₩${lecture.lectureAmount}</p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- 결제 금액 정보 -->
    <div class="card mb-4">
        <div class="card-body d-flex justify-content-between align-items-center">
            <span class="fw-bold">총 결제 금액</span>
            <span class="fs-5 text-danger fw-bold" id="total-amount">
                ₩<fmt:formatNumber value="${totalAmount}" type="number" />
            </span>
        </div>
    </div>

    <!-- 결제 상태 정보 -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="d-flex justify-content-between">
                <span class="text-muted">결제 상태</span>
                <c:choose>
                    <c:when test="${paymentDTO.paymentStatus eq 's'}">
                        <span class="badge bg-success">결제 완료</span>
                    </c:when>
                    <c:when test="${paymentDTO.paymentStatus eq 'p'}">
                        <span class="badge bg-warning text-dark">결제 대기</span>
                    </c:when>
                    <c:when test="${paymentDTO.paymentStatus eq 'c'}">
                        <span class="badge bg-danger">결제 취소</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-secondary">알 수 없음</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- 버튼 -->
    <div class="d-grid gap-2">
        <a href="/lecture/list" class="btn btn-success btn-lg"><i class="bi bi-play-circle me-1"></i>수강하러 가기</a>
        <button class="btn btn-outline-danger btn-sm"
                onclick="openCancelModal(${orderIdx}, ${totalAmount})">
            취소
        </button>
    </div>
</div>
<!-- 취소 모달 -->
<div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="cancelModalLabel">결제 취소 사유 입력</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="modalOrderIdx">
                <input type="hidden" id="modalAmount">
                <div class="mb-3">
                    <label for="cancelReason" class="form-label">취소 사유</label>
                    <textarea class="form-control" id="cancelReason" rows="3" placeholder="사유를 입력해 주세요"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-danger" onclick="submitCancel()">취소하기</button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>

    function openCancelModal(orderIdx, amount) {
        document.getElementById("modalOrderIdx").value = orderIdx;
        document.getElementById("modalAmount").value = amount;
        document.getElementById("cancelReason").value = ""; // 초기화

        const modal = new bootstrap.Modal(document.getElementById('cancelModal'));
        modal.show();
    }

    function submitCancel() {
        const merchant_uid = document.getElementById("modalOrderIdx").value;
        const amount = document.getElementById("modalAmount").value;
        const reason = document.getElementById("cancelReason").value.trim();

        if (reason === "") {
            alert("취소 사유를 입력해 주세요.");
            return;
        }

        $.ajax({
            url: '/payment/cancel',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                merchant_uid: merchant_uid,
                reason: reason,
                amount: parseInt(amount)
            }),
            success: function (response) {
                alert("결제 취소가 완료되었습니다.");
                location.reload();
            },
            error: function (request, status, error) {
                console.error("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                alert("취소 중 오류가 발생했습니다.");
            }
        });

    }


</script>
</body>
</html>