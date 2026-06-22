<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<style>
	.reply-viewer, .reply-editor { display:flex; padding:15px; box-shadow: 0 0 0 1px lightgray; }
	.reply-viewer > .profile-wrapper, .reply-editor > .profile-wrapper { width:34px; flex-shrink: 0; }
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
		<div class="content-wrapper ms-20">
			<div class="flex-area">
				<div class="image-circle image-profile" style="width: 34px; height: 34px; flex-shrink: 0; margin-right: 10px;">
				</div>
				<div class="w-200">
					<h3 class="mt-0 mb-0">
						<span class="reply-writer writer-name" style="cursor: pointer;">아이디</span>
						<span class="board-writer" style="color: #f94b4b">(작성자)</span>
					</h3>
					<div class="w-50">
						<span class="gray reply-wtime">yyyy-MM-dd HH:mm</span>
					</div>
				</div>
				<div style="margin-left : auto">
					<i class="fa-regular fa-thumbs-up blue reply-btn-like"></i>
					<span class="reply-thumbs-up-count">0</span>
					<i class="fa-regular fa-thumbs-down red reply-btn-dislike"></i>
					<span class="reply-thumbs-down-count">0</span>
				</div>
			</div>
			
			<div class="reply-image-wrapper mt-10" style="display: none;">
				<img class="reply-image" src="" style="max-width: 200px; max-height: 200px; border-radius: 5px; border: 1px solid #ccc;">
			</div>
			
			<pre class="mt-10 mb-0 reply-content">내용 샘플</pre>
			
			<div class="flex-area"> 
				<div class="button-wrapper" style="margin-left: auto">
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

<div class="container w-100 mt-20 mb-50 background-card">
	<div class="cell">
		<div class="flex-area" style="align-items: end">
			<div>
				<h1 class="mt-0 mb-0">
					<c:if test="${boardDto.boardHead != null}">(${boardDto.boardHead})</c:if>
					${boardDto.boardTitle}
					<c:if test="${boardDto.boardEtime != null}">(수정됨)</c:if>
				</h1>
			</div>
		</div>
	</div>

	<div class="cell mt-20 flex-area">
		<div class="ms-10">
			<c:if test="${boardDto.boardWriter == null}">(탈퇴한사용자)</c:if>
			<c:if test="${boardDto.boardWriter != null}">
				<span class="writer-name" data-id="${boardDto.boardWriter}" style="cursor: pointer; font-weight: bold;">
					${boardDto.boardWriter}
				</span>
			</c:if>
		</div>
		<div class="ms-200" style="margin-left: auto;"><fmt:formatDate value="${boardDto.boardWtime}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate></div>
		<div class="ms-20">조회수 ${boardDto.boardReadcount}</div>
	</div>

	<hr>
	<div class="cell" style="min-height:300px">
    	<div class="board-content-area">${boardDto.boardContent}</div>
	</div>

	<div class="cell mt-20 flex-area">
		<div>
			좋아요 
			<i class="fa-solid fa-thumbs-up blue board-btn-like"></i>
			<span class="thumbs-up-count">?</span>
		</div>
		<div class="ms-20">
			싫어요 
			<i class="fa-regular fa-thumbs-down red board-btn-dislike"></i>
			<span class="thumbs-down-count">?</span>
		</div>
		<div class="ms-20">
			댓글 <span class="reply-count-text"> ${boardDto.boardReplycount}</span>
		</div>
	</div>

	<div class="cell reply-area"></div>

