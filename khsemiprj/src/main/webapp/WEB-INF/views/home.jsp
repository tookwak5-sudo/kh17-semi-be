<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp" />

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

.p-20 {
	padding: 20px;
}

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
	box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
	z-index: 10000;
}
</style>

<!-- fullcalendar cdn -->
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/index.global.min.js'></script>
<!-- <script src='https://cdn.jsdelivr.net/npm/@fullcalendar/core@6.1.20/index.global.min.js'></script> -->

<script type="text/template" id="write-template">
<div class="calendarModal">
	<div class="flex-area flex-center mb-10">
	        <h3 class= "mt-50">일정 등록</h3>
	        <button type="button" onclick="closeCalendarModal()" style="cursor: pointer; background: none; border: none; font-size: 18px;">&times;</button>
	</div>
		<div class="container w-500 mt-50">
			<div class="cell">
	        	<label>일정명</label>
	        	<input type="text" name="planName" class="field w-100">
	        </div>
	        <div class="cell">
	        	<label>유형</label>
	        	<select class="field w-100" name="planType">
	                <option value="">선택하세요</option>
	                <option value="개인">개인</option>
					<option value="부서">부서</option>
					<option value="회사">회사</option>
	            </select>
	        </div>
			<div class="cell">
	        	<label>종류(헤더)</label>
	        	<select class="field w-100" name="planHeadNo">
	                <option value="">선택하세요</option>
	            </select>
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
	            <button type="submit" class="btn btn-positive btn-plan">
	                등록하기
	            </button>
	       </div>
    	</div>
</div>
</script>

<script type="text/template" id="detail-template">
<div class="calendarModal" class="container w-600 mt-50">
    <div class="flex-area flex-center mb-10">
	        <h3 class= "mt-50">일정 상세</h3>
	        <button type="button" onclick="closeCalendarModal()" style="cursor: pointer; background: none; border: none; font-size: 18px;">&times;</button>
	</div>

    <div class="container w-500 mt-50">
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
        <a href="#" id="modalDeleteBtn" class="btn btn-negative">삭제하기</a>
    </div>
</div>
</script>

<script type="text/javascript">
	$(function(){
		
// 		//상태객체
//         var state = {
//             planNameValid : false,
//             planTypeValid : false,
//             planHeadNoValid : true,
//             planSdateValid : true,
//             planEdateValid : true,
//             planExplainValid : true, // 선택항목
//             ok : function() {
//                 return Object.values(this)//이 객체의 모든 이름에 대한 값을 반환해라
//                 .filter(v => typeof v == "boolean") // boolean값만 추출해서
//                 .every(v => v === true); //모두 true인지 확인해서 반환해라;
//             }
//         };
		//등록 버튼을 누르면 발생하는 등록 작업
		$(document).on("click",".btn-plan", function(){
			var data = {// 입력된 값들의 name값을 가져와서 data에 입력 
				planType : $("[name=planType]").val(),
				planHeadNo : $("[name=planHeadNo]").val(),
				planName : $("[name=planName]").val(),
				planSdate : $("[name=planSdate]").val(),
				planEdate : $("[name=planEdate]").val(),
				planExplain : $("[name=planExplain]").val()
			};
			
			console.log(data);
			// 제목, 종류, 일정이 빈값이면 return (다른 건 입력값이 없어도 허용)
// 			var check = data.planName.length == 0 || planType.length == 0 || planSdate.length == 0 || planEdate.length == 0;
// 			if(check) return;
			
			//[1]결재문서
			//planType(개인, 부서, 회사)이 부서이고, planAprvNo가 null이 아닌 경우
			
			//[2]결재문서가 아닌 경우 planAprvNo가 null인 경우
			$.ajax({
				url: "/rest/plan/write",
				method: "post",
				data: data,
				success : function(response) {
					closeCalendarModal();
					//홈 화면 새로고침
					location.reload();
				}
			});
		});
	
	
		//삭제 버튼 클릭시
	    $(document).on("click", "#modalDeleteBtn", function(){
	        var choice = window.confirm("정말 삭제하시겠습니까?");
	        if(choice == false) return;
	
	        //댓글 영역 최상단에 data-key라는 이름으로 작성된 번호를 가져온다
	        var planNo = $(this).data("key");
	
	        $.ajax({
	            url: "/rest/plan/delete",
	            method: "post",
	            data: { planNo : planNo },
	            success: function(response){
	                alert("삭제되었습니다.");
	                closeCalendarModal();
	                //홈 화면 새로고침
	                location.reload();
	            }
	        });
	    });
	
	});
</script>

