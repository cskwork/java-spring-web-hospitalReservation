<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>Q&A-상세보기</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
	<table align="center" style="border:1px solid #ccc; width:60%;height:400px">
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
				<td>${map1.ID }</td>
				<th scope="row">답변 상태</th>
				<td align="center">
					<c:choose>
						<c:when test="${map2.CHK == null}">
							답변 아직
						</c:when>
						<c:otherwise>
							답변 완 (${map2.REG})
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
	<a href="#this" class="btn" id="deleteQ">질문삭제</a>
	
	<c:choose>
		<c:when test="${map2.IDX == null}">
			<a href="#this" class="btn" id="write">답변작성</a>
		</c:when>
		<c:otherwise>
			<a href="#this" class="btn" id="modify">답변수정</a>
			<a href="#this" class="btn" id="deleteA">답변삭제</a>
		</c:otherwise>
	</c:choose>

	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#list").on("click", function(e){ //목록으로 버튼
				e.preventDefault();
				fn_qnaList();
			});
			$("#deleteQ").on("click", function(e){ //질문삭제 버튼
				e.preventDefault();
				fn_qnaDeleteQ();
			});
			$("#write").on("click", function(e){ //답변작성 버튼
				e.preventDefault();
				fn_qnaWrite();
			});
			$("#modify").on("click", function(e){ //답변수정 버튼
				e.preventDefault();
				fn_qnaModify();
			});
			$("#deleteA").on("click", function(e){ //답변삭제 버튼
				e.preventDefault();
				fn_qnaDeleteA();
			});
		});
		function fn_qnaList(){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/qna/listform' />");
			comSubmit.submit();
		}
		function fn_qnaDeleteQ(){
			var idx = "${map1.IDX}";
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/qna/delete' />");
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();
		}
		function fn_qnaWrite(){
			var idx = "${map1.IDX}";
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/qna/writeform' />");
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();
		}
		function fn_qnaModify(){
			var idx = "${map2.IDX}";
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/qna/modifyform' />");
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();
		}
		function fn_qnaDeleteA(){
			var idx = "${map2.IDX}";
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/qna/admindelete' />");
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();
		}
	</script>
</body>
</html>