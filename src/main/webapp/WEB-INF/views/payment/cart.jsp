<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>학습 플랫폼 - 장바구니</title>
    <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Malgun Gothic', sans-serif;
        }

        body {
            background-color: #fff;
            color: #333;
            line-height: 1.5;
        }

        .page-container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            border: 1px solid #ddd;
        }


        .content {
            padding: 20px;
        }

        .cart-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .cart-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        .cart-table th {
            background-color: #f5f5f5;
            padding: 10px;
            text-align: center;
            border-top: 1px solid #ddd;
            border-bottom: 1px solid #ddd;
        }

        .cart-table td {
            padding: 15px 10px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        .cart-table .title-cell {
            text-align: center;
        }

        .cart-table .price-cell {
            text-align: right;
        }

        .checkbox {
            width: 16px;
            height: 16px;
        }

        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            background-color: #ccc;
            color: #333;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #bbb;
        }

        .total-area {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            margin-bottom: 30px;
            padding-top: 15px;
            border-top: 1px solid #ddd;
        }

        .total-label {
            font-weight: bold;
            margin-right: 20px;
        }

        .total-price {
            font-weight: bold;
            font-size: 18px;
        }

        .button-group {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        @media (max-width: 768px) {
            .cart-table {
                font-size: 14px;
            }

            .cart-table th:nth-child(1),
            .cart-table td:nth-child(1) {
                width: 10%;
            }

            .button-group {
                flex-wrap: wrap;
            }

            .btn {
                font-size: 14px;
            }
        }

        @media (max-width: 576px) {
            .cart-table th:nth-child(1),
            .cart-table td:nth-child(1) {
                display: none;
            }

            .button-group {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
<div class="page-container">
    <div class="content">
        <div class="cart-title">장바구니</div>

        <table class="cart-table">
            <thead>
            <tr>
                <th width="10%">
                    전체선택<br><input type="checkbox" id="checkAll">
                </th>
                <th width="50%">제목</th>
                <th width="20%">금액</th>
                <th width="20%">수강하기</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="lecture" items="${cartList}">
                <tr>
                    <td>
                        <input type="checkbox" class="checkbox" data-lecture-idx="${lecture.cartLectureIdx}" checked>
                    </td>
                    <td class="title-cell">${lecture.lectureTitle}</td>
                    <td class="price-cell">${lecture.lectureAmount}원</td>
                    <td>
                        <button type="button" class="btn">수강하기</button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <div class="total-area">
            <div class="total-label">총 금액</div>
            <div class="total-price"></div>
        </div>

        <div class="button-group">
            <button type="button" class="btn" id="btnSelectDelete" onclick="cartDeleteSelected()">선택삭제</button>
            <button type="button" class="btn" id="btnSelectLecture" onclick="cartPayment()">선택강좌수강</button>
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
            cartMemberId: "dog109",
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
