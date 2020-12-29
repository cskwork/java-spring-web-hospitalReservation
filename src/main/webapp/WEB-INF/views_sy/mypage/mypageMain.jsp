<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<style>
.modifyInfo {
	border: none;
	background-color: white;
}
.modify_Success{
	grid-area: modify;
	position: absolute;
	display: none;
	color: #0000ff;
}
.payment_Success{
	grid-area: modify;
	position: absolute;
	display: none;
	color: #0000ff;
}
</style>
</head>
<body>
	<div class="myInfo">
		<div class="UserInfo">
			<table class="UserInfo_header">
				<tr valign="middle">
					<td align="center">내 정보
				</tr>
			</table>
			<table class="UserImg">
			</table>

			<table class="UserBaseInfo" style="width: 310px;">
				<colgroup>
					<col style="width: 30%;">
					<col style="width: 35%;">
					<col style="width: 34%;">
				</colgroup>
				<tbody>
				</tbody>
			</table>

		</div>
		<div class="UserBodyInfo">
			<table class="UserBodyInfo_header">
				<tr valign="middle">
					<td align="center">신체 정보
				</tr>
			</table>
			<table class="UserBodyInfo_body" style="width: 240px;">
				<colgroup>
					<col style="width: 25%;">
					<col style="width: 75%;">
				</colgroup>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
	
	<div class="modify_Success">
		*개인정보 수정을 완료했습니다.
	</div>
	<div class="payment_Success">
		*포인트 충전을 완료했습니다.
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

	<script type="text/javascript">			
		
		$(document).ready(function() {
			window.onload = function() {
				fn_selectUserInfo();
			};

			//닫기 버튼
			$("input[name='close']").on("click", function(e) {
				$(document).find(".point_payment").css("display", "none");
				$("input[name='won']").val("");
			});

			//결제하기 버튼
			$("a[name='payment']").on("click", function(e) {
				var amount = $(this).parent().find("input[name='won']").val();
				fn_Point(amount);
			});
		});
		var success_Ment = "";
		function fn_selectUserInfo(data) {
			$(".modify_Success").css("margin", "-30px 0 0 " + $(".UserInfo").offset().left + "px");
			$(".payment_Success").css("margin", "-30px 0 0 " + $(".UserInfo").offset().left + "px");
			
			if(success_Ment == "modify_Success") {
				$(".modify_Success").css("display", "block");
				$(".payment_Success").css("display", "none");
			} else if(success_Ment == "payment_Success") {
				$(".modify_Success").css("display", "none");
				$(".payment_Success").css("display", "block");
			}
			
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/mypage/selectUserInfo' />");
			comAjax.setCallback("fn_UserInfo");
			
			comAjax.ajax();
		}

		function fn_UserInfo(data) {
			UserImg(data.map);

			UserBaseInfo(data.map);

			UserBodyInfo(data.map);
		}

		var tagToggle = true;
		function UserImg(map) {
			var body = $(".UserImg");
			body.empty();

			if (map.ID_IMG == "N" || map.ID_IMG == "null") {
				map.ID_IMG = "/hospital/img/UserImg/default.jpg";
			} else if (map.ID_IMG == "Y") {
				map.ID_IMG = "/hospital/img/UserImg/" + map.IDX + ".png";
			}
			console.log(map.ID_IMG);
			var str = ""  + 
				"<tr style='height: 0%;'>" + 
				"	<td align='center'>" + 
				"		<img src='" + map.ID_IMG + "?" + 1000*Math.random() + "' style='width: 100px; height: 100px; margin: 10px 0 15% 0;'/>"  + 
				"	</td>"  + 
				"</tr>"  + 
				
				"<tr style='height: 0%'>"  + 
				"	<td align='center'>"  + 
				"		<input type='button' id='img' value='이미지 변경' style='margin-bottom: 15%;'>"  + 
				"	</td>" + 
				"</tr>" + 
				
				"<tr style='vertical-align: top;'>" + 
				"	<td align='center' style='padding-bottom: 15%;'>" + 
				"		<input type='button' id='update' value='회원정보 변경'>" + 
				"	</td>" + 
				"</tr>" + 
				
				"<tr style='vertical-align: middle;'>" + 
				"	<td align='center' style='padding-bottom: 15%;'>" + 
				"		<input type='button' id='delete' value='회원 탈퇴'>" + 
				"	</td>" + 
				"</tr>";

			body.append(str);
			
			$("#img").on("click", function(e) { //목록으로 버튼
				e.preventDefault();
				Insert_IMG_form();
			});
			
			$("#update").on("click", function(e) { //수정하기 버튼
				if (tagToggle) {
					memberUpdate();
				} else {
					memberUpdate1();
				}
			});
			
			$("#delete").on("click", function(e) { //삭제하기 버튼
				e.preventDefault();
				memberDelete();	//추가
			});
		}

		function Insert_IMG_form() {
			url = "http://localhost:8080/hospital/mypage/InsertImgform";
			PopupCenter(url, '프로필 변경', '600', '300');
		}
		
		function memberDelete() {
			url = 'http://localhost:8080/hospital/mypage/deleteForm';
			PopupCenter(url, '회원탈퇴', '600', '300');
		}
		
		function PopupCenter(url, title, w, h) {
		    // 화면 위치 설정 브라우저 전체 호환 가능
		    var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : window.screenX;
		    var dualScreenTop = window.screenTop != undefined ? window.screenTop : window.screenY;

		    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
		    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

		    var systemZoom = width / window.screen.availWidth;
			var left = (width - w) / 2 / systemZoom + dualScreenLeft;
			var top = (height - h) / 2 / systemZoom + dualScreenTop;
			    
			var newWindow = window.open(url, title, 'scrollbars=yes, width=' + w / systemZoom + ', height=' + h / systemZoom + ', top=' + top + ', left=' + left);
		    // 새창 
		    if (window.focus) newWindow.focus();
		}
		
		function memberUpdate() {
			var GENDER = $("#GenderTag>th").prop("id");
			$("#GenderTag").empty();
			
			var str = "" +
			"	<th>성별</td>" + 
			"	<td>" + 
			"		<input class='modifyInfo' id='male' type='radio' name='GENDER' value='1' disabled> 남" + 
			"	</td>" +
			"	<td style='width: 105px'>" + 
			"		<input class='modifyInfo' id='female' type='radio' name='GENDER' value='2' disabled> 여" + 
			"	</td>";
			
			$("#GenderTag").append(str);

			if (GENDER == '여성') 
				$("#female").attr('checked', true);
			else 
				$("#male").attr('checked', true);
			
			$(".modifyInfo").attr('disabled', false);
			$(".modifyInfo").css("border", "1px solid #a9a9a9");
			$("#update").val("수정 완료");
			
			tagToggle = false;
		}

		function memberUpdate1() {
			if ($('input[name="NAME"]').val() == '') {
				alert("이름 입력은 필수입니다 (3 문자 이상으로 입력해주세요)");
				$('input[name="NAME"]').focus();

				return false;
			}

			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/mypage/updateUserInfo'/>");
			comAjax.setCallback("fn_selectUserInfo");
			comAjax.addParam("IDX", 	$("input[name='IDX']").val());
			comAjax.addParam("NAME", 	$("input[name='NAME']").val());
			comAjax.addParam("ID", 		$("input[name='ID']").val());
			comAjax.addParam("GENDER", 	$("input[name='GENDER']:checked").val());
			comAjax.addParam("PHONE", 	$("input[name='PHONE']").val());
			comAjax.addParam("ADDR", 	$("input[name='ADDR']").val());
			comAjax.addParam("B_TYPE", 	$("input[name='B_TYPE']").val());
			comAjax.addParam("HEIGHT", 	$("input[name='HEIGHT']").val());
			comAjax.addParam("WEIGHT", 	$("input[name='WEIGHT']").val());

			comAjax.ajax();

			success_Ment = "modify_Success";
			tagToggle = true;
		}
		
		function ModifyError() {
			$(".modify_Success").css("display", "none");
			$(".modify_Error").css("display", "block");
		}
		
		function UserBaseInfo(map) {
			var body = $(".UserBaseInfo>tbody");
			body.empty();

			var NAME = (typeof map.NAME != 'undefined') ? map.NAME : '';
			var PHONE = (typeof map.PHONE != 'undefined') ? map.PHONE : '';
			var ADDR = (typeof map.ADDR != 'undefined') ? map.ADDR : '';
			var GENDER = (typeof map.GENDER != 'undefined') ? map.GENDER : '등록필요';
			
			var str = "" + 
			"<tr class='tmptr'><td colspan='3'></td></tr>" + 
			"<tr>" + 
			"	<th>이름</td>"  + 
			"	<td colspan='2'><input name='NAME' placeholder='등록이 필요합니다' `length='1' maxlength='30' class='modifyInfo' value='" + NAME + "' disabled required /></td>" + 
			"</tr>"  + 
			"<tr class='tmptr' style='border-bottom: 1px solid #a9a9a9;'><td colspan='3'></td></tr>" + 
			
			"<tr class='tmptr'><td colspan='3'></td></tr>"	 + 
			"<tr>" + 
			"	<th>아이디</td>" + 
			"	<td colspan='2'>" + map.ID + "</td>" + 
			"   <td><input type='hidden' name='IDX' value='" + map.IDX  + "'></td>" + 
			"</tr>" + 
			"<tr class='tmptr' style='border-bottom: 1px solid #a9a9a9;'><td colspan='3'></td></tr>" + 
			
			"<tr class='tmptr'><td colspan='3'></td></tr>" + 
			"<tr id='GenderTag'>" + 
			"	<th id='" + GENDER + "'>성별</td>" + 
			"	<td>" + GENDER + "</td>" + 
			"	<td></td>" + 
			"</tr>" + 
			"<tr class='tmptr' style='border-bottom: 1px solid #a9a9a9;'><td colspan='3'></td></tr>" + 
			
			"<tr class='tmptr'><td colspan='3'></td></tr>" + 
			"<tr>"	 + 
			"	<th>연락처</td>" + 
			"	<td colspan='2'><input name='PHONE' maxlength='20' placeholder='등록이 필요합니다' class='modifyInfo' value='" + PHONE  + "' disabled></input></td>"  + 
			"</tr>" + 
			"<tr class='tmptr' style='border-bottom: 1px solid #a9a9a9;'><td colspan='3'></td></tr>" + 
			
			"<tr class='tmptr'><td colspan='3'></td></tr>" + 
			"<tr>"	 + 
			"	<th>주소</td>"	 + 
			"   <td colspan='2'>"+
			"	<input  name='ADDR' class='modifyInfo' value='" +ADDR+ "' style='background:#ffffff;' disabled id='sample5_address' onclick='sample5_execDaumPostcode();' maxlength='90' placeholder='클릭해서 도로명 검색' ></input>"+
			"	</td>"+
			"</tr>" + 
			"<tr class='tmptr' style='border-bottom: 1px solid #a9a9a9;'><td colspan='3'></td></tr>" + 
			
			"<tr class='tmptr'><td colspan='3'></td></tr>" + 
			"<tr>" + 
			"	<th>포인트</td>" + 
			"	<td colspan='2'>" + map.POINT + "<a href='#' name='point' style='float: right;'>포인트 결제</a></td>" + 
			"</tr>" + 
			"<tr class='tmptr'><td colspan='3'></td></tr>";

			body.append(str);

			$("a[name='point']").on("click", function(e) {
				$(document).find(".point_payment").css("display", "block");
			});
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
					comAjax.setCallback("fn_selectUserInfo");
					comAjax.addParam("POINT", amount);
					comAjax.ajax();
					
					$(document).find(".point_payment").css("display", "none");
					success_Ment = "payment_Success";
				} else {
					alert('결제에 실패하였습니다. 에러내용 : ' + rsp.error_msg);
				}
			});
		}
		
		//maxlength 숫자 제한하기
		function maxLengthCheck(object) {
			if (object.value.length > object.maxLength)
				object.value = object.value.slice(0, object.maxLength);
		}

		function UserBodyInfo(map) {
			var body = $(".UserBodyInfo_body>tbody");
			body.empty();

			var BMI_stat;
			var prs_value;

			// prs_value = [해당 칸까지의 비율] + [전체에서 해당 칸의 비율] * (map.BMI - [전 칸들의 총량]) / [해당 칸의 총량];
			if (map.BMI != null) {
				if (map.BMI <= 18.5) {
					BMI_stat = "저체중";
					prs_value = 0 + 33 * (map.BMI - 0) / 18.5;
				} else if (map.BMI <= 23) {
					BMI_stat = "정상체중";
					prs_value = 33 + 25 * (map.BMI - 18.5) / 4.5;
				} else if (map.BMI <= 25) {
					BMI_stat = "과체중";
					prs_value = 58 + 12 * (map.BMI - 23) / 2
				} else if (map.Bmi <= 30) {
					BMI_stat = "비만";
					prs_value = 70 + 20 * (map.BMI - 25) / 5;
				} else {
					BMI_stat = "고도비만";
					prs_value = 90 + 10 * (map.BMI - 30) / 10;
				}
			}

			var HEIGHT = (typeof map.HEIGHT != 'undefined') ? map.HEIGHT : '';
			var WEIGHT = (typeof map.WEIGHT != 'undefined') ? map.WEIGHT : '';
			var B_TYPE = (typeof map.B_TYPE != 'undefined') ? map.B_TYPE : '';

			var BMI = map.BMI != null ? map.BMI.toFixed(1) : "";
			var BMI_stat = BMI_stat != null ? "(" + BMI_stat + ")" : "";
			var prs_value = prs_value != null ? prs_value : "";

			var str = "" + 
				"<tr class='tmptr'><td colspan='2'></td></tr>" + 
				"<tr>" + 
				"	<th>신장</th>" + 
				"	<td><input name='HEIGHT' placeholder='등록이 필요합니다' maxlength='3' oninput='maxLengthCheck(this)' type='number' class='modifyInfo' value='" + HEIGHT + "' disabled /></td>"  + 
				"</tr>" + 
				"<tr class='tmptr' style='border-bottom: 1px solid #a9a9a9;'><td colspan='2'></td></tr>" + 
					
				"<tr class='tmptr'><td colspan='2'></td></tr>" + 
				"<tr>" + 
				"	<th>체중</th>" + 
				"	<td><input name='WEIGHT' placeholder='등록이 필요합니다' maxlength='3' oninput='maxLengthCheck(this)' type='number' class='modifyInfo' value='" + WEIGHT + "' disabled /></td>" + 
				"</tr>" + 
				"<tr class='tmptr' style='border-bottom: 1px solid #a9a9a9;'><td colspan='2'></td></tr>"  + 
				
				"<tr class='tmptr'><td colspan='2'></td></tr>" + 
				"<tr>" + 
				"	<th>혈액형</th>" + 
				"	<td><input name='B_TYPE' placeholder='등록이 필요합니다' maxlength='2' class='modifyInfo' value='" + B_TYPE  + "' disabled /></td>" + 
				"</tr>" + 
				"<tr class='tmptr' style='border-bottom: 1px solid #a9a9a9;'><td colspan='2'></td></tr>"  + 
				
				"<tr class='tmptr'><td colspan='2'></td></tr>" + 
				"<tr>" + 
				"	<th>BMI 수치</th>" + 
				"	<td>" + BMI + " " + BMI_stat + "</td>" + 
				"</tr>" + 
				
				"<tr class='tmptr'><td colspan='2'></td></tr>" + 
				"<tr valign='middle'>" + 
				"	<td colspan='2' style='width: 220px'>" + 
				"		<progress value='" + prs_value + "' max='100'>" + 
				"			#document-fragment" + 
				"			<div pseudo='-webkit-progress-inner-element'>" + 
				"				<div pseudo='-webkit-progress-bar'>" + 
				"					<div pseudo='-webkit-progress-value' style='width: 80%;'></div>"  + 
				"				</div>" + 
				"			</div>" + 
				"		</progress>" + 
				"	</td>" + 
				"</tr>" + 
				"<tr>"  + 
				"	<td colspan='2' style='font-size: 10px; color: #ff0000;'>*근육량을 알 수 없기에 정확한 측정이 아닙니다.</td>"  + 
				"</tr>"  + 
				"<tr class='tmptr'><td colspan='2'></td></tr>";

			body.append(str);
		}
		
		var geocoder = new daum.maps.services.Geocoder();

		function sample5_execDaumPostcode() {
		   new daum.Postcode({
		      oncomplete:function(data) {
		         var ADDR = data.address;
		         
		         document.getElementById("sample5_address").value = ADDR;
		         
		         geocoder.addressSearch(data.address,function(results, status) {
		            if (status === daum.maps.services.Status.OK) {
		               var result = results[0];
		               var coords =new daum.maps.LatLng(result.y, result.x);
		               
		               mapContainer.style.display = "block";
		               map.relayout();               
		               map.setCenter(coords);                     
		               marker.setPosition(coords)
		            }
		         });
		      }
		   }).open();
		}	 
	</script>
</body>
</html>