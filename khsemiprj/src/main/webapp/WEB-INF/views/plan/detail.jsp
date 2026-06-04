<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<div class="container w-600 mt-50">
    <h2 class="mb-30">일정 상세 조회</h2>

    <div class="card p-20 mb-30" style="border: 1px solid #ddd; border-radius: 8px;">
        <div class="cell">
            <h1 class="mb-10">
                <c:if test="${planDto.planType != null}">[${planDto.planType}] </c:if>
                ${planDto.planName}
            </h1>
            <p class="text-muted">
                <strong>기간:</strong> 
              	(${planDto.planSdate} 
              	~ 
               	${planDto.planEdate})
            </p>
        </div>
        <div class="cell">
        	${planDto.planExplain}
        </div>
    </div>

    <div class="cell text-right">
        <a href="edit?planNo=${planDto.planNo}" class="btn btn-positive">수정하기</a>
        <a href="delete?planNo=${planDto.planNo}" class="btn btn-negative" 
           onclick="return confirm('정말 삭제하시겠습니까?');">삭제하기</a>
        <a href="list" class="btn btn-netural">목록으로</a>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>