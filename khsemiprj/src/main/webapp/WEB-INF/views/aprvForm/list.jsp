<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

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
$(function(){
    // 1. 페이지 켜지자마자 세션 스토리지에 저장된 검색 조건이 있는지 확인
    var savedColumn = sessionStorage.getItem('searchColumn');
    var savedKeyword = sessionStorage.getItem('searchKeyword');
    
    // 현재 주소창에 파라미터(column)가 없고, 브라우저 메모리에 저장된 이전 검색어가 있다면?
    var urlParams = new URLSearchParams(window.location.search);
    if (!urlParams.has('column') && savedColumn && savedKeyword) {
        // 상세페이지 갔다가 그냥 목록 버튼 눌러서 돌아온 상황이므로, 저장된 주소로 강제 리다이렉트
        location.href = './list?column=' + savedColumn + '&keyword=' + encodeURIComponent(savedKeyword);
        return; // 아래 코드 실행 막기
    }

    // 기존의 검색 조건 변경 시 입력창 스위칭 이벤트
    $("[name=column]").on("change", function() {
        var column = $(this).val();
        
        if (column === "form_head_no") {
            $(".head-search-zone").show().find("select").prop("disabled", false); 
            $(".form-search-zone").hide().find("input").prop("disabled", true);  
        } 
        else if(column === "form_name") {
            $(".head-search-zone").hide().find("select").prop("disabled", true);  
            $(".form-search-zone").css("display", "inline-flex").find("input").prop("disabled", false); 
        }
    });

    // 페이지 로드 시 기존 검색 조건에 맞게 인풋 세팅 초기화
    $("[name=column]").trigger("change");

    // 2. 사용자가 실제 검색 폼을 제출할 때(검색 버튼 클릭 시) 현재 검색 조건을 저장소에 기억
    $("form").on("submit", function() {
        var column = $("[name=column]").val();
        // 텍스트 인풋창이냐, 셀렉트 박스냐에 따라 활성화된 keyword 값을 유연하게 따옴
        var keyword = $("[name=keyword]:not(:disabled)").val();
        
        if(column && keyword) {
            sessionStorage.setItem('searchColumn', column);
            sessionStorage.setItem('searchKeyword', keyword);
        } else {
            // 검색어 없이 그냥 검색하거나 초기화되면 메모리도 비움
            sessionStorage.removeItem('searchColumn');
            sessionStorage.removeItem('searchKeyword');
        }
    });
});
</script>
<!-- 삭제 시 -->
<script>
$(document).ready(function() {
    // 세션 스토리지에 formDeleted 값이 true로 들어있는지 확인
    if(sessionStorage.getItem('formDeleted') === 'true') {
        
        // 오른쪽 아래 위치 세팅
        $('#div-alarm').css({'left': 'auto', 'right': '20px', 'bottom': '40px', 'top': 'auto'});
        
        // 팝업 띄우기
        showAjaxAlarm('양식이 삭제가 되었습니다.', 'btn-negative');
        
        
        sessionStorage.removeItem('formDeleted');
    }
});
</script>





<c:if test="${sessionScope.loginId != null && sessionScope.empGrade >=1 }">
<div class="container w-100 mt-20 mb-50 background-card">
	<div class="cell center flex-area">
	    <div class="w-25 flex-area" style="justify-content: left">
				<div>
			        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
			            결재양식 관리
			            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
			        </h1>
				</div>
	    </div>

	<div class="cell flex-area background-fill">
	    <form action="./list" method="get" autocomplete="off">
	        <input type="hidden" name="size" value="${pageVO.size}">
	        <div class="flex-area" style="align-items: center; gap: 10px;">
	            <select name="column" class="field field-sm">
	                <option value="form_name" ${param.column == 'form_name' ? 'selected' : ''}>양식명</option>
	                <option value="form_head_no" ${param.column == 'form_head_no' ? 'selected' : ''}>구분(업무/비용 등)</option>
	            </select>
	                
	            <div class="form-search-zone" style="display: inline-block;">
	                <input type="text" name="keyword" class="field-sm"
	                    placeholder="양식 이름 입력" value="${param.keyword}" style="width: 300px;" id="name">
	            </div>   
	           
	            <div class="head-search-zone" style="display: inline-block;">
	                <select name="keyword" class="field-sm">
	                    <option value="">선택하세요</option>
	                    <c:forEach var="head" items="${filterHeadList}">
	                        <option value="${head.headName}" ${param.keyword == head.headName ? 'selected' : ''}>
	                            ${head.headName}
	                        </option>
	                    </c:forEach>
	                </select>
	            </div>
	            
	            <button type="submit" class="btn btn-positive">
	                <i class="fa-solid fa-magnifying-glass"></i>
	                <span>검색</span>
	            </button>
	        </div>
	    </form>
	</div>    
	    <div class="w-15 flex-area" style="justify-content: right; align-items: center;">
	        <c:if test="${sessionScope.loginId != null}">
	            <a href="./insert" class="btn btn-neutral">
	                <i class="fa-solid fa-plus"></i> 양식 등록
	            </a>
	        </c:if>
	    </div>
</div>
	
    <div class="right" style="font-size: 14px; color: #666;">
		    <strong style="color: #007bff;">${pageVO.count}</strong>개의 항목
	</div>

    <div class="cell">
        <table class="table">
            <thead>
                <tr>
                    <th>양식번호</th>
                    <th>구분</th>
                    <th class="w-40">양식명</th>
                    <th>사용여부</th>
                    <th>최종수정일</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="formDto" items="${list}">
                <tr>
                    <td>${formDto.formNo}</td>
                    <td>
                        <c:if test="${formDto.headName != null}">
                            [${formDto.headName}]
                        </c:if>
                    </td>
                    <td align="left">
                        <a href="./detail?formNo=${formDto.formNo}">
                            ${formDto.formName}
                        </a>
                    </td>
                    <td>
                        <c:if test="${formDto.formUseYn == 'Y'}">사용중</c:if>
                        <c:if test="${formDto.formUseYn == 'N'}">미사용</c:if>
                    </td>
                    <td>
                    	<fmt:formatDate value="${formDto.formWtime}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="cell mt-40">
        <jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
    </div>
        
   <%-- <div class="cell center">
    	<form action="./list" method="get">
        	<select name="column" class="field">
            <option value="form_name" ${param.column == 'form_name' ? 'selected' : ''}>양식명</option>
            <option value="form_head_no" ${param.column == 'form_head_no' ? 'selected' : ''}>구분(업무/비용 등)</option>
         	</select>
            <input type="text" name="keyword" class="field-sm" placeholder="검색어 입력" value="${param.keyword}">
            <button type="submit" class="btn btn-positive">
                <i class="fa-solid fa-magnifying-glass"></i>
                <span>검색</span>
            </button>
        </form>
    </div> --%>
</div>
</c:if>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>

