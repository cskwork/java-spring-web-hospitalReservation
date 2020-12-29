<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>공지사항-상세보기</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
	<div class="Notice_detail">
		<h2>공지사항</h2>
		<table align="center">
			<tbody>
				<tr class="tmptr"><td></td></tr>
				<tr>
					<td class="tmptd"></td>
					<td class="Notice_detail_title">${map.TITLE }</td>
					<td class="tmptd"></td>
				</tr>
				
				<tr>
					<td class="tmptd"></td>
					<td class="Notcie_detail_content">${map.CONTENT }</td>
					<td class="tmptd"></td>
				</tr>
				
				<tr>
					<td class="tmptd"></td>
					<td class="Notcie_detail_file">
						<c:forEach var="row" items="${list }">
							<p>
								<input type="hidden" id="F_IDX" value="${row.F_IDX }">
								<a href="#this" name="file">${row.ORG_FILE }</a> 
								(${row.FILE_SIZE }kb)
							</p>
						</c:forEach>
					</td>
					<td class="tmptd"></td>
				</tr>
				
				<tr>
					<td class="tmptd"></td>
					<td class="Notcie_detail_reg">${map.REG }</td>
					<td class="tmptd"></td>
				</tr>
				
				<tr >
					<td class="tmptd"></td>
					<td align="right" style="padding-top: 20px; padding-bottom: 20px;"><a href="#this" class="btn" id="list">목록으로</a></td>
					<td class="tmptd"></td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#list").on("click", function(e){ //목록으로 버튼
				e.preventDefault();
				fn_noticeList();
			});
			$("a[name='file']").on("click", function(e){ //파일 이름
				e.preventDefault();
				fn_downloadFile($(this));
			});
		});
		function fn_noticeList(){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/notice/listform' />");
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