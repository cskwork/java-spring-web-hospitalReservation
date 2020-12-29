<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>Q&A-작성&수정</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
	<c:choose>
		<c:when test="${map2.IDX == null}">
			<form id="Write">
		</c:when>
		<c:otherwise>
			<form id="Modify">
				<input type="hidden" name="CHK" value="1">
		</c:otherwise>
	</c:choose>
		<input type="hidden" name="IDX" value="${map1.IDX}">
		<input type="hidden" name="TITLE" value="${map1.TITLE}">
		<table align="center" border="1" style="border:1px solid #ccc; width:60%;height:400px">
			<colgroup>
				<col width="15%"/>
				<col width="35%"/>
				<col width="15%"/>
				<col width="35%"/>
			</colgroup>
			<caption>관리자-Q&A상세내용</caption>
			<tbody>
				<tr>
					<th scope="row">글 번호</th>
					<td>${map1.IDX }</td>
					<th scope="row">작성시간</th>
					<td align="center">${map1.REG }</td>
				</tr>
				<tr>
					<th scope="row">회원ID</th>
					<td colspan="3">${map1.ID }</td>
				</tr>
				<tr>
					<th scope="row">제목</th>
					<td colspan="3">${map1.TITLE }</td>
				</tr>
				<tr height="40%">
					<th scope="row">질문</th>
					<td colspan="3">${map1.CONTENT }</td>
				</tr>
				<tr height="40%">
					<th scope="row">답변</th>
					<td colspan="3">
						<textarea rows="10" cols="70" name="CONTENT">${map2.CONTENT}</textarea>
					</td>
				</tr>
			</tbody>
		</table>
		<br><br>
		<c:choose>
			<c:when test="${map2.IDX == null}">
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
			comSubmit.setUrl("<c:url value='/admin/qna/listform' />");
			comSubmit.submit();
		}
		function fn_qnaWrite(){
			var comSubmit = new ComSubmit("Write");
			comSubmit.setUrl("<c:url value='/admin/qna/write' />");
			return validation()?comSubmit.submit():false;
		}
		function fn_qnaModify(){
			var comSubmit = new ComSubmit("Modify");
			comSubmit.setUrl("<c:url value='/admin/qna/modify' />");
			return validation()?comSubmit.submit():false;
		}
		
		function validation() {
			var frm = document.forms[0];
			if(frm.CONTENT.value == "") {
				alert("답변을 입력해주세요");
				return false;
			}
			return true;
		}
	</script>
</body>
</html>