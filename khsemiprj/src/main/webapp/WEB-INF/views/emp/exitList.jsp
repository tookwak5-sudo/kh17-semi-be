<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp" />

<div class="container w-950 mt-50 mb-50">
    
    <div class="cell mb-30">
        <h1 class="mt-0 mb-10 black"><i class="fa-solid fa-user-slash red"></i> 퇴사 사원 목록</h1>
        <div class="gray" style="font-size: 14px;">시스템에서 퇴사 처리 완료된 사원들의 기록을 조회합니다.</div>
    </div>

    <div class="cell right mb-20">
        <form action="exitList" method="get" class="flex-area" style="justify-content: flex-end; align-items: center;">
            <input type="hidden" name="column" value="emp_name">
            
            <input type="text" name="keyword" class="field-sm me-10" 
                   placeholder="퇴사 사원명 입력" value="${pageVO.keyword}">
                   
            <button type="submit" class="btn btn-neutral" style="height: 40px;">
                <i class="fa-solid fa-magnifying-glass"></i> <span class="ms-10">검색</span>
            </button>
            
            <c:if test="${pageVO.keyword != null}">
                <a href="exitList" class="btn btn-negative ms-10" style="height: 40px;">
                    <i class="fa-solid fa-rotate-left"></i> <span class="ms-10">초기화</span>
                </a>
            </c:if>
        </form>
    </div>

    <div class="cell">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th style="width: 25%;">사원 아이디</th>
                    <th style="width: 30%;">사원명</th>
                    <th style="width: 45%;">퇴사 신청 시각</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="exitList" items="${exitList}">
                    <tr>
                        <td class="black">${exitList.empId}</td>
                        <td>
                            <b class="black">${exitList.empName}</b>
                        </td>
                        <td class="gray">
                            <fmt:formatDate value="${exitList.empExitTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

   <div class="cell mt-40">
        <jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
    </div>

</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp" />