<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
 <body>
	<h2>회원 목록</h2>
	<table class="board_list">
		<colgroup>
			<col width="7.6%"/>
			<col width="7.6%"/>
			<col width="7.6%"/>
			<col width="7.6%"/>
			<col width="7.6%"/>
			<col width="7.6%"/>
			<col width="7.6%"/>
			<col width="7.6%"/>
			<col width="7.6%"/>
			<col width="7.6%"/>
			
			<col width="7.6%"/>
			<col width="7.6%"/>
			<col width="7.6%"/>
		</colgroup>
		<thead>
			<tr>
				<th scope="col">ID/EMAIL</th>
				<th scope="col">이름</th>
				<th scope="col">암호</th>
				<th scope="col">문자수신</th>
				<th scope="col">전화번호</th>
				<th scope="col">주소</th>
				<th scope="col">주민등록번호</th>
				<th scope="col">마지막 접속일</th>
				<th scope="col">신장</th>
				
				<th scope="col">몸무게</th>
				<th scope="col">혈액형</th>
				<th scope="col">포인트</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	
	<div id="PAGE_NAVI" align="center"></div>
	<input type="hidden" id="PAGE_INDEX" name="PAGE_INDEX" />

	<br/>
<!-- 	<a href="#this" class="btn" id="write">회원추가</a>
	  -->
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	
	<script type="text/javascript">
		$(document).ready(function(){
			fn_selectBoardList(1);

			$("#write").on("click", function(e){ //글쓰기 버튼
				e.preventDefault();
				fn_openBoardWrite();
			}); 
		});

		function fn_openBoardDetail(obj){
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/member/info' />");
			comSubmit.addParam("IDX", obj.parent().find("#IDX").val()); 
			comSubmit.submit();
		}

		var pagerow = 12;
		
		function fn_selectBoardList(pageNo){
			var comAjax = new ComAjax();			
			comAjax.setUrl("<c:url value='/member/list2' />");
			comAjax.setCallback("fn_selectBoardListCallback");
			comAjax.addParam("PAGE_INDEX", pageNo);
			comAjax.addParam("PAGE_ROW", pagerow);
			comAjax.ajax();
		}
			
		function fn_selectBoardListCallback(data){
			var total = data.TOTAL;
			var body = $(".board_list>tbody");
			
			body.empty();
			
			if(total == 0) {
				var str = ""
				+ "<tr>"
				+ "<td colspan='4'>조회된 결과가 없습니다.</td>"
				+ "</tr>";
		
				body.append(str);
			} else {
				var params = {
					divId : "PAGE_NAVI",
					pageIndex : "PAGE_INDEX",
					totalCount : total,
					eventName : "fn_selectBoardList",
					recordCount : pagerow
				};
				
				gfn_renderPaging(params);
				 
				
				var str = "";
				
			    $.each(data.list, function(key, value){				 	
					str += ""
					+ "<td class='title'>" + value.ID + "</td>"
					+ "<td>" + value.NAME + "</td>"
					+ "<td>" + value.PWD + "</td>"
					+ "<td>" + value.MMS_CHK + "</td>"
					+ "<td>" + value.PHONE + "</td>"
					+ "<td>" + value.ADDR + "</td>"
					+ "<td>" + value.JUMIN + "</td>"
					+ "<td>" + value.JOINDATE + "</td>";
					
				 	if(typeof value.HEIGHT == 'undefined'){	
				 		str += "<td>(NULL)</td>"
					} else{
						str += "<td>" + value.HEIGHT + "</td>"
					}
					
					if(typeof value.WEIGHT == 'undefined'){	
						str += "<td>(NULL)</td>"
					} else{
						str += "<td>" + value.WEIGHT + "</td>"
					}

					if(typeof value.B_TYPE == 'undefined'){	
						str += "<td>(NULL)</td>"
					} else{
						str += "<td>" + value.B_TYPE + "</td>"
					}
					if(typeof value.POINT == 'undefined'){					
						str += "<td>0</td>"
					} else{
						str += "<td>" + value.POINT + "</td>"
					} 
	
					str += "</tr>";
				});

				body.append(str);
				
 				$("a[name='title']").on("click", function(e){ //제목
					e.preventDefault();
					fn_openBoardDetail($(this));
				}); 
			}
		}
	</script> 
</body>
</html>

<!-- http://localhost:8080/first/sample/openBoardList.do -->



