<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<style>
/* 공통 배지 스타일 */
.type-badge {
	font-weight: 600;
	font-size: 16px;
}

/* 타입별 색상 설정 */
.type-personal {
	color: #1565C0;
}

.type-dept {
	color: #2E7D32;
}

.type-company {
	color: #EF6C00;
}
</style>

<script>
	$(function () {
		 var picker8 = new Lightpick({
             field : $(".picker-sdate")[0] ,
             secondField : $(".picker-edate")[0],
             singleDate : false,//범위선택으로 변경
             format : "YYYY-MM-DD", 
             firstDay : 7 ,
             numberOfMonths : 2,//2달 표시
             numberOfColumns : 2,//한 줄에 2칸 표시
             selectForward : false,//최초 선택날짜 이후로만 선택가능
         });
		
		$(document).on("click", "#dateReset", function() {
			$(".picker-sdate").val("");
			$(".picker-edate").val("");
			$(".field-sm").val("");
			
		});
	})
</script>
<div class="container w-100 mt-20 mb-50 background-card">
	<div class="cell center flex-area">
    <div>
        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
            일정
            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
        </h1>
    </div>
    <div class="w-70 flex-area flex-center" style="flex: 1; justify-content: center;">
        <form autocomplete="off">
            <input type="text" name="planSdate" class="field picker-sdate" size="4" placeholder="시작일" value="${param.planSdate}">
            	<span class="timeTilde">~</span>
            <input type="text" name="planEdate" class="field picker-edate" size="4" placeholder="종료일" value="${param.planEdate}">
            <select name="column" class="field-ph">
                <option value="emp_name" ${param.column == 'emp_name' ? 'selected' : ''}>작성자</option>
                <option value="dept_name" ${param.column == 'dept_name' ? 'selected' : ''}>부서명</option>
                <option value="plan_name" ${param.column == 'plan_name' ? 'selected' : ''}>일정명</option>
                <option value="plan_type" ${param.column == 'plan_type' ? 'selected' : ''}>일정타입</option>
            </select> 
            <input type="text" name="keyword" class="field-sm" placeholder="검색어 입력" value="${param.keyword}">
            <button type="submit" class="btn btn-positive" style="width:102px">
                <i class="fa-solid fa-magnifying-glass"></i><span>검색</span>
            </button>
            <button type="button" class="btn btn-neutral" style="width:102px" id="dateReset">
                <i class="fa-solid fa-xmark"></i> <span>초기화</span>
            </button>
        </form>
    </div>
    <div class="flex-area" style="justify-content: right; align-items: center; flex-shrink: 0;">
        <c:if test="${sessionScope.loginId != null}">
            <a href="/plan/write" class="btn btn-neutral">일정 등록하기</a>
        </c:if>
    </div>    
</div>

	<div class="cell right mt-0">
		<span>${pageVO.beginRownum}-${pageVO.endRownum} / 총
			${pageVO.count}개 로그</span>
	</div>

	<div class="cell">
		<table class="table">
			<thead>
				<tr>
					<th>일정 타입</th>
					<th>일정명</th>
					<th>일정 기간</th>
					<th>부서</th>
					<th>작성자</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="planDto" items="${planList}">
					<tr style="height: 45px;">
						<c:if test="${planDto.planType== '개인'}">
							<td class="center type-badge type-personal">
								${planDto.planType}</td>
						</c:if>
						<c:if test="${planDto.planType== '부서'}">
							<td class="center type-badge type-dept">${planDto.planType}
							</td>
						</c:if>
						<c:if test="${planDto.planType== '회사'}">
							<td class="center type-badge type-company">
								${planDto.planType}</td>
						</c:if>
						<td class="left"
							style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
							${planDto.planName}</td>
						<td class="center">${planDto.planSdate} ~ ${planDto.planEdate}</td>
						<td class="center"><c:choose>
								<c:when
									test="${empty planDto.deptName && (empty planDto.planDeptNo || planDto.planDeptNo == 0)}">
									<span style="color: #ccc;">지정 없음</span>
								</c:when>
								<c:otherwise>
							${planDto.deptName} (${planDto.planDeptNo})
						</c:otherwise>
							</c:choose></td>
						<td class="center">${planDto.empName}(${planDto.planEmpId})</td>
					</tr>
				</c:forEach>

				<c:if test="${empty planList}">
					<tr>
						<td colspan="6" class="center"
							style="padding: 100px 0; color: #999;">조회된 일정 데이터가 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>
</div>
<div class="cell">
	<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>