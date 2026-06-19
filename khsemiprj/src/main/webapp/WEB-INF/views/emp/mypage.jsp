<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp" />

<style>
	/* 전체 컨테이너 여백 */
	.mypage-container { max-width: 1000px; margin: 40px auto; }
	
	/* 정보 카드 그룹 */
	.card-group {
	    display: grid;
	    grid-template-columns: 1fr 1fr; /* 2열 배치 */
	    gap: 20px;
	}
	
	/* 개별 정보 카드 */
	.info-card {
	    background: #ffffff;
	    border-radius: 16px;
	    padding: 24px;
	    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
	    border: 1px solid #e2e8f0;
	}
	
	/* 상세 행 스타일 */
	.info-row {
	    display: flex;
	    padding: 12px 0;
	    border-bottom: 1px solid #f1f5f9;
	}
	.info-row:last-child { border-bottom: none; }
	.info-label { width: 125px; color: #64748b; font-weight: 500; display: flex; align-items: center; gap: 8px; }
	.info-value { color: #1e293b; font-weight: 600; }
	
	/* 테이블 헤더 색상 및 디자인 개선 */
	.table { width: 100%; border-collapse: separate; border-spacing: 0; margin-top: 10px; }
	.table th { background-color: #f8fafc; padding: 14px; border-bottom: 2px solid #e2e8f0; color: #475569; }
	.table td { padding: 14px; border-bottom: 1px solid #f1f5f9; text-align: center; }
	
	/* 휴가 정보 카드 스타일 */
	.vacation-card {
	    background: #ffffff;
	    border-radius: 16px;
	    padding: 24px;
	    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
	    border: 1px solid #e2e8f0;
	    margin-top: 30px;
	}
	
	/* 테이블 디자인 개선 */
	.vacation-table {
	    width: 100%;
	    border-collapse: separate;
	    border-spacing: 0;
	    margin-top: 15px;
	}
	.vacation-table th {
	    background-color: #f8fafc;
	    padding: 16px;
	    border-bottom: 2px solid #e2e8f0;
	    color: #475569;
	    font-weight: 600;
	}
	.vacation-table td {
	    padding: 16px;
	    border-bottom: 1px solid #f1f5f9;
	    text-align: center;
	    color: #334155;
	}
	
	/* 차트 영역 스타일 개선 */
	.chart-box-left, .chart-box-right {
	    background: #ffffff !important;
	    border: 1px solid #e2e8f0;
	    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
	    border-radius: 16px;
	}
	
	/* 섹션 제목 컨테이너 */
	.section-header {
	    display: flex;
        flex-direction: column; /* 세로 정렬 */
        align-items: flex-start; /* 좌측 기준 정렬 */
        margin-bottom: 24px;
        padding-left: 12px;
        border-left: 4px solid #4f46e5;
	}
	
	/* 제목 텍스트 스타일 */
	.section-title {
	    font-size: 20px;
        font-weight: 700;
        color: #1e293b;
        margin: 0;
	}
	
	/* 부가적인 강조를 위한 서브 문구 (선택) */
	.section-subtitle {
	    font-size: 14px;
        color: #64748b;
        margin-top: 5px; /* 제목과 부제목 사이 간격 */
        margin-left: 0;
	}
	
	.page-title {
    font-size: 28px;
    font-weight: 800;
    color: #1e293b;
    margin-bottom: 30px;
    position: relative;
    display: inline-block;
	}
	.page-title::after {
	    content: '';
	    position: absolute;
	    left: 0; bottom: -8px;
	    width: 40px; height: 4px;
	    background: #4f46e5; /* 포인트 컬러 */
	    border-radius: 2px;
	}
</style>


<div class="container w-90 mt-20 mb-50 background-card">
	<div style="margin-bottom: 40px;">
	        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
	            마이 페이지
	            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
	        </h1>
	</div>
	
	<div class="section-header">
	    <h1 class="section-title">${findEmpDto.empName}님의 정보</h1>
	    <span class="section-subtitle">기본 및 상세 설정 관리</span>
	</div>

	<div class="card-group">
	    <div class="info-card" style="position: relative;">
    <div style="position: absolute; top: 20px; right: 20px; display: flex; gap: 8px;">
        <a href="/emp/checkPassword" class="btn btn-positive">내 정보 수정</a>
        <a href="/emp/changePassword" class="btn btn-neutral">비밀번호 수정</a>
    </div>
    
    <h3>기본 정보</h3>
    
    <div style="display: flex; gap: 30px; margin-top: 20px;">
        <div style="flex-grow: 1;">
            <div class="info-row"><div class="info-label"><i class="fa-solid fa-user"></i> 아이디</div><div class="info-value">${findEmpDto.empId}</div></div>
            <div class="info-row"><div class="info-label"><i class="fa-solid fa-envelope"></i> 이메일</div><div class="info-value">${findEmpDto.empEmail}</div></div>
            <div class="info-row"><div class="info-label"><i class="fa-solid fa-phone"></i> 연락처</div><div class="info-value">${findEmpDto.empContact}</div></div>
        </div>
    </div>
</div>
	    <div class="info-card">
	        <h3>상세 정보</h3>
	        <div class="info-row"><div class="info-label"><i class="fa-solid fa-location-dot"></i>주소</div><div class="info-value">${findEmpDto.empAddress1}</div></div>
	        <div class="info-row"><div class="info-label"><i class="fa-solid fa-cake-candles"></i>생년월일</div><div class="info-value">${findEmpDto.empBirth}</div></div>
	        <div class="info-row">
	        	<div class="info-label">
	        		<i class="fa-solid fa-clock-rotate-left"></i>
	        		최종 로그인
	        	</div>
	        	<div class="info-value">
	        		<fmt:formatDate value="${findEmpDto.empLogin}" pattern="yyyy-MM-dd" />
	        	</div>
	        </div>
	   </div>
	</div>

	<div class="section-header mt-50">
	    <h1 class="section-title">휴가 현황</h1>
	    <span class="section-subtitle">연차 사용 및 잔여 현황</span>
	</div>
	<div class="vacation-card">
	    <table class="vacation-table">
	        <thead>
	            <tr>
	                <th>연도</th>
	                <th>총 연차</th>
	                <th>사용 연차</th>
	                <th>잔여 연차</th>
	            </tr>
	        </thead>
	        <tbody>
	            <c:forEach var="leave" items="${empLeaveList}">
	                <tr>
	                    <td><strong>${leave.leaveYear}년</strong></td>
	                    <td>${leave.leaveTotal}일</td>
	                    <td><span style="color: #ef4444;">${leave.leaveUsed}일</span></td>
	                    <td><strong>${leave.leaveRemain}일</strong></td>
	                </tr>
	            </c:forEach>
	        </tbody>
	    </table>
	</div>

	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

	<style>
		.chart-section { width: 100%; margin-top: 50px; }
		.chart-header { display: flex; align-items: center; justify-content: center; gap: 20px; margin-bottom: 30px; user-select: none; }
		.chart-header .btn-arrow { font-size: 24px; font-weight: bold; cursor: pointer; color: #333; transition: color 0.2s; }
		.chart-header .btn-arrow:hover { color: #007bf6; }
		.chart-header .period-text { font-size: 22px; font-weight: bold; color: #222; min-width: 250px; text-align: center; }
		
		.chart-flex-container { display: flex; gap: 30px; width: 100%; align-items: center; }
		.chart-box-left { flex: 7; background-color: #f8fafc; border-radius: 12px; padding: 20px; height: 380px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
		.chart-box-right { flex: 3; background-color: #f8fafc; border-radius: 12px; padding: 20px; height: 380px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); display: flex; flex-direction: column; align-items: center; justify-content: center; }
		.total-info-text { margin-top: 15px; font-size: 18px; font-weight: bold; color: #333; }
	</style>

	<div class="chart-section">
		<div class="section-header">
	    <h1 class="section-title">${findEmpDto.empName}님의 근무 리포트</h1>
	    <span class="section-subtitle">근무 시간</span>
		</div> 
		<div class="chart-header">
			<span class="btn-arrow" id="prevMonthBtn">&lt;</span>
			<span class="period-text" id="periodDisplay">2026. 05 ~ 2026. 06</span>
			<span class="btn-arrow" id="nextMonthBtn">&gt;</span>
		</div>
	
		<div class="chart-flex-container">
			<div class="chart-box-left">
				<canvas id="weeklyBarChart"></canvas>
			</div>
			
			<div class="chart-box-right">
				<div style="width: 100%; height: 260px; position: relative;">
					<canvas id="monthlyPieChart"></canvas>
				</div>
				<div class="total-info-text" id="totalHoursText">총 근무시간: 0시간</div>
			</div>
		</div>
	</div>
</div>

<script>
	let currentDate = new Date();
	let currentYear = currentDate.getFullYear();
	let currentMonth = currentDate.getMonth() + 1;
	
	
	let barChartInstance = null;
	let pieChartInstance = null;

	const targetEmpId = '${findEmpDto.empId}';

	window.addEventListener('load', function() {
		loadChartData(currentYear, currentMonth);
		
		document.getElementById('prevMonthBtn').addEventListener('click', function() {
			currentMonth--;
			if(currentMonth < 1) {
				currentMonth = 12;
				currentYear--;
			}
			loadChartData(currentYear, currentMonth);
		});
		
		document.getElementById('nextMonthBtn').addEventListener('click', function() {
			currentMonth++;
			if(currentMonth > 12) {
				currentMonth = 1;
				currentYear++;
			}
			loadChartData(currentYear, currentMonth);
		});
	});

	function loadChartData(year, month) {
		let nextY = year;
		let nextM = month + 1;
		if(nextM > 12) { nextM = 1; nextY++; }
		
		const formatM = month < 10 ? '0' + month : month;
		const formatNextM = nextM < 10 ? '0' + nextM : nextM;
		
		document.getElementById('periodDisplay').innerText = year + '. ' + formatM + ' ~ ' + nextY + '. ' + formatNextM;
		
		const yearMonthParam = year + '-' + formatM;
		
		fetch('${pageContext.request.contextPath}/rest/stat/workhours?empId=' + targetEmpId + '&yearMonth=' + yearMonthParam)
			.then(response => response.json())
			.then(data => {
				const labels = ['1주차', '2주차', '3주차', '4주차', '5주차'];
				const values = [0, 0, 0, 0, 0];
				
				data.forEach(item => {
					intIdx = labels.indexOf(item.title);
					if(intIdx !== -1) {
						values[intIdx] = item.value;
					}
				});
				
				const totalHours = values.reduce((acc, cur) => acc + cur, 0);
				document.getElementById('totalHoursText').innerText = '총 근무시간: ' + totalHours.toFixed(1) + '시간';
				
				drawWeeklyBarChart(labels, values);
				drawMonthlyPieChart(totalHours);
			})
			.catch(err => console.error('데이터 로드 실패:', err));
	}

	function drawWeeklyBarChart(labels, values) {
		if(barChartInstance) barChartInstance.destroy(); 
		
		const maxValue = Math.max(...values);
		
		const chartMax = maxValue > 52 ? Math.ceil(maxValue) + 2 : 52;
		
		const ctx = document.getElementById('weeklyBarChart').getContext('2d');
		barChartInstance = new Chart(ctx, {
			type: 'bar',
			data: {
				labels: labels,
				datasets: [{
					label: '주차별 근무 시간 (h)',
					data: values,
					backgroundColor: 'rgba(0, 123, 246, 0.6)',
					borderColor: 'rgba(0, 123, 246, 1)',
					borderWidth: 1,
					borderRadius: 5
				}]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				scales: {
					y: { beginAtZero: true, max : chartMax } 
				}
			}
		});
	}

	// 원형그래프
	function drawMonthlyPieChart(totalHours) {
		if(pieChartInstance) pieChartInstance.destroy();
		
		// 기준 시간 정의 (예: 한 달 소정 근로시간 기본 160시간 기준 업무 진척도 표시)
		const targetHours = 209; 
		let remaining = targetHours - totalHours;
		if(remaining < 0) remaining = 0; // 초과 근무 시 0 처리
		
		const ctx = document.getElementById('monthlyPieChart').getContext('2d');
		pieChartInstance = new Chart(ctx, {
			type: 'doughnut',
			data: {
				
				labels: ['지정 근무완료', '잔여 의무시간'],
				datasets: [{
					data: [totalHours, remaining],
					backgroundColor: ['#91D2FF', '#EBEFF5'],
					borderWidth: 0
				}]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				plugins: {
					legend: { display: false } // 수치는 하단 텍스트로 표현하므로 범례 숨김
				}
			}
		});
	}
</script>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>

