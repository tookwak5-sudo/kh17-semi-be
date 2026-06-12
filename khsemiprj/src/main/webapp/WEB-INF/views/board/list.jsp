	<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<style>
	/* table, tr, th, td { border: none !important; border-bottom: 1px solid #ebebeb !important;}
	tr:hover { background-color: #f6f5f5 }
	th,td { height: 37px;}
	th { 
	background-color: #739BED;
	color: white;
	}
	td a { text-decoration: none; }
	td:hover a { text-decoration: underline; } */
	
	
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
</style>

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


<div class="container w-1200 mt-50 mb-50">

	<div class="cell center mb-0">
		<h1 class="mb-0">자유 게시판</h1>
	</div>

	<div class="cell center">타인에 대한 무분별한 비방글은 예고 없이 삭제될 수 있습니다.</div>

	<div class="cell right">
		<c:if test="${sessionScope.loginId != null}">
			<a href="write" class="btn btn-neutral">신규 글 등록하기</a>
		</c:if>
	</div>

	<div class="cell right">
		${pageVO.getBeginRownum()}-${pageVO.endRownum} / 총 ${pageVO.count}개의 글
	</div>

	<div class="cell">
		<table class="table">
			<thead>
				<tr>
					<th>번호</th>
					<th class="w-40">제목</th>
					<th>작성자</th>
					<th>작성일</th>
					<th>조회수</th>
					<th>좋아요</th>
				<!-- 	<th>싫어요</th> -->
				</tr>
			</thead>
			<tbody>
				<c:forEach var="boardDto" items="${noticeList}">
					<tr bgcolor="#f6f5f5" style="font-weight: bold;">
						<td>${boardDto.boardNo}</td>
						<td align="left"><c:if test="${boardDto.boardHead != null}">
                    (${boardDto.boardHead})
                </c:if> <a href="./detail?boardNo=${boardDto.boardNo}">${boardDto.boardTitle}
                <c:if test="${boardDto.boardReplycount > 0}">
                    [${boardDto.boardReplycount}]
                </c:if> 
                </a>

							</td>
						<td><c:if test="${boardDto.boardWriter == null}">
                    (탈퇴한 사용자)
                </c:if> <c:if test="${boardDto.boardWriter != null}">
								<span class="writer-name" data-id="${boardDto.boardWriter}" style="cursor: pointer; font-weight: bold;">
    								${boardDto.boardWriter}
								</span>
							</c:if></td>
						<td>${boardDto.boardWtimeString}</td>
						<td>${boardDto.boardReadcount}</td>
						<td>${boardDto.boardLikecount}</td>
						<%-- <td>${boardDto.boardDislikecount}</td> --%>
					</tr>
				</c:forEach>

				<c:forEach var="boardDto" items="${boardList}">
					<tr>
						<td>${boardDto.boardNo}</td>
						<td align="left"><c:if test="${boardDto.boardHead != null}">
                    (${boardDto.boardHead})
                </c:if> 
                <c:if test="${param.column!=null }">
                <a href="./detail?boardNo=${boardDto.boardNo}&column=${param.column}&keyword=${param.keyword}">${boardDto.boardTitle}
                <c:if test="${boardDto.boardReplycount > 0}">
                    [${boardDto.boardReplycount}]
                </c:if></a>
				</c:if>
				 <c:if test="${param.column==null }">
                <a href="./detail?boardNo=${boardDto.boardNo}">${boardDto.boardTitle}
                <c:if test="${boardDto.boardReplycount > 0}">
                    [${boardDto.boardReplycount}]
                </c:if></a>
				</c:if>
							</td>
						<td><c:if test="${boardDto.boardWriter == null}">
                    (탈퇴한 사용자)
                </c:if> 
                <c:if test="${boardDto.boardWriter != null}">
						<span class="writer-name" data-id="${boardDto.boardWriter}" style="cursor: pointer; font-weight: bold;">
  						  	${boardDto.boardWriter}
						</span>
							</c:if></td>
						<td>${boardDto.boardWtimeString}</td>
						<td>${boardDto.boardReadcount}</td>
						<td>${boardDto.boardLikecount}</td>
						<%-- <td>${boardDto.boardDislikecount}</td> --%>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
<!-- 페이지네이션 -->
	<div class="cell mt-40">
		<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
	</div>
	<div class="cell center">
		<form action="./list" method="get">
			<select name="column" class="field">
				<option value="board_title"
					${param.column=='board_title' ? "selected" : ""}>제목</option>
				<option value="board_writer"
					${param.column=='board_writer' ? "selected" : ""}>작성자</option>
			</select> <input type="text" name="keyword" class="field-sm" placeholder="검색어 입력"
				value="${param.keyword}">
			<button type="submit" class="btn btn-positive">
				<i class="fa-solid fa-magnifying-glass"></i> <span>검색</span>
			</button>
		</form>
	</div>
</div>

<!-- 닉네임 클릭 시 나타날 창 -->
<div id="user-context-menu" style="display: none;">
    <a href="#" id="link-view-posts">
        <i class="fa-solid fa-magnifying-glass"></i> 작성 글 보기
    </a>
</div>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>