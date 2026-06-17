<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp" />

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
$(function() {
    // 검색 조건 변경 시 입력창 스위칭 이벤트
    $("[name=column]").on("change", function() {
        var column = $(this).val();
        
        if (column === "emp_name") {
            // 사원명 검색일 때는 텍스트 인풋만 보여줌
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
});
</script>

<body>

    <div class="container w-1000 mt-50">
        
        <div class="cell">
            <h2>퇴사자 조회</h2>
        </div>

        <div class="cell flex-area flex-vertical" style="background-color: #f8fafc; padding: 20px; border-radius: 8px; border: 1px solid #e2e8f0;">
            <form action="exitList" method="get" class="w-100">
                <input type="hidden" name="size" value="${pageVO.size}">
                
                <div class="flex-area" style="align-items: center; gap: 10px;">
                    <select name="column" class="field" style="width: 140px;">
                        <option value="emp_name" ${pageVO.column == 'emp_name' ? 'selected' : ''}>사원명</option>
                        <option value="emp_exit_time" ${pageVO.column == 'emp_exit_time' ? 'selected' : ''}>퇴사 신청일</option>
                        <option value="aprv_etime" ${pageVO.column == 'aprv_etime' ? 'selected' : ''}>사직 처리일</option>
                    </select>
                    
                    <div class="text-search-zone" style="display: inline-block;">
                        <input type="text" name="keyword" class="field-sm" 
                               placeholder="퇴사 사원명 입력" value="${pageVO.keyword}" style="width: 300px;">
                    </div>
                    
                    <div class="date-search-zone flex-area" style="display: none; align-items: center; gap: 5px;">
                        <input type="date" name="startDate" value="${pageVO.startDate}" class="field" style="width: 160px;">
                        <span style="color: #64748b;">~</span>
                        <input type="date" name="endDate" value="${pageVO.endDate}" class="field" style="width: 160px;">
                    </div>
                    
                    <button type="submit" class="btn btn-positive ms-10">검색</button>
                    
                    <c:if test="${pageVO.keyword != null || (pageVO.startDate !=null && pageVO.endDate !=null)}">
                        <a href="exitList" class="btn btn-neutral">초기화</a>
                    </c:if>
                </div>
            </form>
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
                    <c:if test="${exitList == null}">
                        <tr>
   				 			<td style="position: absolute; left: 0; width: 100%; text-align: center; 
   				 			padding: 30px 0;" class="gray">
       					 		조회된 퇴사자 데이터가 없습니다.
    						</td>
						</tr>
                    </c:if>
                    
                    <c:if test="${exitList != null}">
                        <c:forEach var="exitList" items="${exitList}">
                            <tr>
                                <td>${exitList.empId}</td>
                                <td>${exitList.empName}</td>
                                <td>
                                    <fmt:formatDate value="${exitList.empExitTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </td>
                                <td>
                                    <c:if test="${exitList.aprvEtime == null}">
                                        <span class="silver">처리 대기중</span>
                                    </c:if>
                                    <c:if test="${exitList.aprvEtime !=null }">
                                        <fmt:formatDate value="${exitList.aprvEtime}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
                <a href="exitList?page=${pageVO.getPreviousBlock()}&${pageVO.getSearchParams()}">&lt;</a>
            </c:if>

            <%-- [숫자 페이지] 반복문 --%>
            <c:forEach var="i" begin="${pageVO.getBeginBlock()}" end="${pageVO.getEndBlock()}">
                <c:if test="${pageVO.page == i}">
                    <a href="exitList?page=${i}&${pageVO.getSearchParams()}" class="on">${i}</a>
                </c:if>
                <c:if test="${pageVO.page != i}">
                    <a href="exitList?page=${i}&${pageVO.getSearchParams()}">${i}</a>
                </c:if>
            </c:forEach>

            <%-- [다음 블록] 이동 버튼 --%>
            <c:if test="${pageVO.hasNext()}">
                <a href="exitList?page=${pageVO.getNextBlock()}&${pageVO.getSearchParams()}">&gt;</a>
            </c:if>
            
        </div>

    </div>

</body>
</html>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>