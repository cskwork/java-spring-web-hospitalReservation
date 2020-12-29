<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
	
	<link rel="stylesheet" type="text/css"
		href="<c:url value='/css/ui.css'/>" />
	
	<!-- 부트스트랩 CSS -->
	<link rel="stylesheet" type="text/css"
		href="<c:url value='/css/bootstrap.min.css'/>" />
	<link rel="stylesheet" type="text/css"
		href="<c:url value='https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css'/>" />
		
	<!-- 사용자 template css -->
	<link rel="stylesheet" type="text/css"
		href="<c:url value='/css/owl.carousel.css'/>" />
	<link rel="stylesheet" type="text/css"
		href="<c:url value='/css/owl.theme.default.min.css'/>" />
	<link rel="stylesheet" type="text/css"
		href="<c:url value='/css/animate.css'/>" />
	<link rel="stylesheet" type="text/css"
		href="<c:url value='/css/style.css'/>" />
	<link rel="stylesheet" type="text/css"
		href="<c:url value='/css/ui.css'/>" />
	<link rel="icon" href="<c:url value='favicon.ico'/>" />
	
	
	
	<!-- jQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	<script src="<c:url value='/js/common.js'/>" charset="utf-8"></script>
	
	<!-- 자바스크립트 부트스트 ========================================== -->
	<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script>
	<script src="<c:url value='/js/bootstrap.min.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/owl.carousel.min.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/cbpAnimatedHeader.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/jquery.appear.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/SmoothScroll.min.js'/>" charset="utf-8"></script>
	<script src="<c:url value='/js/theme-scripts.js'/>" charset="utf-8"></script>
</head>
<style>
	#dialogoverlay{
		display: none;
		opacity: .8;
		position: fixed;
		top: 0px;
		left: 0px;
		background: #FFF;
		width: 100%;
		z-index: 10;
	}
	#dialogbox{
		display: none;
		position: fixed;
		background: #000;
		border-radius:7px; 
		width:550px;
		z-index: 10;
	}
	#dialogbox > div{ background:#FFF; margin:8px; }
	#dialogbox > div > #dialogboxhead{ background: #666; font-size:19px; padding:10px; color:#CCC; }
	#dialogbox > div > #dialogboxbody{ background:#333; padding:20px; color:#FFF; }
	#dialogbox > div > #dialogboxfoot{ background: #666; padding:10px; text-align:right; }
