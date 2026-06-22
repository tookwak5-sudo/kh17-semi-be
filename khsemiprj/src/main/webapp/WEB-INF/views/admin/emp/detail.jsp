<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<script
	src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<style>
	/* 기존 스타일 수정 및 추가 */
		.profile-info {
		    font-size: 0.95em;
		    color: #475569;
		    margin-top: 15px;
		    line-height: 1.4;
		    padding: 10px 0;
		}
		
		/* 이름 강조 */
		.profile-name {
		    font-size: 1.2em;
		    font-weight: 700;
		    color: #1E293B;
		    margin-bottom: 2px;
		}
		
		/* 부서 및 직책 라인 */
		.profile-dept-pos {
		    font-size: 0.9em;
		    color: #64748b;
		    margin-bottom: 8px;
		}
		
		/* 아이디(작은 텍스트) */
		.profile-id {
		    font-size: 0.8em;
		    color: #94a3b8;
		    background: #f8fafc;
		    display: inline-block;
		    padding: 2px 6px;
		    border-radius: 4px;
		}
		.emp-info-card {
			background-color: #ffffff;
			border: 1px solid #e9ecef;
			border-radius: 12px;
			padding: 10px 30px;
		}
		.emp-info-row {
			display: flex;
			align-items: center;
			padding: 16px 0;
			border-bottom: 1px solid #f1f3f5;
		}
		.emp-info-row:last-child {
			border-bottom: none;
		}
		.emp-info-label {
			width: 25%;
			font-weight: 600;
			color: #495057;
			position: relative;
			padding-left: 14px;
			letter-spacing: -0.5px;
		}
		.emp-info-label::before {
			content: "";
			position: absolute;
			left: 0;
			top: 50%;
			transform: translateY(-50%);
			width: 4px;
			height: 14px;
			background-color: #739BED;
			border-radius: 2px;
		}
		.emp-info-value {
			width: 75%;
			color: #343a40;
			font-weight: 500;
		}
		.emp-info-value.point-color {
			color: #739BED;
			font-weight: 600;
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
<div class="container w-100 mt-20 mb-50 background-card">
	<div class="profile-info">
		<div class="profile-name">${empDto.empName} ${empPositionDeptDto.empPositionName}</div>
		<div class="profile-dept-pos">${empPositionDeptDto.deptName}</div>
	</div>
	<div class="cell">
		<img src="/emp/profile?empId=${empDto.empId}" width="100" height="100"
			style="border-radius:50%; box-shadow:0 0 1px 0 black">
	</div>
	
	<form action="edit" method="post" id="editForm" class="form-check">
		<input type="hidden" name="empId" value="${empDto.empId}">
		
		<div class="cell mt-40 emp-info-card">
			<div class="emp-info-row">
				<div class="emp-info-label">사원 아이디</div>
				<div class="emp-info-value point-color">${empDto.empId}</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">직책(직급)</div>
				<div class="emp-info-value">
					<span class="view-mode">${empPositionDeptDto.empPositionName}</span>
					<span class="edit-mode" style="display: none;">
						<select name="empPositionNo" class="field">
			            	<option value="">선택</option>
			            	<c:forEach var="position" items="${positionList}">
			            	<option value="${position.empPositionNo}" ${empPositionDeptDto.empPositionNo == position.empPositionNo ? 'selected' : ''}>
		                            ${position.empPositionName}
		                        </option>
			            	</c:forEach>
			            </select>
					</span>
				</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">이메일</div>
				<div class="emp-info-value">
					<span class="view-mode">${empDto.empEmail}</span>
					<span class="edit-mode" style="display: none;">
						<input type="email" name="empEmail" value="${empDto.empEmail}" class="field w-100">
					</span>
				</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">연락처</div>
				<div class="emp-info-value">
					<span class="view-mode">${empDto.empContact}</span>
					<span class="edit-mode" style="display: none;">
						<input type="text" name="empContact" value="${empDto.empContact}" class="field w-100">
					</span>
				</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">우편번호</div>
				<div class="emp-info-value flex-area">
					<div class="view-mode">${empDto.empPost}</div>
					<div class="edit-mode flex-area" style="display: none;">
						<input type="text" name="empPost" id="postcode" value="${empDto.empPost}" class="field w-200 me-10">
						<button type="button" class="btn btn-neutral btn-address-search">
							주소검색
						</button>
						<button type="button" class="btn btn-negative ms-10 btn-address-clear" style="display: none;">
							<i class="fa-solid fa-xmark"></i>
						</button>
					</div>
				</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">기본주소</div>
				<div class="emp-info-value">
					<span class="view-mode">${empDto.empAddress1}</span>
					<span class="edit-mode" style="display: none;">
						<input type="text" id="basicAddress" name="empAddress1" value="${empDto.empAddress1}" class="field w-100">
					</span>
				</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">상세주소</div>
				<div class="emp-info-value">
					<span class="view-mode">${empDto.empAddress2}</span>
					<span class="edit-mode" style="display: none;">
						<input type="text" id="detailAddress" name="empAddress2" value="${empDto.empAddress2}" class="field w-100">
					</span>
					<div class="gray mt-10 edit-mode" style="display: none; font-size: 13px;">
						* 주소를 변경하려면
						우편번호, 기본주소, 상세주소를 모두 입력해야 합니다.
					</div>
				</div>
			</div>
		</div>
		
		<c:if test="${empDto.empValid=='W' }">
			<div>
				<button type="button" class="btn btn-positive" onclick="openPopUp('${empDto.empId}')" style="padding: 6px 12px; font-size: 18px;">승인</button>
				<%-- <a href="reject?empId=${waitEmp.empId}" class="btn btn-negative btn-reject-action" style="text-decoration: none; padding: 6px 12px; font-size: 18px;">거절</a> --%>
				<a class="btn btn-negative btn-reject-action" onclick="event.stopPropagation(); rejectConfirm('${empDto.empId}');" style="text-decoration: none; padding: 6px 12px; font-size: 18px;">거절</a>
			</div>
		</c:if>
		
		<hr class="mt-50 mb-50">
		
		<div class="cell" style="display: flex; justify-content: flex-end; gap: 10px;">
			<c:if test="${param.keyword==null}">
				<a href="list" class="btn btn-positive view-mode">
					<i class="fa-solid fa-list"></i> 목록으로
				</a>
			</c:if>
			<c:if test="${param.keyword!=null}">
				<a href="list?column=${param.column}&keyword=${param.keyword}" class="btn btn-positive view-mode">
					<i class="fa-solid fa-list"></i> 목록으로
				</a>
			</c:if>
		
			<button type="button" class="btn btn-neutral view-mode" onclick="toggleEditMode(true)">정보 수정</button>
			
			<button type="button" class="btn btn-negative edit-mode" style="display: none;" onclick="toggleEditMode(false)">취소</button>
			<button type="submit" class="btn btn-positive edit-mode" style="display: none;">저장하기</button>
		</div>
	</form>
</div>
<div id="popUp" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); z-index: 999;">
    <div style="background-color: white; width: 400px; margin: 15% auto; padding: 25px; border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);">
        <h3 class="mt-0 blue">사원 가입 승인</h3>
        
        <div style="background-color: #f5f6fa; padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: bold;">
            사원 ID : <span id="targetEmpId" class="blue"></span>
        </div>
        
        <form id="formEmp" action="approve" method="post" style="display: flex; flex-direction: column; gap: 15px;" onsubmit="return checkApproveValidate();">
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
                <button id="btnEmpPopup" type="submit" class="btn btn-positive">입력 완료</button>
                <button type="button" class="btn btn-negative" onclick="closePopUp()">취소</button>
            </div>
        </form>
    </div>
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>

