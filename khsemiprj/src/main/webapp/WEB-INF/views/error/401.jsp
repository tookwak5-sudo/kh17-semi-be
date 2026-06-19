<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- <h1>일시적인 오류가 발생했습니다</h1> -->
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<h1>${message == null ? "로그인 후 이용 가능합니다" : message}</h1>

<h2><a href="/member/login">로그인 하러가기</a></h2>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>