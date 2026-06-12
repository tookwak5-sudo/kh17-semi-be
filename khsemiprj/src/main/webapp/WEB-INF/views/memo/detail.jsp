<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/memoHeader.jsp"></jsp:include>

<div class="container w-600 mt-0 mb-0 memo-card">
<!-- 	제목, 타입, 작성자 -->
	<div class="cell">
		<div class="flex-area" style="align-items:end">
			<div>
				<h1 class="mt-0 mb-0">
					(${memoDto.memoType})
					<!-- 제목 -->
					${memoDto.memoTitle}
				</h1>
			</div>
			<div class="ms-40">
				<c:if test="${boardDto.boardWriter != null}">
					${memoDto.memoSenderId}
				</c:if>
			</div>
		</div>
	</div>
<!-- 	작성일 -->
	<div class="cell mt-20 flex-area">
		<div>작성일 : <fmt:formatDate value="${memoDto.memoWtime}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></div>
	</div>	
	<hr style="color:#e1e4e6">		
<!-- 	쪽지 내용 -->
	<div class="cell" style="min-height:300px">
		<pre style="font-size:16px;">${memoDto.memoContent}</pre>
	</div>
	<hr style="color:#e1e4e6">
	<a href="/memo/write?memoSenderId=${memoDto.memoSenderId}" class="btn btn-positive">
    	<span>답변하기</span>
	</a>
	<a class="btn btn-neutral" href="./list">목록으로</a>
</div>      