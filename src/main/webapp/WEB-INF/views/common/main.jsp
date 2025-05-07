<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>메인 페이지</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/bootstrap-5.0.0-alpha.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/LineIcons.2.0.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/animate.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/main.css">

    <%--    <style>--%>
    <%--        .warning-text {--%>
    <%--            color: red;--%>
    <%--            font-size: 0.8rem;--%>
    <%--            margin: 0.2rem 0 0 0.2rem;--%>
    <%--        }--%>
    <%--    </style>--%>
</head>
<body>
<%@include file="header.jsp" %>
<%--<div class="content-nonside">--%>
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
<%--</div>--%>

<!--[if lte IE 9]>
<p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="https://browsehappy.com/">upgrade
    your browser</a> to improve your experience and security.</p>
<![endif]-->

<!-- ========================= preloader start ========================= -->
<div class="preloader">
    <div class="loader">
        <div class="ytp-spinner">
            <div class="ytp-spinner-container">
                <div class="ytp-spinner-rotator">
                    <div class="ytp-spinner-left">
                        <div class="ytp-spinner-circle"></div>
                    </div>
                    <div class="ytp-spinner-right">
                        <div class="ytp-spinner-circle"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- preloader end -->

<!-- ========================= carousel-section end ========================= -->
<section id="home" class="carousel-section-wrapper">
    <div id="carouselExampleCaptions" class="carousel slide carousel-fade" data-ride="carousel">
        <div class="carousel-inner">
            <div class="carousel-section carousel-item active clip-bg pt-225 pb-200 img-bg"
                 style="background-image: url('${pageContext.request.contextPath}/resources/assets/img/carousel/1.jpg');">
                <div class="container">
                    <div class="row">
                        <div class="col-xl-8 col-lg-10 mx-auto">
                            <div class="carousel-content text-center">
                                <div class="section-title">
                                    <h2 class="text-white">당신의 성장을 위한 첫 걸음</h2>
                                    <p class="text-white">봄콩에서 시작하세요. 초등부터 고등까지, 단계별 맞춤 인강으로 실력을 키워드립니다.</p>
                                </div>
                                <a href="javascript:void(0)" class="theme-btn border-btn">Read More</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="carousel-section carousel-item clip-bg pt-225 pb-200 img-bg"
                 style="background-image: url('${pageContext.request.contextPath}/resources/assets/img/carousel/2.jpg');">
                <div class="container">
                    <div class="row">
                        <div class="col-xl-8 col-lg-10 mx-auto">
                            <div class="carousel-content text-center">
                                <div class="section-title">
                                    <h2 class="text-white">오늘의 공부가 내일을 바꿉니다</h2>
                                    <p class="text-white">검증된 강사진, 탄탄한 커리큘럼, 그리고 당신의 열정. 봄콩에서 만나보세요.</p>
                                </div>
                                <a href="javascript:void(0)" class="theme-btn border-btn">Read More</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <a class="carousel-control carousel-control-prev" href="#carouselExampleCaptions" role="button"
           data-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"><i class="lni lni-arrow-left"></i></span>
            <span class="sr-only">Previous</span>
        </a>
        <a class="carousel-control carousel-control-next" href="#carouselExampleCaptions" role="button"
           data-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"><i class="lni lni-arrow-right"></i></span>
            <span class="sr-only">Next</span>
        </a>
    </div>
</section>
<!-- ========================= carousel-section end ========================= -->

