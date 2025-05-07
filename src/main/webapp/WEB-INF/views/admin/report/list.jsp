<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  Created by IntelliJ IDEA.
  User: sinjihye
  Date: 2025. 5. 6.
  Time: 00:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<svg xmlns="http://www.w3.org/2000/svg" class="d-none">
    <symbol id="house-door-fill" viewBox="0 0 16 16">
        <path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5z"/>
    </symbol>
</svg>
<fmt:setLocale value="ko_kr"/>
<%@ include file="../../common/header.jsp" %>
<%@ include file="../../common/sidebarHeader.jsp" %>
<div class="content" style="margin-left: 280px; margin-top: 100px; padding-left: 10px; padding-right: 10px">
    <svg xmlns="http://www.w3.org/2000/svg" class="d-none">
        <symbol id="house-door-fill" viewBox="0 0 16 16">
            <path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5z"/>
        </symbol>
    </svg>
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
                    <a class="link-body-emphasis fw-semibold text-decoration-none" href="/mypage">마이페이지</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    신고 목록
                </li>
            </ol>
        </nav>
    </div>
    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">신고 목록</h3>
        </div>
        <div class="search-box" style="max-width: 700px;">
            <form name="frmSearch" method="get" action="/mypage/report" class="mb-1 p-4">
                <div class="row g-2 align-items-center mb-3">
                    <div class="col-md-3">
                        <select name="dateType" class="form-select">
                            <option value="reportCreatedAt" ${param.dateType eq 'reportCreatedAt' ? 'selected' : ''}>
                                신고일자
                            </option>
                            <option value="postCreatedAt" ${param.dateType eq 'postCreatedAt' ? 'selected' : ''}>게시글
                                작성일자
                            </option>
                        </select>
                    </div>
                    <div class="col-md-8">
                        <input type="text" name="datefilter" id="datefilter" class="form-control" placeholder="기간 선택"
                               autocomplete="off"
                               value="${not empty param.datefilter ? param.datefilter : ''}"/>
                    </div>
                </div>

                <div class="row g-2 align-items-center mb-3">
                    <div class="col-md-3">
                        <select name="searchType" class="form-select">
                            <option value="postTitle" ${searchDTO.searchType eq "postTitle" ? "selected":""}>제목</option>
                            <option value="postContent" ${searchDTO.searchType eq "postContent" ? "selected":""}>내용
                            </option>
                            <option value="postMemberId" ${searchDTO.searchType eq "postMemberId" ? "selected":""}>작성자
                            </option>
                        </select>
                    </div>
                    <div class="col-md-5">
                        <input type="text" name="searchWord" class="form-control" placeholder="검색어 입력"
                               value="${searchDTO.searchWord}"/>
                    </div>
                    <div class="col-md-3 d-flex gap-1">
                        <button type="submit" class="btn btn-primary flex-fill" id="btnSearch">검색</button>
                        <button type="button" class="btn btn-link text-decoration-none" id="btnReset">초기화</button>
                    </div>
                </div>
            </form>
        </div>
    <table class="table">
        <colgroup>
            <col span="1" style="width: 80px">
            <col span="1">
            <col span="1" style="width: 120px">
            <col span="1" style="width: 180px">
            <col span="1" style="width: 180px">
            <col span="1" style="width: 150px">
        </colgroup>
        <thead>
        <tr>
            <th scope="col">
                No
                <span class="sort-icons" onclick="sortBy('reportIdx', 'asc')">▲</span>
                <span class="sort-icons" onclick="sortBy('reportIdx', 'desc')">▼</span>
            </th>
            <th scope="col">
                원본 글 번호
                <span class="sort-icons" onclick="sortBy('reportRefIdx', 'asc')">▲</span>
                <span class="sort-icons" onclick="sortBy('reportRefIdx', 'desc')">▼</span>
            </th>
            <th scope="col">
                원본 글 유형
            </th>
            <th scope="col">
                신고한 회원
                <span class="sort-icons" onclick="sortBy('reportMemberId', 'asc')">▲</span>
                <span class="sort-icons" onclick="sortBy('reportMemberId', 'desc')">▼</span>
            </th>
            <th scope="col">
                신고일자
                <span class="sort-icons" onclick="sortBy('reportCreatedAt', 'asc')">▲</span>
                <span class="sort-icons" onclick="sortBy('reportCreatedAt', 'desc')">▼</span>
            </th>
            <th scope="col">
                신고 상태
                <span class="sort-icons" onclick="sortBy('reportState', 'asc')">▲</span>
                <span class="sort-icons" onclick="sortBy('reportState', 'desc')">▼</span>
            </th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${reports}" var="report">
            <tr>
                <td>${report.reportIdx} </td>
                <td>
    <%--                <a href="javascript:void(0);" onclick="openMemberDetail('${member.memberId}')">--%>
    <%--                    ${member.memberId}--%>
    <%--                </a>--%>
                    ${report.reportRefIdx}
                </td>
                <td>${report.reportRefType.displayName}</td>
                <td>${report.reportMemberId}</td>
                <td><fmt:formatDate value="${report.reportCreatedAt}" pattern="yyyy-MM-dd"/></td>
                <td>${report.reportState}</td>
            </tr>
        </c:forEach>
        <tr>
            <td colspan="8">
                ${paging}
            </td>
        </tr>
        </tbody>
    </table>
    </div>
</div>
</body>
</html>
