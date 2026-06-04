<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
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
        .dept-checkbox, .emp-checkbox {
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
        
        
        .dept-change-list.active {
        	display: block;
        }
        .dept-change-list {
        	display: none;
        }
        .border {
        	box-shadow: 0 0 0 1px #cccccc;
        }
    </style>
	
	
	<!-- 화면에 나오지 않으면서 언제든지 불러서 쓸 수 있는 화면 조각(템플릿) -->
<script type="text/template" id="dept-template">
<li class="dept-item">
	<div class="dept-row">
		<span class="toggle-btn">▼</span>
		<input type="checkbox" name="dept" class="dept-checkbox" id="dept">
		<label for="dept" class="dept-name">부서명</label>
	</div>
	<ul>
	</ul>
</li>
</script>
<script type="text/template" id="emp-template">
<tr>
	<td><input type="checkbox" name="emp" class="emp-checkbox" id="emp"></td>
	<td></td>
	<td></td>
	<td></td>
	<td></td>
</tr>
</script>
<script type="text/template" id="emp-empty-template">
<tr>
	<td colspan="5">검색된 사원이 없습니다</td>
</tr>
</script>
    
    <script>
    
	    function createTree(node) {
	    	
	    	var template = $("#dept-template").text();
            const li = $.parseHTML(template)[1];
            $(li).find(".dept-checkbox").attr("id", "dept1_" + node.deptNo);
            $(li).find(".dept-checkbox").attr("value", node.deptNo);
            $(li).find(".dept-checkbox").attr("data-emp-id", node.deptEmpId);
            $(li).find(".dept-name").text(node.deptName);
            $(li).find("label").attr("for", "dept1_" + node.deptNo);
	        if (node.children && node.children.length > 0) {
	        	const ul = $(li).find("ul")[0];
	            node.children.forEach(child => {
	                ul.appendChild(createTree(child));
	            });
	        }
	        return li;
	    }
	    
		function createTree2(node) {
	    	
	    	var template = $("#dept-template").text();
            const li = $.parseHTML(template)[1];
            $(li).find(".dept-checkbox").attr("id", "dept2_" + node.deptNo);
            $(li).find(".dept-checkbox").attr("value", node.deptNo);
            $(li).find(".dept-name").text(node.deptName);
            $(li).find("label").attr("for", "dept2_" + node.deptNo);
	        if (node.children && node.children.length > 0) {
	        	const ul = $(li).find("ul")[0];
	            node.children.forEach(child => {
	                ul.appendChild(createTree2(child));
	            });
	        }
	        return li;
	    }
	    
	    $(function(){
		    const deptList = JSON.parse('${deptListJson}');
		    if (deptList && deptList.length > 0) {
		        const listContainer = $('#deptList');
		        const rootUl = $(listContainer).find('ul')[0];
		        // 📌 여러 개의 루트 노드를 반복문 돌리며 rootUl에 li 형태로 붙여줍니다.
		        deptList.forEach(rootNode => {
		            rootUl.appendChild(createTree(rootNode));
		        });
		        
		        const listContainer2 = $('#deptList2');
		        const rootUl2 = $(listContainer2).find('ul')[0];
		        // 📌 여러 개의 루트 노드를 반복문 돌리며 rootUl에 li 형태로 붙여줍니다.
		        deptList.forEach(rootNode => {
		            rootUl2.appendChild(createTree2(rootNode));
		        });
		    }
		    
		    //화살표 이벤트 추가
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
		    
		    $(document).on("click", "#deptList input[type=checkbox][name=dept]", function () {
		    	if($(this).prop("checked")) {
		    		$("#deptList input[type=checkbox][name=dept]").prop("checked", false);
		    		$(this).prop("checked", true);
		    		var deptNo = $(this).val();
		    		//변경할 부서 목록 숨기기
		    		resetDeptList2();
					//부서장변경 버튼 보여주기 여부
					if($(this).val() != "") {
						$(".dept-emp-change").show();
						$(".dept-emp-demotion").show();
					}
					
		    		//부서원 목록 가져오기
		    		getEmpPositionDeptList(deptNo);
		    		//기존 선택된 비활성화 해제
		    		$("#deptList2 input[type=checkbox][name=dept]").prop("disabled", false);
		    		//이동할 부서에서 내 부서 비활성화 시키기
		    		$("#deptList2 input[type=checkbox][name=dept][value='" + deptNo + "']").prop("disabled", true);
		    	}
		    });
		    
		    $(document).on("click", "#deptList2 input[type=checkbox][name=dept]", function () {
		    	if($(this).prop("checked")) {
		    		$("#deptList2 input[type=checkbox][name=dept]").prop("checked", false);
		    		$(this).prop("checked", true);
		    	}
		    });
		    
		    $(document).on("click", "input[type=checkbox][name=emp]", function () {
		    	if($(this).prop("checked")) {
		    		//변경할 부서 목록 보이기
		    		$(".dept-change-list").addClass("active");
		    	}
		    });
		    
		    $(document).on("click", ".check-emp-all", function () {
		    	var checked = $(this).prop("checked");
		    	$("#empList input[type=checkbox][name=emp]").prop("checked", checked);
		    });
		    
		    function resetDeptList2() {
		    	$(".dept-change-list").removeClass("active");
				$(".dept-emp-change").hide();
				$(".dept-emp-demotion").hide();	
				$(".emp-checkbox").prop("checked", false);
		    	$("#deptList2 input[type=checkbox][name=dept]").prop("checked", false);
		    }
		    
		    function getEmpPositionDeptList(deptNo) {
				if(deptNo == "") deptNo = null;
		    	$.ajax({
	                url : "/rest/dept/empPositionDeptList",
	                method:"post",
	                data: { deptNo : deptNo },
	                success : function(response) {
	                	$("#empList").empty();
	                	if(response.length > 0) {
		                	var deptList = response;
		                	for(var i = 0; i < deptList.length; i++) {
			                	var empId = deptList[i].empId;
			                	var deptName = deptList[i].deptName;
			                	var empName = deptList[i].empName;
			                	var empPositionName = deptList[i].empPositionName;
			                	var deptEmpId = deptList[i].deptEmpId;
			                	
			                	var template = $("#emp-template").text();
			                	const tr = $.parseHTML(template)[1];
			                	$(tr).find(".emp-checkbox").attr("value", empId);
			                	$(tr).find("td:eq(1)").text(deptName);
			                	$(tr).find("td:eq(2)").text(empId);
			                	if(empId == deptEmpId) {
			                		$(tr).find("td:eq(3)").html("<i class=\"fa-solid fa-crown gold\"></i> " + empName);
			                	} else {
			                		$(tr).find("td:eq(3)").html(empName);
			                	}
			                	$(tr).find("td:eq(4)").text(empPositionName);
			                	$("#empList").append(tr);
		                	}
	                	} else {
	                		var template = $("#emp-empty-template").text();
	                		const tr = $.parseHTML(template)[1];
	                		$("#empList").append(tr);
	                	}
	                }
	            });
		    }
		    
		    $(".dept-change").click(function () {
		    	var empIdList = $("#empList input[type=checkbox]:checked").map(function () {
		    		return $(this).val();
		    	}).get();
		    	var fromDeptNo = $("#deptList input[type=checkbox]:checked").val();
		    	var deptNo = $("#deptList2 input[type=checkbox]:checked").val();
		    	
		    	if(deptNo == undefined) {
		    		alert("이동할 부서를 선택하세요");
		    		return false;
		    	}
		    	
		    	if(confirm("선택한 사원들의 부서를 변경하시겠습니까?")) {
		    		$.ajax({
		                url : "/rest/dept/empPositionDeptUpdate",
		                method:"post",
		                data: { 
		                	empIdList : empIdList
							, fromDeptNo : fromDeptNo
		                	, toDeptNo : deptNo 
		                	},
		                success : function(response) {
		                	if(response) {
		                		//부서원 목록 다시 가져오기
		                		getEmpPositionDeptList(fromDeptNo);
		                	} else {
		                		alert("부서 변경 중 오류가 발생했습니다.");
		                	}
		                }
		            });
		    	}
		    });
			
			$(".dept-emp-change").click(function () {
				if($("#empList input[type=checkbox]:checked").length == 0) {
					alert("부서원을 선택해주세요");
					return false;
				}
				if($("#empList input[type=checkbox]:checked").length > 1) {
					alert("부서장으로 지정할 부서원은 한명만 선택해주세요");
					return false;
				}
				var deptNo = $("#deptList input[type=checkbox]:checked").val();
				var empId = $("#empList input[type=checkbox]:checked").val();
				
				if(confirm("선택한 사원을 부서장으로 변경하시겠습니까?")) {
		    		$.ajax({
		                url : "/rest/dept/deptEmpIdUpdate",
		                method:"post",
		                data: { 
		                	empId : empId
							, deptNo : deptNo
		                	},
		                success : function(response) {
		                	if(response) {
		                		//부서원 목록 다시 가져오기
		                		getEmpPositionDeptList(deptNo);
		                	} else {
		                		alert("부서장 변경 중 오류가 발생했습니다.");
		                	}
		                }
		            });
		    	}
			});
			
			$(".dept-emp-demotion").click(function () {
				var deptNo = $("#deptList input[type=checkbox]:checked").val();
				
				if(confirm("해당 부서의 부서장을 해제하시겠습니까?")) {
		    		$.ajax({
		                url : "/rest/dept/deptEmpIdDemotion",
		                method:"post",
		                data: { 
		                	deptNo : deptNo
		                	},
		                success : function(response) {
		                	if(response) {
		                		//부서원 목록 다시 가져오기
		                		getEmpPositionDeptList(deptNo);
		                	} else {
		                		alert("부서장 해제 중 오류가 발생했습니다.");
		                	}
		                }
		            });
		    	}
			});
	    });
    
    </script>
	
	
	<div class="cell flex-area">
		<h1>부서관리</h1>
	</div>
	<div class="cell flex-area">
		<div class="cell w-25">
			<div class="cell">
				<span>부서 목록</span>
				<a href="/dept/insert" class="btn btn-positive">부서 등록</a>
			</div>
			<div id="deptList" class="dept-tree border">
				<ul>
					<li class="dept-item">
						<div class="dept-row">
							<span class="toggle-btn">▼</span>
							<input type="checkbox" name="dept" class="dept-checkbox" id="dept1_" value="">
							<label for="dept1_" class="dept-name">부서없음</label>
						</div>
					</li>
				</ul>
			</div>
		</div>
		<div class="cell w-50 ms-10 me-10">
			<div class="cell">
				<div class="cell">
					<span>부서별 사원 목록</span>
					<a class="btn btn-positive dept-emp-change" style="display:none;">부서장 변경</a>
					<a class="btn btn-positive dept-emp-demotion" style="display:none;">부서장 해제</a>
				</div>
			</div>
			<!-- 테이블 -->
			<div class="cell center" style="width:580px;">
				<table class="table">
					<thead>
						<tr>
							<th><input type="checkbox" name="emp" class="emp-checkbox check-emp-all"></th>
							<th>부서</th>
							<th>사원아이디</th>
							<th>이름</th>
							<th>직급</th>
						</tr>
					</thead>
					<tbody id="empList">
					</tbody>
				</table>
			</div>
		</div>
		<div class="cell w-25 dept-change-list">
			<div class="cell">
				<span>이동할 부서 목록</span>
				<a class="btn btn-positive dept-change">변경</a>
			</div>
			<div id="deptList2" class="dept-tree border">
				<ul>
					<li class="dept-item">
						<div class="dept-row">
							<span class="toggle-btn">▼</span>
							<input type="checkbox" name="dept" class="dept-checkbox" id="dept2_" value="">
							<label for="dept2_" class="dept-name">부서없음</label>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>
	
<jsp:include page="/WEB-INF/views/template/footer.jsp"/>