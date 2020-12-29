<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>Q&A-상세보기</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
<div class="Tiles_wrap">
	<table align="center" style="border:1px solid #ccc; width:60%;height:400px;">
		<colgroup>
			<col width="15%"/>
			<col width="35%"/>
			<col width="15%"/>
			<col width="35%"/>
		</colgroup>
		<caption>질문 답변 상세내용</caption>
		<tbody>
			<tr>
				<th scope="row">글 번호</th>
				<td>${map1.IDX }</td>
				<th scope="row">작성시간</th>
				<td>${map1.REG }</td>
			</tr>
			<tr>
				<th scope="row">회원ID</th>
				<td>${map1.ID }</td>
				<th scope="row">답변 상태</th>
				<td align="center">
					<c:choose>
						<c:when test="${map2.CHK == null}">
							답변 NO
						</c:when>
						<c:otherwise>
							답변 OK
						</c:otherwise>
					</c:choose>
				</td>
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
				<c:choose>
					<c:when test="${map2.CONTENT == null}">
						<td colspan="3">등록된 답변이 없습니다.</td>
					</c:when>
					<c:otherwise>
						<td colspan="3">${map2.CONTENT }</td>
					</c:otherwise>
				</c:choose>
			</tr>
		</tbody>
	</table>
	<br><br>
	<a href="#this" class="btn" id="list">목록으로</a>
	<a href="#this" class="btn" id="modify">수정하기</a>
	<a href="#this" class="btn" id="delete">삭제하기</a>
</div>
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#list").on("click", function(e){ //목록으로 버튼
				e.preventDefault();
				fn_qnaList();
			});
			$("#modify").on("click", function(e){ //수정하기 버튼
				e.preventDefault();
				fn_qnaModify();
			});
			$("#delete").on("click", function(e){ //삭제하기 버튼
				e.preventDefault();
				fn_qnaDelete();
			});
		});
		function fn_qnaList(){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/qna/listform' />");
			comSubmit.submit();
		}
		function fn_qnaModify(){
			var idx = "${map1.IDX}";
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/qna/modifyform' />");
			comSubmit.addParam("IDX", idx);
			//comSubmit.addParam("CHK", 0);
			comSubmit.submit();
		}
		function fn_qnaDelete(){
			var idx = "${map1.IDX}";
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/qna/delete' />");
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();
		}
	</script>
</body>
</html>