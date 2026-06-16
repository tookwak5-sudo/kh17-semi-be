<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    

<jsp:include page="/WEB-INF/views/template/header.jsp"/>
    
<!-- 결재 디자인 css -->
<link rel="stylesheet" type="text/css" href="/css/aprv/insert.css">
<!-- 부서 목록 디자인 css -->
<link rel="stylesheet" type="text/css" href="/css/dept/list.css">

<script>
	const deptList = JSON.parse('${deptListJson}');
	
	$(function () {
		var formNo = '${aprvDto.aprvFormNo}';
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
					startDate : '${aprvDto.aprvSdate}',
					endDate : '${aprvDto.aprvEdate}',
					singleDate : true, //단일 날짜 선택 불가(범위 선택 가능)
				    format : "YYYY-MM-DD",
					firstDay : 7,
					disableWeekends: true,
					// 1. 달력이 화면에 열렸을 때 마우스 움직임 감지 셋팅
				    onOpen: function() {
				        // Lightpick 달력의 날짜 칸(td)들에 마우스가 올라갈 때 이벤트 리스너 추가
				        const calendarEl = document.querySelector('.lightpick__months');
				        
				        calendarEl.addEventListener('mouseenter', function(e) {
				            // 마우스가 올라간 날짜 엘리먼트가 실제 날짜(day) 칸인지 확인
				            if (e.target.classList.contains('lightpick__day') && !e.target.classList.contains('is-disabled')) {
				                
				                // Lightpick이 내부적으로 계산을 마친 직후(아주 잠깐의 뒤)에 가로채기 위해 setTimeout 사용
				                setTimeout(function() {
				                    // 시작일은 선택되었고 종료일은 아직 마우스만 올라가 있는 상태(is-in-range 상태)일 때
				                    const start = picker1.getStartDate();
				                    
				                    // 마우스가 올라가 있는 칸의 timestamp 데이터를 가져와 moment 객체로 변환
				                    const hoverTimestamp = parseInt(e.target.getAttribute('data-time'));
				                    
				                    if (start && hoverTimestamp) {
				                        const hoverDate = moment(hoverTimestamp);
				                        
				                        // 시작일과 마우스가 올라간 날짜 사이의 평일 수 계산
				                        // (시작일이 호버일보다 미래일 경우를 대비해 순서 정렬)
				                        const firstDate = start.isBefore(hoverDate) ? start : hoverDate;
				                        const secondDate = start.isBefore(hoverDate) ? hoverDate : start;
				                        
				                        const weekdaysCount = getWeekdaysCount(firstDate, secondDate);
				                        
				                        // 툴팁 텍스트 강제 변경
				                        const tooltip = document.querySelector('.lightpick__tooltip');
				                        if (tooltip) {
				                            tooltip.innerText = weekdaysCount + ' 일 (평일 기준)';
				                        }
				                    }
				                }, 5);
				            }
				        }, true); // 이벤트 캡처링 사용으로 개별 td의 이벤트를 부모에서 감지
				    },
					onSelect: function(start, end){
				        // 날짜 선택 시 실행될 코드
						var formHead = $(".aprv-form-list:selected").attr("data-head");
						var sDate = $(".picker-sdate").val();
						var eDate = $(".picker-edate").val();
						if(formHead == "연차" && sDate != "" && eDate != "") {
					        if(sDate == eDate) {
								$(".vacationType").show();
								var template = $("#vacation-type-template").text();
								const div = $.parseHTML(template)[1];
								$(".vacationType").append(div);
							} else {
								$(".vacationType").hide();
								$(".vacationType").empty();
							}
						} else {
							$(".vacationType").hide();
							$(".vacationType").empty();
						}
						
						var formHead = $(".aprv-form-list option:selected").attr("data-head");
						if(formHead == "연차") {
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
				    startDate : '${aprvDto.aprvSdate}',
				    format : "YYYY-MM-DD",
					firstDay : 7,
					disableWeekends: true,
					onSelect: function(start, end){
				        // 날짜 선택 시 실행될 코드
				        $(".picker-edate").val($(".picker-sdate").val());//시작일만 선택 가능하므로 종료일도 동일하게 설정
				    }
				});
				break;
		}
		
		// 유효성 검사 상태 객체
		var state = {
			aprvTitleValid: false,
			aprvContentValid: false,
			aprvSdateValid: false,
			aprvEdateValid: false,
			aprvLineNo1Valid: false,
			aprvLineNo2Valid: true,
			ok: function(){
				return Object.values(this)
				.filter(v => typeof v==="boolean")
				.every(v => v === true);
			}
		};
		
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
		
		//폼검사
		$(".form-check").on("submit", function(e){
        	$(this).find("select[name]").trigger("input");
            $(this).find("input[name], textarea[name]").trigger("blur");
            
         // [1] 전송 직전 입력값 기준으로 state 갱신
            state.aprvTitleValid = $("[name=aprvTitle]").val().trim().length > 0;
            state.aprvContentValid = $("[name=aprvContent]").val().trim().length > 0;
            state.aprvSdateValid = $("[name=aprvSdate]").val().trim().length > 0;
            state.aprvEdateValid = $("[name=aprvEdate]").val().trim().length > 0;
            
            // [2] 결재 라인 테이블(tbody)에 추가된 행(tr) 개수로 결재자 등록 여부 체크
            state.aprvLineNo1Valid = ($("#line1List tr").length > 0);

            // [3] 순차적 유효성 검사 및 경고창 출력
            if(!state.aprvTitleValid) {
                //window.alert("제목을 입력하세요.");
                showAjaxAlarm('필수', 'btn-negative', '[name=aprvTitle]', 'left');
                $("[name=aprvTitle]").focus();
                return false; 
            }
            
            if(!state.aprvSdateValid) {
                //window.alert("결재 시작일을 입력하세요.");
                showAjaxAlarm('필수', 'btn-negative', '[name=aprvSdate]', 'left');
                $("[name=aprvSdate]").focus();
                return false; 
            }
            if(!state.aprvEdateValid) {
                //window.alert("결재 종료일을 입력하세요.");
                showAjaxAlarm('필수', 'btn-negative', '[name=aprvEdate]', 'right');
                $("[name=aprvEdate]").focus();
                return false; 
            }
            if(!state.aprvContentValid) {
                //window.alert("내용을 입력하세요.");
                showAjaxAlarm('필수', 'btn-negative', '[name=aprvContent]', 'left');
                $("[name=aprvContent]").focus();
                return false;
            }
            // 🚨 결재자 미선택 시 명확하게 경고창을 띄우고 전송 중단
            if(!state.aprvLineNo1Valid) {
                //window.alert("1차 결재 라인 결재자를 추가하세요.");
                showAjaxAlarm('필수', 'btn-negative', '.aprv-line-1', 'left');
                //$(".aprv-line-1").click();
                return false; // 무조건 전송 차단
            }
            /* if(!state.aprvLineNo2Valid) {
                window.alert("두 번째 결재자를 입력하세요.");
                $(".aprv-line-2").focus(); 
                return false; // 무조건 전송 차단
            } */
            
         	// submit을 유발한 버튼 객체 가져오기
            var clickedButton = e.originalEvent.submitter; 

            // 특정 버튼일 때만 다르게 처리하고 싶다면?
            if ($(clickedButton).hasClass("aprv-update")) {
            	$(".aprv-status").val("대기");
            	return confirm("문서를 기안하시겠습니까?");
            } else {
            	$(".aprv-status").val("임시저장");
            }
           	return state.ok();
        });
		
		function getWeekdaysCount(startDate, endDate) {
		    let count = 0;
		    // Moment.js를 활용하여 시작일부터 종료일까지 1일씩 증가
		    let current = startDate.clone(); 
		    
		    while (current.isSameOrBefore(endDate, 'day')) {
		        // 요일 확인: 0(일요일) ~ 6(토요일)
		        let dayOfWeek = current.day(); 
		        
		        // 일요일(0)도 토요일(6)도 아닌 경우에만 카운트 증가
		        if (dayOfWeek !== 0 && dayOfWeek !== 6) {
		            count++;
		        }
		        current.add(1, 'day');
		    }
		    return count;
		}
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
	<td><input type="checkbox" name="emp" class="emp-checkbox" id="emp"></td>
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

<form action="./edit" autocomplete="off" method="post" enctype="multipart/form-data" class="form-check">
	<input type="hidden" name="aprvNo" value="${aprvDto.aprvNo}">
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
                <option value="${aprvFormDto.formNo}" data-head="${aprvFormDto.headName}" data-name="${aprvFormDto.formName}" <c:if test="${aprvFormDto.formNo == aprvDto.aprvFormNo}">selected</c:if>>[${aprvFormDto.headName}] ${aprvFormDto.formName}</option>
                </c:forEach>
            </select>
            <input type="hidden" class="">
        </div>
        <div class="cell mb-0">
            <label>제목 <i class="fa-solid fa-asterisk red"></i></label>
        </div>
        <div class="cell mt-0">
        	<input type="text" name="aprvTitle" class="field w-40" value="${aprvDto.aprvTitle}">
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
					<input type="hidden" name="aprvLeave" value="${aprvDto.aprvLeave}" />
		        	<input type="text" name="aprvSdate" class="field picker-sdate" size="4" placeholder="시작일">
		        	<span class="timeTilde">~</span>
		        	<input type="text" name="aprvEdate" class="field picker-edate" size="4" placeholder="종료일" value="${aprvDto.aprvEdate}">
		        </div>
	        </div>
	        <div class="w-66 vacationType">
	        	
	        </div>
        </div>
        <div class="cell">
        	<label>내용 <i class="fa-solid fa-asterisk red"></i></label>
        	<input type="text" name="aprvContent" class="field w-100" value="${aprvDto.aprvContent}">
        </div>
        <div class="cell mb-0">
            <label>첨부 파일</label>
        </div>
        <div class="cell mt-0">
			<label>
				<i class="fa-regular fa-file"></i>
				<span>클릭해서 첨부파일을 선택하세요</span>
				<input type="file" name="attach" class="field w-100 attach-input" style="display: none;" >
			</label>
			<input type="hidden" name="deleteFileNo" value="" />
		</div>
		<div class="cell aprv-form-file-down">
			<c:if test="${not empty attachDto}">
	  		<a style="display: inline-block; border: 1px solid #333; background: white; color: black; padding: 5px 15px; text-decoration: none; border-radius: 3px; font-size: 14px;">
			<i class="fa-regular fa-file"></i><span>${attachDto.attachName}</span>
    		</a>
    		<button type="button" class="btn-delete-file" data-no="${attachDto.attachNo}" onclick="removeFile(this)" style="display: inline-flex; align-items: center; justify-content: center; width: 28px; height: 28px; border: 1px solid #dc3545; background: #fff; color: #dc3545; border-radius: 3px; cursor: pointer; font-size: 14px; transition: all 0.2s;" onmouseover="this.style.background='#dc3545'; this.style.color='#fff';" onmouseout="this.style.background='#fff'; this.style.color='#dc3545';">
		        <i class="fa-solid fa-xmark"></i>
		    </button>
		    </c:if>
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
		        			<c:forEach var="aprvLineList" items="${aprvLine1List}">
		        			<tr name="line1EmpId" data-id="${aprvLineList.empId}">
		        				<input type="hidden" name="aprvLine1IdList" value="${aprvLineList.empId}"/>
		        				<td>${aprvLineList.deptName}</td>
		        				<td>${aprvLineList.empName}</td>
		        				<td>${aprvLineList.empPositionName}</td>
		        				<td><button type="button" class="btn btn-negative line-delete">삭제</button></td>
		        			</tr>
		        			</c:forEach>
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
		        			<c:forEach var="aprvLineList" items="${aprvLine2List}">
		        			<tr name="line2EmpId" data-id="${aprvLineList.empId}">
		        				<input type="hidden" name="aprvLine2IdList" value="${aprvLineList.empId}"/>
		        				<td>${aprvLineList.deptName}</td>
		        				<td>${aprvLineList.empName}</td>
		        				<td>${aprvLineList.empPositionName}</td>
		        				<td><button type="button" class="btn btn-negative line-delete">삭제</button></td>
		        			</tr>
		        			</c:forEach>
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
        	<button class="btn btn-save aprv-temp-update">
                임시저장
            </button>
            <button class="btn btn-positive aprv-update">
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