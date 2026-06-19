<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/memoHeader.jsp"></jsp:include>

<!-- 	쪽지 읽으면 새 알림 수 실시간으로 줄어들음 -->
<script>
    $(function() {
        // 1. 부모 창(window.opener)이 존재하면 부모 창의 뱃지를 찾고, 
        // 그냥 현재 페이지 이동 구조면 현재 문서(document)에서 뱃지를 찾는다.
        var $targetBadge = window.opener ? $(window.opener.document).find('.badge') : $('.badge');

        if ($targetBadge.length > 0) {
            // 2. 현재 메인 헤더 상단바 뱃지에 적힌 숫자 꺼내기
            var currentCount = parseInt($targetBadge.text()) || 0;

            // 3. 0보다 크면 실시간으로 딱 1만 깎아주기
            if (currentCount > 1) {
                $targetBadge.text(currentCount - 1);
                
                // 만약 서브창(팝업) 구조라면, 메인 화면 뱃지 텍스트를 강제로 연동
                if(window.opener) {
                    $(window.opener.document).find('.badge').text(currentCount - 1);
                }
            } else {
                // 숫자가 1이었으면 이제 안 읽은 쪽지가 0개니까 뱃지 자체를 숨김
                $targetBadge.text('0').hide();
                if(window.opener) {
                    $(window.opener.document).find('.badge').text('0').hide();
                }
            }
        }
    });
</script>

<div class="container w-600 mt-20 mb-0 memo-card background-card">
<!-- 	제목, 타입, 작성자 -->
	<div class="cell">
		<div class="flex-area" style="align-items:end">
			<div>
				<h1 class="mt-0 mb-0">
					(${memoDto.memoType})
					<!-- 제목 -->
					${memoDto.memoTitle}
				</h1>
			</div>
			<div class="ms-40">
				<c:if test="${boardDto.boardWriter != null}">
					${memoDto.memoSenderId}
				</c:if>
			</div>
		</div>
	</div>
<!-- 	작성일 -->
	<div class="cell mt-20 flex-area">
		<div>작성일 : <fmt:formatDate value="${memoDto.memoWtime}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></div>
	</div>	
	<hr style="color:#e1e4e6">		
<!-- 	쪽지 내용 -->
	<div class="cell" style="min-height:300px">
		<pre style="font-size:16px;">${memoDto.memoContent}</pre>
	</div>
	<hr style="color:#e1e4e6">
	<a href="/memo/write?memoSenderId=${memoDto.memoSenderId}" class="btn btn-positive">
    	<span>답변하기</span>
	</a>
	<a class="btn btn-neutral" href="./list">목록으로</a>
</div>      