<script>
	function toggleEditMode(isEdit) {
		// 화면의 모든 view-mode와 edit-mode 요소들을 찾습니다.
		var views = document.querySelectorAll('.view-mode');
		var edits = document.querySelectorAll('.edit-mode');
		
		if(isEdit) {
			// 수정 모드 켜기: view는 숨기고, edit는 보여줌
			views.forEach(function(el) { el.style.display = 'none'; });
			edits.forEach(function(el) { el.style.display = ''; }); // 또는 block
		} else {
			// 수정 모드 끄기(취소): edit는 숨기고, view는 다시 보여줌
			views.forEach(function(el) { el.style.display = ''; });
			edits.forEach(function(el) { el.style.display = 'none'; });
		}
	}
	
    /* // 주소 검사 로직
    $("[name=empAddress2]").on("blur", function () {
        var empPost = $("[name=empPost]").val();
        var empAddress1 = $("[name=empAddress1]").val();
        var empAddress2 = $(this).val();

        var stable = $(this).prop("readonly");
        if(stable){
            $("[name=empPost],[name=empAddress1],[name=empAddress2]").removeClass("success fail");
            formState.empPostValid = true;
            formState.empAddress1Valid = true;
            formState.empAddress2Valid = true;
            return;
        }
        
        var valid = empPost.length > 0 && empAddress1.length > 0 && empAddress2.length > 0;
       
        $("[name=empPost],[name=empAddress1],[name=empAddress2]")
            .removeClass("success fail").addClass(valid ? "success" : "fail");

        formState.empPostValid = valid;
        formState.empAddress1Valid = valid;
        formState.empAddress2Valid = valid;
    }); */
    
    $("[name=empPost], [name=empAddress1], .btn-address-search").on("click", function () {
        new kakao.Postcode({
            oncomplete: function (data) {
                var addr = ''; 
                if (data.userSelectedType === 'R') { 
                    addr = data.roadAddress;
                } else { 
                    addr = data.jibunAddress;
                }

                $("[name=empPost]").val(data.zonecode);
                $("[name=empAddress1]").val(addr);

                $("[name=empAddress2]").prop("readonly", false).val("");
                
                $(".btn-address-clear").fadeIn();
                $("[name=empAddress2]").trigger("focus");
            }
        }).open();
    });

    $(".btn-address-clear").on("click", function () {
        $("[name=empPost], [name=empAddress1], [name=empAddress2]")
            .val("").removeClass("success").addClass("fail");
            
        $("[name=empAddress2]").prop("readonly", true);
        $(this).fadeOut();
        state.empAddressValid = false;
    });
	
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
        $('select[name="deptNo"], select[name="empPositionNo"]:eq(1)').select2({
            dropdownParent: $('#popUp'),
            width: '100%',
            minimumResultsForSearch: Infinity
        });
        
    
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
    
  //유효성 검사 상태 객체
    var formState = {
   		empPositionNoValid: false,
   		empEmailValid: false,
   		empContactValid: false,
   		empPostValid: false,
   		empAddress1Valid: false,
   		empAddress2Valid: false,
    	ok: function(){
    		return Object.values(this)
    		.filter(v => typeof v==="boolean")
    		.every(v => v === true);
    	}
    };
    
 	// 블러/체인지 이벤트 핸들러들
    $("[name=empPositionNo]:eq(0)").on("input", function(){
    	formState.empPositionNoValid = $(this).val().trim().length > 0;
    });
    $("[name=empEmail]").on("blur", function(){
    	formState.empEmailValid = $(this).val().trim().length > 0;
    });
    $("[name=empContact]").on("blur", function(){
    	formState.empContactValid = $(this).val().trim().length > 0;
    });
    $("[name=empPost]").on("blur", function(){
    	formState.empPostValid = $(this).val().trim().length > 0;
    });
    $("[name=empAddress1]").on("blur", function(){
    	formState.empAddress1Valid = $(this).val().trim().length > 0;
    });
    $("[name=empAddress2]").on("blur", function(){
    	formState.empAddress2Valid = $(this).val().trim().length > 0;
    });
  
    $(".form-check").on("submit", function(e){
    	$(this).find("select[name]").trigger("input");
        $(this).find("input[name], textarea[name]").trigger("blur");

        if(!formState.empPositionNoValid) {
            showAjaxAlarm('직책을 선택하세요', 'btn-negative', '[name=empPositionNo]', 'left');
            $("[name=empPositionNo]").focus();
            return false; 
        }
        
        if(!formState.empEmailValid) {
            showAjaxAlarm('이메일을 입력하세요', 'btn-negative', '[name=empEmail]', 'left');
            $("[name=empEmail]").focus();
            return false; 
        }
        
        if(!formState.empContactValid) {
            showAjaxAlarm('연락처를 입력하세요', 'btn-negative', '[name=empContact]', 'left');
            $("[name=empContact]").focus();
            return false; 
        }
        
        if(!formState.empPostValid) {
            showAjaxAlarm('우편번호를 입력하세요', 'btn-negative', '[name=empPost]', 'left');
            $("[name=empPost]").focus();
            return false; 
        }
        
        if(!formState.empAddress1Valid) {
            showAjaxAlarm('기본주소를 입력하세요', 'btn-negative', '[name=empAddress1]', 'left');
            $("[name=empAddress1]").focus();
            return false; 
        }
        
        if(!formState.empAddress2Valid) {
            showAjaxAlarm('상세주소를 입력하세요', 'btn-negative', '[name=empAddress2]', 'left');
            $("[name=empAddress2]").focus();
            return false; 
        }

        return formState.ok();
    });
    
  	//유효성 검사 상태 객체
    var approveState = {
    	empConfirmValid: false,
    	ok: function(){
    		return Object.values(this)
    		.filter(v => typeof v==="boolean")
    		.every(v => v === true);
    	}
    };
  
    function checkApproveValidate() {
    	$(this).find("select[name]").trigger("input");
        $(this).find("input[name], textarea[name]").trigger("blur");
    	
        var hireDate = document.querySelector('[name="empHireDate"]');
        var deptNo = document.querySelector('[name="deptNo"]');
        var positionNo = document.querySelectorAll('[name="empPositionNo"]')[1];
        
        if (!hireDate.value.trim()) {
            openAlert("입사일을 지정해 주세요.", "$('[name=empHireDate]').focus();");
            return false; // 전송 중단
        }
        
        if (!deptNo.value) {
            openAlert("부서를 배치해 주세요.", "$('[name=deptNo]').select2('open');");
            return false;
        }
        
        if (!positionNo.value) {
            openAlert("직급을 지정해 주세요.", "$('[name=empPositionNo]:eq(1)').select2('open');");
            return false;
        }

        // 3개 모두 입력되었다면 마지막으로 확인받고 전송
        if(!approveState.empConfirmValid) {
        	openConfirm("해당 사원의 가입을 승인하시겠습니까?", "approveState.empConfirmValid = true; $('#btnEmpPopup').click();");
        	return false;
        }
        
        return approveState.ok();
    }
    
    var rejectState = {
    		rejectValid: false,
			ok: function(){
				return Object.values(this)
				.filter(v => typeof v==="boolean")
				.every(v => v === true);
			}
		};
    
    function rejectConfirm(empId) {
    	openConfirm('승인 거절하시겠습니까?', "rejectOk('" + empId + "');");
	}
    
    function rejectOk(empId) {
    	location.href = "reject?empId=" + empId;
    }
</script>

