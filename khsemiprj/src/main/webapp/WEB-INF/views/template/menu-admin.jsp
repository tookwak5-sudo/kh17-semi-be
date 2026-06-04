<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 관리자가 아닌 회원일 때 보여줄 메뉴 -->
<ul class="menu">
	<li>
	    <a href="/">
	        <i class="fa-solid fa-house"></i>
	        <span>홈</span>
	    </a>
	</li>
	<li>
	    <a href="#">
	        <i class="fa-solid fa-database"></i>
	        <span>결재</span>
		</a>
        <!-- 하위 메뉴 -->
        <ul>
            <li>
                <a href="/aprv/list">
                    <i class="fa-solid fa-flag"></i>
                    <span>결재 목록</span>
                </a>
            </li>
        </ul>
	</li>
	<li>
	    <a href="/member/list">
	        <i class="fa-solid fa-comments"></i>
	        <span>사원관리</span>
	    </a>
	</li>
	<li>
	    <a href="#">
	        <i class="fa-solid fa-database"></i>
	        <span>부서관리</span>
		</a>
        <!-- 하위 메뉴 -->
        <ul>
            <li>
                <a href="/dept/list">
                    <i class="fa-solid fa-flag"></i>
                    <span>부서 목록</span>
                </a>
            </li>
            <li>
                <a href="/dept/chart">
                    <i class="fa-solid fa-flag"></i>
                    <span>조직도</span>
                </a>
            </li>
        </ul>
	</li>
	<li>
	    <a href="/board/list">
	        <i class="fa-solid fa-comments"></i>
	        <span>게시판</span>
	    </a>
	</li>
	
	<li class="divider"></li>
	
	<li class="menu-wrapper">
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
</ul>