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
		 	color: #739BED;
		}
		
		/* 3. 🔥 핵심: 빨간색 알림 뱃지 */
		.badge {
		    position: absolute;    /* 💡 중요: 부모 상자를 기준으로 자유롭게 배치 */
		    top: 10px;             /* 위에서부터의 위치 */
		    right: 30px;           /* 우측에서부터의 위치 */
		    
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


    <!-- 메인 컨테이너1 + 내부영역4 -->
    <div class="container w-1400">
        <div class="flex-area flex-vertical">
            <!-- 헤더 영역 -->
            <div class="flex-area">
                <div class="w-25 flex-area flex-center">
                    <img src="/images/kh정보교육원 로고.png" alt="로고" style="height: 42px; width: auto; object-fit: contain;">
                </div>
                <div class="w-50 flex-area flex-center">
                    <h1>　                        </h1>
                </div>
                <c:if test="${sessionScope.loginId != null && sessionScope.empGrade != null}">
	                <div class="w-25 flex-area" style="justify-content: right; align-items: center;">
	                    <div style="padding-top: 15px;padding-right: 20px;width: 100px;height: 42px; text-align: center;" class="notification-box"> 
	                    	<a href="/memo/list" 
					           style="font-size:20px; text-decoration: none;" 
					           onclick="
					               var w = 650; 
					               var h = 650; 
					               var left = (screen.width/2) - (w/2); 
					               var top = (screen.height/2) - (h/2); 
					               window.open(this.href, 'memoListPopup', 'width='+w+',height='+h+',top='+top+',left='+left+',scrollbars=yes,resizable=no'); 
					               return false;
					        		 ">
					            <i class="fa-solid fa-bell bell-icon">
					            	<c:if test="${not empty countMemo && countMemo != 0}">
						            	<span class="badge">${countMemo}</span>					            	
					            	</c:if>
					            </i>
					        </a>
	                    </div>
	                </div>
                </c:if>
            </div>

            <!-- 메뉴 -->
           <div> 
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

            <!-- 사이드바 및 컨텐츠 -->
            <div style="min-height: 450px;" class="flex-area">
                <div class="w-200 flex-fill">