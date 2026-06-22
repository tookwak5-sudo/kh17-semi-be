<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<form id="boardEditForm" action="./edit" method="post" novalidate autocomplete="off">
<input type="hidden" name="boardNo" value="${boardDto.boardNo}">

<div class="container w-950 mt-20 mb-50 background-card">
	<div class="w-100 flex-area" style="justify-content: left">
			<div>
		        <h1 style="font-size: 32px; font-weight: 800; color: #1e293b; position: relative; display: inline-block;">
		           	게시글 수정
		            <span style="display: block; width: 40px; height: 4px; background: #4f46e5; border-radius: 2px; margin-top: 8px;"></span>
		        </h1>
			</div>
        </div>
	<div class="cell">
		타인에 대한 무분별한 비방글은 경고 없이 삭제될 수 있습니다
	</div>
	
	<div class="cell mt-40">
		<label>제목 <i class="fa-solid fa-asterisk red"></i></label>
		<input type="text" name="boardTitle" class="field w-100 input-title"
				value="${boardDto.boardTitle}">
	</div>
	<div class="cell mb-0">
		<label>구분 <i class="fa-solid fa-asterisk red"></i></label>
	</div>
	<div class="cell mt-0">
		<select name="boardHead" class="field select-head">
			<option value="">선택 안함</option>
			
		<c:if test="${sessionScope.empGrade == '0'}">
			<option value="공지" ${boardDto.boardHead == '공지' ? 'selected':''}>공지</option>
		</c:if>
			<option value="자유" ${boardDto.boardHead == '자유' ? 'selected':''}>자유</option>
			<option value="유머" ${boardDto.boardHead == '유머' ? 'selected':''}>유머</option>
			<option value="정보" ${boardDto.boardHead == '정보' ? 'selected':''}>정보</option>
			<option value="질문" ${boardDto.boardHead == '질문' ? 'selected':''}>질문</option>
			<option value="나눔" ${boardDto.boardHead == '나눔' ? 'selected':''}>나눔</option>
		</select>
	</div>
	
	<div class="cell">
		<label>내용 <i class="fa-solid fa-asterisk red"></i></label>
		<textarea id="summernote" name="boardContent" rows="10" class="field w-100">${boardDto.boardContent}</textarea>
	</div>
	
	<div class="cell mt-50 right">
		<a href="./list" class="btn btn-neutral">
			<i class="fa-solid fa-list"></i>
			<span>목록으로 이동</span>
		</a>
		<button type="submit" class="btn btn-positive">
			<i class="fa-solid fa-floppy-disk"></i>
			<span>글 수정하기</span>
		</button>
	</div>
</div>
	
</form>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>

<script>
// ★ 4. 유효성 검사 상태 객체
var state = {
    boardTitleValid: false,
    boardHeadValid: false,
    boardContentValid: false
};

$(document).ready(function() {
    
    // 입력창 실시간 검사
    $(".input-title").on("blur keyup", function() {
        state.boardTitleValid = $(this).val().trim().length > 0;
    });
    
    $(".select-head").on("change", function() {
        state.boardHeadValid = $(this).val() !== "";
    });

    $('#summernote').summernote({
        height: 400,                 
        minHeight: 400,              
        maxHeight: null,             
        focus: false,                
        lang: "ko-KR",               
        toolbar: [
            ['fontname', ['fontname']],
            ['fontsize', ['fontsize']],
            ['style', ['bold', 'italic', 'underline','strikethrough', 'clear']],
            ['color', ['forecolor','color']],
            ['table', ['table']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['height', ['height']],
            ['insert',['picture','link']],
            ['view', ['codeview', 'help']]
        ],
        fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New','맑은 고딕','궁서','굴림체','굴림','돋움체','바탕체'],
        fontNamesIgnoreCheck: ['맑은 고딕'],
        fontSizes: ['1','3','5','8', '9', '10', '11', '12', '14', '16', '18', '20', '22', '24', '28', '30', '36', '50', '72'],
        
        callbacks: {
            onImageUpload: function(files) {
                for (var i = 0; i < files.length; i++) {
                    sendImageFile(files[i], this);
                }
            }, // <--- ★ 원인 해결: 여기에 쉼표(,)가 빠져있었습니다!
            onMediaDelete: function(target) {
                deleteImageFile(target[0].src);
            }
        }
    });
    
    // ★ 5. 폼 전송 시 최종 유효성 검사 (checkContent 함수 대체)
    $("#boardEditForm").on("submit", function(e) {
        
        // 제출 직전의 값으로 상태 업데이트 (수정 페이지는 이미 값이 차있을 수 있으므로 필수)
        state.boardTitleValid = $(".input-title").val().trim().length > 0;
        state.boardHeadValid = $(".select-head").val() !== "";
        
        var content = $('#summernote').summernote('code').trim();
        state.boardContentValid = (content !== '' && content !== '<p><br></p>' && content !== '<br>');
        
        if (!state.boardTitleValid) {
            showAjaxAlarm('게시글 제목을 입력해주세요', 'btn-negative', '.input-title', 'left');
            $(".input-title").focus();
            return false;
        }
        
        if (!state.boardHeadValid) {
            showAjaxAlarm('게시글의 말머리(구분)를 선택해주세요', 'btn-negative', '.select-head', 'left');
            $(".select-head").focus();
            return false;
        }
        
        if (!state.boardContentValid) {
            showAjaxAlarm('게시글 내용을 입력해주세요', 'btn-negative', '.note-editable', 'left');
            $('#summernote').summernote('focus');
            return false;
        }
        
        return true;
    });
    
});

// 이미지 업로드 통신
function sendImageFile(file, editor) {
    var data = new FormData();
    data.append("uploadFile", file);

    $.ajax({
        url: "/rest/file/upload",
        type: "POST",
        data: data,
        contentType: false,    
        processData: false,    
        dataType: "text",   
        success: function(url) {
            $('#summernote').summernote('focus');
            var imgNode = document.createElement('img');
            imgNode.src = url;
            imgNode.style.maxWidth = "100%";
            $('#summernote').summernote('insertNode', imgNode);
        },
        error: function(err) {
            openAlert("이미지 업로드 중 통신 오류가 발생했습니다.");
            console.error(err);
        }
    });
}

// 첨부 이미지 삭제 통신
function deleteImageFile(src) {
    var match = src.match(/attachNo=(\d+)/);
    if(match) {
        var attachNo = match[1];
        $.ajax({
            url: "/rest/file/delete",
            type: "POST",
            data: { attachNo: attachNo },
            success: function() {
                console.log("좀비 이미지 삭제 완료");
            }
        });
    }
}
</script>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>