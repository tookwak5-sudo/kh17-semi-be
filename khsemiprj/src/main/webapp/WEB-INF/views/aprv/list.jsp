<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<!-- 결재 목록 디자인 css -->
<link rel="stylesheet" type="text/css" href="/css/aprv/list.css">

<!-- 결재 목록 스크립트 -->
<script src="/js/aprv/list.js"></script>

<h2>결재 목록</h2>
<div class="cell">
	<!-- <a href="/aprv/insert" class="btn btn-positive">결재 등록</a> -->
	<a onclick="openModal();" class="btn btn-positive">결재 등록</a>
</div>

<div class="modal-overlay" id="modalOverlay">
    <div class="modal-box">
        <div class="modal-header center">결재 양식 선택</div>
        
        <div class="modal-body">
            <form id="popupForm1" class="flex-area">
            	<div class="cell w-100">
            		<c:forEach var="aprvFormDto" items="${formList}">
            		<div class="cell">
            			<a href="/aprv/insert?formNo=${aprvFormDto.formNo}" class="btn btn-neutral w-100" style="text-align:left;"><span>[${aprvFormDto.headName}] ${aprvFormDto.formName}</span></a>
            		</div>
	                </c:forEach>
				</div>
            </form>
        </div>
        <div class="modal-footer">
        	<button type="button" class="btn btn-negative" onclick="closeModal()">취소</button>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>