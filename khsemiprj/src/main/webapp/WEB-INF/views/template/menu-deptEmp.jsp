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
			<c:if test="${logInoutType.trim() eq '퇴근'}">
		    <li>
		        <form id="workInForm" action="/emp/work-in" method="post"></form>
		        <a href="#" onclick="document.getElementById('workInForm').submit(); return false;">
		             <i class="fa-solid fa-right-from-bracket"></i>
		             <span>출근</span>
		        </a>
		    </li>
		    </c:if>
		    <c:if test="${logInoutType.trim() eq '출근'}">
		    <li>
		        <form id="workOutForm" action="/emp/work-out" method="post"></form>
		        
		        <a href="#" onclick="document.getElementById('workOutForm').submit(); return false;">
		            <i class="fa-solid fa-right-from-bracket"></i>
		            <span>퇴근</span>
		        </a>
		    </li>
		    </c:if>
		    <li>
		        <a href="/emp/logout">
		            <i class="fa-solid fa-right-from-bracket"></i>
		            <span>로그아웃</span>
		        </a>
		    </li>
		</ul>
    </li>
</ul>