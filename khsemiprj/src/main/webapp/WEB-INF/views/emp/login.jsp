<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<script>
	
</script>

<style>
	.cell a {
		text-decoration-line: none;
		color: black;
	}	
</style>

<form action="./login" method="post">
	<div class="container w-400 mt-50 mb-50">
		<div class="cell center">
			<h1>로그인</h1>
		</div>
		<div class="cell">
			<label>아이디</label>
			<input type="text" name="empId" maxlength="20" class="field w-100" />
		</div>
		<div class="cell">
			<label>비밀번호</label>
			<input type="password" name="empPassword" maxlength="16" class="field w-100" />
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