<!-- ========================= feature-section start ========================= -->
<section id="features" class="feature-section pt-100">
    <div class="container">
        <div class="row">
            <div class="col-xl-6 col-lg-7 col-md-9 mx-auto">
                <div class="section-title text-center mb-55">
                    <span class="wow fadeInDown" data-wow-delay=".2s">Features</span>
                    <h2 class="wow fadeInUp" data-wow-delay=".4s">왜 봄콩일까요?</h2>
                    <p class="wow fadeInUp" data-wow-delay=".6s">학생의 성장을 가장 먼저 생각하는, 믿을 수 있는 온라인 학습 플랫폼입니다.</p>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-4 col-md-6">
                <div class="feature-box box-style">
                    <div class="feature-icon box-icon-style">
                        <i class="lni lni-layers"></i>
                    </div>
                    <div class="box-content-style feature-content">
                        <h4>수준별 맞춤 강의</h4>
                        <p>학년별·레벨별 강좌로 누구나 자기 페이스에 맞춰 학습할 수 있어요.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="feature-box box-style">
                    <div class="feature-icon box-icon-style">
                        <i class="lni lni-brush-alt"></i>
                    </div>
                    <div class="box-content-style feature-content">
                        <h4>전문 강사진</h4>
                        <p>경험 많은 강사들의 명쾌한 설명으로 개념을 쉽게 이해할 수 있습니다.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="feature-box box-style">
                    <div class="feature-icon box-icon-style">
                        <i class="lni lni-pointer-up"></i>
                    </div>
                    <div class="box-content-style feature-content">
                        <h4>성장 추적 시스템</h4>
                        <p>나의 학습 진도와 이해도를 데이터로 확인하며 실력을 점검해요.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- ========================= feature-section end ========================= -->

<!--========================= about-section start========================= -->
<section id="about" class="pt-100">
    <div class="about-section">
        <div class="container">
            <div class="row">
                <div class="col-xl-6 col-lg-6">
                    <div class="about-img-wrapper">
                        <div class="about-img position-relative d-inline-block wow fadeInLeft" data-wow-delay=".3s">
                            <img src="${pageContext.request.contextPath}/resources/assets/img/about/about-img.png"
                                 alt="">

                            <div class="about-experience">
                                <h2 class="mb-40 wow fadeInRight" data-wow-delay=".4s">학생의 가능성을 키우는 공간, 봄콩</h2>
                                <p class="mb-45 wow fadeInUp" data-wow-delay=".6s">우리는 단순한 인강 플랫폼이 아닙니다. 봄콩은 학생 한 명 한 명이
                                    스스로 성장할 수 있도록 돕는 디지털 학습 환경을 제공합니다.</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-6 col-lg-6">
                    <div class="about-content-wrapper">
                        <div class="section-title">
                            <span class="wow fadeInUp" data-wow-delay=".2s">봄콩 소개</span>
                            <h2 class="mb-40 wow fadeInRight" data-wow-delay=".4s">학생의 가능성을 키우는 온라인 클래스</h2>
                        </div>
                        <div class="about-content">
                            <p class="mb-45 wow fadeInUp" data-wow-delay=".6s">
                                봄콩은 봄처럼 생동감 있게 자라는 학생들을 위한 교육 플랫폼입니다.
                                검증된 강사진, 학년별 커리큘럼, 그리고 성장 데이터 기반 학습 시스템으로
                                스스로 학습하고 성장할 수 있는 환경을 제공합니다.
                            </p>
                            <div class="counter-up wow fadeInUp" data-wow-delay=".5s">
                                <div class="counter">
                                    <span id="secondo" class="countup count color-1" cup-end="10" cup-append="k">10</span>
                                    <h4>누적 수강생</h4>
                                    <p>많은 학생들이 봄콩을 통해<br class="d-none d-md-block d-lg-none d-xl-block">학습 역량을 키웠습니다</p>
                                </div>
                                <div class="counter">
                                    <span id="secondo" class="countup count color-2" cup-end="95" cup-append="%">95</span>
                                    <h4>만족도</h4>
                                    <p>실제 수강생 리뷰 기준 <br class="d-none d-md-block d-lg-none d-xl-block">만족도 95% 이상</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!--========================= about-section end========================= -->

