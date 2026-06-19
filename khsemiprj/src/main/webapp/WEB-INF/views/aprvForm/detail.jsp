<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
        /* 커스텀 카드 레이아웃만 남겨두고 나머지는 commons.css 활용 */
        .emp-info-card {
            background-color: #ffffff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 10px 30px;
        }
        .emp-info-row {
            display: flex;
            align-items: center;
            padding: 16px 0;
            border-bottom: 1px solid #f1f3f5;
        }
        .emp-info-row:last-child {
            border-bottom: none;
        }
        .emp-info-label {
            width: 25%;
            font-weight: 600;
            color: #495057;
            position: relative;
            padding-left: 14px;
            letter-spacing: -0.5px;
        }
        .emp-info-label::before {
            content: "";
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 4px;
            height: 14px;
            background-color: #739BED;
            border-radius: 2px;
        }
        .emp-info-value {
            width: 75%;
            color: #343a40;
            font-weight: 500;
        }
        .emp-info-value.point-color {
            color: #739BED;
            font-weight: 600;
        }
</style>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script>
var deleteConfirmState = {
	    deleteConfirmValid: false,
	    ok: function(){
	        return Object.values(this)
	        // 오타 수정 (typeof =>===  ->  typeof v === "boolean")
	        .filter(v => typeof v === "boolean")
	        .every(v => v === true);
	    }
	};

	$(function(){
	    // submit 대신 a 태그의 click 이벤트로 변경
	    $("#btnDeleteConfirm").on("click", function(e){
	        
	        // 검증이 안 끝났으면 일단 a 태그의 기본 이동(href)을 막음
	        if(!deleteConfirmState.deleteConfirmValid){
	            e.preventDefault();
	            var deleteUrl = $(this).attr("href"); // 이동할 주소 따두기
	            
	            // 팝업 확인 누르면 Valid를 true로 바꾸고, 저장해둔 URL로 강제 주소 이동
	            openConfirm(
	                '정말 삭제 하시겠습니까?', 
	                'deleteConfirmState.deleteConfirmValid = true; location.href="' + deleteUrl + '";'
	            );
	        }
	        
	        // workOutState -> deleteConfirmState로 이름 수정
	        return deleteConfirmState.ok();
	    });
	});


</script>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<c:if test="${sessionScope.loginId != null && sessionScope.empGrade >=1 }">
<div class="container w-800 mt-20 mb-50 background-card">
	<div class="w-100 flex-area" style="justify-content: left">
			<div>
		        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
		            ${aprvFormSelectVO.formName}
		            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
		        </h1>
			</div>
    </div>

    <div class="cell mb-10">
        <span class="font-bold" style="color: #666;">양식 기본정보</span>
    </div>
    
    <form action="edit" method="post" id="editForm">
		<input type="hidden" name="empId" value="${empDto.empId}">
		
		<div class="cell mt-40 emp-info-card">
			<div class="emp-info-row">
				<div class="emp-info-label">양식번호</div>
				<div class="emp-info-value point-color">${aprvFormSelectVO.formNo}</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">대분류</div>
				<div class="emp-info-value point-color">${aprvFormSelectVO.headType}</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">양식분류</div>
				<div class="emp-info-value point-color"><c:if test="${aprvFormSelectVO.headName != null}">${aprvFormSelectVO.headName}</c:if></div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">작성일</div>
					<div class="emp-info-value point-color">
						<fmt:formatDate value="${aprvFormSelectVO.formWtime}" pattern="yyyy-MM-dd HH:mm"/>
					</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">사용 여부</div>
				<div class="emp-info-value point-color">
					<c:if test="${aprvFormSelectVO.formUseYn == 'Y'}">사용</c:if>
                    <c:if test="${aprvFormSelectVO.formUseYn == 'N'}">미사용</c:if>
                </div>
			</div>
		</div>
	</form>
    
<div class="cell mb-10">
    <span class="gray" style="font-weight: bold;">양식 파일</span>
</div>
        
<div class="cell mb-40">
    <c:if test="${attachNo != null}">
        <div style="display: flex; align-items: center; justify-content: space-between; padding: 12px 16px; border: 1px solid #e2e8f0; border-radius: 6px; background-color: #ffffff; width: 100%; box-sizing: border-box;">
            <div style="display: flex; align-items: center;">
                <i class="fa-solid fa-file-lines" style="color: #7c3aed; font-size: 16px; margin-right: 10px;"></i>
                
                <a href="/download/legacy?attachNo=${attachNo}" style="font-size: 14px; font-weight: 500; color: #1e293b; text-decoration: none;">
                    ${attachDto.attachName}
                </a>
            </div>
            
            <div style="font-size: 12px; color: #64748b; background-color: #f1f5f9; padding: 4px 8px; border-radius: 4px; font-weight: 500;">
                <fmt:formatNumber value="${attachDto.attachSize / 1024}" pattern="#,##0.0"/> KB
            </div>
        </div>
    </c:if>

    <c:if test="${attachNo == null}">
        <div style="padding: 15px; background-color: #f8f9fa; border: 1px solid #e2e8f0; border-radius: 6px; color: #64748b; font-size: 14px;">
            첨부된 파일이 없습니다.
        </div>
    </c:if>
</div>


<div class="cell file-info-area mb-50"></div>
    
    <div class="cell right" id="deleteConfirmForm">
        <c:if test="${sessionScope.loginId != null}">
            <a href="./edit?formNo=${aprvFormSelectVO.formNo}" class="btn btn-positive">수정하기</a>
            
            <a href="./delete?formNo=${aprvFormSelectVO.formNo}" class="btn btn-negative" id="btnDeleteConfirm">삭제하기</a>
        </c:if>

        <a href="./list" class="btn btn-neutral">목록</a>
    </div>

</div>
</c:if>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>