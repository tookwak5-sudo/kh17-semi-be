<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-800 mt-50 mb-50">

	<div class="cell mb-40">
		<h1 style="font-size: 36px; font-weight: bold; color: #333;">결재양식
			수정</h1>
	</div>

	<form action="./edit" method="post" enctype="multipart/form-data">

		<div class="cell mb-10">
			<label class="font-bold" style="color: #666;">양식 분류</label>
		</div>
		<div class="cell mb-20">

			<div class="cell mb-20">

				<select name="head_name" class="input w-100"
					style="border: 1px solid #ccc; padding: 10px;">
					<c:forEach var="headName" items="${headList}">
						<option value="${headName}"
							${findHeadName.headName == headName ? 'selected' : ''}>
							${headName}</option>
					</c:forEach>
				</select> <select name="head_type" class="input w-100"
					style="border: 1px solid #ccc; padding: 10px; margin-top: 10px;">
					<c:forEach var="headType" items="${typeList}">
						<option value="${headType}"
							${findHeadType.headType == headType ? 'selected' : ''}>
							${headType}</option>
					</c:forEach>
				</select>

			</div>
		</div>


		<!--         pk라 리드온리 있습니다. -->
		<div class="cell mb-20">
			<input type="hidden" name="formNo" value="${aprvFormDto.formNo}"
				class="input w-100" readonly
				style="background-color: #f8f9fa; border: 1px solid #ccc; padding: 10px;">
		</div>

		<div class="cell mb-10">
			<label class="font-bold" style="color: #666;">양식명</label>
		</div>
		<div class="cell mb-20">
			<input type="text" name="formName" value="${aprvFormDto.formName}"
				class="input w-100" required
				style="border: 1px solid #ccc; padding: 10px;">
		</div>

		<div class="cell mb-10">
			<label class="font-bold" style="color: #666;">양식 설명</label>
		</div>
		<div class="cell mb-20">
			<textarea name="formExplain" class="input w-100" required
				style="min-height: 150px; resize: vertical; border: 1px solid #ccc; padding: 10px;">${aprvFormDto.formExplain}</textarea>
		</div>

		<div class="cell mb-20 flex-area" style="align-items: center;">
			<label class="font-bold" style="color: #666; margin-right: 20px;">양식
				사용 여부</label> <input type="checkbox" name="formUseYn" value="Y"
				<c:if test="${aprvFormDto.formUseYn == 'Y'}">checked</c:if>>
		</div>

		<div class="cell mb-10">
			<label class="font-bold" style="color: #666;">첨부</label>
			<c:if test="${attachNo != null}">
				<span style="font-size: 13px; color: #ff1744; margin-left: 10px;">(※
					새 파일을 첨부하면 기존 파일은 삭제되고 덮어씌워집니다.)</span>
			</c:if>
		</div>
		<div class="cell mb-40">
			<c:if test="${attachNo != null}">
				<input type="hidden" name="attachNo" value="${attachNo}">
			</c:if>
			<input type="file" name="attach" class="input w-100"
				style="border: 1px solid #ccc; padding: 5px;">
		</div>

		<div class="cell right">
			<button type="submit" class="btn"
				style="background-color: #556b82; color: white; border: none; padding: 10px 30px; font-size: 16px;">수정하기</button>
		</div>
	</form>


</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>