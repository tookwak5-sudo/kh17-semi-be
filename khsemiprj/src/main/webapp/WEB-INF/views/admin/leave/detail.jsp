<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
	/* 휴가 정보 카드 스타일 */
	.vacation-card {
	    background: #ffffff;
	    border-radius: 16px;
	    padding: 24px;
	    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
	    border: 1px solid #e2e8f0;
	    margin-top: 30px;
	}
	
	/* 테이블 디자인 */
	.vacation-table {
	    width: 100%;
	    border-collapse: separate;
	    border-spacing: 0;
	    margin-top: 15px;
	}
	.vacation-table th {
	    background-color: #f8fafc;
	    padding: 16px;
	    border-bottom: 2px solid #e2e8f0;
	    color: #475569;
	    font-weight: 600;
	}
	.vacation-table td {
	    padding: 16px;
	    border-bottom: 1px solid #f1f5f9;
	    text-align: center;
	    color: #334155;
	}
	
	/* 섹션 제목 컨테이너 */
	.section-header {
	    display: flex;
        flex-direction: column;
        align-items: flex-start;
        margin-bottom: 24px;
        padding-left: 12px;
        border-left: 4px solid #4f46e5;
	}
	
	/* 제목 텍스트 스타일 */
	.section-title {
	    font-size: 20px;
        font-weight: 700;
        color: #1e293b;
        margin: 0;
	}
	
	/* 서브 문구 */
	.section-subtitle {
	    font-size: 14px;
        color: #64748b;
        margin-top: 5px;
        margin-left: 0;
	}
</style>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-90 mt-20 mb-50 background-card">
	<div class="profile-info">
		<div class="profile-name">${empDto.empName} ${empPositionDeptDto.empPositionName} </div>
		<div class="profile-dept-pos">${empPositionDeptDto.deptName}</div>
	</div>
	
	<div class="cell">
		<img src="/emp/profile?empId=${empDto.empId}" width="100" height="100"
			style="border-radius:50%; box-shadow:0 0 1px 0 black">
	</div>
	
	
	<div class="section-header mt-50">
	    <h1 class="section-title">휴가 현황</h1>
	    <span class="section-subtitle">연차 사용 및 잔여 현황</span>
	</div>
	
	<div class="vacation-card">
	    <table class="vacation-table">
	        <thead>
	            <tr>
	                <th>연도</th>
	                <th>총 연차</th>
	                <th>사용 연차</th>
	                <th>잔여 연차</th>
	            </tr>
	        </thead>
	        <tbody>
	            <c:choose>
	        		<c:when test="${empty empLeaveList}">
	        			<tr>
	        				<td colspan="4" style="padding: 40px; color: #64748b; font-weight: 500;">
	        					<i class="fa-solid fa-circle-exclamation" style="margin-right: 8px;"></i>등록된 휴가 데이터가 없습니다.
	        				</td>
	        			</tr>
	        		</c:when>
	        		
	        		<c:otherwise>
			            <c:forEach var="leave" items="${empLeaveList}">
			                <tr>
			                	<td><strong>${leave.leaveYear}년</strong></td>
			                	
			                    <td>
								    <form action="edit" method="post" style="display: flex; justify-content: center; align-items: center; gap: 8px; margin: 0;">
								        <input type="hidden" name="leaveEmpId" value="${empDto.empId}">
								        <input type="hidden" name="leaveYear" value="${leave.leaveYear}">
								        
								        <input type="number" name="leaveTotal" value="${leave.leaveTotal}" step="0.5" min="0"
								               style="width: 60px; padding: 4px; border: 1px solid #ccc; border-radius: 4px; text-align: center;">일
								        
								        <button type="button" onclick="checkLeaveLimit(this)" style="padding: 4px 10px; background-color: #4f46e5; 
								        	color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 12px;">수정
								        </button>
								    </form>
								</td>
								
			                    <td><span style="color: #ef4444;">${leave.leaveUsed}일</span></td>
			                    
			                    <td><strong>${leave.leaveRemain}일</strong></td>
			                </tr>
			            </c:forEach>
		            </c:otherwise>
	            </c:choose>
	        </tbody>
	    </table>
	    <div class="cell" style="display: flex; justify-content: flex-end; gap: 10px;">
			<c:if test="${param.keyword==null}">
				<a href="list" class="btn btn-positive view-mode">
					<i class="fa-solid fa-list"></i> 목록으로
				</a>
			</c:if>
			<c:if test="${param.keyword!=null}">
				<a href="list?column=${param.column}&keyword=${param.keyword}" class="btn btn-positive view-mode">
					<i class="fa-solid fa-list"></i> 목록으로
				</a>
			</c:if>
		</div>
	</div>
	
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>

	
<script>
	function checkLeaveLimit(btn) {
	    var form = btn.closest('form');
	    var leaveTotalInput = form.querySelector('input[name="leaveTotal"]');
	    var leaveTotal = parseFloat(leaveTotalInput.value);
	
	 	// 값이 없거나 0보다 작을 때
	    if (isNaN(leaveTotal) || leaveTotal < 0) {
	        
	        if(typeof showAjaxAlarm === 'function') {
	            showAjaxAlarm("0 이상이어야 합니다.", "btn-negative", leaveTotalInput);
	            
	            var $target = $(leaveTotalInput);
	            $('#div-alarm').css({
	                'top': ($target.offset().top + $target.outerHeight() + 8) + "px",
	                'left': $target.offset().left + "px",                            
	                'transform-origin': 'top center'                                 
	            });
	            
	        } else {
	            openAlert("0 이상이어야 합니다."); 
	        }
	        
	        leaveTotalInput.focus();
	        return; 
	    }
	
	    form.submit();
	}
</script>