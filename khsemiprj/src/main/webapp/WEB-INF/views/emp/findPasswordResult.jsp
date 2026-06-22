<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"/>

<style>
    /* 아이디 찾기 결과 카드 스타일 */
    .result-card {
        background-color: #ffffff;
        border: 1px solid #e3e8ec;
        border-radius: 12px;
        padding: 40px 30px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        text-align: center;
    }
    
    /* 성공 아이콘 */
    .result-icon {
        font-size: 3rem;
        color: #2ecc71; /* 성공을 의미하는 초록색 */
        margin-bottom: 15px;
    }

    /* 결과 타이틀 */
    .result-title {
        font-size: 1.5rem;
        font-weight: bold;
        color: #333333;
        margin-bottom: 30px;
    }

    /* 아이디가 표시되는 박스 영역 */
    .id-display-box {
        background-color: #f8f9fa;
        border: 1px dashed #cbd5e1;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 30px;
    }

    .id-label {
        font-size: 0.9rem;
        color: #7f8c8d;
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
    }

    .id-value {
        font-size: 1.8rem;
        color: #2c3e50;
        font-weight: 800;
        letter-spacing: 0.5px;
        margin: 0;
    }
</style>
<div class="container w-400 mt-20 mb-50 background-card result-card">
        <div class="result-icon">
            <i class="fa-solid fa-circle-check"></i>
        </div>
        <h1 class="result-title">비밀번호 찾기 결과</h1>
        
        <div class="id-display-box">
            <span class="id-label">요청하신 정보와 일치하는 비밀번호</span>
            <h2 class="id-value">
                ${empPassword}
            </h2>
        </div>
        
        <div class="button-group">
            <a href="./login" class="btn btn-neutral w-60">
            	로그인하러 가기 <i class="fa-solid fa-right-to-bracket"></i>
            </a>
        </div>  
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"/>