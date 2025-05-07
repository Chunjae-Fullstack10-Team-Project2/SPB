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
        <button type="button" class="btn btn-primary" id="btnGoRegist">계획등록</button>
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

    <!-- 모달 -->
    <div id="modalPlan" class="modal" tabindex="-1" data-mode="">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">계획 상세</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form name="frmModal" method="post">
                        <input type="hidden" name="planIdx" />
                        <input type="hidden" name="planMemberId" />

                        <label for="planDate" class="form-label">날짜</label>
                        <input type="date" class="form-control mb-3" name="planDate" id="planDate"/>

                        <label for="planLecture" class="form-label">강좌</label>
                        <select class="form-select mb-3" name="planLectureIdx" id="planLecture">
                            <option selected>강좌를 선택하세요.</option>
                            <c:forEach items="${lectureList}" var="lecture">
                                <option value="${lecture.lectureRegisterRefIdx}">${lecture.lectureTitle}</option>
                            </c:forEach>
                        </select>

                        <label for="planContent" class="form-label">메모</label>
                        <textarea class="form-control" name="planContent" id="planContent" style="resize: none;"></textarea>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="btnRegist">등록</button>
                    <button type="button" class="btn btn-primary" id="btnModify">수정</button>
                    <button type="button" class="btn btn-success" id="btnGoModify">수정</button>
                    <button type="button" class="btn btn-danger" id="btnDelete">삭제</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="btnCancel">취소</button>
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

        const param = new URLSearchParams(location.search).get('date');
        let selectedDate = param ? getDateOnly(new Date(param)) : new Date(today);

        // renderCalendar
        const renderCalendar = async (year, month) => {
            calendarTitle.textContent = year + '년 ' + (month+1) + '월';
            calendarDate.innerHTML = '';

            const firstDay = new Date(year, month, 1).getDay(); // 일:0 ~ 토:6
            const lastDate = new Date(year, month+1, 0).getDate();
            const totalCells = Math.ceil((firstDay + lastDate) / 7) * 7;

            // 학습 계획 조회
            const date1 = new Date(year, month, 1 - firstDay);
            const date2 = new Date(date1);
            date2.setDate(date2.getDate() + totalCells - 1);

            const monthPlans = await getPlansByMonth(date1, date2);

            // 달력 렌더링
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

                // 학습 계획 렌더링
                const plans = monthPlans.filter(p => p.planDate == formatDate(date));
                renderMonthPlans(dateDiv, plans);

                calendarDate.appendChild(dateDiv);
            }
        };

        const moveMonth = async (offset) => {
            selectedDate.setMonth(selectedDate.getMonth() + offset);
            await renderCalendar(selectedDate.getFullYear(), selectedDate.getMonth());
            renderDayPlans(await getPlansByDay(selectedDate));
        }

        btnPrev.addEventListener('click', () => moveMonth(-1));
        btnNext.addEventListener('click', () => moveMonth(1));

        // 학습 계획 렌더링
        const renderMonthPlans = (dateDiv, plans) => {
            plans.forEach(plan => {
                const planDiv = document.createElement('div');
                planDiv.className = 'plan-item';
                planDiv.textContent = plan.planContent;

                planDiv.dataset.planIdx = plan.planIdx;

                planDiv.addEventListener('click', async function(e) {
                    e.stopPropagation();
                    openPlanModal('view', await getPlanByIdx(this.dataset.planIdx));
                })

                dateDiv.appendChild(planDiv);
            });
        }

        const renderDayPlans = (plans) => {
            const planList = document.getElementById('planList');
            planList.innerHTML = '';

            const title = document.createElement('h2');
            title.textContent = formatDate(selectedDate);
            planList.appendChild(title);

            if (!plans || plans.length < 1) {
                const emptyMsg = document.createElement('p');
                emptyMsg.textContent = '등록된 계획이 없습니다.';
                planList.appendChild(emptyMsg);
                return;
            }

            plans.forEach(plan => {
                const card = document.createElement('div');
                card.className = 'card';
                card.dataset.planIdx = plan.planIdx;

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

                card.addEventListener('click', async function() {
                    openPlanModal('view', await getPlanByIdx(this.dataset.planIdx));
                });

                planList.appendChild(card);
            });
        }

        async function getPlansByDay(date) {
            const response = await fetch('/mystudy/plan/search?date=' + formatDate(date));
            return await response.json();
        }

        async function getPlansByMonth(date1, date2) {
            const response = await fetch('/mystudy/plan/search?date1=' + formatDate(date1) + '&date2=' + formatDate(date2));
            return await response.json();
        }

        async function getPlanByIdx(idx) {
            const response = await fetch('/mystudy/plan/' + idx);
            return await response.json();
        }

        // modal
        function openPlanModal(mode, data = {}) {
            const modal = document.getElementById('modalPlan');
            const currentInstance = bootstrap.Modal.getInstance(modal);
            const newInstance = currentInstance || new bootstrap.Modal(modal);

            const showModal = () => {
                modal.setAttribute('data-mode', mode);
                modal.setAttribute('data-idx', data.planIdx);

                const frm = document.forms['frmModal'];
                frm.reset();

                const isView = (mode === 'view');       // 수정, 삭제 버튼
                const isModify = (mode === 'modify');   // 수정, 취소 버튼
                const isRegist = (mode === 'regist');   // 등록, 취소 버튼

                const title = document.querySelector('.modal-title');
                if (isView) title.textContent = '학습 계획 상세';
                if (isModify) title.textContent = '학습 계획 수정';
                if (isRegist) title.textContent = '학습 계획 등록';

                // 필드값 설정
                frm.planIdx.value = data.planIdx || '';
                frm.planMemberId.value = data.planMemberId || '';
                frm.planDate.value = data.planDate || '';
                frm.planLectureIdx.value = data.planLectureIdx || '';
                frm.planContent.value = data.planContent || '';

                // 읽기 전용 설정
                frm.planDate.disabled = isView;
                frm.planLectureIdx.disabled = isView;
                frm.planContent.disabled = isView;

                // 버튼 표시 설정
                document.getElementById('btnRegist').classList.toggle('d-none', !isRegist);
                document.getElementById('btnModify').classList.toggle('d-none', !isModify);
                document.getElementById('btnGoModify').classList.toggle('d-none', !isView);
                document.getElementById('btnDelete').classList.toggle('d-none', !isView);
                document.getElementById('btnCancel').classList.toggle('d-none', isView);

                newInstance.show();
            };

            if (modal.classList.contains('show')) {
                modal.addEventListener('hidden.bs.modal', function handler() {
                    modal.removeEventListener('hidden.bs.modal', handler);
                    showModal();
                });
                newInstance.hide();
            } else {
                showModal();
            }
        }

        document.getElementById('btnGoRegist').addEventListener('click', () => {
            openPlanModal('regist');
        });

        document.getElementById('btnRegist').addEventListener('click', () => {
            const frm = document.forms['frmModal'];

            const planDate = frm.planDate.value;
            const planLecture = frm.planLectureIdx.value;
            const planContent = frm.planContent.value;

            if (!planDate) {
                alert("날짜를 선택하세요.");
                frm.planDate.focus();
                return;
            }
            if (!planLecture) {
                alert("강좌를 선택하세요.");
                frm.planLecture.focus();
                return;
            }
            if (planContent.length < 1) {
                alert("내용을 입력하세요.");
                frm.planContent.focus();
                return;
            }

            frm.action = '/mystudy/plan/regist?date=' + formatDate(selectedDate);
            frm.submit();
        });

        document.getElementById('btnGoModify').addEventListener('click', async () => {
            const modal = document.getElementById('modalPlan');
            const data = await getPlanByIdx(modal.getAttribute('data-idx'));
            openPlanModal('modify', data);
        });

        document.getElementById('btnModify').addEventListener('click', async () => {
            const frm = document.forms['frmModal'];

            const planIdx = frm.planIdx.value;
            const planMemberId = frm.planMemberId.value;

            const planDate = frm.planDate.value;
            const planLecture = frm.planLectureIdx.value;
            const planContent = frm.planContent.value;

            if (!planDate) {
                alert("날짜를 선택하세요.");
                frm.planDate.focus();
                return;
            }
            if (!planLecture) {
                alert("강좌를 선택하세요.");
                frm.planLectureIdx.focus();
                return;
            }
            if (planContent.length < 1) {
                alert("내용을 입력하세요.");
                frm.planContent.focus();
                return;
            }

            const formData = { planIdx, planMemberId, planDate, planLectureIdx: planLecture, planContent };
            const response = await fetch('/mystudy/plan/modify?date=' + formatDate(selectedDate), {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });
            const result = await response.json();
            if (result.errorMessage) {
                alert(result.errorMessage);
                return;
            }

            // 수정 완료되면, 수정된 데이터를 다시 가져옴
            const data = await getPlanByIdx(planIdx);
            openPlanModal('view', data);

            // 캘린더 재렌더링
            await renderCalendar(selectedDate.getFullYear(), selectedDate.getMonth());
            renderDayPlans(await getPlansByDay(selectedDate));
        });

        document.getElementById('btnDelete').addEventListener('click', () => {
            if (confirm("학습 계획을 삭제하시겠습니까?")) {
                const frm = document.forms['frmModal'];
                frm.action = '/mystudy/plan/delete';
                frm.submit();
            }
        });

        // 초기 렌더링
        document.addEventListener('DOMContentLoaded', async () => {
            renderCalendar(today.getFullYear(), today.getMonth());
            renderDayPlans(await getPlansByDay(selectedDate));
        });
    </script>
</body>
</html>
