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
	width: 1400px;
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
.list-area{
		height:190px;
	    overflow-y:auto;
}
	
.list-area thead th{
   position: sticky;
   top: 0;
   background: white;
   z-index: 10;
}

/* 일요일 날짜 텍스트 색상 변경 */
    .fc .fc-day-sun a {
        color: #ff4d4d !important; /* 빨간색 계열 */
    }

    /* 토요일 날짜 텍스트 색상 변경 */
    .fc .fc-day-sat a {
        color: #739BED !important; /* 파란색 계열 */
    }
    
    /* 혹시 헤더(월,화,수...)의 글씨 색도 바꾸고 싶다면 */
    .fc-col-header-cell.fc-day-sun {
        color: #ff4d4d;
    }
    .fc-col-header-cell.fc-day-sat {
        color: #739BED;
    }
    
   /* 모든 날짜 영역의 투명도를 1로 강제 고정 */
	.fc .fc-daygrid-day, 
	.fc .fc-daygrid-day-frame, 
	.fc .fc-daygrid-day-top, 
	.fc .fc-popover,
	.fc-day-other, 
	.fc-day-sun, 
	.fc-day-sat {
	    opacity: 1 !important;
	}
	/* 1. 팝업 박스(Popover) 전체를 선명하게 */
	.fc .fc-popover {
	    opacity: 1 !important;
	    background-color: #ffffff !important; /* 배경을 흰색으로 고정 */
	    border: 1px solid #ddd !important;
	    box-shadow: 0 4px 10px rgba(0,0,0,0.2) !important;
	}

	/* 2. 팝업 박스 안의 날짜 및 일정 텍스트 선명하게 */
	.fc .fc-popover .fc-daygrid-day-number,
	.fc .fc-popover .fc-daygrid-event {
	    opacity: 1 !important;
	    color: #333 !important; /* 글자색을 진하게 */
	}
	
	/* 3. 혹시 모를 내부 요소의 투명도 제거 */
	.fc .fc-popover .fc-daygrid-event-harness {
	    opacity: 1 !important;
	}
</style>

<!-- fullcalendar cdn -->
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/index.global.min.js'></script>
<!-- <script src='https://cdn.jsdelivr.net/npm/@fullcalendar/core@6.1.20/index.global.min.js'></script> -->

<script type="text/template" id="write-template">
<div class="calendarModal">
	<div class="flex-area flex-center mb-10 w-100">
		<h1 class= "mt-40 flex-fill ms-20">일정 등록</h1>
	    <button class="me-20 red" type="button" onclick="closeCalendarModal()" style="cursor: pointer; background: none; border: none; font-size: 18px;">
    		<i class="fa-solid fa-x"></i>
		</button>
	</div>
		<div class="container w-500 mt-50">
			<div class="cell">
	        	<label>일정명</label>
	        	<input type="text" name="planName" class="field w-100">
				<div class="fail-feedback w-100">
                   <div>필수 입력 창 입니다</div>
            	</div>
	        </div>
			<input type="hidden" name="planDeptNo" value="${deptNo}" class="field w-100">
	        <div class="cell">
	        	<label>유형</label>
	        	<select class="field w-100" name="planType">
	                <option value="">선택하세요</option>
	                <option value="개인">개인</option>
					<option value="부서">부서</option>
					<option value="회사">회사</option>
	            </select>
				<div class="fail-feedback w-100">
                   <div>필수 입력 창 입니다</div>
            	</div>
	        </div>
			<div class="cell">
	        	<label>종류(헤더)</label>
	        	<select class="field w-100" name="headNo">
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
	            <textarea name="planExplain" class="field w-100"></textarea>
	        </div>
	        <div class="cell mt-40 right">
	            <button type="submit" class="btn btn-positive btn-plan">
	                <i class="fa-solid fa-plus"></i>등록하기
	            </button>
	       </div>
    	</div>
</div>
</script>

