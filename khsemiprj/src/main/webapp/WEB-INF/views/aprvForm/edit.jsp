<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-800 mt-50 mb-50">

    <div class="cell mb-40">
        <h1 style="font-size: 36px; font-weight: bold; color: #333;">결재양식 수정</h1>
    </div>

    <form action="./edit" method="post" enctype="multipart/form-data">
        
        <div class="cell mb-10">
            <label class="font-bold" style="color: #666;">양식 분류</label>
        </div>
        <div class="cell mb-20">
            <select name="formHead" class="input w-100" style="padding: 10px; border: 1px solid #ccc;">
                <option value="연차" <c:if test="${aprvFormDto.formHead == '연차'}">selected</c:if>>연차</option>
                <option value="병가" <c:if test="${aprvFormDto.formHead == '병가'}">selected</c:if>>병가</option>
                <option value="업무" <c:if test="${aprvFormDto.formHead == '업무'}">selected</c:if>>업무</option>
                <option value="비용" <c:if test="${aprvFormDto.formHead == '비용'}">selected</c:if>>비용</option>
                <option value="기타" <c:if test="${aprvFormDto.formHead == '기타'}">selected</c:if>>기타</option>
            </select>
        </div>

        <div class="cell mb-10">
            <label class="font-bold" style="color: #666;">양식 번호</label>
        </div>
<!--         pk라 리드온리 있습니다. -->
        <div class="cell mb-20">
            <input type="number" name="formNo" value="${aprvFormDto.formNo}" class="input w-100" readonly style="background-color: #f8f9fa; border: 1px solid #ccc; padding: 10px;">
        </div>

        <div class="cell mb-10">
            <label class="font-bold" style="color: #666;">양식명</label>
        </div>
        <div class="cell mb-20">
            <input type="text" name="formName" value="${aprvFormDto.formName}" class="input w-100" required style="border: 1px solid #ccc; padding: 10px;">
        </div>

        <div class="cell mb-10">
            <label class="font-bold" style="color: #666;">양식 설명</label>
        </div>
        <div class="cell mb-20">
            <textarea name="formExplain" class="input w-100" required style="min-height: 150px; resize: vertical; border: 1px solid #ccc; padding: 10px;">${aprvFormDto.formExplain}</textarea>
        </div>

        <div class="cell mb-20 flex-area" style="align-items: center;">
            <label class="font-bold" style="color: #666; margin-right: 20px;">양식 사용 여부</label>
            <input type="checkbox" name="formUseYn" value="Y" <c:if test="${aprvFormDto.formUseYn == 'Y'}">checked</c:if>>
        </div>

        <div class="cell mb-10">
            <label class="font-bold" style="color: #666;">첨부</label>
            <c:if test="${attachNo != null}">
                <span style="font-size: 13px; color: #ff1744; margin-left: 10px;">(※ 새 파일을 첨부하면 기존 파일은 삭제되고 덮어씌워집니다.)</span>
            </c:if>
        </div>
        <div class="cell mb-40">
            <c:if test="${attachNo != null}">
                <input type="hidden" name="attachNo" value="${attachNo}">
            </c:if>
            <input type="file" name="attach" class="input w-100" style="border: 1px solid #ccc; padding: 5px;">
        </div>

        <div class="cell right">
            <button type="submit" class="btn" style="background-color: #556b82; color: white; border: none; padding: 10px 30px; font-size: 16px;">수정하기</button>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>