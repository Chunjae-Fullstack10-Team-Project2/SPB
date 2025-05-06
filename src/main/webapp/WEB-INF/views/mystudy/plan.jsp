<%--
  Created by IntelliJ IDEA.
  User: MAIN
  Date: 2025-04-29
  Time: 오후 3:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                <h2>오늘의 계획</h2>
                <div class="card">
                    <div class="card-body">
                        <p class="card-title">2025-04-28</p>
                        <p class="card-subtitle">강의명</p>
                        <p class="card-text">메모</p>
                    </div>
                </div>
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
                    <form>
                        <label for="planDate" class="form-label">날짜</label>
                        <input type="date" class="form-control mb-3" id="planDate" name="plan_date" />

                        <label for="planLecture" class="form-label">강좌</label>
                        <select class="form-select mb-3" id="planLecture" name="plan_lecture">
                            <option selected>강좌를 선택하세요.</option>
                            <option value="1">One</option>
                            <option value="2">Two</option>
                            <option value="3">Three</option>
                        </select>

                        <label for="planContent" class="form-label">메모</label>
                        <textarea class="form-control" id="planContent" name="plan_content" style="resize: none;"></textarea>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="btnSubmit">등록</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="btnCancel">취소</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const calendarTitle = document.getElementById('calendarTitle');
        const calendarDate = document.getElementById('calendarDate');
        const btnPrev = document.getElementById('btnPrev');
        const btnNext = document.getElementById('btnNext');

        const getDateOnly = (date) => new Date(date.getFullYear(), date.getMonth(), date.getDate());

        const today = getDateOnly(new Date());
        let selectedDate = new Date(today);

        const getDayOfWeekClassName = (dayOfWeek) => {
            if (dayOfWeek === 0) return 'sunday';
            if (dayOfWeek === 6) return 'saturday';
            return 'weekday';
        };

        const renderCalendar = (year, month) => {
            calendarTitle.textContent = year + '년 ' + (month+1) + '월';
            calendarDate.innerHTML = '';

            const firstDay = new Date(year, month, 1).getDay(); // 일:0 ~ 토:6
            const lastDate = new Date(year, month+1, 0).getDate();
            const totalCells = Math.ceil((firstDay + lastDate) / 7) * 7;

            for (let i=0; i<totalCells; i++) {
                const offset = i - firstDay;
                const date = new Date(year, month, 1 + offset); // 오늘을 기준으로 앞, 뒤

                const dateDiv = document.createElement('div');
                const dateSpan = document.createElement('span');
                dateSpan.textContent = date.getDate().toString();

                if (date.getMonth() !== month) dateDiv.classList.add('other-month');
                if (date.getTime() === today.getTime()) dateDiv.classList.add('today');
                if (date.getTime() === selectedDate.getTime()) dateDiv.classList.add('selected');

                dateDiv.classList.add(getDayOfWeekClassName(date.getDay()));
                dateDiv.addEventListener('click', () => {
                    selectedDate = date;
                    renderCalendar(year, month);
                });

                dateDiv.appendChild(dateSpan);
                calendarDate.appendChild(dateDiv);
            }
        };

        const moveMonth = (offset) => {
            selectedDate.setMonth(selectedDate.getMonth() + offset);
            renderCalendar(selectedDate.getFullYear(), selectedDate.getMonth());
        }

        btnPrev.addEventListener('click', () => moveMonth(-1));
        btnNext.addEventListener('click', () => moveMonth(1));

        renderCalendar(today.getFullYear(), today.getMonth());

        <!-- Modal -->
        const btnRegist = document.getElementById('btnRegist');
        const modalRegist = document.getElementById('modalRegist');

        btnRegist.addEventListener('show.bs.modal', () => {
           modalRegist.focus();
        });
    </script>
</body>
</html>
