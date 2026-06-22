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
	#user-context-menu {
   		position: absolute;
   		background-color: white;
   		border: 1px solid #ccc;
   		box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
   		border-radius: 3px;
   		padding: 5px 0;
   		z-index: 1000; 
	}

	#user-context-menu a {
   		display: block;
   		padding: 8px 15px;
   		color: #333;
   		text-decoration: none;
   		font-size: 14px;
	}

	#user-context-menu a:hover {
   		background-color: #f1f3f5; 
	}
	
	.writer-name {
		cursor:pointer;
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

	<div class="right" style="font-size: 14px; color: #666;">
		  <strong style="color: #007bff;">${pageVO.count}</strong>개의 일정
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
						<td class="center"><a class="writer-name" data-id="${planDto.empName}">${planDto.empName}(${planDto.planEmpId})</a></td>
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
<script>
	$(document).on("click", ".writer-name", function(e){
		e.stopPropagation(); //클릭 이벤트가 문서 전체로 퍼지는 것을 막음 (바로 닫히는 현상 방지)
		var memberId = $(this).data("id"); // 현재 클릭한 작성자 이름 태그($(this))에 심어져 있는 data-id의 속성값을 가져오기
		if(!memberId) return; //탈퇴한 사용자 등 아이디가 없으면 무시
		
		// 작성 글 보기 링크의 href 주소를 변경
		var searchUrl = "/plan/list?planSdate=&planEdate=&column=emp_name&keyword=" + memberId;
		$("#link-view-posts").attr("href", searchUrl);
		
		// 쪽지 보내기 링크의 아이디를 변경
		$("#link-send-memo").attr("onclick", "sendMemo('"+ memberId +"')");
		
		// 마우스가 클릭된 좌표를 계산하여 메뉴를 이동
		$("#user-context-menu").css({
	    	top: e.pageY + 10 + "px", // 마우스 포인터보다 살짝 아래
	    	left: e.pageX + "px"      // 마우스 포인터 위치
		}).show();
	});
	
	$(document).on("click", function(){
		$("#user-context-menu").hide();
	});
	
	function sendMemo(empId) {
		var w = 650; 
		var h = 650; 
		var left = (screen.width/2) - (w/2); 
		var top = (screen.height/2) - (h/2); 
		window.open('/memo/write?memoSenderId=' + empId, 'memoListPopup', 'width='+w+',height='+h+',top='+top+',left='+left+',scrollbars=yes,resizable=no');
	}
	
</script>
<!-- 닉네임 클릭 시 나타날 창 -->
<div id="user-context-menu" style="display: none;">
	<a href="#" id="link-view-posts">
	 	<i class="fa-solid fa-magnifying-glass"></i> 작성 글 보기
	</a>
	 <a href="#" id="link-send-memo">
    	<i class="fa-solid fa-paper-plane"></i> 쪽지 보내기
   	</a>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>