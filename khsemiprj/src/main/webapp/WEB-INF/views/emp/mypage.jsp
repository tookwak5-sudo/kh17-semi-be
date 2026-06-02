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
			<div class="w-75 blue">${empDto.empBirth}</div>
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


		<div class="flex-area">
			<div class="w-25">승인상태</div>
			<div class="w-75 blue">${findEmpDto.empValid}</div>
		</div>

		<div class="flex-area">
			<div class="w-25">승인날짜</div>
			<div class="w-75 blue">${findEmpDto.empValidDate}</div>
		</div>

		<div class="flex-area">
			<div class="w-25">장기 휴가 시작일</div>
			<div class="w-75 blue">${findEmpDto.empLongLeave}</div>
		</div>
		<!-- 		로그인 이력은 dto dao 구현 해야합니다 -->
		<div class="flex-area">
			<div class="w-25">로그인 이력</div>
			<div class="w-75 blue">2026.06.01</div>
		</div>

		<div class="flex-area">
			<div class="w-25">최종 비밀번호 변경일</div>
			<div class="w-75 blue">${findEmpDto.empChange}</div>
		</div>

	</div>


	<div class="cell">

		<h1>${findEmpDto.empName}님의휴가 정보</h1>

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