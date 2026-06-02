<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-950 mt-50 mb-50">
	<div class="cell">
		<div class="flex-area" style="align-items:end;">
			<h1 class="mt-0 mb-0">회원 관리</h1>
			<form action="./list" method="get" style="margin-left:auto;">
				<select name="column" class="field">
					<option value="emp_id" ${param.column == 'emp_id' ? 'selected' : ''}>아이디</option>
					<option value="emp_name" ${param.column == 'emp_name' ? 'selected' : ''}>이름</option>
					<option value="dept_name" ${param.column == 'dept_name' ? 'selected' : ''}>부서명</option>
					<option value="emp_position_name" ${param.column == 'emp_position_name' ? 'selected' : ''}>직급</option>
				</select>
				<input type="text" name="keyword" class="field" value="${param.keyword}">
				<button class="btn btn-positive">
					<i class="fa-solid fa-magnifying-glass"></i>
					<span>검색</span>
				</button>
			</form>
		</div>
	</div>
	<c:if test="${param.column != null && param.keyword != null}">
	<div class="cell">
		<h3>총 <span class="red">${list.size()}</span>명의 회원이 검색되었습니다</h3>
	</div>
	</c:if>
	<c:if test="${list.size() > 0}">
	<div class="cell">
		<table class="table">
			<thead>
				<tr>
					<th>사원 아이디</th>
					<th>이름</th>
					<th>부서</th>
					<th>직급</th>
				</tr>
			</thead>
			<tbody align="center">
				<c:forEach var="empDto" items="${list}">
				<tr>
					<td>${empDto.empId}</td>
					<td>${empDto.empName}</td>
					<td>${deptDto.deptName}</td>
					<td>${emppositiondeptDto.empPositionName}</td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	</c:if>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>