<c:if test="${sessionScope.loginId != null}">
		<div class="cell mt-20">
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
					<i class="fa-solid fa-pen"></i>
					<span>댓글 작성하기</span>
				</button>
			</div>
		</div>
	</c:if>

	<c:if test="${sessionScope.loginId == null}">
		<div class="cell mt-20">
			<h3>댓글 작성을 원하시면 <a href="/emp/login">로그인</a>하세요</h3>
		</div>
	</c:if>


	<hr>
	
		<div class="cell" style="margin-top: 10px; margin-bottom: 10px;">
			<span class="blue me-20" style="display: inline-block; color: white; padding: 4px 8px; border-radius: 3px; font-size: 12px; font-weight: bold;">다음글</span>
			<c:if test="${param.column!=null || param.boardHead!=null}">
			<a href="./detail?boardNo=${nextBoardDto.boardNo}&column=${param.column}&keyword=${param.keyword}" class="link">${nextBoardDto.boardTitle}</a>
			</c:if>
			<c:if test="${param.column==null && param.boardHead==null}">
			<a href="./detail?boardNo=${nextBoardDto.boardNo}" class="link">${nextBoardDto.boardTitle}</a>
			</c:if>
		</div>
		
		<div class="cell" style="margin-bottom: 10px;">
			<span class="blue me-20" style="display: inline-block; color: black; padding: 4px 8px; border-radius: 3px; font-size: 12px; font-weight: bold;">이전글</span> 
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
			<a class="btn btn-negative" onclick="deleteCheck();">삭제</a>
		</c:if>
		
		<c:if test="${param.column == null && param.boardHead == null}">
			<a class="btn btn-neutral" href="./list">목록으로</a>
		</c:if>
		<c:if test="${param.column != null || param.boardHead != null}">
			<a class="btn btn-neutral" href="./list?boardHead=${param.boardHead}&column=${param.column}&keyword=${param.keyword}">목록으로</a>
		</c:if>
	</div>
</div>


<!-- 닉네임 클릭 시 나타날 창 -->
<div id="user-context-menu" style="display: none;">
    <a href="#" id="link-view-posts">
        <i class="fa-solid fa-magnifying-glass"></i> 작성 글 보기
    </a>
    <a href="#"  id="link-send-memo"
			onclick="
				var w = 650; 
				var h = 650; 
				var left = (screen.width/2) - (w/2); 
				var top = (screen.height/2) - (h/2); 
				window.open(this.href, 'memoListPopup', 'width='+w+',height='+h+',top='+top+',left='+left+',scrollbars=yes,resizable=no'); 
				return false;">
        <i class="fa-solid fa-paper-plane"></i> 쪽지 보내기
    </a>
</div>


