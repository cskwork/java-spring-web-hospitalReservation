<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>공지사항</title>

<%@ include file="/WEB-INF/include/include-header.jspf" %>

</head>
<body>
	<div class="Notice_list">
		<h2>공지사항</h2>
		<table align="center" style="width:700px; height: auto;">
			<colgroup>
				<col width="72"/>
				<col width="18%"/>
				<col width="10%"/>
			</colgroup>
			<thead valign="top">
				<tr>
					<th scope="col" class="Notice_list_th">제목</th>
					<th scope="col" id="th_Graduation" class="Notice_list_th">작성일</th>
					<th scope="col"  class="Notice_list_th">조회수</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		
		<div align="center" id="PAGE_NAVI" style="margin-top: 20px;"></div>
		
		<input type="hidden" id="PAGE_INDEX" name="PAGE_INDEX" value="1"/>
	</div>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	
	<script type="text/javascript">
		$(document).ready(function() {
			window.onload = function() {
				fn_selectNoticeList(1);
			};	
		});
		
		var pagerow = 15;
		function fn_selectNoticeList(pageNo){
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/notice/list' />");
			comAjax.setCallback("fn_selectNoticeListCallback");
			comAjax.addParam("PAGE_INDEX", pageNo);
			comAjax.addParam("PAGE_ROW", pagerow);
			comAjax.ajax();
		}
		
		function fn_noticeDetail(obj){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/notice/detail' />");
			comSubmit.addParam("IDX", obj.parent().find("#IDX").val());
			comSubmit.submit();
		}
		
		function fn_selectNoticeListCallback(data){
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
					eventName : "fn_selectNoticeList",
					recordCount : pagerow
				};
				gfn_renderPaging(params);
				
				var str = "";
				
				var num = 0; 
				var first = ($("#PAGE_INDEX").val() - 1) * pagerow;
				var last = $("#PAGE_INDEX").val() * pagerow;

				$.each(data.list, function(key, value) {
					if(first <= num && num < last) {
						str += "" +
							"<tr class='tmptr'><td colspan='3'></td></tr>" +
							"<tr>" + 
							"	<td>" +
							"		<a href='#this' name='title'>" + value.TITLE + (value.F_CHK != null ? " [첨부: " + value.F_CHK + "]</a>" : "</a>") +
							"		<input type='hidden' id='IDX' value=" + value.IDX + ">" + 
							"	</td>" +
							"	<td id='td_Graduation' align='center'>" + value.REG + "</td>" + 
							"	<td align='center'>" + value.HITS + "</td>" + 
							"</tr>" + 
							"<tr class='tmptr'";
							
						if(num < last - 1)
							str += "style='border-bottom: 1px solid #cccccc;'";
							
						str += "><td colspan='3'></td></tr>";
						
						num++;
					} else {
						num++;
					}
				});
				
				body.append(str);
				
				$("a[name='title']").on("click", function(e){ //상세보기
					e.preventDefault();
					fn_noticeDetail($(this));
				});
			}
		}
	</script>
</body>
</html>