<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>메인 페이지</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/mainAssets/css/bootstrap-5.0.0-alpha.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/mainAssets/css/LineIcons.2.0.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/mainAssets/css/animate.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/mainAssets/css/main.css">
    <!-- ========================= JS here ========================= -->
    <script src="${pageContext.request.contextPath}/resources/mainAssets/js/bootstrap.bundle-5.0.0.alpha-min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/mainAssets/js/count-up.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/mainAssets/js/wow.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/mainAssets/js/imagesloaded.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/mainAssets/js/main.js"></script>

</head>
<body>
<%@include file="header.jsp" %>

<!--[if lte IE 9]>
<p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a
        href="https://browsehappy.com/">upgrade
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
                 style="background-image: url('${pageContext.request.contextPath}/resources/img/spb_illustration1.png');">
                <div class="container">
                    <div class="row">
                        <div class="col-xl-8 col-lg-10 mx-auto">
                            <div class="carousel-content text-center mt-100">
                                <div class="section-title">
                                    <h2 class="text-white">당신의 성장을 위한 첫 걸음</h2>
                                    <p class="text-white">봄콩에서 시작하세요. 초등부터 고등까지, 단계별 맞춤 인강으로 실력을 키워드립니다.</p>
                                </div>
                                <a href="/login" class="theme-btn border-btn">로그인하기</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="carousel-section carousel-item clip-bg pt-225 pb-200 img-bg"
                 style="background-image: url('${pageContext.request.contextPath}/resources/img/spb_illustration2.png');">
                <div class="container">
                    <div class="row">
                        <div class="col-xl-8 col-lg-10 mx-auto">
                            <div class="carousel-content text-center mt-100">
                                <div class="section-title">
                                    <h2 class="text-white">오늘의 공부가 내일을 바꿉니다</h2>
                                    <p class="text-white">검증된 강사진, 탄탄한 커리큘럼, 그리고 당신의 열정. 봄콩에서 만나보세요.</p>
                                </div>
                                <a href="/login" class="theme-btn border-btn">로그인하기</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <a class="carousel-control carousel-control-prev" href="#carouselExampleCaptions" role="button"
           data-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
        </a>
        <a class="carousel-control carousel-control-next" href="#carouselExampleCaptions" role="button"
           data-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
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
                        <div class="ml-5 about-img position-relative d-inline-block wow fadeInLeft" data-wow-delay=".3s">
                            <img src="${pageContext.request.contextPath}/resources/img/spb_illustration3_transparent.png"
                                 alt="">

<%--                            <div class="about-experience">--%>
<%--                                <h2 class="mb-40 wow fadeInRight" data-wow-delay=".4s"--%>
<%--                                    style="color: #5e3e0f; font-weight: 700;">학생의 가능성을 키우는 공간</h2>--%>
<%--                                <p class="mb-45 wow fadeInUp" data-wow-delay=".6s">우리는 단순한 인강 플랫폼이 아닙니다. 봄콩은 학생 한 명--%>
<%--                                    한 명이--%>
<%--                                    스스로 성장할 수 있도록 돕는 디지털 학습 환경을 제공합니다.</p>--%>
<%--                            </div>--%>
                        </div>
                    </div>
                </div>
                <div class="col-xl-6 col-lg-6">
                    <div class="about-content-wrapper">
                        <div class="section-title">
                            <span class="wow fadeInUp" data-wow-delay=".2s" style="color: #f9a683;">봄콩 소개</span>
                            <h2 class="mb-40 wow fadeInRight" data-wow-delay=".4s">학생의 가능성을 키우는 온라인 클래스</h2>
                        </div>
                        <div class="about-content">
                            <p class="mb-45 wow fadeInUp" data-wow-delay=".6s">
                                봄콩은 봄처럼 생동감 있게 자라는 학생들을 위한 교육 플랫폼입니다.
                                검증된 강사진, 학년별 커리큘럼, 그리고 성장 데이터 기반 학습 시스템으로
                                스스로 학습하고 성장할 수 있는 환경을 제공합니다.
                            </p>
                            <div class="d-flex justify-content-between text-center px-4 py-5" style="background-color: #f8f9fc;">
                                <div class="flex-fill">
                                    <div class="fw-bold display-5 text-warning countup" cup-end="10" cup-append="k">0</div>
                                    <h4 class="mt-2 fw-bold">누적 수강생</h4>
                                    <p class="text-secondary">지금까지 1만 명 이상의 학생이<br>봄콩과 함께 성장했습니다.</p>
                                </div>
                                <div class="flex-fill">
                                    <div class="fw-bold display-5 text-warning countup" cup-end="95" cup-append="%">0</div>
                                    <h4 class="mt-2 fw-bold">수강 만족도</h4>
                                    <p class="text-secondary">실제 수강생 리뷰 기반<br>95% 이상 만족을 기록했습니다.</p>
                                </div>
                                <div class="flex-fill">
                                    <div class="fw-bold display-5 text-warning countup" cup-end="1" cup-append="위">0</div>
                                    <h4 class="mt-2 fw-bold">학습 만족도 1위</h4>
                                    <p class="text-secondary">온라인 학습 플랫폼 중<br>최고의 만족도를 자랑합니다.</p>
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
                                <img src="${pageContext.request.contextPath}/resources/mainAssets/img/timeline/timeline-1.png"
                                     alt="강사 탐색">
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
                                <img src="${pageContext.request.contextPath}/resources/mainAssets/img/timeline/timeline-2.png"
                                     alt="회원가입">
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
                                <img src="${pageContext.request.contextPath}/resources/mainAssets/img/timeline/timeline-3.png"
                                     alt="강좌 담기">
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
                                <img src="${pageContext.request.contextPath}/resources/mainAssets/img/timeline/timeline-4.png"
                                     alt="결제 및 수강">
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
<section class="bg-primary text-white py-5" style="background-image: url('${pageContext.request.contextPath}/resources/mainAssets/img/bg/common-bg.svg'); background-size: cover; background-repeat: no-repeat;">
    <div class="p-5 mb-5 bg-primary bg-opacity-75 rounded-3 text-white"
         style="background-image: url('${pageContext.request.contextPath}/resources/mainAssets/img/bg/common-bg.svg'); background-size: cover; background-repeat: no-repeat; background-position: center;">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">지금 바로 체험해보세요!</h1>
            <p class="col-md-8 fs-4 text-white lh-base">
                회원가입하고 오늘부터 무료 강의를 체험해보세요.<br>
                <strong>봄콩</strong>과 함께라면 공부가 즐거워집니다.
            </p>
            <a href="${pageContext.request.contextPath}/join" class="btn btn-light btn-lg fw-bold">
                회원가입 하러 가기
            </a>
        </div>
<%--        <div class="ml-5 about-img position-relative d-inline-block wow fadeInRight" data-wow-delay=".3s">--%>
<%--            <img src="${pageContext.request.contextPath}/resources/img/spb_illustration3_transparent.png"--%>
<%--                 alt="">--%>
<%--        </div>--%>
    </div>

</section>

<!-- ========================= subscribe-section end ========================= -->

<!-- ========================= scroll-top ========================= -->
<a href="#" class="scroll-top">
    <i class="lni lni-chevron-up"></i>
</a>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const counter = new counterUp({
            duration: 2000,
            append: '',
            prepend: '',
            selector: '.countup',
            intvalues: true,
            interval: 50
        });
        counter.start();
    });
</script>

</body>
</html>