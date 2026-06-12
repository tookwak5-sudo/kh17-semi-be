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
	
	<form action="edit" method="post" id="editForm">
		<input type="hidden" name="empId" value="${empDto.empId}">
		
		<div class="cell mt-40 emp-info-card">
			<div class="emp-info-row">
				<div class="emp-info-label">사원 아이디</div>
				<div class="emp-info-value point-color">${empDto.empId}</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">직책(직급)</div>
				<div class="emp-info-value">
					<span class="view-mode">${empPositionDeptDto.empPositionName}</span>
					<span class="edit-mode" style="display: none;">
						<select name="empPositionNo" class="field">
			            	<option value="">선택</option>
			            	<c:forEach var="position" items="${positionList}">
			            	<option value="${position.empPositionNo}" ${empPositionDeptDto.empPositionNo == position.empPositionNo ? 'selected' : ''}>
		                            ${position.empPositionName}
		                        </option>
			            	</c:forEach>
			            </select>
					</span>
				</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">이메일</div>
				<div class="emp-info-value">
					<span class="view-mode">${empDto.empEmail}</span>
					<span class="edit-mode" style="display: none;">
						<input type="email" name="empEmail" value="${empDto.empEmail}" class="field w-100">
					</span>
				</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">연락처</div>
				<div class="emp-info-value">
					<span class="view-mode">${empDto.empContact}</span>
					<span class="edit-mode" style="display: none;">
						<input type="text" name="empContact" value="${empDto.empContact}" class="field w-100">
					</span>
				</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">우편번호</div>
				<div class="emp-info-value">
					<span class="view-mode">${empDto.empPost}</span>
					<span class="edit-mode" style="display: none;">
						<input type="text" name="empPost" value="${empDto.empPost}" class="field w-100">
					</span>
				</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">기본주소</div>
				<div class="emp-info-value">
					<span class="view-mode">${empDto.empAddress1}</span>
					<span class="edit-mode" style="display: none;">
						<input type="text" name="empAddress1" value="${empDto.empAddress1}" class="field w-100">
					</span>
				</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">상세주소</div>
				<div class="emp-info-value">
					<span class="view-mode">${empDto.empAddress2}</span>
					<span class="edit-mode" style="display: none;">
						<input type="text" name="empAddress2" value="${empDto.empAddress2}" class="field w-100">
					</span>
				</div>
			</div>
		</div>
		
		<hr class="mt-50 mb-50">
		
		<div class="cell" style="display: flex; justify-content: flex-end; gap: 10px;">
			<a href="list" class="btn btn-positive view-mode">
				<i class="fa-solid fa-list"></i> 목록으로
			</a>
		
			<button type="button" class="btn btn-neutral view-mode" onclick="toggleEditMode(true)">정보 수정</button>
			
			<button type="button" class="btn btn-negative edit-mode" style="display: none;" onclick="toggleEditMode(false)">취소</button>
			<button type="submit" class="btn btn-positive edit-mode" style="display: none;">저장하기</button>
		</div>
	</form>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>

<script>
	function toggleEditMode(isEdit) {
		// 화면의 모든 view-mode와 edit-mode 요소들을 찾습니다.
		var views = document.querySelectorAll('.view-mode');
		var edits = document.querySelectorAll('.edit-mode');
		
		if(isEdit) {
			// 수정 모드 켜기: view는 숨기고, edit는 보여줌
			views.forEach(function(el) { el.style.display = 'none'; });
			edits.forEach(function(el) { el.style.display = 'inline-block'; }); // 또는 block
		} else {
			// 수정 모드 끄기(취소): edit는 숨기고, view는 다시 보여줌
			views.forEach(function(el) { el.style.display = 'inline-block'; });
			edits.forEach(function(el) { el.style.display = 'none'; });
		}
	}
</script>