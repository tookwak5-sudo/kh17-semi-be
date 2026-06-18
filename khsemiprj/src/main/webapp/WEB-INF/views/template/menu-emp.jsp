<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 관리자가 아닌 회원일 때 보여줄 메뉴 -->
<ul class="menu">
	<li>
	    <a href="/">
	        <i class="fa-solid fa-house"></i>
	        <span>홈</span>
	    </a>
	</li>
	<li>
	    <a href="/aprv/list">
	        <i class="fa-solid fa-database"></i>
	        <span>결재</span>
		</a>
	</li>
	<li>
        <a href="/dept/chart">
            <i class="fa-solid fa-people-group"></i>
            <span>조직도</span>
        </a>
	</li>
	<li>
	    <a href="/board/list">
	        <i class="fa-solid fa-comments"></i>
	        <span>게시판</span>
	    </a>
	</li>
	<li>
	    <a href="/plan/list">
	        <i class="fa-solid fa-calendar"></i>
	        <span>일정</span>
	    </a>
	</li>
	<li>
		<a href="/memo/list" style="font-size:20px; text-decoration: none;" onclick="
             var w = 650; 
             var h = 750; 
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
          <span>쪽지</span>
      	</a>
	</li>
	
	<li class="divider"></li>
	<li>
		<div class="flex-area">
		    <a href="/emp/mypage">
		        <i class="fa-solid fa-user"></i>
		        <span>내정보</span>
		    </a>
		</div>
	    <!-- 하위메뉴 -->
		<ul>
		    <li>
		        <a href="/emp/logout">
		            <i class="fa-solid fa-right-from-bracket"></i>
		            <span>로그아웃</span>
		        </a>
		    </li>
		</ul>
    </li>