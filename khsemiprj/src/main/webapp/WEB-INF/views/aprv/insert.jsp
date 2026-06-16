<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<!-- 결재 디자인 css -->
<link rel="stylesheet" type="text/css" href="/css/aprv/insert.css">
<!-- 부서 목록 디자인 css -->
<link rel="stylesheet" type="text/css" href="/css/dept/list.css">
<script>
const deptList = JSON.parse('${deptListJson}');

// 유효성 검사 상태 객체
var state = {
	aprvTitleValid: false,
	aprvContentValid: false,
	aprvSdateValid: false,
	aprvEdateValid: false,
	aprvLineNo1Valid: false,
	aprvLineNo2Valid: false,
	ok: function(){
		return Object.values(this)
		.filter(v => typeof v==="boolean")
		.every(v => v === true);
	}
};

// 평일(주말 제외) 일수 계산 함수 (호이스팅을 위해 상단 정의 또는 바깥 배치)
function getWeekdaysCount(startDate, endDate) {
	let count = 0;
	let current = startDate.clone(); 
	
	while (current.isSameOrBefore(endDate, 'day')) {
		let dayOfWeek = current.day(); 
		if (dayOfWeek !== 0 && dayOfWeek !== 6) {
			count++;
		}
		current.add(1, 'day');
	}
	return count;
}

