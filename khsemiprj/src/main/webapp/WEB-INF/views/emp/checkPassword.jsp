<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />


<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
$(function() {
    var state = {
        empPasswordValid: false
    };

    $("[name=empPassword]").on("blur", function(){
        var empPassword = $(this).val();
        var $failDiv = $(this).siblings(".fail-feedback");

        $.ajax({
            url: "/rest/cert/checkPassword",
            method: "post",
            data: { empPassword: empPassword },
            success: function(response){
                if(response === true) {
                    $("[name=empPassword]").removeClass("success fail").addClass("success");
                    state.empPasswordValid = true;
                    $(".server-error").hide();
                } else {
                    $("[name=empPassword]").removeClass("success fail").addClass("fail");
                    $failDiv.text("비밀번호가 일치하지 않습니다.");
                    state.empPasswordValid = false;
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
});
</script>


<div class="container w-500 mt-50 mb-50">
	<div class="cell center">
	
		<h1>비밀번호 확인</h1>
		
	</div>
	<form action="./checkPassword" method="post" autocomplete="off" class="check-form">
		<div class="cell">
	
			<div class="cell mt-40">
	
				<label>비밀번호 입력</label> 
				<input type="password" name="empPassword" class="field w-100">
				<div class="success-feedback">비밀번호가 확인되었습니다.</div>
	            <div class="fail-feedback"></div>
			</div>
	
	
			<div class="mt-50">
				<button type="submit" class="btn btn-positive w-100">
					<i class="fa-solid fa-lock fa-fade"></i> <span>확인</span>
				</button>
			</div>
	
			<c:if test="${param.error != null}">
				<div class="cell red server-error">오류 : 비밀번호가 불일치합니다.</div>
			</c:if>
		</div>
	</form>
</div>