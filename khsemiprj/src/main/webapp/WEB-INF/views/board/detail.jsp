<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<style>
	.reply-viewer, .reply-editor {
		display:flex;
		padding:15px;
		box-shadow: 0 0 0 1px lightgray;
	}
	.reply-viewer > .profile-wrapper ,
	.reply-editor > .profile-wrapper
	{
		width:100px;
	}
	.reply-viewer > .profile-wrapper > img ,
	.reply-editor > .profile-wrapper > img
	{
		width:100%;
		aspect-ratio:1/1;
	}
	.reply-viewer > .content-wrapper ,
	.reply-editor > .content-wrapper
	{
		flex-grow: 1;
	}
</style>

<!-- 좋아요 처리 관련 자바스크립트 (비회원도 가능) -->
<script type="text/javascript">
	//header.jsp에 jQuery CDN이 있기 때문에 그냥 사용 가능
	$(function(){
		//시작하자마자 서버에 물어봐서 좋아요 상태와 좋아요 개수를 알아낸다
		
		//주소창에 있는 파라미터 중 boardNo를 꺼내는 코드
		var params = new URLSearchParams(window.location.search);
		var boardNo = params.get("boardNo");
		$.ajax({
			url: "/rest/board/like-check",
			method: "post",
			data: { boardNo : boardNo },
			success: function(response){
				//response에 action, count가 있을 것으로 기대
				//- action은 좋아요 여부, count는 좋아요 개수
				$(".fa-heart").removeClass("fa-regular fa-solid")
					.addClass(response.action ? "fa-solid" : "fa-regular");
				$(".fa-heart").next(".heart-count").text(response.count);
			}
		});
	});
</script>

