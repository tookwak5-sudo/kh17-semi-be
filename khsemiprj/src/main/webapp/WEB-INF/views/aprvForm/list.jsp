<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-80 mt-20 mb-50 background-card">
	<div class="cell center flex-area">
	    <div class="w-20 flex-area" style="justify-content: left">
				<div>
			        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
			            결재양식 관리
			            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
			        </h1>
				</div>
	    </div>

		<div class="w-70 flex-area flex-center">
	    	<form action="./list" method="get">
	        	<select name="column" class="field field-sm">
	            <option value="form_name" ${param.column == 'form_name' ? 'selected' : ''}>양식명</option>
	            <option value="form_head_no" ${param.column == 'form_head_no' ? 'selected' : ''}>구분(업무/비용 등)</option>
	         	</select>
	            <input type="text" name="keyword" class="field-sm" placeholder="검색어 입력" value="${param.keyword}">
	            <button type="submit" class="btn btn-positive">
	                <i class="fa-solid fa-magnifying-glass"></i>
	                <span>검색</span>
	            </button>
	        </form>
	    </div>
	    <div class="w-15 flex-area flex-center" style="justify-content: right; align-items: center;">
	        <c:if test="${sessionScope.loginId != null}">
	            <a href="./insert" class="btn btn-neutral">
	                <i class="fa-solid fa-plus"></i> 양식 등록
	            </a>
	        </c:if>
	    </div>
	</div>
	
    <div class="cell right">
       ${pageVO.getBeginRownum()}-${pageVO.getEndRownum()} / 총 ${pageVO.count}개의 양식
    </div>

    <div class="cell">
        <table class="table">
            <thead>
                <tr>
                    <th>양식번호</th>
                    <th>구분</th>
                    <th class="w-40">양식명</th>
                    <th>사용여부</th>
                    <th>최종수정일</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="formDto" items="${list}">
                <tr>
                    <td>${formDto.formNo}</td>
                    <td>
                        <c:if test="${formDto.headName != null}">
                            [${formDto.headName}]
                        </c:if>
                    </td>
                    <td align="left">
                        <a href="./detail?formNo=${formDto.formNo}">
                            ${formDto.formName}
                        </a>
                    </td>
                    <td>
                        <c:if test="${formDto.formUseYn == 'Y'}">사용중</c:if>
                        <c:if test="${formDto.formUseYn == 'N'}">미사용</c:if>
                    </td>
                    <td>
                    	<fmt:formatDate value="${formDto.formWtime}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="cell mt-40">
        <jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
    </div>
        
   <%-- <div class="cell center">
    	<form action="./list" method="get">
        	<select name="column" class="field">
            <option value="form_name" ${param.column == 'form_name' ? 'selected' : ''}>양식명</option>
            <option value="form_head_no" ${param.column == 'form_head_no' ? 'selected' : ''}>구분(업무/비용 등)</option>
         	</select>
            <input type="text" name="keyword" class="field-sm" placeholder="검색어 입력" value="${param.keyword}">
            <button type="submit" class="btn btn-positive">
                <i class="fa-solid fa-magnifying-glass"></i>
                <span>검색</span>
            </button>
        </form>
    </div> --%>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>

