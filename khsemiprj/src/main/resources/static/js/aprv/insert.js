/**
 * 결재 등록 js 파일
 */

var modal;
var form;

$(function () {
	var picker1 = new Lightpick({ 
	    field : $(".picker-sdate")[0] ,
	    format : "YYYY-MM-DD" ,
	});

	var picker2 = new Lightpick({ 
	    field : $(".picker-edate")[0] ,
	    format : "YYYY-MM-DD" ,
	});
	
	//const modal = document.getElementById('modalOverlay');
	modal = document.getElementById('modalOverlay');
	//const form = document.getElementById('popupForm');
	form = document.getElementById('popupForm');
	
	// 배경(어두운 부분) 클릭 시에도 팝업 닫히게 설정
	modal.addEventListener('click', (e) => {
	    if (e.target === modal) {
	        closeModal();
	    }
	});
	
	if (deptList && deptList.length > 0) {
        const listContainer = $('#deptList');
        const rootUl = $(listContainer).find('ul')[0];
        // 📌 여러 개의 루트 노드를 반복문 돌리며 rootUl에 li 형태로 붙여줍니다.
        deptList.forEach(rootNode => {
            rootUl.appendChild(createTree(rootNode));
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
			
			$(".emp-checkbox").prop("checked", false);
    		//부서원 목록 가져오기
    		getEmpPositionDeptList(deptNo);
    	}
    });
	
	$(document).on("click", ".check-emp-all", function () {
    	var checked = $(this).prop("checked");
    	$("#empList input[type=checkbox][name=emp]").prop("checked", checked);
    });
});

// 팝업 열기
function openModal() {
    modal.classList.add('active');
}

// 팝업 닫기
function closeModal() {
    modal.classList.remove('active');
    form.reset(); // 닫을 때 입력값 초기화
	$("#empList").empty();
}

// 입력값 처리 (서버 전송 또는 데이터 추출)
function submitData() {
    const name = document.getElementById('userName').value.trim();
    const email = document.getElementById('userEmail').value.trim();

    // 간단한 유효성 검사
    if(!name || !email) {
        alert("모든 필드를 입력해주세요.");
        return;
    }

    // 1. 만약 순수 JavaScript / Ajax로 처리하고 싶다면?
    document.getElementById('resultView').innerText = `입력된 결과 -> 이름: ${name}, 이메일: ${email}`;
    closeModal();
    
    // 2. 만약 서블릿(Controller)이나 다른 JSP로 form을 전송하고 싶다면?
    // form.action = "registerAction.jsp"; // 전송할 URL
    // form.submit();
}

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