<c:if test="${sessionScope.loginId != null}">
<!-- 좋아요 토글 자바스크립트(회원만 가능) -->
<script type="text/javascript">
	$(function(){
		//주소창에 있는 파라미터 중 boardNo를 꺼내는 코드
		var params = new URLSearchParams(window.location.search);
		var boardNo = params.get("boardNo");
		//하트를 클릭하면 좋아요 토글이 발생하도록 처리
		$(".fa-heart").on("click", function(){
			
			if($(this).hasClass("fa-solid")) {
				return;
			}
			
			$.ajax({
				url:"/rest/board/like-action",
				method:"post",
				data:{boardNo : boardNo},
				success:function(response){
					$(".fa-heart").removeClass("fa-regular fa-solid")
						.addClass(response.action ? "fa-solid" : "fa-regular");
					$(".fa-heart").next(".heart-count").text(response.count);
				}
			});
			
			$(".fa-thumbs-down").on("click", function(){
				
				if($(this).hasClass("fa-regular")) {
					return;
				}
				
				$.ajax({
					url:"/rest/board/like-action",
					method:"post",
					data:{boardNo : boardNo},
					success:function(response){
						$(".fa-heart").removeClass("fa-regular fa-solid")
							.addClass(response.action ? "fa-solid" : "fa-regular");
						$(".fa-heart").next(".heart-count").text(response.count);
					}
				});
		});
	});
</script>
</c:if>

<!-- 댓글 시스템을 위한 자바스크립트 -->
<script type="text/javascript">
	$(function(){
		var params = new URLSearchParams(window.location.search);
		var boardNo = params.get("boardNo");
		
		//목록을 부르는 함수를 만들어두고 시작하자마자 한 번 부르기
		loadList();
		
		function loadList() {
			//목록 불러올 때 최초 1회 목록 영역을 지워주는 코드가 필요
			$(".reply-area").empty();
			
			$.ajax({
				url: "/rest/reply/list",
				method: "post",
				data: {replyOrigin : boardNo},
				success: function(response) {
					//response는 백엔드에서의 List<ReplyDto>이다
					//반복을 통해 템플릿을 배치하고 정보를 갈아끼운다
					for(var i=0; i < response.length; i++) {
						var template = $("#reply-viewer-template").text();//템플릿 불러와서 
						var html = $.parseHTML(template);//HTML로 변환하고
						
						//html에서 필요한 정보를 찾아서 변경
						//- (중요) 수정, 삭제등을 위해서 기본키를 영역에 설정해야함
						//- html은 .reply-wrapper이다.
						$(html).attr("data-key", response[i].replyNo);
						$(html).find(".image-profile")
							.attr("src", "/member/profile?memberId="+response[i].replyWriter);
						$(html).find(".reply-writer").text(response[i].replyWriter);
						$(html).find(".reply-content").text(response[i].replyContent);
						
						//$(html).find(".reply-wtime").text(response[i].replyWtime);
						//var wtime = moment(response[i].replyWtime).format("YYYY-MM-DD HH:mm");
						var wtime = moment(response[i].replyWtime).fromNow();
						
						//var replyWtime = moment(response[i].replyWtime);
						//var diff = moment().diff(replyWtime, 'minutes');
						//var wtime = diff >= 60 ? replyWtime.format("YYYY-MM-DD HH:mm") : replyWtime.fromNow();
						$(html).find(".reply-wtime").text(wtime);
						
						//상황에 따른 화면 제거
						//[1] owner가 false면 수정삭제 버튼 영역을 지운다
						if(response[i].owner == false) {//소유자가 아닐 때
							$(html).find(".button-wrapper").remove();
						}
						//[2] writer가 false면 작성자라는 글자 영역을 지운다
						if(response[i].writer == false) {
							$(html).find(".board-writer").remove();
						}
						
						$(".reply-area").append(html);//화면에 추가
					}
				}
			});
		}
		
		
		//등록 버튼을 누르면 발생할 등록 작업
		$(".btn-reply").on("click", function(){
			var replyContent = $(".field-reply").val();
			if(replyContent.length == 0) return;//입력값이 없으면 차단
			
			$.ajax({
				url: "/rest/reply/write",
				method: "post",
				data: {
					replyContent : replyContent, 
					replyOrigin : boardNo
				},
				success: function(){
					$(".field-reply").val("");//입력값 삭제
					loadList();
				}
			});
		});
		
		//삭제 버튼을 누르면 확인창을 띄우고 ajax요청을 보내 삭제가 이루어지도록 처리
		//- 주의 : .btn-reply-delete는 현재 시점(문서 로딩 후)에 존재하지 않는다
		//- 따라서 이벤트 설정이 정상적인 방법으로 불가능하다
		//- 이벤트를 에너지 소모(메모리 점유)가 크더라도 영역에 설정하는 방향으로 변화시킨다
		//$(".btn-reply-delete").on("click", function(){//안됨
		$(".reply-area").on("click", ".btn-reply-delete", function(){
			var choice = window.confirm("정말 삭제하시겠습니까?");
			if(choice == false) return;
			
			//댓글 영역 최상단에 data-key라는 이름으로 작성된 번호를 가져온다
			var replyNo = $(this).closest(".reply-viewer").data("key");
			
			$.ajax({
				url: "/rest/reply/delete",
				method: "post",
				data: { replyNo : replyNo },
				success: function(response){
					loadList();//목록 갱신
				}
			});
		});
		
		//목표 : 수정버튼을 누르면 수정화면을 보여주도록 처리
		//$(".btn-reply-edit").on("click", function(){});//작동하지 않음(시기가 안맞음)
		$(".reply-area").on("click", ".btn-reply-edit", function(){//영역 감시
// 			기존에 열려있는 모든 댓글 수정화면을 제거
			$(".reply-editor").prev(".reply-viewer").show();
			$(".reply-editor").remove();
			
// 			기존 reply-viewer의 정보를 불러온다
			var replyViewer = $(this).closest(".reply-viewer");
			var key = replyViewer.data("key");
			var src = replyViewer.find(".image-profile").attr("src");
			var replyWriter = replyViewer.find(".reply-writer").text();
			var replyContent = replyViewer.find(".reply-content").text();
			var replyWtime = replyViewer.find(".reply-wtime").text();
			
// 			현재 수정하려는 댓글 화면에 대한 처리			
			var template = $("#reply-editor-template").text();//수정용 템플릿 글자 불러오기
			var html = $.parseHTML(template);//HTML로 변환해서
// 			필요한 정보를 설정하고(프로필, 작성자, 내용, 작성시각, + 댓글번호)
			$(html).attr("data-key", key);
			$(html).find(".image-profile").attr("src", src);
			$(html).find(".reply-writer").text(replyWriter);
			$(html).find(".field-reply-edit").val(replyContent);
			$(html).find(".reply-wtime").text(replyWtime);
			
// 			$(this).closest(".reply-viewer").before(html);
// 			$(this).closest(".reply-viewer").prepend(html);
// 			$(this).closest(".reply-viewer").append(html); 
// 			$(this).closest(".reply-viewer").after(html);
			$(this).closest(".reply-viewer").hide().after(html);
		});
		
		//목표 : 수정취소버튼을 누르면 수정화면을 삭제하고 표시화면을 출력
		$(".reply-area").on("click", ".btn-reply-cancel", function(){
			$(this).closest(".reply-editor").prev(".reply-viewer").show();
			$(this).closest(".reply-editor").remove();
		});
		
		//목표 : 수정완료버튼을 누르면 ajax통신을 이용해 수정요청을 한 뒤 목록 갱신
		$(".reply-area").on("click", ".btn-reply-save", function(){
			var replyNo = $(this).closest(".reply-editor").data("key");
			var replyContent = $(this).closest(".reply-editor")
										.find(".field-reply-edit").val();
			if(replyContent.length == 0) return;
			
			$.ajax({
				url:"/rest/reply/edit",
				method:"post",
				data: { 
					replyNo : replyNo,
					replyContent: replyContent
				},
				success: function(){
					loadList();//목록 갱신
				}
			});
		});
	});
</script>
<script type="text/template" id="reply-viewer-template">
	<div class="reply-viewer">
		<div class="profile-wrapper">
			<img src="https://picsum.photos/500" class="image-circle image-profile">
		</div>
		<div class="content-wrapper ms-20">
			<h3 class="mt-0 mb-0">
				<span class="reply-writer">아이디</span>
				<span class="board-writer red">(작성자)</span>
			</h3>
			<pre class="mt-10 mb-0 reply-content">내용 샘플</pre>
			<div class="mt-20 flex-area"> 
				<div class="w-50">
					<span class="gray reply-wtime">yyyy-MM-dd HH:mm</span>
				</div>
				<div class="button-wrapper right w-50">
					<i class="fa-solid fa-edit orange btn-reply-edit"></i>
					<i class="fa-solid fa-trash red btn-reply-delete"></i>
				</div>
			</div>
		</div>
	</div>
</script>
<script type="text/template" id="reply-editor-template">
	<div class="reply-editor">
		<div class="profile-wrapper">
			<img src="https://picsum.photos/500" class="image-circle image-profile">
		</div>
		<div class="content-wrapper ms-20">
			<h3 class="mt-0 mb-10 reply-writer">작성자</h3>
			<textarea class="field w-100 field-reply-edit" rows="3">내용 샘플</textarea>
			<div class="mt-10 flex-area">
				<div class="w-50">
					<span class="gray reply-wtime">yyyy-MM-dd HH:mm</span>
				</div>
				<div class="button-wrapper right w-50">
					<i class="fa-solid fa-xmark red btn-reply-cancel"></i>
					<i class="fa-solid fa-check blue btn-reply-save"></i>
				</div>
			</div>
		</div>
	</div>
</script>
<div class="container w-950 mt-50 mb-50">
	<div class="cell">
		<div class="flex-area" style="align-items:end">
			<div>
				<h1 class="mt-0 mb-0">
					<!-- 말머리가 있으면 표시 -->
					<c:if test="${boardDto.boardHead != null}">
					(${boardDto.boardHead})
					</c:if>
					<!-- 제목 -->
					${boardDto.boardTitle}
					<!-- 수정되었다면 추가 표시 -->
					<c:if test="${boardDto.boardEtime != null}">
					(수정됨)
					</c:if>	
				</h1>
			</div>
			<div class="ms-40">
				<!-- 목록과 동일하게 사용자 아이디 출력 -->
				<c:if test="${boardDto.boardWriter == null}">
					(탈퇴한사용자)
				</c:if>
				<c:if test="${boardDto.boardWriter != null}">
					<!-- 누르면 이동하도록 링크 구현 -->
					<a href="/member/detail?memberId=${boardDto.boardWriter}" class="link">
						${boardDto.boardWriter}
					</a>
				</c:if>
			</div>
		</div>
	</div>
	
	<div class="cell mt-20 flex-area">
		<div><fmt:formatDate value="${boardDto.boardWtime}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></div>
		<div class="ms-20">조회수 ${boardDto.boardReadcount}</div>
	</div>
	
	<hr>
	<div class="cell" style="min-height:300px">
		<!-- 있는 그대로의 출력을 수행하는 태그(엔터, 스페이스 등을 인정) -->
		<pre>${boardDto.boardContent}</pre>
	</div>
	
	<div class="cell mt-20 flex-area">
		<!-- 
			좋아요 처리 시나리오
			1. 이 페이지가 최초로 로딩되었을 때, 현재 사용자가 이 글에 좋아요를 누른적이 있는지 + 현재 좋아요 개수 불러옴
			 → 하트를 채울지 비울지 결정, 하트 옆에 적어야될 숫자를 표시
			 → 비회원도 가능한 기능
			2. 하트를 클릭하면 글번호를 알려주면서 좋아요/해제 처리를 요청
			 → 서버에서 결과적으로 좋아요/해제 중 어떤것이 처리되었는지와 현재 좋아요 개수를 알려줌
			 → 회원만 가능한 기능
		-->
		<div>
			좋아요 
			<i class="fa-solid fa-heart red"></i>
			<span class="heart-count">?</span>
		</div>
		<div>
			싫어요 
			<i class="fa-regular fa-thumbs-down blue"></i>
			<span class="heart-count">?</span>
		</div>
		<div class="ms-20">댓글 ${boardDto.boardReplycount}</div>
	</div>
	
	<!-- 댓글 관련 정보가 표시될 자리 -->
	<div class="cell reply-area">
<!-- 		표시용 더미 화면 -->
		<div class="reply-viewer">
			<div class="profile-wrapper">
				<img src="https://picsum.photos/500" class="image-circle image-profile">
			</div>
			<div class="content-wrapper ms-20">
				<h3 class="mt-0 mb-0 reply-writer">작성자</h3>
				<pre class="mt-10 mb-0 reply-content">내용 샘플</pre>
				<div class="mt-20 flex-area">
					<div class="w-50">
						<span class="gray reply-wtime">yyyy-MM-dd HH:mm</span>
					</div>
					<div class="button-wrapper right w-50">
						<i class="fa-solid fa-edit orange btn-reply-edit"></i>
						<i class="fa-solid fa-trash red btn-reply-delete"></i>
					</div>
				</div>
			</div>
		</div>
		
<!-- 		수정용 더미화면 -->
		<div class="reply-editor">
			<div class="profile-wrapper">
				<img src="https://picsum.photos/500" class="image-circle image-profile">
			</div>
			<div class="content-wrapper ms-20">
				<h3 class="mt-0 mb-10 reply-writer">작성자</h3>
				<textarea class="field w-100 field-reply-edit" rows="3">내용 샘플</textarea>
				<div class="mt-10 flex-area">
					<div class="w-50">
						<span class="gray reply-wtime">yyyy-MM-dd HH:mm</span>
					</div>
					<div class="button-wrapper right w-50">
						<i class="fa-solid fa-xmark red btn-reply-cancel"></i>
						<i class="fa-solid fa-check blue btn-reply-save"></i>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<c:if test="${sessionScope.loginId != null}">
	<div class="cell">
		<textarea class="field w-100 field-reply" rows="4" placeholder="댓글 내용 작성"></textarea>
		<button type="button" class="btn btn-positive w-100 mt-10 btn-reply">
			<i class="fa-solid fa-pen"></i>
			<span>댓글 작성하기</span>
		</button>
	</div>
	</c:if>
	
	<c:if test="${sessionScope.loginId == null}">
	<div class="cell">
		<h3>댓글 작성을 원하시면 <a href="/member/login">로그인</a>하세요</h3>
	</div>
	</c:if>
	
	
	<hr>
	
	<!-- 이전글/다음글 출력 -->
	<div class="cell">
		<span class="badge blue me-20">이전글</span> 
		<a href="./detail?boardNo=${prevBoardDto.boardNo}" class="link">${prevBoardDto.boardTitle}</a>	
	</div>
	<div class="cell">
		<span class="badge blue me-20">다음글</span>
		<a href="./detail?boardNo=${nextBoardDto.boardNo}" class="link">${nextBoardDto.boardTitle}</a>	
	</div>
	
	<hr>
	<div class="cell right">
		<c:if test="${sessionScope.loginId != null}">
		<a class="btn btn-positive" href="./write">글쓰기</a>
		<a class="btn btn-positive" href="./write?boardParent=${boardDto.boardNo}">답글쓰기</a>
		</c:if>
		
		<c:if test="${boardDto.boardWriter != null && boardDto.boardWriter == sessionScope.loginId}">
		<a class="btn btn-negative" href="./edit?boardNo=${boardDto.boardNo}">수정</a>
		<a class="btn btn-negative" href="./delete?boardNo=${boardDto.boardNo}">삭제</a>
		</c:if>
		
		<a class="btn btn-neutral" href="./list">목록으로</a>
	</div>
</div>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>

