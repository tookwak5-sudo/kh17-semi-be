<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />

<!-- kakao postapi cdn --> 
<script
	src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	$(function() {
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
							//document.getElementById('sample6_postcode').value = data.zonecode;
							//document.querySelector("[name=memberPost]").value = data.zonecode;
							$("[name=empPost]").val(data.zonecode);

							//document.getElementById("sample6_address").value = addr;
							//document.querySelector("[name=memberAddress1]").value = addr;
							$("[name=empAddress1]").val(addr);

							// 지우기 버튼을 표시한다
							$(".btn-address-clear").fadeIn();

							// 커서를 상세주소 필드로 이동한다.
							//document.getElementById("sample6_detailAddress").focus();
							//document.querySelector("[name=memberAddress2]").focus();
							$("[name=empAddress2]").trigger("focus");
						}
					}).open();
				});

	});
</script>




<form action="./join" method="post" enctype="multipart/form-data" autocomplete="off" class="form-check">
	<div class="container w-400 mt-50 mb-50">
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
			<label>이메일</label> <input type="text" inputmode="email"
				name="empEmail" class="field w-100">

		</div>

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