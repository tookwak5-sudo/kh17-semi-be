<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />

<script>
document.addEventListener("DOMContentLoaded", function () {
    const aprvHeadCheckboxes = document.querySelectorAll(".aprvHead-checkbox");
    const deleteForm = document.getElementById("deleteForm");

    // 1. 하나만 선택되게 제한하는 로직 (괄호 오타 수정 완료)
    aprvHeadCheckboxes.forEach(function (cb) {
        cb.addEventListener("change", function () {
            if (this.checked) {
                aprvHeadCheckboxes.forEach(function (otherCb) {
                    if (otherCb !== cb) {
                        otherCb.checked = false;
                    }
                });
            }
        }); // <- 누락되었던 이벤트 리스너 닫기 추가
    }); // <- 누락되었던 forEach 닫기 추가

    // 2. 폼이 제출(submit)될 때 체크 여부 검사
    if (deleteForm) {
        deleteForm.addEventListener("submit", function (e) {
            const checkedBox = document.querySelector(".aprvHead-checkbox:checked");
            
            if (!checkedBox) {
                e.preventDefault(); // 체크 안 됐으면 서버 전송 취소!
                alert("삭제할 항목을 선택해주세요.");
                return;
            }

            if (!confirm("선택한 결재 헤드를 삭제하시겠습니까?")) {
                e.preventDefault(); // 취소 누르면 서버 전송 취소!
            }
        });
    }
});
</script>

<h1>관리</h1>

<div class="container w-950 mt-50 mb-50">

	<div class="cell">
		<h1>헤더 종류 목록</h1>
	</div>
	
	<form id="deleteForm" action="/admin/delete" method="POST">
		<table class="table">
		    <thead>
		        <tr>
	        		<th>선택</th>
		            <th>헤드 이름</th>
		            <th>헤드 타입</th>
		        </tr>
		    </thead>
		    <tbody>
		        <c:forEach var="aprvHead" items="${aprvHeadList}">
		           <tr>
		               <td>
			               <input type="checkbox" 
	                              name="headNo" 
	                              class="aprvHead-checkbox" 
	                              value="${aprvHead.headNo}">
		               </td>
		               <td>${aprvHead.headName}</td>
		               <td>${aprvHead.headType}</td>
		           </tr>
		       </c:forEach>
		    </tbody>
		</table>
		
		<div class="cell right">
			<button type="submit" id="btnDeleteAprvHead" class="btn btn-negative">삭제</button>	
		</div>
	</form>
	
	<div class="cell">    
		<jsp:include page="/WEB-INF/views/template/pagination2.jsp"></jsp:include>		
	</div>
	
	<div class="cell">
		<form action="/admin/write" method="post">
	    	<div class="cell">
				<label>헤더 이름</label> <input type="text" name="headName">
			</div>
			<div class="cell">
				<label>헤더 타입</label>
				<select name="headType" class="field">
		        	<option value="">선택</option>
		        	<option value="결재">결재</option>
		        	<option value="일반">일반</option>
		       	</select>
			</div>
			
		   	<button type="submit" class="btn btn-positive">헤더생성</button>
		</form>
	</div>

</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>