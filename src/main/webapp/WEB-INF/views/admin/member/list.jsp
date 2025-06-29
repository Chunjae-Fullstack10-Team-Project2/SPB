<%@ page import="net.spb.spb.util.MemberUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: sinjihye
  Date: 2025. 5. 3.
  Time: 20:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>봄콩이 회원 목록</title>
    <style>
        .table td {
            font-size: 13px;
            vertical-align: middle;
        }
        .table td a {
            text-decoration: none;
            color: black;
        }
        .table td a:hover {
            text-decoration: underline;
        }
        .sort-icons {
            font-size: 0.7em;
            color: gray;
        }
        .sort-icons:hover {
            color: black;
        }
    </style>
</head>
<body>
<%@ include file="../../common/sidebarHeader.jsp" %>
<c:set var="memberUtil" value="<%= new MemberUtil()%>"/>
<div class="content mr-5">
    <%@ include file="../../common/breadcrumb.jsp" %>
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0">봄콩이 회원 목록</h3>
        </div>
        <div class="search-box" style="max-width: 700px;">
            <form name="frmSearch" method="get" action="/admin/member/list" class="mb-1 p-4">
                <div class="row g-2 align-items-center mb-3">
                    <div class="col-md-4">
                        <select name="search_member_state" class="form-select" id="search_member_state">
                            <option value="">선택</option>
                            <c:forEach var="i" begin="1" end="6" step="1">
                                <option value="${i}" ${searchDTO.search_member_state == i ? "selected":""}>${memberUtil.getMemberState(i)}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select name="search_member_grade" class="form-select" id="search_member_grade">
                            <option value="" selected>선택</option>

                            <optgroup label="관리자">
                                <option value="0" ${searchDTO.search_member_grade == '0' ? 'selected' : ''}>${memberUtil.getMemberGrade(0)}</option>
                                <option value="13" ${searchDTO.search_member_grade == '13' ? 'selected' : ''}>${memberUtil.getMemberGrade(13)}</option>
                                <option value="14" ${searchDTO.search_member_grade == '14' ? 'selected' : ''}>기타</option>
                            </optgroup>
                            <optgroup label="초등학교">
                                <option value="1" ${searchDTO.search_member_grade == '1' ? 'selected' : ''}>${memberUtil.getMemberGrade('1')}</option>
                                <option value="2" ${searchDTO.search_member_grade == '2' ? 'selected' : ''}>${memberUtil.getMemberGrade(2)}</option>
                                <option value="3" ${searchDTO.search_member_grade == '3' ? 'selected' : ''}>${memberUtil.getMemberGrade(3)}</option>
                                <option value="4" ${searchDTO.search_member_grade == '4' ? 'selected' : ''}>${memberUtil.getMemberGrade(4)}</option>
                                <option value="5" ${searchDTO.search_member_grade == '5' ? 'selected' : ''}>${memberUtil.getMemberGrade(5)}</option>
                                <option value="6" ${searchDTO.search_member_grade == '6' ? 'selected' : ''}>${memberUtil.getMemberGrade(6)}</option>
                            </optgroup>
                            <optgroup label="중학교">
                                <option value="7" ${searchDTO.search_member_grade == '7' ? 'selected' : ''}>${memberUtil.getMemberGrade(7)}</option>
                                <option value="8" ${searchDTO.search_member_grade == '8' ? 'selected' : ''}>${memberUtil.getMemberGrade(8)}</option>
                                <option value="9" ${searchDTO.search_member_grade == '9' ? 'selected' : ''}>${memberUtil.getMemberGrade(9)}</option>
                            </optgroup>
                            <optgroup label="고등학교">
                                <option value="10" ${searchDTO.search_member_grade == '10' ? 'selected' : ''}>${memberUtil.getMemberGrade(10)}</option>
                                <option value="11" ${searchDTO.search_member_grade == '11' ? 'selected' : ''}>${memberUtil.getMemberGrade(11)}</option>
                                <option value="12" ${searchDTO.search_member_grade == '12' ? 'selected' : ''}>${memberUtil.getMemberGrade(12)}</option>
                            </optgroup>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <input type="text" name="search_word" class="form-control" placeholder="이름/아이디 검색"
                               value="${searchDTO.search_word}"/>
                    </div>
                    <div class="col-md-3 d-flex gap-1">
                        <button type="submit" class="btn btn-primary flex-fill" id="btnSearch">검색</button>
                        <button type="button" class="btn btn-link text-decoration-none" id="btnReset">초기화</button>
                    </div>
                </div>
            </form>
        </div>
        <div class="text-right mb-2">
            <select class="form-select form-select-sm w-auto" name="page_size" id="selectPageSize">
                <option value="5" ${searchDTO.page_size == 5 ? "selected":""}>5개씩</option>
                <option value="10" ${searchDTO.page_size == 10 ? "selected":""}>10개씩</option>
                <option value="15" ${searchDTO.page_size == 15 ? "selected":""}>15개씩</option>
                <option value="20" ${searchDTO.page_size == 20 ? "selected":""}>20개씩</option>
                <option value="30" ${searchDTO.page_size == 30 ? "selected":""}>30개씩</option>
            </select>
        </div>
        <table class="table table-hover text-center align-middle">
            <colgroup>
                <col span="1" style="width: 80px">
                <col span="1">
                <col span="1" style="width: 118px">
                <col span="1" style="width: 118px">
                <col span="1" style="width: 118px">
                <col span="1" style="width: 150px">
                <col span="1" style="width: 150px">
                <col span="1" style="width: 118px">
            </colgroup>
            <thead class="table-light">
            <tr>
                <th scope="col">
                    No
    <%--                <span class="sort-icons" onclick="sortBy('memberIdx', 'asc')">▲</span>--%>
    <%--                <span class="sort-icons" onclick="sortBy('memberIdx', 'desc')">▼</span>--%>
                </th>
                <th scope="col">
                    아이디
                    <span class="sort-icons" onclick="sortBy('memberId', 'asc')">▲</span>
                    <span class="sort-icons" onclick="sortBy('memberId', 'desc')">▼</span>
                </th>
                <th scope="col">
                    이름
                    <span class="sort-icons" onclick="sortBy('memberName', 'asc')">▲</span>
                    <span class="sort-icons" onclick="sortBy('memberName', 'desc')">▼</span>
                </th>
                <th scope="col">
                    학년
                    <span class="sort-icons" onclick="sortBy('memberGrade', 'asc')">▲</span>
                    <span class="sort-icons" onclick="sortBy('memberGrade', 'desc')">▼</span>
                </th>
                <th scope="col">
                    생년월일
                    <span class="sort-icons" onclick="sortBy('memberBirth', 'asc')">▲</span>
                    <span class="sort-icons" onclick="sortBy('memberBirth', 'desc')">▼</span>
                </th>
                <th scope="col">
                    회원 가입일
                    <span class="sort-icons" onclick="sortBy('memberCreatedAt', 'asc')">▲</span>
                    <span class="sort-icons" onclick="sortBy('memberCreatedAt', 'desc')">▼</span>
                </th>
                <th scope="col">
                    상태
                    <span class="sort-icons" onclick="sortBy('memberState', 'asc')">▲</span>
                    <span class="sort-icons" onclick="sortBy('memberState', 'desc')">▼</span>
                </th>
                <th scope="col">삭제</th>
            </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach items="${list}" var="member" varStatus="status">
                            <tr>
                                <td>${status.count} </td>
                                <td><a href="javascript:void(0);" onclick="openMemberDetail('${member.memberId}')">
                                        ${member.memberId}
                                </a></td>
                                <td>${member.memberName}</td>
                                <td>${memberUtil.getMemberGrade(member.memberGrade)}</td>
                                <td>
                                    <c:set var="rawDate" value="${member.memberBirth}" />
                                        ${fn:substring(rawDate, 0, 4)}-${fn:substring(rawDate, 4, 6)}-${fn:substring(rawDate, 6, 8)}
                                </td>
                                <td>${member.memberCreatedAt}</td>
                                <td>${memberUtil.getMemberState(member.memberState)}</td>
                                <td>
                                    <form action="/admin/member/state" method="post" class="frmMemberState" onsubmit="return confirm('정말 상태를 변경하시겠습니까?');" style="display:inline;">
                                        <input type="hidden" name="memberId" value="${member.memberId}"/>
                                        <input type="hidden" name="memberIdx" value="${member.memberIdx}"/>
                                        <input type="hidden" name="search_member_state" value="${searchDTO.search_member_state}">
                                        <input type="hidden" name="search_member_grade" value="${searchDTO.search_member_grade}">
                                        <input type="hidden" name="search_word" value="${searchDTO.search_word}">
                                        <input type="hidden" name="page_no" value="${searchDTO.page_no}">
                                        <input type="hidden" name="page_size" value="${searchDTO.page_size}">
                                        <input type="hidden" name="page_block_size" value="${searchDTO.page_block_size}">
                                        <input type="hidden" name="sort_by" value="${searchDTO.sort_by}">

                                        <c:choose>
                                            <c:when test="${member.memberState eq '1'}">
                                                <input type="hidden" name="memberState" value="2"/>
                                                <button type="submit" class="btn btn-outline-danger btnDelete" style="font-size:13px">정지</button>
                                            </c:when>
                                            <c:when test="${member.memberState > 1 and member.memberState < 7}">
                                                <input type="hidden" name="memberState" value="1"/>
                                                <button type="submit" class="btn btn-outline-success btnDelete" style="font-size:13px">활성화</button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="submit" class="btn btn-outline-secondary" style="font-size:13px" disabled>변경불가</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <tr>
                            <td colspan="8">
                                ${paging}
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="8" style="text-align: center;padding: 20px;">
                                등록된 회원 정보가 없습니다.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>
