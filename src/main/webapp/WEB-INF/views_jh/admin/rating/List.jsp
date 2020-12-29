<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>진료후기</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
	<h2>관리자-진료후기 목록</h2>
	<table align="center" style="width:70%; border:1px solid #ccc;">
		<colgroup>
			<col width="10%"/>
			<col width="10%"/>
			<col width="10%"/>
			<col width="10%"/>
			<col width="10%"/>
			<col width="10%"/>
			<col width="20%"/>
			<col width="20%"/>
		</colgroup>
		<thead valign="top">
			<tr>
				<th scope="col">병원번호</th>
				<th scope="col">ID</th>
				<th scope="col">의사진료 만족도</th>
				<th scope="col">간호사 친절성</th>
				<th scope="col">청결성</th>
				<th scope="col">대기시간 만족도</th>
				<th scope="col">후기</th>
				<th scope="col">작성일</th>
			</tr>
		</thead>
		<tbody>
			<%-- <c:choose>
				<c:when test="${fn:length(list) > 0}">
					<c:forEach items="${list }" var="row">
						<tr>
							<td align="center">${row.H_IDX }</td>
							<td align="center">${row.ID }</td>
							<td align="center">${row.RATE1 }</td>
							<td align="center">${row.RATE2 }</td>
							<td align="center">${row.RATE3 }</td>
							<td align="center">${row.RATE4 }</td>
							<td align="center">${row.COMM }</td>
							<td align="center">${row.REG }</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="8">조회된 결과가 없습니다.</td>
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
			fn_selectAdminNoticeList(1);
		});
		function fn_selectAdminNoticeList(pageNo){
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/admin/rating/list' />");
			comAjax.setCallback("fn_selectAdminNoticeListCallback");
			comAjax.addParam("PAGE_INDEX",pageNo);
			comAjax.addParam("PAGE_ROW", 10);
			comAjax.ajax();
		}
		function fn_selectAdminNoticeListCallback(data){
			var total = data.TOTAL;
			var body = $("table>tbody");
			body.empty();
			if(total == 0){
				var str = "<tr>" + 
								"<td colspan='8' align='center'>조회된 결과가 없습니다.</td>" + 
							"</tr>";
				body.append(str);
			} else {
				var params = {
					divId : "PAGE_NAVI",
					pageIndex : "PAGE_INDEX",
					totalCount : total,
					eventName : "fn_selectAdminNoticeList"
				};
				gfn_renderPaging(params);
				var str = "";
				$.each(data.list, function(key, value){
					str += "<tr>" + 
								"<td align='center'>" + value.H_IDX + "</td>" + 
								"<td align='center'>" + value.ID + "</td>" + 
								"<td align='center'>" + value.RATE1 + "</td>" + 
								"<td align='center'>" + value.RATE2 + "</td>" + 
								"<td align='center'>" + value.RATE3 + "</td>" + 
								"<td align='center'>" + value.RATE4 + "</td>" + 
								"<td align='center'>" + value.COMM + "</td>" + 
								"<td align='center'>" + value.REG + "</td>" + 
							"</tr>";
				});
				body.append(str);
			}
		}
	</script>
</body>
</html>