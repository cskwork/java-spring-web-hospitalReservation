<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/include/include-header.jspf" %>
</head>
<body>
	<div class="Tiles_wrap">
		<h2>${boardTitle }</h2>
		<div class="center_right_top" style="background : #ffe8cd">
			<table id="searchForm">
				<tr>
					<td colspan="2">
						<select id="SEARCHTYPE">
							<option value="">검색</option>
							<option value="HOSP">병원명</option>
							<option value="ADDR">위치</option>
							<option value="MAJOR">진료과목</option>
						</select>
						<input type="text" id="SEARCHVALUE" >
						<input type="button" id="SEARCH" value="검색">
					</td>
				</tr>		
				<tr>
					<td>
						<select id="distance">
							<option value="">거리순</option>
							<option value="200">200m</option>
							<option value="500">500m</option>
							<option value="1000">1.0km</option>
							<option value="1500">1.5km</option>
							<option value="3000">3.0km</option>
							<option value="5000">5km</option>
							<option value="7000">7km</option>
							<option value="10000">10km</option>
						</select>
					</td>
					<td>
						<input type="text" id="address" style="width: 350px" placeholder="주소" disabled="disabled" value="${ADDR }" />
						<input type="button" onclick="execDaumPostcode()" value="주소 찾기" />
					</td>
				</tr>
			</table>
		</div>
		<div class="gridForm">
			<table id="listForm" >
				<colgroup>
					<col />
				</colgroup>
				<tbody>		
				</tbody>
			</table>
			
			<div>
				<div class="floatMenu">
					<table id="daumMap"></table>
				</div>
			</div>
			
			<div id="PAGE_NAVI" align="center"></div>
		</div>
		<input type="hidden" id="ID" name="ID" value="${ID }">
		<input type="hidden" id="REG_CHK" name="REG_CHK" value="${REG_CHK }">
		<input type="hidden" id="LIST" name="LIST" value="${LIST }" />
		<input type="hidden" id="QUERY" name="QUERY" value="${QUERY }" />
		<input type="hidden" id="PAGE_INDEX" name="PAGE_INDEX" value="1"/>

		<%@ include file="/WEB-INF/include/include-body.jspf" %>
	
	</div>
	
	<script type="text/javascript" >
		//로딩된 후 한번 실행하는 구간
		var floatPosition = parseInt($(".floatMenu").css('top'));
		
		$(document).ready(function() {
			window.onload = function() {
				fn_selectHpList(1);
			};	
			
			//윈도우가 스크롤 될때마다 실행되는 구간
			$(window).scroll(function(){
				// 현재 스크롤 위치를 가져온다.
				var scrollTop = $(window).scrollTop();
				var newPosition = scrollTop + $("#listForm").offset().top;
		 	
				if(0 < $("#listForm").height() + $("#listForm").offset().top - 400 && $("#listForm").height() + $("#listForm").offset().top - 400 < newPosition)
					newPosition = $("#listForm").height() + $("#listForm").offset().top - 400;
				
				newPosition += "px";
				
				$(".floatMenu").stop().animate({
					"top" : newPosition
				}, 500);
			}).scroll();
			
			$("#SEARCH").on("click", function(e) {
				e.preventDefault();
				fn_selectHpList(1);
			});
				
			$("#distance").change(function(e) {
 				e.preventDefault();
				getLocation(); 
			});

			$(document).mousemove(function(event) {
				mouse(event);
			});
		});   
		 
		function fn_openBoardDetail(obj) {
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/hplist/HpDetail' />");
			comSubmit.addParam("H_IDX", obj.parent().parent().parent().find("#H_IDX").val()); 
			
			comSubmit.submit();
		}

		var pagerow = 10;
		var pageno = 0;
		
		function fn_selectHpList(pageNo) {
			// 검색 기능
			var searchType = $("#SEARCHTYPE").val();
			var searchValue = $("#SEARCHVALUE").val();
			
			// 페이징
			pageno = pageNo;
			var list = $("#LIST").val();
			var query = $("#QUERY").val();
			var reg_chk = $("#REG_CHK").val();		
			
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/hplist/" + list + "' />");
			comAjax.setCallback("fn_selectHpListCallback");
			comAjax.addParam("PAGE_INDEX", pageno);
			comAjax.addParam("PAGE_ROW", pagerow);
			comAjax.addParam("QUERY", query);

			if(searchType != "" && searchValue != "") {
				comAjax.addParam("SEARCHTYPE", searchType);
				comAjax.addParam("SEARCHVALUE", searchValue);
				comAjax.addParam("SEARCH_CHK", "Y");
			}
			
			if(reg_chk == 'Y') 
				comAjax.addParam("REG_CHK", reg_chk);	
			
			comAjax.ajax();
		}

		var paramData = null;
		
		function fn_selectHpListCallback(data) {
			if(typeof(data) == "object") {
				paramData = data;
			}
			
			var total = paramData.TOTAL;
			
			var params = {
				divId : "PAGE_NAVI",
				pageIndex : "PAGE_INDEX",
				totalCount : total,
				eventName : "fn_selectHpListCallback",
				recordCount : pagerow
			};
			
			gfn_renderPaging(params);

			var body = $("#listForm>tbody");
			body.empty();
			
			var num = 0;
			var first = ($("#PAGE_INDEX").val() - 1) * pagerow;
			var last = $("#PAGE_INDEX").val() * pagerow;
			
			var str = "";

			$.each(paramData.list, function(key, value) {				
				if(num == paramData.list.length - 1)
					return false;
				
				if(first <= num && num < last) {
					str += ""
					+ "<tr>"
					+ "<td class='Hp_list'>"
					+ "<table id='listform" + ++num + "' class='listform" + (num % 10 == 1 ? "_border" : "") +"'>"
						+ "<tr>"
							+ "<td id='" + num + "' align='left'>"
							+	 "<b><font size='6'><a href='#this' id='" + num + "' name='title'>" + (((pageno - 1) * pagerow) + num) + ". " + (value.HOSP.length <= 10 ? value.HOSP : value.HOSP.substring(0, 9) + "...") + "</a></font></b>"
								+ "<input type='hidden' id='H_IDX' value='" + value.H_IDX + "' >"
							+ "</td>";
					
					if(value.REG_CHK == 'Y' && $("#ID").val() != null && $("#ID").val() != "")
						str += "<td id='" + num + "' align='right' style='width: 200px; padding: 0 3px 0 0'><input type='button' name='REG' value='예약가능'></td>";
							
					str += "" 
						+ "</tr>"
						+ "<tr>"
							+ "<td id='" + num + "' align='left'>▶진료과목: " + value.MAJOR + "</td>";
					
					if($("#ID").val() != null && $("#ID").val() != "")	
						str += "<td id='" + num + "' align='right' style='width: 200px; padding: 0 3px 0 0'><img name='FAVCheck' src='" + (value.FAV == null ? "/hospital/img/off.png" : "/hospital/img/on.png") + "' style='height: 24px'></img></td>";
						
					str += ""
						+ "</tr>"
						+ "<tr>"
							+ "<td id='" + num + "' align='left'>▶전화번호: " + value.TEL + "</td>"
							+ "<td id='" + num + "' align='right' style='width: 200px; padding: 0 3px 0 0'>▶진료시간: " + value.HOUR + "</td>";
						
					if(value.DISTANCE != 0) {
						if(value.DISTANCE >= 1000) {
							str += "<td id='" + num + "' align='right'>▶거리: " + (value.DISTANCE / 1000).toFixed(2) + "(km)" + "</td>";
						} else {
							str += "<td id='" + num + "' align='right'>▶거리: " + value.DISTANCE + "(m)" + "</td>";
						}
					}
					
					str += "</tr>"
						+ "<tr>"
							+ "<td id='" + num + "' colspan='2'>▶주소: " + value.ADDR + "</td>"
						+ "</tr>"
					+ "</table>"
					+ "</td>"
					+ "</tr>";
				
				} else {
					++num;
				}
				
				if(num == paramData.list.length)
					return false;
			});

			body.append(str);
			
			map_location();
			
			if ($("#address").val() != "")
				my_location($("#address").val()); 
			
			// 데이터 갯수에 따라  footer css 변경
			$(".footer").css("margin-top" ,"100px");
			
			if(paramData.list.length - 1 < 4) {
				$(".footer").css("margin-top" ,"300px");
			} 
			
			$("a[name='title']").on("click", function(e) {
				e.preventDefault();
				fn_openBoardDetail($(this));
			});
			 
			$("input[name='REG']").on("click", function(e) {
				e.preventDefault();
				fn_MovetoReservation($(this));
			});
			
			$("img[name='FAVCheck']").on("click", function() {
				var URL;
				if($(this).prop("src") == "http://localhost:8080/hospital/img/off.png") {
					URL = "/hospital/mypage/InsertFav";
					$(this).prop("src", "http://localhost:8080/hospital/img/on.png");
				} else {
					URL = "/hospital/mypage/DelFavHp";	
					$(this).prop("src", "http://localhost:8080/hospital/img/off.png");			
				}
				
				var comAjax = new ComAjax();
	            comAjax.setUrl("<c:url value='" + URL +"' />");
				comAjax.setCallback("");
				comAjax.addParam("H_IDX", $(this).parent().parent().parent().find("#H_IDX").val());

				comAjax.ajax();
			});
		}

		function fn_MovetoReservation(obj) {
			var H_IDX = obj.parent().parent().find("#H_IDX").val();
			
			if($("#ID").val() == "") {
	            alert("로그인이 필요한 서비스입니다.");
	         } else {	         
				var comSubmit = new ComSubmit();
				comSubmit.setUrl("<c:url value='/reserv/OpenReserv' />");
				comSubmit.addParam("H_IDX", H_IDX);
				
				comSubmit.submit();
	         }
		}

		function getLocation() {
			var body = $("#listForm>tbody");
			body.empty();
						
		    var list = $("#LIST").val();
			var query = $("#QUERY").val();
			var reg_chk = $("#REG_CHK").val();		
			
            var comAjax = new ComAjax();
            comAjax.setUrl("<c:url value='/hplist/" + list + "' />");
			comAjax.setCallback("fn_selectHpListCallback");
			comAjax.addParam("QUERY", query);
			comAjax.addParam("PAGE_INDEX", pageno);
			comAjax.addParam("PAGE_ROW", pagerow);
			comAjax.addParam("CURRNET_LAT", Latitude);
			comAjax.addParam("CURRNET_LON", Longitude);
			comAjax.addParam("LIMIT_DISTANCE", $('#distance option:selected').val());
			
			if(reg_chk == 'Y') 
				comAjax.addParam("REG_CHK", reg_chk);
			
			comAjax.ajax();
	   }
		
		var map = null;
		var marker = new Array();
		
		function map_location() {
			var lat = paramData.list[paramData.list.length - 1].C_LAT/* 33.450701 */;
			var lon = paramData.list[paramData.list.length - 1].C_LON/* 126.570667 */;
			
			// 지도생성
		    $('#daumMap div').remove();
		    var container = document.getElementById('daumMap');
		    
		    coords = new daum.maps.LatLng(lat, lon);
		    
		    var options = {
				center: coords,
				level: paramData.list[paramData.list.length - 1].zoom
		    };
		
			map = new daum.maps.Map(container, options);
			// -----------

			// 마커 표시
			var i = 0;
 			$.each(paramData.list, function(key, value) {
 				marker[i] = new daum.maps.Marker({
 				    map: map, 
 				    position: new daum.maps.LatLng(value.LAT, value.LON)
 				});
 				
 				var infowindow = new daum.maps.InfoWindow({
					content: value.HOSP // 인포윈도우에 표시할 내용
 			    });
 				 
 				daum.maps.event.addListener(marker[i], 'mouseover', makeOverListener(i));
 			    /* daum.maps.event.addListener(marker[i], 'click', makeOutListener()); */
 				
				if(++i == paramData.list.length)
					return false;
			});

			if($("#address").val() != "")
 				my_marker();
		}
		
		// 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
		function makeOverListener(i) {
		    return function() {
			  map_Overlay(i);
		    };
		}
		
		var overlay = null;
		function map_Overlay(targ) {
			var num;
			if(targ.id == null)
				num = targ;
			else 
				num = targ.id - 1;
			
			
			if(overlay != null)
				closeOverlay();
			
			// 커스텀 오버레이에 표시할 컨텐츠 입니다
			var content = '' +
				'<div class="Map_wrap">' +
				'	<div class="info">' +
				'		<div class="title">' +
							(paramData.list[num].HOSP.length <= 10 ? paramData.list[num].HOSP : paramData.list[num].HOSP.substring(0, 9) + "...") +
				'			<div class="close" onclick="closeOverlay()" title="닫기"></div>' +
				'		</div>' +
				'		<div class="body">' +
				'			<div class="desc" style="margin: 13px 0 0 0">' +
				'				<div class="ellipsis">' + paramData.list[num].ADDR + '</div>' +
				'					<div><a href="#this" name="m_title">상세정보</a></div>' +
				'					<input type="hidden" id="H_IDX" value="' + paramData.list[num].H_IDX + '" >'+
				'			</div>' +
				'		</div>' +
				'	</div>' +
				'</div>';

			// 마커 위에 커스텀오버레이를 표시합니다
			overlay = new daum.maps.CustomOverlay({
			    content: content,
			    map: map,
			    position: marker[num].getPosition()
			});


			// 마커를 클릭했을 때 커스텀 오버레이를 표시합니다
			daum.maps.event.addListener(marker[num], 'click', function() {
			    overlay.setMap(map);
			});
			
			$("a[name='m_title']").on("click", function(e) {
				e.preventDefault();
				fn_openBoardDetail($(this));
			}); 
		}
		
		// 커스텀 오버레이를 닫기 위해 호출되는 함수입니다 
		function closeOverlay() {
		    overlay.setMap(null);     
		}
		
		var targ;
		function mouse(event) {
			var e = window.event;
			
			if (e.target) {
				targ = e.target;
			} else if (e.srcElement) {
				targ = e.srcElement;
			}
			if(targ.id > 0)
				map_Overlay(targ);
			
			var tname;
			tname = targ.tagName;
		}
		
		// 다음 주소찾기 API
		function execDaumPostcode() {
			new daum.Postcode({
				oncomplete : function(data) {
					var fullAddr = '';
					if (data.userSelectedType === 'R') {
						fullAddr = data.roadAddress;
					} else {
						fullAddr = data.jibunAddress;
					}
					
					document.getElementById('address').value = fullAddr;
					
					my_location(fullAddr);
				}
			}).open();
		}
		
		var Latitude = null;
		var Longitude = null;
		var coords = null;
		
		// 주소-좌표 변환 객체를 생성합니다
		function my_location(Addr) {
			var geocoder = new daum.maps.services.Geocoder();
			geocoder.addressSearch(Addr, function(result, status) {
				if (status === daum.maps.services.Status.OK) {
					coords = new daum.maps.LatLng(result[0].y, result[0].x);
					
					Latitude = result[0].y;
					Longitude = result[0].x;
					
					my_marker();
				}
			});
		}
		
		var user_marker = null;
		var markerImage = null;
		var imageSrc = 'http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';
	    var imageSize = new daum.maps.Size(24, 35);
	    
	    // 내 위치를 표현하는 이미지 마커
		function my_marker() {
			// 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
			markerImage = new daum.maps.MarkerImage(imageSrc, imageSize);
			
			if(user_marker != null)
				user_marker.setVisible(false);
			
			user_marker = new daum.maps.Marker({
				map: map,
				position: coords,
				image: markerImage // 마커이미지 설정 
			});
			
			// 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
			map.setCenter(coords);
		}
	</script>
</body>
</html>

