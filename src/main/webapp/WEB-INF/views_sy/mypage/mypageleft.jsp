<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
<table>
	<tr>
		<td><a href="#this" id="health" name="health">건강수첩</a></td>
	</tr>
	<tr>
		<td><a href="#this" id="reservInfo" name="reservInfo">예약내역</a>	</td>
	</tr>
	<tr>
		<td><a href="#this" id="pastreservInfo" name="pastreservInfo">지난예약내역</a>	</td>
	</tr>
	<tr>
		<td><a href="#this" id="favhp" name="favhp">관심병원</a></td>
	</tr>
	<tr>
		<td><a href="#this" id="rating" name="rating">만족도 조사 참여하기</a></td>
	</tr>
</table>
<h2>병원리스트</h2>
<table border="1">
	<thead> 
		<tr>
	       <th scope="col">번호</th>
	       <th scope="col">병원명</th>
	       <th scope="col"></th>
		</tr>
	<tbody> 
      <c:forEach var="row" items="${list}">
       <tr>
       	<td>${row.H_IDX}</td>
       	<td>
       		<a href="#" name="testdetail">${row.HOSP}</a>
       		<input type="hidden" id="H_IDX" value="${row.H_IDX }"/>
       	</td>
       	<td>
       		<a href="#" name="fav">관심병원등록</a>
       		<input type="hidden" id="H_IDX" value="${row.H_IDX }"/>
       		<input type="hidden" id="ID" value="sy"/><!-- 임의지정! 나중에 지워야함 -->   			
       	</td>
       </tr>
      </c:forEach> 
	</tbody>   
</table>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
<script type="text/javascript">
$(document).ready(function(){
	//병원 상세보기 test용
	$("a[name='testdetail']").on("click", function(e){
        e.preventDefault();
        fn_testdetail($(this));
    });	
	
    $("#health").on("click", function(e){ //건강수첩 버튼
        e.preventDefault();
        fn_openMypage();
    }); 
    
    $("#reservInfo").on("click", function(e){ //예약내역 버튼
        e.preventDefault();
        fn_openMyReserv();
    });
    
    $("#pastreservInfo").on("click", function(e){ //지난예약내역 버튼
        e.preventDefault();
        fn_openMyPastReserv();
    });
    
    $("#favhp").on("click", function(e){ //관심병원등록하기 버튼
        e.preventDefault();
        fn_openMyFavhp();
    });
    
	$("#reserv").on("click", function(e){ //예약하기 버튼
		e.preventDefault();
		fn_openReserv();
	});
    
    $("a[name='fav']").on("click", function(e){ //관심병원등록하기 버튼
        e.preventDefault();
        fn_myFavhp($(this));
    });   
    
    $("#rating").on("click", function(e){ //만족도조사참여하기 버튼
        e.preventDefault();
        fn_Rating();
    }); 
});

//마이페이지(건강수첩) 버튼
function fn_openMypage(){
    var comSubmit = new ComSubmit();
    comSubmit.setUrl("<c:url value='/mypage/OpenMypageMain' />");
    comSubmit.addParam("ID","sy");//ID 임의 지정함 나중에 지울것!!!!!!!!!!!!!!!
    comSubmit.submit();
}

//예약내역페이지 버튼
function fn_openMyReserv(){
    var comSubmit = new ComSubmit();
    comSubmit.setUrl("<c:url value='/reserv/MyReserv' />");
    comSubmit.addParam("ID","sy");//ID 임의 지정함 나중에 지울것!!!!!!!!!!!!!!!
    comSubmit.addParam("STEP","reserv");//예약내역인지 지난예약인지 구분
    comSubmit.submit();
}

//지난예약내역페이지 버튼
function fn_openMyPastReserv(){
	var comSubmit = new ComSubmit();
	comSubmit.setUrl("<c:url value='/reserv/MyPastReserv' />");
	comSubmit.addParam("ID","sy");//ID 임의 지정함 나중에 지울것!!!!!!!!!!!!!!!
	comSubmit.addParam("STEP","pastreserv");//예약내역인지 지난예약인지 구분
	comSubmit.submit();
}

//관심병원페이지 버튼
function fn_openMyFavhp(){
    var comSubmit = new ComSubmit();
    comSubmit.setUrl("<c:url value='/mypage/OpenMypageFavhp' />");
    comSubmit.addParam("ID","sy");//ID 임의 지정함 나중에 지울것!!!!!!!!!!!!!!!
    comSubmit.submit();
}

//관심병원등록하기 버튼
function fn_myFavhp(obj){
	var comSubmit = new ComSubmit();
	if(confirm("관심병원 등록하시겠습니까?") == true){
		comSubmit.setUrl("<c:url value='/mypage/InsertFav'/>");
		comSubmit.addParam("H_IDX", obj.parent().find("#H_IDX").val());
		comSubmit.addParam("ID",obj.parent().find("#ID").val());//ID 임의 지정함 나중에 지울것!!!!!!!!!!!!!!!
		comSubmit.submit();
	}else{
		false;
	}
}

//만족도조사참여하기 버튼
function fn_Rating(){
	var comSubmit = new ComSubmit();
	comSubmit.setUrl("<c:url value='/rate/RatingList' />");
    comSubmit.addParam("ID","sy");//ID 임의 지정함 나중에 지울것!!!!!!!!!!!!!!!
    comSubmit.submit();
}
</script>
</body>
</html>