<script type="text/javascript">

	function deleteCheck() {
		openConfirm('게시글을 삭제하시겠습니까?', 'location.href="./delete?boardNo='+${boardDto.boardNo}+'";');
	}
	
	function deleteReply(replyNo) {
		$.ajax({
			url: "/rest/reply/delete",
			method: "post",
			data: { replyNo : replyNo },
			success: function(response){
				loadList();
			}
		});
	}

	$(function(){
    	$(document).on("click", ".writer-name", function(e) {
	        e.stopPropagation(); 
    	    var memberId = $(this).data("id");
        	if(!memberId) return; 

        	var searchUrl = "/board/list?column=board_writer&keyword=" + memberId;
        	$("#link-view-posts").attr("href", searchUrl);
        	
        	var memoUrl = "/memo/write?memoSenderId=" + memberId;
        	$("#link-send-memo").attr("href", memoUrl);

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
	var params = new URLSearchParams(window.location.search);
	var boardNo = params.get("boardNo");
		
		
		//목록 불러오기 로직
		function loadList() {
			$(".reply-area").empty();
			
			$.ajax({
				url: "/rest/reply/list",
				method: "post",
				data: {replyOrigin : boardNo},
				success: function(response) {
				    
				    var displayLimit = 15; 
				    var totalValidCount = response.filter(function(r) { return r.replyStatus !== 'Y'; }).length;
				    
				    var currentChunkContainer = null; 
				    var chunkIndex = 0;         
				    var validCounter = 0;       
				    var globalValidCounter = 0;
				    var maxChunkIndex = Math.max(0, Math.ceil(totalValidCount / displayLimit) - 1);
					
					for(var i=0; i < response.length; i++) {
					    if (currentChunkContainer === null || (validCounter === displayLimit && globalValidCounter < totalValidCount)) {
					        if (currentChunkContainer !== null) {
					            chunkIndex++;
					            validCounter = 0; 
					        }
					        var startNum = chunkIndex * displayLimit + 1;
					        var endNum = Math.min((chunkIndex + 1) * displayLimit, totalValidCount);
					        var isOpen = (chunkIndex === maxChunkIndex);
					        var iconClass = isOpen ? "fa-minus" : "fa-plus";
					        var displayStyle = isOpen ? "block" : "none";
					        
					        if (totalValidCount > displayLimit) {
								if(chunkIndex!=maxChunkIndex){
						       		var chunkHeader = `
										<div class="reply-chunk-header" data-target="chunk-` + chunkIndex + `" style="border: 1px solid #ddd; padding: 12px 15px; margin-bottom: -1px; cursor: pointer; display: flex; justify-content: space-between; align-items: center; background-color: #fbfbfb; border-radius: 3px;">
											<span style="font-weight: bold; font-size: 14px; color: #333;">` + startNum + ` ~ ` + endNum + ` 번째 댓글</span>
											<i class="fa-solid ` + iconClass + `" style="color: #666;"></i>
										</div>
									`;
								} else{
									var chunkHeader = `
						                <div class="reply-chunk-header" data-target="chunk-` + chunkIndex + `" style="border: 1px solid #ddd; padding: 12px 15px; margin-bottom: -1px; cursor: pointer; display: flex; justify-content: space-between; align-items: center; background-color: #fbfbfb; border-radius: 3px;">
						                    <span style="font-weight: bold; font-size: 14px; color: #333;">` + startNum + ` ~  번째 댓글</span>
						                    <i class="fa-solid ` + iconClass + `" style="color: #666;"></i>
						                </div>
						            `;
								}
								
					            $(".reply-area").append(chunkHeader);
					        }
					        currentChunkContainer = $(`<div id="chunk-` + chunkIndex + `" class="reply-chunk-container" style="display: ` + (totalValidCount > displayLimit ? displayStyle : 'block') + `; margin-bottom: 20px;"></div>`);
					        $(".reply-area").append(currentChunkContainer);
					    }
					    
						var template = $("#reply-viewer-template").text().trim();
						var html = $(template);
						$(html).attr("data-key", response[i].replyNo);
						
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
							$(html).find(".reply-image-wrapper").hide(); 
						} else {
						    // 정상 댓글 처리
							if (response[i].profileAttachNo != null && response[i].profileAttachNo > 0) {
							    var profileUrl = "/download/modern?attachNo=" + response[i].profileAttachNo;
							    $(html).find(".image-profile").attr("src", profileUrl);
							} else {
								var blankWhiteSvg = "data:image/svg+xml;charset=UTF-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%221%22%20height%3D%221%22%3E%3Crect%20width%3D%22100%25%22%20height%3D%22100%25%22%20fill%3D%22white%22%2F%3E%3C%2Fsvg%3E";
							    $(html).find(".image-profile")
							           .attr("src", blankWhiteSvg)
							           .css("background-color", "white")
							           .css("border", "1px solid #e0e0e0");
							}
							$(html).find(".reply-writer").text(response[i].replyWriter).attr("data-id", response[i].replyWriter);
							$(html).find(".reply-thumbs-up-count").text(response[i].replyLikecount);
							$(html).find(".reply-thumbs-down-count").text(response[i].replyDislikecount);
							$(html).find(".reply-content").text(response[i].replyContent);
							
							if (response[i].attachNo != null && response[i].attachNo > 0) {
						        var imageUrl = "/download/modern?attachNo=" + response[i].attachNo;
						        $(html).find(".reply-image").attr("src", imageUrl);
						        $(html).find(".reply-image-wrapper").show(); 
						    } else {
						        $(html).find(".reply-image-wrapper").hide();
						    }

							if (response[i].empLiked=='Y') {
					    		$(html).find(".reply-btn-like").removeClass("fa-regular").addClass("fa-solid");
					    	} else {
					    		$(html).find(".reply-btn-like").removeClass("fa-solid").addClass("fa-regular");
					    	}
					    	if (response[i].empDisliked=='Y') {
					    		$(html).find(".reply-btn-dislike").removeClass("fa-regular").addClass("fa-solid");
					    	} else {
					    		$(html).find(".reply-btn-dislike").removeClass("fa-solid").addClass("fa-regular");
					    	}
					    	validCounter++;
					    	globalValidCounter++;
						}
						
						var wtime = moment(response[i].replyWtime).fromNow();
						$(html).find(".reply-wtime").text(wtime);
						
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
						
						if (response[i].replyParent) { 
						    $(html).find(".btn-nested-reply").remove(); 
						    $(html).css({
						        /* "padding-left": "60px", */
						        "position": "relative"
						    }); 
						    var arrowHtml = `
						        <div class="nested-reply-arrow" style="position: absolute; left: 20px; top: 25px;">
						            <i class="fa-solid fa-turn-up fa-rotate-90 gray" style="font-size: 20px;"></i>
						        </div>
						    `;
						    var wrapper = $(`
						        <div style="display: flex; margin-bottom: 10px;">
						            <div style="width: 50px; flex-shrink: 0; text-align: right; padding-top: 15px; padding-right: 15px;">
						                <i class="fa-solid fa-turn-up fa-rotate-90 gray" style="font-size: 20px;"></i>
						            </div>
						            <div style="flex-grow: 1;"></div>
						        </div>
						    `);
						    wrapper.find("div:last-child").append(html);
						    currentChunkContainer.append(wrapper);
						} else {
						    currentChunkContainer.append(html);
						}
					}
				}
			});
		}
	$(function(){
		loadList();
		
		//이벤트: 인벤 스타일 아코디언 그룹 토글
		$(".reply-area").on("click", ".reply-chunk-header", function() {
		    // 내가 누른 헤더가 담당하는 그룹 박스 ID
			var targetId = $(this).data("target");
			var $container = $("#" + targetId);
			var $icon = $(this).find("i");

            // 숨겨져 있으면 열면서 아이콘을 - 로 변경
			if ($container.is(":hidden")) {
				$container.slideDown(200);
				$icon.removeClass("fa-plus").addClass("fa-minus");
			} 
			// 열려있으면 닫으면서 아이콘을 + 로 변경
			else {
				$container.slideUp(200);
				$icon.removeClass("fa-minus").addClass("fa-plus");
			}
		});
	
		//이벤트: 일반 댓글 첨부파일
		$(".btn-attach-image").on("click", function() {
			$("#reply-file-input").click();
		});

		$("#reply-file-input").on("change", function(e) {
			var file = e.target.files[0];
			if(!file) return; 
			if(!file.type.match("image.*")) {
				openAlert("이미지 파일만 첨부할 수 있습니다.");
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

		//이벤트: 일반 댓글 등록
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
		
		//이벤트: 대댓글 폼 열기
		$(".reply-area").on("click", ".btn-nested-reply", function() {
		    var $replyViewer = $(this).closest(".reply-viewer");
		    var isAlreadyOpen = $replyViewer.next(".nested-reply-editor").length > 0;
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
				        <div class="mt-10" style="display: flex; justify-content: space-between; align-items: center;">
				            <div>
				                <button type="button" class="btn btn-neutral btn-nested-attach-image" style="flex-shrink: 0;">
				                    <i class="fa-solid fa-camera"></i> 사진 첨부
				                </button>
				            </div>
			            <div>
			                <button type="button" class="btn btn-neutral btn-nested-cancel">취소</button>
			                <button type="button" class="btn btn-positive btn-nested-save" data-parent="`+parentNo+`">등록</button>
			            </div>
			        </div>
			    </div>
			`;
		    $(this).closest(".reply-viewer").after(html);
		});
		
		//이벤트: 대댓글 첨부파일
		$(".reply-area").on("click", ".btn-nested-attach-image", function() {
		    $(this).closest(".nested-reply-editor").find(".nested-file-input").click();
		});

		$(".reply-area").on("change", ".nested-file-input", function(e) {
		    var file = e.target.files[0];
		    if(!file) return;
		    if(!file.type.match("image.*")) {
		        openAlert("이미지 파일만 첨부할 수 있습니다.");
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
		
		//이벤트: 대댓글 등록
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
		
		//이벤트: 댓글 삭제, 수정
 		$(".reply-area").on("click", ".btn-reply-delete", function(){
			var replyNo = $(this).closest(".reply-viewer").data("key");
			openConfirm("정말 삭제하시겠습니까?", 'deleteReply('+replyNo+');');
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
		
		//이벤트: 댓글 좋아요 / 싫어요
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