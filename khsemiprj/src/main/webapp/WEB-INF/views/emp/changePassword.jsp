<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />

<style>

/* togglebox 디자인 */
.togglebox {
	cursor: pointer;
}

.togglebox>[type=checkbox], /*체크박스*/ .togglebox>[type=checkbox] ~.fa-eye,
	/*평상시 체크박스 뒤 눈표시*/ .togglebox>[type=checkbox]:checked ~.fa-eye-slash
	/*체크되었을 때 눈가림 표시*/ {
	display: none;
}

.togglebox>[type=checkbox]:checked ~.fa-eye, /*체크되었을 때 눈 표시*/ .togglebox>[type=checkbox]
	 ~.fa-eye-slash /*평상시 체크박스 뒤 눈가림 표시*/ {
	display: inline;
}

.password-change-form input.field.success,
.password-change-form input.field.fail {
    transition: none !important; 
    background-repeat: no-repeat !important;
    background-position: right 12px center !important;
    background-size: 16px 16px !important;
    padding-right: 40px !important;
}
</style>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
$(function() {
	
	var state ={
			empPasswordValid: false, 
			newPasswordValid: false,
			newPasswordCheckValid: false,
	}
	
	// 정규식 하나로 통합
	var passwordRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_=+{}\[\]"';:?><.,/\\|~`-]).{8,16}$/;
	
	// 1. 현재 비밀번호 검증 및 분기 처리
	$("[name=empPassword]").on("input blur", function(e){
		var empPassword = $(this).val();
		
		// 입력값이 없을 때 숨김 처리
		if(empPassword.length == 0) {
			$(this).removeClass("success fail").removeAttr("data-error");
			state.empPasswordValid = false;
			hideNewPasswordFields();
			return;
		}
		
		// 정규식 검사 틀렸을 때 숨김 처리
		if(!passwordRegex.test(empPassword)){
			// 정규식과 안 맞고 다른 곳을 클릭 했을 때 실패 피드백
			if(e.type==="blur"){
				$("[name=empPassword]").removeClass("success fail")
				.addClass("fail").attr("data-error","1");	
			}
			state.empPasswordValid = false;
			hideNewPasswordFields();
			return;
		}
		
		// DB 대조
		$.ajax({
			url:"/rest/cert/checkPassword",
			method:"post",
			data:{empPassword : empPassword},
			success: function (response){
				if(response){
					$("[name=empPassword]").removeClass("success fail")
						.addClass("success").removeAttr("data-error");
					state.empPasswordValid = true;
					
					
					$(".step-2").slideDown(300);
				}
				else{
					if(e.type==="blur"){
						$("[name=empPassword]").removeClass("success fail")
						.addClass("fail")
						.attr("data-error","2");
					}
					state.empPasswordValid = false;
					hideNewPasswordFields();
				}
			}
		});
	});
	
	// 새 비밀번호 창 숨기고 초기
	function hideNewPasswordFields() {
		$(".step-2").slideUp(300);
		$("[name=newPassword], [name=newPasswordCheck]").val('').removeClass("success fail");
		state.newPasswordValid = false;
		state.newPasswordCheckValid = false;
	}
	
	// 2. 새 비밀번호 및 확인 검증
	$("[name=newPassword], [name=newPasswordCheck]").on("input blur", function(){
		var newPassword = $("[name=newPassword]").val();
		var newPasswordCheck = $("[name=newPasswordCheck]").val();
			
		// 새 비밀번호 유효성 검사
		if(newPassword.length > 0) {
			state.newPasswordValid = passwordRegex.test(newPassword);
			$("[name=newPassword]").removeClass("success fail")
				.addClass(state.newPasswordValid ? "success" : "fail");
		} else {
			$("[name=newPassword]").removeClass("success fail");
		}
				
		// 새 비밀번호 확인 검사
		if(newPasswordCheck.length > 0) {
			state.newPasswordCheckValid = (newPassword == newPasswordCheck);
			$("[name=newPasswordCheck]").removeClass("success fail")
				.addClass(state.newPasswordCheckValid ? "success" : "fail");
		} else {
			$("[name=newPasswordCheck]").removeClass("success fail");
		}
	});
		
	// 3. 비밀번호 보이기/숨기기 토글
	$(".togglebox").find("[type=checkbox]").on("input", function () {
		var check = $(this).prop("checked");
		// 모든 토글박스 상태 동기화
		$(".togglebox").find("[type=checkbox]").prop("checked", check);

		$("[name=empPassword], [name=newPassword], [name=newPasswordCheck]")
			.attr("type", check ? "text" : "password");
	});

	// 4. Form 전송 차단 로직
	$(".password-change-form").on("submit", function() {
		if(!state.empPasswordValid || !state.newPasswordValid || !state.newPasswordCheckValid) {
			alert("입력 항목을 다시 확인해주세요.");
			return false;
		}
		return true;
	});
});
</script>
<form action="./changePassword" method="post" autocomplete="off" class="password-change-form">
	<div class="container w-500 mt-50 mb-50">
		<div class="cell center">
			<h1>비밀번호 변경</h1>
		</div>
			

			
		<div class="cell">
			<label>현재 비밀번호 입력 <i class="fa-solid fa-asterisk red"></i></label> 
			<label class="togglebox"> 
				<input type="checkbox"> 
				<i class="fa-solid fa-eye-slash red"></i> 
				<i class="fa-solid fa-eye blue"></i>
			</label> 
			<input type="password" name="empPassword" class="field w-100">
			<div class="success-feedback">올바른 비밀 번호 입니다.</div>
			<div class="fail-feedback data-error-2">입력하신 비밀번호와 등록된 비밀번호가 다릅니다.</div>
		</div>
			
		<div class="cell step-2" style="display: none;">
			<label>새로운 비밀번호 입력 <i class="fa-solid fa-asterisk red"></i></label> 
			<label class="togglebox"> 
				<input type="checkbox"> 
				<i class="fa-solid fa-eye-slash red"></i> 
				<i class="fa-solid fa-eye blue"></i>
			</label> 
			<input type="password" name="newPassword" class="field w-100">
			<div class="success-feedback">올바른 비밀 번호 입니다.</div>
			<div class="fail-feedback">영문 대/소문자, 숫자, 특수문자를 1개이상 포함하여 8~16글자로 작성하세요</div>
		</div>
	
		<div class="cell step-2" style="display: none;">
			<label>새로운 비밀번호 확인 <i class="fa-solid fa-asterisk red"></i></label> 
			<label class="togglebox"> 
				<input type="checkbox"> 
				<i class="fa-solid fa-eye-slash red"></i> 
				<i class="fa-solid fa-eye blue"></i>
			</label> 
			<input type="password" name="newPasswordCheck" class="field w-100">
			<div class="success-feedback">비밀번호가 일치합니다.</div>
			<div class="fail-feedback">비밀번호가 공란이거나 일치하지 않습니다</div>
		</div>	

		<div class="cell mt-30 step-2" style="display: none;">
			<button type="submit" class="btn btn-positive w-100 finshModify">
				<i class="fa-solid fa-key"></i> <span>비밀번호 변경하기</span>
			</button>
		</div>
		
		<div class="cell center mt-10">
			<a href="./mypage" class="link">취소하고 마이페이지로 돌아가기</a>
		</div>
	</div>
</form>
<jsp:include page="/WEB-INF/views/template/footer.jsp" />