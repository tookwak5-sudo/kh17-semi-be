<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />


<!-- kakao postapi cdn -->
<script
	src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
$(function() {
    var state = {
        empIdValid: true,
        empNameValid: true,
        empPasswordValid: true,
        empPasswordCheckValid: true,
        empEmailValid: true,
        empEmailCertValid: false, // 인증 통과했는지
        empBirthValid: true,
        empContactValid: true,
        empAddressValid: false,
        ok: function(){
            return Object.values(this)
            .filter(v => typeof v==="boolean")
            .every(v => v === true);
        }
    };
    
    $("[name=empId]").on("blur",function(){
        var regex =/^[a-z][a-z0-9]{4,19}$/;
        var empId = $("[name=empId]").val();
        var valid = regex.test(empId); 
        if(valid == false){
            $("[name=empId]").removeClass("success fail")
            .addClass("fail").attr("data-error","1");
            state.empIdValid = false;
            return;
        } else {
            $("[name=empId]").removeClass("success fail").addClass("success");
            state.empIdValid = true;
        }
    });	
    
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
        
        var empty = empPost.length == 0 && empAddress1.length == 0 && empAddress2.length == 0;
        var full = empPost.length > 0 && empAddress1.length > 0 && empAddress2.length > 0;
        var valid = empty || full;

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
        state.empAddressValid = true;
        $(this).fadeOut();
    });

    // 인증메일 보내기 버튼 (.btn-cert-send)
    $(".btn-cert-send").on("click", function(){
        var empEmail = $("[name=empEmail]").val();
        if(empEmail.length == 0) {
            window.alert("이메일을 입력해주세요.");
            return;
        }
        if(state.empEmailValid == false) return;

        // 회원가입용 중복 검사 먼저 진행 (기존 DB에 이메일이 있는지 확인)
        $.ajax({
            url: "/rest/cert/checkEmail", 
            method: "post",
            data: { empEmail : empEmail },
            success: function(isUsed) {
                if(isUsed === true || isUsed === "true" || isUsed === "Y") {
                    window.alert("이미 사용중인 이메일입니다. 다른 이메일을 입력하세요.");
                } else {
                    // 중복 아니면 진짜로 이메일 쏘는 함수 호출
                    sendRealEmail(empEmail);
                }
            },
            error: function() {
                window.alert("이메일 중복 확인 서버 통신 에러 발생");
            }
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
    
    // 인증번호 검사 버튼
    $(".cert-area").on("click", ".btn-cert-check", function(){
        var certEmail = $("[name=empEmail]").val();
        var certNumber = $(".field-cert").val();
        var certRegex = /^[0-9]{6}$/;
        var certValid = certRegex.test(certNumber);
        
        if(certValid == false) {
            window.alert("인증번호 6자리를 정확히 입력해주세요.");
            return;
        }
        
        $.ajax({
            url:"/rest/cert/check",
            method:"post",
            data: { certEmail : certEmail , certNumber : certNumber },
            success: function(response) {
                if(response === true || response === "true") {
                    state.empEmailCertValid = true;
                    $("[name=empEmail]").removeClass("success fail").addClass("success");
                    $(".cert-area").empty(); // 성공했으니 인증칸 밀어버리기
                    
                    // 전송 버튼 숨김 유지하고 다시인증하기 버튼만 활성화해둠
                    $(".btn-cert-send").hide();
                    $(".btn-cert-retry").show();
                    window.alert("이메일 인증이 완료되었습니다.");
                }
                else {
                    state.empEmailCertValid = false;
                    $(".field-cert").addClass("fail");
                    window.alert("인증번호가 일치하지 않습니다.");
                }
            }
        });
    });
    
    // 다시 인증하기 버튼 
    $(".btn-cert-retry").on("click", function(){
         $(".btn-cert-retry").hide();
         $(".btn-cert-send").show();
         
         // 인풋창 자물쇠 풀고 값 완전 초기화
         $("[name=empEmail]").removeClass("success fail").prop("readonly", false).val("");
         $(".cert-area").empty(); 
         
         // 폼 검사 통과 상태값 정상 복구 
         state.empEmailValid = true; 
         state.empEmailCertValid = false;

         $("[name=empEmail]").trigger("focus");
    }); 

    // 폼검사
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
            <div class="fail-feedback w-100">인증번호를 다시 확인해주세요</div>
        </div>
     </script>

<div class="container w-600 mt-50 mb-50">
	<h1 class="left black mb-40">내 정보 수정</h1>

	<form action="edit" method="post" enctype="multipart/form-data">

		<div class="cell mt-30">
			<div class="gray mb-10">
				<b>이름</b>
			</div>
			<input type="text" name="empName" class="field w-100"
				placeholder="기존 이름" value="${empDto.empName}">
		</div>

		<div class="cell mt-0 flex-area" style="flex-wrap: wrap;">
			<input type="text" name="empEmail" class="field" inputmode="email"
				placeholder="바꾸실 이메일을 입력해주세요.">
			<button type="button" class="btn btn-neutral btn-cert-send ms-10">
				<i class="fa-solid fa-envelope"></i> <span>인증메일 보내기</span>
			</button>
			<button type="button" class="btn btn-negative btn-cert-retry ms-10"
				style="display: none;">
				<i class="fa-solid fa-rotate-right"></i> <span>다시 인증하기</span>
			</button>
		</div>

		<!-- 인증번호 입력 영역 -->
		<div class="cell cert-area"></div>


		<div class="cell mt-40">
			<div class="gray mb-10">
				<b>생년월일</b>
			</div>
			<input type="date" name="empBirth" class="field w-100"
				placeholder="YYYY . MM . DD" value="${empDto.empBirth}">
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
					class="field flex-fill w-100" value="${empDto.empAddress2}"
					readonly>
			</div>
			
			<div class="gray mt-10" style="font-size: 13px;">* 주소를 변경하려면
				우편번호, 기본주소, 상세주소를 모두 입력해야 합니다.
				
			</div>
		</div>

		<div class="cell mt-30">
			<div class="gray mb-10">
				<b>연락처</b>
			</div>
			<div class="flex-area">
				<input type="text" name="empContact" class="field flex-fill" placeholder="${empDto.empContact}">

			</div>
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