<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<script type="text/javascript">
      $(function(){
              var picker8 = new Lightpick({
              field: $(".picker-8-1")[0],
              secondField : $(".picker-8-2")[0],
              singleDate : false, //범위선택으로 변경
              format : "YYYY-MM-DD",
              firstDay : 7 ,
              numberOfMonths : 2, //2달 표시한다
              numberOfColumns : 2, //한 줄에 2칸 표시
              selectForward : true, //최초 선택날짜 이후로만 선택가능
              minDays : 1, //최소 선택기간(일)
              //maxDays : 8, //최대 선택기간(일)
          });
      });
</script>

<form action="./insert" autocomplete="off" method="post" class="form-check">
<input type="hidden" name="planNo" value="${planDto.planNo}">
	<div class="container w-600 mt-50">
		
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
    </div>
</form>
	
<jsp:include page="/WEB-INF/views/template/footer.jsp"/>