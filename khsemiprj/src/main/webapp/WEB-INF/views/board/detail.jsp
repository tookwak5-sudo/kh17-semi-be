<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<style>
	.reply-viewer, .reply-editor { display:flex; padding:15px; box-shadow: 0 0 0 1px lightgray; }
	.reply-viewer > .profile-wrapper, .reply-editor > .profile-wrapper { width:100px; }
	.reply-viewer > .profile-wrapper > img, .reply-editor > .profile-wrapper > img { width:100%; aspect-ratio:1/1; }
	.reply-viewer > .content-wrapper, .reply-editor > .content-wrapper { flex-grow: 1; }
	
	#user-context-menu { position: absolute; background-color: white; border: 1px solid #ccc; box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2); border-radius: 3px; padding: 5px 0; z-index: 1000; }
	#user-context-menu a { display: block; padding: 8px 15px; color: #333; text-decoration: none; font-size: 14px; }
	#user-context-menu a:hover { background-color: #f1f3f5; }
	
	pre, .reply-content { white-space: pre-wrap; word-break: break-all; overflow-wrap: break-word; font-family: inherit; }
	.board-content-area { word-break: break-all; overflow-wrap: break-word; }
</style>

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
			
			<div class="reply-image-wrapper mt-10" style="display: none;">
				<img class="reply-image" src="" style="max-width: 200px; max-height: 200px; border-radius: 5px; border: 1px solid #ccc;">
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
					<c:if test="${boardDto.boardHead != null}">(${boardDto.boardHead})</c:if>
					${boardDto.boardTitle}
					<c:if test="${boardDto.boardEtime != null}">(수정됨)</c:if>
				</h1>
			</div>
			<div class="ms-40">
				<c:if test="${boardDto.boardWriter == null}">(탈퇴한사용자)</c:if>
				<c:if test="${boardDto.boardWriter != null}">
					<span class="writer-name" data-id="${boardDto.boardWriter}" style="cursor: pointer; font-weight: bold;">
  						${boardDto.boardWriter}
					</span>
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
    	<div class="board-content-area">${boardDto.boardContent}</div>
	</div>

	<div class="cell mt-20 flex-area">
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

	<div class="cell reply-area"></div>

	<c:if test="${sessionScope.loginId != null}">
		<div class="cell">
			<div id="reply-image-preview" style="display:none; margin-bottom:10px; position:relative;">
				<img id="preview-img" src="" style="max-width: 150px; max-height: 150px; border-radius: 5px; border: 1px solid #ccc;">
				<i class="fa-solid fa-circle-xmark red btn-preview-remove" style="position:absolute; top:-8px; right:-8px; cursor:pointer; font-size:20px; background:white; border-radius:50%;"></i>
			</div>
		
			<textarea class="field w-100 field-reply" rows="4" placeholder="댓글 내용 작성"></textarea>
			
			<div class="flex-area mt-10">
				<input type="file" id="reply-file-input" accept="image/*" style="display: none;">
				<button type="button" class="btn btn-neutral btn-attach-image" style="flex-shrink: 0;">
					<i class="fa-solid fa-camera"></i> 사진 첨부
				</button>
				<button type="button" class="btn btn-positive w-100 ms-10 btn-reply">
					<i class="fa-solid fa-pen"></i> <span>댓글 작성하기</span>
				</button>
			</div>
		</div>
	</c:if>

	<c:if test="${sessionScope.loginId == null}">
		<div class="cell">
			<h3>댓글 작성을 원하시면 <a href="/emp/login">로그인</a>하세요</h3>
		</div>
	</c:if>

	<hr>

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

<div id="user-context-menu" style="display: none;">
    <a href="#" id="link-view-posts">
        <i class="fa-solid fa-magnifying-glass"></i> 작성 글 보기
    </a>
</div>


