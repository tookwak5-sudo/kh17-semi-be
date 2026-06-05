<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"/>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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

        <div 
        class="card p-20" style="height: 300px;">
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
        	    right: 'btnAll,btnDept,btnPersonal' 
        	},
 			 
 			customButtons: {
 			    btnAll: {
 			        text: '회사',
 			        click: function() {
 			            filterCalendarEvents("회사"); // 함수에게 "전체"를 전달!
 			        }
 			    },
 			    btnDept: {
 			        text: '부서',
 			        click: function() {
 			            filterCalendarEvents("부서"); // 함수에게 "부서"를 전달!
 			        }
 			    },
 			    btnPersonal: {
 			        text: '개인',
 			        click: function() {
 			            filterCalendarEvents("개인"); // 함수에게 "개인"를 전달!
 			        }
 			    }
 			},
 			
			events: ${eventList},
        	initialView: 'dayGridMonth', 
            height: '100%', // 부모 div 높이에 맞춤
            displayEventTime: false,
            locale: 'ko'
        });
        //날짜 클릭시 클릭한 날짜와 함께 
        
        calendar.render();
        
        //함수 정의
        function filterCalendarEvents(type) {
            var allEvents = calendar.getEvents(); // 달력의 모든 일정 가져오기
            
            allEvents.forEach(function(event) {
                // DB의 plan_type 컬럼값 (extendedProps에서 꺼내옴)
                var eventType = event.extendedProps.planType; 
               
                if (eventType === type) {
                    event.setProp('display', 'auto'); // 일치하면 화면에 표시
                } else {
                    event.setProp('display', 'none'); // 다르면 화면에서 숨김
                }
            });
        }
    });

// $(document).ready(function() {
//             // 1. 요소 선택 (jQuery 문법 사용 가능)
//             var calendarEl = $('#calendar')[0]; 
        
//             // 2. FullCalendar 초기화 (기존 방식 유지)
//             var calendar = new FullCalendar.Calendar(calendarEl, {
//                 slotMinTime: '09:00',
//                 slotMaxTime: '19:00',
                
//                 headerToolbar: {
//                     left: 'prev,next today',
//                     center: 'title',
//                     right: 'dayGridMonth,timeGridWeek,timeGridDay' // 이 부분이 버튼을 생성합니다
//                   },
                  
//                  selectable: true,
                 
//                 events: ${eventList},
//                 initialView: 'dayGridMonth', 
//                 height: '100%' // 부모 div 높이에 맞춤
//             });
//             calendar.render();
// });

</script>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>