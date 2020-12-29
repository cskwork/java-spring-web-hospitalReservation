<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<div class="RateList">
		<h2>만족도 조사 참여 목록</h2>
		
		<table>
			<colgroup>
				<col width="32%"/>
				<col width="12%"/>
				<col width="12%"/>
				<col width="12%"/>
				<col width="12%"/>
				<col width="20%"/>
			</colgroup>
		   
			<thead>
				<tr>
					<th scope="col"><p id="p_border">병원명</p></th>
					<th scope="col"><p id="p_border">환자명</p></th>
					<th scope="col"><p id="p_border">진료일</p></th>
					<th scope="col"><p id="p_border">평가일</p></th>
					<th scope="col"><p id="p_border">상태</p></th>
					<th scope="col"><p				>만족도 조사</p></th>
				</tr>
			</thead>
		   
			<tbody>
				<c:choose>
					<c:when test="${fn:length(list) > 0}">
					<c:forEach items="${list }" var="row">
						<tr>
							<td>${row.HOSP}</td>
							<td>${row.NAME}</td>
							<td>${row.RESERV1}</td>
							<td>${row.REG}</td>
							<td>${row.STATE}</td>
							
							<c:if test="${row.STATE == '미완료'}">
								<td>
									<a href="#" id="rate" name="rate">만족도조사</a>
									
									<input type="hidden" id="H_IDX" name="H_IDX" value="${row.H_IDX}"/>
									<input type="hidden" id="RESERV1" name="RESERV1" value="${row.RESERV1}"/>
									<input type="hidden" id="NUM" name="NUM" value="${row.NUM}"/>
									<input type="hidden" id="ID" name="ID" value="${ID}"/>
								</td>
							</c:if>
							<c:if test="${row.STATE != '미완료'}">
								<td></td>
							</c:if>
						</tr>
					</c:forEach>
					</c:when>
					
					<c:otherwise>
						<tr>
							<td colspan="6">조회된 결과가 없습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	
	<script type="text/javascript">
		$(document).ready(function(){
			$("a[name='rate']").on("click", function(e){ //건강수첩 버튼
				e.preventDefault();
				fn_openRating($(this));
			});
		});
		
		function fn_openRating(obj){			
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/rate/OpenRating' />");
			comSubmit.addParam("ID", 		obj.parent().find("#ID").val());
			comSubmit.addParam("H_IDX",		obj.parent().find("#H_IDX").val());
			comSubmit.addParam("RESERV1",	obj.parent().find("#RESERV1").val());
			comSubmit.addParam("NUM", 		obj.parent().find("#NUM").val());
			
			comSubmit.submit();
		}
	</script>
</body>
</html>