<%--
  Created by IntelliJ IDEA.
  User: MAIN
  Date: 2025-04-29
  Time: 오후 3:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>나의 강의실</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js" integrity="sha384-k6d4wzSIapyDyv1kpU366/PK5hCdSbCRGRCMv+eplOQJWyd1fbcAu9OCUj5zNLiq" crossorigin="anonymous"></script>

    <link rel="stylesheet" href="/resources/css/calendar.css" />
</head>
<body>
    <%@include file="../common/header.jsp" %>

    <div class="container">
        <h1>학습계획표</h1>
        <button type="button" class="btn btn-primary" id="btnRegist" data-bs-toggle="modal" data-bs-target="#modalRegist">계획등록</button>
        <div class="row">
            <div class="col-12 col-lg-4" id="planList">

            </div>
            <div class="col-12 col-lg-8" id="calendarSection">
                <div class="calendar">
                    <div class="calendar-header">
                        <input type="button" id="btnPrev" value="<" />
                        <span id="calendarTitle"></span>
                        <input type="button" id="btnNext" value=">" />
                    </div>
                    <div class="calendar-body">
                        <div class="calendar-week">
                            <div class="sunday">일</div>
                            <div>월</div>
                            <div>화</div>
                            <div>수</div>
                            <div>목</div>
                            <div>금</div>
                            <div class="saturday">토</div>
                        </div>
                        <div class="calendar-date" id="calendarDate"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 계획 등록 모달 -->
    <div id="modalRegist" class="modal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">계획 등록</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form name="frmRegist" method="post">
                        <label for="planDate" class="form-label">날짜</label>
                        <input type="date" class="form-control mb-3" id="planDate" name="planDate"/>

                        <label for="planLecture" class="form-label">강좌</label>
                        <select class="form-select mb-3" id="planLecture" name="planLectureIdx">
                            <option selected>강좌를 선택하세요.</option>
                            <c:forEach items="${lectureList}" var="lecture">
                                <option value="${lecture.lectureRegisterRefIdx}">${lecture.lectureTitle}</option>
                            </c:forEach>
                        </select>

                        <label for="planContent" class="form-label">메모</label>
                        <textarea class="form-control" id="planContent" name="planContent" style="resize: none;"></textarea>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="btnSubmit">등록</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="btnCancel">취소</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 계획 상세 모달 -->
    <div id="modalView" class="modal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">계획 상세</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <th>날짜</th>
                            <td id="viewPlanDate"></td>
                        </tr>
                        <tr>
                            <th>강좌명</th>
                            <td id="viewLectureTitle"></td>
                        </tr>
                        <tr>
                            <th>메모</th>
                            <td id="viewPlanContent"></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <span id="viewPlanCreatedAt"></span>
                                <span id="viewPlanUpdatedAt"></span>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="btnModify">수정</button>
                    <button type="button" class="btn btn-danger" id="btnDelete">삭제</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // common function
        const getDateOnly = (date) => new Date(date.getFullYear(), date.getMonth(), date.getDate());

        const getDayOfWeekClassName = (dayOfWeek) => {
            if (dayOfWeek === 0) return 'sunday';
            if (dayOfWeek === 6) return 'saturday';
            return 'weekday';
        };

        const formatDate = (date) => {
          const year = date.getFullYear();
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const day = String(date.getDate()).padStart(2, '0');

          return year + '-' + month + '-' + day;
        };

        // variable
        const calendarTitle = document.getElementById('calendarTitle');
        const calendarDate = document.getElementById('calendarDate');
        const btnPrev = document.getElementById('btnPrev');
        const btnNext = document.getElementById('btnNext');

        const today = getDateOnly(new Date());
        let selectedDate = new Date(today);
        let monthPlans = [];

        // renderCalendar
        const renderCalendar = async (year, month) => {
            calendarTitle.textContent = year + '년 ' + (month+1) + '월';
            calendarDate.innerHTML = '';

            const firstDay = new Date(year, month, 1).getDay(); // 일:0 ~ 토:6
            const lastDate = new Date(year, month+1, 0).getDate();
            const totalCells = Math.ceil((firstDay + lastDate) / 7) * 7;

            // 일정 업데이트
            const date1 = new Date(year, month, 1 - firstDay);
            const date2 = new Date(date1);
            date2.setDate(date2.getDate() + totalCells - 1);
            await getPlansByMonth(date1, date2);

            for (let i=0; i<totalCells; i++) {
                const offset = i - firstDay;
                const date = new Date(year, month, 1 + offset); // 오늘을 기준으로 앞, 뒤

                const dateDiv = document.createElement('div');
                dateDiv.dataset.date = formatDate(date);

                const dateSpan = document.createElement('span');
                dateSpan.textContent = date.getDate().toString();

                if (date.getMonth() !== month) dateDiv.classList.add('other-month');
                if (date.getTime() === today.getTime()) dateDiv.classList.add('today');
                if (date.getTime() === selectedDate.getTime()) dateDiv.classList.add('selected');

                dateDiv.classList.add(getDayOfWeekClassName(date.getDay()));
                dateDiv.addEventListener('click', () => {
                    const prevSelected = calendarDate.querySelector('.selected');
                    if (prevSelected) prevSelected.classList.remove('selected');

                    selectedDate = date;
                    dateDiv.classList.add('selected');

                    getPlansByDay(selectedDate);
                });

                dateDiv.appendChild(dateSpan);

                renderMonthPlans(dateDiv, date);

                calendarDate.appendChild(dateDiv);
            }
        };

        const renderMonthPlans = (dateDiv, date) => {
            const plans = monthPlans.filter(p => p.planDate == formatDate(date));
            plans.forEach(plan => {
                const planDiv = document.createElement('div');
                // planDiv.dataset.bsToggle = 'modal';
                // planDiv.dataset.bsTarget = '#modalView';
                planDiv.className = 'plan-item';
                planDiv.textContent = plan.planContent;

                planDiv.dataset.planIdx = plan.planIdx;

                planDiv.addEventListener('click', function(e) {
                    e.stopPropagation();
                    getPlanByIdx(this.dataset.planIdx);
                })

                dateDiv.appendChild(planDiv);
            });
        }

        // month navigation
        const moveMonth = (offset) => {
            selectedDate.setMonth(selectedDate.getMonth() + offset);
            renderCalendar(selectedDate.getFullYear(), selectedDate.getMonth());
        }

        btnPrev.addEventListener('click', () => moveMonth(-1));
        btnNext.addEventListener('click', () => moveMonth(1));

        // day plan list
        function getPlansByDay(date = selectedDate) {
            date = formatDate(date)
            fetch('/mystudy/plan/search?date=' + date)
                .then(response => response.json())
                .then(data => {
                    const planList = document.getElementById('planList');
                    planList.innerHTML = '';

                    const title = document.createElement('h2');
                    title.textContent = date;
                    planList.appendChild(title);

                    if (!data || data.length < 1) {
                        const emptyMsg = document.createElement('p');
                        emptyMsg.textContent = '등록된 계획이 없습니다.';
                        planList.appendChild(emptyMsg);
                        return;
                    }

                    data.forEach(plan => {
                        const card = document.createElement('div');
                        card.className = 'card';
                        card.dataset.bsToggle = 'modal';
                        card.dataset.bsTarget = '#modalView';

                        const cardBody = document.createElement('div');
                        cardBody.className = 'card-body';

                        const cardTitle = document.createElement('p');
                        cardTitle.className = 'card-title';
                        cardTitle.textContent = plan.lectureTitle;

                        const cardText = document.createElement('p');
                        cardText.className = 'card-text';
                        cardText.textContent = plan.planContent;

                        cardBody.appendChild(cardTitle);
                        cardBody.appendChild(cardText);

                        card.appendChild(cardBody);

                        planList.appendChild(card);
                    });
                });
        }

        async function getPlansByMonth(date1, date2) {
            const response = await fetch('/mystudy/plan/search?date1=' + formatDate(date1) + '&date2=' + formatDate(date2));
            const data = await response.json();
            monthPlans = data;
        }

        function getPlanByIdx(idx) {
            fetch('/mystudy/plan/idx=' + idx)
                .then(response => response.json())
                .then(data => {
                   document.getElementById('viewPlanDate').value = data.planDate;
                   document.getElementById('viewLectureTitle').value = data.lectureTitle;
                   document.getElementById('viewPlanContent').value = data.planContent;

                    // 모달 열기
                    const modal = new bootstrap.Modal(document.getElementById('modalView'));
                    modal.show();
                });
        }

        // modal
        document.getElementById('btnSubmit').addEventListener('click', () => {
            const frm = document.querySelector('[name="frmRegist"]');

            const planDate = frm.planDate;
            const planLecture = frm.planLectureIdx;
            const planContent = frm.planContent;

            if (planDate.value == null) {
                alert("날짜를 선택하세요.");
                planDate.focus();
                return;
            }
            if (planLecture.value == null) {
                alert("강좌를 선택하세요.");
                planLecture.focus();
                return;
            }
            if (planContent.value.length < 1) {
                alert("내용을 입력하세요.");
                planContent.focus();
                return;
            }

            frm.action = '/mystudy/plan/regist';
            frm.submit();
        });

        // init
        renderCalendar(today.getFullYear(), today.getMonth());
        getPlansByDay();
    </script>
</body>
</html>
