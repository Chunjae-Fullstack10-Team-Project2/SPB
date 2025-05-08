<%--
  Created by IntelliJ IDEA.
  User: sinjihye
  Date: 2025. 5. 3.
  Time: 21:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .sidebar {
    width: 150px;
    border-right: 1px solid #ddd;
    padding: 15px;
  }

  .sidebar-title {
    font-weight: bold;
    margin-bottom: 15px;
  }

  .sidebar-menu {
    list-style: none;
  }

  .sidebar-menu li {
    margin-bottom: 10px;
  }

  .sidebar-menu a {
    text-decoration: none;
    color: #333;
  }

  .sidebar-menu a:hover {
    text-decoration: underline;
  }
  .sidebar-menu ul, .sidebar-menu li {
    padding-left: 0;
  }
</style>
<div class="sidebar">
  <div class="sidebar-title">관리자 페이지</div>
  <ul class="sidebar-menu">
    <li><strong><a href="/admin/member/list">회원 목록</a></strong></li>
    <li><a href="/admin/teacher/regist">선생님 등록</a></li>
    <li><a href="/admin/lecture/regist">강좌 목록</a></li>
    <li><a href="/admin/lecture/chapter/regist">강좌 등록</a></li>
    <li><a href="/admin/report/list">신고 내역</a>
    <li><a href="/admin/report/list">자유게시판</a>
    <li><a href="/admin/report/list">강의 리뷰</a></li>
    <li><a href="#">공지사항 작성</a></li>
  </ul>
</div>
