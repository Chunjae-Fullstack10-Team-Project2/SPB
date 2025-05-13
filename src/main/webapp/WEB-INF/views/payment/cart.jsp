<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>장바구니</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap + jQuery -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.js"></script>

    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Malgun Gothic', sans-serif;
        }

        .cart-title {
            font-size: 24px;
            font-weight: bold;
        }

        .cart-thumbnail {
            width: 130px;
            height: 80px;
            object-fit: cover;
        }

        .total-price {
            font-size: 20px;
            font-weight: bold;
        }

        .table td, .table th {
            vertical-align: middle;
        }

        @media (max-width: 576px) {
            .cart-thumbnail {
                width: 100px;
                height: 60px;
            }

            .btn {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
<%@ include file="../common/sidebarHeader.jsp" %>
<div class="content">
    <div class="container my-5">
        <h2 class="cart-title mb-4">장바구니</h2>
        <div class="row g-5">
            <!-- 장바구니 리스트 영역 -->
            <div class="col-md-7 col-lg-8">
                <div class="mb-3 form-check">
                    <input class="form-check-input" type="checkbox" id="checkAll" checked>
                    <label class="form-check-label" for="checkAll">전체 선택</label>
                </div>

                <table class="table table-hover align-middle bg-white rounded shadow-sm overflow-hidden">
                    <tbody>
                    <c:if test="${empty cartList}">
                        <div class="alert alert-warning mt-4" role="alert">
                            장바구니가 비었습니다.
                        </div>
                    </c:if>
                    <c:if test="${not empty cartList}">
                        <c:forEach var="lecture" items="${cartList}">
                            <tr id="cart-row-${lecture.cartLectureIdx}">
                                <td style="width: 5%;">
                                    <input type="checkbox" class="form-check-input checkbox" data-lecture-idx="${lecture.cartLectureIdx}" checked>
                                </td>
                                <td style="width: 15%;">
                                    <img src="/upload/${lecture.lectureThumbnailImg}" alt="썸네일" class="cart-thumbnail rounded">
                                </td>
                                <td>
                                    <div class="fw-bold">${lecture.lectureTitle}</div>
                                </td>
                                <td class="text-end price-cell" style="width: 20%;">
                                <span class="text-primary fw-semibold">
                                    <fmt:formatNumber value="${lecture.lectureAmount}" type="number"/>원
                                </span>
                                </td>
                                <td style="width: 15%;">
                                    <button type="button" class="btn btn-success btn-sm w-100" onclick="cartPaymentOne('${lecture.cartLectureIdx}')">수강하기</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    </tbody>
                </table>

                <div class="d-flex justify-content-end mt-4 gap-2">
                    <button type="button" class="btn btn-outline-danger" id="btnSelectDelete" onclick="cartDeleteSelected()">선택 삭제</button>
                    <button type="button" class="btn btn-primary" id="btnSelectLecture" onclick="cartPayment()">선택 강좌 수강</button>
                </div>
            </div>

            <!-- 결제 내역 사이드바 영역 -->
            <div class="col-md-5 col-lg-4">
                <h4 class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-black">결제 내역</span>
                    <span class="badge bg-primary rounded-pill" id="cart-count-badge">${fn:length(cartList)}</span>
                </h4>
                <ul class="list-group mb-3">
                    <c:forEach var="lecture" items="${cartList}">
                        <li class="list-group-item d-flex justify-content-between lh-sm">
                            <div>
                                <h6 class="my-0">${lecture.lectureTitle}</h6>
                            </div>
                            <span class="text-body-secondary">
                            <fmt:formatNumber value="${lecture.lectureAmount}" type="number"/>원
                        </span>
                        </li>
                    </c:forEach>
                    <li class="list-group-item d-flex justify-content-between">
                        <strong>총 금액</strong>
                        <strong class="text-danger total-price">0원</strong>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const checkboxes = document.querySelectorAll('.checkbox');
        const checkAll = document.getElementById('checkAll');

        function calculateTotal() {
            let total = 0;
            checkboxes.forEach(function(checkbox) {
                if (checkbox.checked) {
                    const row = checkbox.closest('tr');
                    const priceText = row.querySelector('.price-cell').textContent;
                    const price = parseInt(priceText.replace(/[^0-9]/g, '')) || 0;
                    total += price;
                }
            });

            document.querySelector('.total-price').textContent = total.toLocaleString() + '원';
        }

        if (checkAll) {
            checkAll.addEventListener('change', function () {
                checkboxes.forEach(function (checkbox) {
                    checkbox.checked = checkAll.checked;
                });
                calculateTotal(); // 총합 재계산
            });
        }

        // ✅ 개별 체크 변경 시 총합 계산 및 전체선택 체크 상태 동기화
        checkboxes.forEach(function (checkbox) {
            checkbox.addEventListener('change', function () {
                calculateTotal();

                // 일부라도 체크 해제되면 전체선택 체크 해제
                if (!checkbox.checked) {
                    checkAll.checked = false;
                } else {
                    // 모두 체크되었는지 확인
                    const allChecked = Array.from(checkboxes).every(cb => cb.checked);
                    checkAll.checked = allChecked;
                }
            });
        });

        // 페이지 로드시 총합 계산
        calculateTotal();
    });

    // 체크박스 전체 선택/해제 기능
    document.addEventListener('DOMContentLoaded', function() {
        // 장바구니 항목이 여러 개일 경우 전체 선택/해제 기능 구현
        const checkboxes = document.querySelectorAll('.checkbox');

        // 체크박스 상태에 따라 총액 계산 함수
        function calculateTotal() {
            let total = 0;
            checkboxes.forEach(function(checkbox) {
                if (checkbox.checked) {
                    const row = checkbox.closest('tr');
                    const priceText = row.querySelector('.price-cell').textContent;
                    const price = parseInt(priceText.replace(/[^0-9]/g, ''));
                    total += price;
                }
            });

            document.querySelector('.total-price').textContent = total.toLocaleString() + '원';
        }

        // 체크박스 변경 이벤트
        checkboxes.forEach(function(checkbox) {
            checkbox.addEventListener('change', calculateTotal);
        });
    });

    function cartDeleteSelected() {
        const checkedBoxes = document.querySelectorAll('.checkbox:checked');
        const selectCartItemIds = [];

        checkedBoxes.forEach(box => {
            const lectureIdx = box.getAttribute('data-lecture-idx');
            if (lectureIdx) {
                selectCartItemIds.push(parseInt(lectureIdx));
            }
        });

        if (selectCartItemIds.length === 0) {
            alert("삭제할 강좌를 선택해주세요.");
            return;
        }

        const data = {
            cartMemberId: "${memberId}",
            selectCartItemIds: selectCartItemIds
        };

        $.ajax({
            url: '/payment/cartDelete',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function (response) {
                alert("선택한 강좌가 삭제되었습니다.");
                location.reload();
            },
            error: function (xhr) {
                console.error('삭제 실패:', xhr.responseText);
                alert("삭제 중 오류가 발생했습니다.");
            }
        });
    }

    function cartPaymentOne(lectureIdx) {
        const selectCartItemIds = [];
        selectCartItemIds.push(lectureIdx);

        const query = 'lectureIdxList='  + selectCartItemIds.join('&lectureIdxList=');
        console.log("query == " + query);
        window.location.href = `/payment/payment?`+query;
    }

    function cartPayment(){
        const checkedBoxes = document.querySelectorAll('.checkbox:checked');
        const selectCartItemIds = [];

        checkedBoxes.forEach(box => {
            const lectureIdxStr = box.getAttribute('data-lecture-idx');
            const parsedIdx = parseInt(lectureIdxStr, 10);

            if (!isNaN(parsedIdx)) {
                selectCartItemIds.push(parsedIdx);
            }
        });

        console.log('선택된 강좌 ID: ', selectCartItemIds);

        if (selectCartItemIds.length === 0) {
            alert("수강 할 강좌를 선택해주세요.");
            return;
        }
        //const query = selectCartItemIds.map(id => `lectureIdxList=${id}`).join('&');
        //console.log('전송할 쿼리:', query);

        const query = 'lectureIdxList='  + selectCartItemIds.join('&lectureIdxList=');
        console.log("query == " + query);
        window.location.href = `/payment/payment?`+query;
    }
</script>
</body>
</html>
