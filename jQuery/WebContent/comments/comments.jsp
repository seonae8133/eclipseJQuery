<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>comments.jsp</title>
<style>
	.comment {
	border : 1px dotted blue;
	}
	
	#commentUpdate {
	border : 2px solid red;}
</style>
<script src="../js/jquery-3.5.1.min.js"></script>
<script>
	window.onload=function() {// 윈도우가 로딩되면
		loadCommentList(); //해당 함수를 실행
	}
	//목록조회
	function loadCommentList() {
		$.ajax({
			url:'../CommentsServ',
			data: 'cmd=selectAll', // 둘다 같은말에 표현식만 다름 => {cmd: 'selectAll'},
			dataType: 'xml',
			type : 'get',
			success: loadCommentResult,
			error : function(a,b) {
				alert('댓글 로딩 실패: ' +b);
			}
		});
	}
	//콜백함수
	function loadCommentResult(xmlResult) {
		//console.log(xmlResult);
		let xmlDoc = xmlResult;
		let code = xmlDoc.getElementsByTagName('code').item(0).firstChild.nodeValue;
		if(code == 'success') {
			let commentList = eval('('+xmlDoc.getElementsByTagName('data').item(0).firstChild.nodeValue+')');//eval함수 사용 (괄호안의 함수를 그대로 실행하겠다는 의미)
			console.log(commentList);
			let listDiv = $('#commentList');
			/*for( field in commentList[0]) {
				$(listDiv).append(commentList[0][field]);
			}*/
			for(let i=0; i<commentList.length; i++) {
				let commentDiv = makeCommentView(commentList[i]);
				listDiv.append(commentDiv);
			}
		}
	}
	function makeCommentView(comment) {
		let div = document.createElement('div');
		div.setAttribute('id','c'+comment.id);
		div.className ='comment';
		div.comment = comment; //{id:2, name:홍길동, content:내용 ...}
		
		let str ='<strong>'+comment.name+'</strong>'+comment.content
		+' <input type="button" value="수정" onclick="viewUpdateForm('+comment.id+')">'
		+' <input type="button" value="삭제" onclick="confirmDeleton('+comment.id+')">';
		div.innerHTML = str;
		return div;
	}
	
	//등록 ajax호출.
	function addComment() {
		let name = document.addForm.name.value;
		let content = document.addForm.content.value;
		if(name==null||name=="") {
			alert("name is invalid")
			return; //function 에서return구문을 만나면 실행하다가 이 부분에서 함수 종료됨
		} else if(content==null||content=="") {
			alert("content is invalid")
			return;
		}
		let params = 'name='+name+'&content='+content+'&cmd=insert';
			$.ajax({
				url:'../CommentsServ',//1 이파일을 호출하는데
				dataType: 'xml', //3 xml파일로
				data: params,//2 파라미터 타입을 params 로 하고
				success: addResult,
				error: function(a,b) {
					alert('서버 에러: '+b);
				}
		                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	});
	}
	//콜백함수
	function addResult(req) {
		let xmlDoc = req;
		let code = xmlDoc.getElementsByTagName('code').item(0).firstChild.nodeValue;
		if(code=='success') {
			let comment = eval('('+xmlDoc.getElementsByTagName('data').item(0).firstChild.nodeValue+')');
			let listDiv = document.getElementById('commentList');
			let commentDiv = makeCommentView(comment);
			listDiv.append(commentDiv);
			
			document.addForm.name.value="";
			document.addForm.content.value="";
			
			alert('등록해따!['+comment.id+']');
			
		}
		
	}
	
	//수정버튼 이벤트 핸들러
	function viewUpdateForm(commentId) {//매개값으로 들어오는 아이디에 해당하는 데이터 값들을 보여줌
		let commentDiv = document.getElementById('c'+commentId);
		let updateFormDiv = document.getElementById('commentUpdate');
		commentDiv.after(updateFormDiv);
		
		let comment = commentDiv.comment; //{id:??, name:??, content:???}
		document.updateForm.id.value=comment.id;
		document.updateForm.name.value=comment.name;
		document.updateForm.content.value=comment.content;
		updateFormDiv.style.display = "block";
	}
	
	//변경이벤트 핸들러
	function updateComment() {
		let id = document.updateForm.id.value;
		let name = document.updateForm.name.value;
		let content = document.updateForm.content.value;
		let params ='id='+id+'&name='+name+'&content='+content+'&cmd=update';
		$.ajax({
			url:'../CommentsServ',
			data:params,
			dataType:'xml',
			success: updateResult,
			error: function(a,b) {
				console.log(a,b);
			}
		});
	}
	//변경 콜백함수
	function updateResult(req){
		let xmlDoc = req;
		let code = xmlDoc.getElementsByTagName('code').item(0).firstChild.nodeValue;
		if(code=='success') {
			let comment = eval('('+xmlDoc.getElementsByTagName('data').item(0).firstChild.nodeValue+')');
			let listDiv = document.getElementById('commentList');
			let commentDiv = makeCommentView(comment);
			let oldCommentDiv = document.getElementById('c'+comment.id);
			listDiv.replaceChild(commentDiv, oldCommentDiv);
			
			document.getElementById('commentUpdate').style.display='none';
			alert('수정되땻');
		}
	}
	
	//삭제 이벤트
	function confirmDeleton(id) {
		$.ajax({
			url:'../CommentsServ',
			data : 'id='+id+'&cmd=delete',
			dataType: 'xml',
			success: deleteResult,
			error: function(a,b) {console.log(a,b)}
		});
	}
	
	//삭제 콜백함수
	function deleteResult(req) {
		let xmlDoc = req;
		let code = xmlDoc.getElementsByTagName('code').item(0).firstChild.nodeValue;
		if(code=='success') {
			let comment = eval('('+xmlDoc.getElementsByTagName('data').item(0).firstChild.nodeValue+')');
			let listDiv = document.getElementById('commentList');
			let commentDiv = document.getElementById('c'+comment.id);
			listDiv.removeChild(commentDiv);
			
			alert('삭제되었습니다');
		}
	}
	
	
	
</script>
</head>
<body>
	<div id="commentList"></div>
	
	<!-- 글 등록화면 -->
	<div id="commentAdd">
		<form action="" name="addForm">
			이름: <input type="text" name="name" size="10"><br>
			내용: <textarea name="content" cols="20" rows="2"></textarea><br>
			<input type="button" value="등록" onclick="addComment()"><br>
		</form>
	</div>
	
	
	<!-- 글수정화면 -->
	<div id="commentUpdate" style="display:none;">
		<form action="" name="updateForm">
			<input type="hidden" name="id" value="">
			이름: <input type="text" name="name" size="10"><br>
			내용: <textarea name="content" cols="20" rows="2"></textarea><br>
			<input type="button" value="변경" onclick="updateComment()">
			<input type="button" value="취소" onclick="cancleUpdate()">
		</form>
	</div>
</body>
</html>