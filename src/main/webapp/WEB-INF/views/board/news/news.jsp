<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>뉴스 게시판</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .news-table {
            width: 100%;
            table-layout: fixed;
            word-break: break-word;
        }

        .news-title, .news-desc {
            white-space: normal;
        }

        .news-title {
            font-size: 1rem;
            font-weight: bold;
        }

        .news-desc {
            margin-top: 0.5rem;
        }

    </style>
</head>
<body>
<%@ include file="../../common/header.jsp" %>

<div class="content-nonside">
    <div class="container my-5">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb breadcrumb-chevron p-3 bg-body-tertiary rounded-3">
                <li class="breadcrumb-item">
                    <a class="link-body-emphasis" href="/">
                        <svg class="bi" width="16" height="16" aria-hidden="true">
                            <use xlink:href="#house-door-fill"></use>
                        </svg>
                        <span class="visually-hidden">Home</span>
                    </a>
                </li>
                <li class="breadcrumb-item">
                    <a class="link-body-emphasis fw-semibold text-decoration-none" href="/">게시판</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    뉴스
                </li>
            </ol>
        </nav>
    </div>

    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">뉴스 게시판</h3>
        </div>

        <%
            List<Map<String, String>> searchTypeOptions = new ArrayList<>();
            searchTypeOptions.add(Map.of("value", "title", "label", "제목"));
            searchTypeOptions.add(Map.of("value", "description", "label", "설명"));
            request.setAttribute("searchTypeOptions", searchTypeOptions);
            request.setAttribute("searchAction", "/board/news");
        %>
        <jsp:include page="../../common/searchBox.jsp"/>

        <c:if test="${not empty newsList}">
            <div style="overflow-x: auto;">
                <table class="table table-hover text-center align-middle news-table">
                    <thead class="table-light">
                    <tr>
                        <th style="width: 5%;">번호</th>
                        <th style="width: 80%;">
                            <a href="javascript:void(0);" onclick="applySort('title')">
                                제목
                                <c:if test="${searchDTO.sortColumn eq 'title'}">
                                    ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                        <th style="width: 15%;">
                            <a href="javascript:void(0);" onclick="applySort('pubDate')">
                                날짜
                                <c:if test="${searchDTO.sortColumn eq 'pubDate'}">
                                    ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                                </c:if>
                            </a>
                        </th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="news" items="${newsList}" varStatus="status">
                        <tr>
                            <td>${status.index + 1}</td>
                            <td class="text-start">
                                <a href="${news.link}" target="_blank"
                                   class="text-decoration-none text-dark d-block news-title">
                                    <c:out value="${news.title}"/>
                                </a>
                                <div class="small text-muted news-desc">
                                    <c:out value="${news.description}"/>
                                </div>
                            </td>
                            <td><c:out value="${news.pubDate}"/></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>

        <c:if test="${empty newsList}">
            <div class="alert alert-warning mt-4" role="alert">
                뉴스 결과가 없습니다.
            </div>
        </c:if>

        <div class="mt-4 text-center">
            <%@ include file="../../common/paging.jsp" %>
        </div>
    </div>
</div>

<script>
    <c:if test="${not empty message}">
    alert("${message}");
    </c:if>
</script>
</body>
</html>
