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
    <link rel="stylesheet" href="/resources/css/calendar.css" />
</head>
<body>
    <h1>학습계획표</h1>

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
    </script>
</body>
</html>