<script type="text/template" id="detail-template">
<div class="calendarModal" class="container w-600 mt-50">
    <div class="flex-area flex-center mb-10">
	        <h1 class= "mt-40 flex-fill ms-20">일정 상세</h1>
	        	<button class="me-20 red" type="button" onclick="closeCalendarModal()" style="cursor: pointer; background: none; border: none; font-size: 18px;">
    		<i class="fa-solid fa-x"></i>
		</button>
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

<script type="text/template" id="edit-template">
<div class="calendarModal">
	<div class="flex-area flex-center mb-10">
	        <h1 class= "mt-40 flex-fill ms-20">일정 수정</h1>
	        	<button class="me-20 red" type="button" onclick="closeCalendarModal()" style="cursor: pointer; background: none; border: none; font-size: 18px;">
    		<i class="fa-solid fa-x"></i>
		</button>
	</div>
		<div class="container w-500 mt-50">
			<div class="cell">
	        	<label>일정명</label>
	        	<input type="text" name="planName" class="field w-100">
	        </div>
	        <div class="cell">
	        	<label>유형</label>
	        	<div class="cell">
	        	<label>유형</label>
	        	<select class="field w-100" name="planType">
	                <option value="">선택하세요</option>
	                <option value="개인">개인</option>
					<option value="부서">부서</option>
					<option value="회사">회사</option>
	            </select>
	        </div>
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
	            <button type="submit" class="btn btn-positive btn-plan-edit">
	                수정하기
	            </button>
	       </div>
    	</div>
</div>
</script>

<script type="text/javascript">
	$(function(){
	
	});
</script>

