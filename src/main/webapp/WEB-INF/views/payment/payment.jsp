<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>학습 플랫폼 - 결제</title>
    <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
    <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
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
<%@ include file="../common/header.jsp" %>
<div class="page-container">
    <div class="content">
        <div class="payment-title">결제</div>
        <table class="order-items">
            <th colspan="2">구매자 정보</th>
                <tr>
                    <td>이름</td>
                    <td id="mName">${member.memberName}</td>
                </tr>
                <tr>
                    <td>Email</td>
                    <td id="mEmail">${member.memberEmail}</td>
                </tr>
                <tr>
                    <td>Phone</td>
                    <td id="mPhone">${member.memberPhone}</td>
                </tr>
        </table>
        <form id="frm">
        <div class="section">
            <table class="order-items">
                <th colspan="2">주문 내역</th>
                <c:forEach var="lecture" items="${selectedLectures}">
                    <tr>
                        <input type="hidden" name ="lectureIdx" value="${lecture.lectureIdx}" />
                        <input type="hidden" name="lectureTitle" value="${lecture.lectureTitle}" />
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
        </form>
        <div class="button-group">
            <button type="button" class="btn btn-primary" onclick="processPayment()">결제하기</button>
            <button type="button" class="btn btn-secondary" onclick="cancelOrder()">주문 취소</button>
        </div>
    </div>
</div>
<script>
    // 결제 수단에 따른 폼 표시/숨김 처리
    document.addEventListener('DOMContentLoaded', function() {

        let total = 0;
        document.querySelectorAll('.price').forEach(el => {
            const price = parseInt(el.textContent.replace(/[^0-9]/g, ''));
            total += price;
        });
        document.getElementById('total-price').textContent = total.toLocaleString() + '원';
    });

    // 결제 처리 함수
    function processPayment() {

        const data = {
            orderId : "${member.memberId}",
            orderAmount : document.getElementById('total-price').textContent.replace("원","").replace(",",""),
            orderLectureList : $("input[name='lectureIdx']").map(function () {
                return $(this).val();
            }).get()
        }

        console.log(JSON.stringify(data));

        $.ajax({
            url: '/payment/insertOrder',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function (response) {
                    var paymentMethod = $("input[name='payment-method']:checked").val();
                requestPay(response);
            },
            error: function (request,status,error) {
                console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                alert("등록 중 오류가 발생했습니다.");
            }
        });
    }

    // 주문 취소 함수
    function cancelOrder() {
        if (confirm('주문을 취소하시겠습니까?')) {
            // 장바구니 페이지로 이동
            window.location.href = '/payment/cart?memberId=${member.memberId}';
            alert('주문이 취소되었습니다.');
        }
    }


    function requestPay(orderIdx) {
        const lectureTitleElements = document.querySelectorAll("input[name='lectureTitle']");
        const lectureTitles = Array.from(lectureTitleElements).map(el => el.value);

        let displayTitle = "";
        if (lectureTitles.length === 1) {
            displayTitle = lectureTitles[0];
        } else if (lectureTitles.length > 1) {
            displayTitle = lectureTitles[0]+' 외 '+ (lectureTitles.length - 1)+'건';
        }

        var IMP = window.IMP;
        IMP.init("imp28817856");
        IMP.request_pay({
            pg: "html5_inicis.INIpayTest",
            pay_method: "card",
            merchant_uid: orderIdx,
            name: displayTitle,
            amount: document.getElementById('total-price').textContent.replace("원","").replace(",",""),
            buyer_email: "${member.memberEmail}",
            buyer_name: "${member.memberName}",
            buyer_tel: "${member.memberPhone}",
        }, function (rsp) {
            console.log("rsp === " + rsp);
            if (rsp.success) {
                // POST 방식으로 imp_uid와 merchant_uid 전송
                fetch("/payment/verify", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({
                        imp_uid: rsp.imp_uid,
                        merchant_uid: rsp.merchant_uid
                    })
                })
                    .then(res => res.json())
                    .then(data => {
                        if (data.status === "success") {
                            alert("결제 성공 처리 완료!");
                        } else {
                            alert("결제 검증 실패: " + data.message);
                        }
                    });
            } else {
                alert("결제 실패: " + rsp.error_msg);
            }
        });
    }
</script>
</body>
</html>
