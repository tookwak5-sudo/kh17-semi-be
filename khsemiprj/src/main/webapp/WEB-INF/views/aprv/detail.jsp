<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<!-- 결재 상세 스크립트 -->
<script src="/js/aprv/detail.js"></script>

<style>
        /* 커스텀 카드 레이아웃만 남겨두고 나머지는 commons.css 활용 */
        .aprv-info-card {
            background-color: #ffffff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 10px 30px;
        }
        .aprv-info-row {
            display: flex;
            align-items: center;
            padding: 16px 0;
            border-bottom: 1px solid #f1f3f5;
        }
        .aprv-info-row-split {
            display: flex;
            align-items: center;
        }
        .aprv-info-row:last-child {
            border-bottom: none;
        }
        .aprv-info-label {
            width: 160px;
            font-weight: 600;
            color: #495057;
            position: relative;
            padding-left: 14px;
            letter-spacing: -0.5px;
        }
        .aprv-info-label::before {
            content: "";
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 4px;
            height: 14px;
            background-color: #739BED;
            border-radius: 2px;
        }
        .aprv-info-value {
            width: 100%;
            color: #343a40;
            font-weight: 500;
        }
        .aprv-info-value.point-color {
            color: #739BED;
            font-weight: 600;
        }
        
        #aprv-context-menu {
	   		position: absolute;
	   		background-color: white;
	   		border: 1px solid #ccc;
	   		box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
	   		border-radius: 3px;
	   		padding: 10px;
	   		z-index: 1000; 
	   		max-width:400px;
		}
	
		#aprv-context-menu a {
	   		display: block;
	   		padding: 8px 15px;
	   		color: #333;
	   		text-decoration: none;
	   		font-size: 14px;
		}
	
		#aprv-context-menu a:hover {
	   		background-color: #f1f3f5; 
		}
		
		.aprv-comment {
			cursor:pointer;
		}
</style>

<script>

	var state = {
		aprvValid: false,
		ok: function(){
			return Object.values(this)
			.filter(v => typeof v==="boolean")
			.every(v => v === true);
		}
	};

	$(function () {
		$(".form-check").on("submit", function(e){
			
			// submit을 유발한 버튼 객체 가져오기
            var clickedButton = e.originalEvent.submitter; 
			if(!state.aprvValid) {
	            // 특정 버튼일 때만 다르게 처리하고 싶다면?
	            if ($(clickedButton).hasClass("aprv-save")) {
	            	$(".form-check").attr("action", "./save");
	    			openConfirm('문서를 기안하시겠습니까?', 'state.aprvValid = true; $(".aprv-save").click();');
	            } else if($(clickedButton).hasClass("aprv-delete")) {
	            	$(".form-check").attr("action", "./delete");
	            	openConfirm('문서를 삭제하시겠습니까?', 'state.aprvValid = true; $(".aprv-delete").click();');
	            } else {
					openAlert("잘못된 접근입니다.<br><br>페이지를 새로고침합니다.", "location.reload();");
	            }
			}
			
			return state.ok();
		});
	});

	$(document).on("click", ".aprv-comment", function(e) {
	    e.stopPropagation(); //클릭 이벤트가 문서 전체로 퍼지는 것을 막음 (바로 닫히는 현상 방지)
	    var comment = $(this).data("comment");
	
		// 코멘트 표시
		$(".comment-view").text(comment);
	
		// 마우스가 클릭된 좌표를 계산하여 메뉴를 이동
		$("#aprv-context-menu").css({
	    	top: e.pageY + 10 + "px", // 마우스 포인터보다 살짝 아래
	    	left: e.pageX + "px"      // 마우스 포인터 위치
		}).show();
	});
	
	$(document).on("click", function() {
    	$("#aprv-context-menu").hide();
	});
</script>

<!-- 사유 클릭 시 나타날 창 -->
<div id="aprv-context-menu" style="display: none;">
	<span class="comment-view"></span>
</div>

