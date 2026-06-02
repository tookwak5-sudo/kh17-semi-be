<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<form action="./edit" method="post">
<input type="hidden" name="boardNo" value="${boardDto.boardNo}">


<div class="container w-950 mt-50 mb-50">
	<div class="cell">
		<h1 class="mt-0 mb-0">게시글 수정</h1>
	</div>
	<div class="cell">
		타인에 대한 무분별한 비방글은 경고 없이 삭제될 수 있습니다
	</div>
	
	<div class="cell mt-40">
		<label>제목 <i class="fa-solid fa-asterisk red"></i></label>
		<input type="text" name="boardTitle" required class="field w-100"
				value="${boardDto.boardTitle}">
	</div>
	<c:if test="${sessionScope.loginLevel != '0'}">
		<div class="cell mb-0">
			<label>구분</label>
		</div>
		<div class="cell mt-0">
			<select name="boardHead" class="field">
				<option value="">선택 안함</option>
				
				<!-- 공지는 관리자에게만 보이도록 해야함 -->
				<option ${boardDto.boardHead == '공지' ? 'selected':''}>공지</option>
				<option ${boardDto.boardHead == '자유' ? 'selected':''}>자유</option>
			</select>
		</div>
	</c:if>
	
	<div class="cell">
		<label>내용 <i class="fa-solid fa-asterisk red"></i></label>
		<textarea name="boardContent" rows="10" required class="field w-100">${boardDto.boardContent}</textarea>
	</div>
	
	<div class="cell mt-50 right">
		<a href="./list" class="btn btn-neutral">
			<i class="fa-solid fa-list"></i>
			<span>목록으로 이동</span>
		</a>
		<button type="submit" class="btn btn-positive">
			<i class="fa-solid fa-floppy-disk"></i>
			<span>글 수정하기</span>
		</button>
	</div>
</div>
	
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>



