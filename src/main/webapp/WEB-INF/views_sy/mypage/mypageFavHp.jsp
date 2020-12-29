<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<div class="FavList">		
		<h2>관심병원</h2>
		
		<a href="#this" name="delFavHp">선택삭제</a>
		
		<table>
			<colgroup>
				<col width="5%"/>
				<col width="30%"/>
				<col width="15%"/>
				<col width="*"/>
			</colgroup>
			<thead>
				<tr>
					<th scope="col"><p id="p_border"><input type="checkbox" name="checkAll" id="th_checkAll" onclick="checkAll();"/></p></th>
					<th scope="col"><p id="p_border">병원명</p></th>
					<th scope="col"><p id="p_border">전화번호</p></th>
					<th scope="col"><p				>주소</p></th>
				</tr>
			</thead>
			
			<tbody>
				<c:choose>
					<c:when test="${fn:length(list) > 0}">
						<c:forEach items="${list }" var="row" varStatus="stat">
							<tr>
								<td align="center" id="td"><input type="checkbox" value="${row.H_IDX }" id="checkRow" name="checkRow"/></td>											 
								<td class="title">
									<a href="#this" name="title">${row.HOSP }</a>
								</td>
								<td>${row.TEL }</td>
								<td>${row.ADDR }</td>
							</tr>
						</c:forEach>
					</c:when>
					
					<c:otherwise>
						<tr>
							<td colspan="4">조회된 결과가 없습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>		
	</div>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>

	<script type="text/javascript">
		$(document).ready(function(){
			$("a[name='delFavHp']").on("click", function(e){
				e.preventDefault();
		 		fn_delFavHp();
			});
		});
		
		
		function fn_delFavHp(obj){
			var comSubmit = new ComSubmit();
			var parent = document.getElementsByName('checkRow');
			var h_idx = new Array();
			var num = 0;
			for(var i = 0;i < parent.length; i++)
				if(parent[i].checked == true) {
					h_idx[num++] = parent[i].value;
				}
			if(num == 0){
				alert("관심병원에서 제외할 병원을 선택해주세요");
			}else{
				if(confirm("관심병원에서 삭제하시겠습니까?") == true){
					comSubmit.setUrl("<c:url value='/mypage/DelFavHp' />");
					comSubmit.addParam("H_IDX", h_idx);			
					comSubmit.submit();
				}else{
					$("#th_checkAll").prop("checked", false);
					$("input[id=checkRow]").prop("checked", false);
					return;
				}
			}
		}
		
		function checkAll(){
			if( $("#th_checkAll").is(':checked') ){
			  $("input[id=checkRow]").prop("checked", true);
			}else{
			  $("input[id=checkRow]").prop("checked", false);
			}
		}
	</script>
</body>
</html>