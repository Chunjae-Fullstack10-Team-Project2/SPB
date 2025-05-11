<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>봄콩이</title>
    <link href="/resources/css/carousel.css" rel="stylesheet">
    <style>
        .carousel-item {
            position: relative;
        }

        .carousel-item .overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.4);
            z-index: 1;
        }

        .carousel-caption {
            position: relative;
            z-index: 2;
        }
    </style>
</head>
<body>
<%@ include file="../common/header.jsp" %>
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
                <a href="/mypage/changePwd" class="btn btn-primary">예</a>
                <button type="button" class="btn btn-secondary" id="btnRemindLater">90일 후 다시 알림</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="emailVerifyModal" tabindex="-1" aria-labelledby="emailVerifyModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">이메일 인증 필요</h5>
            </div>
            <div class="modal-body">
                <p>휴면 상태입니다. 이메일 인증 후 서비스를 이용해주세요.</p>
                <div class="mb-3">
                    <input type="email" class="form-control" id="emailInput"
                           value="${sessionScope.memberDTO.memberEmail}" readonly>
                </div>
                <button id="btnSendEmail" class="btn btn-primary w-100 mb-2">인증코드 전송</button>

                <div class="mb-3">
                    <input type="text" class="form-control" id="codeInput" placeholder="인증코드 입력" maxlength="6">
                </div>
                <div class="mb-2">
                    <span id="emailCountWarning" class="warning-text text-danger"></span>
                    <span id="emailAuthTimeWarning" class="warning-text text-danger"></span>
                </div>
                <button id="btnCheckCode" class="btn btn-success w-100">인증 확인</button>
            </div>
        </div>
    </div>
</div>
<div>
    <div id="myCarousel" class="carousel slide mb-6" data-bs-ride="carousel">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#myCarousel" data-bs-slide-to="0" class="active"
                    aria-current="true" aria-label="Slide 1"></button>
            <button type="button" data-bs-target="#myCarousel" data-bs-slide-to="1" aria-label="Slide 2"></button>
            <button type="button" data-bs-target="#myCarousel" data-bs-slide-to="2" aria-label="Slide 3"></button>
        </div>
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="/resources/img/spb_logo.png" class="d-block w-100" alt="추천 강의 1">
                <div class="overlay"></div>
                <div class="container">
                    <div class="carousel-caption text-start">
                        <h1>초등 수학 마스터 과정</h1>
                        <p class="opacity-75">기초부터 탄탄하게! 수학에 자신감을 심어주는 커리큘럼.</p>
                        <p><a class="btn btn-lg btn-primary" href="#">강의 살펴보기</a></p>
                    </div>
                </div>
            </div>
            <div class="carousel-item">
                <img src="/resources/img/spb_logo.png" class="d-block w-100" alt="추천 강의 2">
                <div class="overlay"></div>
                <div class="container">
                    <div class="carousel-caption">
                        <h1>중등 영어 회화 집중반</h1>
                        <p>원어민처럼 말하고 싶은 친구들을 위한 최고의 선택.</p>
                        <p><a class="btn btn-lg btn-primary" href="#">강의 살펴보기</a></p>
                    </div>
                </div>
            </div>
            <div class="carousel-item">
                <img src="/resources/img/spb_logo.png" class="d-block w-100" alt="추천 강의 3">
                <div class="overlay"></div>
                <div class="container">
                    <div class="carousel-caption text-end">
                        <h1>과학실험으로 배우는 물리</h1>
                        <p>직접 실험하며 배우는 원리, 재미와 이해를 동시에!</p>
                        <p><a class="btn btn-lg btn-primary" href="#">강의 살펴보기</a></p>
                    </div>
                </div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#myCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#myCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </div>


    <!-- Marketing messaging and featurettes
    ================================================== -->
    <!-- Wrap the rest of the page in another container to center all the content. -->

    <div class="container marketing">

        <!-- Three columns of text below the carousel -->
        <div class="row">
            <div class="col-lg-4">
                <img src="/resources/img/spb_logo.png" class="rounded-circle" width="140" height="140" alt="강사진">
                <h2 class="fw-bold">우수 강사진</h2>
                <p>현직 교사, 교육 전문가들이 직접 강의합니다.</p>
                <p><a class="btn btn-secondary" href="#">더 알아보기 &raquo;</a></p>
            </div>
            <div class="col-lg-4">
                <img src="/resources/img/spb_logo.png" class="rounded-circle" width="140" height="140" alt="콘텐츠">
                <h2 class="fw-bold">다양한 콘텐츠</h2>
                <p>기초부터 심화까지! 초·중·고 전과목 학습자료 제공.</p>
                <p><a class="btn btn-secondary" href="#">콘텐츠 보기 &raquo;</a></p>
            </div>
            <div class="col-lg-4">
                <img src="/resources/img/spb_logo.png" class="rounded-circle" width="140" height="140" alt="AI 진단">
                <h2 class="fw-bold">AI 학습 진단</h2>
                <p>맞춤 진단으로 나에게 꼭 맞는 강의를 추천해드립니다.</p>
                <p><a class="btn btn-secondary" href="#">AI 진단 시작 &raquo;</a></p>
            </div>
        </div>

        <!-- START THE FEATURETTES -->

        <hr class="featurette-divider">

        <div class="row featurette">
            <div class="col-md-7">
                <h2 class="featurette-heading">봄콩은 다릅니다.</h2>
                <h2><span class="text-muted">학생 중심 설계.</span></h2>
                <p class="lead">복잡한 수업은 이제 그만! 봄콩은 쉬운 설명과 직관적인 UI로 학습에만 집중할 수 있도록 설계되었습니다.</p>
            </div>
            <div class="col-md-5">
                <img src="/resources/img/spb_logo.png" class="img-fluid" alt="학습환경">
            </div>
        </div>
        <hr class="featurette-divider">

        <div class="row featurette">
            <div class="col-md-7 order-md-2">
                <h2 class="featurette-heading">모바일, 태블릿 완벽 지원. </h2>
                <h2><span class="text-muted">언제 어디서나.</span></h2>
                <p class="lead">PC는 물론, 스마트폰과 태블릿에서도 최적화된 학습 환경을 제공합니다.</p>
            </div>
            <div class="col-md-5 order-md-1">
                <img src="/resources/img/spb_logo.png" class="img-fluid" alt="모바일 지원">
            </div>
        </div>

        <hr class="featurette-divider">

        <!-- /END THE FEATURETTES -->

    </div><!-- /.container -->
