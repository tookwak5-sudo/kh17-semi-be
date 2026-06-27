<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/memoHeader.jsp"></jsp:include>

<style>
#receiverCell {
    opacity: 1;
    max-height: 200px;
    overflow: hidden;
    transition: opacity 0.4s ease, max-height 0.4s ease, margin 0.4s ease, padding 0.4s ease;
}

#receiverCell.hide {
    opacity: 0;
    max-height: 0;
    margin-top: 0 !important;
    margin-bottom: 0 !important;
    padding-top: 0 !important;
    padding-bottom: 0 !important;
    pointer-events: none; /* 숨겨졌을 때 클릭 방지 */
}
</style>

<script>
document.addEventListener("DOMContentLoaded", function() {
    var typeSelect = document.getElementById("memoTypeSelect");
    var receiverCell = document.getElementById("receiverCell");
    var receiverInput = document.getElementById("memoReceiverId");

    if (typeSelect && receiverCell) {
        typeSelect.addEventListener("change", function() {
            if (this.value === "공지") {
                // 공지 선택 시 hide 클래스 추가 (부드럽게 축소 및 투명화)
                receiverCell.classList.add("hide");
                receiverInput.value = ""; 
            } else {
                // 일반/선택안함 선택 시 hide 클래스 제거 (부드럽게 나타남)
                receiverCell.classList.remove("hide");
            }
        });
    }
});

//유효성 검사 상태 객체
var state = {
	memoTitleValid: false,
	memoReceiverIdValid: false,	
	memoContentValid: false,
	ok: function(){
		return Object.values(this)
		.filter(v => typeof v==="boolean")
		.every(v => v === true);
	}
};
$(function () {
	// 블러/체인지 이벤트 핸들러들
    $("[name=memoTitle]").on("blur", function(){
        state.memoTitleValid = $(this).val().trim().length > 0;
    });
 	
    $("[name=memoReceiverId]").on("blur", function(){
        state.memoReceiverIdValid = $(this).val().trim().length > 0;
    });
	
    $("[name=memoContent]").on("blur", function(){
        state.memoContentValid = $(this).val().trim().length > 0;
    });
    
    $(".form-check").on("submit", function(e){
    	$(this).find("select[name]").trigger("input");
        $(this).find("input[name], textarea[name]").trigger("blur");
    	
    	if(!state.memoTitleValid) {
    		showAjaxAlarm('제목을 입력하세요', 'btn-negative', '[name=memoTitle]', 'bottom');
            $("[name=memoTitle]").focus();
            return false;
    	}
    	
    	if($('#memoTypeSelect').val() == '일반') {
	    	if(!state.memoReceiverIdValid) {    		
	    		showAjaxAlarm('받을사람 아이디를 입력하세요', 'btn-negative', '[name=memoReceiverId]', 'bottom');
	            $("[name=memoReceiverId]").focus();
	            return false;
	    	}
	    } else {
	    	state.memoReceiverIdValid = true;
	    }
    	
    	if(!state.memoContentValid) {
    		showAjaxAlarm('내용을 입력하세요', 'btn-negative', '[name=memoContent]', 'bottom');
            $("[name=memoContent]").focus();
            return false;
    	}
    	
    	return state.ok();
    });
});
</script>

   

<form action="./write" method="post" class="form-check">
	<div class="container memo-card w-600 mt-20 mb-50 background-card">
		<div class="w-40 flex-area" style="justify-content: left">
			<div>
		        <h1 style="font-size: 28px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
		            <!-- 제목을 답글일 때와 새글일 때로 나눠서 처리 -->
		            쪽지 쓰기
		            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
		        </h1>
			</div>
        </div>
		<div class="cell mt-10">
			<label>제목 <i class="fa-solid fa-asterisk red"></i></label>
			<input type="text" name="memoTitle" class="field w-100">
		</div>
		<c:if test="${sessionScope.empGrade == '2'}">
			<div class="cell mb-0">
				<label>쪽지 타입</label>
			</div>
		
			<div class="cell mt-0">
				<select id="memoTypeSelect" name="memoType" class="field">
					<option>일반</option>
					<option>공지</option>		
				</select>
			</div>
		</c:if>
		<div class="cell" id="receiverCell">
			<label>받을사람 아이디<i class="fa-solid fa-asterisk red"></i></label>
			<input type="text" id="memoReceiverId" name="memoReceiverId" value="${replyReceiverId}" class="field w-100">
		</div>
		<div class="cell">
			<label>내용 <i class="fa-solid fa-asterisk red"></i></label>
			<textarea name="memoContent" rows="8" rows="8" class="field w-100" style="height:170px"></textarea>
		</div>
		
		<div class="cell mt-40 right">
			<a href="/memo/list" class="btn btn-neutral">
				<i class="fa-solid fa-list"></i>
				<span>목록</span>
			</a>
			<button type="submit" class="btn btn-positive">
				<i class="fa-solid fa-paper-plane"></i>
				<span>발송</span>
			</button>
		</div>
	</div>
	<jsp:include page="/WEB-INF/views/template/memoFooter.jsp"></jsp:include>
</form>