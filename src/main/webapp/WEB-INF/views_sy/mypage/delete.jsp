<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<%@ include file="/WEB-INF/include/include-header.jspf"%>
<link rel="stylesheet" 
		href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" 
		integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" 
		crossorigin="anonymous">
		
	<link rel="stylesheet" 
		href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" 
		integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" 
		crossorigin="anonymous">
<title>회원탈퇴</title>
</head>
<body>
	<form name="deleteAccount" id="deleteAccount" class="form-reset" novalidate>
		<br/><br/>
		
		<input type="hidden" id="IDX" name="IDX" value="${IDX}"/>
		
		<div class="form-row">
			<div class="col-md-12 mb-3">
				<div class="input-group">
					<input type="email" class="form-control" name="ID" id="findPwID" placeholder="이메일 주소" onkeyup="validationKeyUpPWD()" maxlength="20">
				</div> 
				
				<div class="input-group">
					<span id="alertID">
						<span style="color: #777"></span>
					</span>
					<br/>
				</div>
				
				<span class="input-group-text" style="float:left;">
					<i class="fa fa-lock" style="padding: 0px 15px 0px 0px"></i>				
					<input class="btn-twitter" style="float:left;" type="button" value="인증번호 받기" onclick="newPWD(document.getElementById('findPwID').value)" >		 
				</span>  
				
				<div class="input-group"> 
					<!-- 인증 번호 받기 칸 -->
					<div id="newPWD"></div> 
				</div>	
				<br/>	
				
				<div class="row" style="display:block;">
					<input type="submit" id="write3" class="btn btn-primary btn-block" value="회원탈퇴"><br>
				</div>	
				
				<!-- flashAttribute --> 
				<span>
					<span style="color: red">${msg}</span>
				</span>
			</div>
		</div> 
	</form> 
</body>

<script>
	$("#write3").on("click", function(e) {//3 암호 찾기
		e.preventDefault(); 
		validationEmpty3(); 
	});
	
	var emailFilter=/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;	
	var pass = document.deleteAccount;
	
	//keyup
	function validationKeyUpPWD() {
		idChk = null;
		if (emailFilter.test(pass.ID.value) == false) {
			document.getElementById("alertID").innerHTML=('<span style="color: red;">아이디는 이메일 형식으로 입력하세요.</span>'); 
			
			return;
		} else {
			document.getElementById("alertID").innerHTML=('<span style="color: green;">정상적으로 입력되었습니다.</span>');
		}
	}	
	
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
		
		if(pass.chkCode1.value != pass.chkCode2.value) {
			alert('인증번호가 일치하지 않습니다.');
			
			return false;
		}
		pass.reset();
		
	    var comSubmit = new ComSubmit("deleteAccount");
		comSubmit.setUrl("<c:url value='/mypage/delete' />");
		
		comSubmit.submit();

		var comAjax = new ComAjax();
	    comAjax.addParam("IDX", $("#IDX").val());
		comAjax.setCallback("closeWin");
		
		comAjax.ajax();
	}	
	
	function closeWin(){
		alert("정상적으로 회원탈퇴가 되었습니다.");
		window.opener.location.href = "http://localhost:8080/hospital/main";
	    self.close();
	}
	
	//인증번호
	var joinCode = Math.floor(Math.random() * 100000) + 1;
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
					/* ajax로 가져온 데이터 생성 */
					$('#newPWD').empty();
					
					var html =''
						+ '<td>'
							+ '<input type="hidden" name="chkCode2" value=' + data.joinCode + '>'
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
									+ '<input name="chkCode1" id="chkCode1 style="float:right;" maxlength="5" placeholder="인증번호 입력" type="text" class="form-control">'
									+ '<div class="input-group">'
									+ '</div>'
										+ '<span id="alertPWD">'
											+ '<span style="color: #777"></span>이메일로 보낸 인증번호를 입력해주세요.'
										+ '</span>'
									+'</div>'
								+ '</div>'
							+ '</div>'
						+ '</div>'
					+ '</td>'
					+ '<td>';
					
					$('#newPWD').append(html); 
				}
			});
		}
	}
</script>
</html>