$(function () {
	var formNo = '${param.formNo}';
	getAprmFormAttach(formNo);
	var formName = $(".aprv-form-list option:selected").attr("data-name");
	var formHead = $(".aprv-form-list option:selected").attr("data-head");
	
	switch(formHead) {
		case "연차":
		case "병가":
		case "기타":
		default:
			if(formHead == "연차") $(".date-title").text("기한 [잔여휴가일수 : ${leaveRemain}일]");
			else $(".date-title").text("기한");
			$(".timeTilde").show();
			$(".picker-edate").show();
			var picker1 = new Lightpick({ 
			    field : $(".picker-sdate")[0],
				secondField : $(".picker-edate")[0],
				singleDate : true,
			    format : "YYYY-MM-DD",
				firstDay : 7,
				disableWeekends: true,
			    onOpen: function() {
			        const calendarEl = document.querySelector('.lightpick__months');
			        if(!calendarEl) return;
			        
			        calendarEl.addEventListener('mouseenter', function(e) {
			            if (e.target.classList.contains('lightpick__day') && !e.target.classList.contains('is-disabled')) {
			                setTimeout(function() {
			                    const start = picker1.getStartDate();
			                    const hoverTimestamp = parseInt(e.target.getAttribute('data-time'));
			                    
			                    if (start && hoverTimestamp) {
			                        const hoverDate = moment(hoverTimestamp);
			                        const firstDate = start.isBefore(hoverDate) ? start : hoverDate;
			                        const secondDate = start.isBefore(hoverDate) ? hoverDate : start;
			                        
			                        const weekdaysCount = getWeekdaysCount(firstDate, secondDate);
			                        const tooltip = document.querySelector('.lightpick__tooltip');
			                        if (tooltip) {
			                            tooltip.innerText = weekdaysCount + ' 일 (평일 기준)';
			                        }
			                    }
			                }, 5);
			            }
			        }, true);
			    },
				onSelect: function(start, end){
					// ⚠️ 선택자 수정 (:selected -> option:selected)
					var currentFormHead = $(".aprv-form-list option:selected").attr("data-head");
					var sDate = $(".picker-sdate").val();
					var eDate = $(".picker-edate").val();
					
					if(currentFormHead == "연차" && sDate != "" && eDate != "") {
				        if(sDate == eDate) {
							$(".vacationType").show();
							var template = $("#vacation-type-template").text();
							const div = $.parseHTML(template)[1];
							$(".vacationType").html(div); // 중복 append 방지를 위해 html() 사용 권장
						} else {
							$(".vacationType").hide().empty();
						}
					} else {
						$(".vacationType").hide().empty();
					}
					
					if(currentFormHead == "연차" && sDate && eDate) {
						var count = getWeekdaysCount(moment(sDate), moment(eDate));
						if(count > ${leaveRemain}) {
							alert("휴가 잔여일 : ${leaveRemain}일\r\n휴가 선택일 : " + count + "일\r\n\r\n휴가 잔여일보다 휴가 선택일이 많습니다.\r\n\r\n다시 선택하세요.");
							picker1.setDateRange(null, null);
							$(".picker-sdate").val("");
							$(".picker-edate").val("");
							$('input[name=aprvLeave]').val("");
						} else {
							$('input[name=aprvLeave]').val(count);
						}
					}
					
                    if($(".picker-sdate").val().trim().length > 0) $(".picker-sdate").removeClass("fail");
                    if($(".picker-edate").val().trim().length > 0) $(".picker-edate").removeClass("fail");
                    
                    // 날짜 변경 시 실시간 상태 동기화
                    state.aprvSdateValid = $(".picker-sdate").val().trim().length > 0;
                    state.aprvEdateValid = $(".picker-edate").val().trim().length > 0;
			    }
			});
			break;
			
		case "사직":
			$(".date-title").text("퇴사일자");
			$(".picker-sdate").attr("placeholder", "퇴사일");
			$(".timeTilde").hide();
			$(".picker-edate").hide();
			var picker1 = new Lightpick({ 
			    field : $(".picker-sdate")[0],
			    format : "YYYY-MM-DD",
				firstDay : 7,
				disableWeekends: true,
				onSelect: function(start, end){
			        $(".picker-edate").val($(".picker-sdate").val());
                    state.aprvSdateValid = true;
                    state.aprvEdateValid = true;
			    }
			});
			break;
			
		case "비용":
			$(".date-title").text("지출일자");
			$(".picker-sdate").attr("placeholder", "지출일");
			$(".timeTilde").hide();
			$(".picker-edate").hide();
			var picker1 = new Lightpick({ 
			    field : $(".picker-sdate")[0],
			    format : "YYYY-MM-DD",
				firstDay : 7,
				disableWeekends: true,
				onSelect: function(start, end){
			        $(".picker-edate").val($(".picker-sdate").val());
                    state.aprvSdateValid = true;
                    state.aprvEdateValid = true;
			    }
			});
			break;
	}
	
	// 블러/체인지 이벤트 핸들러들
    $("[name=aprvTitle]").on("blur", function(){
        state.aprvTitleValid = $(this).val().trim().length > 0;
    });
    $("[name=aprvContent]").on("change keyup", function(){ // keyup 추가로 실시간 검사 보완
        state.aprvContentValid = $(this).val().trim().length > 0;
    });
    $("[name=aprvEdate]").on("blur", function(){
        state.aprvEdateValid = $(this).val().trim().length > 0;
    });
    $("[name=aprvSdate]").on("blur", function(){
        state.aprvSdateValid = $(this).val().trim().length > 0;
    });
    $("[name=aprvLineNo1]").on("blur", function(){
        state.aprvLineNo1Valid = $(this).val().trim().length > 0;
    });
    $("[name=aprvLineNo2]").on("blur", function(){
        state.aprvLineNo2Valid = $(this).val().trim().length > 0;
    });
 
 // 9. 최종 전송(submit) 시 검사
    $(".form-check").on("submit", function(e){
        
        // [1] 전송 직전 입력값 기준으로 state 갱신
        state.aprvTitleValid = $("[name=aprvTitle]").val().trim().length > 0;
        state.aprvContentValid = $("[name=aprvContent]").val().trim().length > 0;
        state.aprvSdateValid = $("[name=aprvSdate]").val().trim().length > 0;
        state.aprvEdateValid = $("[name=aprvEdate]").val().trim().length > 0;
        
        // [2] 결재 라인 테이블(tbody)에 추가된 행(tr) 개수로 결재자 등록 여부 체크
        state.aprvLineNo1Valid = ($("#line1List tr").length > 0);
        state.aprvLineNo2Valid = ($("#line2List tr").length > 0);

        // [3] 순차적 유효성 검사 및 경고창 출력
        if(!state.aprvTitleValid) {
            window.alert("결재명을 입력하세요.");
            $("[name=aprvTitle]").focus();
            return false; 
        }
        if(!state.aprvContentValid) {
            window.alert("결재 내용을 입력하세요.");
            $("[name=aprvContent]").focus();
            return false; 
        }
        if(!state.aprvSdateValid) {
            window.alert("결재 시작일을 입력하세요.");
            $("[name=aprvSdate]").focus();
            return false; 
        }
        if(!state.aprvEdateValid) {
            window.alert("결재 종료일을 입력하세요.");
            $("[name=aprvEdate]").focus();
            return false; 
        }
        
        // 🚨 결재자 미선택 시 명확하게 경고창을 띄우고 전송 중단
        if(!state.aprvLineNo1Valid) {
            window.alert("첫 번째 결재자를 입력하세요.");
            $(".aprv-line-1").focus(); 
            return false; // 무조건 전송 차단
        }
        if(!state.aprvLineNo2Valid) {
            window.alert("두 번째 결재자를 입력하세요.");
            $(".aprv-line-2").focus(); 
            return false; // 무조건 전송 차단
        }
        
        // [4] 기안 / 임시저장 상태 값 세팅
        var clickedButton = e.originalEvent.submitter; 
        if ($(clickedButton).hasClass("aprv-insert")) {
        	$(".aprv-status").val("대기");
        } else {
        	$(".aprv-status").val("임시저장");
        }

        // 위의 모든 if문을 통과했다면 완벽하게 검증된 것이므로 무조건 true 반환
        return true; 
    });
});
</script>

