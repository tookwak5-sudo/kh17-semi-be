<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />

<h1>관리</h1>

<div class="container w-950 mt-50 mb-50">
	<div class="cell">
		<h1>헤더 종류 목록</h1>
	</div>
	<table class="table">
	    <thead>
	        <tr>
	            <th>헤드 번호</th>
	            <th>헤드 이름</th>
	            <th>헤드 타입</th>
	
	        </tr>
	    </thead>
	    <tbody>
	        <c:forEach var="aprvHead" items="${aprvHeadList}">
	           <tr>
	               <td>${aprvHead.headNo}</td>
	               <td>${aprvHead.headName}</td>
	               <td>${aprvHead.headType}</td>
	           </tr>
	       </c:forEach>
	    </tbody>
	</table>
	<div class="cell">    
		<!-- 페이지네이션 -->
		<jsp:include page="/WEB-INF/views/template/pagination2.jsp"></jsp:include>		
	</div>
	
	<div class="cell">
		<form action="/admin/write" method="post">
	    	<div class="cell">
				<label>헤더 이름</label> <input type="text" name="headName">
			</div>
			<div class="cell">
				<label>헤더 타입</label>
				<select name="headType" class="field">
		        	<option value="">선택</option>
		        	<option value="결재">결재</option>
		        	<option value="일반">일반</option>
		       	</select>
			</div>
			
		   	<button type="submit" class="btn btn-positive">헤더생성</button>
		</form>
	</div>
	
	
	</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp"/>