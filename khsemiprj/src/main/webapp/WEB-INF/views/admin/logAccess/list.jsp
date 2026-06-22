<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<style>
.break-url {
    word-break: break-all;     /* 글자 단위로 쪼개서 줄바꿈 */
    white-space: normal;       /* 기본 줄바꿈 허용 */
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
	
<div class="container w-100 mt-20 mb-50 background-card">
	<div class="cell center flex-area">		
		<div class="w-25 flex-area" style="justify-content: left">
			<div>
		        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
		            페이지 접근 로그
		            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
		        </h1>
			</div>
        </div>
		<div class="cell flex-area background-fill">
			<!-- 검색창 -->
	            <form autocomplete="off">
	                <select name="column" class="field-ph">
	                    <option value="access_emp_id" ${param.column == 'access_emp_id' ? 'selected' : ''}>접근자 아이디</option>
	                    <option value="access_url" ${param.column == 'access_url' ? 'selected' : ''}>접속 URL</option>
	                </select>
	                <input type="text" name="keyword"
	                    class="field-sm" placeholder="검색어 입력" value="${param.keyword}">
	                <button type="submit" class="btn btn-positive">
	                    <i class="fa-solid fa-magnifying-glass"></i>
	                    <span>검색</span>
	                </button>
	            </form>
		</div>
	</div>
		<div class="right" style="font-size: 14px; color: #666;">
		    <strong style="color: #007bff;">${pageVO.count}</strong>개의 로그
		</div>
	   
	   <div class="cell">
	   		<table class="table">
	   			<thead>
	               <tr>
	                   <th width="80px">no.</th>
	                   <th>접근자</th>
	                   <th>경로(URL)</th>
	                   <th width="130px">접근IP</th>
	                   <th width="200px">접근시각</th>
	               </tr>
	  			</thead>
	  			<tbody>
	  				<c:forEach var="logAccessDto" items="${logAccessList}">
	  				<tr>
	  					<td>${logAccessDto.accessNo}</td>
	  					<td>${logAccessDto.accessEmpId} ([${logAccessDto.deptName}] ${logAccessDto.empName})</td>
	  					<td  class="break-url">${logAccessDto.accessUrl}</td>
	  					<td>${logAccessDto.accessIp}</td>
	  					<td><fmt:formatDate value="${logAccessDto.accessDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	  				</tr>
	  				</c:forEach>
	  			</tbody>
	   		</table>
	   </div>
	</div>
	<div class="cell">    
		<!-- 페이지네이션 -->
		<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
	</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>