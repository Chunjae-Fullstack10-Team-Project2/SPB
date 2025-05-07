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
                                    <h2 class="text-white">Bootstrap 5 One Page Template</h2>
                                    <p class="text-white">We Crafted an awesome design library that is
                                        robust and intuitive to use. No matter you're building a business
                                        presentation
                                        websit or a complex web application our design blocks can easily be
                                        adapted for your needs.</p>
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
                                    <h2 class="text-white">Get Started with Mighty Bootstrap 5</h2>
                                    <p class="text-white">Create Stunning Websites in Easier
                                        and Effecient Way! No matter you're building a business
                                        presentation websit or a complex web application our design blocks can easily be
                                        adapted for your needs.</p>
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
                    <h2 class="wow fadeInUp" data-wow-delay=".4s">Why Choose?</h2>
                    <p class="wow fadeInUp" data-wow-delay=".6s">At vero eos et accusamus et iusto odio dignissimos
                        ducimus quiblanditiis praesentium</p>
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
                        <h4>Bootstrap 5</h4>
                        <p>Lorem ipsum dolor sit amet, adipscing elitr, sed diam nonumy eirmod tempor ividunt
                            labor dolore magna.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="feature-box box-style">
                    <div class="feature-icon box-icon-style">
                        <i class="lni lni-brush-alt"></i>
                    </div>
                    <div class="box-content-style feature-content">
                        <h4>Awesome Design</h4>
                        <p>Lorem ipsum dolor sit amet, adipscing elitr, sed diam nonumy eirmod tempor ividunt
                            labor dolore magna.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="feature-box box-style">
                    <div class="feature-icon box-icon-style">
                        <i class="lni lni-pointer-up"></i>
                    </div>
                    <div class="box-content-style feature-content">
                        <h4>One-page Template</h4>
                        <p>Lorem ipsum dolor sit amet, adipscing elitr, sed diam nonumy eirmod tempor ividunt
                            labor dolore magna.</p>
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
                            <img src="${pageContext.request.contextPath}/resources/assets/img/about/about-img.png" alt="">

                            <div class="about-experience">
                                <h3>5 Year Of Working Experience</h3>
                                <p>We Crafted an aweso design library that is robust and intuitive to use.</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-6 col-lg-6">
                    <div class="about-content-wrapper">
                        <div class="section-title">
                            <span class="wow fadeInUp" data-wow-delay=".2s">About Us</span>
                            <h2 class="mb-40 wow fadeInRight" data-wow-delay=".4s">Built-With Boostrap 5, a New
                                Experiance</h2>
                        </div>
                        <div class="about-content">
                            <p class="mb-45 wow fadeInUp" data-wow-delay=".6s">We Crafted an awesome design library
                                that is robust and intuitive to use. No matter you're building a business
                                presentation websit or a complex web application our design</p>
                            <div class="counter-up wow fadeInUp" data-wow-delay=".5s">
                                <div class="counter">
                                    <span id="secondo" class="countup count color-1" cup-end="30"
                                          cup-append="k">10</span>
                                    <h4>Happy Client</h4>
                                    <p>We Crafted an awesome design <br class="d-none d-md-block d-lg-none d-xl-block">
                                        library that is robust and</p>
                                </div>
<%--                                <div class="counter">--%>
<%--                                    <span id="secondo" class="countup count color-2" cup-end="42"--%>
<%--                                          cup-append="k">5</span>--%>
<%--                                    <h4>Project Done</h4>--%>
<%--                                    <p>We Crafted an awesome design <br class="d-none d-md-block d-lg-none d-xl-block">--%>
<%--                                        library that is robust and</p>--%>
<%--                                </div>--%>
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
                    <span class="wow fadeInDown" data-wow-delay=".2s">Services</span>
                    <h2 class="wow fadeInUp" data-wow-delay=".4s">Our Best Services</h2>
                    <p class="wow fadeInUp" data-wow-delay=".6s">At vero eos et accusamus et iusto odio
                        dignissimos ducimus quiblanditiis praesentium</p>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-4 col-md-6">
                <div class="service-box box-style">
                    <div class="service-icon box-icon-style">
                        <i class="lni lni-leaf"></i>
                    </div>
                    <div class="box-content-style service-content">
                        <h4>Clean & Refreshing</h4>
                        <p>Lorem ipsum dolor sit amet, adipscing elitr, sed diam nonumy eirmod tempor ividunt
                            labor dolore magna.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="service-box box-style">
                    <div class="service-icon box-icon-style">
                        <i class="lni lni-bootstrap"></i>
                    </div>
                    <div class="box-content-style service-content">
                        <h4>Solid Bootstrap 5</h4>
                        <p>Lorem ipsum dolor sit amet, adipscing elitr, sed diam nonumy eirmod tempor ividunt
                            labor dolore magna.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="service-box box-style">
                    <div class="service-icon box-icon-style">
                        <i class="lni lni-briefcase"></i>
                    </div>
                    <div class="box-content-style service-content">
                        <h4>Crafted for Business</h4>
                        <p>Lorem ipsum dolor sit amet, adipscing elitr, sed diam nonumy eirmod tempor ividunt
                            labor dolore magna.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="service-box box-style">
                    <div class="service-icon box-icon-style">
                        <i class="lni lni-bolt"></i>
                    </div>
                    <div class="box-content-style service-content">
                        <h4>Speed Optimized</h4>
                        <p>Lorem ipsum dolor sit amet, adipscing elitr, sed diam nonumy eirmod tempor ividunt
                            labor dolore magna.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="service-box box-style">
                    <div class="service-icon box-icon-style">
                        <i class="lni lni-infinite"></i>
                    </div>
                    <div class="box-content-style service-content">
                        <h4>Fully Customizable</h4>
                        <p>Lorem ipsum dolor sit amet, adipscing elitr, sed diam nonumy eirmod tempor ividunt
                            labor dolore magna.</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6">
                <div class="service-box box-style">
                    <div class="service-icon box-icon-style">
                        <i class="lni lni-reload"></i>
                    </div>
                    <div class="box-content-style service-content">
                        <h4>Regular Updates</h4>
                        <p>Lorem ipsum dolor sit amet, adipscing elitr, sed diam nonumy eirmod tempor ividunt
                            labor dolore magna.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- ========================= service-section end ========================= -->

