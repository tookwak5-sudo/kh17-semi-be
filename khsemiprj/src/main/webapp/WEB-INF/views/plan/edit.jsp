<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<script type="text/javascript">
      $(function(){
              var picker8 = new Lightpick({
              field: $(".picker-8-1")[0],
              secondField : $(".picker-8-2")[0],
              singleDate : false, //범위선택으로 변경
              format : "YYYY-MM-DD",
              firstDay : 7 ,
              numberOfMonths : 2, //2달 표시한다
              numberOfColumns : 2, //한 줄에 2칸 표시
              selectForward : true, //최초 선택날짜 이후로만 선택가능
              minDays : 1, //최소 선택기간(일)
              //maxDays : 8, //최대 선택기간(일)
          });
      });
</script>

<form action="./insert" autocomplete="off" method="post" class="form-check">
<input type="hidden" name="planNo" value="${planDto.planNo}">
	<div class="container w-600 mt-50">
		
    	<div class="cell center">
            <h1>일정 수정</h1>
        </div>
        <div class="cell">
        	<label>유형</label>
        	<select class="field w-100" name="planType">
                <option value="">선택하세요</option>
                <c:forEach var="planDto" items="${list}">
	                <option value="${planDto.planNo}" ${planDto.planNo == myPlan.planNo ? 'selected' : ''}>
			            ${planDto.planType}
			        </option>
                </c:forEach>
            </select>
        </div>
        <div class="cell">
            <label>일정<i class="fa-solid fa-asterisk red"></i></label>
        </div>
        <div class="cell flex-area" style="align-items: center;">
            <input type="text" name="planName" class="field w-100 picker-8-1"value="<fmt:formatDate value='${myPlan.planSdate}' pattern='yyyy-MM-dd' />">
                <i class="fa-solid fa-minus ms-10 me-10"></i>
            <input type="text" class="field w-100 picker-8-2"value="<fmt:formatDate value='${myPlan.planEdate}' pattern='yyyy-MM-dd' />">
        </div>
        
         <div class="cell">
            <label>내용</label>
            <textarea name="planExplain" class="field w-100" rows="5">${planDto.planExplain}</textarea>
        </div>
        <div class="cell mt-40 right">
            <button class="btn btn-positive">
                수정하기
            </button>
        	<a href="./list" class="btn btn-neutral">목록으로</a>
        </div>
    </div>
</form>
	
<jsp:include page="/WEB-INF/views/template/footer.jsp"/>