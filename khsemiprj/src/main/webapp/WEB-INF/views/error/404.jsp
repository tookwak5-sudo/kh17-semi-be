<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<style>
        /* 커스텀 카드 레이아웃만 남겨두고 나머지는 commons.css 활용 */
        .aprv-info-card {
            background-color: #ffffff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 10px 30px;
        }
        .aprv-info-row {
            display: flex;
            align-items: center;
            padding: 16px 0;
            border-bottom: 1px solid #f1f3f5;
        }
        .aprv-info-row:last-child {
            border-bottom: none;
        }
        .aprv-info-label {
            width: 160px;
            font-weight: 600;
            color: #495057;
            position: relative;
            padding-left: 14px;
            letter-spacing: -0.5px;
        }
        .aprv-info-label::before {
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
        .aprv-info-value {
            width: 100%;
            color: #343a40;
            font-weight: 500;
        }
        .aprv-info-value.point-color {
            color: #739BED;
            font-weight: 600;
        }
</style>

<div class="container w-600 mt-20 mb-50 background-card">
	<div class="w-100" style="justify-content: left">
		<div>
	        <h1 style="font-size: 24px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
	            Error
	            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
	        </h1>
		</div>
		<div class="aprv-info-card">
			<div class="aprv-info-row">
				<div class="aprv-info-label">내용</div>
				<div class="aprv-info-value"><span>${message == null ? "존재하지 않는 대상입니다" : message}</span></div>
			</div>
			<div class="aprv-info-row" style="justify-content: center;">
				<div>
	                <a href="/" class="btn btn-neutral">
	                	<i class="fa-solid fa-house" style="font-size: 16px; margin-right: 10px;"></i>
	                    메인페이지로 이동
	                </a>
	            </div>
			</div>
		</div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>