</style>
<body id="page-top">
	<div id="dialogoverlay"></div>
	<div id="dialogbox">
	  <div>
		<div id="dialogboxhead"></div>
		<div id="dialogboxbody"></div>
		<div id="dialogboxfoot"></div>
	  </div>
	</div>
	<div class="header">
		<div>
			<div class="Logo">
				<a href="#" id="MainLogo"><img src="/hospital/img/logo2.gif" alt="로고"/></a>
			</div>
			<div class="menu">
				<ul>
					<li class="left"><a name="showMenu" id="subMenu1" href="#">병원검색</a></li>
					<li><a name="showMenu" id="subMenu2" href="#">고객지원</a></li>
					<li><a name="showMenu" id="subMenu3" href="#">사이트 이용 가이드</a></li>
				</ul>
			</div>
			
			<div class="login">
				<c:if test="${ID == null}">
					<a href="#" id="loginForm">로그인</a>
				</c:if>
				
				<c:if test="${ID != null}">
					<c:if test="${ID_IMG == 'Y' }">
						<a href="/hospital/mypage/OpenMypageMain" ><img src="/hospital/img/UserImg/${IDX }.png" style="width: 65px; height: 65px; margin: 0 30px 0 0"/></a>
					</c:if>
					
					<c:if test="${ID_IMG == 'N' }">
						${NAME }
					</c:if>
					<input type="button" id="mypageList" value="▼">
					<a href="#" id="logout">로그아웃</a>
					
					<div class="mypageList">
						<div class="mypageList2">
							<a href="#" name="mypageList" id="mypage/OpenMypageMain" 	style="grid-column: 1; grid-row: 1; border-bottom: 1px solid #a9a9a9;">내 정보</a>
							<a href="#" name="mypageList" id="reserv/MyReserv" 			style="grid-column: 1; grid-row: 2; border-bottom: 1px solid #a9a9a9;">예약 내역 보기</a>
							<a href="#" name="mypageList" id="reserv/MyPastReserv" 		style="grid-column: 1; grid-row: 3; border-bottom: 1px solid #a9a9a9;">지난 예약 내역 보기</a>
							<a href="#" name="mypageList" id="mypage/OpenMypageFavhp" 	style="grid-column: 1; grid-row: 4; border-bottom: 1px solid #a9a9a9;">관심 병원 보기</a>
							<a href="#" name="mypageList" id="rate/RatingList" 			style="grid-column: 1; grid-row: 5;"								  >후기 남기기</a>
						</div>
					</div>
				</c:if>
			</div>
		</div>
		
			
		<div class="subMenu">
			<div>
				<ul id="subMenu1">
					<li class="left"><a name="HpList" id="ALL" href="#">전체병원검색</a></li>
					<li><a name="HpList" id="ALL_REG" href="#">예약가능병원</a></li>
					<li><a name="HpList" id="RATE" href="#">평가 우수병원</a></li>
				</ul>
				
				<ul id="subMenu2">
					<li class="left"><a name="CustomService" id="notice/listform" href="#">공지사항</a></li>
					<li><a name="CustomService" id="faq/listform" href="#">자주하는 질문들</a></li>
					<li><a name="QnaService" id="qna/listform" href="#">1:1 문의내역</a></li>
					<li><a name="QnaService" id="qna/writeform" href="#">1:1 문의하기</a></li>
				</ul> 
				
				<ul id="subMenu3">
					<li class="left"><a name="GuideService" id="guide/searchGuide" href="#">병원검색 가이드</a></li>
					<li><a name="GuideService" id="guide/reservationGuide" href="#">병원예약 가이드</a></li>
					<li><a name="GuideService" id="guide/ratingGuide" href="#">만족도조사 가이드</a></li>
				</ul>
			</div>
		</div>
	</div>
	<%@ include file="/WEB-INF/include/include-body.jspf"%>

	<script type="text/javascript">
		$(document).ready(function() {
			$("#MainLogo").on("click", function(e) {
				e.preventDefault();
				moveToMainPage();
			});

			// 병원 클릭 이벤트
			$("a[name='HpList']").on("click", function(e) {
				e.preventDefault();
				moveToHpList($(this));
			});

			// 고객지원 클릭 이벤트
			$("a[name='CustomService']").on("click", function(e) {
				e.preventDefault();
				moveToCustomService($(this));
			});

			$("a[name='QnaService']").on("click", function(e) {
				e.preventDefault();
				if ($("#ID").val() == "") {
					Alert.render("로그인이 필요한 서비스입니다.");
				} else {
					moveToCustomService($(this));
				}
			});
			
			// 가이드 클릭 이벤트
			$("a[name='GuideService']").on("click", function(e) {
				e.preventDefault();
				moveToCustomService($(this));
			});

			// 서브 메뉴 마우스 오버 이벤트
			$("a[name='showMenu'").mouseenter(function() {
				$(".subMenu").css('display', 'block');
				$(".subMenu").find(".left").css('margin-left', $(this).offset().left + "px");
				
				for(var i = 1; i < 4; i++) {
					if($(this).prop("id") == ("subMenu" + i))
						$(".subMenu").find("#subMenu" + i).css('display', 'block');
					else
						$(".subMenu").find("#subMenu" + i).css('display', 'none');
				}
			});

			$(".subMenu").mouseleave(function() {
				$(".subMenu").css('display', 'none');
				$(".subMenu>ul").css('display', 'none');
			});

 			$("#loginForm").on("click", function(e) {
				e.preventDefault();
				moveTologinForm($(this));
			});

			$("#logout").on("click", function(e) {
				e.preventDefault();
				LogOut();
			});

			$("#mypageList").on("click", function(e) {
				makeToMypageList($(this));
			});

			$("a[name='mypageList']").on("click", function(e) {
				e.preventDefault();
				moveToMypageMain($(this));
			})
		});

		function moveTologinForm(obj) {
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/member/loginForm' />");

			comSubmit.submit();
		}

		function makeToMypageList(obj) {
			if (obj.val() == "▼") {
				obj.val("▲");
				obj.parent().parent().find(".mypageList").css("display", "block");
			} else {
				obj.val("▼");
				obj.parent().parent().find(".mypageList").css("display", "none");
			}
		}

		function moveToMypageMain(obj) {
			var URL = obj.attr('id');

			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/" + URL + "'/>");
			if (URL == "reserv/MyReserv")
				comSubmit.addParam("STEP", "reserv");

			comSubmit.submit();
		}

		Kakao.init('a2a026028f5ff6b1e76fd91816f13681');
		function LogOut() {
			Kakao.Auth.logout(function() {
				console.log("logged out.");
			});

			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/member/logout' />");

			comSubmit.submit();
		}

		function moveToHpList(obj) {
			var BOARD = obj.attr('id');
			var URL = "<c:url value='/hplist/List' />";
			var LIST = "selectHpList";
			var REG_CHK = 'N';
			var boardTitle;
			var QUERY;

			if (BOARD == 'ALL') {
				boardTitle = "전체 병원";
				QUERY = "hplist.selectAllHpList";
			} else if (BOARD == 'ALL_REG') {
				if($("#ID").val() == null || $("#ID").val() == "") {
					Alert.render("로그인 후 이용해주세요.");
					return false;
				} else {
					boardTitle = "예약 가능한 병원";
					QUERY = "hplist.selectAllHpList";
					REG_CHK = 'Y';
				}
			} else if (BOARD == 'RATE') {
				boardTitle = "평가 우수병원";
				QUERY = "hplist.selectRateHpList";
			}

			var comSubmit = new ComSubmit();
			comSubmit.setUrl(URL);
			comSubmit.addParam("boardTitle", boardTitle);
			comSubmit.addParam("LIST", LIST);
			comSubmit.addParam("QUERY", QUERY);
			comSubmit.addParam("REG_CHK", REG_CHK);

			comSubmit.submit();
		}

		function moveToCustomService(obj) {
			var URL = obj.attr('id');

			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/" + URL + "'/>");

			comSubmit.submit();
		}

		function moveToMainPage() {
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/main' />");

			comSubmit.submit();
		}
		
		function CustomAlert(){
			this.render = function(dialog){
              var winW = window.innerWidth;
              var winH = window.innerHeight;
              var dialogoverlay = document.getElementById('dialogoverlay');
              var dialogbox = document.getElementById('dialogbox');
              dialogoverlay.style.display = "block";
              dialogoverlay.style.height = winH+"px";
              dialogbox.style.left = (winW/2) - (550 * .5)+"px";
              dialogbox.style.top = "100px";
              dialogbox.style.display = "block";
              document.getElementById('dialogboxhead').innerHTML = "확인을 눌러주세요";
              document.getElementById('dialogboxbody').innerHTML = dialog;
              document.getElementById('dialogboxfoot').innerHTML = '<button onclick="Alert.ok()">확인</button>';
         }
         this.ok = function(){
            document.getElementById('dialogbox').style.display = "none";
            document.getElementById('dialogoverlay').style.display = "none";
         }
      }
	var Alert = new CustomAlert();
	</script>
	<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
</body>