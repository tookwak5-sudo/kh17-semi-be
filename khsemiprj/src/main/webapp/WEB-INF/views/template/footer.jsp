<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                </div>
            </div>

            <!-- 푸터 -->
            
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
		        
		        #send-alarm, #send-ajax-alarm {
		        	background-color: #ffffff;
		        	transition: transform 0.5s ease, opacity 0.5s ease;
		        }
		        #send-alarm.btn-positive:hover, #send-ajax-alarm.btn-positive:hover {
		        	background-color: #5A86E3;
		        	transition: transform 0.5s ease, opacity 0.5s ease;
		        }
		        #send-alarm.btn-negitave:hover, #send-ajax-alarm.btn-negative:hover {
		        	background-color: #E86A7A;
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
				        } else if(position == 'right') {
				            // 왼쪽을 기준으로 오른쪽으로 확장 (기본값)
				            $(divAlarm).css('transform-origin', 'left center');
				            
				            $(divAlarm).css({
				                top: $(target).offset().top + "px",
				                left: ($(target).offset().left + $(target).outerWidth() + 10) + "px"
				            });
				        } else if(position == 'bottom') {
				        	// 왼쪽을 기준으로 오른쪽으로 확장 (기본값)
				            $(divAlarm).css('transform-origin', 'left center');
				            
				            $(divAlarm).css({
				                top: $(target).offset().top + $(target).outerHeight() + 10 + "px",
				                left: $(target).offset().left + "px"
				            });
				        } else {
				        	// 왼쪽을 기준으로 오른쪽으로 확장 (기본값)
				            $(divAlarm).css('transform-origin', 'left center');
				            
				            $(divAlarm).css({
				                top: $(target).offset().top - 50 + "px",
				                left: $(target).offset().left + "px"
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
				function openAlert(message, clickScript) {
					$('#alertMessage').html(message);
					if(clickScript != undefined) {
						$('#btnAlertAction').attr('onclick', clickScript + ' closeAlert();');
					} else {
						$('#btnAlertAction').attr('onclick', 'closeAlert();');
					}
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
					$('#confirmMessage').html(message);
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
				
				document.body.addEventListener('keydown', function(event) {
				    // 모달창 내부에서 발생한 이벤트인지 확인
				    if (event.key === 'Enter') {
				    	//열려있는 모달들을 확인
				    	const modals = document.querySelectorAll('.modal-overlay.active');
			        	if (modals.length > 0) {//열려있는 모달이 1개라도 있다면
			        		event.preventDefault();//모달외의 submit을 막고
			        	    // 배열의 마지막 요소가 가장 나중에 열린 모달입니다.
			        	    const lastModal = modals[modals.length - 1];
			        		$(lastModal).find(".btn-positive").click();//모달의 확인 버튼을 클릭
			        	}
				    }
				});
				
			</script>
			<c:choose>
				<c:when test="${param.alarm != null}">
					<c:choose>
						<c:when test="${param.alarm == 'needLogin'}">
							<div style="position: absolute;">
						        <a id="send-alarm" class="btn btn-negative btn-slide-hidden" onclick="$(this).parent().hide();" >로그인이 필요합니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'join'}">
							<div style="position: absolute;top: 590px;left: 20px;">
						        <a id="send-alarm" class="btn btn-positive btn-slide-hidden" onclick="$(this).parent().hide();" >회원가입이 완료되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'headWriter'}">
							<div style="position: absolute;top: 590px;left: 20px;">
						        <a id="send-alarm" class="btn btn-positive btn-slide-hidden" onclick="$(this).parent().hide();" >헤더 등록이 완료되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'headDelete'}">
							<div style="position: absolute;top: 590px;left: 20px;">
						        <a id="send-alarm" class="btn btn-negative btn-slide-hidden" onclick="$(this).parent().hide();" >헤더가 삭제되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'positionWriter'}">
							<div style="position: absolute;top: 590px;left: 20px;">
						        <a id="send-alarm" class="btn btn-positive btn-slide-hidden" onclick="$(this).parent().hide();" >직책 등록이 완료되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'positionDelete'}">
							<div style="position: absolute;top: 590px;left: 20px;">
						        <a id="send-alarm" class="btn btn-negative btn-slide-hidden" onclick="$(this).parent().hide();" >직책이 삭제되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'calendarWriter'}">
							<div style="position: absolute;top: 590px;left: 20px;">
						        <a id="send-alarm" class="btn btn-positive btn-slide-hidden" onclick="$(this).parent().hide();" >일정이 등록되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'calendarEdit'}">
							<div style="position: absolute;top: 590px;left: 20px;">
						        <a id="send-alarm" class="btn btn-positive btn-slide-hidden" onclick="$(this).parent().hide();" >일정이 수정되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'calendarDelete'}">
							<div style="position: absolute;top: 590px;left: 20px;">
						        <a id="send-alarm" class="btn btn-negative btn-slide-hidden" onclick="$(this).parent().hide();" >일정이 삭제되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'empApprove'}">
							<div style="position: absolute;top: 590px;left: 20px;">
						        <a id="send-alarm" class="btn btn-positive btn-slide-hidden" onclick="$(this).parent().hide();" >사원이 승인되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'aprvTempSave'}">
							<div style="position: absolute;">
						        <a id="send-alarm" class="btn btn-positive btn-slide-hidden" onclick="$(this).parent().hide();" >결재가 임시저장 되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'aprvSave'}">
							<div style="position: absolute;">
						        <a id="send-alarm" class="btn btn-positive btn-slide-hidden" onclick="$(this).parent().hide();" >결재가 기안되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'aprvDelete'}">
							<div style="position: absolute;">
						        <a id="send-alarm" class="btn btn-positive btn-slide-hidden" onclick="$(this).parent().hide();" >결재가 삭제되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'aprvFormDelete'}">
					      	<div style="position: absolute;">
						        <a id="send-alarm"
						           class="btn btn-negative btn-slide-hidden"
						           onclick="$(this).parent().hide();"
						           style="left:auto; right:20px; bottom:40px;">
						            양식이 삭제되었습니다.
						        </a>
    						</div>
						</c:when>
						<c:when test="${param.alarm == 'workIn'}">
							<div style="position: absolute;">
						        <a id="send-alarm" class="btn btn-positive btn-slide-hidden" onclick="$(this).parent().hide();" style="top:400px;">출근처리 되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'workOut'}">
							<div style="position: absolute;">
						        <a id="send-alarm" class="btn btn-negative btn-slide-hidden" onclick="$(this).parent().hide();" style="top:400px;">퇴근처리 되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'editLeave'}">
							<div style="position: absolute;">
						        <a id="send-alarm" class="btn btn-positive btn-slide-hidden" onclick="$(this).parent().hide();">휴가수정이 완료되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'duplicateHead'}">
							<div style="position: absolute;">
						        <a id="send-alarm" class="btn btn-negative btn-slide-hidden" onclick="$(this).parent().hide();">중복된 헤더입니다</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'duplicatePositionName'}">
							<div style="position: absolute;">
						        <a id="send-alarm" class="btn btn-negative btn-slide-hidden" onclick="$(this).parent().hide();">중복된 직책명입니다</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'duplicatePositionLevel'}">
							<div style="position: absolute;">
						        <a id="send-alarm" class="btn btn-negative btn-slide-hidden" onclick="$(this).parent().hide();">중복된 직책단계입니다</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'deptInsert'}">
							<div style="position: absolute;">
						        <a id="send-alarm" class="btn btn-positive btn-slide-hidden" onclick="$(this).parent().hide();">부서등록이 완료되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'planDelete'}">
							<div style="position: absolute;">
						        <a id="send-alarm" class="btn btn-negative btn-slide-hidden" onclick="$(this).parent().hide();">일정이 삭제되었습니다.</a>
						    </div>
						</c:when>
						<c:when test="${param.alarm == 'planEdit'}">
							<div style="position: absolute;">
						        <a id="send-alarm" class="btn btn-positive btn-slide-hidden" onclick="$(this).parent().hide();">일정이 수정되었습니다.</a>
						    </div>
						</c:when>
					</c:choose>
				</c:when>
	    	</c:choose>
	    	<!-- 비동기용 알림 -->
			<div id="div-alarm" style="position: absolute;opacity: 0;visibility: hidden;width: fit-content;">
		        <a id="send-ajax-alarm" class="btn btn-positive btn-slide-hidden" onclick="hideAjaxAlarm(this)">알림</a>
		    </div>
		    
		    <!-- 커스텀 얼럿 -->
		    <div class="modal-overlay" id="modalAlert">
			    <div class="modal-box" style="width:400px;">
			        <!-- <div class="modal-header center"></div> -->
			        <div class="modal-body">
			            <form id="popupFormAlert" class="flex-area">
			            	<div class="cell w-100">
			            		<span id="alertMessage"></span>
							</div>
			            </form>
			        </div>
			        <div class="modal-footer" style="txt-align:center;">
			        	<button id="btnAlertAction" type="button" class="btn btn-positive" onclick="closeAlert()">확인</button>
			        </div>
			    </div>
			</div>
			
		    <!-- 커스텀 컨펌 -->
		    <div class="modal-overlay" id="modalConfirm">
			    <div class="modal-box" style="width:400px;">
			        <!-- <div class="modal-header center"></div> -->
			        <div class="modal-body">
			            <form id="popupFormConfirm" class="flex-area">
			            	<div class="cell w-100">
			            		<span id="confirmMessage"></span>
							</div>
			            </form>
			        </div>
			        <div class="modal-footer" style="txt-align:center;">
			        	<button id="btnConfirmAction" type="button" class="btn btn-positive" onclick="">확인</button>
			        	<button type="button" class="btn btn-neutral" onclick="closeConfirm()">취소</button>
			        </div>
			    </div>
			</div>
        </div>
    </div>
</body>
</html>