<!-- 화면에 나오지 않으면서 언제든지 불러서 쓸 수 있는 화면 조각(템플릿) -->
<script type="text/template" id="dept-template">
<li class="dept-item">
	<div class="dept-row">
		<span class="toggle-btn">▼</span>
		<input type="checkbox" name="dept" class="dept-checkbox" id="dept">
		<label for="dept" class="dept-name">부서명</label>
	</div>
	<ul>
	</ul>
</li>
</script>
<script type="text/template" id="emp-template">
<tr>
    <td>
        <input type="checkbox" name="emp" class="emp-checkbox checkbox-custom" id="emp_DYNAMIC">
        <label for="emp_DYNAMIC" class="my-checkbox-label"></label> </td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
</tr>
</script>
<script type="text/template" id="emp-empty-template">
<tr>
	<td colspan="6">검색된 사원이 없습니다</td>
</tr>
</script>
<script type="text/template" id="line-template">
<tr>
	<input type="hidden" />
	<td></td>
	<td></td>
	<td></td>
	<td><button type="button" class="btn btn-negative line-delete">삭제</button></td>
</tr>
</script>
<script type="text/template" id="aprv-form-file-template">
<a style="display: inline-block; border: 1px solid #333; background: white; color: black; padding: 5px 15px; text-decoration: none; border-radius: 3px; font-size: 14px;"><i class="fa-regular fa-file"></i><span>양식 파일 다운로드</span></a>
</script>
<script type="text/template" id="aprv-form-file-empty-template">
<a style="display: inline-block; border: 1px solid #333; background: white; color: black; padding: 5px 15px; text-decoration: none; border-radius: 3px; font-size: 14px;"><span>양식 파일 없음</span></a>
</script>
<script type="text/template" id="aprv-form-file-delete-template">
<button type="button" class="btn-delete-file" data-no="" onclick="removeFile(this)" style="display: inline-flex; align-items: center; justify-content: center; width: 28px; height: 28px; border: 1px solid #dc3545; background: #fff; color: #dc3545; border-radius: 3px; cursor: pointer; font-size: 14px; transition: all 0.2s; margin-left: 2px;" onmouseover="this.style.background='#dc3545'; this.style.color='#fff';" onmouseout="this.style.background='#fff'; this.style.color='#dc3545';">
	<i class="fa-solid fa-xmark"></i>
