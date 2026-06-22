<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<script type="text/javascript">
$(function () {
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
})


</script>    
  
<form id="planEditForm" action="/plan/edit" method="post" novalidate autocomplete="off">
	<input type="hidden" name="planNo" value="${planDto.planNo}">
	<div class="container w-950 mt-20 mb-50 background-card">
		<div class="flex-area flex-center mb-10">
		        <h1 class= "mt-40 flex-fill ms-20">일정 수정</h1>
		</div>
		<div class="cell">
	       	<label>일정명<i class="fa-solid fa-asterisk red"></i></label>
	       	<input type="text" name="planName" class="field w-100" value="${planDto.planName}">
			<div class="fail-feedback w-100">
	                 <div>필수 입력 창 입니다</div>
	          	</div>
	       </div>
		<div class="cell">
	       	<label>유형<i class="fa-solid fa-asterisk red"></i></label>
	       	<select class="field w-100" name="planType">
	               <option value="">선택하세요</option>
	               <option value="개인" ${planDto.planType == '개인' ? 'selected':''}>개인</option>
				<option value="부서" ${planDto.planType == '부서' ? 'selected':''}>부서</option>
				<option value="회사" ${planDto.planType == '회사' ? 'selected':''}>회사</option>
	           </select>
			<div class="fail-feedback w-100">
	                 <div>필수 입력 창 입니다</div>
	          	</div>
	       </div>
		<div class="cell">
	       	<label>종류(헤더)</label>
	       	<select class="field w-100" name="planHeadNo">
				<option value="">선택하세요</option>
				    <c:forEach var="head" items="${planHead}">
				        <%-- 현재 일정의 헤드번호와 반복문의 헤드번호가 같으면 selected 출력 --%>
				        <option value="${head.headNo}" ${planDto.planHeadNo == head.headNo ? 'selected' : ''}>
				            ${head.headName}
				        </option>
				    </c:forEach>
	        </select>
	    </div>
	       <div class="cell">
	           <label>일정 <i class="fa-solid fa-asterisk red"></i></label>
	       </div>
	       <div class="cell flex-area" style="align-items: center;">
	           <input type="text" name="planSdate" class="field w-100 picker-sdate" autocomplete="off" value="${planDto.planSdate}">
	               <i class="fa-solid fa-minus ms-10 me-10"></i>
	           <input type="text" name="planEdate" class="field w-100 picker-edate" autocomplete="off" value="${planDto.planEdate}">
			<div class="fail-feedback w-100">
	                 <div>필수 입력 창 입니다</div>
	          	</div>
	       </div>
	       
	        <div class="cell">
	           <label>내용</label>
	           <textarea name="planExplain" class="field w-100" rows="5">${planDto.planExplain}</textarea>
	       </div>
	       <div class="cell mt-40 right">
	           <button type="submit" class="btn btn-positive btn-plan-edit">
	               수정하기
	           </button>
	      </div>
	</div>
</form>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>