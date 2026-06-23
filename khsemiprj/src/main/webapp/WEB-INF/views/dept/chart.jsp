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
	
<div class="container w-100 mt-20 mb-50 background-card" style="padding:0px;">

	<div class="cell">
		<h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block; padding-left:20px;">
            조직도
            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
        </h1>
        <div class="zoom-controls">
            <button class="zoom-btn" onclick="zoomOut()">-</button>
            <div class="zoom-text" id="zoomLevel">100%</div>
            <button class="zoom-btn" onclick="zoomIn()">+</button>
            <button class="zoom-btn" onclick="zoomReset()" style="font-size: 11px;"><i class="fa-solid fa-arrow-rotate-left"></i></button>
        </div>
	</div>
	
	<div class="dept-chart-wrapper">
	    <div class="dept-chart-container" style="justify-content: flex-start; margin-bottom:0px;padding-top:0px;">
	        <div class="tree" id="deptChart">
	            <!-- JavaScript로 트리 구조가 생성됩니다. -->
	        </div>     
	        
	        <div id="empDetailCard" class="emp-detail-popup" style="display: none;">
			    <div class="popup-close" onclick="closeDetailCard()">×</div>
			    <div class="popup-row"><span id="popDeptName" class="popup-value"></span></div>
			    <div class="popup-row" style="display:flex;"><span id="popEmpName" class="popup-value"></span><div id="popEmpId"></div></div>
			    <hr>
			    <div class="popup-row"><span class="popup-label">직급:</span> <span id="popEmpPositionName" class="popup-value"></span></div>
			    <div class="popup-row"><span class="popup-label">연락처:</span> <span id="popEmpContact" class="popup-value"></span></div>
			    <div class="popup-row"><span class="popup-label">이메일:</span> <span id="popEmpEmail" class="popup-value"></span></div>
			</div>
	    </div>
    </div>
</div>
	
<jsp:include page="/WEB-INF/views/template/footer.jsp"/>