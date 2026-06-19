<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp" />

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/css/lightpick.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/moment@2.30.1/moment.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/lightpick.min.js"></script>

<style>
/* 툴팁 박스 자체를 숨기고 마우스 포인터 이벤트도 무시 */
.lightpick__tooltip {
    display: none !important;
    visibility: hidden !important;
    opacity: 0 !important;
    pointer-events: none !important;
}
</style>

<script>
$(function() {
    // 검색 조건 변경 시 입력창 스위칭 이벤트
    $("[name=column]").on("change", function() {
        var column = $(this).val();
        
        if (column === "emp_name") {
            // 사원명 검색일 때는 텍스트 인풋만 보여줌 (백엔드 파라미터명인 empName 활성화)
            $(".text-search-zone").show().find("input").prop("disabled", false);
            $(".date-search-zone").hide().find("input").prop("disabled", true);
        } else {
            // 날짜 범위 검색일 때는 시작일/종료일 인풋을 보여줌
            $(".text-search-zone").hide().find("input").prop("disabled", true);
            $(".date-search-zone").css("display", "inline-flex").find("input").prop("disabled", false);
        }
    });

    // 페이지 로드 시 기존 검색 조건에 맞게 인풋 세팅 초기화
    $("[name=column]").trigger("change");
    
    // 시작일과 종료일을 하나의 Lightpick으로 제어
    var picker = new Lightpick({
        field: $("[name=startDate]")[0],
        secondField: $("[name=endDate]")[0], 
        format: "YYYY-MM-DD",
        firstDay: 7,
        selectForward: true
    });
    
    $("#reset-btn").on("click", function() {
       	$("#start").val("");
       	$("#end").val("");
       	$("#name").val("");
    });
});
</script>
<c:if test="${sessionScope.loginId != null && sessionScope.empGrade >=1 }">
    <div class="container w-1000 mt-20 mb-50 background-card">
      <div class="cell center flex-area">
		<div class="w-20 flex-area" style="justify-content: left">
			<div>
		        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
		            퇴사자 조회
		            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
		        </h1>
			</div>
        </div>


        <div class="cell flex-area flex-vertical" style="background-color: #f8fafc; padding: 20px; border-radius: 8px; border: 1px solid #e2e8f0;">
            <form action="exitList" method="get" class="w-100" autocomplete="off">

                <input type="hidden" name="size" value="${pageVO.size}">
                
                <div class="flex-area" style="align-items: center; gap: 10px;">
                    <select name="column" class="field" style="width: 140px;">
                        <option value="emp_name" ${pageVO.column == 'emp_name' ? 'selected' : ''}>사원명</option>
                        <option value="emp_exit_time" ${pageVO.column == 'emp_exit_time' ? 'selected' : ''}>퇴사 신청일</option>
                        <option value="aprv_etime" ${pageVO.column == 'aprv_etime' ? 'selected' : ''}>사직 처리일</option>
                    </select>
                    
                    <div class="text-search-zone" style="display: inline-block;">
                        <input type="text" name="empName" class="field-sm" 
                               placeholder="퇴사 사원명 입력" value="${param.empName}" style="width: 300px;" id="name">
                    </div>
                    
                    <div class="date-search-zone flex-area" style="display: none; align-items: center; gap: 5px;">
                        <input type="text" name="startDate" value="${pageVO.startDate}" class="field" style="width: 160px;" id="start">
                        <span style="color: #64748b;">~</span>
                        <input type="text" name="endDate" value="${pageVO.endDate}" class="field" style="width: 160px;" id="end">
                    </div>
                    
                    <button type="submit" class="btn btn-positive ms-10"><i class="fa-solid fa-magnifying-glass"></i>검색</button>
                    
                    <c:if test="${not empty param.empName or (not empty pageVO.startDate and not empty pageVO.endDate)}">
                        <button type="button" class="btn btn-neutral" id="reset-btn"><i class="fa-solid fa-xmark red" style="width:102px"></i>초기화</button>
                    </c:if>
                </div>
            </form>
        </div>
	</div>
        <div class="cell">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th class="w-20">사원 ID</th>
                        <th class="w-25">사원명</th>
                        <th class="w-30">사직 신청 시각</th>
                        <th class="w-25">사직 처리 시각</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty exitList}">
                        <tr>
                            <td colspan="4" style="text-align: center; padding: 30px 0;" class="gray">
                                조회된 퇴사자 데이터가 없습니다.
                            </td>
                        </tr>
                    </c:if>
                    
                    <c:if test="${not empty exitList}">
                        <c:forEach var="exit" items="${exitList}">
                            <tr>
                                <td>${exit.empId}</td>
                                <td>${exit.empName}</td>
                                <td>
                                    <fmt:formatDate value="${exit.empExitTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </td>
                                <td>
                                    <c:if test="${empty exit.aprvEtime}">
                                        <span class="silver">처리 대기중</span>
                                    </c:if>
                                    <c:if test="${not empty exit.aprvEtime}">
                                        <fmt:formatDate value="${exit.aprvEtime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                    </c:if>
                                </td>
                          	  </tr>
                        </c:forEach>
                    </c:if>
                </tbody>
            </table>
        </div>

        <div class="cell pagination mt-30">
            
            <%-- [이전 블록] 이동 버튼 --%>
            <c:if test="${pageVO.hasPrevious()}">
                <a href="exitList?page=${pageVO.getPreviousBlock()}&column=${pageVO.column}&empName=${param.empName}&startDate=${pageVO.startDate}&endDate=${pageVO.endDate}">&lt;</a>
            </c:if>

            <%-- [숫자 페이지] 반복문 --%>
            <c:forEach var="i" begin="${pageVO.getBeginBlock()}" end="${pageVO.getEndBlock()}">
                <c:if test="${pageVO.page == i}">
                    <a href="exitList?page=${i}&column=${pageVO.column}&empName=${param.empName}&startDate=${pageVO.startDate}&endDate=${pageVO.endDate}" class="on">${i}</a>
                </c:if>
                <c:if test="${pageVO.page != i}">
                    <a href="exitList?page=${i}&column=${pageVO.column}&empName=${param.empName}&startDate=${pageVO.startDate}&endDate=${pageVO.endDate}">${i}</a>
                </c:if>
            </c:forEach>

            <%-- [다음 블록] 이동 버튼 --%>
            <c:if test="${pageVO.hasNext()}">
                <a href="exitList?page=${pageVO.getNextBlock()}&column=${pageVO.column}&empName=${param.empName}&startDate=${pageVO.startDate}&endDate=${pageVO.endDate}">&gt;</a>
            </c:if>
            
        </div>

    </div>
</c:if>
<jsp:include page="/WEB-INF/views/template/footer.jsp"/>