<div class="container w-100 mt-20 mb-50 background-card">
	<div class="cell">
		<div class="flex-area" style="align-items:end">
			<div>
				<!-- <h1 class="mt-0 mb-0"> -->
				<h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
					<!-- 결재 분류 -->
					[${aprvDetailVO.headName}]
					<!-- 제목 -->
					${aprvDetailVO.aprvTitle}
					<!-- 상태 -->
					<span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
				</h1>
			</div>
		</div>
	</div>
	
	<div class="aprv-info-card">
		<div class="aprv-info-row">
			<div class="flex-area w-100">
				<div class="w-33 aprv-info-row-split">
					<div class="aprv-info-label">기안자</div>
					<div class="aprv-info-value">
						<c:choose>
						<c:when test="${aprvDetailVO.aprvWriter == null || aprvDetailVO.aprvWriter == ''}">
						<span class="gray">(탈퇴한 사원)</span>
						</c:when>
						<c:otherwise>
						<span>[ ${aprvDetailVO.deptName} ] ${aprvDetailVO.empName} ${aprvDetailVO.empPositionName} ( ${aprvDetailVO.aprvWriter} )</span>
						</c:otherwise>
						</c:choose>
					</div>
				</div>
				<div class="w-33 aprv-info-row-split">
					<c:if test="${not empty aprvDetailVO.aprvWtime}">
					<div class="aprv-info-label">기안일</div>
					<div class="aprv-info-value"><fmt:formatDate value="${aprvDetailVO.aprvWtime}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></div>
					</c:if>
				</div>
			</div>
		</div>
		<c:choose>
		<c:when test="${aprvDetailVO.headName == '연차'}">
		<div class="aprv-info-row">
			<div class="flex-area w-100">
				<div class="w-33 aprv-info-row-split">
					<div class="aprv-info-label">휴가기간</div>
					<div class="aprv-info-value">
						${aprvDetailVO.aprvSdate}
						<c:if test="${aprvDetailVO.aprvSdate != aprvDetailVO.aprvEdate}"> ~ ${aprvDetailVO.aprvEdate}</c:if>
					</div>
				</div>
				<div class="w-33 aprv-info-row-split">
					<div class="aprv-info-label">연차적용</div>
					<div class="aprv-info-value">
						${aprvDetailVO.aprvLeave} 일
					</div>
				</div>
			</div>
		</div>
		</c:when>
		<c:when test="${aprvDetailVO.headName == '비용'}">
		<div class="aprv-info-row">
			<div class="flex-area w-100">
				<div class="w-33 aprv-info-row-split">
					<div class="aprv-info-label">지출일자</div>
					<div class="aprv-info-value">${aprvDetailVO.aprvSdate}</div>
				</div>
			</div>
		</div>
		<div class="aprv-info-row">
			<div class="flex-area w-100">
				<div class="w-33 aprv-info-row-split">
					<div class="aprv-info-label">지출금액</div>
					<div class="aprv-info-value"><fmt:formatNumber value="${aprvDetailVO.aprvCost}" pattern="#,##0"></fmt:formatNumber> 원</div>
				</div>
				<div class="w-33 aprv-info-row-split">
					<div class="aprv-info-label">지출구분</div>
					<div class="aprv-info-value">
						${aprvDetailVO.aprvCostType}
					</div>
				</div>
				<c:if test="${aprvDetailVO.aprvCostType == '개인'}">
				<div class="w-33 aprv-info-row-split">
					<div class="aprv-info-label">계좌정보</div>
					<div class="aprv-info-value">
						${aprvDetailVO.aprvCostReceiveBank} ${aprvDetailVO.aprvCostReceiveAccount} ${aprvDetailVO.aprvCostReceiver}
					</div>
				</div>
				</c:if>
			</div>
		</div>
		</c:when>
		<c:when test="${aprvDetailVO.headName == '사직'}">
		<div class="aprv-info-row">
			<div class="flex-area w-100">
				<div class="w-33 aprv-info-row-split">
					<div class="aprv-info-label">퇴사일자</div>
					<div class="aprv-info-value">${aprvDetailVO.aprvSdate}</div>
				</div>
			</div>
		</div>
		</c:when>
		<c:otherwise>
		<div class="aprv-info-row">
			<div class="flex-area w-100">
				<div class="w-33 aprv-info-row-split">
					<div class="aprv-info-label">기한</div>
					<div class="aprv-info-value">${aprvDetailVO.aprvSdate} ~ ${aprvDetailVO.aprvEdate}</div>
				</div>
			</div>
		</div>
		</c:otherwise>
		</c:choose>
		<div class="aprv-info-row">
			<div class="flex-area w-100">
				<div class="w-33 aprv-info-row-split">
					<div class="aprv-info-label">상태</div>
					<div class="aprv-info-value">
						<c:choose>
						<c:when test="${aprvDetailVO.aprvStatus == '승인'}"><span class="blue bold">${aprvDetailVO.aprvStatus}</span></c:when>
						<c:when test="${aprvDetailVO.aprvStatus == '반려'}"><span class="red bold">${aprvDetailVO.aprvStatus}</span></c:when>
						<c:otherwise>
						${aprvDetailVO.aprvStatus}
						</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>
		</div>
		<div class="cell mb-10">
		    <span class="gray" style="font-weight: bold;">내용</span>
		</div>
		<div class="cell" style="min-height:50px">
			<!-- 있는 그대로의 출력을 수행하는 태그(엔터, 스페이스 등을 인정) -->
			<pre>${aprvDetailVO.aprvContent}</pre>
		</div>
		<div class="cell mb-10">
		    <span class="gray" style="font-weight: bold;">첨부 파일</span>
		</div>
		<c:if test="${attachDto != null}">
		<div class="cell mb-20">
	        <div style="width:fit-content; min-width:300px;display: flex; align-items: center; justify-content: space-between; padding: 12px 16px; border: 1px solid #e2e8f0; border-radius: 6px; background-color: #ffffff; box-sizing: border-box;">
	            <div style="display: flex; align-items: center;">
	                <i class="fa-solid fa-file-lines" style="color: #7c3aed; font-size: 16px; margin-right: 10px;"></i>
	                
	                <a href="/download/legacy?attachNo=${attachDto.attachNo}" style="font-size: 14px; font-weight: 500; color: #1e293b; text-decoration: none;">
	                    ${attachDto.attachName}
	                </a>
	            </div>
	            
	            <div style="font-size: 12px; color: #64748b; background-color: #f1f5f9; padding: 4px 8px; border-radius: 4px; font-weight: 500;">
	                <fmt:formatNumber value="${attachDto.attachSize / 1024}" pattern="#,##0.0"/> KB
	            </div>
	        </div>
		</div>
	    </c:if>
	    <c:if test="${attachDto == null}">
        <div style="width:30%; min-width:200px; padding: 15px; background-color: #f8f9fa; border: 1px solid #e2e8f0; border-radius: 6px; color: #64748b; font-size: 14px;" class="mb-20">
            첨부된 파일이 없습니다.
        </div>
	    </c:if>
	</div>
		<div class="cell flex-area">
			<div class="cell w-50 me-10 aprv-info-card">
				<div class="aprv-info-label mb-0">
		            <label>1차 결재 라인</label>
		        </div>
		        <div class="cell w-100 mt-0">
		        	<table class="table">
		        		<thead>
		        			<tr>
			        			<th width="25%">부서</th>
			        			<th width="25%">결재자</th>
			        			<th width="20%">직책</th>
			        			<th width="30%">상태</th>
		        			</tr>
		        		</thead>
		        		<tbody id="line1List" class="lineList">
		        			<c:forEach var="aprvLineList" items="${aprvLine1List}">
		        			<tr>
		        				<td>${aprvLineList.deptName}</td>
		        				<td>${aprvLineList.empName}</td>
		        				<td>${aprvLineList.empPositionName}</td>
	        					<td data-no="${aprvLineList.aprvLineNo}" style="font-weight:bold;">
		        				<c:choose>
			        				<c:when test="${aprvDetailVO.aprvStatus == '대기' && aprvLineList.aprvLineStatus == '대기' && aprvLineList.empId == sessionScope.loginId}">
	        						<button type="button" class="btn btn-positive line-accept" onclick="openModal('${aprvLineList.aprvLineNo}', '승인')">승인</button>
	        						<button type="button" class="btn btn-negative line-deny" onclick="openModal('${aprvLineList.aprvLineNo}', '반려')">반려</button>
			        				</c:when>
			        				<c:otherwise>
				        				<c:choose>
				        					<c:when test="${aprvLineList.aprvLineStatus == '승인'}"><span class="blue">${aprvLineList.aprvLineStatus}</span> <i class="fa-regular fa-comment aprv-comment" data-comment="${aprvLineList.aprvLineComment}"></i></c:when>
				        					<c:when test="${aprvLineList.aprvLineStatus == '반려'}"><span class="red">${aprvLineList.aprvLineStatus}</span> <i class="fa-regular fa-comment aprv-comment" data-comment="${aprvLineList.aprvLineComment}"></i></c:when>
				        					<c:otherwise><span>${aprvLineList.aprvLineStatus}</span></c:otherwise>
				        				</c:choose>
			        				</c:otherwise>
		        				</c:choose>
	        					</td>
		        			</tr>
		        			</c:forEach>
		        		</tbody>
		        	</table>
		        </div>
			</div>
			<div class="cell w-50 ms-10 aprv-info-card">
				<div class="aprv-info-label mb-0">
		            <label>2차 결재 라인</label>
		        </div>
		        <div class="cell w-100 mt-0">
		        	<table class="table">
		        		<thead>
		        			<tr>
			        			<th width="25%">부서</th>
			        			<th width="25%">결재자</th>
			        			<th width="20%">직책</th>
			        			<th width="30%">상태</th>
		        			</tr>
		        		</thead>
		        		<tbody id="line2List" class="lineList">
		        			<c:choose>
		        			<c:when test="${not empty aprvLine2List}">
		        			<c:forEach var="aprvLineList" items="${aprvLine2List}">
		        			<tr>
		        				<td>${aprvLineList.deptName}</td>
		        				<td>${aprvLineList.empName}</td>
		        				<td>${aprvLineList.empPositionName}</td>
			        			<td data-no="${aprvLineList.aprvLineNo}" style="font-weight:bold;">
		        				<c:choose>
			        				<c:when test="${aprvDetailVO.aprvStatus == '대기' && aprvLineList.aprvLineStatus == '대기' && aprvDetailVO.aprvCurrentSeq == '2' && aprvLineList.empId == sessionScope.loginId}">
	        						<button type="button" class="btn btn-positive line-accept" onclick="openModal('${aprvLineList.aprvLineNo}', '승인')">승인</button>
	        						<button type="button" class="btn btn-negative line-deny" onclick="openModal('${aprvLineList.aprvLineNo}', '반려')">반려</button>
			        				</c:when>
			        				<c:otherwise>
				        				<c:choose>
				        					<c:when test="${aprvDetailVO.aprvStatus == '승인'}"><span class="blue">${aprvLineList.aprvLineStatus}</span> <i class="fa-regular fa-comment aprv-comment" data-comment="${aprvLineList.aprvLineComment}"></i></c:when>
				        					<c:when test="${aprvDetailVO.aprvStatus == '반려'}"><span class="red">${aprvLineList.aprvLineStatus}</span> <i class="fa-regular fa-comment aprv-comment" data-comment="${aprvLineList.aprvLineComment}"></i></c:when>
				        					<c:otherwise><span>${aprvLineList.aprvLineStatus}</span></c:otherwise>
				        				</c:choose>
			        				</c:otherwise>
			        			</c:choose>
	        					</td>
		        			</tr>
		        			</c:forEach>
		        			</c:when>
		        			<c:otherwise>
		        			<tr>
		        				<td colspan="4">2차 결재 라인 목록이 없습니다</td>
		        			</tr>
		        			</c:otherwise>
		        			</c:choose>
		        		</tbody>
		        	</table>
		        </div>
			</div>
		</div>
		<div class="cell right">
			<form method="post" class="form-check">
			<a class="btn btn-neutral" href="./list?aprvHead=${param.aprvHead}&aprvStatus=${param.aprvStatus}&column=${param.column}&keyword=${param.keyword}<c:if test="${param.page != null}">&page=${param.page}</c:if>">목록으로</a>
			<input type="hidden" name="aprvNo" value="${param.aprvNo}" />
			<c:if test="${aprvDetailVO.aprvStatus == '임시저장' && aprvDetailVO.aprvWriter == sessionScope.loginId}">
			<a class="btn btn-save" href="./edit?aprvNo=${aprvDetailVO.aprvNo}">수정</a>
			<button class="btn btn-positive aprv-save">기안하기</button>
			<button class="btn btn-negative aprv-delete">삭제</button>
			</c:if>
			</form>
		</div>
</div>

<div class="modal-overlay" id="modalOverlay">
    <div class="modal-box">
        <div class="modal-header center">결재 승인</div>
        
        <div class="modal-body">
            <form id="popupForm" class="flex-area">
            	<div class="cell w-100">
            		<input type="hidden" name="aprvLineNo" value="" />
            		<input type="hidden" name="aprvLineStatus" value="대기" />
            		<input type="text" name="aprvLineComment" class="field w-100" placeholder="결재 코멘트" />
				</div>
            </form>
        </div>
        <div class="modal-footer">
        	<button type="button" class="btn btn-negative" onclick="closeModal()">취소</button>
        	<button type="button" id="btnAprvLineUpdate" class="btn btn-positive" onclick="aprvLineUpdate()">입력 완료</button>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>