<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-950 mt-50 mb-50">
	<div class="cell">
			<h1 class="mt-0 mb-0">회원 관리</h1>
	</div>
	
			
				<%-- <c:if test="${sessionScope.loginLevel >= 0 && wList.size() > 0}"> --%>
				<div class="cell">
						<h3 class="mt-0 black">승인 대기 사원 목록</h3>
						
						<table class="table" style="background-color: white;">
							<thead>
								<tr>
									<th></th>
									<th></th>
									<th></th>
								</tr>
							</thead>
							<tbody align="center">
								<c:forEach var="waitEmp" items="${wList}">
								<tr>
									<td>${waitEmp.empId}</td>
									<td>${waitEmp.empName}</td>
									<td>
										<button type="button" class="btn btn-positive" onclick="openPopUp('${waitEmp.empId}')" style="padding: 4px 8px; font-size: 12px;">승인</button>
										<a href="reject?empId=${waitEmp.empId}" class="btn btn-negative" style="padding: 4px 8px; font-size: 12px;">거절</a>
									</td>
								</tr>
								</c:forEach>
							</tbody>
						</table>
				</div>
				<hr class="mt-30 mb-30">
				<%-- </c:if> --%>
				
				
		<div class="cell" style="display: flex; justify-content: flex-end;">
			<form action="./list" method="get" style="margin-left:auto;">
				<select name="column" class="field">
					<option value="emp_id" ${param.column == 'emp_id' ? 'selected' : ''}>아이디</option>
					<option value="emp_name" ${param.column == 'emp_name' ? 'selected' : ''}>이름</option>
					<option value="dept_name" ${param.column == 'dept_name' ? 'selected' : ''}>부서명</option>
					<option value="emp_position_name" ${param.column == 'emp_position_name' ? 'selected' : ''}>직급</option>
				</select>
				<input type="text" name="keyword" class="field" value="${param.keyword}">
				<button class="btn btn-positive">
					<i class="fa-solid fa-magnifying-glass"></i>
					<span>검색</span>
				</button>
			</form>
	</div>
	
	
	<c:if test="${param.column != null && param.keyword != null && param.keyword != ''}">
	<div class="cell">
		<h3>총 <span class="red">${list.size()}</span>명의 회원이 검색되었습니다</h3>
	</div>
	</c:if>
	
	
	<c:if test="${list.size() > 0}">
	<div class="cell">
		<table class="table">
			<thead>
				<tr>
					<th>사원 아이디</th>
					<th>이름</th>
					<th>부서</th>
					<th>직급</th>
				</tr>
			</thead>
			<tbody align="center">
				<c:forEach var="empPositionDto" items="${list}">
				<tr>
					<td>
					<a href="detail?empId=${empPositionDto.empId}">
					${empPositionDto.empId}
					</a>
					</td>
					<td>${empPositionDto.empName}</td>
					<td>${empPositionDto.deptName}</td>
					<td>${empPositionDto.empPositionName}</td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	</c:if>
</div>


<div id="popUp" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); z-index: 9999;">
    <div style="background-color: white; width: 400px; margin: 15% auto; padding: 20px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);">
        <h3 class="mt-0 blue">사원 가입 승인</h3>
        
        <form action="approve" method="post" style="display: flex; flex-direction: column; gap: 15px;">
            <input type="hidden" name="empId" id="postEmpId">
            
            <div>
                <label>입사일 지정</label>
                <input type="date" name="empHireDate" class="field w-100" required>
            </div>
            
            <div>
                <label>부서 배치</label>
                <select name="deptNo" class="field w-100" required>
                    <option value="">부서를 선택하세요</option>
                    <c:forEach var="dept" items="${deptList}">
                    <option value="${dept.deptNo}">${dept.deptName}</option>
                    </c:forEach>
                </select>
            </div>
            
             <div>
                <label>직급 지정</label>
                <select name="empPositionNo" class="field w-100">
                	<option value="">선택</option>
                	
                	<c:forEach var="position" items="${positionList}">
		            	<option value="${position.empPositionNo}">${position.empPositionName}</option>
                	</c:forEach>
	            </select>
            </div>
            
            <div style="display: flex; gap: 10px; justify-content: flex-end;">
                <button type="button" class="btn btn-negative" onclick="closePopUp()">취소</button>
                <button type="submit" class="btn btn-positive">입력 완료</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>


<script>
    // 팝업 함수
    function openPopUp(empId) {
        document.getElementById('postEmpId').value = empId;
        document.getElementById('popUp').style.display = 'block';
    }

    function closePopUp() {
        document.getElementById('popUp').style.display = 'none';
    }
</script>

