<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"/>


<form action="./insert" autocomplete="off" method="post" class="form-check">

	<div class="container w-400 mt-50">
		
    	<div class="cell center">
            <h1>부서 등록</h1>
        </div>
        <div class="cell">
        	<label>부서 번호<i class="fa-solid fa-asterisk red"></i></label>
        	<input type="text" inputmode="numeric" name="deptNo" class="field w-100" required>
        </div>
        <div class="cell">
            <label>부서 이름 <i class="fa-solid fa-asterisk red"></i></label>
            <input type="text" name="deptName"
                class="field w-100">
        </div>
        <div class="cell">
            <label>상위 부서 선택</label> 

            <select class="field w-100" name="deptParentNo">
                <option value="">선택하세요</option>
                <c:forEach var="deptDto" items="${deptList}">
                <option value="${deptDto.deptNo}">${deptDto.deptName}</option>
                </c:forEach>
            </select>
        </div>
        
        <div class="cell">
        	<label>부서 사용 여부</label>
        	<input type="checkbox" name="deptUseYn" value="Y">
        </div>
        
        <div class="cell mt-40 right">
        	<a href="./list" class="btn btn-neutral">목록으로</a>
            <button class="btn btn-positive">
                등록하기
            </button>
        </div>
    </div>
</form>
	
<jsp:include page="/WEB-INF/views/template/footer.jsp"/>