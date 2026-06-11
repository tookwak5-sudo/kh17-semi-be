<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<script>

	$(function () {
		var state = {
				aprvValid: false,
				ok: function(){
					return Object.values(this)
					.filter(v => typeof v==="boolean")
					.every(v => v === true);
				}
		};
		
		$(".form-check").on("submit", function(e){
			
			// submit을 유발한 버튼 객체 가져오기
            var clickedButton = e.originalEvent.submitter; 

            // 특정 버튼일 때만 다르게 처리하고 싶다면?
            if ($(clickedButton).hasClass("aprv-save")) {
            	$(".form-check").attr("action", "./save");
            	if(confirm("문서를 기안하시겠습니까?")) {
    				state.aprvValid = true;
    			}
            } else if($(clickedButton).hasClass("aprv-delete")) {
            	$(".form-check").attr("action", "./delete");
            	if(confirm("문서를 삭제하시겠습니까?")) {
    				state.aprvValid = true;
    			}
            } else {
            	alert("잘못된 접근입니다. 페이지를 새로고침합니다.");
            	location.reload();
            }
			
			return state.ok();
		});
	});

</script>

<div class="container w-1200 mt-50 mb-50">
	<div class="cell">
		<div class="flex-area" style="align-items:end">
			<div>
				<h1 class="mt-0 mb-0">
					<!-- 결재 분류 -->
					[${aprvDto.aprvFormNo}]
					<!-- 제목 -->
					${aprvDto.aprvTitle}
					<!-- 상태 -->
				</h1>
			</div>
			<div class="ms-40">
				${aprvDto.aprvWriter}
			</div>
		</div>
	</div>
	
	<c:if test="${not empty aprvDto.aprvWtime}">
	<div class="cell mt-20">
		<div>기안일 : <fmt:formatDate value="${aprvDto.aprvWtime}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></div>
	</div>
	</c:if>
	<div class="cell mt-20">
		<div>상태 : ${aprvDto.aprvStatus}</div>
	</div>
	
	<hr>
	<div class="cell" style="min-height:50px">
		<!-- 있는 그대로의 출력을 수행하는 태그(엔터, 스페이스 등을 인정) -->
		<pre>${aprvDto.aprvContent}</pre>
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
		        			<th>부서</th>
		        			<th>결재자</th>
		        			<th>직책</th>
		        			<th>상태</th>
	        			</tr>
	        		</thead>
	        		<tbody id="line1List" class="lineList">
	        			<c:forEach var="aprvLineList" items="${aprvLine1List}">
	        			<tr>
	        				<td>${aprvLineList.deptName}</td>
	        				<td>${aprvLineList.empName}</td>
	        				<td>${aprvLineList.empPositionName}</td>
	        				<c:choose>
		        				<c:when test="${aprvDto.aprvStatus == '대기' && aprvLineList.aprvLineStatus == '대기' && aprvLineList.empId == sessionScope.loginId}">
        					<td>
        						<button type="button" class="btn btn-positive line-accept">승인</button>
        						<button type="button" class="btn btn-negaitve line-deny">반려</button>
        					</td>
		        				</c:when>
		        				<c:otherwise>
	        				<td>${aprvLineList.aprvLineStatus}</td>
		        				</c:otherwise>
	        				</c:choose>
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
		        			<th>부서</th>
		        			<th>결재자</th>
		        			<th>직책</th>
		        			<th>상태</th>
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
	        				<td>${aprvLineList.aprvLineStatus}</td>
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
		<input type="hidden" name="aprvNo" value="${param.aprvNo}" />
		<c:if test="${aprvDto.aprvStatus == '임시저장' && aprvDto.aprvWriter == sessionScope.loginId}">
		<button class="btn btn-positive aprv-save">기안하기</button>
		<a class="btn btn-negative" href="./edit?aprvNo=${aprvDto.aprvNo}">수정</a>
		<button class="btn btn-negative aprv-delete">삭제</button>
		</c:if>
		<a class="btn btn-neutral" href="./list">목록으로</a>
		</form>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>