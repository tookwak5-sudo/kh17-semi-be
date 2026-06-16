<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
	
	<div class="container w-1200 mt-50 mb-50">
		<div class="cell center mb-0">
			<h1 class="mb-0">페이지 접근 로그</h1>
		</div>
		
		<!-- 검색창 -->
        <div class="cell center">
            <form autocomplete="off">
                <select name="column" class="field">
                    <option value="access_emp_id">접근자 아이디</option>
                    <option value="access_url">접속 URL</option>
                </select>
                <input type="text" name="keyword"
                    class="field-sm" placeholder="검색어 입력">
                <button type="submit" class="btn btn-positive">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <span>검색</span>
                </button>
            </form>
        </div>
		
		<div class="cell right mt-0">
	      <!-- 페이지접근로그목록 목록 -->
			<span>${pageVO.beginRownum}-${pageVO.endRownum} / 총 ${pageVO.count}개 로그</span>
	   </div>
	   
	   <div class="cell">
	   		<table class="table">
	   			<thead>
	               <tr>
	                   <th>no.</th>
	                   <th class="w-40">접근자</th>
	                   <th>경로(URL)</th>
	                   <th>접근IP</th>
	                   <th>접근시각</th>
	               </tr>
	  			</thead>
	  			<tbody>
	  				<c:forEach var="logAccessDto" items="${logAccessList}">
	  				<tr>
	  					<td>${logAccessDto.accessNo}</td>
	  					<td>${logAccessDto.accessEmpId} ([${logAccessDto.deptName}] ${logAccessDto.empName})</td>
	  					<td>${logAccessDto.accessUrl}</td>
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