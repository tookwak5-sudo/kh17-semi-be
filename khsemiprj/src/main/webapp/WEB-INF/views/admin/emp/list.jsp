<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<style>
	.table-hover tbody tr:hover {
			background-color : #f8f9fa;
			transition: background-color 0.2s ease;
	}
	
	.select2-results__options {
        max-height: 150px !important;
        overflow-y: auto !important;
    }
    
	.select2-container .select2-selection--single {
	    height: 38px !important; /* 기존 field와 비슷한 높이로 설정 */
	    border: 1px solid #ced4da !important; 
	    border-radius: 6px !important;
	    display: flex;
	    align-items: center;
	}
	
	/* 텍스트가 위아래 정중앙에 오도록 설정 */
	.select2-container--default .select2-selection--single .select2-selection__rendered {
	    line-height: 38px !important;
	    padding-left: 10px !important;
	}
	
	.select2-container--default .select2-selection--single .select2-selection__arrow {
	    height: 36px !important;
	}
</style>

<script>
$(function(){
    // 1. 현재 페이지 경로를 키값으로 사용 (예: /board/list) -> 다른 메뉴와 검색어 섞임 방지
    var menuKey = window.location.pathname; 

    // 2. 세션 스토리지에서 현재 메뉴의 이전 검색어 가져오기
    var savedColumn = sessionStorage.getItem(menuKey + '_column');
    var savedKeyword = sessionStorage.getItem(menuKey + '_keyword');
    
    // 3. 디테일에서 목록으로 돌아왔을 때 (주소창에 파라미터가 없는데 스토리지에 검색어가 있다면?)
    var urlParams = new URLSearchParams(window.location.search);
    if (!urlParams.has('column') && savedColumn && savedKeyword) {
        // 기억해둔 검색어를 주소창에 붙여서 강제 이동 (검색 복구)
        location.href = './list?column=' + savedColumn + '&keyword=' + encodeURIComponent(savedKeyword);
        return;
    }

    // 4. 사용자가 새롭게 검색 폼을 제출(검색 버튼 클릭)할 때 스토리지 갱신
    $("form").on("submit", function() {
        // 폼 안에서 column과 활성화된 keyword 값을 찾음
        var column = $(this).find("[name=column]").val();
        var keyword = $(this).find("[name=keyword]:not(:disabled)").val();
        
        if(column && keyword) {
            sessionStorage.setItem(menuKey + '_column', column);
            sessionStorage.setItem(menuKey + '_keyword', keyword);
        } else {
            // 검색어 없이 전체 검색 시 메모리 초기화
            sessionStorage.removeItem(menuKey + '_column');
            sessionStorage.removeItem(menuKey + '_keyword');
        }
    });
});
</script>

