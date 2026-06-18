<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<!-- 결재 상세 스크립트 -->
<script src="/js/aprv/detail.js"></script>

<script>

	var state = {
		aprvValid: false,
		ok: function(){
			return Object.values(this)
			.filter(v => typeof v==="boolean")
			.every(v => v === true);
		}
	};

	$(function () {
		$(".form-check").on("submit", function(e){
			
			// submit을 유발한 버튼 객체 가져오기
            var clickedButton = e.originalEvent.submitter; 

			if(!state.aprvValid) {
	            // 특정 버튼일 때만 다르게 처리하고 싶다면?
	            if ($(clickedButton).hasClass("aprv-save")) {
	            	$(".form-check").attr("action", "./save");
	            	/* if(confirm("문서를 기안하시겠습니까?")) {
	    				state.aprvValid = true;
	    			} */
	    			openConfirm('문서를 기안하시겠습니까?', 'state.aprvValid = true; $(".aprv-save").click();');
	            } else if($(clickedButton).hasClass("aprv-delete")) {
	            	$(".form-check").attr("action", "./delete");
	            	/* if(confirm("문서를 삭제하시겠습니까?")) {
	    				state.aprvValid = true;
	    			} */
	            	openConfirm('문서를 삭제하시겠습니까?', 'state.aprvValid = true; $(".aprv-delete").click();');
	            } else {
	            	alert("잘못된 접근입니다. 페이지를 새로고침합니다.");
	            	location.reload();
	            }
			}
			
			return state.ok();
		});
	});

</script>