<!-- ========================= portfolio-section start ========================= -->
<section id="portfolio" class="portfolio-section pt-130">
    <section id="team" class="contact-section cta-bg img-bg pt-110 pb-100"
             style="background-image: url('${pageContext.request.contextPath}/resources/assets/img/bg/cta-bg.jpg');">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-xl-5 col-lg-7">
                    <div class="section-title mb-60">
                        <span class="text-white wow fadeInDown" data-wow-delay=".2s"
                              style="visibility: visible; animation-delay: 0.2s; animation-name: fadeInDown;">Hey</span>
                        <h2 class="text-white wow fadeInUp" data-wow-delay=".4s"
                            style="visibility: visible; animation-delay: 0.4s; animation-name: fadeInUp;">You are using
                            free lite version of Fancy</h2>
                        <p class="text-white wow fadeInUp" data-wow-delay=".6s"
                           style="visibility: visible; animation-delay: 0.6s; animation-name: fadeInUp;">Please,
                            purchase full version of template to get all elements, section and permission to remove
                            credits.</p>
                    </div>
                </div>
                <div class="col-xl-7 col-lg-5">
                    <div class="contact-btn text-left text-lg-right">
                        <a href="https://rebrand.ly/fancy-ud" rel="nofollow" class="theme-btn">Purchase Now</a>
                    </div>
                </div>
            </div>
        </div>
    </section>
</section>
<!-- ========================= portfolio-section end ========================= -->

<!-- ========================= process-section start ========================= -->
<section id="process" class="process-section pt-100 pb-100">
    <div class="container">
        <div class="row">
            <div class="col-xl-6 col-lg-7 col-md-9 mx-auto">
                <div class="section-title text-center mb-55">
                    <span class="wow fadeInDown" data-wow-delay=".2s">Process</span>
                    <h2 class="wow fadeInUp" data-wow-delay=".4s">Working Process</h2>
                    <p class="wow fadeInUp" data-wow-delay=".6s">At vero eos et accusamus et iusto odio
                        dignissimos ducimus quiblanditiis praesentium</p>
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
                                    <i class="lni lni-search-alt"></i>
                                </div>
                                <h4 class="mb-10">Research</h4>
                                <p>At vero eos et accusamus et iusto odio dignissimos quiblanditiis praesentium
                                    At vero eos et accusamus et iusto odio dignissimos ducimusm.</p>
                            </div>
                        </div>
                        <div class="col-lg-2"></div>
                        <div class="col-lg-5">
                            <div class="timeline-img">
                                <img src="${pageContext.request.contextPath}/resources/assets/img/timeline/timeline-1.png" alt="">
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
                                <img src="${pageContext.request.contextPath}/resources/assets/img/timeline/timeline-2.png" alt="">
                            </div>
                        </div>
                        <div class="col-lg-2"></div>
                        <div class="col-lg-5">
                            <div class="timeline-content right-content text-left">
                                <div class="box-icon-style">
                                    <i class="lni lni-layers"></i>
                                </div>
                                <h4 class="mb-10">Design</h4>
                                <p>At vero eos et accusamus et iusto odio dignissimos quiblanditiis praesentium
                                    At vero eos et accusamus et iusto odio dignissimos ducimusm.</p>
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
                                    <i class="lni lni-code-alt"></i>
                                </div>
                                <h4 class="mb-10">Code</h4>
                                <p>At vero eos et accusamus et iusto odio dignissimos quiblanditiis praesentium
                                    At vero eos et accusamus et iusto odio dignissimos ducimusm.</p>
                            </div>
                        </div>
                        <div class="col-lg-2"></div>
                        <div class="col-lg-5">
                            <div class="timeline-img">
                                <img src="${pageContext.request.contextPath}/resources/assets/img/timeline/timeline-3.png" alt="">
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
                                <img src="${pageContext.request.contextPath}/resources/assets/img/timeline/timeline-4.png" alt="">
                            </div>
                        </div>
                        <div class="col-lg-2"></div>
                        <div class="col-lg-5">
                            <div class="timeline-content right-content text-left">
                                <div class="box-icon-style">
                                    <i class="lni lni-rocket"></i>
                                </div>
                                <h4 class="mb-10">Launch</h4>
                                <p>At vero eos et accusamus et iusto odio dignissimos quiblanditiis praesentium
                                    At vero eos et accusamus et iusto odio dignissimos ducimusm.</p>
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
<section class="subscribe-section pt-70 pb-70 img-bg" style="background-image: url('${pageContext.request.contextPath}/resources/assets/img/bg/common-bg.svg')">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-xl-6 col-lg-6">
                <div class="section-title mb-30">
                    <span class="text-white wow fadeInDown" data-wow-delay=".2s">Subscribe</span>
                    <h2 class="text-white mb-40 wow fadeInUp" data-wow-delay=".4s">Subscribe Our Newsletter</h2>
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
                    <a href="index.html" class="logo mb-30"><img src="${pageContext.request.contextPath}/resources/assets/img/logo/logo.svg" alt="logo"></a>
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