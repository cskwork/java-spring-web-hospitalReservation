<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<div class="myReservList">
		<c:choose>
			<c:when test="${STEP == 'reserv'}">
				<h2>예약내역</h2>
			</c:when>
	
			<c:otherwise>
				<h2>지난예약내역</h2>
			</c:otherwise>
		</c:choose>
	
		<c:if test="${STEP == 'reserv'}">
			<a href="#this" name="cancel" style="float:right; display:block;">예약 취소</a>
		</c:if>
		
		<table style="width: 650px;">
			<colgroup>
			 		<c:if test="${STEP == 'reserv'}">
						<col width="*"/>
					</c:if>
		            <col width="17%"/>
		            <col width="17%"/>
		            <col width="17%"/>
		            <col width="49%"/>
		        </colgroup>
		        <thead>
		            <tr>
			            <c:if test="${STEP == 'reserv'}">
							<th scope="col" style="padding-left : 5px;"><input type="checkbox" name="checkAll" id="th_checkAll" onclick="checkAll();"/></th>
						</c:if>
						
						<td scope="col"><p id="p_border">예약번호</p></td>               
		                <td scope="col"><p id="p_border">예약일시</p></td>
		                <td scope="col"><p id="p_border">예약시간</p></td>
		                <td scope="col"><p				>병원명</p></td>
		                
			            <c:if test="${STEP == 'pastreserv'}">
							<th scope="col">상태</th>
						</c:if>
		            </tr>
		        </thead>
		        <tbody>
		            <c:choose>
		                <c:when test="${fn:length(list) > 0}">
		                    <c:forEach items="${list}" var="row" varStatus="stat">
		                        <tr>
			                        <c:if test="${STEP == 'reserv'}">
			                            <td align="center" id="td"><input type="checkbox" value="${row.H_IDX}" id="checkRow" name="checkRow"/></td> 
			                        </c:if>
			                        
		                        	<td>${row.NUM}</td>                                       
		                            <td>${row.RESERV1}</td>
		                            <td>${row.RESERV2}</td>
		                            <td>${row.HOSP}</td>
		                            
									<c:if test="${STEP == 'pastreserv'}">
										<td>${row.STATE}</td>
									</c:if>         
		                        </tr>
		                    </c:forEach>
		                </c:when>
		                <c:otherwise>
		                    <tr>
		                        <td colspan="5" align="center">조회된 결과가 없습니다.</td>
		                    </tr>
		                </c:otherwise>
		            </c:choose>
		        </tbody>
		</table>		
		
		<p id="Warning">
			※ 병원에 대기하는 환자가 많거나 현재 시간 기준으로 + 30분은 예약 및 예약수정이 불가능합니다.<br>
			재예약을 원하시는 분은 신중히 취소해 주시기 바랍니다.<br>
		</p>
		
		<p id="Notice">
			※ 『정보통신망 이용촉진 및 정보보호 등에 관한 법률』 제 30조 2항(개인정보 이용내역의 통지)에 따라 에버메디 예약 서비스를 이용한 회원님의 개인정보 이용내역입니다.<br>
			※ ‘예약내역’ 에는 오늘 날짜 이후의 예약내역만 확인하실 수 있습니다.<br>
			※ 오늘 이전의 예약내역은 <font color="blue">‘지난예약내역’</font> 에서 확인하시기 바랍니다.
		</p>		
	</div>
	
	<%@ include file="/WEB-INF/include/include-body.jspf" %>
	
	<script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script><!-- jQuery CDN --->
	
	<script type="text/javascript">
		$(document).ready(function(){
			$("a[name='cancel']").on("click", function(e){
		        e.preventDefault();
		 		fn_cancelReserv();
		    });
		});
		function fn_cancelReserv(){
			var comSubmit = new ComSubmit();
			var parent = document.getElementsByName('checkRow');
			var h_idx = new Array();
			var num = 0;
			
			for(var i = 0;i < parent.length; i++) {
				if(parent[i].checked == true) {
					h_idx[num++] = parent[i].value;
				}
			}
			
			if(num==0){
				alert("예약취소할 병원을 선택하세요");
			} else {
				if(confirm("정말 예약 취소하시겠습니까?") == true) {
					comSubmit.setUrl("<c:url value='/reserv/CancelReserv' />");
					comSubmit.addParam("H_IDX", h_idx);
					comSubmit.addParam("STEP","reserv")//예약내역인지 지난예약내역인지 구분
					comSubmit.submit();
				} else {
					$("#th_checkAll").prop("checked", false);
					$("input[id=checkRow]").prop("checked", false);
					
					return;
				}
			}
		}
		
		function checkAll(){
		    if($("#th_checkAll").is(':checked') ) {
		      $("input[id=checkRow]").prop("checked", true);
		    } else {
		      $("input[id=checkRow]").prop("checked", false);
		    }
		}
	</script>
</body>
</html>