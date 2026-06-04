<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<form action="./insert" autocomplete="off" method="post" class="form-check">

	<div class="container w-1200 mt-50">
		
    	<div class="cell center">
            <h1>결재 등록</h1>
        </div>
        <div class="cell mb-0">
            <label>양식 선택</label> 
		</div>
		<div class="cell mt-0">
            <select class="field w-40" name="aprvFormNo">
                <option value="">선택하세요</option>
                <c:forEach var="aprvFormDto" items="${aprvFormList}">
                <option value="${aprvFormDto.formNo}">${aprvFormDto.formName}</option>
                </c:forEach>
            </select>
        </div>
        <div class="cell mb-0">
            <label>제목 <i class="fa-solid fa-asterisk red"></i></label>
        </div>
        <div class="cell mt-0">
        	<input type="text" name="aprvTitle" class="field w-40">
        </div>
        <div class="cell mb-0">
            <label>양식 파일</label>
        </div>
        <div class="cell mt-0">
        	<a href=""><i class="fa-regular fa-file"></i>양식 파일 다운로드</a>
        </div>
        <div class="cell mb-0">
            <label>기한 <i class="fa-solid fa-asterisk red"></i></label>
        </div>
        <div class="cell mt-0">
        	<input type="date" class="field w-20">
        	~
        	<input type="date" class="field w-20">
        </div>
        <div class="cell">
        	<label>내용 <i class="fa-solid fa-asterisk red"></i></label>
        	<input type="text" inputmode="numeric" name="aprvContent" class="field w-100">
        </div>
        <div class="cell mb-0">
            <label>첨부 파일</label>
        </div>
        <div class="cell mt-0">
			<label>
				<i class="fa-regular fa-file"></i>
				<span>클릭해서 첨부파일을 선택하세요</span> <input type="file" name="attach" class="field w-100 preview-input" accept=".png, .jpg" style="display: none;">
			</label>
		</div>
        <div class="cell mb-0">
            <label>1차 결재 라인</label>
        </div>
        <div class="cell w-40 mt-0">
        	<table class="table">
        		<thead>
        			<tr>
	        			<th>순서</th>
	        			<th>결재자</th>
	        			<th>부서</th>
	        			<th>직책</th>
        			</tr>
        		</thead>
        		<tbody>
        			
        		</tbody>
        	</table>
        </div>
        <div class="cell w-40 right">
        	<a href="" class="btn btn-positive">결재자 추가</a>
        </div>
        <div class="cell mb-0">
            <label>2차 결재 라인</label>
        </div>
        <div class="cell w-40 mt-0">
        	<table class="table">
        		<thead>
        			<tr>
	        			<th>순서</th>
	        			<th>결재자</th>
	        			<th>부서</th>
	        			<th>직책</th>
        			</tr>
        		</thead>
        		<tbody>
        			
        		</tbody>
        	</table>
        </div>
        <div class="cell w-40 right">
        	<a href="" class="btn btn-positive">결재자 추가</a>
        </div>
        <div class="cell mt-40 right">
        	<a href="./list" class="btn btn-neutral">목록으로</a>
        	<button class="btn" style="background-color:#fdcb6e;">
                임시저장
            </button>
            <button class="btn btn-positive">
                등록하기
            </button>
        </div>
    </div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>