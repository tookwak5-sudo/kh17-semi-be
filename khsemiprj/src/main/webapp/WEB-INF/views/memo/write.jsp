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
</script>

   

<form action="./write" method="post">
	<div class="container memo-card w-600 mt-0">
		<div class="cell">
			<!-- 제목을 답글일 때와 새글일 때로 나눠서 처리 -->
			<h1 class="mt-0 mb-0">쪽지쓰기</h1>
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
					<option value="">선택 안함</option>
					<!-- 공지는 관리자에게만 보이도록 해야함 -->
					<option>일반</option>
					<option>공지</option>		
				</select>
			</div>
		</c:if>
		<div class="cell" id="receiverCell">
			<label>받을사람 아이디<i class="fa-solid fa-asterisk red"></i></label>
			<input type="text" name="memoReceiverId" value="${replyReceiverId}" class="field w-100">
		</div>
		<div class="cell">
			<label>내용 <i class="fa-solid fa-asterisk red"></i></label>
			<textarea name="memoContent" rows="5" required rows="5" class="field w-100"></textarea>
		</div>
		
		<div class="cell mt-10 right">
			<a href="/memo/list" class="btn btn-neutral">
				<i class="fa-solid fa-list"></i>
				<span>목록으로 이동</span>
			</a>
			<button type="submit" class="btn btn-positive">
				<i class="fa-solid fa-floppy-disk"></i>
				<span>쪽지 보내기</span>
			</button>
		</div>
	</div>
</form>
