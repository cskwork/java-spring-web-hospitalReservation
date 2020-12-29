<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Q&A</title>

<%@ include file="/WEB-INF/include/include-header.jspf" %>

</head>
<body>
	<div class="QnA_list">
		<h2>Q&A 목록</h2>
		<table align="center" style="width: 700px; margin: auto;">
			<colgroup>
				<col width="5%"/>
				<col width="65%"/>
				<col width="18%"/>
				<col width="12%"/>
			</colgroup>
			<thead valign="top">
				<tr>
					<th scope="col">
						<input type="checkbox" name="checkAll" id="th_checkAll" onclick="checkAll();"/>
					</th>
					<th scope="col" class="QnA_list_th">제목</th>
					<th scope="col" id="th_Graduation" class="QnA_list_th">작성일</th>
					<th scope="col"  class="QnA_list_th">답변여부</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		
		<div align="center" id="PAGE_NAVI"></div>
		
		<input type="hidden" id="PAGE_INDEX" name="PAGE_INDEX" value="1"/>
		
		<a href="#this" class="btn" id="delete">삭제</a>
	</div>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		$(document).ready(function(){
			fn_selectQnaList(1);
			$("#delete").on("click", function(e){
				e.preventDefault();
				fn_qnaDelete();
			});
		});
		
		function fn_qnaDetail(obj){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/qna/detail' />");
			comSubmit.addParam("IDX", obj.parent().find("#IDX").val());
			comSubmit.submit();
		}

		var pagerow = 15;
		function fn_selectQnaList(pageNo){
			var ID = $("#ID").val();
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/qna/list' />");
			comAjax.setCallback("fn_selectQnaListCallback");
			comAjax.addParam("PAGE_INDEX",pageNo);
			comAjax.addParam("PAGE_ROW", pagerow);
			comAjax.addParam("ID", ID);
			comAjax.ajax();
		}
		
		function fn_selectQnaListCallback(data){
			var total = data.TOTAL;
			var body = $("table>tbody");
			body.empty();
			if(total == 0){
				var str = "" + 
					"<tr>" + 
					"	<td colspan='4' align='center'>작성한 게시물이 없습니다.</td>" + 
					"</tr>";
					
				body.append(str);
			} else {
				var params = {
					divId : "PAGE_NAVI",
					pageIndex : "PAGE_INDEX",
					totalCount : total,
					eventName : "fn_selectQnaList",
					recordCount : pagerow
				};
				
				if(pagerow < total)
					gfn_renderPaging(params);
				
				var str = "";
				var num = 0;
				var first = ($("#PAGE_INDEX").val() - 1) * pagerow;
				var last = $("#PAGE_INDEX").val() * pagerow;

				$.each(data.list, function(key, value) {
					if(first <= num && num < last) {
						str += "" +
							"<tr class='tmptr'><td colspan='4'></td></tr>" +
							"<tr>" + 
							"	<td align='center'>" +
							"		<input type='checkbox' id='checkRow' name='checkRow' value=" + value.IDX + ">" + 
							"	</td>" +
							"	<td>" +
							"		<a href='#this' name='title'>" + value.TITLE + "</a>" +
							"		<input type='hidden' id='IDX' value=" + value.IDX + ">" + 
							"	</td>" +
							"	<td id='td_Graduation' align='center'>" + value.REG + "</td>" +
							"<td align='center'>";
						if(value.A_CHK == 2)
							str += "완료";
													
						str += "" + 
							"	</td>" +
							"</tr>" + 
							"<tr class='tmptr'";
					
						if(num < last - 1)
							str += "style='border-bottom: 1px solid #cccccc;'";
							
						str += "><td colspan='4'></td></tr>";
						
						num++;
					} else {
						num++;
					}
				});
				
				body.append(str);
				
				$("a[name='title']").on("click", function(e){ //상세보기
					e.preventDefault();
					fn_qnaDetail($(this));
				});
			}
		}
		
		function fn_qnaDelete(){
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
					comSubmit.setUrl("<c:url value='/qna/delete' />");
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