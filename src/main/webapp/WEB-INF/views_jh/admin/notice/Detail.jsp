<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>공지사항-상세보기</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
	<table align="center" style="border:1px solid #ccc; width:60%; height:500px;">
		<colgroup>
			<col width="15%"/>
			<col width="35%"/>
			<col width="15%"/>
			<col width="35%"/>
		</colgroup>
		<caption>관리자-게시글 상세</caption>
		<tbody>
			<tr height="10%">
				<th scope="row">글 번호</th>
				<td>${map.IDX }</td>
				<th scope="row">조회수</th>
				<td>${map.HITS }</td>
			</tr>
			<tr height="10%">
				<th scope="row">작성시간</th>
				<td colspan="3">${map.REG }</td>
			</tr>
			<tr height="10%">
				<th scope="row">제목</th>
				<td colspan="3">${map.TITLE }</td>
			</tr>
			<tr height="45%">
				<th scope="row">내용</th>
				<td colspan="3">${map.CONTENT }</td>
			</tr>
			<tr height="25%">
				<th scope="row">첨부파일</th>
				<td colspan="3">
					<c:forEach var="row" items="${list }">
						<p>
							<input type="hidden" id="F_IDX" value="${row.F_IDX }">
							<a href="#this" name="file">${row.ORG_FILE }</a> 
							(${row.FILE_SIZE }kb)
						</p>
					</c:forEach>
				</td>
			</tr>
		</tbody>
	</table>
	<a href="#this" class="btn" id="list">목록으로</a>
	<a href="#this" class="btn" id="modify">수정하기</a>
	<a href="#this" class="btn" id="delete">삭제하기</a>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#list").on("click", function(e){ //목록으로 버튼
				e.preventDefault();
				fn_noticeList();
			});
			$("#modify").on("click", function(e){ //수정하기 버튼
				e.preventDefault();
				fn_noticeModify();
			});
			$("#delete").on("click", function(e){ //삭제하기 버튼
				e.preventDefault();
				fn_noticeDelete();
			});
			$("a[name='file']").on("click", function(e){ //파일 이름
				e.preventDefault();
				fn_downloadFile($(this));
			});
		});
		function fn_noticeList(){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/notice/listform' />");
			comSubmit.submit();
		}
		function fn_noticeModify(){
			var idx = "${map.IDX}";
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/notice/modifyform' />");
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();
		}
		function fn_noticeDelete(){
			var idx = "${map.IDX}";
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/notice/delete' />");
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();
		}
		function fn_downloadFile(obj){
			var f_idx = obj.parent().find("#F_IDX").val();
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/common/downloadFile' />");
			comSubmit.addParam("F_IDX", f_idx);
			comSubmit.submit();
		}
	</script>
</body>
</html>