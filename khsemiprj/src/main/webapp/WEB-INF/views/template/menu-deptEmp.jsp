<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 관리자가 아닌 회원일 때 보여줄 메뉴 -->
<ul class="menu">
	<li>
	    <a href="/aprv/list">
	        <i class="fa-solid fa-file-signature"></i>
	        <span>결재</span>
		</a>
	</li>
	<li>
        <a href="/dept/chart">
            <i class="fa-solid fa-circle-nodes"></i>
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
          <span>쪽지</span>
      	</a>
	</li>
	
	<li class="divider"></li>
	
	<li>
	    <a href="/admin/manage">
	        <i class="fa-solid fa-user"></i>
	        <span>관리메뉴</span>
	    </a>
	     <!-- 하위메뉴 -->
        <ul>
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
                <a href="/aprvForm/list">
					<i class="fa-solid fa-box"></i>
                    <span>결재 양식</span>
                </a>
            </li>
        </ul>
    </li>
    <li>
	    <a href="/emp/mypage">
	        <i class="fa-solid fa-user"></i>
	        <span>내정보</span>
	    </a>
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