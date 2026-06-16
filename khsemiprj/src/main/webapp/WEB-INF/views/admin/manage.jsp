<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />
<style>
	.card {
	    background: #fff;
	    border: 1px solid #ddd;
	    border-radius: 8px;
	}
	
	.list-area{
		height:230px;
	    overflow-y:auto;
	}
	
	.list-area thead th{
    position: sticky;
    top: 0;
    background: white;
    z-index: 10;
	}
	    
	.p-20 { padding: 20px; }
	
 	.card input[type="text"],
 	.card select.field {
 		box-sizing: border-box;
 		height: 45px;
 	}
</style>
<script>
document.addEventListener("DOMContentLoaded", function () {
    const aprvHeadCheckboxes = document.querySelectorAll(".aprvHead-checkbox");
    const empPositionCheckboxes = document.querySelectorAll(".empPosition-checkbox");
    
    const headDeleteForm = document.getElementById("headDeleteForm");
    const empPositionDeleteForm = document.getElementById("empPositionDeleteForm");
    
    const btnToggleHeadWrite = document.getElementById('btnToggleHeadWrite');
    const headWriteArea = document.getElementById('headWriteArea');
    const btnTogglePositionWrite = document.getElementById('btnTogglePositionWrite');
    const positionWriteArea = document.getElementById('positionWriteArea');
    

    
    // 1. 하나만 선택되게 제한하는 로직(헤더 체크박스)
    aprvHeadCheckboxes.forEach(function (cb) {
    	// 잠긴 체크박스면 건너뛰기
    	if(cb.disabled) return;
    	
        cb.addEventListener("change", function () {
            if (this.checked) {
                aprvHeadCheckboxes.forEach(function (otherCb) {
                    if (otherCb !== cb) {
                        otherCb.checked = false;
                    }
                });
            }
        });
    }); 
    
 // 1. 하나만 선택되게 제한하는 로직(직책 체크박스)
    empPositionCheckboxes.forEach(function (cb) {
        cb.addEventListener("change", function () {
            if (this.checked) {
            	empPositionCheckboxes.forEach(function (otherCb) {
                    if (otherCb !== cb) {
                        otherCb.checked = false;
                    }
                });
            }
        });
    }); 

    // 2. 폼이 제출(submit)될 때 체크 여부 검사(헤더)
    if (headDeleteForm) {
        headDeleteForm.addEventListener("submit", function (e) {
            const checkedBox = document.querySelector(".aprvHead-checkbox:checked");
            
            if (!checkedBox) {
                e.preventDefault(); // 체크 안 됐으면 서버 전송 취소!
                alert("삭제할 항목을 선택해주세요.");
                return;
            }

            if (!confirm("선택한 헤드를 삭제하시겠습니까?")) {
                e.preventDefault(); // 취소 누르면 서버 전송 취소!
            }
        });
    }
    
    // 2. 폼이 제출(submit)될 때 체크 여부 검사(직책)
    if (empPositionDeleteForm) {
    	empPositionDeleteForm.addEventListener("submit", function (e) {
            const checkedBox = document.querySelector(".empPosition-checkbox:checked");
            
            if (!checkedBox) {
                e.preventDefault(); // 체크 안 됐으면 서버 전송 취소!
                alert("삭제할 항목을 선택해주세요.");
                return;
            }

            if (!confirm("선택한 직책을 삭제하시겠습니까?")) {
                e.preventDefault(); // 취소 누르면 서버 전송 취소!
            }
        });
    }
    
 	// 3. 헤더 추가창 숨겼다가 보이게 (헤더)
    if (btnToggleHeadWrite && headWriteArea) {
    	btnToggleHeadWrite.addEventListener('click', function() {
            // 현재 숨겨져 있으면 보이고, 보이고 있으면 숨기기 (토글)
            if (headWriteArea.style.display === 'none') {
            	headWriteArea.style.display = 'block';
            } else {
            	headWriteArea.style.display = 'none';
            }
        });
    }
 	
 // 3. 헤더 추가창 숨겼다가 보이게 (직책)
    if (btnTogglePositionWrite && positionWriteArea) {
    	btnTogglePositionWrite.addEventListener('click', function() {
            // 현재 숨겨져 있으면 보이고, 보이고 있으면 숨기기 (토글)
            if (positionWriteArea.style.display === 'none') {
            	positionWriteArea.style.display = 'block';
            } else {
            	positionWriteArea.style.display = 'none';
            }
        });
    }
});
</script>

