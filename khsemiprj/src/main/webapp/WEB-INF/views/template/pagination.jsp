<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 페이지네이션 -->
<div class="pagination">
	<!-- 이전 -->
	<c:if test="${pageVO.hasPrevious()}">
	<a href="./list?page=${pageVO.getPreviousBlock()}&${pageVO.getSearchParams()}">
		<i class="fa-solid fa-chevron-left"></i>
	</a>
	</c:if>

	<!-- 숫자 --> 
	<c:forEach var="i" begin="${pageVO.getBeginBlock()}" end="${pageVO.getEndBlock()}" step="1">
		<!-- 현재 페이지의 번호를 출력하는 경우(활성화 처리 필요) -->
		<c:if test="${pageVO.page == i}">
			<a href="#" class="on">${i}</a>
		</c:if>
		<!-- 현재 페이지가 아닌 번호를 출력하는 경우 -->
		<c:if test="${pageVO.page != i}">
			<a href="./list?page=${i}&${pageVO.getSearchParams()}">${i}</a>
		</c:if>
	</c:forEach>
	
	<!-- 다음 -->
	<c:if test="${pageVO.hasNext()}">
		<a href="./list?page=${pageVO.getNextBlock()}&${pageVO.getSearchParams()}">
			<i class="fa-solid fa-chevron-right"></i>
		</a>
	</c:if>
</div>