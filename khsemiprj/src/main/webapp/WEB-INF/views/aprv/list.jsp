<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<!-- 결재 목록 디자인 css -->
<link rel="stylesheet" type="text/css" href="/css/aprv/list.css">

<!-- 결재 목록 스크립트 -->
<script src="/js/aprv/list.js"></script>

<style>
	select, option, input {
		font-weight: bold;
	}
</style>

<div class="container w-1200 mt-50 mb-50">

	<div class="cell center mb-0">
		<h1 class="mb-0">결재 목록</h1>
	</div>

	<!-- <div class="cell center">타인에 대한 무분별한 비방글은 예고 없이 삭제될 수 있습니다.</div> -->
	
	
	<div class="cell center flex-area">
		<div class="w-20 flex-area flex-center">
        </div>
		<div class="w-60 flex-area flex-center">
			<form action="./list" method="get">
				<select name="aprvStatus" class="field">
					<option value="" ${param.aprvStatus=="" ? "selected" : ""}>전체</option>
					<option value="대기" ${param.aprvStatus=="대기" ? "selected" : ""}>대기</option>
					<option value="승인" ${param.aprvStatus=="승인" ? "selected" : ""} class="blue">승인</option>
					<option value="반려" ${param.aprvStatus=="반려" ? "selected" : ""} class="red">반려</option>
				</select>
				<select name="column" class="field">
					<option value="aprv_title"
						${param.column=="aprv_title" ? "selected" : ""}>제목</option>
					<option value="aprv_writer"
						${param.column=="aprv_writer" ? "selected" : ""}>기안자</option>
				</select> <input type="text" name="keyword" class="field" placeholder="검색어 입력"
					value="${param.keyword}">
				<button type="submit" class="btn btn-positive">
					<i class="fa-solid fa-magnifying-glass"></i> <span>검색</span>
				</button>
			</form>
		</div>
		<div class="w-20 flex-area" style="justify-content: right; align-items: center;">
			<c:if test="${sessionScope.loginId != null}">
				<button type="button" onclick="openModal();" class="btn btn-neutral">결재 등록</button>
			</c:if>
		</div>
	</div>

	<div class="cell right">
		${pageVO.getBeginRownum()}-${pageVO.endRownum} / 총 ${pageVO.count}개의 글
	</div>

	<div class="cell">
		<table class="table">
			<thead>
				<tr>
					<th width="6%">번호</th>
					<th width="5%">분류</th>
					<th width="36%">제목</th>
					<th width="5%">상태</th>
					<th width="27%">기안자</th>
					<th width="12%">기안일자</th>
				</tr>
			</thead>
				<tbody>
				<c:choose>
				<c:when test="${not empty aprvList}">
				<c:forEach var="aprvDetailVO" items="${aprvList}">
					<tr>
						<td>${aprvDetailVO.aprvNo}</td>
						<td>${aprvDetailVO.headName}</td>
						<td class="left"><a href="./detail?aprvNo=${aprvDetailVO.aprvNo}">${aprvDetailVO.aprvTitle}</a></td>
						<td style="font-weight:bold;">
							<c:choose>
							<c:when test="${aprvDetailVO.aprvStatus == '승인'}"><span class="blue">${aprvDetailVO.aprvStatus}</span></c:when>
							<c:when test="${aprvDetailVO.aprvStatus == '반려'}"><span class="red">${aprvDetailVO.aprvStatus}</span></c:when>
							<c:otherwise>${aprvDetailVO.aprvStatus}</c:otherwise>
							</c:choose>
						</td>
						<td class="left" style="padding-left:20px;"><span>[ ${aprvDetailVO.deptName} ] ${aprvDetailVO.empName} ${aprvDetailVO.empPositionName} ( ${aprvDetailVO.aprvWriter} )</span></td>
						<td><fmt:formatDate value="${aprvDetailVO.aprvWtime}" pattern="yyyy-MM-dd HH:mm" /></td>
					</tr>
				</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="6">조건에 맞는 결재정보가 없습니다</td>
					</tr>
				</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>
	<!-- 페이지네이션 -->
	<div class="cell mt-40">
		<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
	</div>
</div>


<div class="modal-overlay" id="modalOverlay">
    <div class="modal-box">
        <div class="modal-header center">결재 양식 선택</div>
        
        <div class="modal-body">
            <form id="popupForm1" class="flex-area">
            	<div class="cell w-100">
            		<c:forEach var="aprvFormDto" items="${formList}">
            		<div class="cell">
            			<a href="/aprv/insert?formNo=${aprvFormDto.formNo}" class="btn btn-neutral w-100" style="text-align:left;"><span>[${aprvFormDto.headName}] ${aprvFormDto.formName}</span></a>
            		</div>
	                </c:forEach>
				</div>
            </form>
        </div>
        <div class="modal-footer">
        	<button type="button" class="btn btn-negative" onclick="closeModal()">취소</button>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>