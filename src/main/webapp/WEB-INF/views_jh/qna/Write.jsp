<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>Q&A-작성&수정</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
<div class="Tiles_wrap">
	<c:choose>
		<c:when test="${map.IDX == null}">
			<form id="Write">
		</c:when>
		<c:otherwise>
			<form id="Modify">
				<input type="hidden" name="IDX" value="${map.IDX}">
				<input type="hidden" name="CHK" value="0">
		</c:otherwise>
	</c:choose>
	<input type="hidden" name="ID" value="${ID}" />
		<table align="center" style="border:1px solid #ccc; width:100%;height:400px;">
			<colgroup>
				<col width="15%">
				<col width="*"/>
			</colgroup>
			<c:choose>
				<c:when test="${map.IDX == null}">
					<caption>Q&A 작성</caption>
				</c:when>
				<c:otherwise>
					<caption>Q&A 수정</caption>
				</c:otherwise>
			</c:choose>
			<tbody>
				<tr>
					<th scope="row">제목</th>
					<td><input type="text" name="TITLE" value="${map.TITLE}"></input></td>
				</tr>
				<tr>
					<th scope="row">내용</th>
					<td>
						<textarea rows="20" cols="100" name="CONTENT">${map.CONTENT}</textarea>
					</td>
				</tr>
			</tbody>
		</table>
		<br><br>
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
</div>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#list").on("click", function(e){ //목록으로 버튼
				e.preventDefault();
				fn_qnaList();
			});
			$("#write").on("click", function(e){ //작성하기 버튼
				e.preventDefault();
				fn_qnaWrite();
			});
			$("#modify").on("click", function(e){ //수정하기 버튼
				e.preventDefault();
				fn_qnaModify();
			});
		});
		function fn_qnaList(){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/qna/listform' />");
			comSubmit.submit();
		}
		function fn_qnaWrite(){
			var comSubmit = new ComSubmit("Write");
			comSubmit.setUrl("<c:url value='/qna/write' />");
			return validation()?comSubmit.submit():false;
		}
		function fn_qnaModify(){
			var comSubmit = new ComSubmit("Modify");
			comSubmit.setUrl("<c:url value='/qna/modify' />");
			return validation()?comSubmit.submit():false;
		}
		
		function validation() {		
			if($("input[name='TITLE']").val() == "") {
				alert("제목을 입력해주세요");
				return false;
			}
			else if($("textarea[name='CONTENT']").val() == "") {
				alert("내용을 입력해주세요");
				return false;
			}
			return true;
		}
	</script>
</body>
</html>