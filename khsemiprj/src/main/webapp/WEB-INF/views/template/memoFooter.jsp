<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
		        /* [1] 버튼 기본 스타일 */
		        #send-alarm {
		            position: fixed; /* 화면 하단에 고정 */
		            bottom: 40px;
		            left: 20px;
		            padding: 15px 25px;
		            /* background-color: transparent; */
		            /* color: #5A86E3; */
		            /* border: 2px solid #5A86E3; */
		            border-radius: 50px;
		            font-size: 16px;
		            cursor: pointer;
		            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
		            z-index: 1000; /* 최상단 위치 */
		            
		            /* 💡 핵심: 부드러운 움직임 설정 (transition) */
		            transition: transform 0.5s ease, opacity 0.5s ease;
		        }
		        
		        #send-ajax-alarm {
		        	transition: transform 0.5s ease, opacity 0.5s ease;
		        }
		
		        /* [2] 처음 숨겨진 상태 (기본) */
		        #send-alarm.btn-slide-hidden, #send-ajax-alarm.btn-slide-hidden {
		            /* 아래로 100px 내려가 있고 투명함 */
		            transform: translateY(100px); 
		            opacity: 0;
		        }
		
		        /* [3] 자연스럽게 나타난 상태 (JS로 추가할 클래스) */
		        #send-alarm.btn-slide-show, #send-ajax-alarm.btn-slide-show  {
		            /* 제자리로 돌아오고 불투명함 */
		            transform: translateY(0);
		            opacity: 1;
		        }
		        
		        /* 보여지는 상태 */
				#div-alarm.is-visible {
				    opacity: 1 !important;
				    visibility: visible !important;
				}
		    </style>
			
			<script>
				// 페이지가 완전히 로드되면 실행
			    document.addEventListener("DOMContentLoaded", function() {
			    	showAlarm();
			    });
				
				function showAlarm() {
					const btn = document.getElementById("send-alarm");
					if(btn != undefined) {
			            // --- [단계 1] 자연스럽게 등장 (아래 -> 위) ---
			            // 페이지 로드 즉시 등장 애니메이션 클래스 추가
			            // (브라우저 렌더링 타이밍을 맞추기 위해 setTimeout을 사용)
			            setTimeout(() => {
			                btn.classList.add("btn-slide-show");
			            }, 10); // 아주 미세한 지연 후 실행
			
			            // --- [단계 2] 3초 대기 ---
			            
			            // --- [단계 3] 자연스럽게 사라짐 (위 -> 아래) ---
			            setTimeout(() => {
			                // 등장 클래스를 제거 -> CSS transition에 의해 아래로 내려감
			                btn.classList.remove("btn-slide-show");
			                
			                // 💡 핵심: 애니메이션 시간(0.5초)이 끝난 후 요소 삭제
			                // transition 시간인 0.5초(500ms) 뒤에 remove 실행
			                setTimeout(() => {
			                    //btn.remove(); // HTML에서 완전히 삭제
			                    $(btn).hide();//HTML에서 숨김
			                }, 500); // CSS 애니메이션 시간과 맞춤
			
			            }, 3000); // 3초 대기 시간
					}
				}
				
				// 함수 외부(전역 범위)에 타이머 변수 선언
				let alarmTimer = null; 
				let fadeOutTimer = null;
				
				function showAjaxAlarm(message, className, target, position) {
					const btn = document.getElementById("send-ajax-alarm");
					// 1. 기존에 돌고 있던 타이머들이 있다면 전부 취소 (핵심!)
				    clearTimeout(alarmTimer);
				    clearTimeout(fadeOutTimer);
					
					if(className == undefined || className == 'btn-positive') {
						$('#send-ajax-alarm').removeClass('btn-negative').addClass('btn-positive');
					} else {
						$('#send-ajax-alarm').removeClass('btn-positive').addClass('btn-negative');
					}
					$('#send-ajax-alarm').text(message);
					
					if (target != undefined) {
						var divAlarm = document.getElementById("div-alarm");
				        // [핵심] 위치 및 transform-origin 설정
				        if (position == 'left') {
				            // 오른쪽을 기준으로 왼쪽으로 확장
				            $(divAlarm).css('transform-origin', 'right center');
				            
				            // 타겟의 왼쪽에서 알림창 너비만큼을 빼서 배치
				            let alarmWidth = $(divAlarm).width(); 
				            $(divAlarm).css({
				                top: $(target).offset().top + "px",
				                left: ($(target).offset().left - alarmWidth - 10) + "px" // 10은 타겟과의 간격
				            });
				        } else {
				            // 왼쪽을 기준으로 오른쪽으로 확장 (기본값)
				            $(divAlarm).css('transform-origin', 'left center');
				            
				            $(divAlarm).css({
				                top: $(target).offset().top + "px",
				                left: ($(target).offset().left + $(target).outerWidth() + 10) + "px"
				            });
				        }
				    }
					
		            // --- [단계 1] 자연스럽게 등장 (아래 -> 위) ---
		            // 페이지 로드 즉시 등장 애니메이션 클래스 추가
		            // (브라우저 렌더링 타이밍을 맞추기 위해 setTimeout을 사용)
	                btn.classList.add("btn-slide-show");
		            $('#div-alarm').addClass("is-visible");
		
		            // --- [단계 2] 3초 대기 ---
		            
		            // --- [단계 3] 자연스럽게 사라짐 (위 -> 아래) ---
		            alarmTimer = setTimeout(() => {
		            	hideAjaxAlarm(btn);
		            }, 3000); // 3초 대기 시간
				}
				
				function hideAjaxAlarm(btn) {
					// 등장 클래스를 제거 -> CSS transition에 의해 아래로 내려감
	                btn.classList.remove("btn-slide-show");
	                // 💡 핵심: 애니메이션 시간(0.5초)이 끝난 후 요소 삭제
	                // transition 시간인 0.5초(500ms) 뒤에 removeClass 실행
	                fadeOutTimer = setTimeout(() => {
	                	$('#div-alarm').removeClass("is-visible");
	                }, 500); // CSS 애니메이션 시간과 맞춤
				}
				
				// 얼럿 열기
				function openAlert(message) {
					$('#alertMessage').text(message);
					var alert = document.getElementById('modalAlert');
					alert.classList.add('active');
				}

				// 얼럿 닫기
				function closeAlert() {
					var alert = document.getElementById('modalAlert');
					alert.classList.remove('active');
				}
				
				// 컨펌 열기
				function openConfirm(message, clickScript) {
					$('#confirmMessage').text(message);
					$('#btnConfirmAction').attr('onclick', clickScript + ' closeConfirm();');
					var confirm = document.getElementById('modalConfirm');
					confirm.classList.add('active');
				}

				// 컨펌 닫기
				function closeConfirm() {
					var confirm = document.getElementById('modalConfirm');
					confirm.classList.remove('active');
					$('#btnConfirmAction').attr("onclick", '');
				}
			</script>