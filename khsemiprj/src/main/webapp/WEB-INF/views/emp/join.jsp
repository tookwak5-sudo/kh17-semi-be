<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />

<!-- kakao postapi cdn --> 
<script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
	$(function() {
		//상태객체
		var state = {
				empEmailValid : true,
				empEmailCertValid : false,//인증 통과했는지
				ok : function(){
                    return Object.values(this)
                    .filter(v => typeof v == "boolean")
                    .every(v => v == true);
                }
            }
		
		//주소 검색 서비스 추가를 위한 코드
		$("[name=empPost], [name=empAddress1], .btn-address-search").on(
				"click", function() {
					new kakao.Postcode({
						oncomplete : function(data) {
							// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

							// 각 주소의 노출 규칙에 따라 주소를 조합한다.
							// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
							var addr = ''; // 주소 변수

							//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
							if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
								addr = data.roadAddress;
							} else { // 사용자가 지번 주소를 선택했을 경우(J)
								addr = data.jibunAddress;
							}

							// 우편번호와 주소 정보를 해당 필드에 넣는다.
							$("[name=empPost]").val(data.zonecode);

							$("[name=empAddress1]").val(addr);

							// 지우기 버튼을 표시한다
							$(".btn-address-clear").fadeIn();

							// 커서를 상세주소 필드로 이동한다.
							$("[name=empAddress2]").trigger("focus");
						}
					}).open();
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
                        $(".cert-area").empty();
                        $(".btn-cert-send").hide();//전송버튼 숨김
                        $(".btn-cert-retry").show();
                    }
                    else {
                        state.empEmailCertValid = false;
                        $(".field-cert").addClass("fail");
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
	
	         $("[name=empEmail]").trigger("focus");//커서 옮김
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




<form action="./join" method="post" enctype="multipart/form-data" autocomplete="off" class="form-check">
	<div class="container w-600 mt-50 mb-50">
		<div class="cell center">
			<h1>회원 가입</h1>

		</div>

		<div class="cell">
			<label>아이디</label> <input type="text" name="empId"
				class="field w-100">

		</div>

		<div class="cell">
			<label>비밀번호</label> <input type="password" name="empPassword"
				class="field w-100">

		</div>
		
		<div class="cell">
			<label>이메일</label>
		</div>
		<div class="cell mt-0 flex-area" style="flex-wrap: wrap;">
                <input type="text" name="empEmail"
                class="field" inputmode="email">
                <button type="button" class="btn btn-neutral btn-cert-send ms-10">
                    <i class="fa-solid fa-envelope"></i>
                    <span>인증메일 보내기</span>
                </button>
                <button type="button" class="btn btn-negative btn-cert-retry ms-10" 
                        style="display: none;">
                    <i class="fa-solid fa-rotate-right"></i>
                    <span>다시 인증하기</span>
                </button>
        </div>
        
        <!-- 인증번호 입력 영역 -->
        <div class="cell cert-area"></div>

		<div class="cell">
			<label>성함</label> <input type="text" name="empName"
				class="field w-100">


		</div>


		<div class="cell">
			<label>생년월일</label> <input type="text" name="empBirth"
				class="field w-100">
			<div class="fail-feedback">올바른 날짜 형식이 아닙니다</div>
		</div>


		<div class="cell">
			<label>개인 휴대전화 연락처</label> <input type="text" inputmode="tel"
				name="empContact" class="field field-numeric w-100"
				placeholder="대시(-) 없이 입력">
			<div class="fail-feedback">올바른 전화번호 형식이 아닙니다</div>
		</div>

		<div class="cell mb-0">
			<label>주소</label>
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