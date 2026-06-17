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
	
<style>
    /* 프로필 이미지를 동그랗게 만드는 스타일 */
    .image-round {
        width: 100px;         /* 너비 고정 */
        height: 100px;        /* 높이를 너비와 똑같이 맞춰서 정정사각형 생성 */
        border-radius: 50%;   /* 모서리를 50% 깎아서 완벽한 원형으로 변경 */
        object-fit: cover;    /* 이미지가 일그러지지 않고 비율을 유지하며 원에 꽉 차게 함 */
    }

    /* (선택) 그림자 효과를 주고 싶다면 추가 */
    .image-shadow {
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    /* (선택) 미리보기 영역 정렬 */
    .preview-area {
        margin-top: 15px;
        display: flex;
        gap: 10px;
    }
</style>



<script>
$(function() {
	
	// 프사 미리보기 및 삭제 플래그 제어
	$(".preview-input").on("input", function(){
	    $(".profile-view-container").find("img").each(function(){
	        URL.revokeObjectURL($(this).attr("src"));
	    });
	    $(".profile-view-container").empty(); 

	    if(this.files.length > 0) {
	        for(var i=0; i < this.files.length; i++){
	            var img = $("<img>").addClass("image-shadow image-round")
	                        .attr("src", URL.createObjectURL(this.files[i]))
	                        .css({"width": "100px", "height": "100px", "object-fit": "cover"});
	            $(".profile-view-container").append(img);
	        }
	        $(".delete-profile-flag").val("N");
	        $(".btn-delete-profile").show();
	    } else {
	        var defaultIcon = $("<i>").addClass("fa-solid fa-user-circle").css({"font-size": "100px", "color": "#e2e8f0"});
	        $(".profile-view-container").html(defaultIcon);
	    }
	});

	// 기본 이미지로 변경 버튼 클릭 이벤트
	// on("click", ...) 안에 이벤트 객체 e를 넣어서 방어
	$(document).on("click", ".btn-delete-profile", function(e) {
	    e.preventDefault(); // 쓸데없는 링크 이동이나 새로고침 완전 차단
	    $(".delete-profile-flag").val("Y");
	    $(".preview-input").val("");
	    
	    var defaultIcon = $("<i>").addClass("fa-solid fa-user-circle").css({"font-size": "100px", "color": "#e2e8f0"});
	    $(".profile-view-container").html(defaultIcon);
	    
	    $(this).hide();
	});
	
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

 // 기본 이미지로 변경 버튼을 클릭했을 때
    $(".btn-delete-profile").on("click", function() {
        // 1. 플래그 값을 Y로 변경 (서버에 지우라고 신호 보냄)
        $(".delete-profile-flag").val("Y");
        
        // 2. 파일 선택 창에 들어있던 값도 초기화
        $(".preview-input").val("");
        
        // 3. 화면의 프사 이미지를 기본 대머리 아이콘으로 강제 변경
        var defaultIcon = $("<i>")
            .addClass("fa-solid fa-user-circle")
            .css({"font-size": "100px", "color": "#e2e8f0"});
            
        $(".profile-view-container").html(defaultIcon);
        
        // 4. 이미 지웠으므로 '기본 이미지로 변경' 버튼은 숨김 처리
        $(this).hide();
    });

    // 만약 유저가 기본 이미지로 변경을 눌렀다가 다시 새 파일을 고르면?
    $(".preview-input").on("input", function() {
        if(this.files.length > 0) {
            $(".delete-profile-flag").val("N");
            $(".btn-delete-profile").show(); 
        }
    });

    // [수정] 폼 검사할 때 var valid를 써서 전송 막기
    $(".form-check").on("submit", function(){
        $(this).find("input[name], textarea[name]").trigger("blur");
        
        // state.ok() 검사 결과를 var valid 변수에 담음
        var valid = state.ok();
        
        // 만약 유효성 검사 통과 못하면 return false로 form 전송 차단
        if (valid == false) {
            window.alert("입력하신 정보를 다시 확인해주세요.");
            return false;
        }
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

	<form action="edit" method="post" enctype="multipart/form-data" class=>

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
    <label class="btn btn-neutral w-100" style="cursor: pointer;">
        <i class="fa-solid fa-image"></i> 
        <span>클릭해서 프로필 이미지를 선택하세요 (.jpg , .png)</span> 
        <input type="file" name="attach" class="field preview-input" accept="image/png, image/jpeg" style="display: none;">
    </label>
</div>

<input type="hidden" name="deleteProfileFlag" class="delete-profile-flag" value="N">

<div style="display: flex; flex-direction: column; align-items: center; margin-top: 20px;">
    <div class="profile-view-container" style="display: flex; justify-content: center;">
        
        <c:if test="${not empty profileAttachNo}">
            <img src="/download/modern?attachNo=${profileAttachNo}" class="image-shadow image-round" style="width: 100px; height: 100px; object-fit: cover;">
        </c:if>
        
        <c:if test="${empty profileAttachNo}">
            <i class="fa-solid fa-user-circle" style="font-size: 100px; color: #e2e8f0;"></i>
        </c:if>
        
    </div>
    
    <c:if test="${not empty profileAttachNo}">
        <a class="btn-delete-profile" style="margin-top: 12px; font-size: 13px; color: #ef4444; text-decoration: none; font-weight: 600; cursor: pointer;">
            <i class="fa-solid fa-trash-can"></i> 기본 이미지로 변경
        </a>
    </c:if>
</div>

<div class="cell mt-50">
    <button type="submit" class="btn btn-positive w-100">수정하기</button>
</div>
<div class="cell mt-50">
    <button type="submit" class="btn btn-positive w-100">수정하기</button>
</div>
        
        <div class="cell mt-50">
            <button type="submit" class="btn btn-positive w-100">수정하기</button>
        </div>

    </form>
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp" />