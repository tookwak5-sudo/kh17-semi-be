<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>그룹웨어</title>
    <!-- <link rel="icon" href="/images/kh.jpg" type="image/jpeg"> -->

    <!-- 아이콘 -->
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">

    <!-- 디자인을 작성하기 위한 영역 -->
    <link rel="stylesheet" type="text/css" href="/css/commons.css">
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

세션ID : ${pageContext.session.id},
loginId : ${sessionScope.loginId},
empGrade : ${sessionScope.empGrade}


    <!-- 메인 컨테이너1 + 내부영역4 -->
    <div class="container w-1200">
        <div class="flex-area flex-vertical">
            <!-- 헤더 영역 -->
            <div class="flex-area">
                <div class="w-25 flex-area flex-center">
                    <img src="https://www.dummyimage.com/200x50">
                </div>
                <div class="w-50 flex-area flex-center">
                    <h1>KH정보교육원 그룹웨어 프로젝트</h1>
                </div>
                <div class="w-25 flex-area flex-center">
                    <div class="center">
                        <!-- <h2 class="mt-0 mb-0">24시간상담</h2>
                        <div>1588-0000</div>-->
                    </div>
                </div>
            </div>

            <!-- 메뉴 -->
            <div class="menu-container"> 
            	<%-- <jsp:include page="/WEB-INF/views/template/menu-member.jsp"></jsp:include> --%>
				<c:if test="${sessionScope.loginId != null && sessionScope.empGrade != null}">
					<c:if test="${sessionScope.empGrade == '0' || sessionScope.empGrade == null}">
						<jsp:include page="/WEB-INF/views/template/menu-emp.jsp"></jsp:include>
					</c:if>
					<c:if test="${sessionScope.empGrade == '1' || sessionScope.empGrade == '2'}">
						<jsp:include page="/WEB-INF/views/template/menu-admin.jsp"></jsp:include>
					</c:if>
				</c:if>
            </div>

            <!-- 사이드바 및 컨텐츠 -->
            <div style="min-height: 450px;" class="flex-area">
                <div class="w-200 flex-fill">