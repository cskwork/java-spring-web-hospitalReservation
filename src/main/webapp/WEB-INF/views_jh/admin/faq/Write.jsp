<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>FAQ-작성&수정</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
	<c:choose>
		<c:when test="${map.IDX == null}">
			<form id="Write">
		</c:when>
		<c:otherwise>
			<form id="Modify">
				<input type="hidden" name="IDX" value="${map.IDX}">
		</c:otherwise>
	</c:choose>
		<table border="1">
			<colgroup>
				<col width="15%">
				<col width="*"/>
			</colgroup>
			<caption>관리자-게시글</caption>
			<tbody>
				<tr>
					<th scope="row">질문</th>
					<td><input type="text" name="Q" value="${map.Q}"></input></td>
				</tr>
				<tr>
					<th scope="row">답변</th>
					<td>
						<textarea rows="20" cols="100" name="A">${map.A}</textarea>
					</td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="2" align="right">
						<c:choose>
							<c:when test="${map.IDX == null}">
								<a href="#this" class="btn" id="write">작성 완료</a>
							</c:when>
							<c:otherwise>
								<a href="#this" class="btn" id="modify">수정 완료</a>
							</c:otherwise>
						</c:choose>
						<a href="#this" class="btn" id="list">목록으로</a>
					</td>
				</tr>
			</tfoot>
		</table>
	</form>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#list").on("click", function(e){ //목록으로 버튼
				e.preventDefault();
				fn_faqList();
			});
			$("#write").on("click", function(e){ //작성하기 버튼
				e.preventDefault();
				fn_faqWrite();
			});
			$("#modify").on("click", function(e){ //수정하기 버튼
				e.preventDefault();
				fn_faqModify();
			});
		});
		function fn_faqList(){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/faq/listform' />");
			comSubmit.submit();
		}
		function fn_faqWrite(){
			var comSubmit = new ComSubmit("Write");
			comSubmit.setUrl("<c:url value='/admin/faq/write' />");
			return validation()?comSubmit.submit():false;
		}
		function fn_faqModify(){
			var comSubmit = new ComSubmit("Modify");
			comSubmit.setUrl("<c:url value='/admin/faq/modify' />");
			return validation()?comSubmit.submit():false;
		}
		
		function validation() {
			var frm = document.forms[0];
			if(frm.Q.value == "") {
				alert("제목을 입력해주세요");
				return false;
			}
			else if(frm.A.value == "") {
				alert("내용을 입력해주세요");
				return false;
			}
			return true;
		}
	</script>
</body>
</html>