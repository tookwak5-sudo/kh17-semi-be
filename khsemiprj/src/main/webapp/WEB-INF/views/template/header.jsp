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
		.profile-card {
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
		
		/* 프로필 정보 텍스트 */
		.profile-info {
		    font-size: 0.95em;
		    color: #475569;
		    margin-top: 15px;
		    line-height: 1.6;
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
		var workInState = {
			workInValid: false,
			ok: function(){
				return Object.values(this)
				.filter(v => typeof v==="boolean")
				.every(v => v === true);
			}
		};
		
		var workOutState = {
			workOutValid: false,
			ok: function(){
				return Object.values(this)
				.filter(v => typeof v==="boolean")
				.every(v => v === true);
			}
		};
		
		$(function () {
			$("#workInForm").on("submit", function(e){
				
				if(!workInState.workInValid) {
	            	openConfirm('출근하시겠습니까?', 'workInState.workInValid = true; $("#btnWorkIn").click();');
				}
				
				return workInState.ok();
			});
			
			$("#workOutForm").on("submit", function(e){
				
				if(!workOutState.workOutValid) {
	            	openConfirm('퇴근하시겠습니까?', 'workOutState.workOutValid = true; $("#btnWorkOut").click();');
				}
				
				return workOutState.ok();
			});
		});
	</script>

    <!-- 메인 컨테이너1 + 내부영역4 -->
    <div class="container w-clamp">
        <div class="flex-area flex-vertical">
        	<div class="sticky-header flex-area" style="background-color: #739BED; align-items: center;">
                
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
					    <div class="profile-card">
					        <div class="image-hover image-circle image-shadow" style="width: 120px; margin: 0 auto;">
					            <img src="https://picsum.photos/200">
					            <div class="content">
					                <a href="/emp/mypage" class="white">
					                    <i class="fa-solid fa-user"></i> 내정보
					                </a>
					            </div>
					        </div>
					
					        <div class="profile-info">
					            <div style="font-weight: bold; color: #1E293B;">${sessionScope.loginId}</div>
					            <div>${sessionScope.empDept}</div>
					            <div>${sessionScope.empPosition}</div>
					        </div>
					
					        <c:choose>
					            <c:when test="${logInoutType.trim() eq '퇴근'}">
					                <form id="workInForm" action="/emp/work-in" method="post">
					                <button id="btnWorkIn" class="btn btn-positive btn-work">
					                    <i class="fa-solid fa-arrow-right-to-bracket"></i> 출근
					                </button>
					                </form>
					            </c:when>
					            <c:otherwise>
					                <form id="workOutForm" action="/emp/work-out" method="post">
					                <button id="btnWorkOut" class="btn btn-negative btn-work">
					                    <i class="fa-solid fa-arrow-right-to-bracket"></i> 퇴근
					                </button>
					                </form>
					            </c:otherwise>
					        </c:choose>
					    </div>
	            	
	            	<!-- 
	            	사이드 바
	            	<nav class="sidebar">
						<div class="sidebar-header">메뉴</div>
						<ul class="menu-list">
							<li><a href="#">홈</a></li>
				  			<li><a href="#">결재</a></li>
				  			<li><a href="#">조직도</a></li>
				  			<li><a href="#">게시판</a></li>
				  			<li><a href="#">관리메뉴</a></li>
				  			<li><a href="#">내정보</a></li>
				  		</ul>
					</nav>
					
					<style>
					  /* 사이드바 스타일 */
					  .sidebar {
					    width: 200px;
					    background-color: #ffffff;
					    border-right: 1px solid #e0e0e0;
					    height: 100vh;
					    padding: 20px;
					    font-family: 'Segoe UI', sans-serif;
					  }
					
					  .sidebar-header {
					    font-size: 1.2rem;
					    font-weight: bold;
					    color: #333;
					    margin-bottom: 20px;
					    padding-bottom: 10px;
					    border-bottom: 2px solid #0056b3; /* 메인 색상 포인트 */
					  }
					
					  .menu-list {
					    list-style: none;
					    padding: 0;
					  }
					
					  .menu-list li {
					    margin-bottom: 15px;
					  }
					
					  .menu-list li a {
					    text-decoration: none;
					    color: #555;
					    font-weight: 500;
					    display: block;
					    padding: 10px;
					    border-radius: 5px;
					    transition: background 0.3s;
					  }
					
					  /* 호버 효과 */
					  .menu-list li a:hover {
					    background-color: #f0f7ff;
					    color: #0056b3;
					  }
					</style>
	            	 -->
	            	<!-- 컨텐츠 -->
	                <div class="w-200 flex-fill">
