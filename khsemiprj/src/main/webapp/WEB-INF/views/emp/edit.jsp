<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />

<!-- lightpick cdn -->
<link
	href="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/css/lightpick.min.css"
	rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/moment@2.30.1/moment.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/lightpick.min.js"></script>

<!-- jQuery CDN -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<!-- kakao postapi cdn -->
<script
	src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
$(function() {
    var state = {
       // empIdValid: true, id는 내 정보 수정에서는 못 바꾸는 거 같아 주석 했습니다.
        empNameValid: false,
        empEmailValid: false,
        empEmailCertValid: false, // 인증 통과했는지
        empBirthValid: false,
        empContactValid: false,
        empAddressValid: false,
        ok: function(){
            return Object.values(this)
            .filter(v => typeof v==="boolean")
            .every(v => v === true);
        }
    };
    
 var certFailCount = 0;//이메일 인증 횟수 초기화
    
    //날짜 선택기 생성
    var datePicker = new Lightpick({
        field: $("[name=empBirth]")[0],
        format: "YYYY-MM-DD",
        firstDay: 7,
        maxDate: moment(),//오늘까지
    });

    
    //이름은 형식 검사만
    $("[name=empName]").on("blur", function(){
        var regex = /^([가-힣a-zA-Z\.]{2,100})$/;
        var empName = $(this).val();
        var valid = regex.test(empName);
        
        $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
        state.empNameValid = valid;
    });
    
    //생일은 형식검사만
    $("[name=empBirth]").on("blur", function(){
        var regex = /^([0-9]{4})-(((02)-(0[1-9]|1[0-9]|2[0-9]))|((0[469]|11)-(0[1-9]|1[0-9]|2[0-9]|30))|((0[13578]|1[02])-(0[1-9]|1[0-9]|2[0-9]|3[01])))$/
        var empBirth = $(this).val();
        var valid = regex.test(empBirth);
        
        $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
        state.empBirthValid = valid;
    });
    
    //전화 번호는 형식검사만
    $("[name=empContact]").on("blur", function(){
        var regex = /^010[1-9][0-9]{7}$/;
        var empContact = $(this).val();
        var valid = regex.test(empContact);
        
        $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
        state.empContactValid = valid;
    });
    
    //주소 부분 시작
    $("[name=empAddress2]").on("blur", function () {
        var empPost = $("[name=empPost]").val();
        var empAddress1 = $("[name=empAddress1]").val();
        var empAddress2 = $("[name=empAddress2]").val();

        //address2의 리드온리 상태를 담고
        var stable =$(this).prop("readonly");
        
        //리드온리가 참이라면
        if(stable){
			$("[name=empPost],[name=empAddress1],[name=empAddress2]").removeClass("success fail")
			state.empAddressValid = true;//입력 가능한 상태로 만들기 위해서
			return;
        }
        
      
        var valid = empPost.length > 0 && empAddress1.length > 0 && empAddress2.length > 0;
       

        $("[name=empPost],[name=empAddress1],[name=empAddress2]")
            .removeClass("success fail").addClass(valid ? "success" : "fail");

        state.empAddressValid = valid;
    });
    
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

                //address2를 리드온리로 두고 새로운 우편번호 address1을 입력 해야만 리드온리를 풀어주고 빈칸으로 만들어줍니다.
                $("[name=empAddress2]").prop("readonly",false).val("")
                
                $(".btn-address-clear").fadeIn();
                $("[name=empAddress2]").trigger("focus");
            }
        }).open();
    });

    $(".btn-address-clear").on("click", function () {
        $("[name=empPost], [name=empAddress1], [name=empAddress2]")
            .val("").removeClass("success").addClass("fail");//클리어시 공백 때 fail 피드백을 나타내기위해 fail을 addclass했습니다.
        //클리어 버튼을 클릭 했을 시에 리드온리가 풀린 address2를 다시 리드온리로 바꾸고 공백으로 돌려 놓습니다.
        $("[name=empAddress2]").prop("readonly",true).val("")
        $(this).fadeOut();
    });

 
    //이메일 형식 및 중복 검사 
    $("[name=empEmail]").on("blur", function(){
        var regex = /^([a-z][a-z0-9]{4,19})@([A-Za-z0-9\-\.]{1,})(\.[a-z]{2,3})$/;
        var empEmail = $("[name=empEmail]").val(); 
        var valid = regex.test(empEmail); 
        
        if(valid == false){
            $("[name=empEmail]").removeClass("success fail")
                               .addClass("fail").attr("data-error","1");
            state.empEmailValid = false; 
            return;
        } 
        
        // 정규식 통과했으면 백엔드로 중복 검사 요청
        $.ajax({
            url: "/rest/cert/checkEmail",
            method: "post",
            data: { empEmail : empEmail }, 
            success: function (response){
                if(response === true){ 
                    $("[name=empEmail]").removeClass("success fail")
                                       .addClass("fail").attr("data-error","2");
                    state.empEmailValid = false; 
                }
                else { 
                    $("[name=empEmail]").removeClass("success fail")
                                       .addClass("success");
                    state.empEmailValid = true; 
                    $("[name=empEmail]").removeClass("success fail")
                }
            }
        });
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
		
 
    var sendRealEmail = function(empEmail) {
        
        var sendBtn = $(".btn-cert-send");
        var retryBtn = $(".btn-cert-retry");
        var emailInput = $("[name=empEmail]");
        var certArea = $(".cert-area");

        $.ajax({
            url: "/rest/cert/send",
            method: "post",
            data: { certEmail: empEmail },
            success: function() {
                var template = $("#cert-template").text();
                var content = $.parseHTML(template);
                certArea.html(content); 
                
                sendBtn.hide();  
                retryBtn.show(); 
            },
            error: function() {
                window.alert("이메일 발송에 실패했습니다.\n잠시 후 다시 시도해보세요");
            },
            beforeSend: function() {
                sendBtn.find("span").text("인증메일 발송중");
                sendBtn.find("i").removeClass("fa-envelope").addClass("fa-spinner fa-spin");
                sendBtn.prop("disabled", true);
                emailInput.prop("readonly", true);
            },
            complete: function() {
                sendBtn.find("span").text("인증메일 보내기");
                sendBtn.find("i").removeClass("fa-spinner fa-spin").addClass("fa-envelope");
                sendBtn.prop("disabled", false);
            }
        });
    };
    
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
                      .css("color", "red");
				        $(".field-cert").prop("disabled", true); // 입력창 막기
				        $(".btn-cert-check").prop("disabled", true); // 검사 버튼 막기
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
        state.empEmailValid = true;
        state.empEmailCertValid = false;
        
        certFailCount = 0;//0으로 초기화
        $(".cert-message").text(""); // 메시지 비우기

        $("[name=empEmail]").trigger("focus");//커서 옮김
    });

    // 폼검사
    $(".form-check").on("submit", function(e){
        $(this).find("input[name], textarea[name]").trigger("blur");
        
        if (!state.ok()) {
            e.preventDefault();
            window.alert("입력하신 정보를 다시 확인해주세요.");
        }
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

<div class="container w-600 mt-50 mb-50">
	<h1 class="left black mb-40">내 정보 수정</h1>

	<form action="edit" method="post" enctype="multipart/form-data">

		<div class="cell mt-30">
	        <div class="gray mb-10"><b>이름</b></div>
	        <input type="text" name="empName" class="field w-100" placeholder="기존 이름" value="${empDto.empName}">
	        <div class="success-feedback">사용 가능한 이름입니다.</div>
	        <div class="fail-feedback">한글 또는 영문 2~100자로 입력해주세요.</div>
	    </div>
		<div class="cell mt-30">
		    	<div class="gray mb-10"><b>이메일</b></div>
	    	<div class="flex-area" style="flex-wrap: wrap;">
		        <input type="text" name="empEmail" class="field flex-fill" inputmode="email">
		
		        <button type="button" class="btn btn-neutral btn-cert-send ms-10">
		             <i class="fa-solid fa-envelope"></i> <span>인증메일 보내기</span>
		        </button>
		        <button type="button" class="btn btn-negative btn-cert-retry ms-10" style="display: none;">
		            <i class="fa-solid fa-rotate-right"></i> <span>다시 인증하기</span>
		        </button>
		
		        <div class="success-feedback w-100 mt-5">사용 가능한 이메일입니다.</div>
	        <div class="fail-feedback w-100 mt-5"></div> </div>
	    </div>
	
		<!-- 인증번호 영역 -->
	    <div class="cell cert-area"></div>
	
	    <div class="cell">
	        <div class="gray mb-10"><b>생년월일</b></div> 
	        <input type="text" name="empBirth" class="field w-100" value="${empDto.empBirth}" readonly>
	        <div class="success-feedback">올바른 날짜 형식입니다.</div>
	        <div class="fail-feedback">올바른 날짜 형식이 아닙니다.</div>
	    </div>


		<div class="cell mt-30">
			<div class="gray mb-10">
				<b>주소</b>
			</div>
			<div class="flex-area mb-10">
				<input type="text" id="postcode" name="empPost"
					class="field w-200 me-10" value="${empDto.empPost}" readonly>
				<button type="button" class="btn btn-neutral btn-address-search">
					주소검색
				</button>
				<button type="button" class="btn btn-negative ms-10 btn-address-clear" style="display: none;">
                    <i class="fa-solid fa-xmark"></i>
                </button>
			</div>
			
			<div class="flex-area mb-10">
				<input type="text" id="basicAddress" name="empAddress1"
					class="field flex-fill w-100" value="${empDto.empAddress1}"
					readonly>
			</div>
			<div class="flex-area">
				<input type="text" id="detailAddress" name="empAddress2"
					class="field flex-fill w-100" value="${empDto.empAddress2}" data-origin="${empDto.empAddress2}"
					readonly>
			</div>
			
			<div class="gray mt-10" style="font-size: 13px;">* 주소를 변경하려면
				우편번호, 기본주소, 상세주소를 모두 입력해야 합니다.
				
			</div>
		</div>

		<div class="cell">
	        <label>개인 휴대전화 연락처 (대시(-)없이 입력 해 주세요)</label> 
	        <input type="text" inputmode="tel" name="empContact" class="field field-numeric w-100" value="${empDto.empContact}">
	        <div class="success-feedback">올바른 전화번호입니다.</div>
	        <div class="fail-feedback">올바른 전화번호 형식이 아닙니다.</div>
   		</div>


		<div class="cell mt-40">
			<label> <i class="fa-solid fa-image"></i> <span>클릭해서
					변경할 프로필 이미지를 선택하세요</span> <input type="file" name="attach"
				class="field w-100 preview-input" accept=".png, .jpg"
				style="display: none;">
			</label>
		</div>
		<div class="cell preview-area"></div>

		<div class="cell mt-50">
			<button type="submit" class="btn btn-positive w-100">수정하기</button>
		</div>

	</form>
</div>