<!-- ========================= service-section start ========================= -->
<section id="services" class="service-section pt-130">
    <div class="container">
        <div class="row">
            <div class="col-xl-6 col-lg-7 col-md-9 mx-auto">
                <div class="section-title text-center mb-55">
                    <span class="wow fadeInDown" data-wow-delay=".2s">봄콩 서비스</span>
                    <h2 class="wow fadeInUp" data-wow-delay=".4s">당신의 성장을 돕는 학습 경험</h2>
                    <p class="wow fadeInUp" data-wow-delay=".6s">봄콩은 단순한 강의 제공을 넘어, 학생 한 명 한 명의 학습 여정을 함께합니다.</p>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-4 col-md-6">
                <div class="service-box box-style">
                    <div class="service-icon box-icon-style">
                        <i class="lni lni-video"></i>
                    </div>
                    <div class="box-content-style service-content">
                        <h4>전문 강사진의 영상 강의</h4>
                        <p>검증된 선생님들의 체계적인 커리큘럼으로<br>기초부터 심화까지 탄탄하게 배울 수 있어요.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="service-box box-style">
                    <div class="service-icon box-icon-style">
                        <i class="lni lni-bulb"></i>
                    </div>
                    <div class="box-content-style service-content">
                        <h4>자기주도 학습 지원</h4>
                        <p>개인 학습 스케줄 설정과 진도 체크로<br>스스로 학습하는 습관을 기를 수 있습니다.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="service-box box-style">
                    <div class="service-icon box-icon-style">
                        <i class="lni lni-comments-alt"></i>
                    </div>
                    <div class="box-content-style service-content">
                        <h4>질문 & 커뮤니티</h4>
                        <p>언제든 질문하고 토론할 수 있는 커뮤니티를 통해<br>같이 공부하고 서로 도울 수 있어요.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="service-box box-style">
                    <div class="service-icon box-icon-style">
                        <i class="lni lni-book"></i>
                    </div>
                    <div class="box-content-style service-content">
                        <h4>학습 자료 제공</h4>
                        <p>강의에 맞는 요약 자료, 문제지, 복습 노트 등을<br>함께 제공해 학습 효과를 높입니다.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="service-box box-style">
                    <div class="service-icon box-icon-style">
                        <i class="lni lni-bar-chart"></i>
                    </div>
                    <div class="box-content-style service-content">
                        <h4>학습 분석 리포트</h4>
                        <p>진도율, 반복 학습, 오답률 등을 분석해<br>나만의 학습 리포트를 받아볼 수 있어요.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="service-box box-style">
                    <div class="service-icon box-icon-style">
                        <i class="lni lni-support"></i>
                    </div>
                    <div class="box-content-style service-content">
                        <h4>1:1 학습 지원</h4>
                        <p>관리 선생님과의 1:1 피드백 시스템으로<br>궁금한 점과 고민을 함께 해결할 수 있습니다.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- ========================= service-section end ========================= -->

