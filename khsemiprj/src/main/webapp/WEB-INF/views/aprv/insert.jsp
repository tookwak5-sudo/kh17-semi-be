<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<!-- 결재 디자인 css -->
<link rel="stylesheet" type="text/css" href="/css/aprv/insert.css">
<!-- 부서 목록 디자인 css -->
<link rel="stylesheet" type="text/css" href="/css/dept/list.css">

<script>
	const deptList = JSON.parse('${deptListJson}');
</script>

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

<form action="./insert" autocomplete="off" method="post" class="form-check">

	<div class="container w-1200 mt-50">
		
    	<div class="cell center">
            <h1>결재 등록</h1>
        </div>
        <div class="cell mb-0">
            <label>양식 선택</label> 
		</div>
		<div class="cell mt-0">
            <select class="field w-40" name="aprvFormNo">
                <option value="">선택하세요</option>
                <c:forEach var="aprvFormDto" items="${aprvFormList}">
                <option value="${aprvFormDto.formNo}">${aprvFormDto.formName}</option>
                </c:forEach>
            </select>
        </div>
        <div class="cell mb-0">
            <label>제목 <i class="fa-solid fa-asterisk red"></i></label>
        </div>
        <div class="cell mt-0">
        	<input type="text" name="aprvTitle" class="field w-40">
        </div>
        <div class="cell mb-0">
            <label>양식 파일</label>
        </div>
        <div class="cell mt-0">
        	<a href=""><i class="fa-regular fa-file"></i>양식 파일 다운로드</a>
        </div>
        <div class="cell mb-0">
            <label>기한 <i class="fa-solid fa-asterisk red"></i></label>
        </div>
        <div class="cell mt-0">
        	<input type="text" name="aprvStime" class="field picker-sdate" size="4" placeholder="시작일">
        	~
        	<input type="text" name="aprvEtime" class="field picker-edate" size="4" placeholder="종료일">
        </div>
        <div class="cell">
        	<label>내용 <i class="fa-solid fa-asterisk red"></i></label>
        	<input type="text" inputmode="numeric" name="aprvContent" class="field w-100">
        </div>
        <div class="cell mb-0">
            <label>첨부 파일</label>
        </div>
        <div class="cell mt-0">
			<label>
				<i class="fa-regular fa-file"></i>
				<span>클릭해서 첨부파일을 선택하세요</span> <input type="file" name="attach" class="field w-100 preview-input" accept=".png, .jpg" style="display: none;">
			</label>
		</div>
		<div class="cell flex-area">
			<div class="cell flex-vertical w-50 me-10">
		        <div class="cell mb-0">
		            <label>1차 결재 라인</label>
		        </div>
		        <div class="cell w-100 mt-0">
		        	<table class="table">
		        		<thead>
		        			<tr>
			        			<th>순서</th>
			        			<th>결재자</th>
			        			<th>부서</th>
			        			<th>직책</th>
		        			</tr>
		        		</thead>
		        		<tbody>
		        			
		        		</tbody>
		        	</table>
		        </div>
		        <div class="cell w-100 right">
		        	<a onclick="openModal();" class="btn btn-positive aprv-line-1">결재자 추가</a>
		        </div>
		    </div>
		    <div class="cell flex-vertical w-50 ms-10">
		        <div class="cell mb-0">
		            <label>2차 결재 라인</label>
		        </div>
		        <div class="cell w-100 mt-0">
		        	<table class="table">
		        		<thead>
		        			<tr>
			        			<th>순서</th>
			        			<th>결재자</th>
			        			<th>부서</th>
			        			<th>직책</th>
		        			</tr>
		        		</thead>
		        		<tbody>
		        			
		        		</tbody>
		        	</table>
		        </div>
		        <div class="cell w-100 right">
		        	<a href="" class="btn btn-positive aprv-line-2">결재자 추가</a>
		        </div>
			</div>
        </div>
        <div class="cell mt-40 mb-50 right">
        	<a href="./list" class="btn btn-neutral">목록으로</a>
        	<button class="btn" style="background-color:#fdcb6e;">
                임시저장
            </button>
            <button class="btn btn-positive">
                등록하기
            </button>
        </div>
    </div>
</form>

<div class="modal-overlay" id="modalOverlay">
    <div class="modal-box">
        <div class="modal-header">결재 라인 선택</div>
        
        <div class="modal-body">
            <form id="popupForm" action="" method="post" class="flex-area">
            	<div class="cell w-25">
	                <div id="deptList" class="dept-tree border">
						<ul>
						</ul>
					</div>
				</div>
				<div class="cell w-75">
					<!-- 테이블 -->
					<div class="cell center">
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
            </form>
        </div>
        
        <div class="modal-footer">
            <button type="button" class="btn btn-positive" onclick="submitData()">확인</button>
            <button type="button" class="btn btn-neutral" onclick="closeModal()">취소</button>
        </div>
    </div>
</div>

<!-- 결재 동작 스크립트 -->
<script src="/js/aprv/insert.js"></script>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>