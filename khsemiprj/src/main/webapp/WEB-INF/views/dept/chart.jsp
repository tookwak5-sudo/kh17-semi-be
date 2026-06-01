<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"/>
	<h1>조직도</h1>
	
	<style>
        body {
            font-family: 'Malgun Gothic', dotum, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        h2 { color: #333; margin-bottom: 30px; }

        .dept-chart-container {
            display: flex;
            justify-content: center;
            overflow-x: auto;
            width: 100%;
            padding: 20px 0;
        }

        /* 트리 구조 기본 CSS */
        .tree, .tree ul, .tree li {
            list-style: none;
            margin: 0;
            padding: 0;
            position: relative;
        }

        .tree { display: flex; justify-content: center; }
        .tree ul { display: flex; justify-content: center; margin-top: 25px; }
        .tree li { text-align: center; position: relative; padding: 25px 10px 0 10px; }

        /* 연결선 스타일 */
        .tree li::before, .tree li::after {
            content: ''; position: absolute; top: 0; right: 50%;
            border-top: 2px solid #b2bec3; width: 50%; height: 25px;
        }
        .tree li::after { right: auto; left: 50%; border-left: 2px solid #b2bec3; }
        .tree li:only-child::after, .tree li:only-child::before { display: none; }
        .tree li:only-child { padding-top: 0; }
        .tree li:first-child::before, .tree li:last-child::after { border: 0 none; }
        .tree li:last-child::before { border-right: 2px solid #b2bec3; border-radius: 0 5px 0 0; }
        .tree li:first-child::after { border-radius: 5px 0 0 0; }
        .tree ul ul::before {
            content: ''; position: absolute; top: -25px; left: 50%;
            border-left: 2px solid #b2bec3; width: 0; height: 25px;
        }

        /* 🏢 부서 박스 스타일 */
        .dept-card {
            border: 1px solid #ced4da;
            border-radius: 8px;
            background-color: #ffffff;
            box-shadow: 0 4px 10px rgba(0,0,0,0.06);
            display: inline-block;
            min-width: 180px;
            overflow: hidden;
            text-align: left;
            transition: transform 0.2s;
        }
        
        .dept-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
        }

        /* 부서 헤더 (이름 부분) */
        .dept-header {
            background-color: #4a90e2;
            color: white;
            padding: 10px 14px;
            font-size: 14px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        /* 최상위노드(대표이사 등)인 경우 헤더 색상 다르게 */
        .dept-card.root-node .dept-header {
            background-color: #2c3e50;
        }

        /* 👥 부서원 목록 컨테이너 */
        .member-list {
            background-color: #fff;
            padding: 6px 0;
        }

        /* 👤 개별 부서원 아이템 */
        .member-item {
            padding: 8px 14px;
            border-bottom: 1px dashed #edf2f7;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
            cursor: pointer;
            transition: background 0.2s;
        }

        .member-item:last-child { border-bottom: none; }
        .member-item:hover { background-color: #f1f7fe; }

        .member-name { font-weight: bold; color: #333; }
        .member-title { font-size: 11px; color: #888; background: #e9ecef; padding: 2px 6px; border-radius: 4px; }
        
        /* 부서원이 없을 때 표시 */
        .empty-member {
            padding: 10px; font-size: 12px; color: #b2bec3; text-align: center; font-style: italic;
        }
    </style>

    <div class="dept-chart-container">
        <div class="tree" id="deptChart">
            <!-- JavaScript로 트리 구조가 생성됩니다. -->
        </div>
    </div>

<script>
    // 1. 변경된 데이터 구조: 부서 정보와 그 부서에 속한 멤버 리스트(members)를 분리
    const deptChartList = JSON.parse('${deptChartJson}');
    /* const deptChartList = {
        deptName: "경영진",
        isRoot: true, // 최상위 표시용 플래그
        members: [
            { name: "홍길동", title: "대표이사" }
        ],
        children: [
            {
                deptName: "영업본부",
                members: [
                    { name: "김철수", title: "본부장/이사" },
                    { name: "이영희", title: "팀장/과장" },
                    { name: "박민수", title: "사원" }
                ],
                children: [
                    {
                        deptName: "영업마케팅파트",
                        members: [
                            { name: "최다은", title: "대리" },
                            { name: "정홍보", title: "사원" }
                        ],
                        children: [] // 하위 파트가 더 있다면 여기에 추가 가능
                    }
                ]
            },
            {
                deptName: "개발본부",
                members: [
                    { name: "강기술", title: "연구소장/CTO" }
                ],
                children: [
                    {
                        deptName: "플랫폼개발팀",
                        members: [
                            { name: "정차장", title: "팀장/차장" },
                            { name: "한지원", title: "대리" },
                            { name: "조코딩", title: "사원" }
                        ]
                    },
                    {
                        deptName: "인프라보안팀",
                        members: [
                            { name: "김보안", title: "팀장/과장" },
                            { name: "이네트", title: "사원" }
                        ]
                    }
                ]
            }
        ]
    }; */

    // 2. 부서 박스와 내부에 사원 리스트를 포함하여 트리를 그리는 재귀 함수
    function createTree(node) {
		const li = document.createElement('li');
        
        const deptCard = document.createElement('div');
        deptCard.className = `dept-card \${node.deptDepth == 0 ? 'root-node' : ''}`;
        
        const memberCount = node.members ? node.members.length : 0;
        deptCard.innerHTML = `
            <div class="dept-header">
                <span>\${node.deptName}</span>
                <span style="font-size:11px; opacity:0.8;">(\${memberCount}명)</span>
            </div>
        `;

        const memberListDiv = document.createElement('div');
        memberListDiv.className = 'member-list';

        if (node.members && node.members.length > 0) {
            node.members.forEach(member => {
                const item = document.createElement('div');
                item.className = 'member-item';
                item.innerHTML = `
                    <span class="member-name">\${member.name}</span>
                    <span class="member-title">\${member.title}</span>
                `;
                memberListDiv.appendChild(item);
            });
        } else {
            memberListDiv.innerHTML = `<div class="empty-member">배치 사원 없음</div>`;
        }
        deptCard.appendChild(memberListDiv);
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
    /* const chartContainer = document.getElementById('deptChart');
    const rootUl = document.createElement('ul');
    rootUl.appendChild(createTree(deptData));
    chartContainer.appendChild(rootUl); */
    
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
    
</script>
	
<jsp:include page="/WEB-INF/views/template/footer.jsp"/>