<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<form action="./write" method="post" onsubmit="return checkContent()">

<div class="container w-950 mt-50 mb-50">
	<div class="cell">
		<!-- 제목을 답글일 때와 새글일 때로 나눠서 처리 -->
		<h1 class="mt-0 mb-0">신규 글 작성</h1>
	</div>
	<div class="cell">
		타인에 대한 무분별한 비방글은 경고 없이 삭제될 수 있습니다
	</div>
	
	<div class="cell mt-40">
		<label>제목 <i class="fa-solid fa-asterisk red"></i></label>
		<input type="text" name="boardTitle" required class="field w-100">
	</div>
		<div class="cell mb-0">
			<label>구분</label>
		</div>
	
		<div class="cell mt-0">
			<select name="boardHead" class="field" required>
				<option value="" >선택 안함</option>
				<!-- 공지는 관리자에게만 보이도록 해야함 -->
			<c:if test="${sessionScope.empGrade == '0'}">
				<option>공지</option>
			</c:if>
				<option>자유</option>
				<option>자유</option>
				<option>유머</option>
				<option>정보</option>
				<option>질문</option>
				<option>나눔</option>		
			</select>
		</div>
	
	<div class="cell">
		<label>내용 <i class="fa-solid fa-asterisk red"></i></label>
		<textarea id="summernote" name="boardContent" rows="10" required class="field w-100"></textarea>
	</div>
	
	<div class="cell mt-50 right">
		<a href="./list" class="btn btn-neutral">
			<i class="fa-solid fa-list"></i>
			<span>목록으로 이동</span>
		</a>
		<button type="submit" class="btn btn-positive">
			<i class="fa-solid fa-floppy-disk"></i>
			<span>글 등록하기</span>
		</button>
	</div>
</div>
	
</form>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>

<script>
$(document).ready(function() {
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
            }
        }
    });
    $('#summernote').summernote('code', '');
});

function sendImageFile(file, editor) {
    var data = new FormData();
    data.append("uploadFile", file);

    $.ajax({
        url: "${pageContext.request.contextPath}/board/uploadImage",
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

//글 등록 버튼을 누를 때 내용이 비어있는지 검사하는 함수
function checkContent() {
    var content = $('#summernote').summernote('code');
    
    if (content === '' || content === '<p><br></p>') {
        alert("내용을 입력해주세요!");
        $('#summernote').summernote('focus');
        return false;
    }
    
    return true;
}
</script>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>


