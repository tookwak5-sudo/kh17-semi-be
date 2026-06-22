/**
 * 
 */

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
    } else {
		$(li).find(".toggle-btn").text("");
		$(li).addClass("no-children");
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
    } else {
		$(li).find(".toggle-btn").text("");
		$(li).addClass("no-children");
	}
    return li;
}
    
$(function(){
    //const deptList = JSON.parse('${deptListJson}');
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
    
    $(".dept-change").click(function () {
    	var empIdList = $("#empList input[type=checkbox]:checked").map(function () {
    		return $(this).val();
    	}).get();
    	var fromDeptNo = $("#deptList input[type=checkbox]:checked").val();
    	var deptNo = $("#deptList2 input[type=checkbox]:checked").val();
    	
    	if(deptNo == undefined) {
			openAlert("이동할 부서를 선택하세요");
    		return false;
    	}
    	
		openConfirm("선택한 사원들의 부서를 변경하시겠습니까?", "empPositionDeptUpdate('" + fromDeptNo + "', '" + deptNo + "');")
    	/*if(confirm("선택한 사원들의 부서를 변경하시겠습니까?")) {
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
                		openAlert("부서 변경 중 오류가 발생했습니다.");
                	}
                }
            });
    	}*/
    });
	
	$(".dept-emp-change").click(function () {
		if($("#empList input[type=checkbox]:checked").length == 0) {
			openAlert("부서원을 선택해주세요");
			return false;
		}
		if($("#empList input[type=checkbox]:checked").length > 1) {
			openAlert("부서장으로 지정할 부서원은 한명만 선택해주세요");
			return false;
		}
		var deptNo = $("#deptList input[type=checkbox]:checked").val();
		var empId = $("#empList input[type=checkbox]:checked").val();
		
		openConfirm("선택한 사원을 부서장으로 변경하시겠습니까?", "deptEmpIdUpdate('" + empId + "', " + deptNo + ");")
		/*if(confirm("선택한 사원을 부서장으로 변경하시겠습니까?")) {
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
						openAlert("부서장 변경 중 오류가 발생했습니다")
                	}
                }
            });
    	}*/
	});
	
	$(".dept-emp-demotion").click(function () {
		var deptNo = $("#deptList input[type=checkbox]:checked").val();
		
		openConfirm("해당 부서의 부서장을 해제하시겠습니까?", "deptEmpIdDemotion(" + deptNo + ");");
		/*if(confirm("해당 부서의 부서장을 해제하시겠습니까?")) {
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
                		openAlert("부서장 해제 중 오류가 발생했습니다.");
                	}
                }
            });
    	}*/
	});
});

// 부서 체크박스 클릭 이벤트 발생 시 호출될 함수 (예시)
document.addEventListener('change', function(e) {
    if (e.target.classList.contains('dept-checkbox') && e.target.closest('#deptList')) {
        
        // 1. 왼쪽에서 체크된 부서들의 ID를 모두 가져옴
        const checkedDepts = Array.from(document.querySelectorAll('#deptList .dept-checkbox:checked'))
                                  .map(cb => cb.id); // 혹은 value 값 등 부서 식별자

        // 2. 오른쪽 목록(#deptList2)의 모든 체크박스를 초기화 (다시 선명하게)
        document.querySelectorAll('#deptList2 .dept-checkbox').forEach(cb => {
            cb.disabled = false;
            cb.parentElement.style.opacity = "1";
            cb.parentElement.style.cursor = "pointer";
        });

        // 3. 왼쪽에서 체크된 부서와 동일한 ID를 가진 오른쪽 체크박스를 찾아 흐릿하게 처리
        checkedDepts.forEach(id => {
            // id가 dept1_123 이라면 dept2_123 처럼 매칭되는 규칙이 필요함
            const targetId = id.replace('dept1_', 'dept2_'); 
            const targetCb = document.getElementById(targetId);
            
            if (targetCb) {
                targetCb.disabled = true; // 클릭 불가
                targetCb.parentElement.style.opacity = "0.3"; // 흐릿하게
                targetCb.parentElement.style.cursor = "not-allowed";
            }
        });
    }
});

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
					$(tr).find(".emp-checkbox").attr("id", "emp_" + empId);
					$(tr).find("label").attr("for", "emp_" + empId);
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

function deptEdit() {
	var deptNo = $("#deptList input[type=checkbox]:checked").val();
	if(deptNo == undefined) {
		openAlert('수정할 부서를 선택하세요');
		return false;
	}
	if(deptNo == '') {
		openAlert('[부서없음]은 수정할 수 없습니다');
		return false;
	} else {
		location.href = "./edit?deptNo=" + deptNo;
	}
}

function deptDelete() {
	var deptNo = $("#deptList input[type=checkbox]:checked").val();
	var deptName = $("#deptList input[type=checkbox]:checked").next().text();
	if(deptNo == undefined) {
		openAlert('삭제할 부서를 선택하세요');
		return false;
	}
	if(deptNo == '') {
		openAlert('[부서없음]은 삭제할 수 없습니다.');
		return false;
	} else {
		openConfirm("[" + deptName + "] 부서를 삭제하시겠습니까?", "location.href='./delete?deptNo=" + deptNo + "';");
	}
}

function deptEmpIdUpdate(empId, deptNo) {
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
				openAlert("부서장 변경 중 오류가 발생했습니다")
        	}
        }
    });
}

function deptEmpIdDemotion(deptNo) {
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
        		openAlert("부서장 해제 중 오류가 발생했습니다.");
        	}
        }
    });
}

function empPositionDeptUpdate(fromDeptNo, toDeptNo) {
	var empIdList = $("#empList input[type=checkbox]:checked").map(function () {
		return $(this).val();
	}).get();
	$.ajax({
        url : "/rest/dept/empPositionDeptUpdate",
        method:"post",
        data: { 
        	empIdList : empIdList
			, fromDeptNo : fromDeptNo
        	, toDeptNo : toDeptNo 
        	},
        success : function(response) {
        	if(response) {
        		//부서원 목록 다시 가져오기
        		getEmpPositionDeptList(fromDeptNo);
        	} else {
        		openAlert("부서 변경 중 오류가 발생했습니다.");
        	}
        }
    });
}