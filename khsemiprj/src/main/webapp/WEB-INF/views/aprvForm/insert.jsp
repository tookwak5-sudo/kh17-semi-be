<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<script>
$(function() {
    var state = {
        formNameValid: false,
        headNameValid: false,
        formExplainValid: false, 
        
        ok: function(){
            return Object.values(this)
            .filter(v => typeof v==="boolean")
            .every(v => v === true);
        }
    };

    $(".preview-input").on("change", function(){
        $(".file-info-area").empty(); 

        if(this.files.length > 0) {
            var file = this.files[0];
            var fileName = file.name;
            var fileSize = (file.size / 1024).toFixed(1) + " KB"; 

            var fileContainer = $("<div>")
                .css({
                    "padding": "15px",
                    "background-color": "#f8f9fa",
                    "border": "1px solid #e2e8f0",
                    "border-radius": "6px",
                    "display": "flex",
                    "align-items": "center",
                    "justify-content": "space-between"
                });

            var fileLeft = $("<div>").css("display", "flex").css("align-items", "center");
            var fileIcon = $("<i>").addClass("fa-solid fa-file-lines purple me-10").css("font-size", "18px");
            var fileNameText = $("<span>").addClass("black").css("font-weight", "bold").css("font-size", "14px").text(fileName);
            
            var deleteBtn = $("<i>")
                .addClass("fa-solid fa-xmark gray ms-10")
                .css({"cursor": "pointer", "font-size": "14px"})
                .on("click", function(){
                    $(".preview-input").val("").trigger("change"); 
                });
            
            fileLeft.append(fileIcon).append(fileNameText).append(deleteBtn);

            var fileRight = $("<span>")
                .addClass("gray")
                .css({
                    "font-size": "12px",
                    "background-color": "#edf2f7",
                    "padding": "3px 8px",
                    "border-radius": "4px",
                    "font-weight": "500"
                })
                .text(fileSize);

            fileContainer.append(fileLeft).append(fileRight);
            $(".file-info-area").append(fileContainer);

        } else {
            var uploadPlaceholder = $("<div>")
                .css({
                    "padding": "30px",
                    "background-color": "#ffffff",
                    "border": "2px dashed #cbd5e0",
                    "border-radius": "6px",
                    "text-align": "center",
                    "cursor": "pointer",
                    "color": "#718096"
                })
                .html("<i class='fa-solid fa-cloud-arrow-up' style='font-size:24px; margin-bottom:8px; color:#a0aec0;'></i><br><span style='font-size:14px; font-weight:500;'>클릭하여 파일 첨부 (hwp, docx 등)</span>")
                .on("click", function(){
                    $(".preview-input").click(); 
                });

            $(".file-info-area").append(uploadPlaceholder);
        }
    });

    $(".preview-input").trigger("change");

    $("[name=formName]").on("blur", function(){
        var value = $(this).val().trim(); 
        if(value.length == 0){ 
            state.formNameValid = false; 
        } else {
            state.formNameValid = true;
        }
    });

    $("[name=headName]").on("change", function(){
        var value = $(this).val();
        if(value == "선택하세요") {
            state.headNameValid = false;
        } else {
            state.headNameValid = true;
        }
    });

    $("[name=formExplain]").on("blur", function(){
        var value = $(this).val().trim();
        if(value.length == 0) {
            state.formExplainValid = false;
        } else {
            state.formExplainValid = true;
        }
    });

    $("form").on("submit", function(e){
        var canSubmit = false;

        if(state.formNameValid == false) {
            window.alert("양식명을 입력하세요.");
            $("[name=formName]").focus();
            return canSubmit; 
        }

        if(state.headNameValid == false) {
            window.alert("구분을 선택하세요.");
            $("[name=headName]").focus();
            return canSubmit; 
        }

        if(state.formExplainValid == false) {
            window.alert("양식 내용을 입력하세요.");
            $("[name=formExplain]").focus();
            return canSubmit; 
        }

        canSubmit = true;
        return canSubmit;
    });
});
</script>
<form action="./insert" method="post" enctype="multipart/form-data">

	<div class="container w-950 mt-50 mb-50">
		<div class="cell">
			<h1 class="mt-0 mb-0">결재 양식 신규 등록</h1>
		</div>
		<div class="cell">전자결재 기안 시 직원들이 사용할 새로운 양식을 등록합니다.</div>

		<div class="cell mt-40">
			<label>양식명 <i class="fa-solid fa-asterisk red"></i></label> 
			<input type="text" name="formName" class="field w-100" placeholder="예: 연차 신청서">
		</div>

		<div class="cell mb-0 mt-20">
			<label>구분<i class="fa-solid fa-asterisk red"></i></label>
		</div>
		<div class="cell mb-20">
			<select name="headName" class="input w-100" style="border: 1px solid #ccc; padding: 10px;">
				<option value="선택하세요">선택하세요</option>
				<c:forEach var="head" items="${headList}">
					<option value="${head.headName}">${head.headName}</option>
				</c:forEach>
			</select> 
		</div>

		<div class="cell mb-0 mt-20">
			<label>사용 여부</label>
		</div>
		<div class="cell mt-0">
			<input type="checkbox" name="formUseYn" value="Y" checked>
		</div>

		<div class="cell mt-20">
			<label>양식 설명 <i class="fa-solid fa-asterisk red"></i></label>
			<textarea name="formExplain" rows="10" class="field w-100" placeholder="양식에 대한 구체적인 설명을 입력하세요"></textarea>
		</div>

		<div class="cell mt-20">
			<label>양식 파일 첨부 (hwp, docx 등)</label> 
			<input type="file" name="attach" class="field w-100 preview-input" style="display: none;">
		</div>
		
		<div class="cell file-info-area"></div>
		
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