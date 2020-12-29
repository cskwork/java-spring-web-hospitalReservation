<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<body>
	<div class="RateWrite">
		<h4> >> 만족도 조사 </h4>
		<div>
			<input type="hidden" name="NUM" id="NUM" value="${NUM}"/>
			<input type="hidden" name="ID" id="ID" value="${ID}"/>
			<input type="hidden" name="H_IDX" id="H_IDX" value="${H_IDX}"/>
			<input type="hidden" name="RESERV1" id="RESERV1" value="${RESERV1}"/>
			
			<div class="Rate_box"> 
				의사진료 만족도?
				<ul>
					<li><p>1. ★★★★★</p><input type="radio" name="rate1" value="5"></li>
					<li><p>2. ★★★★</p><input type="radio" name="rate1" value="4"></li>
					<li><p>3. ★★★</p><input type="radio" name="rate1" value="3"></li>
					<li><p>4. ★★</p><input type="radio" name="rate1" value="2"></li>
					<li><p>5. ★</p><input type="radio" name="rate1" value="1"></li>
				</ul>
			</div>
			
			<div class="Rate_box"> 
				간호사  친절성?
				<ul>
					<li><p>1. ★★★★★</p><input type="radio" name="rate2" value="5"></li>
					<li><p>2. ★★★★</p><input type="radio" name="rate2" value="4"></li>
					<li><p>3. ★★★</p><input type="radio" name="rate2" value="3"></li>
					<li><p>4. ★★</p><input type="radio" name="rate2" value="2"></li>
					<li><p>5. ★</p><input type="radio" name="rate2" value="1"></li>
				</ul>
			</div>
			
			<div class="Rate_box"> 
			 	청결성?
				<ul>
					<li><p>1. ★★★★★</p><input type="radio" name="rate3" value="5"></li>
					<li><p>2. ★★★★</p><input type="radio" name="rate3" value="4"></li>
					<li><p>3. ★★★</p><input type="radio" name="rate3" value="3"></li>
					<li><p>4. ★★</p><input type="radio" name="rate3" value="2"></li>
					<li><p>5. ★</p><input type="radio" name="rate3" value="1"></li>
				</ul>
			</div>
			
			<div class="Rate_box">  
				대기시간 만족도?
				<ul>
					<li><p>1. ★★★★★</p><input type="radio" name="rate4" value="5"></li>
					<li><p>2. ★★★★</p><input type="radio" name="rate4" value="4"></li>
					<li><p>3. ★★★</p><input type="radio" name="rate4" value="3"></li>
					<li><p>4. ★★</p><input type="radio" name="rate4" value="2"></li>
					<li><p>5. ★</p><input type="radio" name="rate4" value="1"></li>
				</ul>
			</div>
			<div>
				<textarea name="COMM" id="COMM"></textarea>
				<p style="font-size: 12px; color: red;">※ 후기를 500자 내외로 작성해주세요.</p> 
			</div>
		</div>
		
		<a href="#this" id="rate" name="rate" class="btn">만족도 조사 완료</a>
	</div>
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#rate").on("click", function(e) { //건강수첩 버튼
		        e.preventDefault();
		        fn_Rating();
		    });
		});
		
		function fn_Rating() {
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/rate/Rating'/>");
		    comSubmit.addParam("ID", 		$("#ID").val());
		    comSubmit.addParam("COMM", 		$("#COMM").val());
		    comSubmit.addParam("H_IDX", 	$("#H_IDX").val());
		    comSubmit.addParam("RESERV1", 	$("#RESERV1").val());
		    comSubmit.addParam("NUM", 		$("#NUM").val());
		    
			for(var j = 1; j < 5; j++) {
				for(var i = 0; i < $("input[name='rate" + j + "']").length; i++) {
					if($("input[name='rate" + j + "']")[i].checked == true) {
					    comSubmit.addParam("RATE" + j, $("input[name='rate" + j + "']")[i].value);
					}	
				}
			}
			
			comSubmit.submit();			
		}
	</script>
</body>
</html>