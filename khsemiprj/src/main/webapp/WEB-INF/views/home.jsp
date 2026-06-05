<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<style>
    /* 레이아웃 구성 */
    .dashboard-container {
        display: flex;
        gap: 20px; /* 좌우 간격 */
        width: 1200px;
        margin: 50px auto;
    }

    /* 좌측 달력 영역 (비율 7) */
    .left-section {
        flex: 7;
    }

    /* 우측 리스트 영역 (비율 3) */
    .right-section {
        flex: 3;
        display: flex;
        flex-direction: column;
        gap: 20px; /* 공지사항과 결재목록 사이 간격 */
    }

    .card {
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 8px;
    }
    
    .p-20 { padding: 20px; }
</style>

<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/index.global.min.js'></script>
<!-- <script src='https://cdn.jsdelivr.net/npm/@fullcalendar/core@6.1.20/index.global.min.js'></script> -->
<div class="dashboard-container">
    <div class="left-section">
        <div id='calendar' class="card p-20" style="min-height: 620px;"></div>
    </div>
    
    <div class="right-section">
        <div class="card p-20" style="height: 300px;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <h3>결재사항</h3>
                <a href="#">더보기</a>
            </div>
            </div>

        <div class="card p-20" style="height: 300px;">
            <h3>공지사항</h3>
            </div>
    </div>
</div>

<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');
        var calendar = new FullCalendar.Calendar(calendarEl, {
           
        	slotMinTime: '09:00',
        	slotMaxTime: '19:00',
        	
        	headerToolbar: {
			    left: 'prev,next today',
			    center: 'title',
			    right: 'dayGridMonth,timeGridWeek,timeGridDay' // 이 부분이 버튼을 생성합니다
 			 },
			    events: ${eventList},
        	initialView: 'dayGridMonth', 
            height: '100%' // 부모 div 높이에 맞춤
        });
        calendar.render();
    });
</script>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>