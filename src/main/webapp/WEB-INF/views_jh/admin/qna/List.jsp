<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Q&A</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
	<h2>관리자-Q&A 목록</h2>
	<table align="center" style="border:1px solid #ccc; width:70%;">
		<colgroup>
			<col width="10%"/>
			<col width="20%"/>
			<col width="10%"/>
			<col width="15%"/>
			<col width="25%"/>
			<col width="10%"/>
			<col width="10%"/>
		</colgroup>
		<thead>
			<tr>
				<th scope="col">글번호</th>
				<th scope="col">제목</th>
				<th scope="col">회원ID</th>
				<th scope="col">작성일</th>
				<th scope="col">내용</th>
				<th scope="col">답변여부</th>
				<th scope="col">삭제여부</th>
			</tr>
		</thead>
		<tbody>
			<%-- <c:choose>
				<c:when test="${fn:length(list) > 0}">
					<c:forEach items="${list }" var="row">
						<tr>
							<td align="center">${row.IDX }</td>
							<td align="center">
								<a href="#this" name="title">${row.TITLE }</a>
								<input type="hidden" id="IDX" value="${row.IDX }">
							</td>
							<td align="center">${row.ID }</td>
							<td align="center">${row.REG }</td>
							<td align="center">${row.CONTENT }</td>
							<td align="center">
								<c:choose>
									<c:when test="${row.CHK == 0}">
										질문
									</c:when>
									<c:otherwise>
										답변
									</c:otherwise>
								</c:choose>
							</td>
							<td align="center">
								<c:if test="${row.DEL_CHK == 1}">
									삭제됨
								</c:if>
							</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="7">조회된 결과가 없습니다.</td>
					</tr>
				</c:otherwise>
			</c:choose> --%>
		</tbody>
	</table>
	<br><br>
	<div align="center" id="PAGE_NAVI"></div>
	<input type="hidden" id="PAGE_INDEX" name="PAGE_INDEX"/>
	<a style="color:red" href="http://localhost:8080/hospital/page.jsp">홈으로</a>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		$(document).ready(function(){
			fn_selectQnaList(1);
		});
		function fn_qnaDetail(obj){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/qna/detail' />");
			comSubmit.addParam("IDX", obj.parent().find("#IDX").val());
			comSubmit.submit();
		}
		
		function fn_selectQnaList(pageNo){
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/admin/qna/list' />");
			comAjax.setCallback("fn_selectQnaListCallback");
			comAjax.addParam("PAGE_INDEX",pageNo);
			comAjax.addParam("PAGE_ROW", 10);
			comAjax.ajax();
		}
		function fn_selectQnaListCallback(data){
			var total = data.TOTAL;
			var body = $("table>tbody");
			body.empty();
			if(total == 0){
				var str = "<tr>" + 
								"<td colspan='3' align='center'>작성한 게시물이 없습니다.</td>" + 
							"</tr>";
				body.append(str);
			} else {
				var params = {
					divId : "PAGE_NAVI",
					pageIndex : "PAGE_INDEX",
					totalCount : total,
					eventName : "fn_selectQnaList"
				};
				gfn_renderPaging(params);
				var str = "";
				$.each(data.list, function(key, value){
					str += "<tr>" + 
								"<td align='center'>" + value.IDX + "</td>" + 
								"<td>" +
									"<a href='#this' name='title'>" + value.TITLE + "</a>" +
									"<input type='hidden' id='IDX' value=" + value.IDX + ">" + 
								"</td>" +
								"<td align='center'>" + value.ID + "</td>" + 
								"<td align='center'>" + value.REG + "</td>" + 
								"<td align='center'>" + value.CONTENT + "</td>" + 
								"<td align='center'>";
								if(value.A_CHK == 2)
									str += "완료</td>";
						str += "<td align='center'>";
								if(value.DEL_CHK == 1)
									str += "삭제됨</td>";
					str += "</tr>";
				});
				body.append(str);
				
				$("a[name='title']").on("click", function(e){ //상세보기
					e.preventDefault();
					fn_qnaDetail($(this));
				});
			}
		}
	</script>
</body>
</html>