<div class="container w-90 mt-20 mb-50 background-card">
	<div class="cell center flex-area">
		<div class="w-25 flex-area" style="justify-content: left">
			<div>
		        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
		            사원 관리
		            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
		        </h1>
			</div>
        </div>
        
        <div class="cell flex-area flex-vertical background-fill">
			<form action="./list" method="get" style="display: flex; align-items: center; gap: 8px;">
				<select name="column" class="field">
					<option value="emp_id" ${param.column == 'emp_id' ? 'selected' : ''}>아이디</option>
					<option value="emp_name" ${param.column == 'emp_name' ? 'selected' : ''}>이름</option>
					<option value="dept_name" ${param.column == 'dept_name' ? 'selected' : ''}>부서명</option>
					<option value="emp_position_name" ${param.column == 'emp_position_name' ? 'selected' : ''}>직급</option>
				</select>
				<input type="text" name="keyword" class="field-sm" value="${param.keyword}">
				<button class="btn btn-positive" style="padding: 8px 18px; font-size: 16px;">
					<i class="fa-solid fa-magnifying-glass"></i>
					<span>검색</span>
				</button>
			</form>
		</div>
		
		<div class="w-20 flex-area flex-center" style="justify-content: right;">
		</div>
	</div>
			
		<c:if test="${sessionScope.empGrade == 2 && wList.size() > 0}">
		<div class="cell">
			<button type="button" id="toggleWaitBtn" style="width: 100%; height: 50px; padding: 15px; font-size: 16px; font-weight: bold; border: 1px solid #739BED; background-color: white; cursor: pointer; display: flex; justify-content: space-between; align-items: center; border-radius: 8px;">
				<span>
                <i class="fa-solid fa-bell" style="color: #f94b4b;"></i>
                승인 대기 중인 사원이 <span style="color: #f94b4b; font-size: 18px;">${wList.size()}</span>명 있습니다.
            	</span>
            	<span id="toggleIcon" style="color: #666;">▼</span>
            </button>
       	</div>
       	<div id="waitListArea" style="display: none; margin-top: 0px;">
					<table class="table" style="background-color: white; margin-bottom: 0;">
						<thead>
							<tr style="border-bottom: 2px solid #e9ecef;">
								<th style="padding: 10px;">아이디</th>
								<th style="padding: 10px;">이름</th>
								<th style="padding: 10px;">관리</th>
							</tr>
						</thead>
						<tbody align="center">
							<c:forEach var="waitEmp" items="${wList}">
							<tr>
								<td style="padding: 12px 0;">${waitEmp.empId}</td>
								<td style="padding: 12px 0;">${waitEmp.empName}</td>
								<td>
									<button type="button" class="btn btn-positive" onclick="openPopUp('${waitEmp.empId}')" style="padding: 6px 12px; font-size: 18px;">승인</button>
									<a href="reject?empId=${waitEmp.empId}" class="btn btn-negative btn-reject-action" style="text-decoration: none; padding: 6px 12px; font-size: 18px;">거절</a>
								</td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
		
		<hr class="mt-20 mb-30">
		</c:if>
				
	<c:if test="${param.column != null && param.keyword != null && param.keyword != ''}">
	<div class="cell">
		<h3>총 <span class="red">${list.size()}</span>명의 회원이 검색되었습니다</h3>
	</div>
	</c:if>
	
	
	<c:if test="${list.size() > 0}">
	<div class="cell">
			<table class="table table-hover">
				<thead>
					<tr>
						<th>사원 아이디</th>
						<th>이름</th>
						<th>부서</th>
						<th>직급</th>
					</tr>
				</thead>
				<tbody align="center">
					<c:forEach var="empPositionDto" items="${list}">
					
					<tr onclick="location.href='detail?empId=${empPositionDto.empId}'">
						<td>${empPositionDto.empId}</td>
						<td>${empPositionDto.empName}</td>
						<td>${empPositionDto.deptName}</td>
						<td>${empPositionDto.empPositionName}</td>
					</tr>
					
					</c:forEach>
				</tbody>
			</table>
	</div>
	</c:if>
</div>


<div id="popUp" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); z-index: 9999;">
    <div style="background-color: white; width: 400px; margin: 15% auto; padding: 25px; border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);">
        <h3 class="mt-0 blue">사원 가입 승인</h3>
        
        <div style="background-color: #f5f6fa; padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: bold;">
            사원 ID : <span id="targetEmpId" class="blue"></span>
        </div>
        
        <form action="approve" method="post" style="display: flex; flex-direction: column; gap: 15px;" onsubmit="return checkApproveForm();">
            <input type="hidden" name="empId" id="postEmpId">
            
            <div>
                <label>입사일 지정</label>
                <input type="text" name="empHireDate" id="hireDatePicker" class="field w-100" placeholder="YYYY-MM-DD" autocomplete="off">
            </div>
            
            <div>
                <label>부서 배치</label>
                <select name="deptNo" class="field w-100">
                    <option value="">부서를 선택하세요</option>
                    <c:forEach var="dept" items="${deptList}">
                    <option value="${dept.deptNo}">${dept.deptName}</option>
                    </c:forEach>
                </select>
            </div>
            
             <div>
                <label>직급 지정</label>
                <select name="empPositionNo" class="field w-100">
                	<option value="">선택</option>
                	<c:forEach var="position" items="${positionList}">
		            	<option value="${position.empPositionNo}">${position.empPositionName}</option>
                	</c:forEach>
	            </select>
            </div>
            
            <div style="display: flex; gap: 10px; justify-content: flex-end;">
                <button type="submit" class="btn btn-positive">입력 완료</button>
                <button type="button" class="btn btn-negative" onclick="closePopUp()">취소</button>
            </div>
        </form>
    </div>
