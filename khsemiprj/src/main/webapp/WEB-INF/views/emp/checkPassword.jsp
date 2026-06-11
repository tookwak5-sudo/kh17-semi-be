<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />



<div class="container w-500 mt-50 mb-50">
<div class="cell center">

<h1>비밀번호 확인</h1>

</div>
<form action="./checkPassword" method="post" autocomplete="off">
	<div class="cell">

		<div class="cell mt-40">

			<label>비밀번호 입력</label> <input type="password" name="empPassword"
				required class="field w-100">

		</div>


		<div class="mt-50">
			<button type="submit" class="btn btn-positive w-100">
				<i class="fa-solid fa-lock fa-fade"></i> <span>확인</span>
			</button>
		</div>

		<c:if test="${param.error != null}">
			<div class="cell red">오류 : 비밀번호가 불일치합니다.</div>
		</c:if>
	</div>



</form>



</div>