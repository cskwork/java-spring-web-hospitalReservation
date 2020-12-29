<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
	<table class="board_view" style="margin: auto;">
		<colgroup>
			<col width="15%"/>
			<col width="35%"/>
			<col width="15%"/>
			<col width="35%"/>
		</colgroup>
		
		<caption>게시글 상세</caption>
		
		<tbody>
			<tr>
				<th scope="row">H_IDX</th>
				<td>${map.H_IDX }</td>
				<th scope="row">병원명</th>
				<td>${map.HOSP }</td>
			</tr>
			
			<tr>
				<th scope="row">진료과목</th>
				<td>${map.MAJOR }</td>
				<th scope="row">전화번호</th>
				<td>${map.TEL }</td>
			</tr>
			
			<tr>
				<th scope="row">진료시간</th>
				<td>${map.HOUR }</td>
				<c:if test="${map.REG_CHK == 'Y'}">
					<th scope="row">진료예약</th>
					<td><input type='button' name='REG' value='예약'></td>
				</c:if>
			</tr>
			
			<tr>
				<th scope="row">주소</th>
				<td>${map.ADDR }</td>
				<th scope="row">주소(GPS)</th>
				<td>${map.ADDR_GPS }</td>
			</tr>
			
			<tr>
				<th scope="row">병원소개</th>
				<td colspan="3">${map.H_COMM }</td>
			</tr>
			
			<tr>
				<th scope="row">의사소개</th>
				<td colspan="3">${map.DOC_COMM}</td>
			</tr>
		</tbody>
	</table>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	
	<script type="text/javascript">
		$(document).ready(function(){
			$("#list").on("click", function(e){ //목록으로 버튼
				e.preventDefault();
				fn_openBoardList();
			});

			$("#update").on("click", function(e){ //수정하기 버튼
				e.preventDefault();
				fn_openBoardUpdate();
			});
			
			$("#reply").on("click", function(e){ //답글달기 버튼
				e.preventDefault();
				fn_openBoardReply();
			});
			
			$("a[name='file']").on("click", function(e) {
				e.preventDefault();
				fn_downloadFile($(this));
			})
			
			$("input[name='REG']").on("click", function(e) {
				e.preventDefault();
				fn_MovetoReservation($(this));
			});
		});
		
		function fn_openBoardList(){
			var comSubmit = new ComSubmit();
			
			comSubmit.setUrl("<c:url value='/sample/openBoardList.do' />");
			comSubmit.submit();
		}
		
		function fn_openBoardUpdate() {
			var idx = "${map.IDX}";
			var comSubmit = new ComSubmit();
			
			comSubmit.setUrl("<c:url value='/sample/openBoardUpdate.do' />");
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();
		}
		
		function fn_openBoardReply() {
			var parent_idx = "${map.PARENT_IDX}";
			var comSubmit = new ComSubmit();
			
			comSubmit.setUrl("<c:url value='/sample/openBoardReply.do' />");
			comSubmit.addParam("PARENT_IDX", parent_idx);
			comSubmit.addParam("content_title", "답글 작성");
			comSubmit.submit();
		}
		
	    function fn_downloadFile(obj) {
	        var idx = obj.parent().find("#IDX").val();
	        var comSubmit = new ComSubmit();
	        comSubmit.setUrl("<c:url value='/common/downloadFile.do' />");
	        comSubmit.addParam("IDX", idx);
	        comSubmit.submit();
	    }
	    
	    function fn_MovetoReservation() {
			var H_IDX = "${map.H_IDX}";
			if($("#ID").val() == "") {
	            alert("로그인이 필요한 서비스입니다.");
	         } else {
	        	 var comSubmit = new ComSubmit();
	 			comSubmit.setUrl("<c:url value='/reserv/OpenReserv' />");
	 			comSubmit.addParam("H_IDX", H_IDX);
	 			
	 			comSubmit.submit();
	         }			
		}
	</script>
</body>
</html>