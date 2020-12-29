<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="ie=edge">

	<link rel="stylesheet" 
		href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" 
		integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" 
		crossorigin="anonymous">
		
	<link rel="stylesheet" 
		href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" 
		integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" 
		crossorigin="anonymous">

	<link rel="stylesheet"
		href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

	<title>로그인/회원가입 폼</title>

	<%@ include file="/WEB-INF/include/include-header.jspf" %>
	
	<style>
		@media screen and (max-width:600px){
			.flowcontrol{
				width:230px;
				padding-left:10px;
			}
			.flowcontrol input{
				width:230px;
				padding-left:10px;
			}
		}
		@media screen and (min-width:600px){
			.flowcontrol{
				width:340px;
				padding-left:10px;
			}
			.flowcontrol input{
				width:340px;
				padding-left:10px;
			}
		}
	</style>
</head>
<body class="text-center">
	<div id="logreg-forms">  
		<form class="form-signin" id="loginForm" name="loginForm" novalidate>
			<h1 class="h3 mb-3 font-weight-normal" style="text-align: center">로그인</h1>	
			
			<div class="social-login">
				<a id="custom-login-btn" href="javascript:loginWithKakao()">
					<img src="//mud-kage.kakao.com/14/dn/btqbjxsO6vP/KPiGpdnsubSq3a0PHEGUK1/o.jpg" width="100%"/>
				</a>
			</div>
		
		
			<p style="text-align:center"> 또는</p>
														
			<div class="form-row">
				<div class="col-md-12 mb-3">
					<label for="validationCustomUsername">이메일 주소</label>
					
					<div class="input-group">
						<input type="email" class="form-control" name="ID" id="loginID" placeholder="이메일 주소" onkeyup="validationKeyUp()" maxlength="20">
						</div>
				
					<span id="alert_text">
						<span style="color: #777"></span>
					</span>
				</div>
			</div>
			
			
			<div class="form-row">
				<div class="col-md-12 mb-3">
					<label for="validationCustom03">비밀번호</label>
				
					<input type="password" class="form-control" name="PWD" id="inputPassword" placeholder="비밀번호" onkeyup="validationKeyUp2()" maxlength="20">
				
					<span id="alert_text2">
						<span style="color: #777;"></span>
					</span>
				</div>			
			</div>
				
			<!-- 자동 로그인 / 쿠키 -->
			<div>
				<label for="autoLogin">
					<input type="checkbox" id="autoLogin" name="autoLogin" value="T">로그인 유지
				</label>&nbsp;&nbsp;
				
				<label for="useCookieId">
					<input type="checkbox" id="idSaveCheck" name="idSaveCheck">로그인 ID 저장
				</label>
			</div>
					
			<!-- 로그인 버튼 -->
			<button class="btn btn-success btn-block" id="write1" type="submit">
				<i class="fas fa-sign-in-alt"></i> 로그인
			</button>
				
			<!-- flashAttribute --> 
			<span>
	           <span style="color:red">${msg}</span>
	        </span>
			
			<a href="#" id="forgot_pswd">비밀번호를 잊어버렸나요?</a>
			<hr>
			
			<button class="btn btn-primary btn-block" type="button" id="btn-signup">
				<i class="fas fa-user-plus"></i> 회원가입
			</button> 
		</form>
		
		<form name="findPWD" id="findPWD" class="form-reset" novalidate>
			<br/><br/>
		
			<div class="form-row">
				<div class="col-md-12 mb-3">
					<div class="input-group">
						<input type="email" class="form-control" name="ID" id="findPwID" placeholder="이메일 주소" onkeyup="validationKeyUpPWD()" maxlength="20">
					</div> 
					
					<div class="input-group">
						<span id="alertID">
							<span style="color: #777">비밀번호 재설정 인증 메일을 발송합니다.</span>
						</span>
						<br/>
					</div>
					
					<div id="newPWD">
						<span class="input-group-text" style="float: left; margin-bottom: 10px;">
							<i class="fa fa-lock" style="padding: 0px 15px 0px 0px;"></i>
							<input class="btn-twitter" style="float: left;" type="button" value="인증번호 받기" onclick="newPWD(document.getElementById('findPwID').value)" >
						</span>
					</div>
					 
					<!-- 인증 번호 받기 칸 -->
					<div class="input-group" style="margin-top: 10px"> 
		                <div id="newPWD2" style="width: 100%;"></div> 
		             </div>   
		             <br/>      
		             <input type="submit" id="write3" class="btn btn-primary btn-block" value="비밀번호 변경하기"><br>
		               
		             <!-- flashAttribute --> 
		             <span>
		                <span style="color: blue">${msg2}</span>
		             </span>
				</div>
			</div> 
			
			<a href="#" id="cancel_reset">
				<i class="fas fa-angle-left"></i> 뒤로가기
			</a>
		</form> 
		
		
		<form name="regForm" id="regForm" class="form-signup" novalidate>
			<h4 class="card-title mt-3 text-center">계정 만들기</h4>
			<p class="text-center">무료 계정을 지금 만들어 보세요</p>
			
			<div style="width:100%; text-align:center;">
				<a href="javascript:loginWithKakao()">
					<img src="//mud-kage.kakao.com/14/dn/btqbjxsO6vP/KPiGpdnsubSq3a0PHEGUK1/o.jpg" width="100%"/>
				</a>
			</div>
		
			<p style="text-align:center"> 또는</p>
		
			<div class="form-row">
				<div class="col-md-12 mb-3">
					<div class="input-group">
						<input type="email" class="form-control" name="ID" id="regID" onkeyup="validationKeyUp3()" placeholder="이메일 주소" maxlength="20">
				
						<div class="input-group">
							<span id="alert_text3">
								<span style="color: #777"></span>
							</span>
							<br/>
						</div>
					
						<div class="form-group input-group">
							<input class="btn-primary btn-block" type="button" value="ID 중복 확인" onclick="over(document.getElementById('regID').value);">
							<br/>
							
							<!-- 인증 번호 받기 칸 -->
							<div id="getCode"></div> 
							
							<!-- 인증 번호 hidden칸 -->
							<span id="chkCode"></span> 
						</div> 
					</div>
				</div>
			</div>
		
			<div class="form-row">
				<div class="col-md-12 mb-3">
					<div class="input-group">
						<div class="input-group-prepend">
							<span class="input-group-text">
								<i class="fa fa-lock"></i>
							</span>
						</div>
						<input name="PWD" type="password" class="form-control" placeholder="비밀번호 (6~15 자리, 문자+숫자)" onkeyup="validationKeyUp4()" maxlength="20">
					
						<div class="input-group"> 
							<span id="alert_text4">
								<span style="color: #777"></span>
							</span>
						</div> 
					</div> 
				</div> 
			</div>
		
			<div class="form-row">
				<div class="col-md-12 mb-3">
					<div class="input-group">
						<div class="input-group-prepend">
							<span class="input-group-text">
								<i class="fa fa-lock"></i>
							</span>
						</div>
						
						<input name="PWD2" type="password" class="form-control" placeholder="비밀번호 확인" onkeyup="validationKeyUp5()" maxlength="20">
						
						<div class="input-group"> 
							<span id="alert_text5">
								<span style="color: #777"></span>
							</span>
						</div>
					</div> 
				</div> 
			</div>
		
			<div class="form-row">
				<div class="col-md-12 mb-3">
					<div class="input-group">
						<div class="input-group-prepend">
							<span class="input-group-text">
								<i class="fa fa-user"></i>
							</span>
						</div>
						
						<input name="NAME" id="NAME" type="text" class="form-control" placeholder="성함" onkeyup="validationKeyUp6()" maxlength="20">
						
						<div class="input-group"> 
							<span id="alert_text6">
								<span style="color: #777"></span>
							</span>
						</div> 
					</div> 
				</div>
			</div>
			
			<div>  
				<p style="align:center; text-decoration:underline;">성별</p>
				<label class="container" style="flex:left">남성
					<input type="radio" checked="checked" name="GENDER" value="1">
					<span class="checkmark"></span>
				</label>
				
				<label class="container"  style="flex:left">여성
					<input type="radio" name="GENDER" value="2">
					<span class="checkmark"></span>
				</label>			
			</div>
		
			<div class="form-row">
				<div class="col-md-12 mb-3">
					<div class="input-group">
						<div class="input-group-prepend">
							<span class="input-group-text"><i class="fa fa-user"></i></span>
						</div>
					
						<input name="JUMIN" type="text" class="form-control" placeholder="주민번호 앞자리 000000" onkeyup="validationKeyUp7()" maxlength="6">
						
						<div class="input-group"> 
							<span id="alert_text7">
								<span style="color: #777"></span>
							</span>
						</div>
					</div> 
				</div> 
			</div>
		
		
			<div class="form-row">
				<div class="col-md-12 mb-3">
					<div class="input-group">
						<div class="input-group-prepend">
							<span class="input-group-text"><i class="fa fa-phone"></i></span>
						</div>
					
						<input name="PHONE" type="text" class="form-control" placeholder="000-0000-0000" onkeyup="validationKeyUp8()" maxlength="20">
					
						<div class="input-group"> 
							<span id="alert_text8"><span style="color: #777"></span></span>
						</div>
					</div> 
				</div> 
			</div> 
		
			<div class="form-row">
				<div class="col-md-12 mb-3">
					<div class="input-group">
						<div class="input-group-prepend">
							<span class="input-group-text">
								<i class="fa fa-building"></i>
							</span>
						</div>
							
						<a class="flowcontrol" style="overflow:hidden;line-height:38px; height: 38px; display:block; margin:0px;padding:0px; border:1px solid lightgray;" href='javascript:sample5_execDaumPostcode();'>
						<input  style="color: black; background:#ffffff;border:0px;height:38px;" name='ADDR' disabled id='sample5_address' maxlength='90' placeholder='클릭해서 도로명 검색' ></input></a>
						<br/>
						
						<div id="map" style="width:375px;height:375px;margin-bottom:10px;display:none"></div> 
					</div>
				
					<div class="input-group">
						<br/><br/><br/>
						
						<!-- 회원가입 버튼 --> 
						<input type="submit" id="write2" class="btn-primary btn-block"><br>
						
						<p class="text-center">계정이 있으신가요?<a href="#" id="cancel_signup"> 로그인하기</a></p>
					</div> 
				</div> 
			</div>
		</form>
	</div>
	<br>	
	
	<p style="text-align:center"></p>
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

	<span id="chkKakao"></span>
		
	<script type="text/javascript" >
		$("document").ready(function() {
			//쿠키 사용
			var userInputId = getCookie("userInputId");
			$("input[name='ID']").val(userInputId); 
			
			if($("input[name='ID']").val() != "") {  
				$("#idSaveCheck").attr("checked", true); 
			}
			
			$("#idSaveCheck").change(function() { 
				if($("#idSaveCheck").is(":checked")) {
					var userInputId = $("input[name='ID']").val();
					
					setCookie("userInputId", userInputId, 7); 
				} else { 
					deleteCookie("userInputId");
				}
			});
			
			$("input[name='ID']").keyup(function() {
				if($("#idSaveCheck").is(":checked")) { 
					var userInputId = $("input[name='ID']").val();
					setCookie("userInputId", userInputId, 7); 
				}
			});
			
		});
		
		$("#write1").on("click",function(e) {//1 로그인
			e.preventDefault();
			validationEmpty();
		});
		
		$("#write2").on("click", function(e) {//2 회원가입
			e.preventDefault(); 
			validationEmpty2();
		});
		
		$("#write3").on("click", function(e) {//3 암호 찾기
			e.preventDefault(); 
			validationEmpty3(); 
		});
		//임시로 링크시 deleteCookie 실행 적용
		$('a[name="deleteCookie"]', this).click(function() {
			deleteCookie("userInputId");
		});		
		
		$(()=>{
			// Login Register Form
			$('#logreg-forms #forgot_pswd').click(toggleResetPswd);
			$('#logreg-forms #cancel_reset').click(toggleResetPswd);
			$('#logreg-forms #btn-signup').click(toggleSignUp);
			$('#logreg-forms #cancel_signup').click(toggleSignUp);
		})
		
		function toggleResetPswd(e) {
			e.preventDefault();
			$('#logreg-forms .form-signin').toggle()// display:block or none
			$('#logreg-forms .form-reset').toggle()// display:block or none
		}
			
		function toggleSignUp(e) {
			e.preventDefault();
			$('#logreg-forms .form-signin').toggle();// display:block or none
			$('#logreg-forms .form-signup').toggle();// display:block or none
		}
		
		/* 로그인 VALIDATION */
		/* 필터 전역 */
		var emailFilter=/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;	
		var pwdFilter= /^(?=.*[a-zA-Z])((?=.*\d)|(?=.*\W)).{6,15}$/;
		var phoneFilter = /^\d{2,3}-\d{3,4}-\d{4}$/;
		//LOGINFORM
		var log = document.loginForm;
		
		function validationEmpty() {//로그인 폼
			if(log.ID.value == '') {
	            document.getElementById("alert_text").innerHTML=('<span style="color: red;">아이디를 입력하세요></span>');
	            document.getElementById("alert_text2").innerHTML=('<span style="color: red;">비밀번호를 입력하세요.</span>'); 
	            
	            log.ID.focus();
	            
	            return false; 
			}
		
		
			if (emailFilter.test(log.ID.value) == false && log.ID.value != "admin") {
				document.getElementById("alert_text").innerHTML=('<span style="color: red;">아이디는 이메일 형식으로</span>'); 
				
				log.ID.value ="";
				log.ID.focus();
				
				return false;
			}
			
			if(log.PWD.value == '') {
				document.getElementById("alert_text2").innerHTML=('<span style="color: red;">비밀번호를 입력하세요.</span>'); 
				
				log.PWD.focus();
				
				return false;
			}
			
			if(pwdFilter.test(log.PWD.value) == false && log.PWD.value != "admin1") {
				document.getElementById("alert_text2").innerHTML=('<span style="color: red;">비밀번호가 맞지 않습니다.</span>'); 
				
				log.PWD.focus();
			
				return false;
			}
			
			var comSubmit = new ComSubmit();

			comSubmit.setUrl("<c:url value='/member/login' />");
			comSubmit.addParam("ID", log.ID.value); 
			comSubmit.addParam("PWD", log.PWD.value); 
			
			comSubmit.submit();
			
			log.reset(); 
		}
		
		function validationKeyUp() { 
			if (emailFilter.test(log.ID.value)==false) {
				document.getElementById("alert_text").innerHTML=('<span style="color: red;">아이디는 이메일 형식으로 입력하세요</span>');
				
				return;
			} else {
				document.getElementById("alert_text").innerHTML=('<span style="color: green;">정상적으로 입력되었습니다.</span>');	
			} 
		}	
		
		function validationKeyUp2() {
			if (pwdFilter.test(log.PWD.value)==false)
				document.getElementById("alert_text2").innerHTML=('<span style="color: red;">비밀번호가 맞지 않습니다.</span>'); 
			else
				document.getElementById("alert_text2").innerHTML=('<span style="color: green;">정상적으로 입력되었습니다.</span>');	
		}
		
		//회원가입 REGFORM >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		
		var obj = document.regForm;
		
		function validationEmpty2() {//회원가입 폼
			var tagId = new Array("alert_text3", 
					"alert_text4", 
					"alert_text8", 
					"alert_text5", 
					"alert_text4", 
					"alert_text6", 
					"alert_text7", 
					"alert_text8", 
					"alert_text9" );
			
			var tagName = new Array(obj.ID, 
					obj.PWD, 
					obj.PHONE, 
					obj.PWD2, 
					obj.PWD, 
					obj.NAME, 
					obj.JUMIN, 
					obj.PHONE, 
					obj.ADDR );
			
			var validationStr = new Array('<span style="color: red;">아이디는 이메일 형식으로 입력하세요.</span>',
					'<span style="color: red;">비밀번호는 6~15자리 이내로 숫자와 문자를 포함해야 합니다.</span>',
					'<span style="color: red;">전화번호를 입력하세요.</span>',
					'<span style="color: red;">비밀번호를 정확히 입력해주세요.</span>',
					'<span style="color: red;">비밀번호를 입력하세요.</span>',
					'<span style="color: red;">이름을 입력하세요.</span>',
					'<span style="color: red;">주민번호 앞자리를 입력하세요.</span>',
					'<span style="color: red;">전화번호 양식이 맞지 않습니다.</span>',
					'<span style="color: red;">주소를 입력하세요.</span>' );
			
			var FilterType = new Array( emailFilter, 
					pwdFilter, 
					phoneFilter );
			
			for(var i = 0; i	< 9; i++) {
				if (i	< 3) {
					if (FilterType[i].test(tagName[i].value) == false) {
						return validation(i);
					}
				} else if (i == 3) {
					if (tagName[i].value == '' || tagName[i].value != tagName[i + 1].value) {
						return validation(i);
					}
				} else {
					if (tagName[i].value == '') {
						return validation(i);
					}
				}
			}
			
			//인증번호 값
			if (obj.chkCode2 == null && typeof(obj.chkCode2) == 'undefined') {
				alert('이메일 인증을 하지 않았습니다.');

				return false;
			}

			if (obj.chkCode1.value != obj.chkCode2.value) {
				alert('인증번호가 일치하지 않습니다.');
				
				return false;
			}

			var comSubmit = new ComSubmit("regForm");
			
			comSubmit.setUrl("<c:url value='/member/register' />");
			comSubmit.submit();
			
			obj.reset(); 
			
			function validation(i) {
				document.getElementById(tagId[i]).innerHTML=(validationStr[i]);
				
				tagName[i].value = "";
				tagName[i].focus();
				
				return false;
			}
		}
		
		function validationKeyUp3() {	
			idChk = null;
			
			if (emailFilter.test(obj.ID.value) == false) {
				document.getElementById("alert_text3").innerHTML=('<span style="color: red;">아이디는 이메일 형식으로 입력하세요.</span>'); 
				
				return;
			} else if (emailFilter.test(obj.ID.value) == true && idChk == null) {
				document.getElementById("alert_text3").innerHTML=('<span style="color: red;">ID 중복 확인을 해주세요.</span>');
			
				return;
			}
		}	
		
		function validationKeyUp4() { 
	         if (pwdFilter.test(obj.PWD.value)==false) {
	            document.getElementById("alert_text5").innerHTML=('<span style="color: red;">비밀번호가 일치하지 않습니다.</span>'); 
	            document.getElementById("alert_text4").innerHTML=('<span style="color: red;">6~15자리 이내로 숫자와 문자를 포함해야 합니다.</span>'); 
	            return;
	         } else if(obj.PWD2.value != obj.PWD.value){
	            document.getElementById("alert_text5").innerHTML=('<span style="color: red;">비밀번호가 일치하지 않습니다.</span>'); 
	            document.getElementById("alert_text4").innerHTML=('<span style="color: red;">비밀번호가 일치하지 않습니다.</span>'); 
	            return;
	         } else{
	            document.getElementById("alert_text4").innerHTML=('<span style="color: green;">정상적으로 입력되었습니다.</span>');   
	            document.getElementById("alert_text5").innerHTML=('<span style="color: green;">입력한 비밀번호와 일치합니다.</span>');
	         } 
	      }   
	      
	      ///조건 처리 미흡
	      function validationKeyUp5() { 
	         if(obj.PWD2.value == '' || obj.PWD2.value != obj.PWD.value) {
	            document.getElementById("alert_text5").innerHTML=('<span style="color: red;">비밀번호가 일치하지 않습니다.</span>'); 
	            document.getElementById("alert_text4").innerHTML=('<span style="color: red;">비밀번호가 일치하지 않습니다.</span>'); 
	            return;
	         } else {
	            document.getElementById("alert_text5").innerHTML=('<span style="color: green;">입력한 비밀번호와 일치합니다.</span>'); 
	            document.getElementById("alert_text4").innerHTML=('<span style="color: green;">정상적으로 입력되었습니다.</span>');   
	         }
	      }
		
		function validationKeyUp6() { 
			if(obj.NAME.value.length< 1) {
				document.getElementById("alert_text6").innerHTML=('<span style="color: red;">성함을 입력해주세요.</span>');
				
				return;
			} else {
				document.getElementById("alert_text6").innerHTML=('<span style="color: green;">정상적으로 입력되었습니다.</span>'); 
			}
		}
		
		function validationKeyUp7() {
			if( (obj.JUMIN.value.length)< 5) {
				document.getElementById("alert_text7").innerHTML=('<span style="color: red;">주민번호 앞 6자리를 입력해주세요.</span>');
				
				return;
			} else {
				document.getElementById("alert_text7").innerHTML=('<span style="color: green;">정상적으로 입력되었습니다.</span>'); 
			}
		}
		
		function validationKeyUp8() { 
			if(phoneFilter.test(obj.PHONE.value)==false) {
				document.getElementById("alert_text8").innerHTML=('<span style="color: red;">전화번호 양식에 맞게 입력해주세요.</span>');
				
				return;
			} else {
				document.getElementById("alert_text8").innerHTML=('<span style="color: green;">정상적으로 입력되었습니다.</span>'); 
			}
		}
		
		function validationKeyUp9() { 
			if(obj.ADDR.value.length< 5) {
				document.getElementById("alert_text9").innerHTML=('<span style="color: red;">주소를 입력해주세요.</span>');
				
				return;
			} else {
				document.getElementById("alert_text9").innerHTML=('<span style="color: green;">정상적으로 입력되었습니다.</span>'); 
			}
		}
			
		/* 비밀번호 찾기 */	
		var pass = document.findPWD;
		
		function validationEmpty3() {
			if(pass.ID.value == '') {
				document.getElementById("alertID").innerHTML=('<span style="color: red;">아이디를 입력하세요</span>'); 
				document.getElementById("alertPWD").innerHTML=('<span style="color: red;">비밀번호를 입력하세요.</span>'); 
				
				pass.ID.focus();
				
				return false;
			}
			if (emailFilter.test(pass.ID.value)==false) {
				document.getElementById("alertID").innerHTML=('<span style="color: red;">아이디는 이메일 형식으로</span>'); 
			
				pass.ID.value ="";
				pass.ID.focus();
			
				return false;
			}
			
			if(pass.PWD.value == '') {
				document.getElementById("alertPWD").innerHTML=('<span style="color: red;">비밀번호를 입력하세요.</span>'); 
				pass.PWD.focus();
			
				return false;
			}
			
			if(pwdFilter.test(pass.PWD.value)==false) {
				document.getElementById("alertPWD").innerHTML=('<span style="color: red;">비밀번호가 맞지 않습니다.</span>'); 
				pass.PWD.focus();
				
				return false;
			} 
			
			if(pass.chkCode1.value != pass.chkCode2.value) {
				alert('인증번호가 일치하지 않습니다.');
				
				return false;
			}
			
			var comSubmit =new ComSubmit("findPWD");
			comSubmit.setUrl("<c:url value='/member/newPWD' />");
			
			comSubmit.submit();
			
			pass.reset();
		}	
		
		function validationKeyUpPWD() {
			idChk = null;
			if (emailFilter.test(pass.ID.value) == false) {
				document.getElementById("alertID").innerHTML=('<span style="color: red;">아이디는 이메일 형식으로 입력하세요.</span>'); 
				
				return;
			} else {
				document.getElementById("alertID").innerHTML=('<span style="color: green;">정상적으로 입력되었습니다.</span>');
			}
		}	
	
		//인증번호
		var joinCode = Math.floor(Math.random() * 100000) + 1;
		
		function over(ID) { //함수 설명: 1. 이메일 양식 확인,  2. 이메일 중복 확인, 3. 인증번호 입력 칸 및 인증 번호 저장 폼 
			if (emailFilter.test(ID) == false) {
				alert("이메일 아이디를 입력하세요.");	
			} else {
				$.ajax({ 
					type : "POST",
					url : "/hospital/member/checkId",
					data : ({
						mode : "ID",
						ID : ID
					}), success : function(data) {	
						if (data.checkId == 1) {
							document.getElementById("alert_text3").innerHTML=('<span style="color: red;">사용이 불가능한 아이디입니다.</span>');
								
						} else {				
							document.getElementById("alert_text3").innerHTML=('<span style="color: green;">아이디를 사용할 수 있습니다.</span>');	

							$('#getCode').empty();
							
							var html = ''
								+ '<div class="input-group-prepend" style="margin-top:10px;" >'
									+ '<span class="input-group-text" style="float:left;">'
										+ '<i class="fa fa-lock"></i>'
									+ '</span>'
									+'<div class="input-group">'
										+ '<span class="input-group-prepend">'
											+ '<input name="chkCode1" id="chkCode1 style="float:right;" placeholder="인증번호 입력" type="text" class="form-control">'
										+ '</span>'
									+'</div>'
								+ '</div>'
								+ '<input type="hidden" name="codeSent" id="codeSent"/>'
								+ '<input type="hidden" name="checkId" id="checkId" value="' + data.checkId + '"';			
						
							$('#getCode').append(html);					
						}
						
						if (ID == "") {
							return false;
						} else {					
							$.ajax({ 
								type : "POST",
								url : "/hospital/member/sendMail",
								data : ({
									mode : "ID",
									ID : ID,
									joinCode : joinCode
								}),	success : function(data2) {
									if (data.checkId == 0) {
										setCookie("userInputId", $("input[name='ID']").val(), 1);
							
										$('#chkCode').empty();
										
										var html ='<td><input type="hidden" id="chkCode2" name="chkCode2" value=' + data2.joinCode + '></td>';
										
										$('#chkCode').append(html);
									}
								}
							});
						}
					
						var userInputId = $("input[name='ID']").val();
					
						setCookie("userInputId", userInputId, 7);
					}, error : function() {
						deleteCookie("userInputId");
					}
				});
			}
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		var mapContainer = document.getElementById('map'), mapOption = {
			center:new daum.maps.LatLng(37.537187, 127.005476),
			level: 5
		};
		
		var map = new daum.maps.Map(mapContainer, mapOption);
		
		var geocoder = new daum.maps.services.Geocoder();
		
		var marker = new daum.maps.Marker({
			position:new daum.maps.LatLng(37.537187, 127.005476),
			map: map
		});
		
		function sample5_execDaumPostcode() {
			new daum.Postcode({
				oncomplete:function(data) {
					var addr = data.address;
					
					document.getElementById("sample5_address").value = addr;
					
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

		function newPWD(ID) {//함수 설명 : 1. 암호 변경, 2. 아이디 확인, 3. 인증번호칸 및 인증번호 출력
			if (ID == "") {
				alert("아이디를 입력하세요.");
				
				return false;
			} else {	
				$.ajax({ 
					type : "POST",
					url : "/hospital/member/sendMail",
					data : ({
						mode : "ID",
						ID : ID,
						joinCode: joinCode
					}), success :function(data) {				
						if (data.checkId != 0) {							
							//쿠키 시작 -------------				
							var userInputId = $("input[name='ID']").val();
							
							setCookie("userInputId", userInputId, 1);// 1일 동안 쿠키 보관
							//쿠키 끝 --------------	
							
							/* ajax로 가져온 데이터 생성 */
							$('#newPWD2').empty();
							
							var html =''
								+ '<input type="hidden" name="chkCode2" value=' + data.joinCode + '>'
								+ '<td>'
									+ '<div class="form-row">'
										+ '<div class="col-md-12 mb-3">'
											+ '<div class="input-group">'
												+ '<div class="input-group-prepend">'
													+ '<span class="input-group-text">'
														+ '<i class="fa fa-lock"></i>'
													+ '</span>'
												+ '</div>'
												+ '<input name="PWD" type="text" class="form-control" placeholder="변경 비밀번호" onkeyup="validationKeyUp4()" maxlength="20">'
											+ '</div>'
										+ '</div>'
									+ '</div>'
								+ '</td>'
								+ '<td>'
									+ '<div class="form-row">' 
										+ '<div class="col-md-12 mb-3">'
											+ '<div class="input-group">' 
												+ '<div class="input-group-prepend">' 
													+ '<span class="input-group-text">'
														+ '<i class="fa fa-lock"></i>'
													+ '</span>'
												+ '</div>'
												+ '<input name="PWD2" type="text" class="form-control" placeholder="다시입력" onkeyup="validationKeyUp5()" maxlength="20">'
											+ '</div>'
										+ '</div>'
									+ '</div>'
								+ '</td>';
								
							$('#newPWD2').append(html); 
							

							$('#newPWD').empty();
							
							html =''
								+'<tr>'
								+'<td>'
								+ '<span class="input-group-text" style="float:left;">'
									+'<i class="fa fa-lock" style="padding: 0px 15px 0px 0px"></i>'
									+'<input class="btn-twitter" style="float:left;" type="button" value="인증번호 받기" onclick="newPWD(document.getElementById("findPwID").value)" >'
								+'</span>'
								+'</td>'  

								+'<td style="padding-left: 35px">'
								+'<div class="input-group" style="display: -webkit-inline-box;">' 
									+ '<input name="chkCode1" id="chkCode1 style="float:right;" placeholder="인증번호 입력" type="text" class="form-control">'
								+'</div>'
								+'</td>'
								+'</tr>';
							
							$('#newPWD').append(html); 
							
							
						}
					}
				});
			}
		}
		

		/* 카카오 로그인 */
		//<![CDATA[
		// 사용할 앱의 JavaScript 키를 설정해 주세요.
		Kakao.init('a2a026028f5ff6b1e76fd91816f13681');
		function loginWithKakao() {
			// 로그인 창을 띄웁니다.
			Kakao.Auth.login({
				success: function(authObj) {
					//파라미터 
					Kakao.Auth.setAccessToken(authObj.access_token);
					
					Kakao.API.request({
						url: '/v1/user/me',
						success: function(res) {
							var kakao_id = res.id; //unique id  숫자
							var kakao_name = res.properties.nickname; //이름							
							var kakao_img = res.properties.profile_image;
							
							alert(kakao_name+'님 환영합니다.');

							var comSubmit = new ComSubmit();
							comSubmit.setUrl("<c:url value='/member/kakaoLogin' />");
							comSubmit.addParam("ID", kakao_id);	
							comSubmit.addParam("NAME", kakao_name);
							comSubmit.addParam("ID_IMG", kakao_img);
							
							comSubmit.submit();
						}, fail: function(error) {
							alert(JSON.stringify(error));
						}
					});
				}, fail: function(err) {
					alert(JSON.stringify(err));
				}
			});
		};
		
		
		/* 쿠키 함수*/ 
		function setCookie(cookieName, value, exdays) {
			var exdate = new Date();
			
			exdate.setDate(exdate.getDate() + exdays);
			
			var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
			
			document.cookie = cookieName + "=" + cookieValue;
		}
		
		function deleteCookie(cookieName) {
			var expireDate = new Date();
			
			expireDate.setDate(expireDate.getDate() - 1);
			document.cookie = cookieName + "=" +	"; expires=" + expireDate.toGMTString();
		}
		
		function getCookie(cookieName) {
			cookieName += '=';
			var cookieData = document.cookie;
			var start = cookieData.indexOf(cookieName);
			var cookieValue = '';
			
			if(start != -1) {
				start += cookieName.length;
				
				var end = cookieData.indexOf(';', start);
				
				if(end == -1)
					end = cookieData.length;
				
				cookieValue = cookieData.substring(start, end);
			}
			
			return unescape(cookieValue);
		}	
	</script>
</body>
</html>