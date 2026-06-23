<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"/>
	
<script>
	function deptDelete(deptNo) {
		openConfirm("부서를 삭제하시겠습니까?", "location.href='./delete?deptNo=" + deptNo + "';");
	}
</script>

<form action="./edit" autocomplete="off" method="post" class="form-check">
      
	<div class="container w-400 mt-50 background-card">
				
		<div>
	        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
	            부서 정보 수정
	            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
	        </h1>
		</div>

       <!-- 기본키 숨김처리 -->
<!--       부서 번호 -->
      <input type="hidden" name="deptNo" value="${deptDto.deptNo}">
      
        <div class="cell">
            <label>부서 이름 <i class="fa-solid fa-asterisk red"></i></label>
            <input type="text" name="deptName" value="${deptDto.deptName}"
                class="field w-100" required>
        </div>
        <div class="cell">
            <label>상위 부서 선택</label> 

            <select class="field w-100" name="deptParentNo" value"${deptDto.deptParentNo}>
                <option value="">선택하세요</option>
                <c:forEach var="dept" items="${deptList}">
			        <option value="${dept.deptNo}" 
			            <c:if test="${dept.deptNo == deptDto.deptParentNo}"> selected</c:if>
			            <c:if test="${param.deptNo == dept.deptNo}"> disabled="disabled"</c:if>
			            >
			            <c:if test="${dept.deptDepth > 0}">
						    <c:forEach begin="1" end="${dept.deptDepth}">
						    	&#12288;
						    </c:forEach>
						    └
						</c:if>
			            ${dept.deptName}
			        </option>
			    </c:forEach>
            </select>
        </div>
        
        <div class="cell">
        	<label>부서 사용 여부</label>
        	<input type="checkbox" name="deptUseYn" value="Y"
        		<c:if test="${deptDto.deptUseYn == 'Y'}">checked</c:if>
        	>
        </div>
        
        <div class="cell mt-40 right">
        	<a href="./list" class="btn btn-neutral">목록으로</a>
            <button type="submit" class="btn btn-save">
                <i class="fa-solid fa-pen"></i>
				<span>수정하기</span>
            </button>
            <a class="btn btn-negative" onclick="deptDelete('${deptDto.deptNo}');">
			<i class="fa-solid fa-trash"></i>
			<span>삭제하기</span>
			</a>
        </div>
    </div>
</form>
	
	
<jsp:include page="/WEB-INF/views/template/footer.jsp"/>