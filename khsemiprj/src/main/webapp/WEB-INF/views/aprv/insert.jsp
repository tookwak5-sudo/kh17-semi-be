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
				$(".date-title").text("기한");
				$(".timeTilde").show();
				$(".picker-edate").show();
				var picker1 = new Lightpick({ 
				    field : $(".picker-sdate")[0],
					secondField : $(".picker-edate")[0],
					singleDate : true, //단일 날짜 선택 불가(범위 선택 가능)
				    format : "YYYY-MM-DD",
					firstDay : 7,
					disableWeekends: true,
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
				        // 날짜 선택 시 실행될 코드
				        $(".picker-edate").val($(".picker-sdate").val());//시작일만 선택 가능하므로 종료일도 동일하게 설정
				    }
				});
				break;
		}
		
		var state = {
				aprvFormNoValid: true,
				aprvTitleValid: true,
				aprvContentValid: true,
				aprvSdateValid: true,
				aprvEdateValid: true,
				attachFileValid: true,
				aprvLineNo1Valid: true,
				aprvLineNo2Valid: true,
				ok: function(){
					return Object.values(this)
					.filter(v => typeof v==="boolean")
					.every(v => v === true);
				}
		};
		
		//폼검사
		$(".form-check").on("submit", function(){
        	$(this).find("select[name]").trigger("input");
            $(this).find("input[name], textarea[name]").trigger("blur");
           	return state.ok();
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
	<td colspan="5">검색된 사원이 없습니다</td>
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

<form action="./insert" autocomplete="off" method="post" class="form-check">

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
                <option value="${aprvFormDto.formNo}" data-head="${aprvFormDto.formHead}" data-name="${aprvFormDto.formName}" <c:if test="${aprvFormDto.formNo == param.formNo}">selected</c:if>>[${aprvFormDto.formHead}] ${aprvFormDto.formName}</option>
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
				<input type="file" name="attach" class="field w-100 preview-input" style="display: none;">
			</label>
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
			        			<th>결재자</th>
			        			<th>부서</th>
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
			        			<th>결재자</th>
			        			<th>부서</th>
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
        	<a href="./list" class="btn btn-neutral">목록으로</a>
        	<button class="btn" style="background-color:#fdcb6e;">
                임시저장
            </button>
            <button class="btn btn-positive">
                등록하기
            </button>
        </div>
    </div>
</form>

<div class="modal-overlay" id="modalOverlay1">
    <div class="modal-box">
        <div class="modal-header">1차 결재 라인 선택</div>
        
        <div class="modal-body">
            <form id="popupForm1" class="flex-area">
            	<div class="cell w-25">
	                <div id="deptList1" class="dept-tree border">
						<ul>
						</ul>
					</div>
				</div>
				<div class="cell w-75">
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
            	<div class="cell w-25">
	                <div id="deptList2" class="dept-tree border">
						<ul>
						</ul>
					</div>
				</div>
				<div class="cell w-75">
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