<script type="text/javascript">
	$(function(){
		//상태객체
        var state = {
            planNameValid : false,
            planTypeValid : false,
            planHeadNoValid : true,
            planSdateValid : true,
            planEdateValid : true,
            planExplainValid : true, // 선택항목
            ok : function() {
                return Object.values(this)//이 객체의 모든 이름에 대한 값을 반환해라
                .filter(v => typeof v == "boolean") // boolean값만 추출해서
                .every(v => v === true); //모두 true인지 확인해서 반환해라;
            }
        };
		
    	 // 항목검사 통합 함수
        $(document).on("blur input", "[name=planName]", function () {
            var $input = $(this);
            var val = $input.val();
            
            // 값이 비어있는지 확인 (select의 경우 value가 ""이면 비어있는 것)
            var valid = val !== null && val.trim().length > 0;
            
            // 상태 객체 업데이트
            if($input.attr("name") === "planName") state.planNameValid = valid;
            
            // 클래스 및 데이터 속성 처리
            if(!valid) {
                $input.addClass("fail").attr("data-error", "1");
            } else {
                $input.removeClass("fail").removeAttr("data-error");
            }
        });
        $(document).on("blur input", "[name=planType]", function () {
            var $input = $(this);
            var val = $input.val();
            
            // 값이 비어있는지 확인 (select의 경우 value가 ""이면 비어있는 것)
            var valid = val !== null && val.trim().length > 0;
            
            // 상태 객체 업데이트
            if($input.attr("name") === "planType") state.planTypeValid = valid;
            
            // 클래스 및 데이터 속성 처리
            if(!valid) {
                $input.addClass("fail").attr("data-error", "1");
            } else {
                $input.removeClass("fail").removeAttr("data-error");
            }
        });
		 
		//등록 버튼을 누르면 발생하는 등록 작업
		$(document).on("click",".btn-plan", function(){
			
			// 모든 .field에 대해 검사
		    $(".field").trigger("blur").trigger("input");
		    
		    if(!state.ok()) {
		        alert("입력 오류를 확인하세요.");
		        return;
		    }
			//var planDeptNo = $("[name=planType]").val() == '부서' ? $("[name=planDeptNo]").val() : '';
			var planDeptNo = $("[name=planDeptNo]").val();
			
			var data = {// 입력된 값들의 name값을 가져와서 data에 입력 
				planType : $("[name=planType]").val(),
				planHeadNo : $("[name=planHeadNo]").val(),
				planName : $("[name=planName]").val(),
				planSdate : $("[name=planSdate]").val(),
				planEdate : $("[name=planEdate]").val(),
				planExplain : $("[name=planExplain]").val(),
				planDeptNo :  $("[name=planDeptNo]").val(),
			};
			
			//console.log(data);
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
		
	  //목표 : 수정버튼을 누르면 수정화면을 보여주도록 처리
		$(document).on("click", "#modalEditBtn", function(){//영역 감시
// 			기존 reply-viewer의 정보를 불러온다
			var planNo = $(this).data("key");
			var planTitle = $(this).data("plan-title");
		    var planType = $(this).data("plan-type");
		    var planSdate = $(this).data("plan-sdate");
		    var planEdate = $(this).data("plan-edate");
		    var planExplain = $(this).data("plan-explain");
		    var planHeadNo = $(this).data("plan-head_no");
			
// 			현재 수정하려는 수정 화면에 대한 처리		

			// 수정 화면 가져오기
			var template = $("#edit-template").text();
            $("#modal-body").html(template);
			$("#modal-body").find("[name=planName]").val(planTitle);
			$("#modal-body").find("[name=planType]").val(planType);
			$("#modal-body").find("[name=planHead_no]").val(planHeadNo);
		    $("#modal-body").find("[name=planSdate]").val(planSdate);
		    $("#modal-body").find("[name=planEdate]").val(planEdate);
		    $("#modal-body").find("[name=planExplain]").val(planExplain);
			
		    //수정 눌렀을때 고유키 심어주기
		    $("#modal-body").find(".btn-plan-edit").data("key", planNo);
			
		    var headList = JSON.parse('${planHeadJson}');
            var options = "";
            for(var i = 0; i < headList.length; i++) {
        		options += "<option value='" + headList[i].headNo + "'>" + headList[i].headName + "</option>";
            }
            //가져온 option을 헤더 select 아래에 append 
            $("select[name='planHeadNo']").empty().append(options);
		    
		    $(".calendarModal").show();
		});
		
		//목표 : 수정완료버튼을 누르면 ajax통신을 이용해 수정요청을 한 뒤 목록 갱신
		$(document).on("click", ".btn-plan-edit", function(){
			var planNo = $(this).data("key");
			
			var data = {
			        planNo : planNo, // 어떤 일정을 수정할지 알아야 하므로 무조건 필수!
			        planName : $("#modal-body [name=planName]").val(),
			        planType : $("#modal-body [name=planType]").val(),
			        planHeader : $("#modal-body [name=planHeadNo]").val(),
			        planSdate : $("#modal-body [name=planSdate]").val(),
			        planEdate : $("#modal-body [name=planEdate]").val(),
			        planExplain : $("#modal-body [name=planExplain]").val()
			    };
			
			$.ajax({
				url:"/rest/plan/edit",
				method:"post",
				data: data,
				success: function(response){
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
			
	    	//var currentPlanType = "회사"
	    	
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
	        	
	            dayMaxEvents: 1, 

	            selectable: true,
	       		select: function(info) { // select : 날짜 시간을 선택할 때 사용
	       			
	            // 1. 템플릿을 가져와 모달에 주입
	            var template = $("#write-template").text();
	            $("#modal-body").html(template);
	            
	            // 부서 번호 넣기
	            var headList = JSON.parse('${planHeadJson}');
	            var options = "<option value=''>선택하세요</option>";
	            for(var i = 0; i < headList.length; i++) {
            		options += "<option value='" + headList[i].headNo + "'>" + headList[i].headName + "</option>";
	            }
	            //가져온 option을 헤더 select 아래에 append 
	            $("select[name='headNo']").empty().append(options);
	            
	            
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
                var planHeadNo = info.event.extendedProps.planHeadNo;
                
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
            	 // 2. 로그인 아이디
            	var data = info.event.extendedProps;
	            var loginId = "${loginId}";
	            
	            // 4. 작성자와 로그인 아이디를 비교하여 버튼 제어
	            if(data.planEmpId === loginId) {
	            	$("#modalEditBtn").show();
	            	$("#modalDeleteBtn").show();
	            }
	            else {
	            	$("#modalEditBtn").hide();
	            	$("#modalDeleteBtn").hide();
	            }
	            
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
                $("#modalEditBtn").data("plan-head-no", planHeadNo);
            	
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
            <c:if test="${sessionScope.empGrade == 1 || sessionScope.empGrade == 2}">
            	<div style="display: flex; justify-content: space-between; align-items: center;">
                    <h3>결재 대기 목록</h3>
                    <a href="/aprv/list">
                    	<span><i class="fa-solid fa-list black"></i></span>
                    </a>     
                </div>
                <div class="cell list-area">
                 	<table class="table">
                  		<thead>
			               <tr> 
			                   <th>결재 제목</th> 
			                   <th>기안자</th> 
			                   <th>결재 상태</th> 
			               </tr> 
		  				</thead>
			  			<tbody>
							<!--리스트가 비어있지 않을때 -->
			  				<c:if test="${not emptyReceivedList}">
				  				<c:forEach var="rAprvList" items="${receivedAprvList}">
					  				<tr>
					  					<td>
							                <a href="/aprv/detail?aprvNo=${rAprvList.aprvNo}">
							                	${rAprvList.aprvTitle}
							                </a>
			                            </td>
					  					<td>${rAprvList.empName}</td>
					  					<td>${rAprvList.aprvStatus}</td>
					  				</tr>
				  				</c:forEach>
			  				</c:if>
							<!--리스트가 비어있을때 -->
			  				<c:if test="${emptyReceivedList}">
			  					<tr>
			  						<td colspan="3" style="text-align: center; color: #888; padding: 30px 0;">
                    					결재 대기 중인 문서가 없습니다.
                					</td>
			  					</tr>
			  				</c:if>
			  			</tbody>
                 	</table>
                </div>
            </c:if>
            <c:if test="${sessionScope.empGrade == 0}">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <h3>내 결재목록</h3>
                    <a href="/aprv/list">
                    	<span><i class="fa-solid fa-list black"></i></span>
                    </a>   
                </div>
                <div class="cell list-area">
                 	<table class="table">
                  		<thead>
			               <tr> 
			                   <th>결재 제목</th> 
			                   <th>작성자</th> 
			                   <th>결재 상태</th> 
			               </tr> 
		  				</thead>
			  			<tbody>
							<!--내가쓴 결재가 있을때 -->
				  			<c:if test="${not emptyMyList}">
				  				<c:forEach var="myList" items="${myAprvList}">
					  				<tr>
					  					<td>
							                <a href="/aprv/detail?aprvNo=${myList.aprvNo}">
							                	${myList.aprvTitle}
							                </a>
			                            </td>
					  					<td>${myList.empName}</td>
					  					<td>${myList.aprvStatus}</td>
					  				</tr>
				  				</c:forEach>
				  			</c:if>
				  			<!--리스트가 비어있을때 -->
			  				<c:if test="${emptyMyList}">
			  					<tr>
			  						<td colspan="3" style="text-align: center; color: #888; padding: 30px 0;">
                    					상신한 결재 문서가 없습니다.
                					</td>
			  					</tr>
			  				</c:if>
			  			</tbody>
                 	</table>
                </div>
            </c:if>
			</div>
	           	<div class="card p-20" style="height: 300px; overflow-y: auto;">
		            <h3>공지사항</h3>
		            <hr>
		            <c:forEach var="notice" items="${noticeList}">
		                <div
		                    style="margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px;">
		                    <a href="/board/detail?boardNo=${notice.boardNo}" style="text-decoration: none; color: black;">
		                    ${notice.boardTitle}
		                </a>
		                    <p style="color: #999; font-size: 12px;">작성자:
		                        ${notice.boardWriter}</p>
		                </div>
		            </c:forEach>
		
		            <c:if test="${empty noticeList}">
		                <div>등록된 공지사항이 없습니다.</div>
		            </c:if>
	       		</div>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp" />

