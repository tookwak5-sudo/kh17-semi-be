<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<script>
	$(function() {
		// 인증 실패 횟수 카운트 변수 선언 (누락 수정)
		var certFailCount = 0; 
		
		//상태객체
		var state = {
				empEmailValid : false, // 초기값 false로 세팅 (검증 전이니까)
				empEmailCertValid : false,
				ok : function(){
                    return Object.values(this)
                    .filter(v => typeof v == "boolean")
                    .every(v => v == true);
                }
            }
		
		//이메일 형식 및 중복 검사 
	    $("[name=empEmail]").on("blur", function(){
	        var regex = /^([a-z][a-z0-9]{4,19})@([A-Za-z0-9\-\.]{1,})(\.[a-z]{2,3})$/;
	        var empEmail = $("[name=empEmail]").val(); 
	        var valid = regex.test(empEmail); 
	        
	        if(empEmail.length == 0) {
	        	$("[name=empEmail]").removeClass("success fail");
	        	state.empEmailValid = false;
	        	return;
	        }
	        
	        if(valid == false){
	            $("[name=empEmail]").removeClass("success fail")
	                               .addClass("fail").attr("data-error","1");
	            state.empEmailValid = false; 
	            return;
	        } 
	        
	        // 백엔드로 중복 검사 요청
	        $.ajax({
	            url: "/rest/cert/checkEmail",
	            method: "post",
	            data: { empEmail : empEmail }, 
	            success: function (response){
	            	// 이메일 존재할 때 (true)
	            	if(response === true){ 
	                    $("[name=empEmail]").removeClass("success fail")
	                                       .addClass("success");
	                    state.empEmailValid = true; 
	                }
	            	// 없을 때 (false)
	                else { 
	                	// 오타 수정: class를 false가 아니라 fail로 변경
	                    $("[name=empEmail]").removeClass("success fail")
	                                       .addClass("fail").attr("data-error","2");
	                    state.empEmailValid = false; 
	                }
	            }
	        });
	    });
		
		//인증메일 보내기 버튼
		$(".btn-cert-send").on("click", function(){
			var empEmail = $("[name=empEmail]").val();
			 if(state.empEmailValid == false) {
				 $("[name=empEmail]").trigger("blur");
				 return;
			 }

             $.ajax({
                 url:"/rest/cert/send",
                 method:"post",
                 data: { certEmail : empEmail },
                 success: function(){
                     var template = $("#cert-template").text();
                     var content = $.parseHTML(template);
                     $(".cert-area").html(content);
                     certFailCount = 0; // 메일 새로 보낼 때마다 카운트 초기화
                 },
                 error:function(){
                     window.alert("이메일 발송에 실패했습니다.\n잠시 후 다시 시도해보세요");
                 },
                 beforeSend:function(){
                     $(".btn-cert-send").find("span").text("인증메일 발송중");
                     $(".btn-cert-send").find("i").removeClass("fa-envelope")
                                     .addClass("fa-spinner fa-spin");
                     $(".btn-cert-send").prop("disabled", true);
                     $("[name=empEmail]").prop("readonly", true);
                 },
                 complete:function(){
                     $(".btn-cert-send").find("span").text("인증메일 보내기");
                     $(".btn-cert-send").find("i").removeClass("fa-spinner fa-spin")
                                     .addClass("fa-envelope");
                     $(".btn-cert-send").prop("disabled", false);
                 },
             });
		});
		
		//인증번호 검사 버튼
	    $(".cert-area").on("click", ".btn-cert-check", function(){
	        var certEmail = $("[name=empEmail]").val();
	        var certNumber = $(".field-cert").val();
	        var certRegex = /^[0-9]{6}$/;
	        var certValid = certRegex.test(certNumber);
	        
	        if(certValid == false) {
	            $(".field-cert").removeClass("success fail").addClass("fail");
	            $(".cert-message").text("인증번호 6자리를 올바르게 입력하세요.").css("color", "red");
	            return;
	        }
	        
	      $.ajax({
	          url:"/rest/cert/check",
	          method:"post",
	          data: { certEmail : certEmail , certNumber : certNumber },
	          success: function(response) {
	              if(response === true) {
	                  state.empEmailCertValid = true;
	                  $("[name=empEmail]").removeClass("success fail").addClass("success");
	                  $(".success-feedback.w-100").text("이메일 인증이 완료되었습니다.");
	                  $(".cert-area").empty();
	                  $(".btn-cert-send").hide();
	                  $(".btn-cert-retry").show();
	                  $("[name=empEmail]").prop("readonly", true);
	              }
	              else {
	                  state.empEmailCertValid = false;
	                  $(".field-cert").removeClass("success fail").addClass("fail");
	                  certFailCount++; // 이제 변수 선언되어서 정상 작동함
	                  
	                  if(certFailCount >= 5){
	                  	  $(".cert-message").text("인증번호를 5회 이상 틀렸습니다. 다시 인증번호를 전송 후 시도해주세요.")
	                      	.css("color", "red");
					      $(".field-cert").prop("disabled", true); 
					      $(".btn-cert-check").prop("disabled", true); 
	                  }
	                  else{
	                  	  $(".cert-message").text("인증번호가 일치하지 않습니다. (" + certFailCount + "/5회 오류)")
	                      	.css("color", "red");
	                  }
	              }
	          }
	       });
	    });
		
	     //다시 인증하기 버튼
	     $(".btn-cert-retry").on("click", function(){
	         $(".btn-cert-retry").hide();
	         $(".btn-cert-send").show();
	         $("[name=empEmail]").removeClass("success fail")
	                                 .prop("readonly", false).val("");
	         state.empEmailValid = false;
	         state.empEmailCertValid = false;
	         $(".success-feedback.w-100").text("이메일이 일치합니다."); // 문구 원상복구
	         $(".cert-area").empty();
	         $("[name=empEmail]").trigger("focus");
	     });
	     
	   //폼검사
       $(".form-check").on("submit", function(){
           $(this).find("input[name]").trigger("blur");
           return state.ok();
      	 });
	});
