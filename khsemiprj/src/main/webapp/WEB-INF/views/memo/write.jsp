<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/memoHeader.jsp"></jsp:include>   

<form action="./write" method="post">
	<div class="container memo-card w-600 mt-0">
		<div class="cell">
			<!-- 제목을 답글일 때와 새글일 때로 나눠서 처리 -->
			<h1 class="mt-0 mb-0">쪽지쓰기</h1>
		</div>
		
		<div class="cell mt-10">
			<label>제목 <i class="fa-solid fa-asterisk red"></i></label>
			<input type="text" name="memoTitle" class="field w-100">
		</div>
		<div class="cell">
			<label>받을사람 아이디<i class="fa-solid fa-asterisk red"></i></label>
			<input type="text" name="memoReceiverId" value="${replyReceiverId}" class="field w-100">
		</div>
		<c:if test="${sessionScope.empGrade = '2'}">
			<div class="cell mb-0">
				<label>쪽지 타입</label>
			</div>
		
			<div class="cell mt-0">
				<select name="memoType" class="field">
					<option value="">선택 안함</option>
					<!-- 공지는 관리자에게만 보이도록 해야함 -->
					<option>일반</option>
					<option>공지</option>		
				</select>
			</div>
		</c:if>
		
		<div class="cell">
			<label>내용 <i class="fa-solid fa-asterisk red"></i></label>
			<textarea name="memoContent" rows="6" required rows="6" class="field w-100"></textarea>
		</div>
		
		<div class="cell mt-50 right">
			<a href="/memo/list" class="btn btn-neutral">
				<i class="fa-solid fa-list"></i>
				<span>목록으로 이동</span>
			</a>
			<button type="submit" class="btn btn-positive">
				<i class="fa-solid fa-floppy-disk"></i>
				<span>쪽지 보내기</span>
			</button>
		</div>
	</div>
</form>