<script type="text/javascript">
	$(function(){
    	$(document).on("click", ".writer-name", function(e) {
	        e.stopPropagation(); 
    	    var memberId = $(this).data("id");
        	if(!memberId) return; 

        	var searchUrl = "/board/list?column=board_writer&keyword=" + memberId;
        	$("#link-view-posts").attr("href", searchUrl);

        	$("#user-context-menu").css({
            	top: e.pageY + 10 + "px", 
            	left: e.pageX + "px"      
        	}).show();
    	});

    	$(document).on("click", function() {
        	$("#user-context-menu").hide();
    	});
	});
</script>

<script type="text/javascript">
	$(function(){
		var params = new URLSearchParams(window.location.search);
		var boardNo = params.get("boardNo");
		
		$.ajax({
			url: "/rest/board/like-check",
			method: "post",
			data: { boardNo : boardNo },
			success: function(response){
				$(".board-btn-like").removeClass("fa-regular fa-solid").addClass(response.action ? "fa-solid" : "fa-regular");
				$(".board-btn-like").next(".thumbs-up-count").text(response.count);
			}
		});
		
		$.ajax({
			url: "/rest/board/dislike-check",
			method: "post",
			data: { boardNo : boardNo },
			success: function(response){
				$(".board-btn-dislike").removeClass("fa-regular fa-solid").addClass(response.action ? "fa-solid" : "fa-regular");
				$(".board-btn-dislike").next(".thumbs-down-count").text(response.count);
			}
		});
	});
</script>

<c:if test="${sessionScope.loginId != null}">
<script type="text/javascript">
	$(function(){
		var params = new URLSearchParams(window.location.search);
		var boardNo = params.get("boardNo");
		
		$(".board-btn-like").on("click", function(){
			if($(".board-btn-dislike").hasClass("fa-solid")) {
				$.ajax({
					url: "/rest/board/dislike-action",
					method: "post",
					data: {boardNo : boardNo},
					success: function(response){
						$(".board-btn-dislike").removeClass("fa-solid").addClass("fa-regular");
						$(".board-btn-dislike").next(".thumbs-down-count").text(response.count);
						toggleLike(); 
					}
				});
			} else {
				toggleLike();
			}
		});
		
		$(".board-btn-dislike").on("click", function(){
			if($(".board-btn-like").hasClass("fa-solid")) {
				$.ajax({
					url: "/rest/board/like-action",
					method: "post",
					data: {boardNo : boardNo},
					success: function(response){
						$(".board-btn-like").removeClass("fa-solid").addClass("fa-regular");
						$(".board-btn-like").next(".thumbs-up-count").text(response.count); 
						toggleDislike(); 
					}
				});
			} else {
				toggleDislike();
			}
		});

		function toggleLike() {
			$.ajax({
				url: "/rest/board/like-action",
				method: "post",
				data: {boardNo : boardNo},
				success: function(response){
					$(".board-btn-like").removeClass("fa-regular fa-solid").addClass(response.action ? "fa-solid" : "fa-regular");
					$(".board-btn-like").next(".thumbs-up-count").text(response.count);
				}
			});
		}

		function toggleDislike() {
			$.ajax({
				url: "/rest/board/dislike-action",
				method: "post",
				data: {boardNo : boardNo},
				success: function(response){
					$(".board-btn-dislike").removeClass("fa-regular fa-solid").addClass(response.action ? "fa-solid" : "fa-regular");
					$(".board-btn-dislike").next(".thumbs-down-count").text(response.count);
				}
			});
		}
	});
</script>
</c:if>


