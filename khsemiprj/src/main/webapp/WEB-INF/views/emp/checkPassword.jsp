<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />

<style>
.preview-area img {
    aspect-ratio: 1/1;
    border-radius: 50% !important;
}
        
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
    var state = {
        empPasswordValid: false
    };
	
    $("[name=empPassword]").on("blur", function(){
    	state.empPasswordValid = $(this).val().trim().length > 0;
    });
    
	var $failDiv = $("[name=empPassword]").siblings(".fail-feedback");
    $("#confirm").on("click", function(){
    	
    	var empPassword = $("[name=empPassword]").val();
    	if(empPassword.length==0){
    		$("[name=empPassword]").removeClass("fail");
    		$failDiv.text("비밀번호를 입력해주세요.");
    		return;
    	}
       

        $.ajax({
            url: "/rest/cert/checkPassword",
            method: "post",
            data: { empPassword: empPassword },
            success: function(response){
                if(response === true) {
                    $("[name=empPassword]").removeClass("fail").addClass("success");
                    
                    $(".server-error").hide();
                    $failDiv.text("");
                    state.empPasswordValid = true;
                    $(".check-form").trigger("submit");
                   
                } else {
                    $("[name=empPassword]").removeClass("success").addClass("fail");
                    $failDiv.text("비밀번호가 일치하지 않습니다.");
                    return state.empPasswordValid = false;
                }
            }
        });
    });
    
 // 폼 전송 시 최종 검사 (틀리면 아예 안 넘어가게 막기)
    $(".check-form").on("submit", function(e){
        $(this).find("[name=empPassword]").trigger("blur"); // 제출 전 마지막으로 검사 한 번 더!
        if(!state.empPasswordValid) {
            e.preventDefault();
        }
    });
	
    //togglebox에 대한 제어
    $(".togglebox").find("[type=checkbox]").on("input", function () {
        //this는 체크된 체크박스
        var check = $(this).prop("checked");//체크 여부를 확인해서
        $(".togglebox").find("[type=checkbox]").prop("checked", check);//전파하세요!

        $("[name=empPassword]")
            .attr("type", check ? "text" : "password");//체크되면 password, 아니면 text
    });

});
</script>


<div class="container w-500 mt-20 mb-50 background-card">
	<div class="cell center">
	
		<h1>비밀번호 확인</h1>
		
	</div>
	<form action="./checkPassword" method="post" autocomplete="off" class="check-form">
		<div class="cell">
	
			<div class="cell mt-40">
	
				<label>비밀번호 입력<i class="fa-solid fa-asterisk red"></i></label> <label
				class="togglebox"> <input type="checkbox"> 
				<i class="fa-solid fa-eye-slash red"></i> 
				<i class="fa-solid fa-eye blue"></i></label> 
				<input type="password" name="empPassword" class="field w-100">
	            <div class="fail-feedback"></div>
			</div>
	
	
			<div class="mt-50">
				<button type="button" id="confirm" class="btn btn-positive w-100">
					<i class="fa-solid fa-lock fa-fade"></i> <span>확인</span>
				</button>
			</div>
	
			<c:if test="${param.error != null}">
				<div class="cell red server-error">오류 : 비밀번호가 불일치합니다.</div>
			</c:if>
		</div>
	</form>
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp" />