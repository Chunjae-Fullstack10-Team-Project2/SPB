<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>메인 페이지</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<%@include file="fixedHeader.jsp" %>
<%@include file="sidebar.jsp" %>
<div class="content" style="margin-left: 280px; margin-top: 100px;">

    <div class="modal fade" id="pwdChangeModal" tabindex="-1" aria-labelledby="pwdChangeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="pwdChangeModalLabel">비밀번호 변경 안내</h5>
                </div>
                <div class="modal-body">
                    <p>비밀번호를 변경하신지 90일이 지났습니다.<br>비밀번호를 변경하시겠습니까?</p>
                </div>
                <div class="modal-footer">
                    <a href="/changePwd" class="btn btn-primary">예</a>
                    <button type="button" class="btn btn-secondary" id="btnRemindLater">90일 후 다시 알림</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const modal = new bootstrap.Modal(document.getElementById('pwdChangeModal'));

    <c:if test="${sessionScope.memberDTO.memberState == '3'}">
    window.onload = () => modal.show();
    </c:if>

    document.getElementById("btnRemindLater").addEventListener("click", function () {
        const memberId = "${sessionScope.memberDTO.memberId}";

        fetch('/updatePwdChangeDate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({memberId: memberId})
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert("알림이 설정되었습니다. 비밀번호 변경 알림이 연기되었습니다.");

                    modal.hide();
                } else {
                    alert("알림 설정에 실패했습니다.");
                }
            })
            .catch(error => console.error('Error:', error));
    });
</script>
</body>
</html>
