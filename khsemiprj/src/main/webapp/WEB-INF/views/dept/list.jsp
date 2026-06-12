<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"/>
	
<!-- 부서 목록 디자인 css -->
<link rel="stylesheet" type="text/css" href="/css/dept/list.css">

<style>
/* 은은한 그림자가 들어간 부드러운 상자 스타일 */
.custom-card {
    background: #ffffff;
    border-radius: 12px; /* 모서리를 부드럽게 라운딩 */
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05); /* 은은하고 부드러운 그림자 효과 */
    padding: 24px; /* 상자 내부 여백 */
    box-sizing: border-box;
    transition: all 0.3s ease; /* 마우스 올렸을 때 자연스러운 효과용 (선택) */
}

/* 마우스를 올렸을 때 그림자가 살짝 더 선명해지는 효과 (선택사항, 원치 않으면 삭제 가능) */
.custom-card:hover {
    box-shadow: 0 6px 24px rgba(0, 0, 0, 0.08);
}
</style>

<script>
	//부서 목록 json 데이터
	const deptList = JSON.parse('${deptListJson}');
</script>

<!-- 부서 목록 스크립트 -->
<script src="/js/dept/list.js"></script>

<!-- 화면에 나오지 않으면서 언제든지 불러서 쓸 수 있는 화면 조각(템플릿) -->
<script type="text/template" id="dept-template">
<li class="dept-item">
	<div class="dept-row">
		<span class="toggle-btn">▼</span>
		<input type="checkbox" name="dept" class="dept-checkbox" id="dept">
		<label for="dept" class="dept-name">부서명</label>
	</div>
	<ul>
	</ul>
</li>
</script>
<script type="text/template" id="emp-template">
<tr>
	<td><input type="checkbox" name="emp" class="emp-checkbox" id="emp"></td>
	<td></td>
	<td></td>
	<td></td>
	<td></td>
</tr>
</script>
<script type="text/template" id="emp-empty-template">
<tr>
	<td colspan="5">검색된 사원이 없습니다</td>
</tr>
</script>

	<div class="cell flex-area">
		<h1>부서관리</h1>
	</div>
	<div class="cell flex-area">
		<div class="cell w-25 custom-card">
			<div class="cell flex-area" style="justify-content: space-between; align-items: center;">
				<h2>부서 목록</h2>
				<a href="/dept/insert" class="btn btn-positive">부서 등록</a>				
			</div>
			<div id="deptList" class="dept-tree">
				<ul>
					<li class="dept-item">
						<div class="dept-row">
							<span class="toggle-btn" style="visibility:hidden;">▼</span>
							<input type="checkbox" name="dept" class="dept-checkbox" id="dept1_" value="">
							<label for="dept1_" class="dept-name">부서없음</label>
						</div>
					</li>
				</ul>
			</div>
		</div>
		<div class="cell w-50 ms-10 me-10 custom-card">
			<div class="cell">
				<div class="cell flex-area" style="display: flex; justify-content: space-between; align-items: center;">
					<h2>부서별 사원 목록</h2>
					<div style="display: flex; gap: 6px;">
						<a class="btn btn-positive dept-emp-change" style="display:none;">부서장 변경</a>
						<a class="btn btn-positive dept-emp-demotion" style="display:none;">부서장 해제</a>					
					</div>
				</div>
			</div>
			<!-- 테이블 -->
			<div class="cell center w-100">
				<table class="table" style="margin-top: 15px;">
					<thead>
						<tr>
							<th><input type="checkbox" name="emp" class="emp-checkbox check-emp-all"></th>
							<th>부서</th>
							<th>사원아이디</th>
							<th>이름</th>
							<th>직급</th>
						</tr>
					</thead>
					<tbody id="empList">
					</tbody>
				</table>
			</div>
		</div>
		<div class="cell w-25 dept-change-list custom-card">
			<div class="cell flex-area" style="justify-content: space-between; align-items: center;">
				<h2>이동할 부서 목록</h2>
				<a class="btn btn-positive dept-change">변경</a>
			</div>
			<div id="deptList2" class="dept-tree">
				<ul>
					<li class="dept-item">
						<div class="dept-row">
							<span class="toggle-btn" style="visibility:hidden;">▼</span>
							<input type="checkbox" name="dept" class="dept-checkbox" id="dept2_" value="">
							<label for="dept2_" class="dept-name">부서없음</label>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>
	
<jsp:include page="/WEB-INF/views/template/footer.jsp"/>