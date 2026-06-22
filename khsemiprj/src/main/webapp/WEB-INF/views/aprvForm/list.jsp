<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<script>
$(function(){
    // 검색 조건 변경 시 입력창 스위칭 이벤트
    $("[name=column]").on("change", function() {
        var column = $(this).val();
        
        // 1. 구분을 선택했을 때 (네 select의 value가 form_head_no 일 때)
        if (column === "form_head_no") {
            // 구분 검색 존(셀렉트 박스 영역)을 보여줌
            $(".head-search-zone").show()
                                  .find("select").prop("disabled", false); // select 활성화
            
            // 양식명 검색 존(텍스트 입력창 영역)을 숨김
            $(".form-search-zone").hide()
                                  .find("input").prop("disabled", true);  // input 비활성화 (값 전송 안 됨)
        } 
        // 2. 양식명을 선택했을 때 (form_name 일 때)
        else if(column === "form_name") {
            // 구분 검색 존을 숨김
            $(".head-search-zone").hide()
                                  .find("select").prop("disabled", true);  // select 비활성화
            
            // 양식명 검색 존을 보여줌
            $(".form-search-zone").css("display", "inline-flex")
                                  .find("input").prop("disabled", false); // input 활성화
        }
    });

    // 페이지 로드 시 기존 검색 조건에 맞게 인풋 세팅 초기화 (새로고침 시 풀림 방지)
    $("[name=column]").trigger("change");
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

