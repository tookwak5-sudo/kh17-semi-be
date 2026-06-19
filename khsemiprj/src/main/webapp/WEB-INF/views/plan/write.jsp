<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<script>
$(function(){
	var picker8 = new Lightpick({
        field : $(".picker-sdate")[0] ,
        secondField : $(".picker-edate")[0],
        singleDate : false,//범위선택으로 변경
        format : "YYYY-MM-DD", 
        firstDay : 7 ,
        numberOfMonths : 2,//2달 표시
        numberOfColumns : 2,//한 줄에 2칸 표시
        selectForward : false,//최초 선택날짜 이후로만 선택가능
    });
	
	$(document).on("click", "#dateReset", function() {
		$(".picker-sdate").val("");
		$(".picker-edate").val("");
		$(".field-sm").val("");
		
	});
	//상태객체
    var state = {
        planNameValid : false,
        planTypeValid : false,
        planHeadNoValid : true,
        planSdateValid : false,
        planEdateValid : false,
        planExplainValid : false, 
        ok : function() {
            return Object.values(this)//이 객체의 모든 이름에 대한 값을 반환해라
            .filter(v => typeof v == "boolean") // boolean값만 추출해서
            .every(v => v === true); //모두 true인지 확인해서 반환해라;
        }
    };
	
	 // 항목검사 통합 함수
    $(document).on("blur input", "[name=planName]", function () {
        var $input = $(this);
        var val = $input.val();
        
        // 값이 비어있는지 확인 (select의 경우 value가 ""이면 비어있는 것)
        var valid = val !== null && val.trim().length > 0;
        
        // 상태 객체 업데이트
        if($input.attr("name") === "planName") state.planNameValid = valid;
        
        // 클래스 및 데이터 속성 처리
        if(!valid) {
            $input.addClass("fail").attr("data-error", "1");
        } else {
            $input.removeClass("fail").removeAttr("data-error");
        }
    });
    $(document).on("blur input", "[name=planType]", function () {
        var $input = $(this);
        var val = $input.val();
        
        // 값이 비어있는지 확인 (select의 경우 value가 ""이면 비어있는 것)
        var valid = val !== null && val.trim().length > 0;
        
        // 상태 객체 업데이트
        if($input.attr("name") === "planType") state.planTypeValid = valid;
        
        // 클래스 및 데이터 속성 처리
        if(!valid) {
            $input.addClass("fail").attr("data-error", "1");
        } else {
            $input.removeClass("fail").removeAttr("data-error");
        }
    });
    
    $(document).on("blur input", "[name=planSdate]", function () {
        var $input = $(this);
        var val = $input.val();
        
        // 값이 비어있는지 확인 (select의 경우 value가 ""이면 비어있는 것)
        var valid = val !== null && val.trim().length > 0;
        
        // 상태 객체 업데이트
        if($input.attr("name") === "planSdate") state.planSdateValid = valid;
        
        // 클래스 및 데이터 속성 처리
        if(!valid) {
            $input.addClass("fail").attr("data-error", "1");
        } else {
            $input.removeClass("fail").removeAttr("data-error");
        }
    });
    
    $(document).on("blur input", "[name=planEdate]", function () {
        var $input = $(this);
        var val = $input.val();
        
        // 값이 비어있는지 확인 (select의 경우 value가 ""이면 비어있는 것)
        var valid = val !== null && val.trim().length > 0;
        
        // 상태 객체 업데이트
        if($input.attr("name") === "planEdate") state.planEdateValid = valid;
        
        // 클래스 및 데이터 속성 처리
        if(!valid) {
            $input.addClass("fail").attr("data-error", "1");
        } else {
            $input.removeClass("fail").removeAttr("data-error");
        }
    });
    
    $(document).on("blur input", "[name=planExplain]", function () {
        var $input = $(this);
        var val = $input.val();
        
        // 값이 비어있는지 확인 (select의 경우 value가 ""이면 비어있는 것)
        var valid = val !== null && val.trim().length > 0;
        
        // 상태 객체 업데이트
        if($input.attr("name") === "planExplain") state.planExplainValid = valid;
        
        // 클래스 및 데이터 속성 처리
        if(!valid) {
            $input.addClass("fail").attr("data-error", "1");
        } else {
            $input.removeClass("fail").removeAttr("data-error");
        }
    });
  	//폼검사
    $(".form-check").on("submit", function(){
        $(this).find("select[name]").trigger("input");
        $(this).find("input[name], textarea[name]").trigger("blur");
        return state.ok();
    });
    
});
</script>
<form action="./write" autocomplete="off" method="post" enctype="multipart/form-data" class="form-check">
	<div class="container w-950 mt-20 mb-50 background-card">
		<div class="flex-area flex-center mb-10 w-100">
			<h1 class= "mt-40 flex-fill ms-20">일정 등록</h1>
		</div>
			<div class="cell">
	        	<label>일정명</label>
	        	<input type="text" name="planName" class="field w-100">
				<div class="fail-feedback w-100">
                   <div>필수 입력 창 입니다</div>
            	</div>
	        </div>
			<input type="hidden" name="planDeptNo" value="${deptNo}" class="field w-100">
	        <div class="cell">
	        	<label>유형</label>
	        	<select class="field w-100" name="planType">
	                <option value="">선택하세요</option>
	                <option value="개인">개인</option>
					<option value="부서">부서</option>
					<option value="회사">회사</option>
	            </select>
				<div class="fail-feedback w-100">
                   <div>필수 입력 창 입니다</div>
            	</div>
	        </div>
			<div class="cell">
	        	<label>종류(헤더)</label>
	        	<select class="field w-100" name="headNo">
	                <option value="">선택하세요</option>
	                 <c:forEach var="aprvHeadDto" items="${headList}" varStatus="stat">
                   		<option value="${aprvHeadDto.headNo}">${aprvHeadDto.headName}</option>
                  		 </c:forEach>
	            </select>
	        </div>
	        <div class="cell">   
	            <label>일정 <i class="fa-solid fa-asterisk red"></i></label>
	        </div>
	        <div class="cell flex-area" style="align-items: center;">
	        	 <input type="text" name="planSdate" class="field picker-sdate" size="4" placeholder="시작일" >
           			<span class="timeTilde">~</span>
           		<input type="text" name="planEdate" class="field picker-edate" size="4" placeholder="종료일">
	        </div>
	       	
	         <div class="cell">
	            <label>내용</label>
	            <textarea name="planExplain" class="field w-100"></textarea>
	        </div>
	        <div class="cell mt-40 right">
	            <button type="submit" class="btn btn-positive btn-plan">
	                <i class="fa-solid fa-plus"></i>등록하기
	            </button>
	       </div>
	</div>
</form>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>