<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<!-- 목록->검색->다른 페이지->목록 경로에서 검색어가 안 남는 현상 제거(목록을 한 번 더 누르면 제거됨) -->
<script>
$(function() {
    var menuKey = window.location.pathname; 
    var urlParams = new URLSearchParams(window.location.search);

    // 1. 현재 페이지 경로와 이전 페이지(referrer) 경로가 완전히 똑같은지 검사
    var isSameListMenu = false;
    if (document.referrer) {
        var referrerUrl = new URL(document.referrer);
        if (referrerUrl.pathname === window.location.pathname && !urlParams.toString()) {
            isSameListMenu = true; // 목록에서 목록 메뉴를 또 누른 경우 -> 초기화용
        }
    }

    // 2. URL에 파라미터가 있으면 그걸 무조건 스토리지에 저장
    if (urlParams.toString()) {
        if (urlParams.has('column')) sessionStorage.setItem(menuKey + '_column', urlParams.get('column'));
        else sessionStorage.removeItem(menuKey + '_column');

        if (urlParams.has('keyword')) sessionStorage.setItem(menuKey + '_keyword', urlParams.get('keyword'));
        else sessionStorage.removeItem(menuKey + '_keyword');
    } 
    // 3. URL에 파라미터가 비어있을 때 분기 처리 (복구 또는 초기화)
    else {
        if (isSameListMenu) {
            sessionStorage.removeItem(menuKey + '_column');
            sessionStorage.removeItem(menuKey + '_keyword');
        } else {
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

    // 4. 검색 조건 변경 시 입력창 활성화/비활성화 스위칭 (동일 name 파라미터 꼬임 방지)
    $("[name=column]").on("change", function() {
        var column = $(this).val();
        if (column === "form_head_no") {
            $(".head-search-zone").show().find("select").prop("disabled", false); 
            $(".form-search-zone").hide().find("input").prop("disabled", true);  
        } 
        else if (column === "form_name") {
            $(".head-search-zone").hide().find("select").prop("disabled", true);  
            $(".form-search-zone").css("display", "inline-block").find("input").prop("disabled", false); 
        }
    });

    // 페이지 로드 시 최초 1회 트리거 실행
    $("[name=column]").trigger("change");

    // 5. 삭제 완료 알림 체크 (양식 삭제 후 세션에 값 넘어올 때 대응)
    if (sessionStorage.getItem('formDeleted') === 'true') {
        $('#div-alarm').css({'left': 'auto', 'right': '20px', 'bottom': '40px', 'top': 'auto'});
        showAjaxAlarm('양식이 삭제되었습니다.', 'btn-negative');
        sessionStorage.removeItem('formDeleted');
    }
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

