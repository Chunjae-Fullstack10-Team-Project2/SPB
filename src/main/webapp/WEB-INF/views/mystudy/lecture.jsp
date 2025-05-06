<%--
  Created by IntelliJ IDEA.
  User: MAIN
  Date: 2025-05-06
  Time: 오후 5:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>Title</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <%@ include file="../common/header.jsp" %>
    <div class="container">
        <h1>나의 강의실</h1>

        <!-- 검색창 영역 -->
        <div class="search-box">
            <div class="search-status btn-group" role="group">
                <input type="radio" class="btn-check" name="lecture_status" id="lecture_status_0" value="0" ${pageDTO.lecture_status eq 0 ? checked : ''} />
                <label class="btn btn-outline-primary" for="lecture_status_0">수강전</label>

                <input type="radio" class="btn-check" name="lecture_status" id="lecture_status_1" value="1" ${pageDTO.lecture_status eq 1 ? checked : ''} />
                <label class="btn btn-outline-primary" for="lecture_status_1">수강중</label>

                <input type="radio" class="btn-check" name="lecture_status" id="lecture_status_2" value="2" ${pageDTO.lecture_status eq 2 ? checked : ''} />
                <label class="btn btn-outline-primary" for="lecture_status_2">수강완료</label>
            </div>
            <div class="search-word">
                <select class="form-select" name="search_category">
                    <option value="lectureTitle" ${pageDTO.search_category eq 'lectureTitle' ? selected : ''}>강의명</option>
                    <option value="teacherName" ${pageDTO.search_category eq 'teacherName' ? selected : ''}>선생님</option>
                </select>
                <input class="form-control" type="text" name="search_word" value="${pageDTO.search_word}" placeholder="검색어를 입력하세요."/>
                <button type="button" class="btn btn-primary" id="btnSearch">검색</button>
            </div>
        </div>

        <!-- 목록 영역 -->
        <div class="lecture-list">
            <c:choose>
                <c:when test="${not empty lectureList}">
                    <c:forEach var="lecture" items="${lectureList}">
                        <div class="card">
                            <div class="row">
                                <div class="col">
                                    진도율 ${lecture.lectureProgress != null ? lecture.lectureProgress : 0}%
                                </div>
                                <div class="col">
                                    <div class="card-body">
                                        <p class="lecture-teacher">${lecture.teacherName}</p>
                                        <p class="lecture-title">${lecture.lectureTitle}</p>
                                        <p class="lecture-history">최종학습일: ${lecture.lectureHistoryLastWatchDate != null ? lecture.lectureHistoryLastWatchDate : ''}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p>강좌가 없습니다.</p>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="paging">
            ${paging}
        </div>
    </div>
    <script>
        const lectureStatus = document.querySelectorAll('input[name="lecture_status"]');
        lectureStatus.forEach(status => {
            status.addEventListener("change", function() {
                const status = this.value;
                const params = new URLSearchParams(window.location.search);
                params.set('lecture_status', status);
                window.location.href = "/mystudy/lecture?" + params.toString();
            });
        });

        const btnSearch = document.getElementById("btnSearch");
        btnSearch.addEventListener("click", (e) => {
            e.preventDefault();
            e.stopPropagation();

            const search_category = document.querySelector("select[name='search_category']").value;
            const search_word = document.querySelector("input[name='search_word']").value;

            if (search_category == null || search_word == null) {
                alert("검색어를 입력해주세요.");
                return;
            }

            const params = new URLSearchParams(window.location.search);
            params.set("search_category", search_category);
            params.set("search_word", search_word);
            window.location.href = "/mystudy/lecture?" + params.toString();
        });
    </script>
</body>
</html>
