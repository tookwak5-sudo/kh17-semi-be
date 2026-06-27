<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<style>
/* -----------------------------------------
커스텀 체크박스 클래스 (.checkbox-custom) [형태 토글박스]
----------------------------------------- */
/* 1. 기본 체크박스 숨기기 */
input[type="checkbox"] {
 display: none;
}

/* 체크박스를 스위치 모양으로 */
input[type="checkbox"] + label {
 position: relative;
 padding-left: 60px; /* 스위치 크기만큼 여백 */
 cursor: pointer;
}

input[type="checkbox"] + label::before {
 content: "";
 position: absolute;
 left: 0;
 width: 50px;
 height: 26px;
 background-color: #cbd5e1;
 border-radius: 15px;
 transition: 0.3s;
}

input[type="checkbox"] + label::after {
 content: "";
 position: absolute;
 left: 4px;
 top: 4px;
 width: 18px;
 height: 18px;
 background-color: white;
 border-radius: 50%;
 transition: 0.3s;
}

/* 체크 되었을 때 */
input[type="checkbox"]:checked + label::before {
 background-color: #4f46e5;
}

input[type="checkbox"]:checked + label::after {
 transform: translateX(24px);
}
</style>

<script>

	//유효성 검사 상태 객체
	var state = {
		deptNameValid: false,
		deptParentNoValid: true,
		deptUseYn: true,
		ok: function(){
			return Object.values(this)
			.filter(v => typeof v==="boolean")
			.every(v => v === true);
		}
	};
	
	$(function() {
		
		// 블러/체인지 이벤트 핸들러들
	    $("[name=deptName]").on("input", function(){
	        state.deptNameValid = $(this).val().trim().length > 0;
	    });
	    $("[name=deptParentNo]").on("change", function(){
	        state.deptParentNoValid = $(this).val().trim().length > 0;
	    });
		
		$(".form-check").on("submit", function(e){
	    	$(this).find("select[name]").trigger("input");
	        $(this).find("input[name], textarea[name]").trigger("blur");
	        
	        if(!state.deptNameValid) {
	            showAjaxAlarm('부서 이름을 입력하세요', 'btn-negative', '[name=deptName]', 'left');
	            $("[name=deptName]").focus();
	            return false; 
	        }
	        
	        return state.ok();
	    });
	});
</script>

<form action="./insert" autocomplete="off" method="post" class="form-check">

	<div class="container w-400 mt-20 mb-50 background-card">
		
		<div>
	        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
	            부서등록
	            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
	        </h1>
		</div>
        <!-- <div class="cell">
        	<label>부서 번호<i class="fa-solid fa-asterisk red"></i></label>
        	<input type="text" inputmode="numeric" name="deptNo" class="field w-100" required>
        </div> -->
        <div class="cell">
            <label>부서 이름 <i class="fa-solid fa-asterisk red"></i></label>
            <input type="text" name="deptName"
                class="field w-100">
        </div>
        <div class="cell">
            <label>상위 부서 선택</label> 

            <select class="field w-100" name="deptParentNo">
                <option value="">선택하세요</option>
                <c:forEach var="deptDto" items="${deptList}">
                <option value="${deptDto.deptNo}">
                	<c:if test="${deptDto.deptDepth > 0}">
					    <c:forEach begin="1" end="${deptDto.deptDepth}">
					    	&#12288;
					    </c:forEach>
					</c:if>
                	${deptDto.deptName}
               	</option>
                </c:forEach>
            </select>
        </div>
        
        <div class="cell">
        	<input type="checkbox" id="check1" name="deptUseYn" value="Y">
        	<label for="check1">부서 사용 여부</label>
        </div>
        
        <div class="cell mt-40 right">
        	<a href="./list" class="btn btn-neutral">목록으로</a>
            <button class="btn btn-positive">
                등록하기
            </button>
        </div>
    </div>
</form>
	
<jsp:include page="/WEB-INF/views/template/footer.jsp"/>