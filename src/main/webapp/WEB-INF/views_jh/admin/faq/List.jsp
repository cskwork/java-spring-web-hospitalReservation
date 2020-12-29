<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>FAQ</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
	<h2>관리자-FAQ 목록</h2>
	<table align="center" style="border:1px solid #ccc; width:70%;">
		<colgroup>
			<col width="70%"/>
			<col width="10%"/>
			<col width="10%"/>
			<col width="10%"/>
		</colgroup>
		<thead>
			<tr>
				<th scope="col">글</th>
				<th scope="col">수정</th>
				<th scope="col">삭제</th>
				<th scope="col">삭제여부</th>
			</tr>
		</thead>
		<tbody>
			<%-- <dl>
				<c:choose>
					<c:when test="${fn:length(list) > 0}">
						<c:forEach items="${list }" var="row">
							<tr>
								<td>
									<dt>
										<span>Q${row.IDX }.</span>
										<a href="#" onclick="toggles('answer_${row.IDX }')">
											<span>
												${row.Q }
											</span>
										</a>
									</dt>
									<dd id="answer_${row.IDX }" style="display:none;">
										<div>${row.A }</div>
									</dd>
								</td>
								<td align="center">
									<a href="#this" class="btn" name="modify">수정</a>
									<input type="hidden" id="IDX" value="${row.IDX }">
								</td>
								<td align="center">
									<a href="#this" class="btn" name="delete">삭제</a>
									<input type="hidden" id="IDX" value="${row.IDX }">
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
							<td colspan="4">조회된 결과가 없습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</dl> --%>
		</tbody>
	</table>
	<br><br>
	<div align="right">
		<a href="#this" class="btn" id="write">작성하기</a>
	</div>
	<div align="center" id="PAGE_NAVI"></div>
	<input type="hidden" id="PAGE_INDEX" name="PAGE_INDEX"/>
	<a style="color:red" href="http://localhost:8080/hospital/page.jsp">홈으로</a>		
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		$(document).ready(function(){
			fn_selectFaqList(1);
			$("#write").on("click", function(e){ //글쓰기 버튼
				e.preventDefault();
				fn_faqWrite();
			});
			$("a[name='A']").on("click", function(e){ //A 이벤트
				e.preventDefault();
				toggles($(this));
			});
		});
		function fn_faqWrite(){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/faq/writeform' />");
			comSubmit.submit();
		}
		function fn_faqModify(obj){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/faq/modifyform' />");
			comSubmit.addParam("IDX", obj.parent().find("#IDX").val());
			comSubmit.submit();
		}
		function fn_faqDelete(obj){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/faq/delete' />");
			comSubmit.addParam("IDX", obj.parent().find("#IDX").val());
			comSubmit.submit();
			alert("삭제되었습니다.");
		}
		function toggles(var1) {
			if(document.getElementById(var1).style.display == "none")
				document.getElementById(var1).style.display = "";
			else {
				document.getElementById(var1).style.display = "none";
			}
		}
		
		function fn_selectFaqList(pageNo){
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/admin/faq/list' />");
			comAjax.setCallback("fn_selectFaqListCallback");
			comAjax.addParam("PAGE_INDEX",pageNo);
			comAjax.addParam("PAGE_ROW", 10);
			comAjax.ajax();
		}
		function fn_selectFaqListCallback(data){
			var total = data.TOTAL;
			var body = $("table>tbody");
			body.empty();
			if(total == 0){
				var str = "<tr>" + 
							"<td colspan='4' align='center'>작성한 게시물이 없습니다.</td>" + 
						"</tr>";
				body.append(str);
			} else {
				var params = {
					divId : "PAGE_NAVI",
					pageIndex : "PAGE_INDEX",
					totalCount : total,
					eventName : "fn_selectFaqList"
				};
				gfn_renderPaging(params);
				var str = "";
				$.each(data.list, function(key, value){
					str += "<tr>" + 
								"<td>" + 
									"<dt style='border:1px solid #ccc; font-size: 25px; height:40px;'>" + 
										"<span>Q" + value.IDX + ".</span>" + 
										"<a href='#' onclick=\"toggles('answer_" + value.IDX + "')\">" + 
											"<span>" + value.Q + "</span>" + 
										"</a>" +
									"</dt>" + 
									"<dd id='answer_" + value.IDX + "' style='display:none; font-size: 20px;'>" + 
										"<div>" + value.A + "</div>" + 
									"<dd>" + 
								"</td>" + 
								"<td align='center'>" + 
									"<a href='#this' class='btn' name='modify'>수정</a>" + 
									"<input type='hidden' id='IDX' value='" + value.IDX + "'>" +
								"</td>" + 
								"<td align='center'>" + 
									"<a href='#this' class='btn' name='delete'>삭제</a>" + 
									"<input type='hidden' id='IDX' value='" + value.IDX + "'>" +
								"</td>" + 
								"<td align='center'>";
								if(value.DEL_CHK == 1)
									str += "삭제됨</td>";
					str += "</tr>";
				});
				body.append(str);
				$("a[name='modify']").on("click", function(e){ //수정하기 버튼
					e.preventDefault();
					fn_faqModify($(this));
				});
				$("a[name='delete']").on("click", function(e){ //삭제하기 버튼
					e.preventDefault();
					fn_faqDelete($(this));
				});
			}
		}
	</script>
</body>
</html>