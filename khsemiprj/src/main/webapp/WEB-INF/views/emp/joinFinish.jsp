<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />

<style>
/* 완료 페이지 전용 추가 스타일 */
.success-card {
    background: #FFFFFF;
    border: 1px solid #E2E8F0;
    border-radius: 12px;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
    padding: 50px 30px;
}

.success-icon-box {
    width: 80px;
    height: 80px;
    background-color: #EFF6FF;
    border-radius: 50%;
    font-size: 36px;
    margin-bottom: 20px;
}

.success-title {
    font-size: 28px;
    font-weight: 700;
    color: #1E293B;
}

.success-subtitle {
    font-size: 16px;
    color: #64748B;
    margin-top: 10px;
    margin-bottom: 40px;
}
</style>

<div class="container w-500 mt-50 mb-50">
    <div class="success-card flex-area flex-center flex-vertical">
        
        <div class="success-icon-box flex-area flex-center blue">
            <i class="fa-solid fa-circle-check"></i>
        </div>
        
        <h1 class="success-title center">등록이 완료되었습니다</h1>
        <p class="success-subtitle center">사원 등록이 성공적으로 마무리되었습니다.<br>아래 버튼을 눌러 로그인을 진행해주세요.</p>
        
        <div class="cell w-100">
            <a href="/emp/login" class="btn btn-positive w-100" style="height: 45px; font-size: 16px;">
                <i class="fa-solid fa-right-to-bracket me-10"></i> <span>로그인하러 가기</span>
            </a>
        </div>
        
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>