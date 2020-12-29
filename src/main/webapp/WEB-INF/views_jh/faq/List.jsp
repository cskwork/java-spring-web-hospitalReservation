<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>FAQ</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
	<div class="Faq_List">
		<h2>FAQ - 자주묻는 질문</h2>
		
		<table>
		</table>

		<div align="center" id="PAGE_NAVI"></div>
		
		<input type="hidden" id="PAGE_INDEX" name="PAGE_INDEX" value="1"/>
	</div>
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		$(document).ready(function(){
			window.onload = function() {
				fn_selectFaqList(1);
			};			
		});
		
		function toggles(obj) {
			var key = obj.parent().find("#index").val();
			
			if(obj.parent().parent().parent().find("#tr" + key).css("display") == "table-row") {
				obj.parent().parent().parent().find("#tr" + key).css("display", "none")
				document.getElementById('td' + key).setAttribute('rowspan', '1' );
				$("#span" + key).css("padding-top", "");
				$("#span" + key).css("padding-bottom", "");
			} else {
				for(num = first; num < last; num++) {
					if(num == key) {
						obj.parent().parent().parent().find("#tr" + num).css("display", "");
						document.getElementById('td' + num).setAttribute('rowspan', '2' );
						var padding = Math.floor(($("#td" + num).height() - $("#td" + num).find(".Faq_List_Q_CLS").height()) / 2) - 13;
						$("#span" + num).css("padding-top", padding);
						$("#span" + num).css("padding-bottom", padding);
					}
					else {
						obj.parent().parent().parent().find("#tr" + num).css("display", "none");
						document.getElementById('td' + num).setAttribute('rowspan', '1' );
						$("#span" + num).css("padding-top", "");
						$("#span" + num).css("padding-bottom", "");
					}
				}
			}
		}

		var pagerow = 15;
		function fn_selectFaqList(pageNo){
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/faq/list' />");
			comAjax.setCallback("fn_selectFaqListCallback");
			comAjax.addParam("PAGE_INDEX",pageNo);
			comAjax.addParam("PAGE_ROW", pagerow);
			
			comAjax.ajax();
		}
		
		var num, first, last;
		function fn_selectFaqListCallback(data){
			var total = data.TOTAL;
			var body = $("table");
			
			body.empty();
			
			if(total == 0){
				var str = "<dt>등록된 게시물이 없습니다.</dt>";
				
				body.append(str);
			} else {
				var params = {
					divId : "PAGE_NAVI",
					pageIndex : "PAGE_INDEX",
					totalCount : total,
					eventName : "fn_selectFaqList",
					recordCount : pagerow
				};
				
				gfn_renderPaging(params);
				
				var str = "";

				// 필요에 의해 변수를 전역변수로 바꿈
				num = 0;
				first = ($("#PAGE_INDEX").val() - 1) * pagerow;
				last = $("#PAGE_INDEX").val() * pagerow;
				
				$.each(data.list, function(key, value){
					if(first <= num && num < last) {
						str += "" + 
							"<tr>" + 
							"	<td id='td" + num + "' rowspan='1' style='width: 150px;'>" + 
							"		<span id='span" + num + "' class='Faq_List_Q_CLS'>[ 분류 ]</span>" +
							"	</td>" +
							"	<td style='width: 598px;'>" +
							"		<span class='Faq_List_FAQ'>Q</span>" +
							"		<a href='#' name='Faq_List_A' >" + 
							"			<span>" + value.Q + "</span>" + 
							"		</a>" +
							"		<input type='hidden' id='index' value='" + key + "'/>" +
							"	</td>" +
							"</tr>" + 

							"<tr id='tr" + key + "' style='display:none; font-size: 20px;'>" +
							"	<td>" +
							"		<span class='Faq_List_FAQ'>A</span>" +
							"		<span>" + value.A + "</span>" + 
							"	</td>" +
							"</tr>";
							
						num++;
					} else {
						num++;
					}
				});
				
				body.append(str);

				$("a[name = 'Faq_List_A']").on("click", function(e) {
					e.preventDefault();
					toggles($(this));
				});
			}
		}
	</script>
</body>
</html>