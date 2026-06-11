<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<form action="./insert" method="post" enctype="multipart/form-data">

	<div class="container w-950 mt-50 mb-50">
		<div class="cell">
			<h1 class="mt-0 mb-0">결재 양식 신규 등록</h1>
		</div>
		<div class="cell">전자결재 기안 시 직원들이 사용할 새로운 양식을 등록합니다.</div>

		<div class="cell mt-40">
			<label>양식명 <i class="fa-solid fa-asterisk red"></i></label> <input
				type="text" name="formName" required class="field w-100"
				placeholder="예: 연차 신청서">
		</div>

		<div class="cell mb-0 mt-20">
			<label>구분</label>
		</div>
		<div class="cell mb-20">

				<select name="head_name" class="input w-100"
					style="border: 1px solid #ccc; padding: 10px;">
					<c:forEach var="headName" items="${headList}">
						<option value="${headName}"
							${headList.headName == headName ? 'selected' : ''}>
							${headName}</option>
					</c:forEach>
				</select> <select name="head_type" class="input w-100"
					style="border: 1px solid #ccc; padding: 10px; margin-top: 10px;">
					<c:forEach var="headType" items="${typeList}">
						<option value="${headType}"
							${typeList.headType == headType ? 'selected' : ''}>
							${headType}</option>
					</c:forEach>
				</select>

		</div>

		<div class="cell mb-0 mt-20">
			<label>사용 여부</label>
		</div>
		<div class="cell mt-0">
			<input type="checkbox" name="formUseYn" value="Y">
		</div>

		<div class="cell mt-20">
			<label>양식 설명 <i class="fa-solid fa-asterisk red"></i></label>
			<textarea name="formExplain" rows="10" required class="field w-100"
				placeholder="양식에 대한 구체적인 설명을 입력하세요"></textarea>
		</div>

		<div class="cell mt-20">
			<label>양식 파일 첨부 (hwp, docx 등)</label> <input type="file"
				name="attach" class="field w-100">
		</div>

		<div class="cell mt-50 right">
			<a href="./list" class="btn btn-neutral"> <i
				class="fa-solid fa-list"></i> <span>목록으로 이동</span>
			</a>
			<button type="submit" class="btn btn-positive">
				<i class="fa-solid fa-floppy-disk"></i> <span>양식 등록하기</span>
			</button>
		</div>
	</div>

</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>