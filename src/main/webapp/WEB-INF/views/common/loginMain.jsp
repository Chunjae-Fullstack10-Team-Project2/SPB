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
<%@ include file="../common/sidebarHeader.jsp" %>

<div class="content">
    <svg xmlns="http://www.w3.org/2000/svg" class="d-none">
        <symbol id="house-door-fill" viewBox="0 0 16 16">
            <path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5z"/>
        </symbol>
    </svg>
    <div class="container my-5">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb breadcrumb-chevron p-3 bg-body-tertiary rounded-3">
                <li class="breadcrumb-item">
                    <a class="link-body-emphasis text-decoration-none" href="/">
                        ${sessionScope.memberId} 님, 오늘도 즐거운 학습 되세요! 😊
                    </a>
                </li>
            </ol>
        </nav>
    </div>
<%--    <div class="container mt-2 mb-5">--%>
<%--        <h2 class="mb-4">${sessionScope.memberId} 님, 오늘도 즐거운 학습 되세요! 😊</h2>--%>
<%--    </div>--%>
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
                <h2 class="fw-normal">우수 강사진</h2>
                <p>현직 교사, 교육 전문가들이 직접 강의합니다.</p>
                <p><a class="btn btn-secondary" href="#">더 알아보기 &raquo;</a></p>
            </div>
            <div class="col-lg-4">
                <img src="/resources/img/spb_logo.png" class="rounded-circle" width="140" height="140" alt="콘텐츠">
                <h2 class="fw-normal">다양한 콘텐츠</h2>
                <p>기초부터 심화까지! 초·중·고 전과목 학습자료 제공.</p>
                <p><a class="btn btn-secondary" href="#">콘텐츠 보기 &raquo;</a></p>
            </div>
            <div class="col-lg-4">
                <img src="/resources/img/spb_logo.png" class="rounded-circle" width="140" height="140" alt="AI 진단">
                <h2 class="fw-normal">AI 학습 진단</h2>
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

</script>
<c:if test="${not empty message}">
    <script>
        alert("${message}");
    </script>
</c:if>

</body>
</html>