</script>

<!-- 인증번호 입력창 템플릿 -->
     <script type="text/template" id="cert-template">
        <div class="cert-wrapper flex-area" style="flex-wrap: wrap;">
            <input type="text" inputmode="numeric" class="field field-cert" 
                    placeholder="인증번호 입력" size="6" maxlength="6">
            <button type="button" class="btn btn-positive btn-cert-check ms-10">
                <i class="fa-solid fa-lock"></i>
                <span>인증번호 확인</span>
            </button>
            <div class="fail-feedback w-100">인증번호를 다시 확인해주세요</div>
        </div>
     </script>



<form action="./findPassword" method="post" autocomplete="off" class="form-check">
<div class="container w-600 mt-50 mb-50">
	<div class="cell center">
		<h1>비밀번호 찾기</h1>
	</div>
	<div class="cell">
		<label>아이디</label> <input type="text" name="empId" class="field w-100">
	</div>
	<div class="cell">
		<label>이름</label> <input type="text" name="empName" class="field w-100">
	</div>
	<div class="cell">
			<label>이메일</label>
	</div>
	<div class="cell mt-0 flex-area" style="flex-wrap: wrap;">
   			<input type="text" name="empEmail" class="field" inputmode="email">
   
   		<button type="button" class="btn btn-neutral btn-cert-send ms-10">
      			 <i class="fa-solid fa-envelope"></i> <span>인증메일 보내기</span>
  			</button>
   		<button type="button" class="btn btn-negative btn-cert-retry ms-10" style="display: none;">
       		<i class="fa-solid fa-rotate-right"></i> <span>다시 인증하기</span>
   		</button>

    		<div class="success-feedback w-100 mt-5">이메일이 일치합니다.</div>
   			<div class="fail-feedback w-100 mt-5">
       			<div class="fail-feedback-msg1">이메일이 형식에 맞지 않습니다.</div>
       			<div class="fail-feedback-msg2">이메일이 존재하지 않습니다.</div>
   			</div>
	</div>
       
       <!-- 인증번호 입력 영역 -->
       <div class="cell cert-area"></div>
	
	<div class="cell mt-50">
		<button type="submit" class="btn btn-positive w-100">
			<i class="fa-solid fa-lock"></i> <span>확인</span>
		</button>
	</div>
</div>
</form>
<div style="white-space: nowrap;">
	<c:if test="${param.error != null}">
		입력하신 정보는 없습니다
	</c:if>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>