<!-- ========================= process-section start ========================= -->
<section id="process" class="process-section pt-100 pb-100">
    <div class="container">
        <div class="row">
            <div class="col-xl-6 col-lg-7 col-md-9 mx-auto">
                <div class="section-title text-center mb-55">
                    <span class="wow fadeInDown" data-wow-delay=".2s">이용 절차</span>
                    <h2 class="wow fadeInUp" data-wow-delay=".4s">봄콩에서 공부하는 과정</h2>
                    <p class="wow fadeInUp" data-wow-delay=".6s">간단한 절차로 원하는 강좌를 수강해보세요!</p>
                </div>
            </div>
        </div>
        <div class="row align-items-center time-line">

            <div class="col-12">
                <div class="single-timeline">
                    <div class="row align-items-center">
                        <div class="col-lg-5 order-last order-lg-first">
                            <div class="timeline-content left-content text-lg-right">
                                <div class="box-icon-style">
                                    <i class="lni lni-users"></i>
                                </div>
                                <h4 class="mb-10">1. 강사 탐색</h4>
                                <p>과목별로 다양한 강사님의 소개와<br>강의 스타일을 미리 확인해보세요.</p>
                            </div>
                        </div>
                        <div class="col-lg-2"></div>
                        <div class="col-lg-5">
                            <div class="timeline-img">
                                <img src="${pageContext.request.contextPath}/resources/assets/img/timeline/timeline-1.png" alt="강사 탐색">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-12">
                <div class="single-timeline">
                    <div class="row align-items-center">
                        <div class="col-lg-5">
                            <div class="timeline-img">
                                <img src="${pageContext.request.contextPath}/resources/assets/img/timeline/timeline-2.png" alt="회원가입">
                            </div>
                        </div>
                        <div class="col-lg-2"></div>
                        <div class="col-lg-5">
                            <div class="timeline-content right-content text-left">
                                <div class="box-icon-style">
                                    <i class="lni lni-key"></i>
                                </div>
                                <h4 class="mb-10">2. 회원가입</h4>
                                <p>이메일 인증만으로 간단하게 가입하고<br>내 학습 공간을 만들 수 있어요.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-12">
                <div class="single-timeline">
                    <div class="row align-items-center">
                        <div class="col-lg-5 order-last order-lg-first">
                            <div class="timeline-content left-content text-lg-right">
                                <div class="box-icon-style">
                                    <i class="lni lni-shopping-basket"></i>
                                </div>
                                <h4 class="mb-10">3. 강좌 담기</h4>
                                <p>듣고 싶은 강의를 장바구니에 담고<br>필요한 자료도 미리 확인해보세요.</p>
                            </div>
                        </div>
                        <div class="col-lg-2"></div>
                        <div class="col-lg-5">
                            <div class="timeline-img">
                                <img src="${pageContext.request.contextPath}/resources/assets/img/timeline/timeline-3.png" alt="강좌 담기">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-12">
                <div class="single-timeline">
                    <div class="row align-items-center">
                        <div class="col-lg-5">
                            <div class="timeline-img">
                                <img src="${pageContext.request.contextPath}/resources/assets/img/timeline/timeline-4.png" alt="결제 및 수강">
                            </div>
                        </div>
                        <div class="col-lg-2"></div>
                        <div class="col-lg-5">
                            <div class="timeline-content right-content text-left">
                                <div class="box-icon-style">
                                    <i class="lni lni-credit-cards"></i>
                                </div>
                                <h4 class="mb-10">4. 결제 및 수강</h4>
                                <p>결제를 완료하면 바로 수강 시작!<br>내 학습 진도는 자동으로 저장됩니다.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>
<!-- ========================= process-section end ========================= -->

<!-- ========================= subscribe-section start ========================= -->
<section class="subscribe-section pt-100 pb-100 img-bg"
         style="background-image: url('${pageContext.request.contextPath}/resources/assets/img/bg/common-bg.svg')">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-xl-6 col-lg-6">
                <div class="section-title mb-30">
                    <span class="text-white wow fadeInDown" data-wow-delay=".2s">지금 바로 체험해보세요!</span>
                    <h2 class="text-white mb-40 wow fadeInUp" data-wow-delay=".4s">회원가입하고 오늘부터 무료 강의를 체험해보세요. 봄콩과 함께라면 공부가
                        즐거워집니다.</h2>
                </div>
            </div>
            <div class="col-xl-6 col-lg-6">
                <form action="#" class="subscribe-form wow fadeInRight" data-wow-delay=".4s">
                    <input type="text" name="subs-email" id="subs-email" placeholder="Your Email">
                    <button type="submit"><i class="lni lni-telegram-original"></i></button>
                </form>
            </div>
        </div>
    </div>
</section>
<!-- ========================= subscribe-section end ========================= -->

