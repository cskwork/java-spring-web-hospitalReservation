<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>공지사항</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
	<h2>관리자-게시판 목록</h2>
	<table align="center" style="width:70%; border:1px solid #ccc; height:400px;">
		<colgroup>
			<col width="5%"/>
			<col width="10%"/>
			<col width="30%"/>
			<col width="25%"/>
			<col width="15%"/>
			<col width="15%"/>
		</colgroup>
		<thead valign="top">
			<tr>
				<th scope="col">
					<input type="checkbox" name="checkAll" id="th_checkAll" onclick="checkAll();"/>
				</th>
				<th scope="col">글번호</th>
				<th scope="col">제목</th>
				<th scope="col">작성일</th>
				<th scope="col">조회수</th>
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
							<td align="left">${row.CONTENT }</td>
							<td align="center">${row.REG }</td>
							<td align="center">${row.HITS }</td>
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
						<td colspan="5">조회된 결과가 없습니다.</td>
					</tr>
				</c:otherwise>
			</c:choose> --%>
		</tbody>
	</table>
	<br><br>
	<div align="center" id="PAGE_NAVI"></div>
	<input type="hidden" id="PAGE_INDEX" name="PAGE_INDEX"/>
	<a style="color:red" href="http://localhost:8080/hospital/page.jsp">홈으로</a>
	<div align="right">
		<a href="#this" class="btn" id="write">작성하기</a>
	</div>
	<a href="#this" class="btn" id="delete">삭제</a>

	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		$(document).ready(function(){
			fn_selectAdminNoticeList(1);
			$("#write").on("click", function(e){ //글쓰기 버튼
				e.preventDefault();
				fn_noticeWrite();
			});
			$("#delete").on("click", function(e){
				e.preventDefault();
				fn_noticeDelete();
			});
		});
		function fn_noticeDetail(obj){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/notice/detail' />");
			comSubmit.addParam("IDX", obj.parent().find("#IDX").val());
			comSubmit.submit();
		}
		function fn_noticeWrite(){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/admin/notice/writeform' />");
			comSubmit.submit();
		}
		function fn_selectAdminNoticeList(pageNo){
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/admin/notice/list' />");
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
								"<td colspan='5' align='center'>작성한 게시물이 없습니다.</td>" + 
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
								"<td align='center'>" +
									"<input type='checkbox' id='checkRow' name='checkRow' value=" + value.IDX + ">" + 
								"</td>" +
								"<td align='center'>" + value.IDX + "</td>" + 
								"<td>" +
									"<a href='#this' name='title'>" + value.TITLE;
									if(value.F_CHK != null)
										str += " [첨부: " + value.F_CHK + "]</a>";
							str += "<input type='hidden' id='IDX' value=" + value.IDX + ">" + 
								"</td>" +
								"<td align='center'>" + value.REG + "</td>" + 
								"<td align='center'>" + value.HITS + "</td>" + 
								"<td align='center'>";
									if(value.DEL_CHK == 1)
										str += "삭제됨";
						str += "</td>" + 
							"</tr>";
				});
				body.append(str);
				
				$("a[name='title']").on("click", function(e){ //상세보기
					e.preventDefault();
					fn_noticeDetail($(this));
				});
			}
		}
		
		function fn_noticeDelete(){
			var comSubmit = new ComSubmit();
			var parent = document.getElementsByName('checkRow');
			var idx = new Array();
			var num = 0;
			
			for(var i = 0; i < parent.length; i++) {
				if(parent[i].checked == true) {
					idx[num++] = parent[i].value;
				}
			}
			
			if(num==0){
				alert("삭제할 질문을 선택하세요");
			} else {
				if(confirm("정말 삭제하시겠습니까?") == true) {
					comSubmit.setUrl("<c:url value='/admin/notice/delete' />");
					comSubmit.addParam("IDX", idx);
					comSubmit.submit();
				} else {
					$("#th_checkAll").prop("checked", false);
					$("input[id=checkRow]").prop("checked", false);
					
					return;
				}
			}
		}
		
		function checkAll(){
		    if($("#th_checkAll").is(':checked') ) {
		      $("input[id=checkRow]").prop("checked", true);
		    } else {
		      $("input[id=checkRow]").prop("checked", false);
		    }
		}
	</script>
</body>
</html>