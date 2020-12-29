
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>

<body>
	
<table class="board_view" style="margin: auto;">
	<caption>회원 정보</caption>		
	<tbody>
		<tr>
			<th scope="row">회원 번호</th>
			<td>${view.IDX }</td>
			
			<th scope="row">ID/EMAIL</th>
			<td>${view.ID }</td>
		
			<th scope="row">성함</th>
			<td>${view.NAME }</td>
			
			<th scope="row">암호</th>
			<td>${view.PWD }</td>
			
			<th scope="row">이메일 수신 확인</th>
			<td>${view.MMS_CHK }</td>
		</tr>
			
		<tr>
			<th scope="row">전화번호</th>
			<td>${view.PHONE }</td>
			
			<th scope="row">주소</th>
			<td>${view.ADDR }</td>
		</tr>
		
		<tr>
			<th scope="row">주민번호</th>
			<td colspan="3">${view.JUMIN }</td>
			
			<th scope="row">가입날짜</th>
			<td colspan="4">${view.JOINDATE }</td>
		</tr>
		
		<tr>
			<th scope="row">신장</th>
			<c:if test="${view.HEIGHT eq 0}"> 
				<td colspan="3">등록이 필요합니다</td>
			</c:if> 
			
			<th scope="row">몸무게</th>
			<c:if test="${view.WEIGHT eq 0}"> 
				<td colspan="3">등록이 필요합니다</td>
			</c:if> 
			
			<th scope="row">혈액형</th>
			<c:if test="${view.B_TYPE eq 0}"> 
				<td colspan="3">등록이 필요합니다</td>
			</c:if>	 
			
			<th scope="row">계좌번호</th>
			<c:if test="${view.BANK_NO eq 0}"> 
				<td colspan="3">등록이 필요합니다</td>
			</c:if> 
		</tr>
			
		 <c:if test="${fn:length(list) > 0}">
			<tr>
				<td colspan="4">조회된 회원이 없습니다.</td>
			</tr>
		</c:if>
	</tbody>
</table>
	
<table style="margin: auto;">
	<tr>
		<td>
			<a href="#this" class="btn" id="list">목록으로</a>
			<a href="#this" class="btn" id="update">수정하기</a>
			<br /><br />
		</td>
	</tr>
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

		});
		
		function fn_openBoardList(){
			var comSubmit = new ComSubmit();
			
			comSubmit.setUrl("<c:url value='/member/list' />");
			comSubmit.submit();
		}
		
		function fn_openBoardUpdate() {
			var idx = "${view.IDX}";
			var comSubmit = new ComSubmit();
			
			comSubmit.setUrl("<c:url value='/member/infoUpdate' />");
			comSubmit.addParam("IDX", idx);
			comSubmit.submit();
		}	
	</script>
</body>
</html>



