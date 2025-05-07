<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>강좌 메인</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Malgun Gothic', sans-serif;
        }

        .teacher-container {
            max-width: 1000px;
            margin: 0 auto;
            border: 1px solid #ccc;
        }

        .content {
            padding: 20px;
        }

        .title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .search-area {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            gap: 5px;
        }

        .search-label {
            margin-right: 5px;
        }

        .search-select {
            padding: 3px;
            width: 100px;
            border: 1px solid #ccc;
        }

        .search-input {
            flex: 1;
            padding: 3px;
            border: 1px solid #ccc;
        }

        .btn {
            padding: 3px 10px;
            background-color: #f5f5f5;
            border: 1px solid #ccc;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #e5e5e5;
        }

        .teacher-list {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
        }

        .teacher-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 23%;
            margin-bottom: 20px;
        }

        .teacher-circle {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 1px solid #ccc;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
        }

        .teacher-circle-inner {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background-color: #f5f5f5;
        }

        .teacher-name {
            text-align: center;
        }

        @media (max-width: 768px) {
            .teacher-item {
                width: 48%;
            }
        }
    </style>
</head>
<body>
<%@ include file="../common/header.jsp" %>
<div class="teacher-container">
    <div class="content">
        <div class="title">선생님 페이지</div>
        <div class="search-area">
            <span class="search-label">구분</span>
            <select class="search-select">
                <option>전체</option>
                <option>이름</option>
                <option>과목</option>
            </select>
            <input type="text" class="search-input" placeholder="검색어를 입력하세요">
            <button class="btn">검색</button>
            <button class="btn">초기화</button>
        </div>

        <div class="teacher-list">
            <div class="teacher-item">
                <div class="teacher-circle">
                    <div class="teacher-circle-inner"></div>
                </div>
                <div class="teacher-name">가가가 선생님</div>
            </div>

            <div class="teacher-item">
                <div class="teacher-circle">
                    <div class="teacher-circle-inner"></div>
                </div>
                <div class="teacher-name">나나나 선생님</div>
            </div>

            <div class="teacher-item">
                <div class="teacher-circle">
                    <div class="teacher-circle-inner"></div>
                </div>
                <div class="teacher-name">다다다 선생님</div>
            </div>

            <div class="teacher-item">
                <div class="teacher-circle">
                    <div class="teacher-circle-inner"></div>
                </div>
                <div class="teacher-name">라라라 선생님</div>
            </div>
        </div>
    </div>
</div>
</body>
</html>