<h1>관리</h1>

<div class="container w-1200 mt-50 mb-50">
	<div class="cell flex-area" style="align-items: flex-start;">
		<div class="cell w-50 me-10 card p-20">
			<div class="cell">
				<h1>헤더 종류 목록</h1>
			</div>
			<form id="headDeleteForm" action="/admin/headDelete" method="POST">
				<div class="cell list-area">
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
			                              value="${aprvHead.headNo}"
			                              <c:if test="${aprvHead.headNo<=6}">disabled</c:if>
			                              >
				               </td>
				               <td>${aprvHead.headName}<c:if test="${aprvHead.headNo <= 6}"><small>(삭제 불가)</small></c:if></td>
				               <td>${aprvHead.headType}</td>
				           </tr>
				       </c:forEach>
					    </tbody>
					</table>
				</div>
				<div class="cell right">
					<button type="submit" id="btnDeleteAprvHead" class="btn btn-negative">삭제</button>	
				</div>
			</form>
			<div class="cell right">
				<button type="button" id="btnToggleHeadWrite" class="btn btn-neutral">헤더 추가</button>
			</div>
			<hr>
			<div id="headWriteArea" style="display: none;">
				<div class="cell">
					<form action="/admin/headWrite" method="post">
				    	<div class="cell">
							<label>헤더 이름</label> <input type="text" name="headName" class="w-100">
						</div>
						
						<div class="cell">
							<label>헤더 타입</label>
							<select name="headType" class="field w-100">
					        	<option value="">선택</option>
					        	<option value="결재">결재</option>
					        	<option value="일반">일반</option>
					       	</select>
						</div>
						
					   	<button type="submit" class="btn btn-positive">헤더생성</button>
					</form>
				</div>
			</div>
		</div>
		<div class="cell w-50 ms-10 card p-20">
			<div class="cell">
				<div class="cell">
					<h1>직책 종류 목록</h1>
				</div>
				
				<form id="empPositionDeleteForm" action="/admin/empPositionDelete" method="POST">
					<div class="cell list-area">
						<table class="table">
						    <thead>
						        <tr>
					        		<th>선택</th>
						            <th>직급명</th>
						            <th>직급 단계</th>
						        </tr>
						    </thead>
						    <tbody>
						        <c:forEach var="empPosition" items="${empPositionList}">
					           <tr>
					               <td>
						               <input type="checkbox" 
				                              name="empPositionNo" 
				                              class="empPosition-checkbox" 
				                              value="${empPosition.empPositionNo}">
					               </td>
					               <td>${empPosition.empPositionName}</td>
					               <td>${empPosition.empPositionLevel}</td>
					           </tr>
					       </c:forEach>
						    </tbody>
						</table>
					</div>
					
					<div class="cell right">
						<button type="submit" id="btnDeleteEmpPosition" class="btn btn-negative">삭제</button>	
					</div>
				</form>
				<div class="cell right">
					<button type="button" id="btnTogglePositionWrite" class="btn btn-neutral">직책 추가</button>
				</div>
				<hr>
				<div id="positionWriteArea" style="display: none;">
					<div class="cell">
						<form action="/admin/empPositionWrite" method="post">
					    	<div class="cell">
								<label>직급명</label> <input type="text" name="empPositionName" class="w-100">
							</div>
							<div class="cell">
								<label>직급 단계</label> <input type="text" name="empPositionLevel" class="w-100">
							</div>
						   	<button type="submit" class="btn btn-positive">헤더생성</button>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>



<jsp:include page="/WEB-INF/views/template/footer.jsp"/>