<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<c:if test="${sessionScope.loginId != null && sessionScope.empGrade >=1 }">
<div class="container w-800 mt-100 mb-100 center">

    <div class="cell mb-40">
        <h1 style="font-size: 36px; font-weight: bold; color: #333;">삭제 완료</h1>
    </div>

    <div class="cell mb-50">
        <p style="font-size: 18px; color: #666; line-height: 1.6;">
            요청하신 결재 양식이 정상적으로 삭제되었습니다.<br>
            목록으로 돌아가서 결과를 확인해 주세요.
        </p>
    </div>

    <div class="cell center">
        <a href="./list" class="btn" style="background-color: #37474f; color: white; border: none; padding: 12px 30px; font-size: 16px;">
            목록으로 이동 ≡
        </a>
    </div>

</div>
</c:if>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>