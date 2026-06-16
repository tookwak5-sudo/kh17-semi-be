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
				empIdValid: false,
				empNameValid: false,
				empEmailValid : false,
				empEmailCertValid : false,//인증 통과했는지
				ok : function(){
                    return Object.values(this)
                    .filter(v => typeof v == "boolean")
                    .every(v => v == true);
                }
            }
		
		var certFailCount = 0;//이메일 인증 횟수 초기화
		
		//형식 검사만
	    $("[name=empId]").on("blur",function(){
	        var regex =/^[a-z][a-z0-9]{4,19}$/;
	        var empId = $("[name=empId]").val();
	        var valid = regex.test(empId); 
	        if(valid == false){
	            $("[name=empId]").removeClass("success fail").addClass("fail")
	            state.empIdValid = false;
	            return;
	        } 
	        else{
	        	$("[name=empId]").removeClass("success fail").addClass("success");
	    		state.empIdValid=true;
	        }
	    });	
		
	  	//이름은 형식 검사만
	    $("[name=empName]").on("blur",function(){
	    	var regex =/^([가-힣a-zA-Z\.]{2,100})$/;
	    	var empName = $("[name=empName]").val();
	    	var valid = regex.test(empName);
	    	if(valid == false){
	    		$("[name=empName]").removeClass("success fail").addClass("fail")
	    		state.empNameValid = false;
	    		return;
	    	} 
	    	
	    	else{
	    		$("[name=empName]").removeClass("success fail").addClass("success");
	    		state.empNameValid=true;
	    	}
	    });
	  
	  	//이메일 형식검사 
	    $("[name=empEmail]").on("blur", function(){
	        var regex = /^([a-z][a-z0-9]{4,19})@([A-Za-z0-9\-\.]{1,})(\.[a-z]{2,3})$/;
	        var empEmail = $("[name=empEmail]").val(); 
	        var valid = regex.test(empEmail); 
	        
	        if(valid == false){
	            $("[name=empEmail]").removeClass("success fail").addClass("fail");
	            state.empEmailValid = false; 
	            return;
	        } 
	        else{
	    		$("[name=empEmail]").removeClass("success fail");
	    		state.empEmailValid = true;
	    	}
	    });
		
		
		
	  //인증메일 보내기 버튼(.btn-cert-send)
  		$(".btn-cert-send").on("click", function(){
  			var empEmail = $("[name=empEmail]").val();
  			 if(state.empEmailValid == false) return;

               $.ajax({
                   url:"/rest/cert/send",
                   method:"post",
                   data: { certEmail : empEmail },
                   success: function(){//성공 시 실행될 함수
                       var template = $("#cert-template").text();
                       var content = $.parseHTML(template);
                       $(".cert-area").html(content);
                       $(".btn-cert-send").hide();//전송버튼 숨김
                       $(".btn-cert-retry").show();
                   },
                   error:function(){//실패 시 실행될 함수
                       window.alert("이메일 발송에 실패했습니다.\n잠시 후 다시 시도해보세요");
                   },
                   
                   beforeSend:function(){//요청 시작 직전에 실행되는 함수 (디자인 변화를 부여)
                       $(".btn-cert-send").find("span").text("인증메일 발송중");
                       $(".btn-cert-send").find("i").removeClass("fa-envelope")
                                       .addClass("fa-spinner fa-spin");
                       $(".btn-cert-send").prop("disabled", true);

                       //입력창을 더이상 고치지 못하도록 잠금처리
                       $("[name=empEmail]").prop("readonly", true);
                   },
                   complete:function(){//성공/실패 관계없이 끝나면 실행되는 함수 (디자인 변화를 제거)
                       $(".btn-cert-send").find("span").text("인증메일 보내기");
                       $(".btn-cert-send").find("i").removeClass("fa-spinner fa-spin")
                                       .addClass("fa-envelope");
                       $(".btn-cert-send").prop("disabled", false);
                   },
               });
  		});
		
  	//인증번호 검사 버튼(.btn-cert-check)을 누르면 ajax요청을 보내 번호 진위를 확인
        //- 이 버튼은 언제 생길지 모르는 동적 화면
        $(".cert-area").on("click", ".btn-cert-check", function(){//가능
            //이메일과 인증번호를 구해와서 ajax 요청을 보낸 뒤 응답에 따른 처리를 구현
            var certEmail = $("[name=empEmail]").val();

            var certNumber = $(".field-cert").val();
            var certRegex = /^[0-9]{6}$/;
            var certValid = certRegex.test(certNumber);
            if(certValid == false) {//인증번호가 형식에 맞지 않으면
                return;
            }
            
          $.ajax({
              url:"/rest/cert/check",
              method:"post",
              data: { certEmail : certEmail , certNumber : certNumber },
              success: function(response) {//response는 true 아니면 false
                  if(response === true) {//결과가 정확히 true라면 → 이메일에 success처리, 인증화면삭제
                      state.empEmailCertValid = true;
                      $("[name=empEmail]").removeClass("success fail").addClass("success");
                      $(".success-feedback.w-100").text("이메일 인증이 완료되었습니다.");
                      $(".cert-area").empty();
                      $(".btn-cert-send").hide();//전송버튼 숨김
                      $(".btn-cert-retry").show();
                      $("[name=empEmail]").prop("readonly", true);
                  }
                  else {
                      state.empEmailCertValid = false;
                      $(".field-cert").addClass("fail");
                      certFailCount++;
                      
                      if(certFailCount>= 5){
                      	$(".cert-message").text("인증번호를 5회 이상 틀렸습니다. 다시 인증번호를 전송 후 시도해주세요.")
                          .css("color", "#d63031");
					        $(".field-cert").prop("disabled", true); // 입력창 막기
					        $(".btn-cert-check").prop("disabled", true); // 검사 버튼 막기
                      }
                      else{
                      	$(".cert-message").text("인증번호가 일치하지 않습니다. (" + certFailCount + "/5회 오류)")
                          .css("color", "#d63031");
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
	         state.empEmailValid = true;
	         state.empEmailCertValid = false;
	         
	         certFailCount = 0;//0으로 초기화
	         $(".cert-message").text(""); // 메시지 비우기
	
	         $("[name=empEmail]").trigger("focus");//커서 옮김
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
            <input type="text" inputmode="numeric" class="field field-ph field-cert" 
                    placeholder="인증번호 입력" size="6" maxlength="6">
            <button type="button" class="btn btn-positive btn-cert-check ms-10">
                <i class="fa-solid fa-lock"></i>
                <span>인증번호 확인</span>
            </button>
			<div class="cert-message w-100"></div>
            <div class="fail-feedback w-100">인증번호를 다시 확인해주세요</div>
        </div>
</script>



<form action="./findPassword" method="post" autocomplete="off" class="form-check">
<div class="container w-600 mt-50 mb-50">
	<div class="cell center">
		<h1>비밀번호 찾기</h1>
	</div>
	
	<div class="cell">
		<label>아이디</label> <input
			type="text" name="empId" class="field w-100">
		<div class="fail-feedback">아이디 형식에 맞지 않습니다.</div>
	</div>
	
	<div class="cell">
		<label>이름</label> <input type="text" name="empName" class="field w-100">
	</div>
	
	<div class="cell">
			<label>이메일</label>
	</div>
	<div class="cell mt-0 flex-area" style="flex-wrap: wrap;">
		<input type="text" name="empEmail" class="field field-sm" inputmode="email">

		<button type="button" class="btn btn-neutral btn-cert-send ms-10">
			<i class="fa-solid fa-envelope"></i> <span>인증메일 보내기</span>
		</button>
		<button type="button" class="btn btn-negative btn-cert-retry ms-10"
			style="display: none;">
			<i class="fa-solid fa-rotate-right"></i> <span>다시 인증하기</span>
		</button>

		<div class="success-feedback w-100 mt-5"></div>
		<div class="fail-feedback w-100 mt-5">
			<div>이메일이 형식에 맞지 않습니다.</div>
		</div>
	</div>
       
       <!-- 인증번호 입력 영역 -->
    <div class="cell cert-area"></div>
	
	<div class="cell mt-50">
		<button type="submit" class="btn btn-positive w-100">
			<i class="fa-solid fa-lock"></i> <span>확인</span>
		</button>
	</div>
	<div class="red" style="white-space: nowrap;">
		<c:if test="${param.error != null}">
			입력하신 정보는 존재하지않습니다
		</c:if>
	</div>
</div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>