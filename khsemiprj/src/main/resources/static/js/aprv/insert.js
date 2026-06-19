/**
 * 결재 등록 js 파일
 */

var modal1;
var model2;
var form1;
var form2;

$(function () {
	
	$(document).on("input", ".aprv-form-list", function () {
		var formNo = $(this).val();
		if(formNo != "") {
			getAprmFormAttach(formNo);
		}
	});
	
	//const modal = document.getElementById('modalOverlay');
	modal1 = document.getElementById('modalOverlay1');
	modal2 = document.getElementById('modalOverlay2');
	//const form = document.getElementById('popupForm');
	form1 = document.getElementById('popupForm1');
	form2 = document.getElementById('popupForm2');
	
	// 배경(어두운 부분) 클릭 시에도 팝업 닫히게 설정
	modal1.addEventListener('click', (e) => {
	    if (e.target === modal1) {
	        closeModal('1');
	    }
	});
	
	modal2.addEventListener('click', (e) => {
		    if (e.target === modal2) {
		        closeModal('2');
		    }
		});
	
	if (deptList && deptList.length > 0) {
        const listContainer = $('#deptList1');
        const rootUl = $(listContainer).find('ul')[0];
        // 📌 여러 개의 루트 노드를 반복문 돌리며 rootUl에 li 형태로 붙여줍니다.
        deptList.forEach(rootNode => {
            rootUl.appendChild(createTree(rootNode, '1'));
        });
		
		const listContainer2 = $('#deptList2');
        const rootUl2 = $(listContainer2).find('ul')[0];
        // 📌 여러 개의 루트 노드를 반복문 돌리며 rootUl에 li 형태로 붙여줍니다.
        deptList.forEach(rootNode => {
            rootUl2.appendChild(createTree(rootNode, '2'));
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
	
	$(document).on("click", "[name=vacationType]", function () {
		if($("[name=vacationType]:checked").val() == "반차") {
			$("[name=aprvLeave]").val(0.5);
		} else {
			$("[name=aprvLeave]").val(1);
		}
	});
	
	$(document).on("click", "[name=aprvCostType]", function () {
		if($("[name=aprvCostType]:checked").val() == "개인") {
			$('#divAprvCostTypePersonal').show();
			state.aprvCostReceiverValid = false;
        	state.aprvCostReceiveAccountValid = false;
		} else {
			$('#divAprvCostTypePersonal').hide();
			$('#aprvCostReceiver').val('');
			$('#aprvCostReceiveAccount').val('');
			state.aprvCostReceiverValid = true;
			state.aprvCostReceiveAccountValid = true;
		}
	});
	
	$(document).on("click", "#deptList1 input[type=checkbox][name=dept]", function () {
    	if($(this).prop("checked")) {
    		$("#deptList1 input[type=checkbox][name=dept]").prop("checked", false);
    		$(this).prop("checked", true);
    		var deptNo = $(this).val();
			
			$("#popupForm1 .emp-checkbox").prop("checked", false);
    		//부서원 목록 가져오기
    		getEmpPositionDeptList(deptNo, '1');
    	}
    });
	
	$(document).on("click", "#deptList2 input[type=checkbox][name=dept]", function () {
    	if($(this).prop("checked")) {
    		$("#deptList2 input[type=checkbox][name=dept]").prop("checked", false);
    		$(this).prop("checked", true);
    		var deptNo = $(this).val();
			
			$("#popupForm2 .emp-checkbox").prop("checked", false);
    		//부서원 목록 가져오기
    		getEmpPositionDeptList(deptNo, '2');
    	}
    });
	
	$(document).on("click", ".check-emp-all-1", function () {
    	var checked = $(this).prop("checked");
    	$("#empList1 input[type=checkbox][name=emp][disabled!=disabled]").prop("checked", checked);
    });
	
	$(document).on("click", "#empList1 input[type=checkbox][name=emp]", function () {
		var checked = $(this).prop("checked");
		if(checked) {
			
		}
	});
	
	//첨부 파일 변경 시
	$(document).on("change", ".attach-input", function (e) {
		$(".aprv-form-file-down").empty();
		// 선택된 파일 정보 가져오기
	    const file = e.target.files[0];
	    // 만약 파일을 선택했다가 취소해서 파일이 없는 경우 함수 종료
	    if (!file) return;
		var fileTemplate = $("#aprv-form-file-template").text();
		const a = $.parseHTML(fileTemplate)[1];
		var fileName = file.name;
		$(a).find("span").text(fileName);
		var deleteTemplate = $("#aprv-form-file-delete-template").text();
		const button = $.parseHTML(deleteTemplate)[1];
		
		$('.aprv-form-file-down').append(a);
		$('.aprv-form-file-down').append(button);
	});
	
	$(document).on("click", ".check-emp-all-2", function () {
    	var checked = $(this).prop("checked");
    	$("#empList2 input[type=checkbox][name=emp][disabled!=disabled]").prop("checked", checked);
    });
	
	$(document).on("click", ".line-delete", function () {
		$(this).closest("tr").remove();
	});
 
  	//금액 입력창 처리
    $("[name=aprvCost]").on("input", function(){
    	var $this = $(this);
        var originValue = $this.val();
        
        // 1. 현재 커서의 위치를 저장
        var selectionStart = this.selectionStart;
        
        // 2. 커서 앞쪽에 있던 콤마(,)의 개수를 세어둡니다. (커서 위치 계산용)
        var commaCountBefore = (originValue.substring(0, selectionStart).match(/,/g) || []).length;
        
        // 3. 숫자 외의 문자 제거 및 포맷팅
        var replaceValue = originValue.replace(/[^0-9]/g, "");
        var formattedValue = replaceValue.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        
        // 4. 값을 인풋에 반영
        $this.val(formattedValue);
        
        // 5. 값이 바뀐 후, 커서 앞쪽에 새로 생긴 콤마(,)의 개수를 쎕니다.
        var commaCountAfter = (formattedValue.substring(0, selectionStart).match(/,/g) || []).length;
        
        // 6. 늘어나거나 줄어든 콤마 개수만큼 커서 위치를 보정합니다.
        var newCursorPosition = selectionStart + (commaCountAfter - commaCountBefore);
        
        // 7. 커서 위치를 강제로 세팅합니다.
        this.setSelectionRange(newCursorPosition, newCursorPosition);
        
     	// --- [추가된 로직] 실시간 한글 변환 결과 보여주기 ---
        var koreanText = numberToKorean(replaceValue);
        
        // 예: input 바로 다음(next)에 있는 .korean-view 클래스에 글자를 넣어줌
        $(this).next(".korean-view").text(koreanText);
    });
  	
 	// 1. 숫자를 한글로 변환하는 함수
    function numberToKorean(number) {
    	if (!number || isNaN(number)) return "";
        
        var inputNumber = number.replace(/,/g, ""); // 콤마 제거
        if (parseInt(inputNumber) === 0) return "영원";
        
        var numUnit = ["", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"];
        var danUnit = ["", "십", "백", "천"];
        var manUnit = ["", "만 ", "억 ", "조 ", "경 "]; // 뒤에 공백을 살짝 주면 보기 좋습니다
        
        var koreanResult = "";
        var len = inputNumber.length;
        var currentBlockHasValue = false; // 현재 4자리 블록에 숫자가 존재하는지 체크
        
        for (var i = 0; i < len; i++) {
            var num = inputNumber.charAt(i);
            var unitIdx = len - 1 - i; // 역순 인덱스
            
            // 해당 자리에 숫자가 있으면 (0이 아니면)
            if (num !== "0") {
                currentBlockHasValue = true; // 이 블록은 숫자가 존재함!
                
                var numStr = numUnit[num];
                // '일십' 대신 '십'으로 표현 (단, 만/억/조 등의 자리가 아닌 경우에만)
                if (numStr === "일" && (unitIdx % 4) !== 0) {
                    numStr = ""; 
                }
                koreanResult += numStr + danUnit[unitIdx % 4];
            }
            
            // 4자리마다 (만, 억, 조, 경) 단위를 붙이는 시점
            if (unitIdx % 4 === 0) {
                // 현재 4자리 블록에 숫자가 하나라도 입력되었거나, 
                // 혹은 최초 '억', '조' 단위 위쪽에서 내려온 숫자가 있다면 단위를 붙여줍니다.
                if (currentBlockHasValue) {
                    koreanResult += manUnit[Math.floor(unitIdx / 4)];
                }
                // 다음 4자리 블록을 위해 체크 변수 초기화
                currentBlockHasValue = false; 
            }
        }
        
        // 마지막에 '원'을 붙여주고, 공백 정리
        return koreanResult.trim() + "원";
    }
 	
 	//계좌번호 입력처리
    $("[name=aprvCostReceiveAccount]").on("input", function(e){
    	let value = e.target.value;

	    // 1. 숫자와 하이픈이 아닌 문자(한글 자음 포함) 제거
	    value = value.replace(/[^0-9-]/g, '');

	    // 2. 하이픈 연속 입력 방지
	    value = value.replace(/-{2,}/g, '-');

	    e.target.value = value;
    });
});

// 팝업 열기
function openModal(no) {
	switch(no) {
		case '1':
			modal1.classList.add('active');
			break;
		case '2':
			modal2.classList.add('active');
			break;
	}
}

// 팝업 닫기
function closeModal(no) {
	switch(no) {
		case '1':
		    modal1.classList.remove('active');
		    form1.reset(); // 닫을 때 입력값 초기화
			$("#empList1").empty();
			break;
		case '2':
		    modal2.classList.remove('active');
		    form2.reset(); // 닫을 때 입력값 초기화
			$("#empList2").empty();
			break;
	}
}

// 입력값 처리 (서버 전송 또는 데이터 추출)
function addEmp(no) {
	if(no == '1') {
		$("#empList1 input[type=checkbox]:checked").each(function () {
			var template = $("#line-template").text();
			const tr = $.parseHTML(template)[1];
			$(tr).attr("data-id", $(this).val());//아이디
			var empId = $(this).val();
			$(tr).find("input[type=hidden]").attr("name", "aprvLine1IdList");
			$(tr).find("input[type=hidden]").val(empId);
			var deptName = $(this).closest("tr").find("td:eq(1)").text();
			$(tr).find("td:eq(0)").text(deptName);//부서
			var empName = $(this).closest('tr').find("td:eq(3)").text().trim();
			$(tr).find("td:eq(1)").text(empName);//이름
			var positionName = $(this).closest("tr").find("td:eq(4)").text();
			$(tr).find("td:eq(2)").text(positionName);//직책
			$("#line1List").append(tr);	
		});
	} else if (no == '2') {
		$("#empList2 input[type=checkbox]:checked").each(function () {
			var template = $("#line-template").text();
			const tr = $.parseHTML(template)[1];
			$(tr).attr("data-id", $(this).val());//아이디
			var empId = $(this).val();
			$(tr).find("input[type=hidden]").attr("name", "aprvLine2IdList");
			$(tr).find("input[type=hidden]").val(empId);
			var deptName = $(this).closest("tr").find("td:eq(1)").text();
			$(tr).find("td:eq(0)").text(deptName);//부서
			var empName = $(this).closest('tr').find("td:eq(3)").text().trim();
			$(tr).find("td:eq(1)").text(empName);//이름
			var positionName = $(this).closest("tr").find("td:eq(4)").text();
			$(tr).find("td:eq(2)").text(positionName);//직책
			$("#line2List").append(tr);	
		});
	}
	
    closeModal(no);
}

function createTree(node, no) {
	    	
	var template = $("#dept-template").text();
    const li = $.parseHTML(template)[1];
	if(no == '1') {
	    $(li).find(".dept-checkbox").attr("id", "dept1_" + node.deptNo);
	    $(li).find(".dept-checkbox").attr("value", node.deptNo);
	    $(li).find(".dept-checkbox").attr("data-emp-id", node.deptEmpId);
	    $(li).find(".dept-name").text(node.deptName);
	    $(li).find("label").attr("for", "dept1_" + node.deptNo);
	    if (node.children && node.children.length > 0) {
	    	const ul = $(li).find("ul")[0];
	        node.children.forEach(child => {
	            ul.appendChild(createTree(child, no));
	        });
	    } else {
			$(li).find(".toggle-btn").text("");
			$(li).addClass("no-children");
		}
	} else if(no == '2') {
		$(li).find(".dept-checkbox").attr("id", "dept2_" + node.deptNo);
	    $(li).find(".dept-checkbox").attr("value", node.deptNo);
	    $(li).find(".dept-checkbox").attr("data-emp-id", node.deptEmpId);
	    $(li).find(".dept-name").text(node.deptName);
	    $(li).find("label").attr("for", "dept2_" + node.deptNo);
	    if (node.children && node.children.length > 0) {
	    	const ul = $(li).find("ul")[0];
	        node.children.forEach(child => {
	            ul.appendChild(createTree(child, no));
	        });
	    } else {
			$(li).find(".toggle-btn").text("");
			$(li).addClass("no-children");
		}
	}
    return li;
}

function getAprmFormAttach(formNo) {
	var title = $(".aprv-form-list option:selected").attr("data-name");
	$(".h1-title").text(title);
	$.ajax({
		url : "/rest/aprv/getAprvFormFile",
		method: "post",
		data: { formNo : formNo },
		success : function(response) {
			$(".aprv-form-file").empty();
			
			var attachNo = response.attachNo;
			var attachName = response.attachName;
			var result = response.result;
			
			if(result == "success") {
				var template = $("#aprv-form-file-template").text();
				const a = $.parseHTML(template)[1];
				$(a).find("span").text(attachName);
				$(a).attr("href", "/download/legacy?attachNo=" + attachNo);
				$(".aprv-form-file").append(a);
			} else if(result == "empty") {
				var template = $("#aprv-form-file-empty-template").text();
				const a = $.parseHTML(template)[1];
				$(".aprv-form-file").append(a);
			} else if(result == "error") {
				var template = $("#aprv-form-file-empty-template").text();
				const a = $.parseHTML(template)[1];
				$(a).find("span").text("파일을 찾을 수 없습니다.");
				$(".aprv-form-file").append(a);
			}
		}
	});
}

function getEmpPositionDeptList(deptNo, No) {
	if(deptNo == "") deptNo = null;
	$.ajax({
        url : "/rest/dept/empPositionDeptListForAprv",
        method:"post",
        data: { deptNo : deptNo },
        success : function(response) {
			var lineIdList = $(".lineList tr").map(function () {
	    		return $(this).attr("data-id");
	    	}).get();
			if(No == '1') {
	        	$("#empList1").empty();
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
						if(lineIdList.includes(empId)) {
							$(tr).find(".emp-checkbox").attr("disabled", true);
						}
	                	$(tr).find("td:eq(1)").text(deptName);
	                	$(tr).find("td:eq(2)").text(empId);
	                	if(empId == deptEmpId) {
	                		$(tr).find("td:eq(3)").html("<i class=\"fa-solid fa-crown gold\"></i> " + empName);
	                	} else {
	                		$(tr).find("td:eq(3)").html(empName);
	                	}
	                	$(tr).find("td:eq(4)").text(empPositionName);
	                	$("#empList1").append(tr);
	            	}
	        	} else {
	        		var template = $("#emp-empty-template").text();
	        		const tr = $.parseHTML(template)[1];
	        		$("#empList1").append(tr);
	        	}
			} else if(No == '2') {
				$("#empList2").empty();
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
						if(lineIdList.includes(empId)) {
							$(tr).find(".emp-checkbox").attr("disabled", true);
						}
	                	$(tr).find("td:eq(1)").text(deptName);
	                	$(tr).find("td:eq(2)").text(empId);
	                	if(empId == deptEmpId) {
	                		$(tr).find("td:eq(3)").html("<i class=\"fa-solid fa-crown gold\"></i> " + empName);
	                	} else {
	                		$(tr).find("td:eq(3)").html(empName);
	                	}
	                	$(tr).find("td:eq(4)").text(empPositionName);
	                	$("#empList2").append(tr);
	            	}
	        	} else {
	        		var template = $("#emp-empty-template").text();
	        		const tr = $.parseHTML(template)[1];
	        		$("#empList2").append(tr);
	        	}
			}
        }
    });
}

function removeFile(button) {
    if (confirm("이 첨부파일을 삭제하시겠습니까?")) {
        const fileDiv = button.closest('.aprv-form-file-down');
        if (fileDiv) {
            $(fileDiv).empty();
			$('input[name=attach]').val('');
			$('input[name=deleteFileNo').val($(button).attr("data-no"));
        }
    }
}

// 평일(주말 제외) 일수 계산 함수 (호이스팅을 위해 상단 정의 또는 바깥 배치)
function getWeekdaysCount(startDate, endDate) {
	let count = 0;
	let current = startDate.clone(); 
	
	while (current.isSameOrBefore(endDate, 'day')) {
		let dayOfWeek = current.day(); 
		if (dayOfWeek !== 0 && dayOfWeek !== 6) {
			count++;
		}
		current.add(1, 'day');
	}
	return count;
}