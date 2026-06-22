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
	<!-- 목록->검색->다른 페이지->목록 경로에서 검색어가 안 남는 현상 제거(목록을 한 번 더 누르면 제거됨) -->

	<script>
$(function() {
    var menuKey = window.location.pathname; 
    var urlParams = new URLSearchParams(window.location.search);

    // 1. 현재 페이지 경로와 이전 페이지(referrer) 경로가 완전히 똑같은지 검사
    var isSameListMenu = false;
    if (document.referrer) {
        var referrerUrl = new URL(document.referrer);
        // 이전 주소와 현재 주소의 path가 같고, 현재 주소에 파라미터가 아예 없는 경우
        if (referrerUrl.pathname === window.location.pathname && !urlParams.toString()) {
            isSameListMenu = true; // 목록에서 목록 메뉴를 또 누른 경우
        }
    }

    // 2. URL에 파라미터가 있으면 그걸 무조건 스토리지에 저장
    if (urlParams.toString()) {
        if (urlParams.has('column')) sessionStorage.setItem(menuKey + '_column', urlParams.get('column'));
        else sessionStorage.removeItem(menuKey + '_column');

        if (urlParams.has('keyword')) sessionStorage.setItem(menuKey + '_keyword', urlParams.get('keyword'));
        else sessionStorage.removeItem(menuKey + '_keyword');
    } 
    // 3. URL에 파라미터가 비어있을 때 분기 처리
    else {
        if (isSameListMenu) {
            // 목록 화면에서 메뉴를 한 번 더 클릭한 경우 -> 싹 초기화
            sessionStorage.removeItem(menuKey + '_column');
            sessionStorage.removeItem(menuKey + '_keyword');
        } else {
            // 다른 상세 페이지 등 외부에서 돌아왔는데 스토리지에 저장된 값이 있는 경우 -> 복구
            var savedColumn = sessionStorage.getItem(menuKey + '_column');
            var savedKeyword = sessionStorage.getItem(menuKey + '_keyword');

            if (savedColumn || savedKeyword) {
                var qs = [];
                if(savedColumn) qs.push('column=' + savedColumn);
                if(savedKeyword) qs.push('keyword=' + encodeURIComponent(savedKeyword));
                
                location.href = './list?' + qs.join('&');
                return;
            }
        }
    }
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