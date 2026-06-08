<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
	
	<div class="container w-1200 mt-50 mb-50">
		<div class="cell center mb-0">
			<h1 class="mb-0">출퇴근 기록</h1>
		</div>
		
		<!-- 검색창 -->
        <div class="cell center">
            <form autocomplete="off">
                <select name="column" class="field">
                    <option value="log_inout_emp_id">사원아이디</option>
                    <option value="log_inout_type">분류</option>
                </select>
                <input type="text" name="keyword"
                    class="field" placeholder="검색어 입력">
                <button type="submit" class="btn btn-positive">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <span>검색</span>
                </button>
            </form>
        </div>
		
		<div class="cell right mt-0">
	      <!-- 출퇴근 목록 -->
			<span>${pageVo.beginRownum}-${pageVo.endRownum} / 총 ${pageVo.count}개</span>
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
	  				<c:forEach var="logInoutDto" items="${list}">
	  				<tr>
	  					<td>${logInoutDto.logInoutNo}</td>
	  					<td>${logInoutDto.logInoutEmpId}</td>
	  					<td>${logInoutDto.logInoutType}</td>
	  					<td>${logInoutDto.logInoutTime}</td>
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