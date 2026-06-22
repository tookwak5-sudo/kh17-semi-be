<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

	<div class="container w-100 mt-20 mb-50 background-card">
		<div class="cell center flex-area">
			<div class="w-25 flex-area" style="justify-content: left">
				<div>
			        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
			            출퇴근 로그
			            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
			        </h1>
				</div>
	        </div>
	         <div class="cell flex-area background-fill">
				<!-- 검색창 -->
		            <form autocomplete="off">
		                <select name="column" class="field-ph">
		                    <option value="log_inout_emp_id" ${param.column == 'log_inout_emp_id' ? 'selected' : ''}>사원아이디</option>
		                    <option value="log_inout_type" ${param.column == 'log_inout_type' ? 'selected' : ''}>분류</option>
		                </select>
		                <input type="text" name="keyword"
		                    class="field-sm" placeholder="검색어 입력" value="${param.keyword}">
		                <button type="submit" class="btn btn-positive">
		                    <i class="fa-solid fa-magnifying-glass"></i>
		                    <span>검색</span>
		                </button>
		            </form>
	        </div>
		</div>
		<div class="right" style="font-size: 14px; color: #666;">
		    <strong style="color: #007bff;">${pageVO.count}</strong>개의 로그
		</div>
	   
	   <div class="cell">
	   		<table class="table">
	   			<thead>
	               <tr>
	                   <th>no.</th>
	                   <th class="w-40">사원정보</th>
	                   <th>분류</th>
	                   <th>등록시각</th>
	               </tr>
	  			</thead>
	  			<tbody>
	  				<c:forEach var="EmpLogInoutDto" items="${list}">
	  				<tr>
	  					<td>${EmpLogInoutDto.logInoutNo}</td>
	  					<td>${EmpLogInoutDto.empName} (${EmpLogInoutDto.logInoutEmpId})</td>
	  					<td>${EmpLogInoutDto.logInoutType}</td>
	  					<td>${EmpLogInoutDto.logInoutTime}</td>
	  				</tr>
	  				</c:forEach>
	  			</tbody>
	   		</table>
	   </div>
	</div>
	
	<div class="cell">    
	<!-- 페이지네이션 -->
	<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
	</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>