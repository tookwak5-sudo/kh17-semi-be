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
function openModal(type) {
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
	modal.classList.add('active');
}

// 팝업 닫기
function closeModal() {
	modal.classList.remove('active');
	form.reset(); // 닫을 때 입력값 초기화
	$(modal).find(".modal-header")[0].classList.remove("blue", "red");
}