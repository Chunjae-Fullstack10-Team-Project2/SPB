<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>학습 플랫폼 - 결제</title>
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
            max-width: 800px;
            margin: 0 auto;
            border: 1px solid #ddd;
        }

        header {
            padding: 15px;
            border-bottom: 1px solid #ddd;
        }

        .content {
            padding: 20px;
        }

        .payment-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .section {
            margin-bottom: 30px;
        }

        .section-title {
            font-weight: bold;
            margin-bottom: 15px;
        }

        .payment-methods {
            margin-bottom: 20px;
        }

        .payment-method {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

        .payment-method input[type="radio"] {
            margin-right: 10px;
        }

        .order-items {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
        }

        .order-items td {
            padding: 10px 0;
        }

        .order-items .price {
            text-align: right;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            padding-top: 15px;
            border-top: 1px solid #ddd;
            font-weight: bold;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
        }

        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .form-row {
            display: flex;
            gap: 15px;
        }

        .form-row .form-group {
            flex: 1;
        }

        .button-group {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 30px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-primary {
            background-color: #999;
            color: white;
        }

        .btn-secondary {
            background-color: #ccc;
            color: #333;
        }

        @media (max-width: 576px) {
            .form-row {
                flex-direction: column;
                gap: 0;
            }
        }
    </style>
</head>
<body>
<div class="page-container">
    <div class="content">
        <div class="payment-title">결제</div>

        <div class="section">
            <div class="section-title">결제 수단</div>
            <div class="payment-methods">
                <div class="payment-method">
                    <input type="radio" id="credit-card" name="payment-method" checked>
                    <label for="credit-card">신용카드</label>
                </div>
                <div class="payment-method">
                    <input type="radio" id="easy-payment" name="payment-method">
                    <label for="easy-payment">간편결제</label>
                </div>
                <div class="payment-method">
                    <input type="radio" id="bank-transfer" name="payment-method">
                    <label for="bank-transfer">무통장입금</label>
                </div>
            </div>
        </div>

        <div class="section">
            <table class="order-items">
                <th colspan="2">주문 내역</th>
                <c:forEach var="lecture" items="${selectedLectures}">
                    <tr>
                        <td>${lecture.lectureTitle}</td>
                        <td class="price">${lecture.lectureAmount}원</td>
                    </tr>
                </c:forEach>
            </table>
            <div class="total-row">
                <div>총 금액</div>
                <div id="total-price">39,600원</div>
            </div>
        </div>

        <div class="section" id="credit-card-form">
            <div class="form-group">
                <label for="card-number" class="form-label">카드번호</label>
                <input type="text" id="card-number" class="form-control" placeholder="0000-0000-0000-0000">
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="expiry-date" class="form-label">만료일</label>
                    <input type="text" id="expiry-date" class="form-control" placeholder="MM/YY">
                </div>
                <div class="form-group">
                    <label for="cvc" class="form-label">CVC</label>
                    <input type="text" id="cvc" class="form-control" placeholder="123">
                </div>
            </div>
            <div class="form-group">
                <label for="email" class="form-label">이메일</label>
                <input type="email" id="email" class="form-control" placeholder="example@email.com">
            </div>
        </div>

        <div class="button-group">
            <button type="button" class="btn btn-primary" onclick="processPayment()">결제하기</button>
            <button type="button" class="btn btn-secondary" onclick="cancelOrder()">주문 취소</button>
        </div>
    </div>
</div>

<script>
    // 결제 수단에 따른 폼 표시/숨김 처리
    document.addEventListener('DOMContentLoaded', function() {
        const creditCardRadio = document.getElementById('credit-card');
        const easyPaymentRadio = document.getElementById('easy-payment');
        const bankTransferRadio = document.getElementById('bank-transfer');
        const creditCardForm = document.getElementById('credit-card-form');

        function togglePaymentForm() {
            if (creditCardRadio.checked) {
                creditCardForm.style.display = 'block';
            } else {
                creditCardForm.style.display = 'none';
            }
        }

        creditCardRadio.addEventListener('change', togglePaymentForm);
        easyPaymentRadio.addEventListener('change', togglePaymentForm);
        bankTransferRadio.addEventListener('change', togglePaymentForm);

        let total = 0;
        document.querySelectorAll('.price').forEach(el => {
            const price = parseInt(el.textContent.replace(/[^0-9]/g, ''));
            total += price;
        });
        document.getElementById('total-price').textContent = total.toLocaleString() + '원';
    });

    // 결제 처리 함수
    function processPayment() {
        // 입력값 검증
        const cardNumber = document.getElementById('card-number').value;
        const expiryDate = document.getElementById('expiry-date').value;
        const cvc = document.getElementById('cvc').value;
        const email = document.getElementById('email').value;
        const totalPrice = document.getElementById('total-price').value;

        // if (document.getElementById('credit-card').checked) {
        //     if (!cardNumber || !expiryDate || !cvc || !email) {
        //         alert('모든 필드를 입력해주세요.');
        //         return;
        //     }
        // }
        const data = {
            orderId : "dog109",
            orderAmount : totalPrice
        }
        $.ajax({
            url: '/payment/insertOrder',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function (response) {
                goPayment();
            },
            error: function (xhr) {
                console.error('등록 실패:', xhr.responseText);
                alert("등록 중 오류가 발생했습니다.");
            }
        });
        // 실제로는 서버로 결제 정보를 전송하는 코드가 들어갈 자리
        //alert('결제가 완료되었습니다.');
        // 결제 완료 후 이동할 페이지
        // window.location.href = 'payment-complete.jsp';
    }

    function goPayment(){
        $.ajax({
            url:'/payment/kakaoPayReady',
            type: 'POST',
            data: JSON.stringify({
                "cid": "TC0ONETIME",
                "partner_order_id": "partner_order_id",
                "partner_user_id": "partner_user_id",
                "item_name": "초코파이",
                "quantity": "1",
                "total_amount": "2200",
                "vat_amount": "200",
                "tax_free_amount": "0",
                "approval_url": "https://developers.kakao.com/success",
                "fail_url": "https://developers.kakao.com/fail",
                "cancel_url": "https://developers.kakao.com/cancel"
            }),
            contentType: "application/json",
            success: function (response) {
                console.log("response === " + response);
                window.location.href = response.next_redirect_pc_url;
            },
            error: function (request,status,error) {
                console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
    }

    // 주문 취소 함수
    function cancelOrder() {
        if (confirm('주문을 취소하시겠습니까?')) {
            // 장바구니 페이지로 이동
            // window.location.href = 'cart.jsp';
            alert('주문이 취소되었습니다.');
        }
    }
</script>
</body>
</html>
