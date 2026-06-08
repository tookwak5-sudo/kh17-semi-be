<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<!-- <style>
	table, tr, th, td { border: none !important; border-bottom: 1px solid #ebebeb !important;}
	tr:hover { background-color: #f6f5f5 }
	th,td { height: 37px;}
	th { 
	background-color: #739BED;
	color: white;
	}
	td a { text-decoration: none; }
	td:hover a { text-decoration: underline; }
</style> -->


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
					<th>싫어요</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="boardDto" items="${noticeList}">
					<tr bgcolor="#f6f5f5" style="font-weight: bold;">
						<td>${boardDto.boardNo}</td>
						<td align="left"><c:if test="${boardDto.boardHead != null}">
                    (${boardDto.boardHead})
                </c:if> <a href="./detail?boardNo=${boardDto.boardNo}">${boardDto.boardTitle}</a>

							<c:if test="${boardDto.boardReplycount > 0}">
                    [${boardDto.boardReplycount}]
                </c:if></td>
						<td><c:if test="${boardDto.boardWriter == null}">
                    (탈퇴한 사용자)
                </c:if> <c:if test="${boardDto.boardWriter != null}">
								<a href="/emp/detail?empId=${boardDto.boardWriter}">${boardDto.boardWriter}</a>
							</c:if></td>
						<td>${boardDto.boardWtimeString}</td>
						<td>${boardDto.boardReadcount}</td>
						<td>${boardDto.boardLikecount}</td>
						<td>${boardDto.boardDislikecount}</td>
					</tr>
				</c:forEach>

				<c:forEach var="boardDto" items="${boardList}">
					<tr>
						<td>${boardDto.boardNo}</td>
						<td align="left"><c:if test="${boardDto.boardHead != null}">
                    (${boardDto.boardHead})
                </c:if> <a href="./detail?boardNo=${boardDto.boardNo}">${boardDto.boardTitle}</a>

							<c:if test="${boardDto.boardReplycount > 0}">
                    [${boardDto.boardReplycount}]
                </c:if></td>
						<td><c:if test="${boardDto.boardWriter == null}">
                    (탈퇴한 사용자)
                </c:if> <c:if test="${boardDto.boardWriter != null}">
								<a href="/emp/detail?empId=${boardDto.boardWriter}">${boardDto.boardWriter}</a>
							</c:if></td>
						<td>${boardDto.boardWtimeString}</td>
						<td>${boardDto.boardReadcount}</td>
						<td>${boardDto.boardLikecount}</td>
						<td>${boardDto.boardDislikecount}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<div class="cell mt-40">
		<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
	</div>

	<div class="cell center">
		<form action="./list" method="get">
			<select name="column" class="field">
				<option value="board_title"
					${param.column==bored_title ? "selected" : ""}>제목</option>
				<option value="board_writer"
					${param.column==board_writer ? "selected" : ""}>작성자</option>
			</select> <input type="text" name="keyword" class="field" placeholder="검색어 입력"
				value="${param.keyword}">
			<button type="submit" class="btn btn-positive">
				<i class="fa-solid fa-magnifying-glass"></i> <span>검색</span>
			</button>
		</form>
	</div>
</div>



<!-- 페이지네이션 -->

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>