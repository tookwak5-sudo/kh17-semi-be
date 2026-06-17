<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<form id="boardWriteForm" action="./write" method="post" class="form-check" novalidate autocomplete="off">

<div class="container w-950 mt-50 mb-50">
	<div class="cell">
		<h1 class="mt-0 mb-0">신규 글 작성</h1>
	</div>
	<div class="cell">
		타인에 대한 무분별한 비방글은 경고 없이 삭제될 수 있습니다
	</div>
	
	<div class="cell mt-40">
		<label>제목 <i class="fa-solid fa-asterisk red"></i></label>
		<input type="text" name="boardTitle" class="field w-100 input-title" placeholder="제목을 입력하세요">
	</div>
	<div class="cell mb-0">
		<label>구분 <i class="fa-solid fa-asterisk red"></i></label>
	</div>
	<div class="cell mt-0">
		<select name="boardHead" class="field select-head">
			<option value="">선택 안함</option>
			<c:if test="${sessionScope.empGrade == '0'}">
				<option value="공지">공지</option>
			</c:if>
			<option value="자유">자유</option>
			<option value="유머">유머</option>
			<option value="정보">정보</option>
			<option value="질문">질문</option>
			<option value="나눔">나눔</option>		
		</select>
	</div>
	
	<div class="cell">
		<label>내용 <i class="fa-solid fa-asterisk red"></i></label>
		<textarea id="summernote" name="boardContent" rows="10" class="field w-100"></textarea>
	</div>
	
	<div class="cell mt-50 right">
		<a href="./list" class="btn btn-neutral">
			<i class="fa-solid fa-list"></i> <span>목록으로 이동</span>
		</a>
		<button type="submit" class="btn btn-positive">
			<i class="fa-solid fa-floppy-disk"></i> <span>글 등록하기</span>
		</button>
	</div>
</div>
</form>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>

<script>
// ★ 2. 유효성 검사 상태 관리 객체 (aprv 시스템에서 차용)
var state = {
    boardTitleValid: false,
    boardHeadValid: false,
    boardContentValid: false,
    // ok() 함수는 현재 사용하지 않더라도 구조적 통일성을 위해 유지
    ok: function(){
        return this.boardTitleValid && this.boardHeadValid && this.boardContentValid;
    }
};

$(document).ready(function() {
	
	// ★ 3. 입력창 실시간 검사 이벤트 바인딩
	
	// 3-1. 제목 검사 (blur 시 검사)
	$(".input-title").on("blur keyup", function() {
		state.boardTitleValid = $(this).val().trim().length > 0;
	});
	
	// 3-2. 말머리(구분) 검사 (change 시 검사)
	$(".select-head").on("change", function() {
		state.boardHeadValid = $(this).val() !== "";
	});
	
	// 3-3. 내용 검사는 썸머노트의 특성상 제출 직전에 수행함.

    // 썸머노트 초기화
    $('#summernote').summernote({
        height: 400,                 
        minHeight: 400,              
        maxHeight: null,             
        focus: false,                
        lang: "ko-KR",               
        placeholder: '내용을 입력해주세요.', 
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
            },
            // ★ 이미지 삭제 시 서버에도 지워달라고 요청하는 콜백
            onMediaDelete: function(target) {
                deleteImageFile(target[0].src);
            }
        }
    });
    $('#summernote').summernote('code', '');
    
    $("[name=boardTitle]").on("blur", function(){
        state.boardTitleValid = $(this).val().trim().length > 0;
    });
    $("[name=boardHead]").on("blur", function(){
        state.boardHeadValid = $(this).val().trim().length > 0;
    });
    $("[name=boardContent]").on("blur", function(){
        state.boardContentValid = $(this).val().trim().length > 0;
    });
    
    // ★ 4. 폼 전송(submit) 시 최종 유효성 검사
    $("#boardWriteForm").on("submit", function(e) {
    	
    	// 전송 직전에 현재 값들을 기준으로 state 갱신
    	state.boardTitleValid = $(".input-title").val().trim().length > 0;
    	state.boardHeadValid = $(".select-head").val() !== "";
    	
    	// 썸머노트 내용 검사 (비어있거나 기본 p태그만 있는지 확인)
    	var content = $('#summernote').summernote('code').trim();
        state.boardContentValid = (content !== '' && content !== '<p><br></p>' && content !== '<br>');
    	
        // 순차적으로 검사 후 경고창 띄우고 전송 중단(return false)
        if (!state.boardTitleValid) {
            //alert("게시글 제목을 입력해주세요.");
            showAjaxAlarm('게시글 제목을 입력해주세요', 'btn-negative', '.input-title', 'left');
            $(".input-title").focus();
            return false;
        }
        
        if (!state.boardHeadValid) {
            //alert("게시글의 말머리(구분)를 선택해주세요.");
            showAjaxAlarm('게시글의 말머리(구분)를 선택해주세요', 'btn-negative', '.select-head', 'left');
            $(".select-head").focus();
            return false;
        }
        
        if (!state.boardContentValid) {
            //alert("게시글 내용을 입력해주세요.");
            showAjaxAlarm('게시글 내용을 입력해주세요', 'btn-negative', '.note-editable', 'left');
            $('#summernote').summernote('focus');
            return false;
        }
        
        // 모두 true라면 전송 진행 (return true 생략 시 기본 진행됨)
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
            alert("이미지 업로드 중 통신 오류가 발생했습니다.");
            console.error(err);
        }
    });
}

// ★ 이미지 삭제 통신
function deleteImageFile(src) {
    var match = src.match(/attachNo=(\d+)/);
    if(match) {
        var attachNo = match[1];
        $.ajax({
            url: "/rest/file/delete",
            type: "POST",
            data: { attachNo: attachNo },
            success: function() {
                console.log("에디터 내 이미지 서버 삭제 완료");
            }
        });
    }
}
</script>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>