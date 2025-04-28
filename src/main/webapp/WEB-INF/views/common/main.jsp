<%--
  Created by IntelliJ IDEA.
  User: a82108
  Date: 2025. 4. 23.
  Time: AM 11:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /*
         * Globals
         */


        /* Custom default button */
        .btn-light,
        .btn-light:hover,
        .btn-light:focus {
            color: #333;
            text-shadow: none; /* Prevent inheritance from `body` */
        }


        /*
         * Base structure
         */

        body {
            text-shadow: 0 .05rem .1rem rgba(0, 0, 0, .5);
            box-shadow: inset 0 0 5rem rgba(0, 0, 0, .5);
        }

        .cover-container {
            max-width: 42em;
        }


        /*
         * Header
         */

        .nav-masthead .nav-link {
            color: rgba(255, 255, 255, .5);
            border-bottom: .25rem solid transparent;
        }

        .nav-masthead .nav-link:hover,
        .nav-masthead .nav-link:focus {
            border-bottom-color: rgba(255, 255, 255, .25);
        }

        .nav-masthead .nav-link + .nav-link {
            margin-left: 1rem;
        }

        .nav-masthead .active {
            color: #fff;
            border-bottom-color: #fff;
        }

    </style>
</head>
<body class="d-flex h-100 text-center text-bg-dark">

<div class="cover-container d-flex w-100 h-100 p-3 mx-auto flex-column">
    <header class="mb-auto">
        <div>
            <h3 class="float-md-start mb-0">Home</h3>
            <nav class="nav nav-masthead justify-content-center float-md-end">
                <a class="nav-link fw-bold py-1 px-0" aria-current="page" href="/login">Login</a>
                <%--                <a class="nav-link fw-bold py-1 px-0" href="#">Features</a>--%>
                <%--                <a class="nav-link fw-bold py-1 px-0" href="#">Contact</a>--%>
            </nav>
        </div>
    </header>

    <main class="px-3">
        <h1>게시판입니다.</h1>
        <p class="lead">Cover is a one-page template for building simple and beautiful home pages. Download, edit the
            text, and add your own fullscreen background photo to make it your own.</p>
        <p class="lead">
            <a href="/regist" class="btn btn-lg btn-light fw-bold border-white bg-white">회원가입</a>
        </p>
    </main>

    <footer class="mt-auto text-white-50">
<%--        <p>Cover template for <a href="https://getbootstrap.com/" class="text-white">Bootstrap</a>, by <a--%>
<%--                href="https://x.com/mdo" class="text-white">@mdo</a>.</p>--%>
    </footer>
</div>

<!-- Bootstrap Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
