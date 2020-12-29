<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<!-- http://localhost:8080/hospital/member/register -->
<style>
body {font-family: "Lato", sans-serif;}

.sidebar {
  height: 100%;
  width: 300px;
  position: fixed;
  z-index: 1;
  top: 0;
  left: 0;
  background-color: #111;
  overflow-x: hidden;
  padding-top: 16px;
  text-align:left;
}

.sidebar a {
  padding: 6px 8px 6px 16px;
  text-decoration: none;
  font-size: 20px;
  color: #818181;
  display: block;
}

.sidebar a:hover {
  color: #f1f1f1;
}

.main {
 /*  margin-left: 300px; */ /* Same as the width of the sidenav */
  padding: 0px 10px;
  position: fixed;
  left: 300px;
  background-color:lightcyan ;
  bottom: 0px;
  top:0px;
}

@media screen and (max-height: 450px) {
  .sidebar {padding-top: 15px;}
  .sidebar a {font-size: 18px;}
}

h2{
	font-weight:bold;
}
</style>
<title>회원등록 페이지</title>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>

  <body class="text-center"><%@ include file="/WEB-INF/include/include-body.jspf" %>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
 <div class="main">

<div class="register-box">
    <div class="register-logo">
        <a href="${path}/member/register">
            <b>회원가입</b>&nbsp 
        </a>
    </div>

    <div class="register-box-body">   
    <p class="login-box-msg">회원가입 페이지</p>

<form name="frm" id="frm">
    <table border="1" width="400px">
        <tr>
            <td>ID 또는 이메일 주소</td>
            <td><input name="ID" value="${map.ID}"/></td>
             <td>
				<input type="hidden" id="IDX" name="IDX" value="${map.IDX}">
			</td>
        </tr>
                  
        <hr/>
        
        <tr>
            <td>비밀번호</td>
            <td>
           		<input type="password" name="PWD" value="${map.PWD}">
            </td>
        </tr>
                  
        <tr>
            <td>이름</td>
            <td>
           		 <input name="NAME" value="${map.NAME}"/>
            </td>
        </tr>
         <tr>
            <td>전화번호</td>
            <td>
            	<input name="PHONE" value="${map.PHONE}"/>
            </td>
        </tr>
        <tr>
            <td>주민등록번호 앞자리</td>
            <td>
            	<input name="JUMIN" value="${map.JUMIN}"/>
            </td>
        </tr>
        
        <tr>
            <td>주소</td>
            <td>
            	<input name="ADDR" size="30" value="${map.ADDR}">
            </td>
        </tr>
        <tr>
            <td>신장</td>
            <td>
           		 <input name="HEIGHT" size="30" value="${map.HEIGHT}">
            </td>
        </tr>
        <tr>
            <td>체중</td>
            <td>
           		 <input name="WEIGHT" size="30" value="${map.WEIGHT}">
            </td>
        </tr>
        <tr>
            <td>혈액형</td>
            <td>
            	 <input name="B_TYPE" size="30" value="${map.B_TYPE}">
            </td>
        </tr>
        <tr>
            <td>계좌번호</td>
            <td>
            	<input name="BANK_NO" size="30" value="${map.BANK_NO}">
            </td>
        </tr>
    </table>
    
    <div class="row">
       <div class="col-xs-10">
          <div class="checkbox icheck"> 
                   <br/><input type="checkbox" name="MMS_CHK" id="MMS_CHK" value="${map.MMS_CHK}">                   
           		<label for="MMS_CHK">문자수신여부</label>
           </div> 
       </div>
    </div> 
</form>
    	<br/>
     	<a href="${path}/hospital/member/login" class="btn-outline-primary">로그인</a>
     
    	<a href="#this" class="btn" id="list">목록으로</a>
		<a href="#this" class="btn" id="update">수정하기</a>
		<a href="#this" class="btn" id="delete">삭제하기</a>
		     
     </div>
<!-- /.form-box -->
</div>




</div>
<!-- /.register-box -->
   <script type="text/javascript">
   var gfv_count = '${fn:length(list)+1}';

	$(document).ready(function(){		
		$("#list").on("click", function(e){ //목록으로 버튼
			e.preventDefault();
			fn_openBoardList();
		});
		
		$("#update").on("click", function(e){ //수정하기 버튼
			e.preventDefault();
			fn_updateBoard();
		});
		
		$("#delete").on("click", function(e){ //삭제하기 버튼
			e.preventDefault();
			fn_deleteBoard();
		});             
            
           $("a[name^='delete_']").on("click", function(e){ //삭제 버튼
               e.preventDefault();
               fn_deleteFile($(this));
           });	
	});
	function fn_openBoardList(){
		var comSubmit = new ComSubmit();
		
		comSubmit.setUrl("<c:url value='/member/list' />");
		comSubmit.submit();
	}
	function fn_updateBoard(){
		var comSubmit = new ComSubmit("frm");
		comSubmit.setUrl("<c:url value='/member/infoUpdate2' />");
		comSubmit.submit();
	}
	
	function fn_deleteBoard(){
		var comSubmit = new ComSubmit();
		comSubmit.setUrl("<c:url value='/member/deleteMemb' />");
		comSubmit.addParam("IDX", $("#IDX").val());
		comSubmit.submit();
		
	}               
       function fn_deleteFile(obj){
           obj.parent().remove();
       }
		
	$(function () {
        $('input').iCheck({
            checkboxClass: 'icheckbox_square-blue',
            radioClass: 'iradio_square-blue',
            increaseArea: '20%' // optional
        });
    
       $('#MMS_CHK').on('change', function(){
       	   this.value = this.checked ? 1 : 0;
       	}).change();
        
        
    });
</script>
    
</body>
</html>