<div class="container w-80 mt-20 mb-50 background-card">
	<div class="cell">
		<div class="flex-area" style="align-items:end">
			<div>
				<h1 class="mt-0 mb-0">
					<!-- 결재 분류 -->
					[${aprvDetailVO.headName}]
					<!-- 제목 -->
					${aprvDetailVO.aprvTitle}
					<!-- 상태 -->
				</h1>
			</div>
			<div class="ms-40">
				<span>[ ${aprvDetailVO.deptName} ] ${aprvDetailVO.empName} ${aprvDetailVO.empPositionName} ( ${aprvDetailVO.aprvWriter} )</span>
			</div>
		</div>
	</div>
	
	<c:if test="${not empty aprvDetailVO.aprvWtime}">
	<div class="cell mt-20">
		<div>기안일 : <fmt:formatDate value="${aprvDetailVO.aprvWtime}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></div>
	</div>
	<hr>
	</c:if>
	<div class="cell mt-20">
	<c:choose>
	<c:when test="${aprvDetailVO.headName == '비용'}">
	지출일자 : ${aprvDetailVO.aprvSdate}
	</c:when>
	<c:when test="${aprvDetailVO.headName == '사직'}">
	퇴사일자 : ${aprvDetailVO.aprvSdate}
	</c:when>
	<c:otherwise>
	기한 : ${aprvDetailVO.aprvSdate} ~ ${aprvDetailVO.aprvEdate} <c:if test="${not empty aprvDetailVO.aprvLeave}">[ 연차사용 ${aprvDetailVO.aprvLeave}일 ]</c:if>
	</c:otherwise>
	</c:choose>
	</div>
	<hr>
	<div class="cell mt-20">
		<div>상태 : ${aprvDetailVO.aprvStatus}</div>
	</div>
	<hr>
	<div class="cell" style="min-height:50px">
		<!-- 있는 그대로의 출력을 수행하는 태그(엔터, 스페이스 등을 인정) -->
		<pre>${aprvDetailVO.aprvContent}</pre>
	</div>
	<c:if test="${attachDto != null}">
	<hr>
	<div class="cell">
	    <label>첨부 파일</label>
	</div>
    <div class="cell aprv-form-file">
    	<a style="display: inline-block; border: 1px solid #333; background: white; color: black; padding: 5px 15px; text-decoration: none; border-radius: 3px; font-size: 14px;" href="/download/legacy?attachNo=${attachDto.attachNo}">
    		<i class="fa-regular fa-file"></i><span>${attachDto.attachName}</span>
   		</a>
    </div>
    </c:if>
	<hr>
	<div class="cell flex-area">
		<div class="cell w-50 me-10">
			<div class="cell mb-0">
	            <label>1차 결재 라인</label>
	        </div>
	        <div class="cell w-100 mt-0">
	        	<table class="table">
	        		<thead>
	        			<tr>
		        			<th width="25%">부서</th>
		        			<th width="25%">결재자</th>
		        			<th width="20%">직책</th>
		        			<th width="30%">상태</th>
	        			</tr>
	        		</thead>
	        		<tbody id="line1List" class="lineList">
	        			<c:forEach var="aprvLineList" items="${aprvLine1List}">
	        			<tr>
	        				<td>${aprvLineList.deptName}</td>
	        				<td>${aprvLineList.empName}</td>
	        				<td>${aprvLineList.empPositionName}</td>
        					<td data-no="${aprvLineList.aprvLineNo}" style="font-weight:bold;">
	        				<c:choose>
		        				<c:when test="${aprvDetailVO.aprvStatus == '대기' && aprvLineList.aprvLineStatus == '대기' && aprvLineList.empId == sessionScope.loginId}">
        						<button type="button" class="btn btn-positive line-accept" onclick="openModal('${aprvLineList.aprvLineNo}', '승인')">승인</button>
        						<button type="button" class="btn btn-negative line-deny" onclick="openModal('${aprvLineList.aprvLineNo}', '반려')">반려</button>
		        				</c:when>
		        				<c:otherwise>
			        				<c:choose>
			        					<c:when test="${aprvDetailVO.aprvStatus == '승인'}"><span class="blue">${aprvLineList.aprvLineStatus}</span></c:when>
			        					<c:when test="${aprvDetailVO.aprvStatus == '반려'}"><span class="red">${aprvLineList.aprvLineStatus}</span></c:when>
			        					<c:otherwise><span>${aprvLineList.aprvLineStatus}</span></c:otherwise>
			        				</c:choose>
		        				</c:otherwise>
	        				</c:choose>
        					</td>
	        			</tr>
	        			</c:forEach>
	        		</tbody>
	        	</table>
	        </div>
		</div>
		<div class="cell w-50 ms-10">
			<div class="cell mb-0">
	            <label>2차 결재 라인</label>
	        </div>
	        <div class="cell w-100 mt-0">
	        	<table class="table">
	        		<thead>
	        			<tr>
		        			<th width="25%">부서</th>
		        			<th width="25%">결재자</th>
		        			<th width="20%">직책</th>
		        			<th width="30%">상태</th>
	        			</tr>
	        		</thead>
	        		<tbody id="line2List" class="lineList">
	        			<c:choose>
	        			<c:when test="${not empty aprvLine2List}">
	        			<c:forEach var="aprvLineList" items="${aprvLine2List}">
	        			<tr>
	        				<td>${aprvLineList.deptName}</td>
	        				<td>${aprvLineList.empName}</td>
	        				<td>${aprvLineList.empPositionName}</td>
		        			<td data-no="${aprvLineList.aprvLineNo}" style="font-weight:bold;">
	        				<c:choose>
		        				<c:when test="${aprvDetailVO.aprvStatus == '대기' && aprvLineList.aprvLineStatus == '대기' && aprvDetailVO.aprvCurrentSeq == '2' && aprvLineList.empId == sessionScope.loginId}">
        						<button type="button" class="btn btn-positive line-accept" onclick="openModal('${aprvLineList.aprvLineNo}', '승인')">승인</button>
        						<button type="button" class="btn btn-negative line-deny" onclick="openModal('${aprvLineList.aprvLineNo}', '반려')">반려</button>
		        				</c:when>
		        				<c:otherwise>
			        				<c:choose>
			        					<c:when test="${aprvDetailVO.aprvStatus == '승인'}"><span class="blue">${aprvLineList.aprvLineStatus}</span></c:when>
			        					<c:when test="${aprvDetailVO.aprvStatus == '반려'}"><span class="red">${aprvLineList.aprvLineStatus}</span></c:when>
			        					<c:otherwise><span>${aprvLineList.aprvLineStatus}</span></c:otherwise>
			        				</c:choose>
		        				</c:otherwise>
		        			</c:choose>
        					</td>
	        			</tr>
	        			</c:forEach>
	        			</c:when>
	        			<c:otherwise>
	        			<tr>
	        				<td colspan="4">2차 결재 라인 목록이 없습니다</td>
	        			</tr>
	        			</c:otherwise>
	        			</c:choose>
	        		</tbody>
	        	</table>
	        </div>
		</div>
	</div>
	<div class="cell right">
		<form method="post" class="form-check">
		<a class="btn btn-neutral" href="./list">목록으로</a>
		<input type="hidden" name="aprvNo" value="${param.aprvNo}" />
		<c:if test="${aprvDetailVO.aprvStatus == '임시저장' && aprvDetailVO.aprvWriter == sessionScope.loginId}">
		<a class="btn btn-save" href="./edit?aprvNo=${aprvDetailVO.aprvNo}">수정</a>
		<button class="btn btn-positive aprv-save">기안하기</button>
		<button class="btn btn-negative aprv-delete">삭제</button>
		</c:if>
		</form>
	</div>
</div>

<div class="modal-overlay" id="modalOverlay">
    <div class="modal-box">
        <div class="modal-header center">결재 승인</div>
        
        <div class="modal-body">
            <form id="popupForm" class="flex-area">
            	<div class="cell w-100">
            		<input type="hidden" name="aprvLineNo" value="" />
            		<input type="hidden" name="aprvLineStatus" value="대기" />
            		<input type="text" name="aprvLineComment" class="field w-100" placeholder="결재 코멘트" />
				</div>
            </form>
        </div>
        <div class="modal-footer">
        	<button type="button" class="btn btn-negative" onclick="closeModal()">취소</button>
        	<button type="button" class="btn btn-positive" onclick="aprvLineUpdate()">입력 완료</button>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>