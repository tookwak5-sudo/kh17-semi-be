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
    
    .
</style>

<script type="text/javascript">
      $(function(){
              var picker8 = new Lightpick({
              field: $(".picker-8-1")[0],
              secondField : $(".picker-8-2")[0],
              singleDate : false, //범위선택으로 변경
              format : "YYYY-MM-DD",
              firstDay : 7 ,
              numberOfMonths : 2, //2달 표시한다
              numberOfColumns : 2, //한 줄에 2칸 표시
              selectForward : true, //최초 선택날짜 이후로만 선택가능
              minDays : 1, //최소 선택기간(일)
              //maxDays : 8, //최대 선택기간(일)
          });
      });
</script>

<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/index.global.min.js'></script>
<!-- <script src='https://cdn.jsdelivr.net/npm/@fullcalendar/core@6.1.20/index.global.min.js'></script> -->
<div class="dashboard-container">
	<div id="calendarModal" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 600px; background: white; padding: 20px; border: 1px solid #ccc; box-shadow: 0px 4px 10px rgba(0,0,0,0.2); z-index: 10000;">
		    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
		        <h3>일정 등록</h3>
		        <button type="button" onclick="closeCalendarModal()" style="cursor: pointer; background: none; border: none; font-size: 18px;">&times;</button>
		    </div>
		<form action="./write" autocomplete="off" method="post" class="form-check">
			<div class="container w-500 mt-50">
				
		        <div class="cell">
		        	<label>유형</label>
		        	<select class="field w-100" name="planType">
		                <option value="">선택하세요</option>
		                <c:forEach var="planDto" items="${list}">
		                <option value="${planDto.planNo}">${planDto.planType}</option>
		                </c:forEach>
		            </select>
		        </div>
		        <div class="cell">
		        	<label>일정명</label>
		        	<input type="text" name="planName" class="field w-100">
		        </div>
		        <div class="cell">
		            <label>일정 <i class="fa-solid fa-asterisk red"></i></label>
		        </div>
		        <div class="cell flex-area" style="align-items: center;">
		            <input type="text" name="planSdate" class="field w-100 picker-8-1">
		                <i class="fa-solid fa-minus ms-10 me-10"></i>
		            <input type="text" name="planEdate" class="field w-100 picker-8-2">
		        </div>
		        
		         <div class="cell">
		            <label>내용</label>
		            <textarea name="planExplain" class="field w-100" rows="5"></textarea>
		        </div>
		        <div class="cell mt-40 right">
		            <button class="btn btn-positive">
		                등록하기
		            </button>
		        </div>
		    </div>
		</form>
	</div>
	
	<div id="calendarDetailModal" class="container w-600 mt-50" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); z-index: 999; background: white;">
    <h2 class="mb-30">일정 상세 조회</h2>

    <div class="card p-20 mb-30" style="border: 1px solid #ddd; border-radius: 8px;">
        <div class="cell">
            <h1 class="mb-10">
                <span id="detailType"></span>
                <span id="detailTitle"></span>
            </h1>
            <p class="text-muted">
                <strong>기간:</strong> 
              	(<span id="detailSdate"></span> 
              	~ 
               	<span id="detailEdate"></span>)
            </p>
        </div>
        <div class="cell" id="detailExplain">
        	
        </div>
    </div>

    <div class="cell text-right">
        <a href="#" id="modalEditBtn" class="btn btn-positive">수정하기</a>
        <a href="#" id="modalDeleteBtn" class="btn btn-negative" 
           onclick="return confirm('정말 삭제하시겠습니까?');">삭제하기</a>
        <button type="button" onclick="closeDetailModal()" class="btn btn-netural">닫기</button>
    </div>
</div>
	
	
	
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
    	
    	var currentPlanType = "회사";
    	
        var calendarEl = document.getElementById('calendar');
        var calendar = new FullCalendar.Calendar(calendarEl, {
           
        	slotMinTime: '09:00',
        	slotMaxTime: '19:00',
        	
        	headerToolbar: {
        	    left: 'prev,next today',
        	    center: 'title', 
        	    right: 'btnAll,btnDept,btnPersonal' 
        	},
        	
        	selectable: true,
        	
        	select: function(info) {
                // info.startStr에는 클릭한 날짜(예: "2026-06-05")가 들어있습니다.
//                 console.log('선택된 날짜: ' + info.startStr);
                
                // 팝업창 띄우기
                var modal = document.getElementById('calendarModal');
                if (modal) {
                    modal.style.display = 'block'; // none에서 block으로 변경하여 표시
                }
                
                /* (선택사항) 팝업창 안의 날짜 입력란에 클릭한 날짜를 자동으로 넣어주고 싶다면?
                  document.getElementById('planSdate').value = info.startStr;
                */
            },
            
            eventClick: function(info) {
            	var planNo = info.event.extendedProps.planNo; 
                
                fetch("/getDetailJson?planNo=" + planNo)
                    .then(response => response.json())
                    .then(planDto => {
                        document.getElementById('calendarDetailModal').style.display = 'block';
                        
                        document.getElementById('detailTitle').innerText = planDto.planName;
                        document.getElementById('detailType').innerText = planDto.planType;
                        
                        // ★ 시작일과 종료일을 각각 매핑 (필드명은 Dto와 일치시켜주세요)
                        document.getElementById('detailSdate').innerText = planDto.planSdate; 
                        document.getElementById('detailEdate').innerText = planDto.planEdate; 
                        
                        document.getElementById('detailExplain').innerText = planDto.planExplain || "등록된 내용이 없습니다.";
                    })
                    .catch(error => {
                        alert("일정 정보를 가져오는 데 실패했습니다.");
                    });
            },
            
 			customButtons: {
 			    btnAll: {
 			        text: '회사',
 			        click: function() {
 			        	currentPlanType = "회사";
 			            filterCalendarEvents("회사"); // 함수에게 "전체"를 전달!
 			        }
 			    },
 			    btnDept: {
 			        text: '부서',
 			        click: function() {
 			        	currentPlanType = "부서";
 			            filterCalendarEvents("부서"); // 함수에게 "부서"를 전달!
 			        }
 			    },
 			    btnPersonal: {
 			        text: '개인',
 			        click: function() {
 			        	currentPlanType = "개인";
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
        //처음 로드 될때 회사 디폴트
        filterCalendarEvents("회사");
        
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
    
    function closeCalendarModal() {
        var modal = document.getElementById('calendarModal');
        if (modal) {
            modal.style.display = 'none';
        }
    } 

    function closeDetailModal() {
        var detailModal = document.getElementById('calendarDetailModal');
        if (detailModal) {
            detailModal.style.display = 'none'; 
        }
    }
    
</script>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>