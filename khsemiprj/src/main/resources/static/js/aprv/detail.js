/**
 * 
 */

var modal;
var form;

$(function () {
	
	$(document).on("input", ".aprv-form-list", function () {
		var formNo = $(this).val();
		if(formNo != "") {
			getAprmFormAttach(formNo);
		}
	});
	
	modal = document.getElementById('modalOverlay');
	form = document.getElementById('popupForm');
	
	// 배경(어두운 부분) 클릭 시에도 팝업 닫히게 설정
	modal.addEventListener('click', (e) => {
	    if (e.target === modal) {
	        closeModal();
	    }
	});
});

// 팝업 열기
function openModal(no, type) {
	$(modal).find(".modal-header")[0].classList.remove("blue", "red");
	switch(type) {
		case "승인":
			$(modal).find(".modal-header").text("결재 승인");
			$(modal).find(".modal-header")[0].classList.add("blue");
			break;
		case "반려":
			$(modal).find(".modal-header").text("결재 반려");
			$(modal).find(".modal-header")[0].classList.add("red");
			break;	
	}
	$('input[name=aprvLineNo').val(no);
	$('input[name=aprvLineStatus').val(type);
	modal.classList.add('active');
}

// 팝업 닫기
function closeModal() {
	modal.classList.remove('active');
	$('input[name=aprvLineNo').val('');
	$('input[name=aprvLineStatus').val('대기');
	form.reset(); // 닫을 때 입력값 초기화
}

function aprvLineUpdate() {
	var aprvLineNo = $('input[name=aprvLineNo').val();
	var aprvLineStatus = $('input[name=aprvLineStatus').val();
	var aprvLineComment = $('input[name=aprvLineComment]').val();
	
	if(aprvLineComment.length == 0) {
		//alert('결재 코멘트를 입력해주세요');
		openAlert("결재 코멘트를 입력해주세요");
		$('input[name=aprvLineComment]').focus();
		return false;
	}
	
	$.ajax({
		url : "/rest/aprv/setAprvLineStatus",
		method: "post",
		data: { aprvLineNo : aprvLineNo, aprvLineStatus : aprvLineStatus, aprvLineComment : aprvLineComment },
		success : function(response) {
			var result = response.result;
			if(result == "Success") {
				/*$('#line1List').find('td[data-no=' + aprvLineNo + ']').empty();
				$('#line1List').find('td[data-no=' + aprvLineNo + ']').text(aprvLineStatus);
				closeModal();*/
				location.reload();
			} else if(result == "NeedLogin") {
				alert('로그인이 필요합니다.');
				location.href("/emp/login");
			} else {
				alert('처리 중 오류가 발생했습니다.\r\n\r\n오류코드 : ' + result);
			}
		}
	});
}