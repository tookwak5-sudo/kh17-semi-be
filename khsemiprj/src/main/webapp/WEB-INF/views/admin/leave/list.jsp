<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
	.table-hover tbody tr:hover {
			background-color : #f8f9fa;
			transition: background-color 0.2s ease;
	}
	.profile-info {
		    font-size: 0.95em;
		    color: #475569;
		    margin-top: 15px;
		    line-height: 1.4;
		    padding: 10px 0;
		}
		
		/* 이름 강조 */
		.profile-name {
		    font-size: 1.2em;
		    font-weight: 700;
		    color: #1E293B;
		    margin-bottom: 2px;
		}
		
		/* 부서 및 직책 라인 */
		.profile-dept-pos {
		    font-size: 0.9em;
		    color: #64748b;
		    margin-bottom: 8px;
		}
		
		/* 아이디(작은 텍스트) */
		.profile-id {
		    font-size: 0.8em;
		    color: #94a3b8;
		    background: #f8fafc;
		    display: inline-block;
		    padding: 2px 6px;
		    border-radius: 4px;
		}
</style>

<div class="container w-100 mt-20 mb-50 background-card">
	<div class="cell center flex-area">
		<div class="w-20 flex-area" style="justify-content: left">
			<div>
		        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
		            휴가 관리
		            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
		        </h1>
			</div>
        </div>
        
        <div class="w-70 flex-area flex-center">
			<form action="./list" method="get" style="display: flex; align-items: center; gap: 8px;">
				<select name="column" class="field select">
					<option value="emp_id" ${param.column == 'emp_id' ? 'selected' : ''}>아이디</option>
					<option value="emp_name" ${param.column == 'emp_name' ? 'selected' : ''}>이름</option>
					<option value="dept_name" ${param.column == 'dept_name' ? 'selected' : ''}>부서명</option>
					<option value="emp_position_name" ${param.column == 'emp_position_name' ? 'selected' : ''}>직급</option>
				</select>
				<input type="text" name="keyword" class="field-sm" value="${param.keyword}"  style="width: 300px">
				<button class="btn btn-positive" style="padding: 8px 18px; font-size: 16px;">
					<i class="fa-solid fa-magnifying-glass"></i>
					<span>검색</span>
				</button>
			</form>
		</div>
		
		<div class="w-20 flex-area flex-center" style="justify-content: right;">
		</div>
	</div>

	
	
	<c:if test="${param.column != null && param.keyword != null && param.keyword != ''}">
	<div class="cell">
		<h3>총 <span class="red">${list.size()}</span>명의 회원이 검색되었습니다</h3>
	</div>
	</c:if>
	
	
	<c:if test="${list.size() > 0}">
	<div class="cell">
			<table class="table table-hover">
				<thead>
					<tr>
						<th>사원 아이디</th>
						<th>이름</th>
						<th>부서</th>
						<th>직급</th>
					</tr>
				</thead>
				<tbody align="center">
					<c:forEach var="empPositionDto" items="${list}">
					<tr onclick="location.href='detail?empId=${empPositionDto.empId}'" style="cursor: pointer;">
						<td>${empPositionDto.empId}</td>
						<td>${empPositionDto.empName}</td>
						<td>${empPositionDto.deptName}</td>
						<td>${empPositionDto.empPositionName}</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
	</div>
	</c:if>
	<div class="cell">    
	<!-- 페이지네이션 -->
	<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
	</div>
</div>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>


