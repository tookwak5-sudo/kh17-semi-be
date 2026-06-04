<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-950 mt-50 mb-50">

	
	<div class="cell">
		<h1>${empDto.empName}</h1>
		<h1>${empPositionDeptDto.empPositionName} / ${empPositionDeptDto.deptName}</h1>
	</div>
	
	<div class="cell">
		<img src="./profile?empId=${empDto.empId}" width="100" height="100"
			style="border-radius:50%; box-shadow:0 0 1px 0 black">
	</div>
	
	<div class="cell mt-40">
		<div class="flex-area">
			<div class="w-25">사원 아이디</div>
			<div class="w-75 blue">${empDto.empId}</div>
		</div>
		<div class="flex-area mt-10">
			<div class="w-25">이메일</div>
			<div class="w-75 blue">${empDto.empEmail}</div>
		</div>
		<div class="flex-area mt-10">
			<div class="w-25">생년월일</div>
			<div class="w-75 blue">${empDto.empBirth}</div>
		</div>
		<div class="flex-area mt-10">
			<div class="w-25">연락처</div>
			<div class="w-75 blue">${empDto.empContact}</div>
		</div>
		<div class="flex-area mt-10">
			<div class="w-25">우편번호</div>
			<div class="w-75 blue">${empDto.empPost}</div>
		</div>
		<div class="flex-area mt-10">
			<div class="w-25">기본주소</div>
			<div class="w-75 blue"> ${empDto.empAddress1}</div>
		</div>
		<div class="flex-area mt-10">
			<div class="w-25">상세주소</div>
			<div class="w-75 blue"> ${empDto.empAddress2}</div>
		</div>
		<div class="flex-area mt-10">
			<div class="w-25">입사일</div>
			<div class="w-75 blue">${empDto.empHireDate}</div>
		</div>
	</div>
	
	
	
	<hr class="mt-50 mb-50">
	
	<%-- <c:if test="${sessionScope.loginLevel >= 0}"> --%>
		<div class="cell red">
			<h1>직책 관리</h1>
		</div>
		<div class="cell">
			<form action="detail" method="post">
	            
	            <input type="hidden" name="empId" value="${empDto.empId}">
	            
	            <select name="empPositionNo" class="field">
	            	<option value="">선택</option>
	            	<c:forEach var="position" items="${positionList}">
	            	<option value="${position.empPositionNo}" ${empPositionDto.empPositionNo == position.empPositionNo ? 'selected' : ''}>
                            ${position.empPositionName}
                        </option>
	            	</c:forEach>
	            </select>
	            
	            <button type="submit" class="btn btn-positive">직책 변경</button>
	        </form>
		</div>
	<%-- </c:if> --%>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>


