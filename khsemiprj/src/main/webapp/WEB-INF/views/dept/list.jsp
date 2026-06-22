<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"/>
	
<link rel="stylesheet" type="text/css" href="/css/dept/list.css">

<style>
/* 은은한 그림자가 들어간 부드러운 상자 스타일 */
.custom-card {
    background: #ffffff;
    border: 1px solid #E2E8F0; /* 아주 연한 회색 테두리 */
    border-radius: 12px; /* 모서리를 부드럽게 라운딩 */
    box-shadow: 0 2px 4px rgba(0,0,0,0.05); /* 아주 연한 그림자 */
    padding: 24px; /* 상자 내부 여백 */
    box-sizing: border-box;
    transition: all 0.3s ease; /* 마우스 올렸을 때 자연스러운 효과용 (선택) */
}

/* 마우스를 올렸을 때 그림자가 살짝 더 선명해지는 효과 */
.custom-card:hover {
    box-shadow: 0 6px 24px rgba(0, 0, 0, 0.08);
}

.table tbody tr td.empty-msg {
    display: table-cell !important;      /* 셀 속성 강제 */
    text-align: center !important;       /* 가로 중앙 */
    vertical-align: middle !important;   /* 세로 중앙 */
    width: 100% !important;              /* 표 전체 너비 활용 */
    padding: 50px 0 !important;          /* 높이 확보 */
    border-bottom: none !important;      /* 줄 제거 */
}

/* 템플릿의 tr 자체가 정렬을 방해하지 않도록 처리 */
.table tbody tr.empty-row {
    display: table-row !important;
/* [수정] 헤더 영역 내부 요소를 세로축 기준 완벽한 중앙(Center) 정렬 */
.card-header {
    margin-top: 0 !important;
    padding-top: 0 !important;
    display: flex;
    justify-content: space-between;
    align-items: center; /* 버튼 높이에 맞춰 h2가 정중앙에 오도록 설정 */
}

/* [수정] h2 폰트 자체의 여백을 리셋하고 라인 높이를 정돈 */
.custom-card h2 {
    margin: 0 !important;
    padding: 0 !important;
    line-height: 1; /* 글자가 위아래로 치우치지 않게 고정 */
}

/* 우측 버튼 레이아웃 */
.card-header .btn-area {
    display: flex; 
    gap: 6px;
    margin-top: 0 !important;
    padding-top: 0 !important;
    align-items: center;
}

/* 버튼 자체의 여백 리셋 */
.card-header .btn {
    margin: 0 !important;
}
</style>

<script>
$(function(){
    // 1. 현재 페이지 경로를 키값으로 사용 (예: /board/list) -> 다른 메뉴와 검색어 섞임 방지
    var menuKey = window.location.pathname; 

    // 2. 세션 스토리지에서 현재 메뉴의 이전 검색어 가져오기
    var savedColumn = sessionStorage.getItem(menuKey + '_column');
    var savedKeyword = sessionStorage.getItem(menuKey + '_keyword');
    
    // 3. 디테일에서 목록으로 돌아왔을 때 (주소창에 파라미터가 없는데 스토리지에 검색어가 있다면?)
    var urlParams = new URLSearchParams(window.location.search);
    if (!urlParams.has('column') && savedColumn && savedKeyword) {
        // 기억해둔 검색어를 주소창에 붙여서 강제 이동 (검색 복구)
        location.href = './list?column=' + savedColumn + '&keyword=' + encodeURIComponent(savedKeyword);
        return;
    }

    // 4. 사용자가 새롭게 검색 폼을 제출(검색 버튼 클릭)할 때 스토리지 갱신
    $("form").on("submit", function() {
        // 폼 안에서 column과 활성화된 keyword 값을 찾음
        var column = $(this).find("[name=column]").val();
        var keyword = $(this).find("[name=keyword]:not(:disabled)").val();
        
        if(column && keyword) {
            sessionStorage.setItem(menuKey + '_column', column);
            sessionStorage.setItem(menuKey + '_keyword', keyword);
        } else {
            // 검색어 없이 전체 검색 시 메모리 초기화
            sessionStorage.removeItem(menuKey + '_column');
            sessionStorage.removeItem(menuKey + '_keyword');
        }
    });
});
</script>

<script>
	//부서 목록 json 데이터
	const deptList = JSON.parse('${deptListJson}');
</script>

<script src="/js/dept/list.js"></script>

<script type="text/template" id="dept-template">
<li class="dept-item">
    <div class="dept-row">
        <span class="toggle-btn">▼</span>
        <input type="checkbox" name="dept" class="dept-checkbox" id="dept_DYNAMIC_ID">
        <label for="dept_DYNAMIC_ID" class="dept-name">부서명</label>
    </div>
    <ul></ul>
</li>
</script>
<script type="text/template" id="emp-template">
<tr>
    <td>
        <input type="checkbox" name="emp" class="emp-checkbox" id="">
        <label for="" class="emp-label"></label>
    </td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
</tr>
</script>
<script type="text/template" id="emp-empty-template">
<tr class="empty-row">
    <td colspan="5" class="empty-msg">
        검색된 사원이 없습니다
    </td>
</tr>
</script>
<div class="container w-100 mt-20 mb-50 background-card">
	<div class="w-15 flex-area" style="justify-content: left">
		<div>
	        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
	            부서관리
	            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
	        </h1>
		</div>
    </div>
	<div class="cell flex-area">
		<div class="cell w-25 custom-card">
			<div class="cell card-header">
				<h2>부서 목록</h2>
				<div class="btn-area">
					<a href="/dept/insert" class="btn btn-positive">부서 등록</a>				
				</div>
			</div>
			<div id="deptList" class="dept-tree" style="margin-top: 20px;">
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
			<div class="cell card-header">
				<h2>부서별 사원 목록</h2>
				<div class="btn-area">
					<a class="btn btn-positive dept-emp-change" style="display:none;">부서장 변경</a>
					<a class="btn btn-positive dept-emp-demotion" style="display:none;">부서장 해제</a>					
				</div>
			</div>
			<div class="cell center w-100">
				<table class="table" style="margin-top: 20px;">
					<thead>
						<tr>
							<th><input type="checkbox" id="emp_all" name="emp" class="emp-checkbox check-emp-all"><label for="emp_all"></label></th>
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
			<div class="cell card-header">
				<h2>이동할 부서 목록</h2>
				<div class="btn-area">
					<a class="btn btn-positive dept-change">변경</a>
				</div>
			</div>
			<div id="deptList2" class="dept-tree">
		    <ul>
		        <li class="dept-item no-children">
		            <div class="dept-row">
		                <span class="toggle-btn" style="visibility:hidden;">▶</span>
		                <input type="checkbox" name="dept" class="dept-checkbox" id="dept2_none" value="">
		                <label for="dept2_none" class="dept-name">부서없음</label>
		            </div>
		        </li>
		        </ul>
		</div>
		</div>
	</div>
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp"/>