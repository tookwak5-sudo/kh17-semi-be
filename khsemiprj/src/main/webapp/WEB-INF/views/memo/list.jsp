<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/memoHeader.jsp"></jsp:include> 
  
<style>
	.table-hover tbody tr:hover {
		background-color : #f8f9fa;
		transition: background-color 0.2s ease;
	}
	
	.field {
	    border: 1px solid #ced4da; 
	    border-radius: 6px; 
	    padding: 5px 10px; 
	    outline: none;
	    transition: border-color 0.2s ease, box-shadow 0.2s ease;
	}
	
	.field:focus {
	    border-color: #739BED;
	    box-shadow: 0 0 0 3px rgba(115, 155, 237, 0.2);
	}
	
	.unread-badge {
		background-color: #ff6b6b;
		color: white;
		padding: 2px 6px;
		border-radius: 4px;
		font-size: 12px;
		font-weight: bold;
	}
</style>

<div class="container w-600 mt-0 mb-50">
	<div class="cell">
		<h1 class="mt-0 mb-0">받은 쪽지함</h1>
	</div>
	
	<div class="cell" style="display: flex; justify-content: flex-end;">
		<form action="./list" method="get" style="margin-left:auto; display: flex; align-items: center; gap: 8px">
			<select name="column" class="field" style="padding: 8px 18px; font-size: 16px;">
				<option value="memo_sender_id" ${pageVO.column == 'memo_sender_id' ? 'selected' : ''}>보낸사람</option>
				<option value="memo_title" ${pageVO.column == 'memo_title' ? 'selected' : ''}>제목</option>
				<option value="memo_content" ${pageVO.column == 'memo_content' ? 'selected' : ''}>내용</option>
			</select>
			<input type="text" name="keyword" class="field" value="${pageVO.keyword}" placeholder="검색어를 입력하세요" style="padding: 8px 18px; font-size: 16px;">
			<button class="btn btn-positive" style="padding: 8px 18px; font-size: 16px;">
				<i class="fa-solid fa-magnifying-glass"></i>
				<span>검색</span>
			</button>
		</form>
	</div>
	
	<c:if test="${pageVO.keyword != null && pageVO.keyword != ''}">
	<div class="cell">
		<h3>총 <span class="blue">${pageVO.count}</span>개의 쪽지가 검색되었습니다</h3>
	</div>
	</c:if>
	
	<div class="cell">
		<div style="border: 1px solid #e9ecef; border-radius: 8px; overflow: hidden;">
			<table class="table table-hover" style="background-color: white; margin-bottom: 0;">
				<thead>
					<tr style="border-bottom: 2px solid #e9ecef;">
						<th width="10%">분류</th>
						<th width="40%">제목</th>
						<th width="25%">보낸사람</th>
						<th width="25%">받은시간</th>
					</tr>
				</thead>
				<tbody align="center">
					<c:choose>
						<c:when test="${empty list}">
							<tr>
								<td colspan="5" style="padding: 30px; color: #6c757d;">도착한 쪽지가 없습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="memo" items="${list}">
								<tr>
									<td>
										<c:choose>
											<c:when test="${memo.memoType == '공지'}"><span style="color: #e84118; font-weight:bold;">[공지]</span></c:when>
											<c:when test="${memo.memoType == '결재'}"><span style="color: #0097e6; font-weight:bold;">[결재]</span></c:when>
											<c:otherwise><span style="color: #7f8fa6;">[일반]</span></c:otherwise>
										</c:choose>
									</td>
									<td align="left" style="padding-left: 15px; font-weight: ${memo.memoReadStatus == 'N' ? 'bold' : 'normal'};">
										<c:if test="${memo.memoReadStatus == 'N'}">
											<span class="unread-badge">New</span>
										</c:if>
										<c:if test="${memo.memoReadStatus == 'Y'}">
											<span style="color: #adb5bd;">읽음</span>
										</c:if>
										<a href="./detail?memoNo=${memo.memoNo}">
											${memo.memoTitle}										
										</a>
									</td>
									<td>${memo.memoSenderId}(${memo.empName})</td>
									<td>
										<fmt:formatDate value="${memo.memoWtime}" pattern="yyyy-MM-dd HH:mm"/>
									</td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
		<div class="cell right">
				<a class="btn btn-positive" href="./write">쪽지쓰기</a>
		</div>
	</div>

	<div class="cell">    
		<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
	</div>
</div>
