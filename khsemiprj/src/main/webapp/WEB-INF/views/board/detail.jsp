<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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
	
	#user-context-menu {
    		position: absolute;
    		background-color: white;
    		border: 1px solid #ccc;
    		box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
    		border-radius: 3px;
    		padding: 5px 0;
    		z-index: 1000; 
		}

		#user-context-menu a {
    		display: block;
    		padding: 8px 15px;
    		color: #333;
    		text-decoration: none;
    		font-size: 14px;
		}

		#user-context-menu a:hover {
    		background-color: #f1f3f5; 
		}
		
		/* 긴 문자열이 창을 뚫고 나가는 현상 방지 */
		pre, .reply-content {
    		white-space: pre-wrap;       /* 엔터와 띄어쓰기는 유지하되, 영역 끝에 닿으면 줄바꿈해라 */
    		word-break: break-all;       /* 띄어쓰기가 없는 아주 긴 단어라도 무조건 쪼개서 줄바꿈해라 */
    		overflow-wrap: break-word;   /* 글자가 박스를 뚫고 나가지 못하게 막아라 */
    		font-family: inherit;        /* (선택사항) pre 태그 특유의 딱딱한 글씨체를 기본 글씨체로 변경 */
		}
		
		/* 본문 영역에도 뚫고 나가는 것 방지 */
		.board-content-area {
    		word-break: break-all;
    		overflow-wrap: break-word;
		}
</style>

<!-- 작성글 보기 자바스크립트(비회원 가능) -->
<script type="text/javascript">
	$(function(){
    	// 1. 닉네임 클릭 시 메뉴 띄우기
    	// 동적으로 생성된 댓글 닉네임도 클릭 가능하도록 document 영역 감시
    	$(document).on("click", ".writer-name", function(e) {
	        e.stopPropagation(); //클릭 이벤트가 문서 전체로 퍼지는 것을 막음 (바로 닫히는 현상 방지)

    	    var memberId = $(this).data("id");

        	if(!memberId) return; // 탈퇴한 사용자 등 아이디가 없으면 무시

        // 2) 작성 글 보기 링크의 href 주소를 변경
        	var searchUrl = "/board/list?column=board_writer&keyword=" + memberId;
        	$("#link-view-posts").attr("href", searchUrl);

        // 3) 마우스가 클릭된 좌표를 계산하여 메뉴를 이동
        	$("#user-context-menu").css({
            	top: e.pageY + 10 + "px", // 마우스 포인터보다 살짝 아래
            	left: e.pageX + "px"      // 마우스 포인터 위치
        	}).show();
    	});

    // 2. 메뉴 밖의 다른 빈 공간을 클릭하면 메뉴 숨기기
    	$(document).on("click", function() {
        	$("#user-context-menu").hide();
    	});
	});
</script>


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
				$(".board-btn-like").removeClass("fa-regular fa-solid")
					.addClass(response.action ? "fa-solid" : "fa-regular");
				$(".board-btn-like").next(".thumbs-up-count").text(response.count);
			}
		});
		
		$.ajax({
			url: "/rest/board/dislike-check",
			method: "post",
			data: { boardNo : boardNo },
			success: function(response){
				//response에 action, count가 있을 것으로 기대
				//- action은 좋아요 여부, count는 좋아요 개수
				$(".board-btn-dislike").removeClass("fa-regular fa-solid")
					.addClass(response.action ? "fa-solid" : "fa-regular");
				$(".board-btn-dislike").next(".thumbs-down-count").text(response.count);
			}
		});
	});
</script>