<script type="text/javascript">
	$(function(){
		var params = new URLSearchParams(window.location.search);
		var boardNo = params.get("boardNo");
		
		loadList();
		
		// [목록 불러오기 로직]
		function loadList() {
			$(".reply-area").empty();
			
			$.ajax({
				url: "/rest/reply/list",
				method: "post",
				data: {replyOrigin : boardNo},
				success: function(response) {
				    var displayLimit = 15;
					
					for(var i=0; i < response.length; i++) {
						var template = $("#reply-viewer-template").text();
						var html = $.parseHTML(template);
						$(html).attr("data-key", response[i].replyNo);
						
						if (response[i].replyParent) { 
						    $(html).css("margin-left", "50px"); 
						    $(html).find(".profile-wrapper").before(
						        $('<div class="ms-10 me-10" style="display:flex; padding-top:15px;"><i class="fa-solid fa-turn-up fa-rotate-90 gray"></i></div>')
						    );
						    $(html).find(".btn-nested-reply").remove(); 
						}
						
						// 삭제된 댓글 처리
						if(response[i].replyStatus=='Y'){
							$(html).find(".reply-writer").text("(알수없음)").removeClass("writer-name").css("cursor", "default");
							$(html).find(".reply-content").text("(삭제된 댓글입니다)").addClass("gray");
							$(html).find(".button-wrapper").remove();
							$(html).find(".board-writer").remove();
							$(html).find(".reply-btn-like").remove();
							$(html).find(".reply-thumbs-up-count").remove();
							$(html).find(".reply-btn-dislike").remove();
							$(html).find(".reply-thumbs-down-count").remove();
							$(html).find(".reply-image-wrapper").hide(); // 삭제된 댓글 사진 숨김
						} else {
							// 정상 댓글 처리
							$(html).find(".reply-writer").text(response[i].replyWriter).attr("data-id", response[i].replyWriter);
							$(html).find(".reply-thumbs-up-count").text(response[i].replyLikecount);
							$(html).find(".reply-thumbs-down-count").text(response[i].replyDislikecount);
							$(html).find(".reply-content").text(response[i].replyContent);
							
							// ★ 새로 추가된 이미지 렌더링 로직 (정상 댓글에만 적용)
							if (response[i].attachNo != null && response[i].attachNo > 0) {
						        var imageUrl = "/download/modern?attachNo=" + response[i].attachNo;
						        $(html).find(".reply-image").attr("src", imageUrl);
						        $(html).find(".reply-image-wrapper").show(); 
						    } else {
						        $(html).find(".reply-image-wrapper").hide();
						    }

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
						
						var wtime = moment(response[i].replyWtime).fromNow();
						$(html).find(".reply-wtime").text(wtime);
						
						// 권한별 버튼 숨김
						if(response[i].owner == false) {
							$(html).find(".btn-reply-edit").remove();
							$(html).find(".btn-reply-delete").remove();
						}
						if(response[i].writer == false) {
							$(html).find(".board-writer").remove();
						}
						if(${sessionScope.loginId == null}){
							$(html).find(".btn-nested-reply").remove();
						}
						
						if (i >= displayLimit) {
				            $(html).addClass("reply-hidden").hide(); 
				        }

						$(".reply-area").append(html);
					}
					
					// 더보기 토글
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
		
		// [이벤트: 더보기 토글]
		$(".reply-area").on("click", ".btn-reply-toggle", function() {
			var $hiddenReplies = $(".reply-hidden");
			var $icon = $(this).find("i");
			var $text = $(this).find(".toggle-text");
            var hiddenCount = $hiddenReplies.length;

			if ($hiddenReplies.is(":hidden")) {
				$hiddenReplies.slideDown(200);
				$icon.removeClass("fa-chevron-down").addClass("fa-chevron-up");
				$text.text("댓글 접기");
			} else {
				$hiddenReplies.slideUp(200);
				$icon.removeClass("fa-chevron-up").addClass("fa-chevron-down");
				$text.text("댓글 더보기 (" + hiddenCount + "개)");
			}
		});
		
		// [이벤트: 일반 댓글 첨부파일]
		$(".btn-attach-image").on("click", function() {
			$("#reply-file-input").click();
		});

		$("#reply-file-input").on("change", function(e) {
			var file = e.target.files[0];
			if(!file) return; 
			if(!file.type.match("image.*")) {
				alert("이미지 파일만 첨부할 수 있습니다.");
				$(this).val(""); 
				return;
			}
			var reader = new FileReader();
			reader.onload = function(e) {
				$("#preview-img").attr("src", e.target.result);
				$("#reply-image-preview").show(); 
			}
			reader.readAsDataURL(file);
		});

		$(".btn-preview-remove").on("click", function() {
			$("#reply-file-input").val(""); 
			$("#reply-image-preview").hide(); 
			$("#preview-img").attr("src", ""); 
		});

		// [이벤트: 일반 댓글 등록]
		$(".btn-reply").on("click", function(){
			var replyContent = $(".field-reply").val();
			if(replyContent.length == 0) return; 
			
			var formData = new FormData();
			formData.append("replyContent", replyContent);
			formData.append("replyOrigin", boardNo);
			
			var fileInput = $("#reply-file-input")[0];
			if(fileInput.files.length > 0) {
				formData.append("replyImage", fileInput.files[0]); 
			}
			
			$.ajax({
				url: "/rest/reply/write",
				method: "post",
				data: formData,
				processData: false,
				contentType: false,
				success: function(){
					$(".field-reply").val("");
					$("#reply-file-input").val("");
					$("#reply-image-preview").hide();
					loadList(); 
				}
			});
		});
		
		// [이벤트: 대댓글 폼 열기]
		$(".reply-area").on("click", ".btn-nested-reply", function() {
		    var $replyViewer = $(this).closest(".reply-viewer");
		    var isAlreadyOpen = $replyViewer.find(".nested-reply-editor").length > 0;
		    $(".nested-reply-editor").remove();
		    
		    if (isAlreadyOpen) return; 
    
			var parentNo = $replyViewer.data("key");
			var html = `
			    <div class="nested-reply-editor mt-10" style="margin-left: 50px; padding: 10px; background-color: #f9f9f9; border-radius: 5px;">
			        <input type="file" class="nested-file-input" accept="image/*" style="display: none;">
			        <div style="margin-bottom: 10px;"><i class="fa-solid fa-turn-up fa-rotate-90 gray"></i> 대댓글 작성</div>
			        <div class="nested-image-preview" style="display: none; margin-bottom: 10px; position: relative;">
			            <img class="nested-preview-img" src="" style="max-width: 150px; max-height: 150px; border-radius: 5px; border: 1px solid #ccc;">
			            <i class="fa-solid fa-circle-xmark red btn-nested-preview-remove" style="position:absolute; top:-8px; right:-8px; cursor:pointer; font-size:20px; background:white; border-radius:50%;"></i>
			        </div>
			        <textarea class="field w-100 field-nested-reply" rows="2" placeholder="답글을 남겨주세요"></textarea>
			        <div class="right mt-10">
			            <button type="button" class="btn btn-neutral btn-nested-attach-image" style="flex-shrink: 0;"><i class="fa-solid fa-camera"></i> 사진 첨부</button>
			            <button type="button" class="btn btn-neutral btn-nested-cancel">취소</button>
			            <button type="button" class="btn btn-positive btn-nested-save" data-parent="`+parentNo+`">등록</button>
			        </div>
			    </div>
			`;
		    $(this).closest(".reply-viewer").after(html);
		});
		
		// [이벤트: 대댓글 첨부파일]
		$(".reply-area").on("click", ".btn-nested-attach-image", function() {
		    $(this).closest(".nested-reply-editor").find(".nested-file-input").click();
		});

		$(".reply-area").on("change", ".nested-file-input", function(e) {
		    var file = e.target.files[0];
		    if(!file) return;
		    if(!file.type.match("image.*")) {
		        alert("이미지 파일만 첨부할 수 있습니다.");
		        $(this).val(""); 
		        return;
		    }
		    var $editor = $(this).closest(".nested-reply-editor");
		    var reader = new FileReader();
		    reader.onload = function(e) {
		        $editor.find(".nested-preview-img").attr("src", e.target.result);
		        $editor.find(".nested-image-preview").show();
		    }
		    reader.readAsDataURL(file);
		});

		$(".reply-area").on("click", ".btn-nested-preview-remove", function() {
		    var $editor = $(this).closest(".nested-reply-editor");
		    $editor.find(".nested-file-input").val(""); 
		    $editor.find(".nested-image-preview").hide(); 
		    $editor.find(".nested-preview-img").attr("src", ""); 
		});
		
		$(".reply-area").on("click", ".btn-nested-cancel", function() {
		    $(this).closest(".nested-reply-editor").remove();
		});
		
		// [이벤트: 대댓글 등록]
		$(".reply-area").on("click", ".btn-nested-save", function() {
		    var $editor = $(this).closest(".nested-reply-editor");
		    var parentNo = $(this).data("parent");
		    var replyContent = $editor.find(".field-nested-reply").val();
		    
		    if(replyContent.length == 0) return;
		    
		    var formData = new FormData();
		    formData.append("replyContent", replyContent);
		    formData.append("replyOrigin", boardNo);
		    formData.append("replyParent", parentNo);
		    
		    var fileInput = $editor.find(".nested-file-input")[0];
		    if(fileInput.files.length > 0) {
		        formData.append("replyImage", fileInput.files[0]); 
		    }
		    
		    $.ajax({
		        url: "/rest/reply/write",
		        method: "post",
		        data: formData,
		        processData: false,
		        contentType: false,
		        success: function() {
		            loadList(); 
		        }
		    });
		});
		
		// [이벤트: 댓글 삭제, 수정]
		$(".reply-area").on("click", ".btn-reply-delete", function(){
			var choice = window.confirm("정말 삭제하시겠습니까?");
			if(choice == false) return;
			var replyNo = $(this).closest(".reply-viewer").data("key");
			$.ajax({
				url: "/rest/reply/delete",
				method: "post",
				data: { replyNo : replyNo },
				success: function(response){
					loadList();
				}
			});
		});
		
		$(".reply-area").on("click", ".btn-reply-edit", function(){
			$(".reply-editor").prev(".reply-viewer").show();
			$(".reply-editor").remove();
			
			var replyViewer = $(this).closest(".reply-viewer");
			var key = replyViewer.data("key");
			var src = replyViewer.find(".image-profile").attr("src");
			var replyWriter = replyViewer.find(".reply-writer").text();
			var replyContent = replyViewer.find(".reply-content").text();
			var replyWtime = replyViewer.find(".reply-wtime").text();
			
			var template = $("#reply-editor-template").text();
			var html = $.parseHTML(template);
			$(html).attr("data-key", key);
			$(html).find(".image-profile").attr("src", src);
			$(html).find(".reply-writer").text(replyWriter);
			$(html).find(".field-reply-edit").val(replyContent);
			$(html).find(".reply-wtime").text(replyWtime);
			
			$(this).closest(".reply-viewer").hide().after(html);
		});
		
		$(".reply-area").on("click", ".btn-reply-cancel", function(){
			$(this).closest(".reply-editor").prev(".reply-viewer").show();
			$(this).closest(".reply-editor").remove();
		});
		
		$(".reply-area").on("click", ".btn-reply-save", function(){
			var replyNo = $(this).closest(".reply-editor").data("key");
			var replyContent = $(this).closest(".reply-editor").find(".field-reply-edit").val();
			if(replyContent.length == 0) return;
			
			$.ajax({
				url:"/rest/reply/edit",
				method:"post",
				data: { replyNo : replyNo, replyContent: replyContent },
				success: function(){
					loadList();
				}
			});
		});
		
		// [이벤트: 댓글 좋아요 / 싫어요]
		$(".reply-area").on("click", ".reply-btn-like", function(){
			var $thisLikeBtn = $(this);
			var $thisDislikeBtn = $(this).siblings(".reply-btn-dislike");
			var replyNo = $(this).closest(".reply-viewer").data("key");
			
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

		$(".reply-area").on("click", ".reply-btn-dislike", function(){
			var $thisDislikeBtn = $(this);
			var $thisLikeBtn = $(this).siblings(".reply-btn-like");
			var replyNo = $(this).closest(".reply-viewer").data("key");
			
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

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>