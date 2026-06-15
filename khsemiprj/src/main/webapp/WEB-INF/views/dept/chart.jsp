<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"/>
	
	<!-- 조직도 디자인 css -->
    <link rel="stylesheet" type="text/css" href="/css/dept/chart.css">
	
	<script>
		//조직도 목록 json 정보
		const deptChartList = JSON.parse('${deptChartJson}');
	</script>
	
	<!-- 조직도 동작 스크립트 -->
	<script src="/js/dept/chart.js"></script>
	
	<h1>조직도</h1>
	
	<div class="dept-chart-wrapper">
		<div class="zoom-controls">
            <button class="zoom-btn" onclick="zoomOut()">-</button>
            <div class="zoom-text" id="zoomLevel">100%</div>
            <button class="zoom-btn" onclick="zoomIn()">+</button>
            <button class="zoom-btn" onclick="zoomReset()" style="font-size: 11px;"><i class="fa-solid fa-arrow-rotate-left"></i></button>
        </div>
	    <div class="dept-chart-container" style="justify-content: flex-start;">
	        <div class="tree" id="deptChart">
	            <!-- JavaScript로 트리 구조가 생성됩니다. -->
	        </div>
	        
	        <div id="empDetailCard" class="emp-detail-popup" style="display: none;">
			    <div class="popup-close" onclick="closeDetailCard()">×</div>
			    <div class="popup-row"><span id="popDeptName" class="popup-value"></span></div>
			    <div class="popup-row"><span id="popEmpName" class="popup-value"></span></div>
			    <hr>
			    <div class="popup-row"><span class="popup-label">직급:</span> <span id="popEmpPositionName" class="popup-value"></span></div>
			    <div class="popup-row"><span class="popup-label">연락처:</span> <span id="popEmpContact" class="popup-value"></span></div>
			    <div class="popup-row"><span class="popup-label">이메일:</span> <span id="popEmpEmail" class="popup-value"></span></div>
			</div>
	    </div>
    </div>
	
<jsp:include page="/WEB-INF/views/template/footer.jsp"/>