<c:if test="${sessionScope.loginId != null}">
	<!-- 좋아요 토글 자바스크립트(회원만 가능) -->
	<script type="text/javascript">
	$(function(){
		var params = new URLSearchParams(window.location.search);
		var boardNo = params.get("boardNo");
		
		// 1. 좋아요 하트를 클릭했을 때
		$(".board-btn-like").on("click", function(){
			// 만약 싫어요가 칠해져있다면 싫어요 먼저 취소 요청
			if($(".board-btn-dislike").hasClass("fa-solid")) {
				$.ajax({
					url: "/rest/board/dislike-action",
					method: "post",
					data: {boardNo : boardNo},
					success: function(response){
						$(".board-btn-dislike").removeClass("fa-solid").addClass("fa-regular");
						$(".board-btn-dislike").next(".thumbs-down-count").text(response.count);
						toggleLike(); // 싫어요 취소 후 좋아요 실행
					}
				});
			} else {
				toggleLike();
			}
		});
		
		// 2. 싫어요 하트를 클릭했을 때
		$(".board-btn-dislike").on("click", function(){
			// 만약 좋아요가 칠해져있다면 좋아요 먼저 취소 요청
			if($(".board-btn-like").hasClass("fa-solid")) {
				$.ajax({
					url: "/rest/board/like-action",
					method: "post",
					data: {boardNo : boardNo},
					success: function(response){
						$(".board-btn-like").removeClass("fa-solid").addClass("fa-regular");
						$(".board-btn-like").next(".thumbs-up-count").text(response.count); 
						toggleDislike(); // 좋아요 취소 후 싫어요 실행
					}
				});
			} else {
				toggleDislike();
			}
		});

		//좋아요 ajax 통신
		function toggleLike() {
			$.ajax({
				url: "/rest/board/like-action",
				method: "post",
				data: {boardNo : boardNo},
				success: function(response){
					$(".board-btn-like").removeClass("fa-regular fa-solid")
						.addClass(response.action ? "fa-solid" : "fa-regular");
					// heart-count 오타를 html에 맞게 thumbs-up-count로 수정
					$(".board-btn-like").next(".thumbs-up-count").text(response.count);
				}
			});
		}

		//싫어요 ajax 통신
		function toggleDislike() {
			$.ajax({
				url: "/rest/board/dislike-action",
				method: "post",
				data: {boardNo : boardNo},
				success: function(response){
					$(".board-btn-dislike").removeClass("fa-regular fa-solid")
						.addClass(response.action ? "fa-solid" : "fa-regular");
					$(".board-btn-dislike").next(".thumbs-down-count").text(response.count);
				}
			});
		}
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
					
				    var displayLimit = 15;
					
					/* $(".reply-count-text").text(response.length); */
					//response는 백엔드에서의 List<ReplyDto>이다
					//반복을 통해 템플릿을 배치하고 정보를 갈아끼운다
					for(var i=0; i < response.length; i++) {
						var template = $("#reply-viewer-template").text();//템플릿 불러와서 
						var html = $.parseHTML(template);//HTML로 변환하고
						$(html).attr("data-key", response[i].replyNo);
						
						if (response[i].replyParent) { 
						    // 1. 대댓글 전체 영역 들여쓰기
						    $(html).css("margin-left", "50px"); 
						    // 2. 프로필 이미지 왼쪽에 ㄴ 모양의 꺾인 화살표 아이콘 추가
						    $(html).find(".profile-wrapper").before(
						        $('<div class="ms-10 me-10" style="display:flex; padding-top:15px;"><i class="fa-solid fa-turn-up fa-rotate-90 gray"></i></div>')
						    );
						    //3. 대댓글에는 대댓글쓰기 지우기
						     $(html).find(".btn-nested-reply").remove(); 
						}
						
						//html에서 필요한 정보를 찾아서 변경
						//- (중요) 수정, 삭제등을 위해서 기본키를 영역에 설정해야함
						//- html은 .reply-wrapper이다.
						if(response[i].replyStatus=='Y'){
							$(html).find(".reply-writer").text("(알수없음)").removeClass("writer-name").css("cursor", "default");
							$(html).find(".reply-content").text("(삭제된 댓글입니다)").addClass("gray");
							$(html).find(".button-wrapper").remove();
							$(html).find(".board-writer").remove();
							$(html).find(".button-writer").remove();
							$(html).find(".reply-btn-like").remove();
							$(html).find(".reply-thumbs-up-count").remove();
							$(html).find(".reply-btn-dislike").remove();
							$(html).find(".reply-thumbs-down-count").remove();
						} else {
						/* $(html).find(".image-profile")
							.attr("src", "/member/profile?memberId="+response[i].replyWriter); */
							$(html).find(".reply-writer").text(response[i].replyWriter)
							.attr("data-id", response[i].replyWriter);
						$(html).find(".reply-thumbs-up-count").text(response[i].replyLikecount);
						$(html).find(".reply-thumbs-down-count").text(response[i].replyDislikecount);
						$(html).find(".reply-content").text(response[i].replyContent);
						if (response[i].empLiked=='Y') {
					    	$(html).find(".reply-btn-like").removeClass("fa-regular").addClass("fa-solid");
					    } else{
					    	$(html).find(".reply-btn-like").removeClass("fa-solid").addClass("fa-regular");
					    }
					    if (response[i].empDisliked=='Y') {
					    	$(html).find(".reply-btn-dislike").removeClass("fa-regular").addClass("fa-solid");
					    } else{
					    	$(html).find(".reply-btn-dislike").removeClass("fa-solid").addClass("fa-regular");
					    }
						}
						
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
							$(html).find(".btn-reply-edit").remove();
							$(html).find(".btn-reply-delete").remove();
						}
						//[2] writer가 false면 작성자라는 글자 영역을 지운다
						if(response[i].writer == false) {
							$(html).find(".board-writer").remove();
						}
						//[3] loginId가 null이면 대댓글 등록 버튼을 지운다
						if(${sessionScope.loginId == null}){
							$(html).find(".btn-nested-reply").remove();
						}
						
						if (i >= displayLimit) {
				            $(html).addClass("reply-hidden").hide(); 
				        }

						$(".reply-area").append(html);//화면에 추가
					}
					//댓글 더보기 토글버튼
					if (response.length > displayLimit) {
				        var hiddenCount = response.length - displayLimit;
				        var toggleBtnHtml = `
				            <div class="center mt-20 reply-toggle-wrapper">
				                <button type="button" class="btn btn-neutral w-100 btn-reply-toggle" style="padding: 15px; font-weight: bold;">
				                    <i class="fa-solid fa-chevron-down"></i> 
				                    <span class="toggle-text">댓글 더보기 (` + hiddenCount + `개)</span>
				                </button>
				            </div>
				        `;
				        $(".reply-area").append(toggleBtnHtml);
				    }
				}
			});
		}
		
		
		//댓글 더보기 / 접기 토글
		$(".reply-area").on("click", ".btn-reply-toggle", function() {
			var $hiddenReplies = $(".reply-hidden");
			var $icon = $(this).find("i");
			var $text = $(this).find(".toggle-text");
            var hiddenCount = $hiddenReplies.length;

			// 만약 현재 숨겨진 댓글들이 안 보이고 있는 상태라면 (펼치기 동작)
			if ($hiddenReplies.is(":hidden")) {
				$hiddenReplies.slideDown(200);
				$icon.removeClass("fa-chevron-down").addClass("fa-chevron-up");
				$text.text("댓글 접기");
			} 
			// 만약 다 펴져 있는 상태라면 (접기 동작)
			else {
				$hiddenReplies.slideUp(200);
				$icon.removeClass("fa-chevron-up").addClass("fa-chevron-down");
				$text.text("댓글 더보기 (" + hiddenCount + "개)");
				
				//접었을 때 스크롤을 다시 첫 댓글 위치로
				/* var offset = $(".reply-area").offset().top - 100;
				$("html, body").animate({ scrollTop: offset }, 200); */
			}
		});
		
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
		
		
		
			//대댓글 등록 버튼을 누르면 그 댓글 아래에 대댓글 입력창을 띄운다
		$(".reply-area").on("click", ".btn-nested-reply", function() {
		    // 1. 기존에 열려있는 다른 대댓글 입력창이 있다면 닫기(선택사항)
		    $(".nested-reply-editor").remove();
		    
		    // 2. 내가 누른 원댓글의 번호(부모 번호)를 가져오기
		    var parentNo = $(this).closest(".reply-viewer").data("key");
		    
		    // 3. 동적으로 띄울 대댓글 입력창 HTML 생성
		    var html = `
		        <div class="nested-reply-editor mt-10" style="margin-left: 50px; padding: 10px; background-color: #f9f9f9; border-radius: 5px;">
		            <i class="fa-solid fa-turn-up fa-rotate-90 gray"></i> 대댓글 작성
		            <textarea class="field w-100 field-nested-reply mt-10" rows="2" placeholder="답글을 남겨주세요"></textarea>
		            <div class="right mt-10">
		                <button type="button" class="btn btn-neutral btn-nested-cancel">취소</button>
		                <button type="button" class="btn btn-positive btn-nested-save" data-parent="`+parentNo+`">등록</button>
		            </div>
		        </div>
		    `;
		    
		    // 4. 현재 원댓글 영역 바로 아래에 입력창 추가
		    $(this).closest(".reply-viewer").after(html);
		});
		
		// 취소 버튼 누르면 입력창 지우기
		$(".reply-area").on("click", ".btn-nested-cancel", function() {
		    $(this).closest(".nested-reply-editor").remove();
		});
		
		// 목표: 대댓글 등록 버튼 누르면 AJAX로 전송
		$(".reply-area").on("click", ".btn-nested-save", function() {
		    // 1. 숨겨뒀던 부모 번호(parentNo)와 입력한 내용을 가져옴
		    var parentNo = $(this).data("parent");
		    var replyContent = $(this).closest(".nested-reply-editor").find(".field-nested-reply").val();
		    
		    if(replyContent.length == 0) return;
		    
		    // 2. AJAX 전송 
		    $.ajax({
		        url: "/rest/reply/write",
		        method: "post",
		        data: {
		            replyContent : replyContent,
		            replyOrigin : boardNo,
		            replyParent : parentNo
		        },
		        success: function() {
		            loadList(); // 등록 성공하면 목록 전체 새로고침
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
		
		// === [댓글 좋아요/싫어요 이벤트] ===
		
		// 1. 댓글 좋아요 클릭
		$(".reply-area").on("click", ".reply-btn-like", function(){
			var $thisLikeBtn = $(this);
			var $thisDislikeBtn = $(this).siblings(".reply-btn-dislike");
			var replyNo = $(this).closest(".reply-viewer").data("key");
			
			// 싫어요가 눌려있다면 취소 먼저
			if($thisDislikeBtn.hasClass("fa-solid")) {
				$.ajax({
					url: "/rest/reply/dislike-action",
					method: "post",
					data: {replyNo : replyNo},
					success: function(response){
						$thisDislikeBtn.removeClass("fa-solid").addClass("fa-regular");
						$thisDislikeBtn.next(".reply-thumbs-down-count").text(response.count);
						executeReplyLike(replyNo, $thisLikeBtn);
					}
				});
			} else {
				executeReplyLike(replyNo, $thisLikeBtn);
			}
		});

		// 2. 댓글 싫어요 클릭
		$(".reply-area").on("click", ".reply-btn-dislike", function(){
			var $thisDislikeBtn = $(this);
			var $thisLikeBtn = $(this).siblings(".reply-btn-like");
			var replyNo = $(this).closest(".reply-viewer").data("key");
			
			// 좋아요가 눌려있다면 취소 먼저
			if($thisLikeBtn.hasClass("fa-solid")) {
				$.ajax({
					url: "/rest/reply/like-action",
					method: "post",
					data: {replyNo : replyNo},
					success: function(response){
						$thisLikeBtn.removeClass("fa-solid").addClass("fa-regular");
						$thisLikeBtn.next(".reply-thumbs-up-count").text(response.count);
						executeReplyDislike(replyNo, $thisDislikeBtn);
					}
				});
			} else {
				executeReplyDislike(replyNo, $thisDislikeBtn);
			}
		});

		// 댓글 좋아요 실행 함수
		function executeReplyLike(replyNo, btnElement) {
			$.ajax({
				url: "/rest/reply/like-action",
				method: "post",
				data: {replyNo : replyNo},
				success: function(response){
					btnElement.removeClass("fa-regular fa-solid").addClass(response.action ? "fa-solid" : "fa-regular");
					btnElement.next(".reply-thumbs-up-count").text(response.count);
				}
			});
		}

		// 댓글 싫어요 실행 함수
		function executeReplyDislike(replyNo, btnElement) {
			$.ajax({
				url: "/rest/reply/dislike-action",
				method: "post",
				data: {replyNo : replyNo},
				success: function(response){
					btnElement.removeClass("fa-regular fa-solid").addClass(response.action ? "fa-solid" : "fa-regular");
					btnElement.next(".reply-thumbs-down-count").text(response.count);
				}
			});
		}
	});
</script>
<script type="text/template" id="reply-viewer-template">
	<div class="reply-viewer">
		<div class="profile-wrapper">
			<img src="https://picsum.photos/500" class="image-circle image-profile">
		</div>
		<div class="content-wrapper ms-20">
			<div class="flex-area">
			<h3 class="mt-0 mb-0">
				<span class="reply-writer writer-name" style="cursor: pointer;">아이디</span>
				<span class="board-writer red">(작성자)</span>
			</h3>
				<div style="margin-left : auto">
					<i class="fa-regular fa-thumbs-up red reply-btn-like"></i>
					<span class="reply-thumbs-up-count">0</span>
					<i class="fa-regular fa-thumbs-down blue reply-btn-dislike"></i>
					<span class="reply-thumbs-down-count">0</span>
				</div>
			</div>
			<pre class="mt-10 mb-0 reply-content">내용 샘플</pre>
			<div class="mt-20 flex-area"> 
				<div class="w-50">
					<span class="gray reply-wtime">yyyy-MM-dd HH:mm</span>
				</div>
				<div class="button-wrapper right w-50">
					<i class="fa-solid fa-comment-dots blue btn-nested-reply"></i>
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
		<div class="flex-area" style="align-items: end">
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
					<!-- 누르면 팝업나오게 링크 구현 -->
					<span class="writer-name" data-id="${boardDto.boardWriter}" style="cursor: pointer; font-weight: bold;">
  						  	${boardDto.boardWriter}
						</span>
				</c:if>
			</div>
		</div>
	</div>

	<div class="cell mt-20 flex-area">
		<div>
			<fmt:formatDate value="${boardDto.boardWtime}"
				pattern="yyyy-MM-dd HH:mm"></fmt:formatDate>
		</div>
		<div class="ms-20">조회수 ${boardDto.boardReadcount}</div>
	</div>

	<hr>
	<div class="cell" style="min-height:300px">
    	<div class="board-content-area">
        	${boardDto.boardContent}
    	</div>
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
			<i class="fa-solid fa-thumbs-up red board-btn-like"></i>
			<span class="thumbs-up-count">?</span>
		</div>
		<div class="ms-20">
			싫어요 
			<i class="fa-regular fa-thumbs-down blue board-btn-dislike"></i>
			<span class="thumbs-down-count">?</span>
		</div>
		<div class="ms-20">
			댓글 <span class="reply-count-text"> ${boardDto.boardReplycount}</span>
		</div>
	</div>

	<!-- 댓글 관련 정보가 표시될 자리 -->
	<div class="cell reply-area">
		<!-- 		표시용 더미 화면 -->
		<div class="reply-viewer">
			<div class="profile-wrapper">
				<img src="https://picsum.photos/500"
					class="image-circle image-profile">
			</div>
			<div class="content-wrapper ms-20">
			<div class="flex-area">
			<h3 class="mt-0 mb-0">
				<span class="reply-writer">작성자</span>
			</h3>
				<div style="margin-left : auto">
					<i class="fa-solid fa-thumbs-up red reply-btn-like"></i>
					<span class="reply-thumbs-up-count"></span>
					<i class="fa-regular fa-thumbs-down blue reply-btn-dislike"></i>
					<span class="reply-thumbs-down-count"></span>
				</div>
			</div>
				<pre class="mt-10 mb-0 reply-content">내용 샘플</pre>
				<div class="mt-20 flex-area">
					<div class="w-50">
						<span class="gray reply-wtime">yyyy-MM-dd HH:mm</span>
					</div>
					<div class="button-writer right w-50">
					<i class="fa-solid fa-comment-dots blue btn-nested-reply"></i>
				</div>
				<div class="button-wrapper right w-20">
					<i class="fa-solid fa-comment-dots blue btn-nested-reply"></i>
					<i class="fa-solid fa-edit orange btn-reply-edit"></i>
					<i class="fa-solid fa-trash red btn-reply-delete"></i>
				</div>
				</div>
			</div>
		</div>

		<!-- 		수정용 더미화면 -->
		<div class="reply-editor">
			<div class="profile-wrapper">
				<img src="https://picsum.photos/500"
					class="image-circle image-profile">
			</div>
			<div class="content-wrapper ms-20">
				<h3 class="mt-0 mb-10 reply-writer">작성자</h3>
				<textarea class="field w-100 field-reply-edit" rows="3">내용 샘플</textarea>
				<div class="mt-10 flex-area">
					<div class="w-50">
						<span class="gray reply-wtime">yyyy-MM-dd HH:mm</span>
					</div>
					<div class="button-wrapper right w-50">
						<i class="fa-solid fa-xmark red btn-reply-cancel"></i> <i
							class="fa-solid fa-check blue btn-reply-save"></i>
					</div>
				</div>
			</div>
		</div>
	</div>

	<c:if test="${sessionScope.loginId != null}">
	<div class="cell">
		<textarea class="field w-100 field-reply" rows="4" placeholder="댓글 내용 작성(500자 이내)"></textarea>
		<button type="button" class="btn btn-positive w-100 mt-10 btn-reply">
			<i class="fa-solid fa-pen"></i>
			<span>댓글 작성하기</span>
		</button>
	</div>
	</c:if>

	<c:if test="${sessionScope.loginId == null}">
		<div class="cell">
			<h3>
				댓글 작성을 원하시면 <a href="/emp/login">로그인</a>하세요
			</h3>
		</div>
	</c:if>


	<hr>

	<!-- 이전글/다음글 출력 -->
	<div class="cell">
		<span class="badge blue me-20">다음글</span>
		<c:if test="${param.column!=null || param.boardHead!=null}">
		<a href="./detail?boardNo=${nextBoardDto.boardNo}&column=${param.column}&keyword=${param.keyword}" class="link">${nextBoardDto.boardTitle}</a>
		</c:if>
		<c:if test="${param.column==null && param.boardHead==null}">
		<a href="./detail?boardNo=${nextBoardDto.boardNo}" class="link">${nextBoardDto.boardTitle}</a>
		</c:if>
	</div>
	<div class="cell">
		<span class="badge blue me-20">이전글</span> 
		<c:if test="${param.column!=null || param.boardHead!=null}">
		<a href="./detail?boardNo=${prevBoardDto.boardNo}&column=${param.column}&keyword=${param.keyword}" class="link">${prevBoardDto.boardTitle}</a>
		</c:if>
		<c:if test="${param.column==null && param.boardHead==null}">
		<a href="./detail?boardNo=${prevBoardDto.boardNo}" class="link">${prevBoardDto.boardTitle}</a>
		</c:if>
	</div>

	<hr>
	<div class="cell right">
		<c:if test="${sessionScope.loginId != null}">
			<a class="btn btn-positive" href="./write">글쓰기</a>
			<!--  <a class="btn btn-positive" href="./write?boardParent=${boardDto.boardNo}">답글쓰기</a>-->
		</c:if>
		
		<c:if test="${boardDto.boardWriter != null && boardDto.boardWriter == sessionScope.loginId}">
		<a class="btn btn-negative" href="./edit?boardNo=${boardDto.boardNo}">수정</a>
		<a class="btn btn-negative" href="./delete?boardNo=${boardDto.boardNo}"  onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
		</c:if>
		<c:if test="${param.column==null && param.boardHead==null}">
			<a class="btn btn-neutral" href="./list">목록으로</a>
		</c:if>
		<c:if test="${param.column!=null || param.boardHead!=null}">
			<a class="btn btn-neutral" href="./list?boardHead=${param.boardHead}&column=${param.column}&keyword=${param.keyword}">목록으로</a>
		</c:if>
	</div>
</div>

<!-- 닉네임 클릭 시 나타날 창 -->
<div id="user-context-menu" style="display: none;">
    <a href="#" id="link-view-posts">
        <i class="fa-solid fa-magnifying-glass"></i> 작성 글 보기
    </a>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>

