<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<script>
$(function() {
	var state = {
        formNameValid: false,
        headNameValid: true,
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

    $("[name=formName]").on("blur", function(){
        var value = $(this).val().trim(); 
        if(value.length == 0){ 
            state.formNameValid = false; 
        } else {
            state.formNameValid = true;
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
    	$(this).find("select[name]").trigger("input");
        $(this).find("input[name], textarea[name]").trigger("blur");
    	
        var canSubmit = false;

        if(state.formNameValid == false) {
            //window.alert("양식명을 입력하세요.");
            showAjaxAlarm('양식명을 입력하세요', 'btn-negative', '[name=formName]', 'left');
            $("[name=formName]").focus();
            return canSubmit; 
        }

        if(state.formExplainValid == false) {
            //window.alert("양식 내용을 입력하세요.");
            showAjaxAlarm('양식 내용을 입력하세요', 'btn-negative', '[name=formExplain]', 'left');
            $("[name=formExplain]").focus();
            return canSubmit; 
        }

        canSubmit = true;
        return canSubmit;
    });
    
    $(".preview-input").trigger("change");
}); 
</script>

<div class="container w-800 mt-20 mb-50 background-card">

	<div class="w-100 flex-area" style="justify-content: left">
			<div>
		        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
		            결재양식 수정
		            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
		        </h1>
			</div>
    </div>

	<form action="./edit" method="post" enctype="multipart/form-data">

		<div class="cell mb-10">
			<label class="font-bold" style="color: #666;">양식 분류</label>
		</div>
		<div class="cell mb-20">

			<div class="cell mb-20">

				<select name="head_name" class="input w-100"
					style="border: 1px solid #ccc; padding: 10px;">
					<c:forEach var="head" items="${headList}">
						<option value="${head.headName}"
							${findHeadName.headName == head.headName ? 'selected' : ''}>
							${head.headName}</option>
					</c:forEach>
				</select> 
				
				<select name="head_type" class="input w-100"
					style="border: 1px solid #ccc; padding: 10px; margin-top: 10px;">
					<c:forEach var="type" items="${typeList}">
						<option value="${type.headType}"
							${findHeadType.headType == type.headType ? 'selected' : ''}>
							${type.headType}</option>
					</c:forEach>
				</select>
			</div>
		</div>


		<!--         pk라 리드온리 있습니다. -->
		<div class="cell mb-20">
			<input type="hidden" name="formNo" value="${aprvFormDto.formNo}"
				class="input w-100" readonly
				style="background-color: #f8f9fa; border: 1px solid #ccc; padding: 10px;">
		</div>

		<div class="cell mb-10">
			<label class="font-bold" style="color: #666;">양식명</label>
		</div>
		<div class="cell mb-20">
			<input type="text" name="formName" value="${aprvFormDto.formName}"
				class="input w-100"
				style="border: 1px solid #ccc; padding: 10px;">
		</div>

		<div class="cell mb-10">
			<label class="font-bold" style="color: #666;">양식 설명</label>
		</div>
		<div class="cell mb-20">
			<textarea name="formExplain" class="input w-100"
				style="min-height: 150px; resize: vertical; border: 1px solid #ccc; padding: 10px;">${aprvFormDto.formExplain}</textarea>
		</div>

		<div class="cell mb-20 flex-area" style="align-items: center;">
			<label class="font-bold" style="color: #666; margin-right: 20px;">양식
				사용 여부</label> <input type="checkbox" name="formUseYn" value="Y"
				<c:if test="${aprvFormDto.formUseYn == 'Y'}">checked</c:if>>
		</div>

		<div class="cell mb-10">
			<label class="font-bold" style="color: #666;">첨부</label>
			<c:if test="${attachNo != null}">
				<span style="font-size: 13px; color: #ff1744; margin-left: 10px;">(※
					새 파일을 첨부하면 기존 파일은 삭제되고 덮어씌워집니다.)</span>
			</c:if>
		</div>
		<div class="cell mb-40">
    		<c:if test="${attachNo != null}">
       			 <input type="hidden" name="attachNo" value="${attachNo}">
    		</c:if>
    			<input type="file" name="attach" class="input w-100 preview-input"
        			style="display: none;">
		</div>
		
		<div class="cell file-info-area"></div>
		

		<div class="cell right">
			<button type="submit" class="btn"
				style="background-color: #556b82; color: white; border: none; padding: 10px 30px; font-size: 16px;">수정하기</button>
		</div>
	</form>


</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>