</div>

<div class="cell">    
	<!-- 페이지네이션 -->
	<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
	</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
    // 팝업 함수
    function openPopUp(empId) {
        document.getElementById('postEmpId').value = empId;
        document.getElementById('targetEmpId').innerText = empId;
        document.getElementById('popUp').style.display = 'block';
    }

    function closePopUp() {
        document.getElementById('popUp').style.display = 'none';
        document.getElementById('hireDatePicker').value = '';
        
        $('select[name="deptNo"]').val('').trigger('change');
        $('select[name="empPositionNo"]').val('').trigger('change');
    }
     
    document.addEventListener("DOMContentLoaded", function() {
    	var hireDatePicker = new Lightpick({
    		field: document.getElementById('hireDatePicker'),
    		format: 'YYYY-MM-DD',
    		firstDay: 7
    	});
    });
    
    $(document).ready(function() {
        $('select[name="deptNo"], select[name="empPositionNo"]').select2({
            dropdownParent: $('#popUp'),
            width: '100%',
            minimumResultsForSearch: Infinity
        });
        
        /* $("#toggleWaitBtn").click(function() {
            
           $("#waitListArea").slideToggle(300, function() {
               
            if ($(this).is(":visible")) {
                $("#toggleIcon").html("▲"); 
                $("#toggleWaitBtn").css("border-bottom", "none");
            } else {
                $("#toggleIcon").html("▼"); 
                $("#toggleWaitBtn").css("border-bottom", "1px solid #739BED");
            }
         });
    }); */
    
        $("#toggleWaitBtn").click(function() {
            $("#waitListArea").slideToggle(300, function() {
                if ($(this).is(":visible")) {
                    $("#toggleIcon").html("▲"); // 열리면 위 화살표
                } else {
                    $("#toggleIcon").html("▼"); // 닫히면 아래 화살표
                }
            });
        });
    });
    
    function checkApproveForm() {
        var hireDate = document.querySelector('[name="empHireDate"]');
        var deptNo = document.querySelector('[name="deptNo"]');
        var positionNo = document.querySelector('[name="empPositionNo"]');
        
        if (!hireDate.value.trim()) {
            window.alert("입사일을 지정해 주세요.");
            hireDate.focus();
            return false; // 전송 중단
        }
        
        if (!deptNo.value) {
            window.alert("부서를 배치해 주세요.");
            $(deptNo).select2('open'); // Select2 창 열기
            return false;
        }
        
        if (!positionNo.value) {
            window.alert("직급을 지정해 주세요.");
            $(positionNo).select2('open'); // Select2 창 열기
            return false;
        }

        // 3개 모두 입력되었다면 마지막으로 확인받고 전송
        return confirm("해당 사원의 가입을 승인하시겠습니까?");
    }
    
    var rejectState = {
    		rejectValid: false,
			ok: function(){
				return Object.values(this)
				.filter(v => typeof v==="boolean")
				.every(v => v === true);
			}
		};
    $(function () {
        // id(#)가 아닌 클래스(.) 기반으로 이벤트를 잡아야 모든 행에서 작동합니다.
        $(document).on("click", ".btn-reject-action", function(e){
            e.preventDefault(); // 링크 이동을 일단 막음
            
            var rejectUrl = $(this).attr("href"); // 클릭한 버튼의 거절 URL 수집
            
            openConfirm(
                '승인 거절하시겠습니까?', 
                "location.href = '" + rejectUrl + "';"
            );
        });	
    });
</script>

