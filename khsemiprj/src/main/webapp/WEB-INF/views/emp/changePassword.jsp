<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script>
$(function() {
    
    $(".password-check").on("submit", function() {
        var currentPw = $("[name=empPassword]").val();
        var newPw = $("[name=newPassword]").val();
        var newPwCheck = $("#newPasswordCheck").val();

        if(currentPw.length == 0) {
            window.alert("현재 비밀번호를 입력해주세요.");
            return false;
        }
        if(newPw.length == 0) {
            window.alert("새로운 비밀번호를 입력해주세요.");
            return false;
        }
        if(newPw === currentPw) {
            window.alert("현재 비밀번호와 동일한 비밀번호로 변경할 수 없습니다.");
            return false;
        }
        if(newPw !== newPwCheck) {
            window.alert("새로운 비밀번호와 비밀번호 확인이 일치하지 않습니다.");
            return false;
        }
        
        return true;
    });
});
</script>

<form action="./changePassword" method="post" autocomplete="off" class="password-check">
    <div class="container w-500 mt-50 mb-50">
        <div class="cell center">
            <h1>비밀번호 변경</h1>
        </div>

        <c:if test="${param.error != null}">
            <div class="cell center" style="color: red; font-weight: bold;">
                현재 비밀번호가 일치하지 않습니다. 다시 확인해주세요.
            </div>
        </c:if>

        <div class="cell">
            <label>현재 비밀번호</label>
            <input type="password" name="empPassword" class="field w-100" placeholder="현재 비밀번호 입력">
        </div>

        <div class="cell">
            <label>새로운 비밀번호</label>
            <input type="password" name="newPassword" class="field w-100" placeholder="새로운 비밀번호 입력">
        </div>

        <div class="cell">
            <label>새로운 비밀번호 확인</label>
            <input type="password" id="newPasswordCheck" class="field w-100" placeholder="새로운 비밀번호 다시 입력">
        </div>

        <div class="cell mt-30">
            <button type="submit" class="btn btn-positive w-100">
                <i class="fa-solid fa-key"></i> <span>비밀번호 변경하기</span>
            </button>
        </div>
        
        <div class="cell center mt-10">
            <a href="./mypage" class="link">취소하고 마이페이지로 돌아가기</a>
        </div>
    </div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp" />