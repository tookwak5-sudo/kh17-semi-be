<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<form action="./findId" method="post" autocomplete="off">
<div class="container w-400 mt-50 mb-50">
	<div class="cell center">
		<h1>아이디 찾기</h1>
	</div>
	<div class="cell">
		<label>이름</label> <input type="text" name="empName" class="field w-100">
	</div>
	<div class="cell">
		<label>이메일</label> <input type="email" inputmode="email" name="empEmail" class="field w-100">
	</div>
	
	<div class="cell mt-50">
		<button type="submit" class="btn btn-positive w-100">
			<i class="fa-solid fa-user-plus"></i> <span>확인</span>
		</button>
	</div>
</div>
</form>
<div style="white-space: nowrap;">
	<c:if test="${param.error != null}">
		입력하신 정보는 없습니다
	</c:if>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>