<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-1200 mt-50 mb-50">

    <div class="cell center mb-0">
        <h1 class="mb-0">결재 양식 관리</h1>
    </div>

    <div class="cell center">
        사원들이 결재 기안 시 사용할 서식 양식을 등록하고 관리하는 페이지입니다.
    </div>

    <div class="cell right">
        <c:if test="${sessionScope.loginId != null}">
            <a href="./insert" class="btn btn-neutral">
                <i class="fa-solid fa-plus"></i> 신규 양식 등록하기
            </a>
        </c:if>
    </div>

    <div class="cell right">
       ${pageVO.getBeginRownum()}-${pageVO.getEndRownum()} / 총 ${pageVO.count}개의 양식
    </div>

    <div class="cell">
        <table class="table">
            <thead>
                <tr>
                    <th>양식번호</th>
                    <th>구분</th>
                    <th class="w-40">양식명</th>
                    <th>사용여부</th>
                    <th>최종수정일</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="formDto" items="${list}">
                <tr>
                    <td>${formDto.formNo}</td>
                    <td>
                        <c:if test="${formDto.headName != null}">
                            [${formDto.headName}]
                        </c:if>
                    </td>
                    <td align="left">
                        <a href="./detail?formNo=${formDto.formNo}">
                            ${formDto.formName}
                        </a>
                    </td>
                    <td>
                        <c:if test="${formDto.formUseYn == 'Y'}">사용중</c:if>
                        <c:if test="${formDto.formUseYn == 'N'}">미사용</c:if>
                    </td>
                    <td>${formDto.formWtime}</td>
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
                <option value="form_name" ${param.column == 'form_name' ? 'selected' : ''}>양식명</option>
                <option value="form_head" ${param.column == 'form_head_no' ? 'selected' : ''}>구분(업무/비용 등)</option>
<!--             	head_type 넣어야합니다. -->
            </select>
            <input type="text" name="keyword" class="field" placeholder="검색어 입력" value="${param.keyword}">
            <button type="submit" class="btn btn-positive">
                <i class="fa-solid fa-magnifying-glass"></i>
                <span>검색</span>
            </button>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>