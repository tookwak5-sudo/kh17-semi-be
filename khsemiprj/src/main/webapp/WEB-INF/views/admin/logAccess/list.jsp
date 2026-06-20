<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<style>
.break-url {
    word-break: break-all;     /* 글자 단위로 쪼개서 줄바꿈 */
    white-space: normal;       /* 기본 줄바꿈 허용 */
}
</style>
	
<div class="container w-100 mt-20 mb-50 background-card">
	<div class="cell center flex-area">		
		<div class="w-25 flex-area" style="justify-content: left">
			<div>
		        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
		            페이지 접근 로그
		            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
		        </h1>
			</div>
        </div>
		<div class="cell flex-area background-fill">
			<!-- 검색창 -->
	            <form autocomplete="off">
	                <select name="column" class="field-ph">
	                    <option value="access_emp_id" ${param.column == 'access_emp_id' ? 'selected' : ''}>접근자 아이디</option>
	                    <option value="access_url" ${param.column == 'access_url' ? 'selected' : ''}>접속 URL</option>
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
	                   <th width="80px">no.</th>
	                   <th>접근자</th>
	                   <th>경로(URL)</th>
	                   <th width="130px">접근IP</th>
	                   <th width="130px">접근시각</th>
	               </tr>
	  			</thead>
	  			<tbody>
	  				<c:forEach var="logAccessDto" items="${logAccessList}">
	  				<tr>
	  					<td>${logAccessDto.accessNo}</td>
	  					<td>${logAccessDto.accessEmpId} ([${logAccessDto.deptName}] ${logAccessDto.empName})</td>
	  					<td  class="break-url">${logAccessDto.accessUrl}</td>
	  					<td>${logAccessDto.accessIp}</td>
	  					<td>${logAccessDto.accessDate}</td>
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