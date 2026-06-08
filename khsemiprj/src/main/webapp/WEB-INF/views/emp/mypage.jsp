<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />

<h1>마이 페이지</h1>

<div class="container w-950 mt-50 mb-50">
	<div class="cell">

		<h1>${findEmpDto.empName}님의정보</h1>



	</div>

	<div class="cell">
		<div class="flex-area">
			<div class="w-25">아이디</div>
			<div class="w-75 blue">${findEmpDto.empId}</div>
		</div>

		<div class="flex-area">
			<div class="w-25">이메일</div>
			<div class="w-75 blue">${findEmpDto.empEmail}</div>
		</div>

		<div class="flex-area">
			<div class="w-25">생년월일</div>
			<div class="w-75 blue">${findEmpDto.empBirth}</div>
		</div>

		<div class="flex-area">
			<div class="w-25">연락처</div>
			<div class="w-75 blue">${findEmpDto.empContact}</div>
		</div>

		<div class="flex-area">
			<div class="w-25">우편번호</div>
			<div class="w-75 blue">${findEmpDto.empPost}</div>
		</div>

		<div class="flex-area">
			<div class="w-25">도로명주소</div>
			<div class="w-75 blue">${findEmpDto.empAddress1}</div>
		</div>

		<div class="flex-area">
			<div class="w-25">상세주소</div>
			<div class="w-75 blue">${findEmpDto.empAddress2}</div>
		</div>




		<div class="mt-40 mb-20">
			<table class="table">
				<thead>
					<tr>
						<th class="center black">최종로그인</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="center"><c:if test="${lastAccess != null}">
                                ${lastAccess.accessDate} republic of korea, seoul ${lastAccess.accessIp}
                            </c:if> <c:if test="${lastAccess == null}">
                                접속 기록이 존재하지 않습니다.
                            </c:if></td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="right">
			<a href="/emp/checkPassword" class="btn btn-neutral">정보 수정</a>
		</div>
		
		<div class="right">
			<a href="/emp/changePassword" class="btn btn-neutral">비밀번호 수정</a>
		</div>
		
		
	</div>

</div>


<div class="cell">

	<h1>${findEmpDto.empName}님의휴가정보</h1>

</div>


<table border="1">
	<thead>
		<tr>
			<th>연도</th>
			<th>총 연차</th>
			<th>사용 연차</th>
			<th>잔여 연차</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="leave" items="${empLeaveList}">
			<tr>
				<td>${leave.leaveYear}년</td>
				<td>${leave.leaveTotal}일</td>
				<td>${leave.leaveUsed}일</td>
				<td>${leave.leaveRemain}일</td>
			</tr>
		</c:forEach>
	</tbody>
</table>

</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp" />