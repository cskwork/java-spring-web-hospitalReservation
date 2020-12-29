<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/include/include-header.jspf" %>
	
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/adminui.css'/>" />
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<title>로그인 화면</title>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
</head>

<body>
<div class="main">
<h2>회원 정보</h2>
<table border="1" width="100%">
<tr>
<th>프로필 사진</th>
<th>ID/EMAIL</th>
<th>이름</th>
<th>암호</th>
<th>이메일 수신 확인</th>
<th>전화번호</th>
<th>주소</th>
<th>주민등록번호</th>          
<th>신장</th>
<th>몸무게</th>
<th>혈액형</th>
<th>계좌번호</th>         
<th>회원가입날짜</th>  
</tr>
<c:choose>
	<c:when test="${fn:length(login) > 0}">
		<tr>
			<td>${login.IDX}</td>
		   
		<td class="title">
		<a href="#this" name="id">${login.ID}</a>
			<input type='hidden' id='IDX' value="${login.IDX}">
			</td>
		          
		<td>${login.NAME}</td>
		<td>${login.PWD}</td>
		<td>${login.MMS_CHK}</td>
		<td>${login.PHONE}</td>    
		<td>${login.ADDR}</td>
		<td>${login.JUMIN}</td>
		
		<td>
		    -
		<c:if test="${not empty login.HEIGHT}">
		  		 ${login.HEIGHT}
		</c:if>
		</td>
		    
		<td>
			-
		<c:if test="${not empty login.WEIGHT}">
		  		 ${login.WEIGHT}
		</c:if>
		</td>
		<td>
		   -
		<c:if test="${not empty login.B_TYPE}">
		   		${login.B_TYPE}
		</c:if>
		</td>
		<td>
		    -
		<c:if test="${not empty login.BANK_NO}">
		   		${login.BANK_NO}
		</c:if>
		</td>
		  
		<td>${login.JOINDATE}</td>
		</tr>
		</c:when>
	<c:otherwise>
	 	<tr>
	<td colspan="4">조회된 회원이 없습니다.</td>
	</tr>
	</c:otherwise>
</c:choose>
</table>
    
</div>


<a href="#" onclick="kakaoOut()"><img src="/hospital/img/kakao_logout.PNG" style="width:25%"></a>

<br/><br/>

<div id="plusfriend-add-button" data-plusfriend-id="_xcLqmC" data-size="small" data-color="black" data-shape="rect" data-support-multiple-densities="true"></div>
<script>

/* 카카오 플러스  친구 */

window.kakaoAsyncInit = function () {
    Kakao.PlusFriend.createAddFriendButton({
      container: '#plusfriend-add-button'
    });
  };

  (function (d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//developers.kakao.com/sdk/js/kakao.plusfriend.min.js";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'kakao-js-sdk'));

 
/* 카카오 로그아웃 */
 function kakaoOut(){
	 Kakao.Auth.logout(function(){
		 setTimeout(function(){
			 location.href="/hospital/member/login"
		 }, 1000);
	 });
 }
  
  
</script>

</body>
</html>