</button>
</script>
<script type="text/template" id="vacation-type-template">
<div>
	<div class="cell">
		<label>휴가 분류</label>
	</div>
	<div class="cell">
		<input type="radio" name="vacationType" value="연차" id="vacationType1">
		<label for="vacationType1">연차</label>
		<input type="radio" name="vacationType" value="반차" id="vacationType2">
		<label for="vacationType2">반차</label>
	</div>
</div>
</script>

<style>
	.cell { min-height: 32px; }
</style>

<form action="./insert" autocomplete="off" method="post" enctype="multipart/form-data" class="form-check">

	<div class="container w-1200 mt-50">
		
    	<div class="cell center">
            <h1 class="h1-title">결재 등록</h1>
        </div>
        <div class="cell mb-0" style="display:none;">
            <label>양식 선택</label> 
		</div>
		<div class="cell mt-0" style="display:none;">
            <select class="field w-40 aprv-form-list" name="aprvFormNo">
                <option value="">선택하세요</option>
                <c:forEach var="aprvFormDto" items="${formList}">
                <option value="${aprvFormDto.formNo}" data-head="${aprvFormDto.headName}" data-name="${aprvFormDto.formName}" <c:if test="${aprvFormDto.formNo == param.formNo}">selected</c:if>>[${aprvFormDto.headName}] ${aprvFormDto.formName}</option>
                </c:forEach>
            </select>
            <input type="hidden" class="">
        </div>
        <div class="cell mb-0">
            <label>제목 <i class="fa-solid fa-asterisk red"></i></label>
        </div>
        <div class="cell mt-0">
        	<input type="text" name="aprvTitle" class="field w-40">
        </div>
        <div class="cell mb-0">
            <label>양식 파일</label>
        </div>
        <div class="cell mt-0 aprv-form-file">
        	
        </div>
        <div class="flex-area">
	        <div class="w-33">
		        <div class="cell mb-0">
		            <label><span class="date-title">기한</span> <i class="fa-solid fa-asterisk red"></i></label>
		        </div>
		        <div class="cell mt-0">
		        	<input type="hidden" name="aprvLeave" value="" />
		        	<input type="text" name="aprvSdate" class="field picker-sdate" size="4" placeholder="시작일">
		        	<span class="timeTilde">~</span>
		        	<input type="text" name="aprvEdate" class="field picker-edate" size="4" placeholder="종료일">
		        </div>
	        </div>
	        <div class="w-66 vacationType">
	        	
	        </div>
        </div>
        <div class="cell">
        	<label>내용 <i class="fa-solid fa-asterisk red"></i></label>
        	<input type="text" name="aprvContent" class="field w-100">
        </div>
        <div class="cell mb-0">
            <label>첨부 파일</label>
        </div>
        <div class="cell mt-0">
			<label>
				<i class="fa-regular fa-file"></i>
				<span>클릭해서 첨부파일을 선택하세요</span>
				<input type="file" name="attach" class="field w-100 attach-input" style="display: none;">
			</label>
		</div>
		<div class="cell aprv-form-file-down">
		</div>
		<div class="cell flex-area">
			<div class="cell flex-vertical w-50 me-10">
		        <div class="cell mb-0">
		            <label>1차 결재 라인</label>
		        </div>
		        <div class="cell w-100 mt-0">
		        	<table class="table">
		        		<thead>
		        			<tr>
			        			<th>부서</th>
			        			<th>결재자</th>
			        			<th>직책</th>
			        			<th>처리</th>
		        			</tr>
		        		</thead>
		        		<tbody id="line1List" class="lineList">
		        			
		        		</tbody>
		        	</table>
		        </div>
		        <div class="cell w-100 right">
		        	<a onclick="openModal('1');" class="btn btn-positive aprv-line-1">결재자 추가</a>
		        </div>
		    </div>
		    <div class="cell flex-vertical w-50 ms-10">
		        <div class="cell mb-0">
		            <label>2차 결재 라인</label>
		        </div>
		        <div class="cell w-100 mt-0">
		        	<table class="table">
		        		<thead>
		        			<tr>
			        			<th>부서</th>
			        			<th>결재자</th>
			        			<th>직책</th>
			        			<th>처리</th>
		        			</tr>
		        		</thead>
		        		<tbody id="line2List" class="lineList">
		        			
		        		</tbody>
		        	</table>
		        </div>
		        <div class="cell w-100 right">
		        	<a onclick="openModal('2');" class="btn btn-positive aprv-line-2">결재자 추가</a>
		        </div>
			</div>
        </div>
        <div class="cell mt-40 mb-50 right">
        	<input type="hidden" name="aprvStatus" class="aprv-status" value="">
        	<a href="./list" class="btn btn-neutral">목록으로</a>
        	<button class="btn aprv-temp-insert" style="background-color:#93A8AC;">
                임시저장
            </button>
            <button class="btn btn-positive aprv-insert">
                기안하기
            </button>
        </div>
    </div>
