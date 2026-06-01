<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<div class="container w-400 mt-50 mb-50">
	<div class="cell center">
		<h1>비밀번호 찾기 결과</h1>
	</div>
	<div class="cell">
		<label>비밀번호</label> 
		<h2 class="mt-20">
			${empPassword}
		</h2>
	</div>
	<div class="cell mt-10">
		<a href="./login" class="btn btn-neutral w-100">로그인하러 가기</a>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>