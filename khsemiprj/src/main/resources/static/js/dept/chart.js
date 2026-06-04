/**
 * 조직도 동작을 위한 js코드
 */

$(function () {
	// 1. 변경된 데이터 구조: 부서 정보와 그 부서에 속한 멤버 리스트(empList)를 분리
	//const deptChartList = JSON.parse('${deptChartJson}');

	// 2. 부서 박스와 내부에 사원 리스트를 포함하여 트리를 그리는 재귀 함수
	function createTree(node) {
		const li = document.createElement('li');
	    
	    const deptCard = document.createElement('div');
	    //deptCard.className = `dept-card \${node.deptDepth == 0 ? 'root-node' : ''}`;
		deptCard.className = "dept-card " + (node.deptDepth == 0 ? 'root-node' : '');
	    
	    const empCount = node.empList ? node.empList.length : 0;
	    /*deptCard.innerHTML = `
	        <div class="dept-header">
	            <span>\${node.deptName}</span>
	            <span style="font-size:11px; opacity:0.8;">(\${empCount}명)</span>
	        </div>
	    `;*/
		deptCard.innerHTML = "" +
	        "<div class=\"dept-header\">" + 
	            "<span>" + node.deptName + "</span>" + 
	            "<span style=\"font-size:11px; opacity:0.8;\">(" + empCount + "명)</span>" + 
	        "</div>";

	    const empListDiv = document.createElement('div');
	    empListDiv.className = 'emp-list';

	    if (node.empList && node.empList.length > 0) {
	        node.empList.forEach(emp => {
	            const item = document.createElement('div');
	            item.className = 'emp-item';
	            if(node.deptEmpId == emp.empId) {
	            	/*item.innerHTML = `
	                    <span class="emp-name">\${emp.empName}</span>
	                    <span><i class="fa-solid fa-crown gold"></i></span>
	                    <span class="emp-position">\${emp.empPositionName}</span>
	                `;*/
					item.innerHTML = "" +
	                    "<span class=\"emp-name\">" + emp.empName + "</span>" +
	                    "<span><i class=\"fa-solid fa-crown gold\"></i></span>" + 
	                    "<span class=\"emp-position\">" + emp.empPositionName + "</span>"
	                ;
	            } else {
	                /*item.innerHTML = `
	                    <span class="emp-name">\${emp.empName}</span>
	                    <span class="emp-position">\${emp.empPositionName}</span>
	                `;*/
					item.innerHTML = "" +
	                    "<span class=\"emp-name\">" + emp.empName + "</span>" +
	                    "<span class=\"emp-position\">" + emp.empPositionName + "</span>"
	                ;
	            }
	            empListDiv.appendChild(item);
	        });
	    } else {
	        /*empListDiv.innerHTML = `<div class="empty-emp">배치 사원 없음</div>`;*/
			empListDiv.innerHTML = "<div class=\"empty-emp\">배치 사원 없음</div>";
	    }
	    deptCard.appendChild(empListDiv);
	    li.appendChild(deptCard);

	    if (node.children && node.children.length > 0) {
	        const ul = document.createElement('ul');
	        node.children.forEach(child => {
	            ul.appendChild(createTree(child));
	        });
	        li.appendChild(ul);
	    }
	    return li;
	}

	// 3. 트리 렌더링 시작
	if (deptChartList && deptChartList.length > 0) {
	    const chartContainer = document.getElementById('deptChart');
	    // 트리 전체를 감싸는 최상위 ul 생성
	    const rootUl = document.createElement('ul');
	    // 📌 여러 개의 루트 노드를 반복문 돌리며 rootUl에 li 형태로 붙여줍니다.
	    deptChartList.forEach(rootNode => {
	        rootUl.appendChild(createTree(rootNode));
	    });
	    chartContainer.appendChild(rootUl);
	}
});

//기본 배율 및 설정값 정의
let currentScale = 1.0;
const maxScale = 1.5;     // 최대 150% 확대
const minScale = 0.4;     // 최소 40% 축소
const scaleStep = 0.1;    // 한 번 누를 때마다 10%씩 조절

// 2. 배율 적용 함수 (에러 방지 가드 가동)
function applyZoom() {
    const chart = document.getElementById('deptChart');
    const text = document.getElementById('zoomLevel');
    
    // 예외 처리: HTML 요소를 찾지 못했을 때 스크립트 에러로 멈추는 것을 방지
    if (!chart || !text) {
        console.warn("조직도 요소를 찾을 수 없습니다.");
        return;
    }
    
    // 안전하게 숫자로 변환 후 CSS scale 적용
    const scaleValue = Number(currentScale);
    
 	// 📌 [변경] transform 대신 브라우저 표준 zoom 속성을 사용하여 직접 비율을 조절합니다.
    chart.style.zoom = scaleValue;
    
    /* [수정 포인트] Math.round 오류 방지
       scaleValue에 100을 곱한 뒤 소수점을 버리고 정수로 만듭니다.
       Math.floor()나 Math.round()를 쓰기 전 확실하게 숫자로 강제 변환합니다.
    */
    const percentage = Math.round(scaleValue * 100);
    text.innerText = percentage + "%";
}

// ➕ 확대
function zoomIn() {
    if (currentScale < maxScale) {
        currentScale = parseFloat((currentScale + scaleStep).toFixed(1));
        applyZoom();
    }
}

// ➖ 축소
function zoomOut() {
    if (currentScale > minScale) {
        currentScale = parseFloat((currentScale - scaleStep).toFixed(1));
        applyZoom();
    }
}

// 🔄 원본 비율 리셋
function zoomReset() {
    currentScale = 1.0;
    applyZoom();
}