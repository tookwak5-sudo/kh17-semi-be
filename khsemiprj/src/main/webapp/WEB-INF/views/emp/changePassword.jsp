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
</style>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script>
$(function() {
	
	var state ={
			empOriginPasswordValid: false,
			empNewPasswordValid: false,
			empNewPasswordCheckValid: false,
	}
    // /emp/join이나 /emp/edit의 비밀번호 설정 방식을 차용 할 예정이라
    // 밑 부분은 일단 주석 처리 했습니다.
	
//     $(".password-check").on("submit", function() {
//         var currentPw = $("[name=empPassword]").val();
//         var newPw = $("[name=newPassword]").val();
//         var newPwCheck = $("#newPasswordCheck").val();

//         if(currentPw.length == 0) {
//             window.alert("현재 비밀번호를 입력해주세요.");
//             return false;
//         }
//         if(newPw.length == 0) {
//             window.alert("새로운 비밀번호를 입력해주세요.");
//             return false;
//         }
//         if(newPw === currentPw) {
//             window.alert("현재 비밀번호와 동일한 비밀번호로 변경할 수 없습니다.");
//             return false;
//         }
//         if(newPw !== newPwCheck) {
//             window.alert("새로운 비밀번호와 비밀번호 확인이 일치하지 않습니다.");
//             return false;
//         }
        
//         return true;
//     });
    
    $("[name=empOriginPassword]").on("blur",function(){
    	var empOriginPassword = $("[name=empOriginPassword]").val()
    	
    	//정규식
    	var regex1 = /^[A-Za-z0-9!\@\#\$\%\^\&\*\(\)\-\_\=\+\{\}\'\"`~\<\>\.\,\/\?\\\|]{8,16}$/;
    	var regex2 =/[A-Z]+/;
    	var regex3 =/[a-z]+/;
    	var regex4 =/[0-9]+/;
    	
    	//정규식 하나로
    	var valid = regex1.test(empOriginPassword)
    			 && regex2.test(empOriginPassword)
    			 && regex3.test(empOriginPassword)
    			 && regex4.test(empOriginPassword);
    	
    	//정규식을 통한 걸러내기
    	if(valid == false){
    		$("[name=empOriginPassword]").removeClass("success fail")
    		.addClass("fail").attr("data-error","1");
    		state.empOriginPasswordValid = false;
    		return;
    	}
    	
    	//걸러냈으면 입력값과 실제 비번이 같은지 대조
    	$.ajax({
    		url:"/rest/cert/checkPassword",
    		method:"post",
    		data:{empPassword : empOriginPassword},
    		success: function (response){
    			//같으면 성공시키고
    			if(response){
    				$("[name=empOriginPassword]").removeClass("success fail")
    					.addClass("success")
    					state.empOriginPasswordValid = true;
    			}
    			//다르면 false로
    			else{
    				$("[name=empOriginPassword]").removeClass("success fail")
    						.addClass("fail")
    						.attr("data-error","2");
    				state.empOriginPasswordValid = false;
    			}
    		}
    	})
    })
    
    //새 비번과 새 비번 확인 대조  
    $("[name=empNewPassword], .password-check").on("blur",function(){
   				var empNewPassword = $("[name=empNewPassword]").val()
   				var empOriginPassword = $("[name=empOriginPassword]").val(); 
        		var $failDiv = $("[name=empNewPassword]").siblings(".fail-feedback");
    				    	
    			var regex1 = /^[A-Za-z0-9!\@\#\$\%\^\&\*\(\)\-\_\=\+\{\}\'\"`~\<\>\.\,\/\?\\\|]{8,16}$/;
    			var regex2 =/[A-Z]+/;
    			var regex3 =/[a-z]+/;
    			var regex4 =/[0-9]+/;
    				    	
    			isValidFormat = regex1.test(empNewPassword)
    				    			 && regex2.test(empNewPassword)
    				    			 && regex3.test(empNewPassword)
    				    			 && regex4.test(empNewPassword);
    				   
    			//정규식 판정
    	        if (isValidFormat == false) {
    	            $("[name=empNewPassword]").removeClass("success fail").addClass("fail");
    	            $failDiv.text("영문 대/소문자, 숫자, 특수문자를 1개이상 포함하여 8~16글자로 작성하세요.");
    	            state.empNewPasswordValid = false;
    	            return; 
    	        } 
    	        
    	        //기존 비밀번호와 같은지
    	        if (empNewPassword === empOriginPassword) {
    	            $("[name=empNewPassword]").removeClass("success fail").addClass("fail");
    	            $failDiv.text("현재 비밀번호와 동일한 비밀번호로 변경할 수 없습니다.");
    	            state.empNewPasswordValid = false;
    	            return; // 튕겨냄
    	        } 
    	        
    	        //다 통과했다면 성공
    	        $("[name=empNewPassword]").removeClass("success fail").addClass("success");
    	        state.empNewPasswordValid = true;
    	        
    	        // 새 비번 확인란 대조
    	        var checkVal = $("[name=empNewPasswordCheck]").val();
    	        state.empNewPasswordCheckValid = (empNewPassword.length > 0 && empNewPassword === checkVal);
    	        $("[name=empNewPasswordCheck]").removeClass("success fail")
    	                            .addClass(state.empNewPasswordCheckValid ? "success" : "fail");
    	    });
    	    		
    	    // 토글박스 동기화
    	    $(".togglebox").find("[type=checkbox]").on("input", function () {
    	        var check = $(this).prop("checked");
    	        $(".togglebox").find("[type=checkbox]").prop("checked", check);
    	        $("[name=empOriginPassword], [name=empNewPassword], [name=empNewPasswordCheck]").attr("type", check ? "text" : "password");
    	    });
    	    
    	    // (보너스) 최종 폼 전송 시, 3가지가 전부 true가 아니면 전송 막기
    	    $(".password-check").on("submit", function(e) {
    	        if (!state.empOriginPasswordValid || !state.empNewPasswordValid || !state.empNewPasswordCheckValid) {
    	            e.preventDefault();
    	            window.alert("비밀번호 형식을 다시 확인해주세요.");
    	        }
    	    });
});

// /emp/join , /emp/edit와의 통일성을 위하여 토글박스를 가져왔습니다.


</script>

<form action="./changePassword" method="post" autocomplete="off" class="password-check">
    <div class="container w-500 mt-50 mb-50">
        <div class="cell center">
            <h1>비밀번호 변경</h1>
        </div>

<!-- 혹시 몰라 원래 코드는 주석 처리 해놨습니다. -->

<%--         <c:if test="${param.error != null}"> --%>
<!--             <div class="cell center" style="color: red; font-weight: bold;"> -->
<!--                 현재 비밀번호가 일치하지 않습니다. 다시 확인해주세요. -->
<!--             </div> -->
<%--         </c:if> --%>

<!--         <div class="cell"> -->
<!--             <label>현재 비밀번호</label> -->
<!--             <input type="password" name="empPassword" class="field w-100" placeholder="현재 비밀번호 입력"> -->
<!--         </div> -->

<!--         <div class="cell"> -->
<!--             <label>새로운 비밀번호</label> -->
<!--             <input type="password" name="newPassword" class="field w-100" placeholder="새로운 비밀번호 입력"> -->
<!--         </div> -->

<!--         <div class="cell"> -->
<!--             <label>새로운 비밀번호 확인</label> -->
<!--             <input type="password" id="newPasswordCheck" class="field w-100" placeholder="새로운 비밀번호 다시 입력"> -->
<!--         </div> -->
			
			<div class="cell">
			<label>현재 비밀번호 입력</label> <label
				class="togglebox"> <input type="checkbox"> <i
				class="fa-solid fa-eye-slash red"></i> <i
				class="fa-solid fa-eye blue"></i>
			</label> <input type="password" name="empOriginPassword" class="field w-100">
			<div class="success-feedback">올바른 비밀 번호 입니다.</div>
			<div class="fail-feedback"></div>
			</div>
			
			
			<div class="cell">
			<label>새로운 비밀번호 입력</label> <label
				class="togglebox"> <input type="checkbox"> <i
				class="fa-solid fa-eye-slash red"></i> <i
				class="fa-solid fa-eye blue"></i>
			</label> <input type="password" name="empNewPassword" class="field w-100 empNewPassword">
				<div class="success-feedback">올바른 비밀 번호 입니다.</div>
			<div class="fail-feedback"></div>
		</div>
	
		<div class="cell">
			<label>새로운 비밀번호 확인</label> <label
				class="togglebox"> <input type="checkbox"> <i
				class="fa-solid fa-eye-slash red"></i> <i
				class="fa-solid fa-eye blue"></i>
			</label> <input type="password" name="empNewPasswordCheck" class="field w-100 password-check">
				<div class="success-feedback">비밀번호가 일치합니다.</div>
			<div class="fail-feedback">비밀번호가 공란이거나 일치하지 않습니다</div>
		</div>	

        <div class="cell mt-30">
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