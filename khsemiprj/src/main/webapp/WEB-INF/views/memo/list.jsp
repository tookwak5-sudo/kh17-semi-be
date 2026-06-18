<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/memoHeader.jsp"></jsp:include> 
  
<style>
	.table-hover tbody tr:hover {
		background-color : #f8f9fa;
		transition: background-color 0.2s ease;
	}
	
	.field {
	    border: 1px solid #ced4da; 
	    border-radius: 6px; 
	    padding: 5px 10px; 
	    outline: none;
	    transition: border-color 0.2s ease, box-shadow 0.2s ease;
	}
	
	.field:focus {
	    border-color: #739BED;
	    box-shadow: 0 0 0 3px rgba(115, 155, 237, 0.2);
	}
	
	.unread-badge {
		background-color: #ff6b6b;
		color: white;
		padding: 2px 6px;
		border-radius: 4px;
		font-size: 12px;
		font-weight: bold;
	}
</style>

<div class="container w-600 mt-20 mb-50 background-card">
	<div class="cell center flex-area">
		<div class="w-25 flex-area" style="justify-content: left">
				<div>
			        <h1 style="font-size: 24px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
			            받은 쪽지함
			            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
			        </h1>
				</div>
	    </div>
		<div class="w-70 flex-area flex-center">
			<form action="./list" method="get" style="margin-left:auto; display: flex; align-items: center; gap: 8px">
				<select name="column" class="field" style="padding: 5px 10px; font-size: 16px;">
					<option value="memo_sender_id" ${pageVO.column == 'memo_sender_id' ? 'selected' : ''}>보낸사람</option>
					<option value="memo_title" ${pageVO.column == 'memo_title' ? 'selected' : ''}>제목</option>
					<option value="memo_content" ${pageVO.column == 'memo_content' ? 'selected' : ''}>내용</option>
				</select>
				<input type="text" name="keyword" class="field-sm" value="${pageVO.keyword}" placeholder="검색어를 입력하세요" style="padding: 8px 18px; font-size: 16px;">
				<button class="btn btn-positive" style="padding: 8px 18px; font-size: 16px;">
					<i class="fa-solid fa-magnifying-glass"></i> 
					<span>검색</span>
				</button>
			</form>
		</div>
	</div>	
	<c:if test="${pageVO.keyword != null && pageVO.keyword != ''}">
	<div class="cell">
		<h3>총 <span class="blue">${pageVO.count}</span>개의 쪽지가 검색되었습니다</h3>
	</div>
	</c:if>
	
	<div class="cell">
		<div style="border: 1px solid #e9ecef; border-radius: 8px; overflow: hidden;">
			<table class="table table-hover" style="background-color: white; margin-bottom: 0;">
				<thead>
					<tr style="border-bottom: 2px solid #e9ecef;">
						<th width="10%">분류</th>
						<th width="40%">제목</th>
						<th width="25%">보낸사람</th>
						<th width="25%">받은시간</th>
					</tr>
				</thead>
				<tbody align="center">
					<c:choose>
						<c:when test="${empty list}">
							<tr>
								<td colspan="5" style="padding: 30px; color: #6c757d;">도착한 쪽지가 없습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="memo" items="${list}">
								<tr>
									<td>
										<c:choose>
											<c:when test="${memo.memoType == '공지'}"><span style="color: #e84118; font-weight:bold;">[공지]</span></c:when>
											<c:when test="${memo.memoType == '결재'}"><span style="color: #0097e6; font-weight:bold;">[결재]</span></c:when>
											<c:otherwise><span style="color: #7f8fa6;">[일반]</span></c:otherwise>
										</c:choose>
									</td>
									<td align="left" style="padding-left: 15px; font-weight: ${memo.memoReadStatus == 'N' ? 'bold' : 'normal'};">
										<c:if test="${memo.memoReadStatus == 'N'}">
											<span class="unread-badge">New</span>
										</c:if>
										<c:if test="${memo.memoReadStatus == 'Y'}">
											<span style="color: #adb5bd;">읽음</span>
										</c:if>
										<a href="./detail?memoNo=${memo.memoNo}">
											${memo.memoTitle}										
										</a>
									</td>
									<td>${memo.memoSenderId}(${memo.empName})</td>
									<td>
										<fmt:formatDate value="${memo.memoWtime}" pattern="yyyy-MM-dd HH:mm"/>
									</td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
		<div class="cell right">
				<a class="btn btn-positive" href="./write">
					<i class="fa-regular fa-pen-to-square"></i>
					<span>쪽지쓰기</span>
				</a>
		</div>
	</div>
	<c:if test="${param.send != null}">
	
	<style>
        /* [1] 버튼 기본 스타일 */
        #send-alarm {
            position: fixed; /* 화면 하단에 고정 */
            bottom: 20px;
            right: 20px;
            padding: 15px 25px;
            background-color: transparent;
            color: #5A86E3;
            border: 2px solid #5A86E3;
            border-radius: 50px;
            font-size: 16px;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            z-index: 1000; /* 최상단 위치 */
            
            /* 💡 핵심: 부드러운 움직임 설정 (transition) */
            transition: transform 0.5s ease, opacity 0.5s ease;
        }

        /* [2] 처음 숨겨진 상태 (기본) */
        #send-alarm.btn-slide-hidden {
            /* 아래로 100px 내려가 있고 투명함 */
            transform: translateY(100px); 
            opacity: 0;
        }

        /* [3] 자연스럽게 나타난 상태 (JS로 추가할 클래스) */
        #send-alarm.btn-slide-show {
            /* 제자리로 돌아오고 불투명함 */
            transform: translateY(0);
            opacity: 1;
        }
    </style>
	
	<script>
		// 페이지가 완전히 로드되면 실행
	    document.addEventListener("DOMContentLoaded", function() {
	    	const btn = document.getElementById("send-alarm");

            // --- [단계 1] 자연스럽게 등장 (아래 -> 위) ---
            // 페이지 로드 즉시 등장 애니메이션 클래스 추가
            // (브라우저 렌더링 타이밍을 맞추기 위해 setTimeout을 사용)
            setTimeout(() => {
                btn.classList.add("btn-slide-show");
            }, 10); // 아주 미세한 지연 후 실행

            // --- [단계 2] 3초 대기 ---
            
            // --- [단계 3] 자연스럽게 사라짐 (위 -> 아래) ---
            setTimeout(() => {
                // 등장 클래스를 제거 -> CSS transition에 의해 아래로 내려감
                btn.classList.remove("btn-slide-show");
                
                // 💡 핵심: 애니메이션 시간(0.5초)이 끝난 후 요소 삭제
                // transition 시간인 0.5초(500ms) 뒤에 remove 실행
                setTimeout(() => {
                    btn.remove(); // HTML에서 완전히 삭제
                    console.log("버튼이 완전히 삭제되었습니다.");
                }, 500); // CSS 애니메이션 시간과 맞춤

            }, 3000); // 3초 대기 시간
	    });
	</script>
	
	<div style="position: absolute;top: 590px;right: 20px;">
        <a id="send-alarm" class="btn btn-positive btn-slide-hidden" onclick="$(this).parent().hide();" >쪽지가 전송되었습니다.</a>
    </div>
    </c:if>

	<div class="cell">    
		<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
	</div>
</div>