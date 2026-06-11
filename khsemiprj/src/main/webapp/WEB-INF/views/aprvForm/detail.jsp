<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
        .emp-info-card {
            background-color: #ffffff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 10px 30px;
        }
        .emp-info-row {
            display: flex;
            align-items: center;
            padding: 16px 0;
            border-bottom: 1px solid #f1f3f5;
        }
        .emp-info-row:last-child {
            border-bottom: none;
        }
        .emp-info-label {
            width: 25%;
            font-weight: 600;
            color: #495057;
            position: relative;
            padding-left: 14px;
            letter-spacing: -0.5px;
        }
        .emp-info-label::before {
            content: "";
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 4px;
            height: 14px;
            background-color: #739BED;
            border-radius: 2px;
        }
        .emp-info-value {
            width: 75%;
            color: #343a40;
            font-weight: 500;
        }
        .emp-info-value.point-color {
            color: #739BED;
            font-weight: 600;
        }
</style>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-800 mt-50 mb-50">

    <div class="cell mb-40">
        <h1 style="font-size: 36px; font-weight: bold; color: #333;">${aprvFormSelectVO.formName}</h1>
    </div>

    <div class="cell mb-10">
        <span class="font-bold" style="color: #666;">양식 기본정보</span>
    </div>
    
    
    
    
    
    
    
    <form action="edit" method="post" id="editForm">
		<input type="hidden" name="empId" value="${empDto.empId}">
		
		<div class="cell mt-40 emp-info-card">
			<div class="emp-info-row">
				<div class="emp-info-label">양식번호</div>
				<div class="emp-info-value point-color">${aprvFormSelectVO.formNo}</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">대분류</div>
				<div class="emp-info-value point-color">${aprvFormSelectVO.headType}</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">양식분류</div>
				<div class="emp-info-value point-color"><c:if test="${aprvFormSelectVO.headName != null}">${aprvFormSelectVO.headName}</c:if></div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">작성일</div>
					<div class="emp-info-value point-color">
						<fmt:formatDate value="${aprvFormSelectVO.formWtime}" pattern="yyyy-MM-dd HH:mm"/>
					</div>
			</div>
			
			<div class="emp-info-row">
				<div class="emp-info-label">사용 여부</div>
				<div class="emp-info-value point-color">
					<c:if test="${aprvFormSelectVO.formUseYn == 'Y'}">사용</c:if>
                    <c:if test="${aprvFormSelectVO.formUseYn == 'N'}">미사용</c:if>
                </div>
			</div>
		</div>
	</form>
    
    <div class="cell mb-10">
        <span class="font-bold" style="color: #666;">양식 설명</span>
    </div>
    <div class="cell mb-40" style="border: 1px solid #ccc; padding: 20px; border-radius: 5px; min-height: 100px; white-space: pre-wrap; line-height: 1.6;">${aprvFormSelectVO.formExplain}</div>

    <div class="cell mb-10">
        <span class="font-bold" style="color: #666;">양식 파일</span>
    </div>
    <div class="cell mb-50">
        <c:if test="${attachNo != null}">
            <a href="/download/legacy?attachNo=${attachNo}" style="display: inline-block; border: 1px solid #333; background: white; color: black; padding: 5px 15px; text-decoration: none; border-radius: 3px; font-size: 14px;">
                첨부파일 다운로드
            </a>
        </c:if>
        <c:if test="${attachNo == null}">
            <span style="color: #999;">등록된 양식 파일이 없습니다.</span>
        </c:if>
    </div>

    <div class="cell right">
        <c:if test="${sessionScope.loginId != null}">
            <a href="./edit?formNo=${aprvFormSelectVO.formNo}" class="btn btn-positive">수정하기</a>
            
            <a href="./delete?formNo=${aprvFormSelectVO.formNo}" class="btn btn-negative" onclick="return confirm('정말 이 결재 양식을 삭제하시겠습니까?');">삭제하기</a>
        </c:if>

        <a href="./list" class="btn btn-neutral">목록</a>
    </div>

</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>