<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>그룹웨어</title>
    <link rel="icon" href="/images/kh.ico" type="image/x-icon">

    <!-- 아이콘 -->
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
	
	<!-- fullcalendar cdn -->
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/index.global.min.js'></script>
	<!-- 음력 cdn	 -->
	<script src="https://cdn.jsdelivr.net/npm/lunar-javascript/lunar.min.js"></script>
	<!-- <script src='https://cdn.jsdelivr.net/npm/@fullcalendar/core@6.1.20/index.global.min.js'></script> -->

    <!-- 디자인을 작성하기 위한 영역 -->
    <link rel="stylesheet" type="text/css" href="/css/commons.css">
    <link rel="stylesheet" type="text/css" href="/css/modal.css">
    <style>
        /* div { box-shadow: 0 0 0 1px gray ;} */
        .menu { /* 실제 사용 중인 메뉴 div의 클래스명으로 변경 */
		    position: relative;
		    z-index: 1000; /* 달력보다 높은 값 설정 */
		}
		.menu-wrapper { 
	        position: relative;
	        z-index: 9999 !important; /* 달력보다 높은 우선순위 부여 */
   		}
   		.menu-wrapper ul {
        	position: absolute;
	        top: 100%; /* 내정보 바로 아래에 붙음 */
	        left: 0;
	        z-index: 5000; /* 최상위 */
	        background: white; /* 배경색이 없으면 달력이 비쳐 보임 */
	        border: 1px solid #ddd;
	        padding: 0;
	        margin: 0;
	        display: none; /* 기본은 숨김 */
    	}
    	
    	/* 1. 종 아이콘과 뱃지를 감싸는 부모 상자 */
		.notification-box {
		    position: relative;
		    display: inline-block;
		    background: rgba(255, 255, 255, 0.2); 
		    backdrop-filter: blur(8px);
		    border: 1px solid rgba(255, 255, 255, 0.3);
		    border-radius: 12px;
		    padding: 10px 15px; /* 패딩 조정 */
		    transition: all 0.3s ease;
		    cursor: pointer;
		}
		.notification-box:hover {
		    background: rgba(255, 255, 255, 0.2);
		    transform: translateY(-2px);
		}
		/* 2. 종 아이콘 스타일 */
		.bell-icon {
		    font-size: 20px;       /* 아이콘 크기 (상단바에 맞게 조절 가능) */
		 	color: white;
		}
		
		/* 3. 🔥 핵심: 빨간색 알림 뱃지 */
		.badge {
		    position: absolute;    /* 💡 중요: 부모 상자를 기준으로 자유롭게 배치 */
		    top: 3px;             /* 위에서부터의 위치 */
		    right: 75px;           /* 우측에서부터의 위치 */
		    
		    background-color: #ff4d4d; /* 선명하고 트렌디한 빨간색 */
		    color: #ffffff;        /* 숫자 색상은 흰색 */
		    
		    font-size: 13px;       /* 작은 글씨 크기 */
		    font-weight: bold;
		    
		    /* 둥근 원형 뱃지를 만들기 위한 속성들 */
		    min-width: 20px;
		    height: 20px;
		    padding: 0 4px;
		    border-radius: 50px;   /* 완전히 둥글게 처리 */
		    
		    /* 숫자가 중앙에 오도록 정렬 */
		    display: flex;
		    align-items: center;
		    justify-content: center;
		}
		
		/* 고정 헤더 */
		.sticky-header {
		    position: sticky;
		    top: 0; 
		    /* z-index: 9999; */ 
		    z-index: 999;
		    background-color: #ffffff; 
		}
		body {
		    background-color: #F8F9FA; /* 네이버 스타일의 밝은 회색 */
		    color: #202124; /* 구글 스타일의 다크 그레이 */
		    font-family: 'Pretendard', sans-serif;
		}
		.flex-center h1 {
		    font-size: 26px;
		    font-weight: 800;
		    /* 그라데이션 텍스트 처리 */
		    background: linear-gradient(135deg, #1e293b 0%, #4f46e5 100%);
		    -webkit-background-clip: text;
		    -webkit-text-fill-color: transparent;
		    letter-spacing: -1px;
		}
		
		/* 사이드바 프로필 카드 스타일 */
		
		/* 기존 스타일 수정 및 추가 */
		.profile-info {
		    font-size: 0.95em;
		    color: #475569;
		    margin-top: 15px;
		    line-height: 1.4;
		    padding: 10px 0;
		}
		
		/* 이름 강조 */
		.profile-name {
		    font-size: 1.2em;
		    font-weight: 700;
		    color: #1E293B;
		    margin-bottom: 2px;
		}
		
		/* 부서 및 직책 라인 */
		.profile-dept-pos {
		    font-size: 0.9em;
		    color: #64748b;
		    margin-bottom: 8px;
		}
		
		/* 아이디(작은 텍스트) */
		.profile-id {
		    font-size: 0.8em;
		    color: #94a3b8;
		    background: #f8fafc;
		    display: inline-block;
		    padding: 2px 6px;
		    border-radius: 4px;
		}
		
		/* 출퇴근 버튼 전용 클래스 (기존 btn 스타일 계승) */
		.btn-work {
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    gap: 8px;
		    width: 100%;
		    margin-top: 15px;
		    font-weight: 600;
		}
	
		.profile-card, .profile-card2 {
		    background: #FFFFFF;
		    border: 1px solid #E2E8F0;
		    border-radius: 12px;
		    padding: 20px;
		    margin-top: 20px;
		    margin-right:10px;
		    text-align: center;
		    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
		    height:fit-content;
		}
		.profile-card2 {
		    background: #FFFFFF;
		    border: 1px solid #E2E8F0;
		    border-radius: 12px;
		    padding: 20px;
		    margin-top: 20px;
		    margin-right:10px;
		    text-align: center;
		    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
		    height:fit-content;
		}
		
		.profile-card2 ul {
		    list-style: none;
		    padding: 0;
		    margin-top: 20px;
		    border-top: 1px solid #eee; /* 구분선 */
		    padding-top: 15px;
		}
		.profile-card2 li a {
		    display: flex;
		    align-items: center;
		    padding: 10px 15px;
		    color: #495057;
		    text-decoration: none;
		    border-radius: 8px;
		    transition: 0.2s;
		    font-size: 0.95rem;
		}
		.profile-card2 li a i {
		    margin-right: 12px;
		    width: 20px; /* 아이콘 정렬 맞추기 */
		    text-align: center;
		    color: #6c757d;
		}
		
		.profile-card2 li a:hover {
		    background-color: #f1f3f5;
		    color: #007bff;
		    font-weight: 600;
		}
		
		/* 관리메뉴 타이틀 부분 */
		.menu-title {
		    padding: 10px 20px 5px 20px; /* 위/옆/아래/옆 */
		    font-size: 0.95rem;
		    font-weight: bold;
		    color: #888;
		}
    </style>
    
    <!-- jQuery CDN -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    
    <!-- <script src="/js/checkbox.js"></script> -->
    
    <!-- lightpick cdn -->
    <link href="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/css/lightpick.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/moment@2.30.1/moment.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.30.1/locale/ko.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/lightpick.min.js"></script>
    
    <!-- <link rel="stylesheet" type="text/css" href="/lib/multipage/multipage.css">
    <script src="/lib/multipage/multipage.js"></script> -->
</head>

<body>

<%-- 세션ID : ${pageContext.session.id} --%>
<%-- loginId : ${sessionScope.loginId} --%>
<%-- empGrade : ${sessionScope.empGrade} --%>
<%-- 부서 정보 : ${sessionScope.empDept} --%>
<%-- 직책 정보 : ${sessionScope.empPosition} --%>

	<script>
// 		var workInState = {
// 			workInValid: false,
// 			ok: function(){
// 				return Object.values(this)
// 				.filter(v => typeof v==="boolean")
// 				.every(v => v === true);
// 			}
// 		};
		
		// 퇴근
		var workOutState = {
			workOutValid: false,
			ok: function(){
				return Object.values(this)
				.filter(v => typeof v==="boolean")
				.every(v => v === true);
			}
		};
		
		$(function () {
			
			
			$("#workOutForm").on("submit", function(e){
				
				if(!workOutState.workOutValid) {
	            	openConfirm('퇴근하시겠습니까?로그아웃이 진행됩니다.', 'workOutState.workOutValid = true; $("#btnWorkOut").click();');
				}
				
				return workOutState.ok();
			});
		});
	</script>
	
<!-- 	쪽지 오면 실시간으로 알림 가게 -->
<script>
	$(function() {
		var loginId = "${sessionScope.loginId}";
		
		if(loginId && loginId.trim() !== "") {
			
			setInterval(function() {
				$.ajax({
					url: "${pageContext.request.contextPath}/memo/checkNewMemo",
					type: "GET",
					dataType: "json",
					success: function(data) {
						if(data.hasNewMemo) {
						    // 1. 프사 옆 좌표 계산 다 지우고, 화면 기준 왼쪽 아래(fixed)로 완벽하게 고정
						    // 보라색 말풍선 스타일에 푸터 오리지널 애니메이션 클래스 호환되도록 세팅
						    $('#send-ajax-alarm').css({
// 						        'background-color': '#6c5ce7', /* 네온 퍼플 */
// 						        'color': '#ffffff',
// 						        'border': 'none',
						        'font-weight': 'bold',
						        'box-shadow': '0 4px 15px rgba(0,0,0,0.2)',
						        'padding': '15px 25px',
						        'border-radius': '50px', /* 너희가 준 스타일대로 완전 둥글게 */
						        'font-size': '16px',
						        'white-space': 'nowrap',
						        'transition': 'transform 0.5s ease, opacity 0.5s ease' /* 너희 핵심 속성 유지 */
						    });
						    
						    // 2. 외부 div 박스를 화면 기준 왼쪽 하단으로 박아버리기
						    $('#div-alarm').css({
						        'position': 'fixed',
						        'bottom': '40px',
						        'left': '20px',    /* 💡 오른쪽(right)이 아니라 왼쪽(left)으로 배치! */
						        'right': 'auto',   /* 기존에 잡혀있을지 모를 right 속성 무력화 */
						        'top': 'auto',     /* 기존에 잡혀있을지 모를 top 속성 무력화 */
						        'width': 'fit-content',
						        'height': 'auto',
						        'z-index': '1000'
						    });
						    
						    // 3. 푸터 함수 실행 
						    // (세 번째 인자에 targetElement 대신 null이나 아무거나 던져서 오프셋 계산 무력화)
						    showAjaxAlarm("새 쪽지가 왔어요!", "btn-positive", undefined);
						    
						    // 4. 상단바 뱃지 갱신
						    var $badge = $('.badge');
						    if($badge.length > 0) {
						        var currentCount = parseInt($badge.text()) || 0;
						        $badge.text(currentCount + 1);
						    }
						}
					}, // success 끝
					error: function(err) {
						console.log("쪽지 동기화 중");
					}
				});
			}, 60000);
			
		}
	});
</script>

    <!-- 메인 컨테이너1 + 내부영역4 -->
    <div class="container w-clamp">
        <div class="flex-area flex-vertical">
        	<div class="sticky-header flex-area" style="background-color: #739BED; align-items: center; height: 49px">
                
                <a href="/" style="display: flex; align-items: center; padding: 0 10px; flex-shrink: 0; position: relative; z-index: 9999; margin-right: 100px;">
                    <img src="/images/kh정보교육원 로고.png" alt="홈" style="height: 35px; width: auto; transform: scale(2.8); transform-origin: left center; position: relative; top: 5px;">
                </a>

                <div style="flex-grow: 1;">
                    <style>
                        .sticky-header .bell-icon {
                            color: #ffffff !important;
                        }
                        .sticky-header .notification-box {
                            background: transparent !important;
                            border: none !important;
                            box-shadow: none !important;
                            padding: 0 !important;
                            margin: 0 15px !important;
                        }
                    </style>

                    <c:if test="${sessionScope.loginId != null && sessionScope.empGrade != null}">
                        <c:if test="${sessionScope.empGrade == '2'}">
                            <jsp:include page="/WEB-INF/views/template/menu-admin.jsp"></jsp:include>
                        </c:if>
                        <c:if test="${sessionScope.empGrade == '1'}">
                            <jsp:include page="/WEB-INF/views/template/menu-deptEmp.jsp"></jsp:include>
                        </c:if>
                        <c:if test="${sessionScope.empGrade == '0'}">           	
                            <jsp:include page="/WEB-INF/views/template/menu-emp.jsp"></jsp:include>
                        </c:if>
                    </c:if>
                </div>
	         </div>
	            <!-- 사이드바 및 컨텐츠 -->
	            <div style="min-height: 450px;" class="flex-area">
	        		 <c:if test="${sessionScope.loginId != null && sessionScope.empGrade != null}">
	        		 <div>
					    <div class="profile-card">
					        <div class="image-hover image-circle image-shadow" style="width: 120px; margin: 0 auto;">
					            <img src="/emp/profile?empId=${sessionScope.loginId}">
					            <div class="content">
					                <a href="/emp/mypage" class="white">
					                    <i class="fa-solid fa-user"></i> 내정보
					                </a>
					            </div>
					        </div>
					
					        <div class="profile-info">
					            <div class="profile-name">${sessionScope.empName} ${sessionScope.empPosition}</div>
					            <div class="profile-dept-pos">${sessionScope.empDept}</div>
					            <div class="profile-id">ID: ${sessionScope.loginId}</div>
					        </div>
					
<%-- 					        <c:choose> --%>
<%-- 					            <c:when test="${logInoutType.trim() eq '퇴근'}"> --%>
<!-- 					                <form id="workInForm" action="/emp/work-in" method="post"> -->
<!-- 					                <button id="btnWorkIn" class="btn btn-positive btn-work"> -->
<!-- 					                    <i class="fa-solid fa-arrow-right-to-bracket"></i> 출근 -->
<!-- 					                </button> -->
<!-- 					                </form> -->
<%-- 					            </c:when> --%>
<%-- 					            <c:otherwise> --%>
<!-- 					                <form id="workOutForm" action="/emp/work-out" method="post"> -->
<!-- 					                <button id="btnWorkOut" class="btn btn-negative btn-work"> -->
<!-- 					                    <i class="fa-solid fa-arrow-right-to-bracket"></i> 퇴근 -->
<!-- 					                </button> -->
<!-- 					                </form> -->
<%-- 					            </c:otherwise> --%>
<%-- 					        </c:choose> --%>
					        <c:if test="${logInoutType.trim() eq '출근'}">
					        	<form id="workOutForm" action="/emp/logoutOut" method="post">
				                <button id="btnWorkOut" class="btn btn-negative btn-work">
				                    <i class="fa-solid fa-arrow-right-to-bracket"></i> 퇴근 및 로그아웃
				                </button>
				                </form>
					        </c:if>
					    </div>
					    
					    <c:if test="${sessionScope.empGrade == 1 || sessionScope.empGrade == 2}">
					    <div class="profile-card2">
			    			
						    <div class="menu-title"><i class="fa-solid fa-user-gear"></i> <span>관리메뉴</span></div>
					        <ul>
					        	<li class="mb-0">
						    		<a href="/admin/manage">
								        <i class="fa-solid fa-user-gear"></i>
								        <span>시스템 설정</span>
								    </a>
					    		</li>
					        	<li>
								    <a href="/admin/emp/list">
								        <i class="fa-solid fa-people-group"></i>
								        <span>사원관리</span>
								    </a>
								</li>
								<li>
								    <a href="/dept/list">
								        <i class="fa-solid fa-building"></i>
								        <span>부서관리</span>
									</a>
								</li>
								<li>
								    <a href="/admin/leave/list">
								        <i class="fa-solid fa-umbrella-beach"></i>
								        <span>휴가관리</span>
									</a>
								</li>
								<li>
					                <a href="/aprvForm/list">
					                    <i class="fa-solid fa-box"></i>
					                    <span>결재 양식</span>
					                </a>
					            </li>
					            <li>
					                <a href="/admin/logAccess/list">
					                    <i class="fa-solid fa-server"></i>
					                    <span>접속로그</span>
					                </a>
					            </li>
					            <li>
					                <a href="/admin/log-inout/list">
					                    <i class="fa-solid fa-clock-rotate-left"></i>
					                    <span>근태로그</span>
					                </a>
					            </li>
					            <li>
								    <a href="/admin/emp/exitList">
								        <i class="fa-solid fa-people-group"></i>
								        <span>퇴사자목록</span>
								    </a>
								</li>
					        </ul>
					    </div>
					    </c:if>
					 </div>
	        		 </c:if>   	
	            	<!-- 컨텐츠 -->
	                <div class="w-200 flex-fill">
