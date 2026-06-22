<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<script>
$(function() {
	
	$(".togglebox").find("[type=checkbox]").on("input", function () {
	    var check = $(this).prop("checked");
	    $(".togglebox").find("[type=checkbox]").prop("checked", check);
	
	    $("[name=empPassword]").attr("type", check ? "text" : "password");
	});

});
</script>

<style>
	.cell a {
		text-decoration-line: none;
		color: black;
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

<form action="./login" method="post">
	<div class="container w-500 mt-20 mb-50 background-card">
		<div class="cell center">
			<h1>로그인</h1>
		</div>
		<div class="cell">
			<label>아이디</label>
			<input type="text" name="empId" maxlength="20" class="field w-100"  autocomplete="off"/>
		</div>
		<div class="cell">
			<label>비밀번호</label>
			<label class="togglebox"> 
			<input type="checkbox"> 
			<i class="fa-solid fa-eye-slash"></i> 
			<i class="fa-solid fa-eye"></i>
			</label>
			<input type="password" name="empPassword" maxlength="16" class="field w-100" autocomplete="off"/>
		</div>
		
		<div class="cell">
			<div class="fail-feedback red" style="display:block !important;">
			<c:choose>
			<c:when test="${param.error != null}">
			로그인에 실패했습니다
			</c:when>
			<c:when test="${param.valid != null}">
			승인되지 않은 계정입니다
			</c:when>
			</c:choose>
			</div>
		</div>
		<div class="cell">
			<button class="btn btn-positive w-100">로그인</button>
		</div>
		<div class="cell flex-area">
			<div class="w-50 left">
				<a href="/emp/join">
					<span>회원가입</span>
				</a>
			</div>
			<div class="w-50 right">
				<a href="/emp/findId"><span>아이디 찾기</span></a> / <a href="/emp/findPassword"><span>비밀번호 찾기</span></a>
			</div>
		</div>
	</div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>