<script>
    function openMemberDetail(memberId) {
        const url = '/admin/member/view?memberId=' + encodeURIComponent(memberId);
        window.open(url, 'memberDetail', 'width=600,height=530,scrollbars=no,resizable=no');
    }

    function updateQueryParam(key, value) {
        const url = new URL(window.location.href);
        if (value) {
            url.searchParams.set(key, value);
        } else {
            url.searchParams.delete(key);
        }
        window.location.href = url.toString();
    }

    document.getElementById("search_member_state").addEventListener('change', function() {
        updateQueryParam("search_member_state", this.value);
    });
    document.getElementById("search_member_grade").addEventListener('change', function() {
        updateQueryParam("search_member_grade", this.value);
    });

    function sortBy(sortType, sortDirection) {
        const url = new URL(window.location.href);
        url.searchParams.set("sort_by", sortType);
        url.searchParams.set("sort_direction", sortDirection);
        window.location.href = url.toString();
    }

    document.getElementById('btnReset').addEventListener('click', function() {
        window.location.href="list";
    })

    document.getElementById("selectPageSize").addEventListener('change', function () {
        const pageSize = this.value;
        const url = new URL(window.location.href);
        url.searchParams.set("page_size", pageSize);
        window.location.href = url.toString();
    });
</script>
</body>
</html>
