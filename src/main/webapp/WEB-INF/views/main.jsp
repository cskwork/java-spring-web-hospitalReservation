<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>병원 예약제 사이트</title>
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
<body>
	<div id="dialogoverlay"></div>
	<div id="dialogbox">
	  <div>
		<div id="dialogboxhead"></div>
		<div id="dialogboxbody"></div>
		<div id="dialogboxfoot"></div>
	  </div>
	</div>
	<div class="container-fluid">
		<div class="slider-container" style="width: 100%; height: 740px">
			<div class="owl-slider owl-carousel">
				<div class="item">
					<div class="owl-slider-item" style="height:740px; width:2000px;">
						<img src="/hospital/img/mainImg/slider-1.jpg"style="width: 100%; height: 740px" class="img-responsive" alt="portfolio">
					</div>
				</div>
				<div class="item">
					<div class="owl-slider-item" style="height:740px; width:2000px;">
						<img src="/hospital/img/mainImg/slider-2.jpg"style="width: 100%; height: 740px" style="height:740px; width:2000px;" class="img-responsive" alt="portfolio">
					</div>
				</div>
				<div class="item">
					<div class="owl-slider-item" style="height:740px; width:2000px;">
						<img src="/hospital/img/mainImg/slider-3.jpg" style="width: 100%; height: 740px"class="img-responsive" alt="portfolio">
					</div>
				</div>
				<div class="item">
					<div class="owl-slider-item" style="height:740px; width:2000px;">
						<img src="/hospital/img/mainImg/slider-4.jpg"style="width: 100%; height: 740px" class="img-responsive" alt="portfolio">
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 예약 버튼 -->
	<section class="section-cta ">	
		<div class="container ">
			<div class="row">
				<div class="col-md-8">
					<h2>병원 예약하기</h2>
				</div>
				<div class="col-md-4">
					<a href="#" name="HpList" id="ALL_REG" class="button-cta">예약</a>
				</div>
			</div>
		</div>
	</section>
	
	<!-- 병원 소개 -->
	<section id="about" class="light-bg">
		<div class="container">
			<div class="row">
				<div class="col-lg-12 text-center">
					<div class="section-title">
						<h2>사이트 소개</h2>
						<p><strong>전국 병원 검색 및 예약, Dr.Her 입니다.</strong><br>병원 통합 예약 사이트</p>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-3 text-center">
					<div class="mz-module">
						<div class="mz-module-about">
							<i class="fa fa-briefcase color1 ot-circle"></i>
							<h3>병원 검색</h3>
						</div>
						
						<a href="#" name="HpList" id="ALL" class="mz-module-button">이동하기</a>
					</div>
				</div>
				<div class="col-md-3 text-center">
					<div class="mz-module">
						<div class="mz-module-about">
							<i class="fa fa-photo color2 ot-circle"></i>
							<h3>관심병원</h3>
						</div>
						
						<a href="#" id="fav" class="mz-module-button">이동하기</a>
					</div>
				</div>
				<div class="col-md-3 text-center">
					<div class="mz-module">
						<div class="mz-module-about">
							<i class="fa fa-camera-retro color3 ot-circle"></i>
							<h3>나의 예약현황</h3>
						</div>
						
						<a href="#" id="reserv" class="mz-module-button">이동하기</a>
					</div>
				</div>
				<div class="col-md-3 text-center">
					<div class="mz-module">
						<div class="mz-module-about">
							<i class="fa fa-cube color4 ot-circle"></i>
							<h3>1:1 문의</h3>
						</div>
						
						<a href="#" id="qna" class="mz-module-button">이동하기</a>
					</div>
				</div>
			</div>
		</div>
	</section>
	
	<!-- 병원 후기 -->
	<section id="portfolio" class="light-bg">
		<div class="container">
			<div class="row">
				<div class="col-lg-12 text-center">
					<div class="section-title">
						<h2>병원 후기</h2>
						<p>사이트를 이용하여 최근에 병원을 방문했던 사람들의 후기입니다.</p>
					</div>
				</div>
			</div>
			
			<div class="row row-0-gutter">
				<c:if test="${fn:length(reviewlist) > 0}">
					<c:forEach items="${reviewlist }" var="rl">
						<div class="col-md-4 col-0-gutter">
							<div class="ot-portfolio-item">
								<figure class="effect-bubba">
									<img src="/hospital/img/mainImg/portfolio-${rl.RN}.jpg" alt="img02" class="img-responsive" />
									<figcaption>
										<h2>이름: ${rl.NAME } / 평점: ${rl.RATE }</h2>
										<p>${rl.HOSP }<br><br>${rl.COMM }<br><br>${rl.REG }</p>
										<a href="#" data-toggle="modal" data-target="#Modal-${rl.RN }">View more</a>
									</figcaption>
								</figure>
							</div>
						</div>
					</c:forEach>
				</c:if>
			</div>
		</div>
	</section>
	
	<!-- 이용 데이터 -->
	<section class="dark-bg short-section stats-bar">
		<div class="container text-center">
			<div class="row">
				<div class="col-md-3 mb-sm-30">
					<div class="counter-item">
						<h2 class="stat-number" data-n="${list[0].HPCOUNT }">0</h2>
						<h6>등록된 병원</h6>
					</div>
				</div>
				<div class="col-md-3 mb-sm-30">
					<div class="counter-item">
						<h2 class="stat-number" data-n="${list[1].RATECOUNT1 }">0</h2>
						<h6>만족한 고객</h6>
					</div>
				</div>
				<div class="col-md-3 mb-sm-30">
					<div class="counter-item">
						<h2 class="stat-number" data-n="${list[2].RATECOUNT2 }">0</h2>
						<h6>후기 </h6>
					</div>
				</div>
				<div class="col-md-3 mb-sm-30">
					<div class="counter-item">
						<h2 class="stat-number" data-n="${list[3].MEMBERCOUNT }">0</h2>
						<h6>회원 수</h6>
					</div>
				</div>
			</div>
		</div>
	</section>
	
	<!-- 사이트 이용 가이드 -->
	<section id="partners">
		<div class="container">
			<div class="row">
				<div class="col-lg-12 text-center">
					<div class="section-title">
						<h2>사이트 이용 방법</h2>
						<p>가이드</p>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-lg-12 text-center">
					<div class="owl-partners owl-carousel">
						<c:forEach var="var" begin="1" end="14" step="1" varStatus="stat">
							<div class="item">
								<div class="partner-logo">
									<c:if test="${stat.count<=5}">
										병원 검색 가이드 (${stat.count}/5)
									</c:if>
									<c:choose>
										<c:when test="${stat.count>5 && stat.count<=9}">
											병원 예약 가이드 (${stat.count - 5}/4)
										</c:when>
										<c:when test="${stat.count>9 && stat.count<=14}">
											만족도 조사 가이드 (${stat.count - 9}/5)
										</c:when>
									</c:choose>
									<img src="/hospital/img/mainImg/partners-${stat.current}.jpg" alt="partners">
								</div>
							</div>
						</c:forEach>
					</div>
				</div>
			</div>
		</div>
	</section>
	
	<!-- 병원 후기 이미지 클릭시 -->
	<c:if test="${fn:length(reviewlist) > 0}">
		<c:forEach items="${reviewlist }" var="rl">
			<div class="modal fade" id="Modal-${rl.RN }" tabindex="-1" role="dialog" aria-labelledby="Modal-label-${rl.RN }">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title" id="Modal-label-${rl.RN }">${rl.NAME }</h4>
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						</div>
						<div class="modal-body">
							<p>${rl.HOSP }</p>
							<p>${rl.COMM }</p>
							<div class="modal-works"><span>평점: ${rl.RATE }</span></div>
							<br>
							<p>${rl.REG }</p>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						</div>
					</div>
				</div>
			</div>
		</c:forEach>
	</c:if>
	
	<script>
		$(document).ready(function() { //병원 클릭 이벤트
			window.onload = function() {
	            $(".container-fluid").parent().attr("class", "clearfix")
	            
	            $('.stats-bar').appear();
	            $('.stats-bar').on('appear', function() {
	               $(".stat-number").each(function (i, el) {
	                  var data = parseInt(this.dataset.n, 10);
	                  var props = {
	                     "from": {
	                        "count": 0
	                     },
	                     "to": {
	                        "count": data
	                     }
	                  };
	                  $(props.from).animate(props.to, {
	                     duration: 1000 * 1,
	                     step: function (now, fx) {
	                        $(el).text(Math.ceil(now));
	                     },
	                     complete:function() {
	                        if (el.dataset.sym !== undefined) {
	                           el.textContent = el.textContent.concat(el.dataset.sym);
	                        }
	                     }
	                  });
	               });
	               
	               $(window).on("scroll", function() {
	                  if ($(this).scrollTop() > 90) {
	                     $(this).off("scroll");
	                  }               
	               });
	            });
			};
		
			$("a[name='HpList']").on("click", function(e) {
				e.preventDefault();
				moveToHpList($(this));
			});
			
			$("#fav").on("click", function(e) { //관심 병원
				e.preventDefault();
				if($("#ID").val() == "") {
					Alert.render("로그인이 필요한 서비스입니다.");
				} else {
					fn_favList();
				}
			});
			
			$("#reserv").on("click", function(e) { //예약 확인
				e.preventDefault();
				if($("#ID").val() == "") {
					Alert.render("로그인이 필요한 서비스입니다.");
				} else {
					fn_reservList();
				}
			});
			
			$("#qna").on("click", function(e) { //1:1 문의
				e.preventDefault();
				if($("#ID").val() == "") {
					Alert.render("로그인이 필요한 서비스입니다.");
				} else {
					fn_qnaWrite();
				}
			});
			
			var owl = $('.owl-carousel');
			owl.owlCarousel({
				items:1,
				loop:true,
				margin:10,
				autoplay:true,
				autoplayTimeout:1500,
				autoplayHoverPause:false
			});
		});
		
		function moveToHpList(obj) {
			var BOARD = obj.attr('id');
			var URL = "<c:url value='/hplist/List' />";
			var LIST = "selectHpList";
			var QUERY = "hplist.selectAllHpList";
			var boardTitle;
			var REG_CHK;
			
			if(BOARD == 'ALL') {	
				boardTitle = "전체 병원 검색";
				REG_CHK = 'N';
			} else if (BOARD == 'ALL_REG') {
				boardTitle = "예약 가능한 병원 검색";
				REG_CHK = 'Y';
			}
			
			var comSubmit = new ComSubmit();
			comSubmit.setUrl(URL);
			comSubmit.addParam("boardTitle", boardTitle);
			comSubmit.addParam("LIST", LIST);
			comSubmit.addParam("QUERY", QUERY);
			comSubmit.addParam("REG_CHK", REG_CHK);
	
			comSubmit.submit();
		}
		
		function fn_favList() {
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/mypage/OpenMypageFavhp' />");
			comSubmit.submit();
		}
		
		function fn_reservList() {
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/reserv/MyReserv' />");
			comSubmit.addParam("STEP", "reserv");
			comSubmit.submit();
		}
		
		function fn_qnaWrite() {
			var comSubmit = new ComSubmit();
			comSubmit.setUrl("<c:url value='/qna/writeform' />");
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
</body>
</html>