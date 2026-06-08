/**
 * 
 */

var modal;
var form;

$(function () {
	
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
});

// 팝업 열기
function openModal() {
	modal.classList.add('active');
}

// 팝업 닫기
function closeModal() {
	modal.classList.remove('active');
    form.reset(); // 닫을 때 입력값 초기화
}