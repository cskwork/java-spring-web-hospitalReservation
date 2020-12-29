<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>공지사항-작성&수정</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
	<c:choose>
		<c:when test="${map.IDX == null}">
			<form id="Write" enctype="multipart/form-data">
		</c:when>
		<c:otherwise>
			<form id="Modify" enctype="multipart/form-data">
				<input type="hidden" name="IDX" value="${map.IDX}">
		</c:otherwise>
	</c:choose>
		<table border="1" align="center" style="width:60%;height:400px;">
			<colgroup>
				<col width="15%">
				<col width="*"/>
			</colgroup>
			<caption>관리자-게시글</caption>
			<tbody>
				<tr>
					<th scope="row">제목</th>
					<td><input type="text" name="TITLE" value="${map.TITLE}"></input></td>
				</tr>
				<tr>
					<th scope="row">내용</th>
					<td>
						<textarea rows="20" cols="70" name="CONTENT">${map.CONTENT}</textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">첨부파일</th>
					<td colspan="3">
						<div id="fileDiv">				
							<c:forEach var="row" items="${list }" varStatus="var">
								<p>
									<input type="text" id="F_IDX" name="F_IDX_${var.index }" value="${row.F_IDX }">
									<a href="#this" id="name_${var.index }" name="name_${var.index }">${row.ORG_FILE }</a>
									<input type="file" id="file_${var.index }" name="file_${var.index }"> 
									(${row.FILE_SIZE }kb)
									<a href="#this" class="btn" id="delete_${var.index }" name="delete">삭제</a>
								</p>
							</c:forEach>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
		<br><br>
		<a href="#this" class="btn" id="addFile">파일 추가</a>
		<c:choose>
			<c:when test="${map.IDX == null}">
				<a href="#this" class="btn" id="write">작성 완료</a>
			</c:when>
			<c:otherwise>
				<a href="#this" class="btn" id="modify">수정 완료</a>
			</c:otherwise>
		</c:choose>
		<a href="#this" class="btn" id="list">목록으로</a>
	</form>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		var gfv_count = 1;
		$(document).ready(function(){
			$("#list").on("click", function(e){ //목록으로 버튼
				e.preventDefault();
				fn_noticeList();
			});
			$("#write").on("click", function(e){ //작성하기 버튼
				e.preventDefault();
				fn_noticeWrite();
			});
			$("#modify").on("click", function(e){ //수정하기 버튼
				e.preventDefault();
				fn_noticeModify();
			});
			$("#addFile").on("click", function(e){ //파일 추가 버튼
				e.preventDefault();
				fn_addFile();
			});
			$("a[name='delete']").on("click", function(e){ //삭제 버튼
				e.preventDefault();
				fn_deleteFile($(this));
			});
		});
		function fn_noticeList(){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/notice/listform' />");
			comSubmit.submit();
		}
		function fn_noticeWrite(){
			var comSubmit = new ComSubmit("Write");
			comSubmit.setUrl("<c:url value='/admin/notice/write' />");
			return validation()?comSubmit.submit():false;
		}
		function fn_noticeModify(){
			var comSubmit = new ComSubmit("Modify");
			comSubmit.setUrl("<c:url value='/admin/notice/modify' />");
			return validation()?comSubmit.submit():false;
		}
		function fn_addFile(){
			var str = "<p><input type='file' name='file_"+(gfv_count++)+"'><a href='#this' class='btn' name='delete'>삭제</a></p>";
			$("#fileDiv").append(str);
			$("a[name='delete']").on("click", function(e){ //삭제 버튼
				e.preventDefault();
				fn_deleteFile($(this));
			});
		}
		function fn_deleteFile(obj){
			obj.parent().remove();
		}
		
		function validation() {
			var frm = document.forms[0];
			if(frm.TITLE.value == "") {
				alert("제목을 입력해주세요");
				return false;
			}
			else if(frm.CONTENT.value == "") {
				alert("내용을 입력해주세요");
				return false;
			}
			
			return true;
		}
	</script>
</body>
</html>