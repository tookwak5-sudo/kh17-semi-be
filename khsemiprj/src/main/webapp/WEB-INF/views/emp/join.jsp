<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<!--     <script src="./preview.js"></script> -->

<!-- kakao postapi cdn -->
<script
	src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
$(function() {
    var state = {
        empIdValid: false,//형식 검사 반영
        empNameValid: false,//형식 검사 반영
        empPasswordValid: false,
        empPasswordCheckValid: false,
        empEmailValid: false,//형식검사 들어가면 밑도 위에도 false로 바꾸기
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

    //형식 검사
    $("[name=empId]").on("blur",function(){
        var regex =/^[a-z][a-z0-9]{4,19}$/;
        var empId = $("[name=empId]").val();
        var valid = regex.test(empId); 
        if(valid == false){
            $("[name=empId]").removeClass("success fail")
            .addClass("fail").attr("data-error","1");
            state.empIdValid = false;
            return;
        } 
        
        //id 중복 검사
        
        $.ajax({
        	url:"/rest/cert/checkId",
        	method:"post",
        	data:{empId : empId},
        	success: function (response){
        		if(response){
        			$("[name=empId]").removeClass("success fail")
        					.addClass("fail")
        					.attr("data-error","2");
        			state.empIdValid = false;
        		}
        		else{
        			$("[name=empId]").removeClass("success fail")
        					.addClass("success");
        			state.empIdValid = true;
        		}
        	}
        })
    });	
    
    //이름은 형식 검사만
    $("[name=empName]").on("blur",function(){
    	var regex =/^([가-힣a-zA-Z\.]{2,100})$/;
    	var empName = $("[name=empName]").val();
    	var valid = regex.test(empName);
    	if(valid == false){
    		$("[name=empName]").removeClass("success fail")
    		.addClass("fail").attr("data-error","1");
    		state.empNameValid = false;
    		return;
    	} 
    	
    	else{
    		$("[name=empName]").removeClass("success fail").addClass("success");
    		state.empNameValid=true;
    	}
    });
    
    //생일은 형식검사만
    $("[name=empBirth]").on("blur",function(){
    	var regex = /^([0-9]{4})-(((02)-(0[1-9]|1[0-9]|2[0-9]))|((0[469]|11)-(0[1-9]|1[0-9]|2[0-9]|30))|((0[13578]|1[02])-(0[1-9]|1[0-9]|2[0-9]|3[01])))$/
    	var empBirth = $("[name=empBirth]").val();
    	var valid = regex.test(empBirth);
    	if(valid == false){
    		$("[name=empBirth]").removeClass("success fail")
    		.addClass("fail").attr("data-error","1");
    		state.empBirthValid = false;
    		return;
    	}
    	
    	else{
    		$("[name=empBirth]").removeClass("success fail").addClass("success");
    		state.empBirthValid = true;
    	}
    });
    
    //전화 번호는 형식검사만
    $("[name=empContact]").on("blur",function(){
    	var regex = /^010[1-9][0-9]{7}$/
    	var empContact = $("[name=empContact]").val();
    	var valid = regex.test(empContact);
    	if(valid == false){
    		$("[name=empContact]").removeClass("success fail")
    		.addClass("fail").attr("data-error","1");
    		state.empContactValid = false;
    		return;
    	}
    	
    	else{
    		$("[name=empContact]").removeClass("success fail").addClass("success");
    		state.empContactValid = true;
    	}
    });
    
    //비밀번호 형식검사와 중복 검사
    $("[name=empPassword], .password-check").on("blur",function(){
    	var empPassword = $("[name=empPassword]").val()
    	
		var regex1 = /^[A-Za-z0-9!\@\#\$\%\^\&\*\(\)\-\_\=\+\{\}\'\"`~\<\>\.\,\/\?\\\|]{8,16}$/;
    	var regex2 =/[A-Z]+/;
    	var regex3 =/[a-z]+/;
    	var regex4 =/[0-9]+/;
    	
    	state.empPasswordValid = regex1.test(empPassword)
    			 && regex2.test(empPassword)
    			 && regex3.test(empPassword)
    			 && regex4.test(empPassword);
   
    		$("[name=empPassword]").removeClass("success fail")
    		.addClass(state.empPasswordValid ? "success" : "fail");
    		
    	state.empPasswordCheckValid = $("[name=empPassword]").val().length > 0 &&
    		$("[name=empPassword]").val() == $(".password-check").val();
    	$(".password-check").removeClass("success fail")
    		.addClass(state.empPasswordCheckValid ? "success" : "fail");
    })
    
    //주소 부분 시작
    $("[name=empAddress2]").on("blur", function () {
        var empPost = $("[name=empPost]").val();
        var empAddress1 = $("[name=empAddress1]").val();
        var empAddress2 = $("[name=empAddress2]").val();
        
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

                $(".btn-address-clear").fadeIn();
                $("[name=empAddress2]").trigger("focus");
            }
        }).open();
    });

    $(".btn-address-clear").on("click", function () {
        $("[name=empPost], [name=empAddress1], [name=empAddress2]")
            .val("").removeClass("success fail");
        state.empAddressValid = true;
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
	     
	     //기타 유틸
         //- 숫자 전용 입력창
         $(".field.field-numeric").on("input", function () {
             var regex = /[^0-9]/g;//양의 정수만 가능
             var origin = $(this).val()           
             var replacement = origin.replace(regex, "");
             $(this).val(replacement);
         });

         //togglebox에 대한 제어
         $(".togglebox").find("[type=checkbox]").on("input", function () {
             //this는 체크된 체크박스
             var check = $(this).prop("checked");//체크 여부를 확인해서
             $(".togglebox").find("[type=checkbox]").prop("checked", check);//전파하세요!

             $("[name=empPassword], .password-check")
                 .attr("type", check ? "text" : "password");//체크되면 password, 아니면 text
         });
	     
	   //폼검사
	       $(".form-check").on("submit", function(){
	           $(this).find("select[name]").trigger("input");
	           $(this).find("input[name], textarea[name]").trigger("blur");
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
			<div class="cert-message w-100"></div>
            <div class="fail-feedback w-100">인증번호를 다시 확인해주세요</div>
        </div>
     </script>

<form action="./join" method="post" enctype="multipart/form-data"
	autocomplete="off" class="form-check">
	<div class="container w-600 mt-50 mb-50">
		<div class="cell center">
			<h1>회원 가입</h1>
		</div>

		<div class="cell">
			<label>아이디<i class="fa-solid fa-asterisk red"></i></label> <input
				type="text" name="empId" class="field w-100">
			<div class="success-feedback">사용 가능한 아이디입니다.</div>
			<div class="fail-feedback">
				<div>아이디는 영어소문자로 시작하고 영어나 숫자를 혼합한 4자이상 20자이하입니다.</div>
				<div>이미 사용중인 아이디입니다.</div>
			</div>
		</div>



		<div class="cell">
			<label>비밀번호 <i class="fa-solid fa-asterisk red"></i></label> <label
				class="togglebox"> <input type="checkbox"> <i
				class="fa-solid fa-eye-slash red"></i> <i
				class="fa-solid fa-eye blue"></i>
			</label> <input type="password" name="empPassword" class="field w-100">
			<div class="success-feedback">올바른 비밀 번호 입니다.</div>
			<div class="fail-feedback">영문 대/소문자, 숫자, 특수문자를 1개이상 포함하여
				8~16글자로 작성하세요</div>
		</div>

		<div class="cell">
			<label>비밀번호 확인 <i class="fa-solid fa-asterisk red"></i></label> <label
				class="togglebox"> <input type="checkbox"> <i
				class="fa-solid fa-eye-slash red"></i> <i
				class="fa-solid fa-eye blue"></i>
			</label> <input type="password" class="field w-100 password-check">
			<div class="success-feedback">비밀번호가 일치합니다</div>
			<div class="fail-feedback">비밀번호가 공란이거나 일치하지 않습니다</div>
		</div>


		<div class="cell">
			<label>이메일<i class="fa-solid fa-asterisk red"></i></label>
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
				<div>중복된 이메일입니다.</div>
			</div>
		</div>



		<!-- 인증번호 입력 영역 -->
		<div class="cell cert-area"></div>

		<div class="cell">
			<label>성함<i class="fa-solid fa-asterisk red"></i></label> <input
				type="text" name="empName" class="field w-100">
		</div>

		<div class="cell">
			<label>생년월일<i class="fa-solid fa-asterisk red"></i></label> <input
				type="text" name="empBirth" class="field w-100" placeholder="연도-월-일">
			<div class="fail-feedback">올바른 날짜 형식이 아닙니다</div>
		</div>


		<div class="cell">
			<label>개인 휴대전화 연락처<i class="fa-solid fa-asterisk red"></i></label> <input
				type="text" inputmode="tel" name="empContact"
				class="field field-numeric w-100" placeholder="대시(-) 없이 입력">
			<div class="fail-feedback">올바른 전화번호 형식이 아닙니다</div>
		</div>

		<div class="cell mb-0">
			<label>주소<i class="fa-solid fa-asterisk red"></i></label>
		</div>
		<div class="cell mt-0 flex-area">
			<input type="text" name="empPost" class="field field-numeric"
				size="6" maxlength="6" placeholder="우편번호" readonly>
			<button type="button"
				class="btn btn-neutral ms-10 btn-address-search">
				<i class="fa-solid fa-magnifying-glass"></i>
			</button>
			<button type="button"
				class="btn btn-negative ms-10 btn-address-clear"
				style="display: none;">
				<i class="fa-solid fa-xmark"></i>
			</button>
		</div>
		<div class="cell">
			<input type="text" name="empAddress1" class="field w-100"
				placeholder="기본주소" readonly>
		</div>
		<div class="cell">
			<input type="text" name="empAddress2" class="field w-100"
				placeholder="상세주소">
		</div>


		<div class="cell mt-40">
			<label> <i class="fa-solid fa-image"></i> <span>클릭해서
					프로필 이미지를 선택하세요</span> <input type="file" name="attach"
				class="field w-100 preview-input" accept=".png, .jpg"
				style="display: none;">
			</label>
		</div>


		<div class="cell preview-area"></div>


		<div class="cell mt-50">
			<button type="submit" class="btn btn-positive w-100">
				<i class="fa-solid fa-user-plus"></i> <span>회원 가입하기</span>
			</button>
		</div>
	</div>
</form>