<!-- ========================= footer start ========================= -->
<footer class="footer pt-100">
    <div class="container">
        <div class="row">
            <div class="col-xl-3 col-lg-4 col-md-6">
                <div class="footer-widget mb-60 wow fadeInLeft" data-wow-delay=".2s">
                    <a href="index.html" class="logo mb-30"><img
                            src="${pageContext.request.contextPath}/resources/assets/img/logo/logo.svg" alt="logo"></a>
                    <p class="mb-30 footer-desc">We Crafted an awesome desig library that is robust and intuitive to
                        use. No matter you're building a business presentation websit.</p>
                </div>
            </div>
            <div class="col-xl-2 offset-xl-1 col-lg-2 col-md-6">
                <div class="footer-widget mb-60 wow fadeInUp" data-wow-delay=".4s">
                    <h4>Quick Link</h4>
                    <ul class="footer-links">
                        <li>
                            <a href="javascript:void(0)">Home</a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">About Us</a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">Service</a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">Contact</a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="col-xl-3 col-lg-3 col-md-6">
                <div class="footer-widget mb-60 wow fadeInUp" data-wow-delay=".6s">
                    <h4>Service</h4>
                    <ul class="footer-links">
                        <li>
                            <a href="javascript:void(0)">Marketing</a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">Branding</a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">Web Design</a>
                        </li>
                        <li>
                            <a href="javascript:void(0)">Graphics Design</a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="col-xl-3 col-lg-3 col-md-6">
                <div class="footer-widget mb-60 wow fadeInRight" data-wow-delay=".8s">
                    <h4>Contact</h4>
                    <ul class="footer-contact">
                        <li>
                            <p>+00983467367234</p>
                        </li>
                        <li>
                            <p>yourmail@gmail.com</p>
                        </li>
                        <li>
                            <p>Jackson Heights, NY</br>
                                USA</p>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="copyright-area">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <div class="footer-social-links">
                        <ul class="d-flex">
                            <li><a href="javascript:void(0)"><i class="lni lni-facebook-original"></i></a></li>
                            <li><a href="javascript:void(0)"><i class="lni lni-twitter-original"></i></a></li>
                            <li><a href="javascript:void(0)"><i class="lni lni-linkedin-original"></i></a></li>
                            <li><a href="javascript:void(0)"><i class="lni lni-instagram-original"></i></a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-6">
                    <p class="wow fadeInUp" data-wow-delay=".3s">Template by <a
                            href="https://uideck.com" rel="nofollow">UIdeck</a></p>
                </div>
            </div>
        </div>
    </div>
</footer>
<!-- ========================= footer end ========================= -->


<!-- ========================= scroll-top ========================= -->
<a href="#" class="scroll-top">
    <i class="lni lni-arrow-up"></i>
</a>

<!-- ========================= JS here ========================= -->
<script src="${pageContext.request.contextPath}/resources/assets/js/bootstrap.bundle-5.0.0.alpha-min.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/js/count-up.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/js/wow.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/js/imagesloaded.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/js/main.js"></script>


<script>
    <c:if test="${sessionScope.memberDTO.memberState == '3'}">
    const modal = new bootstrap.Modal(document.getElementById('pwdChangeModal'), {
        backdrop: 'static',
        keyboard: false
    });
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

    <c:if test="${sessionScope.memberDTO.memberState == '5'}">
    const emailModal = new bootstrap.Modal(document.getElementById('emailVerifyModal'), {
        backdrop: 'static',
        keyboard: false
    });
    window.onload = () => emailModal.show();
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

                // 다시 메일 보낼 수 있도록 버튼 활성화
                document.getElementById('btnSendEmail').disabled = false;
            }

            emailAuthTimeLimit--;
        }, 1000);
    }

    document.getElementById("btnSendEmail").addEventListener("click", () => {
        const emailInput = document.getElementById("emailInput");
        emailInput.value = emailInput.value.trim();

        if (!emailInput.value) {
            alert("이메일을 입력해주세요.");
            return;
        }

        fetch("/email/verify", {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify({memberEmail: emailInput.value})
        })
            .then(res => res.json())
            .then(data => {
                alert(data.message);

                if (data.success) {
                    const count = data.emailTryCount || 1;
                    document.getElementById('emailCountWarning').innerHTML = "<strong>인증 횟수 " + count + "/3회</strong>";

                    document.getElementById('btnSendEmail').disabled = true;
                    document.getElementById('codeInput').disabled = false;
                    document.getElementById('btnCheckCode').disabled = false;
                    startEmailAuthTimer();
                }
            });
    });

    document.getElementById("btnCheckCode").addEventListener("click", () => {
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
</script>
</body>
</html>