<script type="text/javascript">
	    document.addEventListener('DOMContentLoaded', function() {
			
	    	var currentPlanType = "회사"
	    	
	        var calendarEl = document.getElementById('calendar');
	        var calendar = new FullCalendar.Calendar(calendarEl, {
	        	slotMinTime: '09:00',
	        	slotMaxTime: '19:00',
	        	slotDuration: '02:00:00',
	        	
	        	headerToolbar: {
	        	    left: 'prev,next today',
	        	    center: 'title', 
	        	    right: 'btnAll,btnDept,btnPersonal' 
	        	},
	        	
	        	
	            dayMaxEvents: 3, 

	            selectable: true,
	       		select: function(info) { // select : 날짜 시간을 선택할 때 사용
	            // 1. 템플릿을 가져와 모달에 주입
	            var template = $("#write-template").text();
	            $("#modal-body").html(template);
	            
	            var headList = ${planHeadJson};
	            var options = "";
	            for(var i = 0; i < headList.length; i++) {
            		options = "<option value='" + headList.planNo + "'>" + headList.plan + "</option>";
	            }
	            
	            //가져온 option을 헤더 select 아래에 append 
	            
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
            
            eventClick: function(info) { // evnetClick은 click이벤트 때 사용 : 상세
            	var planNo = info.event.extendedProps.planNo;
                var planExplain = info.event.extendedProps.planExplain;
                var planTitle = info.event.title;
                var planSdate = info.event.start;
                var planEdate = info.event.end;
                var planType = info.event.extendedProps.planType;
                
                var sdateObj = new Date(planSdate);
                var edateObj = new Date(planEdate);
                
                var sYear = sdateObj.getFullYear();
                var sMonth = sdateObj.getMonth()+1;
                var sDay = sdateObj.getDate();
                
                if(sMonth < 10) sMonth = '0'+ sMonth;
                if(sDay < 10) sDay = '0'+ sDay;
                
                var sResult = sYear + '-' + sMonth + '-' + sDay;
                           
                var eYear = edateObj.getFullYear();
                var eMonth = edateObj.getMonth()+1;
                var eDay = edateObj.getDate();
                
                if(eMonth < 10) eMonth = '0'+ eMonth;
                if(eDay < 10) eDay = '0'+ eDay;
                
                var eResult = eYear + '-' + eMonth + '-' + eDay;
                
                
            	// 1. 상세조회 템플릿을 불러와 #modal-boday에 주입
            	var detailTemplate = $("#detail-template").html();
            	$("#modal-body").html(detailTemplate);
            	
            	// 상세 모달이 열릴때 삭제 버튼을 찾아 data-key에 planNo를 심어줌
                $("#modal-body").find("#modalDeleteBtn").data("key", planNo);
                // 상세 모달이 열릴때 수정 버튼을 찾아 data-key에 planNo를 심어줌
                $("#modal-body").find("#modalEditBtn").data("key", planNo);
                // 상세 모달이 열릴때 상세 값들을 수정 버튼에 심어줌
                $("#modalEditBtn").data("plan-title", planTitle);
                $("#modalEditBtn").data("plan-type", planType);
                $("#modalEditBtn").data("plan-sdate", sResult);
                $("#modalEditBtn").data("plan-edate", eResult);
                $("#modalEditBtn").data("plan-explain", planExplain);
            	
            	document.getElementById('detailTitle').innerText = planTitle;
                document.getElementById('detailType').innerText = planType;
                
                // ★ 시작일과 종료일을 각각 매핑 (필드명은 Dto와 일치시켜주세요)
                document.getElementById('detailSdate').innerText = sResult; 
                document.getElementById('detailEdate').innerText = eResult; 
                document.getElementById('detailExplain').innerText = planExplain || "등록된 내용이 없습니다.";
                
             	// 2. 클래스로 선택하여 보여줌
            	$(".calendarModal").show(); 
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
		
        document.addEventListener('click', function(e) {
            // 클릭된 요소가 '+더보기' 링크인지 확인
            if (e.target.matches('.fc-daygrid-more-link')) {
                e.preventDefault(); // 기본 줌인 동작 방지
                
                // 클릭한 날짜 정보 가져오기 (가까운 날짜 셀에서 data-date 속성 추출)
                var dateStr = e.target.closest('.fc-daygrid-day').getAttribute('data-date');
                // 여기에 모달을 띄우는 로직(예: openCalendarModal) 호출
                // 또는 상세 조회 화면을 모달로 보여주는 로직 실행
            }
        });
        
        //함수 정의
        function filterCalendarEvents(type) {
            var allEvents = calendar.getEvents(); // 달력의 모든 일정 가져오기
            console.log("▶ [내가 클릭한 버튼 타입]:", type);
            // 2. 전체 가져온 일정 개수가 몇 개인지 확인
            console.log("▶ [달력이 불러온 총 일정 개수]:", allEvents.length, "개");
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
</script>

<!-- 	   		planWrite, planDetail들어가는 자리		 -->
<div id="modal-body"></div>

<!--  결재, 공지 보여주는 화면 -->
<div class="dashboard-container">
	<div class="left-section">
		<div id='calendar' class="card p-20" style="min-height: 620px;"></div>
	</div>

	<div class="right-section">
		<div class="card p-20" style="height: 300px;">
			<div
				style="display: flex; justify-content: space-between; align-items: center;">
				<h3>결재사항</h3>
				<a href="#">더보기</a>
			</div>
		</div>

		<div class="card p-20" style="height: 300px; overflow-y: auto;">


			<h3>공지사항</h3>
			<hr>
			<c:forEach var="notice" items="${noticeList}">
				<div
					style="margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px;">
					<a href="/board/detail?boardNo=${notice.boardNo}"
						style="text-decoration: none; color: black;">
						${notice.boardTitle} </a>


					<p style="color: #999; font-size: 12px;">작성자:
						${notice.boardWriter}</p>
				</div>
			</c:forEach>

			<c:if test="${empty noticeList}">
				<div>등록된 공지사항이 없습니다.</div>
			</c:if>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/template/footer.jsp" />