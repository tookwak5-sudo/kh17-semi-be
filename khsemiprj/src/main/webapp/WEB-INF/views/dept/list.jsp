<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"/>
	
	<style>
        /* 기본 스타일 초기화 */
        .dept-tree, .dept-tree ul {
            list-style: none;
            padding-left: 24px;
            font-family: 'Malgun Gothic', sans-serif;
            color: #333;
        }
        .dept-tree > ul {
            padding-left: 0;
        }

        /* 각 부서 항목 스타일 */
        .dept-item {
            margin: 6px 0;
        }
        
        .dept-row {
            display: inline-flex;
            align-items: center;
            padding: 4px 8px;
            border-radius: 4px;
            transition: background-color 0.2s;
        }

        .dept-row:hover {
            background-color: #f0f4f9;
        }

        /* 토글 화살표 */
        .toggle-btn {
            display: inline-block;
            width: 16px;
            font-size: 10px;
            color: #888;
            user-select: none;
            margin-right: 4px;
            cursor: pointer;
            text-align: center;
        }

        /* 체크박스 스타일 커스텀 */
        .dept-checkbox {
            margin-right: 8px;
            width: 16px;
            height: 16px;
            cursor: pointer;
        }

        /* 부서명 */
        .dept-name {
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
        }
        
        /* 하위 부서가 없는 최하단 팀은 화살표를 숨김 처리 */
        .no-children .toggle-btn {
            visibility: hidden;
            cursor: default;
        }

        /* [핵심] 하위 메뉴를 숨기기 위한 클래스 */
        .collapsed > ul {
            display: none;
        }
    </style>
	
	<h1>부서관리</h1>
	<div>
		<a href="/dept/insert" class="btn btn-positive">부서 등록</a>
	</div>
	<div class="dept-tree">
	    <ul>
	        <li class="dept-item">
	            <div class="dept-row">
	                <span class="toggle-btn">▼</span>
	                <input type="checkbox" class="dept-checkbox" id="corp">
	                <label for="corp" class="dept-name">(주) 대박기업</label>
	            </div>
	            
	            <ul>
	                <li class="dept-item">
	                    <div class="dept-row">
	                        <span class="toggle-btn">▼</span>
	                        <input type="checkbox" class="dept-checkbox" id="dev">
	                        <label for="dev" class="dept-name">개발본부</label>
	                    </div>
	                    <ul>
	                        <li class="dept-item no-children">
	                            <div class="dept-row">
	                                <span class="toggle-btn">▶</span>
	                                <input type="checkbox" class="dept-checkbox" id="dev-1">
	                                <label for="dev-1" class="dept-name">플랫폼개발팀</label>
	                            </div>
	                        </li>
	                        <li class="dept-item no-children">
	                            <div class="dept-row">
	                                <span class="toggle-btn">▶</span>
	                                <input type="checkbox" class="dept-checkbox" id="dev-2">
	                                <label for="dev-2" class="dept-name">데이터엔지니어링팀</label>
	                            </div>
	                        </li>
	                    </ul>
	                </li>
	
	                <li class="dept-item">
	                    <div class="dept-row">
	                        <span class="toggle-btn">▼</span>
	                        <input type="checkbox" class="dept-checkbox" id="biz">
	                        <label for="biz" class="dept-name">영업본부</label>
	                    </div>
	                    <ul>
	                        <li class="dept-item no-children">
	                            <div class="dept-row">
	                                <span class="toggle-btn">▶</span>
	                                <input type="checkbox" class="dept-checkbox" id="biz-1">
	                                <label for="biz-1" class="dept-name">국내영업팀</label>
	                            </div>
	                        </li>
	                        <li class="dept-item no-children">
	                            <div class="dept-row">
	                                <span class="toggle-btn">▶</span>
	                                <input type="checkbox" class="dept-checkbox" id="biz-2">
	                                <label for="biz-2" class="dept-name">글로벌마케팅팀</label>
	                            </div>
	                        </li>
	                    </ul>
	                </li>
	            </ul>
	        </li>
	    </ul>
	</div>
	
	<script>
	    document.addEventListener('DOMContentLoaded', () => {
	        // 모든 토글 버튼(화살표)을 가져옵니다.
	        const toggleButtons = document.querySelectorAll('.toggle-btn');
	
	        toggleButtons.forEach(button => {
	            button.addEventListener('click', (e) => {
	                // 클릭한 화살표의 부모인 .dept-item 요소를 찾습니다.
	                const deptItem = e.target.closest('.dept-item');
	                
	                // 하위 메뉴가 없는 말단 부서라면 토글하지 않고 무시합니다.
	                if (deptItem.classList.contains('no-children')) return;
	
	                // .collapsed 클래스를 켜고 끕니다. (CSS에서 display: none 처리됨)
	                deptItem.classList.toggle('collapsed');
	
	                // 클래스 유무에 따라 화살표 모양을 바꿉니다.
	                if (deptItem.classList.contains('collapsed')) {
	                    e.target.textContent = '▶';
	                } else {
	                    e.target.textContent = '▼';
	                }
	            });
	        });
	    });
	</script>
	
<jsp:include page="/WEB-INF/views/template/footer.jsp"/>