<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />

<h1>마이 페이지</h1>

<div class="container w-950 mt-50 mb-50">
	<div class="cell">

		<h1>${findEmpDto.empName}님의정보</h1>

	</div>

	<div class="cell">
		<div class="flex-area">
			<div class="w-25">아이디</div>
			<div class="w-75 blue">${findEmpDto.empId}</div>
		</div>

		<div class="flex-area">
			<div class="w-25">이메일</div>
			<div class="w-75 blue">${findEmpDto.empEmail}</div>
		</div>

		<div class="flex-area">
			<div class="w-25">생년월일</div>
			<div class="w-75 blue">${findEmpDto.empBirth}</div>
		</div>

		<div class="flex-area">
			<div class="w-25">연락처</div>
			<div class="w-75 blue">${findEmpDto.empContact}</div>
		</div>

		<div class="flex-area">
			<div class="w-25">우편번호</div>
			<div class="w-75 blue">${findEmpDto.empPost}</div>
		</div>

		<div class="flex-area">
			<div class="w-25">도로명주소</div>
			<div class="w-75 blue">${findEmpDto.empAddress1}</div>
		</div>

		<div class="flex-area">
			<div class="w-25">상세주소</div>
			<div class="w-75 blue">${findEmpDto.empAddress2}</div>
		</div>


		
		
		<!-- 		로그인 이력은 dto dao 구현 해야합니다 -->
		<div class="flex-area">
			<div class="w-25">로그인 이력</div>
			<div class="w-75 blue">2026.06.01</div>
		</div>

		
	</div>


	<div class="cell">

		<h1>${findEmpDto.empName}님의휴가 정보</h1>

	</div>
	
	
	<table border="1">
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
                <td>${leave.leaveYear}년</td>
                <td>${leave.leaveTotal}일</td>
                <td>${leave.leaveUsed}일</td>
                <td>${leave.leaveRemain}일</td>
            </tr>
        </c:forEach>
    </tbody>
</table>



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
					backgroundColor: ['#22c55e', '#e2e8f0'],
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

</div>