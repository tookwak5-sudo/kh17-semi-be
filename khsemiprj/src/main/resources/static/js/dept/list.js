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