</form>

<div class="modal-overlay" id="modalOverlay1">
    <div class="modal-box">
        <div class="modal-header">1차 결재 라인 선택</div>
        
        <div class="modal-body">
            <form id="popupForm1" class="flex-area">
            	<div class="cell w-25 me-10">
	                <div id="deptList1" class="dept-tree border height-limit">
						<ul>
						</ul>
					</div>
				</div>
				<div class="cell w-75 ms-10">
					<!-- 테이블 -->
					<div class="cell center">
						<table class="table" style="margin-top: 15px;">
							<thead>
								<tr>
									<th width="10%"><input type="checkbox" name="emp" class="emp-checkbox check-emp-all-1"></th>
									<th width="20%">부서</th>
									<th width="25%">사원아이디</th>
									<th width="15%">이름</th>
									<th width="15%">직급</th>
									<th width="15%">상태</th>
								</tr>
							</thead>
							<tbody id="empList1">
							</tbody>
						</table>
					</div>
				</div>
            </form>
        </div>
        
        <div class="modal-footer">
            <button type="button" class="btn btn-positive" onclick="addEmp('1')">확인</button>
            <button type="button" class="btn btn-neutral" onclick="closeModal('1')">취소</button>
        </div>
    </div>
</div>

<div class="modal-overlay" id="modalOverlay2">
    <div class="modal-box">
        <div class="modal-header">2차 결재 라인 선택</div>
        
        <div class="modal-body">
            <form id="popupForm2" class="flex-area">
            	<div class="cell w-25 me-10">
	                <div id="deptList2" class="dept-tree border height-limit">
						<ul>
						</ul>
					</div>
				</div>
				<div class="cell w-75 ms-10">
					<!-- 테이블 -->
					<div class="cell center">
						<table class="table" style="margin-top: 15px;">
							<thead>
								<tr>
									<th width="10%"><input type="checkbox" name="emp" class="emp-checkbox check-emp-all-2"></th>
									<th width="20%">부서</th>
									<th width="25%">사원아이디</th>
									<th width="15%">이름</th>
									<th width="15%">직급</th>
									<th width="15%">상태</th>
								</tr>
							</thead>
							<tbody id="empList2">
							</tbody>
						</table>
					</div>
				</div>
            </form>
        </div>
        
        <div class="modal-footer">
            <button type="button" class="btn btn-positive" onclick="addEmp('2')">확인</button>
            <button type="button" class="btn btn-neutral" onclick="closeModal('2')">취소</button>
        </div>
    </div>
</div>

<!-- 결재 동작 스크립트 -->
<script src="/js/aprv/insert.js"></script>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>