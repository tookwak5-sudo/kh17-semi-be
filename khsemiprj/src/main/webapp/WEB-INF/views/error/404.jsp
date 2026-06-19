<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<!--  <h1>일시적인 오류가 발생했습니다. -->
<h1>${message == null ? "존재하지 않는 대상입니다" : message}</h1>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>