<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<input type="hidden" id="ID_IMG" value="${map.ID_IMG }">
	<input type="hidden" id="IDX" value="${map.IDX }">
	
	<c:if test="${step == 'closeWindow'}">
		<script>
			window.opener.location.href = "http://localhost:8080/hospital/mypage/OpenMypageMain";
		    self.close();
		</script>
	</c:if>

	<form id="IMG_Insert" enctype="multipart/form-data">
		이미지:
		<input type="file" name="IMG" onchange="LoadImg(this);">
		<a href="#this" class="btn" id="insert">완료</a>
		
		<c:if test="${map.ID_IMG == 'Y'}">
			<a href="#this"	class="btn" id="delete">삭제</a>
		</c:if>
		<br>
		<img id="loadImg" style="width: 200px; height: 200px">
		<br>
		이미지 크기: 200 x 200
	</form>
	
	<script type="text/javascript">
		$(document).ready(function(){
			window.onload = function() {
				if ($("#ID_IMG").val() == "N") {
				$("#loadImg").prop("src", "/hospital/img/UserImg/default.jpg");
				} else if ($("#ID_IMG").val() == "Y") {
					$("#loadImg").prop("src", "/hospital/img/UserImg/" + $("#IDX").val() + ".png?" + 1000*Math.random());
				}
			};
			
			$("#insert").on("click", function(e){
				e.preventDefault();
				Insert_IMG();
			});
			
			$("#delete").on("click", function(e){
				e.preventDefault();
				Delete_IMG();
			});
		});
		
		function LoadImg(value) {
			if(value.files && value.files[0]) {
				var reader = new FileReader();
				
				reader.onload = function (e) {
					$("#loadImg").attr('src', e.target.result);
				}
				
				reader.readAsDataURL(value.files[0]);
			}
		}
		
		function Insert_IMG(){
			var comSubmit = new ComSubmit("IMG_Insert");
			comSubmit.setUrl("<c:url value='/mypage/InsertImg' />");
			comSubmit.submit();
		}
		
		function Delete_IMG(){
			var comSubmit = new ComSubmit("IMG_Insert");
			comSubmit.setUrl("<c:url value='/mypage/DeleteImg' />");
			comSubmit.submit();
		}
	</script>
</body>
</html>