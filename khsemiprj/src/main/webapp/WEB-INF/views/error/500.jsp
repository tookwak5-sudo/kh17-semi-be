<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<h1>${message == null ? "일시적인 오류가 발생했습니다" : message}</h1><br>
<a href="javascript:history.back();">이전 페이지로 돌아가기</a>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>