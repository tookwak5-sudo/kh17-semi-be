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
	
	<style>
		.emp-info-card {
			background-color: #ffffff;
			border: 1px solid #e9ecef;
			border-radius: 12px;
			padding: 10px 30px;
		}
		.emp-info-row {
			display: flex;
			align-items: center;
			padding: 16px 0;
			border-bottom: 1px solid #f1f3f5;
		}
		.emp-info-row:last-child {
			border-bottom: none;
		}
		.emp-info-label {
			width: 25%;
			font-weight: 600;
			color: #495057;
			position: relative;
			padding-left: 14px;
			letter-spacing: -0.5px;
		}
		.emp-info-label::before {
			content: "";
			position: absolute;
			left: 0;
			top: 50%;
			transform: translateY(-50%);
			width: 4px;
			height: 14px;
			background-color: #739BED;
			border-radius: 2px;
		}
		.emp-info-value {
			width: 75%;
			color: #343a40;
			font-weight: 500;
		}
		.emp-info-value.point-color {
			color: #739BED;
			font-weight: 600;
		}
	</style>
	
	<div class="cell mt-40 emp-info-card">
		<div class="emp-info-row">
			<div class="emp-info-label">사원 아이디</div>
			<div class="emp-info-value point-color">${empDto.empId}</div>
		</div>
		<div class="emp-info-row">
			<div class="emp-info-label">이메일</div>
			<div class="emp-info-value">${empDto.empEmail}</div>
		</div>
		<div class="emp-info-row">
			<div class="emp-info-label">생년월일</div>
			<div class="emp-info-value">${empDto.empBirth}</div>
		</div>
		<div class="emp-info-row">
			<div class="emp-info-label">연락처</div>
			<div class="emp-info-value">${empDto.empContact}</div>
		</div>
		<div class="emp-info-row">
			<div class="emp-info-label">우편번호</div>
			<div class="emp-info-value">${empDto.empPost}</div>
		</div>
		<div class="emp-info-row">
			<div class="emp-info-label">기본주소</div>
			<div class="emp-info-value">${empDto.empAddress1}</div>
		</div>
		<div class="emp-info-row">
			<div class="emp-info-label">상세주소</div>
			<div class="emp-info-value">${empDto.empAddress2}</div>
		</div>
		<div class="emp-info-row">
			<div class="emp-info-label">입사일</div>
			<div class="emp-info-value">${empDto.empHireDate}</div>
		</div>
	</div>
	<hr class="mt-50 mb-50">
	
	<%-- <c:if test="${sessionScope.empGrade >= 0}"> --%>
	<div class="cell">
		<button type="button" class="btn btn-neutral" id="SelectToggleBtn" onclick="toggleSelect()">직책 관리 메뉴 ▼</button>
	</div>
	
	<div id="Select" style="display: none;">
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
	</div>
	<%-- </c:if> --%>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>

<script>
	function toggleSelect() {
		var area = document.getElementById("Select");
		var btn = document.getElementById("SelectToggleBtn");
		
		if (area.style.display === "none") {
			area.style.display = "block";
			btn.innerText = "직책 관리 메뉴 ▲";
		} else {
			area.style.display = "none";
			btn.innerText = "직책 관리 메뉴 ▼";
		}
	}
</script>