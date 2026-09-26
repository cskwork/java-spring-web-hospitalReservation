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
		<p class="care-eyebrow">나의 진료 여정</p>
<h1>방문 후기</h1><p>지난 진료를 평가하세요. 저장한 후기는 병원 평점에 반영됩니다.</p><p id="ratingSaved" role="status"></p>

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
						<tr data-rating-state="${row.STATE}">
							<td>${row.HOSP}</td>
							<td>${NAME}</td>
							<td>${row.RESERV1}</td>
							<td>${row.REG}</td>
							<td>${row.STATE}</td>


								<td>
									<a href="#" id="rate" name="rate">후기 작성</a>

									<input type="hidden" id="H_IDX" name="H_IDX" value="${row.H_IDX}"/>
									<input type="hidden" id="RESERV1" name="RESERV1" value="${row.RESERV1}"/>
									<input type="hidden" id="NUM" name="NUM" value="${row.NUM}"/>
									<input type="hidden" id="ID" name="ID" value="${ID}"/>
								</td>

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
            $('[data-rating-state="완료"] a[name="rate"]').replaceWith('<span class="care-complete">작성 완료</span>');
            if (new URLSearchParams(location.search).get('saved') === '1') $('#ratingSaved').text('후기가 저장되었습니다. 병원 후기와 평점에 반영했어요.');
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