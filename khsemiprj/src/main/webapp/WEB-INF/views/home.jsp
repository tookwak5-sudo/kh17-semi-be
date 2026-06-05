<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
    
    .lightpick {
    z-index: 20000 !important;
	}
	
    .p-20 { padding: 20px; }
    
    .calendarModal {
    	display: none;
    	position: fixed;
    	top: 50%;
    	left: 50%;
    	transform: translate(-50%, -50%);
    	width: 600px;
    	background: white;
    	padding: 20px;
    	border: 1px solid #ccc; 
    	box-shadow: 0px 4px 10px rgba(0,0,0,0.2); 
    	z-index: 10000;
    }
    .calendarDetailModal {
    	display: none;
    	position: fixed;
    	top: 50%;
    	left: 50%;
    	transform: translate(-50%, -50%);
    	width: 600px;
    	background: white;
    	padding: 20px;
    	border: 1px solid #ccc; 
    	box-shadow: 0px 4px 10px rgba(0,0,0,0.2); 
    	z-index: 10000;
    }
</style>


<script type="text/template" id="write-template">
<div class="calendarModal">
	<div class="flex-area flex-center mb-10">
	        <h3 class= "mt-50">일정 등록</h3>
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
</script>

<script type="text/template" id="detail-template">
<div class="calendarDetailModal" class="container w-600 mt-50">
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
</script>

<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/index.global.min.js'></script>
<!-- <script src='https://cdn.jsdelivr.net/npm/@fullcalendar/core@6.1.20/index.global.min.js'></script> -->

<!-- 	   		planwrite들어가는 자리		 -->
		<div id="modal-body"></div>

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
			
	    	var currentPlanType = "회사"
	    	
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
	        	
	        select: function(info) { // select : 날짜 시간을 선택할 때 사용
	            // 1. 템플릿을 가져와 모달에 주입
	            var template = $("#write-template").text();
	            $("#modal-body").html(template);
	            
	            // 2. 날짜 자동 입력 (info.startStr은 YYYY-MM-DD형식)
	            var $startDate = $("#modal-body [name=planSdate]");
	            var $endDate = $("#modal-body [name=planEdate]");
	            
	            $startDate.val(info.startStr);
	            // 종료일 보정 (FullCalendar의 end는 익일이므로 하루 차감)
	            var end = new Date(info.endStr);
	            end.setDate(end.getDate() - 1);
	            $endDate.val(end.toISOString().substring(0, 10));
	            
	            //3. 모달 표시
	            $(".calendarModal").show();
	            
	            //4. 모달 내부의 input에 Lightpick 다시 적용
	            new Lightpick({
	            	field: $startDate[0],
	                secondField: $endDate[0],
	                singleDate: false,
	                format: "YYYY-MM-DD",
	                firstDay: 7,
	                numberOfMonths: 2,
	                numberOfColumns: 2,
	                selectForward: true,
	                minDays: 1
	            })
            },
            
            eventClick: function(info) { // evnetClick은 click이벤트 때 사용
            	var planNo = info.event.extendedProps.planNo; 
                
            	// 1. 상세조회 템플릿을 불러와 #modal-boday에 주입
            	var detailTemplate = $("#detail-template").html();
            	$("#modal-body").html(detailTemplate);
            
                fetch("/getDetailJson?planNo=" + planNo)
                    .then(response => response.json())
                    .then(planDto => {
                    	
                    	// 2. 클래스로 선택하여 보여줌
                    	$(".calendarDetailModal").show(); 
                    	
                       // document.getElementById('calendarDetailModal').style.display = 'block';
                        
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
			$(".calendarModal").hide();
			$("#modal-body").empty();
    }
    function closeDetailModal() {
    	$(".calendarDetailModal").hide();
    	$("#modal-body").empty();
    }
</script>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>