</div>
<script>
    let modal = null;
    let emailModal = null;

    document.addEventListener('DOMContentLoaded', function () {

        // 비밀번호 변경 모달 처리
        <c:if test="${sessionScope.memberDTO.memberState == '3'}">
        modal = new bootstrap.Modal(document.getElementById('pwdChangeModal'), {
            backdrop: 'static',
            keyboard: false
        });
        modal.show();
        </c:if>

        const remindBtn = document.getElementById("btnRemindLater");
        if (remindBtn) {
            remindBtn.addEventListener("click", function () {
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
                            if (modal) modal.hide();
                        } else {
                            alert("알림 설정에 실패했습니다.");
                        }
                    })
                    .catch(error => console.error('Error:', error));
            });
        }

        // 휴면 계정 이메일 인증 모달 처리
        <c:if test="${sessionScope.memberDTO.memberState == '5'}">
        emailModal = new bootstrap.Modal(document.getElementById('emailVerifyModal'), {
            backdrop: 'static',
            keyboard: false
        });
        emailModal.show();
        </c:if>

        let emailAuthTimer;
        let emailAuthTimeLimit = 300;

        function startEmailAuthTimer() {
            clearInterval(emailAuthTimer);
            emailAuthTimeLimit = 300;

            emailAuthTimer = setInterval(function () {
                const minutes = Math.floor(emailAuthTimeLimit / 60);
                const seconds = emailAuthTimeLimit % 60;

                const timeDisplay = "남은 인증 시간: " + minutes + ":" + (seconds < 10 ? '0' + seconds : seconds);
                document.getElementById('emailAuthTimeWarning').textContent = timeDisplay;

                if (emailAuthTimeLimit <= 0) {
                    clearInterval(emailAuthTimer);
                    document.getElementById('emailAuthTimeWarning').textContent = '인증 시간이 만료되었습니다.';
                    document.getElementById('codeInput').disabled = true;
                    document.getElementById('btnCheckCode').disabled = true;
                    document.getElementById('btnSendEmail').disabled = false;
                }

                emailAuthTimeLimit--;
            }, 1000);
        }

        const sendBtn = document.getElementById("btnSendEmail");
        if (sendBtn) {
            sendBtn.addEventListener("click", () => {
                const emailInput = document.getElementById("emailInput");
                const email = emailInput.value.trim();

                if (!email) {
                    alert("이메일을 입력해주세요.");
                    return;
                }

                fetch("/email/verify", {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({memberEmail: email})
                })
                    .then(res => res.json())
                    .then(data => {
                        alert(data.message);

                        if (data.success) {
                            const count = data.emailTryCount || 1;
                            document.getElementById('emailCountWarning').innerHTML =
                                "<strong>인증 횟수 " + count + "/3회</strong>";

                            document.getElementById('btnSendEmail').disabled = true;
                            document.getElementById('codeInput').disabled = false;
                            document.getElementById('btnCheckCode').disabled = false;
                            startEmailAuthTimer();
                        }
                    });
            });
        }

        const checkBtn = document.getElementById("btnCheckCode");
        if (checkBtn) {
            checkBtn.addEventListener("click", () => {
                const code = document.getElementById("codeInput").value.trim();
                const email = document.getElementById("emailInput").value.trim();

                fetch("/email/codeCheck", {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({
                        memberEmailCode: code,
                        memberEmail: email
                    })
                })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            alert("이메일 인증이 완료되었습니다.");
                            fetch("/email/reactivate", {
                                method: "POST",
                                headers: {"Content-Type": "application/json"},
                                body: JSON.stringify({memberId: "${sessionScope.memberDTO.memberId}"})
                            }).then(() => location.reload());
                        } else {
                            alert(data.message);
                        }
                    });
            });
        }

    });
</script>

<c:if test="${not empty message}">
    <script>
        alert("${message}");
    </script>
</c:if>

</body>
</html>
