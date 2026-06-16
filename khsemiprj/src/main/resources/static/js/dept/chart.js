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
				// 📌 [수정] 단순 alert 대신 상세 팝업 호출 함수를 연결 (이벤트 객체와 요소를 함께 전달)
			    item.onclick = function(e) {
			        e.stopPropagation(); 
			        showDetailCard(e, item, emp);
			    };
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

// 팝업 열기 함수
function showDetailCard(event, element, empData) {
    const popup = document.getElementById('empDetailCard');
    const container = document.querySelector('.dept-chart-container');
    
    if (!popup || !container) return;

    // 1. 팝업 데이터 매핑
	document.getElementById('popDeptName').innerText = empData.deptName;
    document.getElementById('popEmpName').innerText = empData.empName;
	document.getElementById('popEmpId').innerHTML = "<a onclick='sendMemo(\"" + empData.empId + "\");' style='cursor:pointer;margin-left:5px;' title='쪽지쓰기'><i class='fa-solid fa-paper-plane'></i></a>";
	document.getElementById('popEmpPositionName').innerText = empData.empPositionName;
	document.getElementById('popEmpContact').innerText = empData.empContact;
	document.getElementById('popEmpEmail').innerText = empData.empEmail;

	// 높이와 가로 길이를 정확히 계산하기 위해 임시 표시
    popup.style.display = 'block';
	
    // 2. 위치 계산을 위해 컨테이너 안에서 클릭된 요소의 상대 위치값 추출
    // offsetTop, offsetLeft는 부모 요소 기준이므로 부모들을 거슬러 올라가며 정밀 계산합니다.
    let targetTop = element.offsetTop;
    let targetLeft = element.offsetLeft;
    let currentParent = element.offsetParent;

    // 조직도 컨테이너(.org-chart-container)를 만날 때까지 좌표를 누적합니다 (배율/스크롤 대응)
    while (currentParent && !currentParent.classList.contains('dept-chart-container')) {
        targetTop += currentParent.offsetTop;
        targetLeft += currentParent.offsetLeft;
        currentParent = currentParent.offsetParent;
    }

	/* 📌 [핵심 수정] 배율(Zoom) 역산 보정 알고리즘 적용
       - 화면이 축소/확대되었으므로, 원래 좌표값에 현재 배율(currentScale)을 곱해주어야 
         눈에 보이는 실제 화면상의 픽셀 위치와 일치하게 됩니다.
    */
    const scaleValue = Number(currentScale) || 1.0;
    
    // 배율이 적용된 실제 사원 카드의 좌표와 크기 재계산
    const scaledTop = targetTop * scaleValue;
    const scaledLeft = targetLeft * scaleValue;
    const scaledWidth = element.offsetWidth * scaleValue;
    const scaledHeight = element.offsetHeight * scaleValue;

    // 3. 컨테이너 및 팝업 크기 파악 (팝업은 zoom 영향을 받지 않는 부모 밑에 있으므로 원본 크기 유지)
    const containerWidth = container.clientWidth;   
    const containerHeight = container.clientHeight; 
    const popupWidth = popup.offsetWidth;           
    const popupHeight = popup.offsetHeight;         
    
    // 배율 보정된 사원 카드의 세로 중앙점
    const elementCenterY = scaledTop + (scaledHeight / 2); 

    // 기본 설정값 (화살표는 팝업 상단에서 20px 아래, 팝업은 사원 우측에 배치)
    let arrowTopPosition = 20; 
    const arrowHeight = 6; 
    
    let finalTop = elementCenterY - (arrowTopPosition + arrowHeight);
    let finalLeft = scaledLeft + scaledWidth + 12; // 보정된 사원 우측 배치

    // ↔️ [좌우 경계선 방어]
    if (finalLeft + popupWidth > containerWidth) {
        finalLeft = scaledLeft - popupWidth - 12; // 보정된 사원 좌측 배치
        popup.style.setProperty('--arrow-direction', 'right');
    } else {
        popup.style.setProperty('--arrow-direction', 'left');
    }

    // ↕️ [상하 경계선 방어]
    if (finalTop + popupHeight > containerHeight) {
        const overflowAmt = (finalTop + popupHeight) - containerHeight + 15;
        finalTop = finalTop - overflowAmt;
        arrowTopPosition = arrowTopPosition + overflowAmt;

        if (arrowTopPosition > popupHeight - 20) {
            arrowTopPosition = popupHeight - 20;
        }
    }
    if (finalTop < 15) {
        const underflowAmt = 15 - finalTop;
        finalTop = 15;
        arrowTopPosition = arrowTopPosition - underflowAmt;
        if (arrowTopPosition < 15) arrowTopPosition = 15;
    }

    // 4. 최종 좌표 및 화살표 Y축 변수 적용
    popup.style.left = finalLeft + "px";
    popup.style.top = finalTop + "px";
    popup.style.setProperty('--arrow-top', arrowTopPosition + "px");
}

// 팝업 닫기 함수
function closeDetailCard() {
    const popup = document.getElementById('empDetailCard');
    if (popup) popup.style.display = 'none';
}

function sendMemo(empId) {
	var w = 650; 
	var h = 650; 
	var left = (screen.width/2) - (w/2); 
	var top = (screen.height/2) - (h/2); 
	window.open('/memo/write?memoSenderId=' + empId, 'memoListPopup', 'width='+w+',height='+h+',top='+top+',left='+left+',scrollbars=yes,resizable=no');
}

// 바탕화면(조직도 빈 공간) 클릭 시 자동으로 팝업 닫히게 하기 (선택 사항)
document.addEventListener('click', function(e) {
    const popup = document.getElementById('empDetailCard');
    // 클릭된 곳이 팝업 내부가 아니고 사원 아이템도 아니라면 팝업을 닫음
    if (popup && !popup.contains(e.target) && !e.target.closest('.emp-item')) {
        closeDetailCard();
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