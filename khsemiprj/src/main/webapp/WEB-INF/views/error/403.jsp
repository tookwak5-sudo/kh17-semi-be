<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- <h1>일시적인 오류가 발생했습니다</h1> -->
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<h1>${message == null ? "해당 기능은 이용하실 수 없습니다" : message}</h1>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>