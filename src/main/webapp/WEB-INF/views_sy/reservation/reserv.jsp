<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">  
</head>
<body>
	<!--진료예약 버튼을 누르면 나오는 창 -->
	<div class="reserv">
		<input type="hidden" id="H_IDX" value='${map}'/>
		<!-- 병원 선택 창 -->
		<div style="display:inline-block; float:left; width :200px; padding-right:10px;">
			<h4>병원선택</h4>
			<div style = "border : 1px solid #555;">
				<table id="hp">
					<tbody>				
					</tbody>
				</table>
			</div>
			<!-- 진료과목 선택창 -->
			<h4>진료과목 선택</h4>
			<div style = "border: 1px solid #555; height:200px;">
				<table id="major">
					<tbody>				
					</tbody>
				</table>
			</div>
		</div>
		<!--예약일시 -->
		<div style = "display:inline-block; float:left; width:250px; padding-right:10px;">
			<h4>예약일시 선택</h4>
			<div style="border:1px solid #555; height:400px;">
				<!-- 달력 -->
				<table id="calendar">
					<tbody>
					</tbody>
				</table>
				<!-- 예약일 -->
				<div id="reservdate"></div>
				<!-- 예약시간 -->
				<div id="time"></div>
			</div>
		</div>
		<div id="result" style = "display:inline-block; float:left; width:200px;">
			<h4>예약 확인</h4>
			<div style="border:1px solid #555; height:400px;">
				<div id="reservResult"></div>
			</div>
			<br>
			<a href="#" class="btn" id="reservation">예약하기</a>
		</div>
	</div>
	
	<div class="point_payment">
		<div class="box">
			<input type="button" name="close" value="닫기" />
			<div class="innerbox">
				<b>결제할 포인트 가격</b> <input type="text" name="won" />
				<p class="content">
					* 적립할 금액을 적어주세요.<br> 예약 시 적립된 포인트에서 100원 차감됩니다.<br> <br>
					취소 시 차감된 포인트를 반환해 드립니다.
				</p>
			</div>
			<a href="#" name="payment">결제하기</a>
		</div>
		<div class="bbg"></div>
	</div>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	<script type="text/javascript">
		$(document).ready(function() {
			window.onload = function() {
				fn_selectHpList();
			}; //병원 선택창
			
			//결제하기 버튼
			$("a[name='payment']").on("click", function(e) {
				var amount = $(this).parent().find("input[name='won']").val();
				fn_Point(amount);
			});
		});
		
		//병원 선택창 ajax
		function fn_selectHpList() {
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/reserv/SelectHospitalList'/>");
			comAjax.setCallback("fn_selectHpListCallback");
			comAjax.addParam("H_IDX",$("#H_IDX").val());
			comAjax.ajax();
		}
		
		var hp;
		
		//병원 선택창
		function fn_selectHpListCallback(data) {
			var total = data.TOTAL;
			var body = $("#hp>tbody");
			
			body.empty();
	
			if(total == 0) {
				var str = "<tr>" +
								"<td colspan='1'>예약가능한 병원이 없습니다.</td>" +
							"</tr>";
				body.append(str);
			}
			else{		
				var str = "";
				
				$.each(data.list, function(key, value) {
					str += "<tr>" +
								"<td class='title'>" +
									"<a href='#this' name='hosp'>" + value.HOSP + "</a>" +
									"<input type='hidden' id='H_IDX' value=" + value.H_IDX + ">" +
									"<input type='hidden' id='HOSP' value=" + value.HOSP + ">" +
								"</td>" +
							"</tr>";
				});
							
					body.append(str);
							
							
							
				$("a[name='hosp']").on("click", function(e) {
					e.preventDefault();
					fn_selectMajor($(this));
				});
				
				}
		}
		
		 function fn_selectMajor(obj) {
		 	var comAjax = new ComAjax();
		 	comAjax.setUrl("<c:url value='/reserv/SelectMajorList'/>");
			comAjax.setCallback("fn_selectMjListCallback");
			comAjax.addParam("H_IDX",obj.parent().find("#H_IDX").val());
			comAjax.addParam("HOSP",obj.parent().find("#HOSP").val());
			
			comAjax.ajax();
		 }  
		 function fn_selectMjListCallback(data) {
			$("#tb").remove();
			
		 	var maj_total = data.MAJOR_TOTAL;
		 	var body = $("#major>tbody");	 	
		 	
		 	body.empty();
		 	if(maj_total == 0) {
				 var str = "<tr>" +
								 "<td colspan='1'>예약 가능한 진료과목이 없습니다.</td>" +
							 "</tr>";
				 body.append(str);
			 }
			 else{		
				 var str = "";
				 $.each(data.list, function(key, value) {
					 str += "<tr>" +
								 "<td class='title'>" +
									 "<a href='#this' name='major'>" + value.MAJOR + "</a>" +
									 "<input type='hidden' id='H_IDX' value=" + value.H_IDX + ">" +
									 "<input type='hidden' id='HOSP' value=" + value.HOSP + ">" +
									 "<input type='hidden' id='MAJOR' value=" + value.MAJOR + ">" +
								 "</td>" +
							 "</tr>";
				 });
				body.append(str);
				
				$("a[name='major']").on("click", function(e) {
					e.preventDefault();
					fn_selectDate($(this));
				});
			}
		}
		
		function fn_selectDate(obj) {
			var comAjax = new ComAjax();
		 	comAjax.setUrl("<c:url value='/reserv/SelectDate'/>");
			comAjax.setCallback("makeCalendar");
			comAjax.addParam("H_IDX",obj.parent().find("#H_IDX").val());
			comAjax.addParam("HOSP",obj.parent().find("#HOSP").val());
			comAjax.addParam("MAJOR",obj.parent().find("#MAJOR").val());
	
			comAjax.ajax();
		}
		  
		function totalDays(month,year) {
		  var tempDay = new Array(31,28,31,30,31,30,31,31,30,31,30,31);//월마다 일수
		 
		  //윤년계산
		  if(((year %4 ==0) && (year%100!=0)) ||(year%400 ==0))
			tempDay[1] = 29;
		  else
			tempDay[1] = 28;
			
		  return tempDay[month];
		}
		
	function makeCalendar(data) {
		var h_idx = data.H_IDX;
		var hosp = data.HOSP;
		var major = data.MAJOR;
		var today=new Date();
		var year=today.getFullYear();
		var month=today.getMonth();
		var date = today.getDate();
	
		var body=$("#calendar>tbody");
		body.empty();
	
		var firstOfMonth = new Date(year,month,1);
		var firstDay = firstOfMonth.getDay();
	
		var lastDate = totalDays(month,year);
		var text =  ""
			+ '<TABLE ID="tb" BORDER=2 BORDERCOLOR=green style="BORDER-COLLAPSE:collapse">'
			+ '<th colspan=7>' + year + '년' + (month + 1) + '월' + '</th>'
			+ '<tr align ="center" valign="center">'
				+ '<td width=30><font color=red><b>일</b></font></td>'
				+ '<td width=30><b>월</b></td>'
				+ '<td width=30><b>화</b></td>'
				+ '<td width=30><b>수</b></td>'
				+ '<td width=30><b>목</b></td>'
				+ '<td width=30><b>금</b></td>'
				+ '<td width=30><font color=blue><b>토</b></td></font></td>'
			+ '</tr>';
	
		var dayNum = 1
		var curCol = 1
	
		for (var i=1; i<=Math.ceil((lastDate + firstDay)/7);i++,j++) {
			text += ''
			+ '<tr align = "center"valign="top">'
		 
			for (var j=1; j<=7; j++) {
				if(dayNum >lastDate)
				 	break;
				
				if(curCol <firstDay+1) {
					text += '<TD></TD>';
					curCol++;
				} else {
					 
					if (dayNum == date ) {
						text += ''
				+ '<td style="background: skyblue;">';
					} else {
						text += ''
				+ '<td>';
					}
					
					text += ''
					+ '<input type="hidden" id="H_IDX" value="' + h_idx + '"/>'
					+ '<input type="hidden" id="HOSP" value="' + hosp + '"/>'
					+ '<input type="hidden" id="MAJOR" value="' + major + '"/>'
					+ '<input type="hidden" id="dayNum" value="' + dayNum + '"/>'
					+ '<input type="hidden" id="year" value="' + year + '"/>'
					+ '<input type="hidden" id="month" value="' + (month+1) + '"/>';
					
					if (dayNum >= date && dayNum < date+8) {
						text += ''
					+ '<a href="#this" name="cal">';
					}
					
					switch(j) {
					case 1 :
						text += ''
						+ '<font color=red>' + dayNum + '</font>';
					break;
					case 7 :
						text += ''
						+ '<font color=blue>' + dayNum + '</font>';
					break;
				
					default :
						text += dayNum; 
					}
	
					if (dayNum >= date) {
						text += ''
					+ '</a>';
					}
					
					text += ''
				+ '</td>';
					dayNum++;
					}
				
				}
				text += ''
			+ '</tr>';
			}
			text += ''
		+ '</table>';
		text += ''
		+'<p id="p"><font color="red">'+'※ 일주일 단위로 예약이 가능합니다.'+'</font></p>';
	
			body.append(text);
			 $("a[name='cal']").on("click", function(e) {
				e.preventDefault();
				fn_Cal($(this));
			});
		}
		
		function fn_Cal(obj) {
			var h_idx = obj.parent().find("#H_IDX").val();
			var hosp = obj.parent().find("#HOSP").val();
			var major = obj.parent().find("#MAJOR").val();
			var year = obj.parent().find("#year").val();
			var month = obj.parent().find("#month").val();
			var day = obj.parent().find("#dayNum").val();
			
			var comAjax = new ComAjax();
			
			comAjax.setUrl("<c:url value='/reserv/ReservDate'/>");
			comAjax.setCallback("fn_reservDateCallback");
			comAjax.addParam("H_IDX",h_idx);
			comAjax.addParam("HOSP",hosp);
			comAjax.addParam("MAJOR",major);
			comAjax.addParam("year",year);
			comAjax.addParam("month",month);
			comAjax.addParam("day",day);
			
			comAjax.ajax();
		}
		function fn_reservDateCallback(data) {
			var body=$("#reservdate");
			
			var h_idx = data.H_IDX;
			var hosp = data.HOSP;
			var major = data.MAJOR;
			var year = data.YEAR;
			var month = data.MONTH;
			var day = data.DAY; 
			var time = data.TIMELIST;
			
			body.empty();
			if(year != "" || month != "" || day !="") {
				if(month < 10) month = '0'+month;
				var str = "<p>"+"예약일 :" +year+ "/" +month+ "/"+day + "</p>"+
							"<br>"+
							"예약시간 : "+
							"<input type='hidden' id='H_IDX' value='" + h_idx + "'/>"+
							"<input type='hidden' id='HOSP' value='" + hosp + "'/>"+
							"<input type='hidden' id='MAJOR' value='" + major + "'/>"+
							"<input type='hidden' id='YEAR' value='" + year + "'/>"+
							"<input type='hidden' id='MONTH' value='" + month + "'/>"+
							"<input type='hidden' id='DAY' value='" + day + "'/>"+
							"<select id='time'>"+
								"<option value='0'>"+"---선택---"+
								"</option>";
								for(var i in time) {
									str += "<option value='"+time[i]+"'>"+time[i]+
									"</option>";
								}				
								str += "</select>"; 						
				body.append(str);
			}
			
			$("#time").change(function(){
				fn_result($(this));
			});	
		}
		function fn_result(obj){
			var h_idx = obj.parent().find("#H_IDX").val();
			var hosp = obj.parent().find("#HOSP").val();
			var major = obj.parent().find("#MAJOR").val();
			var year = obj.parent().find("#YEAR").val();
			var month = obj.parent().find("#MONTH").val();
			var day = obj.parent().find("#DAY").val();
			var time = obj.val();
			
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/reserv/ReservResult'/>");
			comAjax.setCallback("fn_reservResultCallback");
			comAjax.addParam("H_IDX",h_idx);
			comAjax.addParam("HOSP",hosp);
			comAjax.addParam("MAJOR",major);
			comAjax.addParam("YEAR",year);
			comAjax.addParam("MONTH",month);
			comAjax.addParam("DAY",day);
			comAjax.addParam("TIME",time);
			
			comAjax.ajax();
		}
		
		function fn_reservResultCallback(data){
			var body = $("#reservResult");
			
			var h_idx = data.H_IDX;
			var hosp = data.HOSP;
			var major = data.MAJOR;
			var year = data.YEAR;
			var month = data.MONTH;
			var day = data.DAY; 
			var time = data.TIME;
		
			body.empty();
			if(year != "" || month != "" || day !="") {
				var str = 	"<input type='hidden' id='H_IDX' value='" + h_idx + "'/>"+
							"<input type='hidden' id='HOSP' value='" + hosp + "'/>"+
							"<input type='hidden' id='MAJOR' value='" + major + "'/>"+
							"<input type='hidden' id='YEAR' value='" + year + "'/>"+
							"<input type='hidden' id='MONTH' value='" + month + "'/>"+
							"<input type='hidden' id='DAY' value='" + day + "'/>"+
							"<input type='hidden' id='TIME' value='" + time + "'/>"+
							"<p>"+"병원명 :" +hosp + "</p>"+
							"<br>"+
							"<p>"+"진료과목 :" +major + "</p>"+
							"<br>"+
							"<p>"+"예약일자 - 예약시간 :" +year+ "/" +month+ "/" +day+ "\t" +time+ "</p>";				
													
				body.append(str);
			}
			
			$("#reservation").on("click", function(e){
				e.preventDefault();
				if(confirm("예약하시겠습니까?"))
					fn_reservation($(this));
			});	
		}
		function fn_reservation(obj){
			var h_idx = obj.parent().find("#H_IDX").val();
			var hosp = obj.parent().find("#HOSP").val();
			var major = obj.parent().find("#MAJOR").val();
			var year = obj.parent().find("#YEAR").val();
			var month = obj.parent().find("#MONTH").val();
			var day = obj.parent().find("#DAY").val();
			var time = obj.parent().find("#TIME").val();
			
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/reserv/Reservation'/>");
			comAjax.setCallback("fn_submit");
			comAjax.addParam("H_IDX", h_idx);
			comAjax.addParam("HOSP", hosp);
			comAjax.addParam("CURED", major);
			comAjax.addParam("YEAR", year);
			comAjax.addParam("MONTH", month);
			comAjax.addParam("DAY", day);
			comAjax.addParam("RESERV2", time);
			comAjax.addParam("STEP", "reserv");
			
			comAjax.ajax();
		}
		function fn_submit(data) {
			if(data.reservFalse == 0){
				var comSubmit = new ComSubmit();
				comSubmit.setUrl("<c:url value='/reserv/MyReserv'/>")
				comSubmit.addParam("STEP", "reserv");
	
				comSubmit.submit();
			} else if(data.reservFalse == 1) {
				if(confirm("포인트가 부족합니다.\n현재 포인트는: " + data.POINT + "입니다.\n충전하시겠습니까?")) {
					$(document).find(".point_payment").css("display", "block");
				}
			} else if(data.reservFalse == 2) {
				alert("예약은 한 병원당 한 번만 가능합니다.");
			}
		}
		
		function fn_Point(amount) {
			IMP.init('imp46626503'); // 가맹점 식별 코드
			IMP.request_pay({
				pg : 'kakaopay', // 결제방식
				pay_method : 'card', // 결제 수단
				merchant_uid : 'merchant_' + new Date().getTime(),
				name : '주문명: 예약 대금', // order 테이블에 들어갈 주문명 혹은 주문 번호
				amount : amount, // 결제 금액	
			}, function(rsp) {//콜백
				if (rsp.success) { // 성공시
					var comAjax = new ComAjax();
					comAjax.setUrl("<c:url value='/mypage/paymentPoint'/>");
					comAjax.setCallback("payment_Complete");
					comAjax.addParam("POINT", amount);
					comAjax.ajax();
				} else {
					alert('결제에 실패하였습니다. 에러내용 : ' + rsp.error_msg);
				}
			});
		}
		
		function payment_Complete(data) {
			alert("결제가 완료되었습니다.\n 예약하기 버튼을 다시 눌러주세요.");
			$(document).find(".point_payment").css("display", "none");
		}
	</script>
</body>
</html>