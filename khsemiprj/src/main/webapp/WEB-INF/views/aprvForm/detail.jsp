<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-800 mt-50 mb-50">

    <div class="cell mb-40">
        <h1 style="font-size: 36px; font-weight: bold; color: #333;">${aprvFormDto.formName}</h1>
    </div>

    <div class="cell mb-10">
        <span class="font-bold" style="color: #666;">양식 기본정보</span>
    </div>
    <div class="cell mb-40">
        <table style="width: 100%; border-collapse: collapse; border: 1px solid #ccc;">
            <tbody>
            	<tr>
                    <th style="width: 30%; background-color: #f8f9fa; text-align: center; padding: 10px; border: 1px solid #ccc;">양식번호</th>
                    <td style="background-color: #556b82; color: white; text-align: center; padding: 10px; border: 1px solid #ccc;">
                     ${aprvFormDto.formNo}
                    </td>
                </tr>
                <tr>
                    <th style="width: 30%; background-color: #f8f9fa; text-align: center; padding: 10px; border: 1px solid #ccc;">양식분류</th>
                    <td style="background-color: #556b82; color: white; text-align: center; padding: 10px; border: 1px solid #ccc;">
                        <c:if test="${aprvFormDto.formHead != null}">${aprvFormDto.formHead}</c:if>
                        <c:if test="${aprvFormDto.formHead == null}">-</c:if>
                    </td>
                </tr>
                <tr>
                    <th style="background-color: #f8f9fa; text-align: center; padding: 10px; border: 1px solid #ccc;">작성일</th>
                    <td style="background-color: #556b82; color: white; text-align: center; padding: 10px; border: 1px solid #ccc;">
                        ${aprvFormDto.formWtime}
                    </td>
                </tr>
                <tr>
                    <th style="background-color: #f8f9fa; text-align: center; padding: 10px; border: 1px solid #ccc;">사용 여부</th>
                    <td style="background-color: #556b82; color: white; text-align: center; padding: 10px; border: 1px solid #ccc;">
                        <c:if test="${aprvFormDto.formUseYn == 'Y'}">사용</c:if>
                        <c:if test="${aprvFormDto.formUseYn == 'N'}">미사용</c:if>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="cell mb-10">
        <span class="font-bold" style="color: #666;">양식 설명</span>
    </div>
    <div class="cell mb-40" style="border: 1px solid #ccc; padding: 20px; border-radius: 5px; min-height: 100px; white-space: pre-wrap; line-height: 1.6;">${aprvFormDto.formExplain}</div>

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

    <div class="cell center">
        <c:if test="${sessionScope.loginId != null}">
            <a href="./edit?formNo=${aprvFormDto.formNo}" class="btn" style="background-color: #556b82; color: white; border: none; padding: 10px 20px; margin-right: 5px;">수정하기</a>
            
            <a href="./delete?formNo=${aprvFormDto.formNo}" class="btn" style="background-color: #ff1744; color: white; border: none; padding: 10px 20px; margin-right: 5px;" onclick="return confirm('정말 이 결재 양식을 삭제하시겠습니까?');">삭제하기</a>
        </c:if>

        <a href="./list" class="btn" style="background-color: #37474f; color: white; border: none; padding: 10px 20px;">목록 ≡</a>
    </div>

</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>