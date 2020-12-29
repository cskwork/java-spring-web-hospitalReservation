<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/include/include-header.jspf" %>
	<style type="text/css">
	.AdminMain {
			display: grid;
			grid-template-columns: repeat(6, 1fr);
			grid-auto-rows: minmax(auto, auto);
			grid-template-areas: 
				"header header header header header header" 
				"side_menu main main main main main";
		}
		.AdminMain>.Admin_header {
			grid-area: header;
			padding: 20px 0;
			background: #f3a76b;
			color: #fff8f6;
		}
		.AdminMain>.Admin_header>a {
			text-decoration: none;
			color: #fff8f6;
			float: right;
		}
		.AdminMain>.Admin_menu {
			grid-area: side_menu;
			padding: 20px;	
			color: #f3a76b;
		}
		.AdminMain>.Admin_menu>table>tbody>tr>td>div {
			display: none;
			padding: 10px 20px;
		}
		.AdminMain>.Admin_menu>table>tbody>tr>td>div>a {
			display: block;
			color: #f3a76b;
		}
		.AdminMain>.Admin_menu>table>tbody>tr>td>.Admin_menu_subMenu {
			
		}
		
		.AdminMain>.Admin_body {
			grid-area: main;
			padding: 30px 20px;
		}
		.AdminMain>.Admin_body>#MultiModify {
			display: none;
		}
		.AdminMain>.Admin_body>h2 {
			margin-bottom: 20px;
		}
		.AdminMain>.Admin_body>table {
			padding: 10px 0;
			width: 100%;
			text-align: center;
		}
		.AdminMain>.Admin_body>table>thead>th {
			height: 40px;
		}
		
		.AdminMain>.Admin_body>table>tbody>tr>td>input {
			margin: 5px 0;
			border: none;
			width: 100%;
		}
		.AdminMain>.Admin_body>table>tbody>tr>td>img {
			width: 25px;
		}
		
		.AdminMain>.Admin_EditDetail {
			position: absolute;
			display: none;
			background-color: rgba(0,0,0,0.5);
			width: 100%;
			height: 100%;
		}
		.AdminMain>.Admin_EditDetail>form>table {
			background-color: white;
			margin: 155px auto 0;
			width: 800px;
			
			text-align: center;
		}
		.AdminMain>.Admin_EditDetail>form>table>tbody>tr {
			height: 50px;
		}
		.AdminMain>.Admin_EditDetail>form>table>tbody>tr>td>input {
			margin: 5px 0;
			border: none;
			width: 100%;
		}
		.AdminMain>.Admin_EditDetail>form>table>tbody>tr>td>textarea {
			resize: none;
			
			margin: 5px 0;
			border: none;
			width: 100%; 
			height: 100px;
		}
	</style>
</head>
<body>
	<c:if test="${ID != 'admin' }">
		<div id="header clearfix">
			<tiles:insertAttribute name="header" />
		</div>
		<c:if test="${body != 'body' }">
			<div class="visual clearfix">
		</c:if>
		
		<c:if test="${body == 'body' }">
			<div class="clearfix">
		</c:if>
		
			<tiles:insertAttribute name="${body }" />
		</div>
		
		<div class="footer clearfix">
			<tiles:insertAttribute name="footer" />
		</div>
	</c:if>
	
	<c:if test="${ID == 'admin' }">
		<div class="AdminMain">
			<div class="Admin_header">
				<h3>Dr.hur 관리자 페이지</h3>
				
				<a href="#" id="logout" >관리자 종료</a>
			</div>
			
			<div class="Admin_menu">
				<table style="width: 100%">
					<tbody>
						<tr>
							<td>
								<div><a href="#" id="1" class="Admin_menu_subMenu">회원 관리<font style="float: right;">▼</font></a></div>
								<div class="Admin_menu_subMenu1"><a href="#" name="ShowInfo" id="member/list2">- 회원 목록</a></div>
							</td>
						</tr>
							
						<tr>
							<td>
								<div><a href="#" id="2" class="Admin_menu_subMenu">병원 관리<font style="float: right;">▼</font></a></div>
								<div class="Admin_menu_subMenu2"><a href="#" name="ShowInfo" id="hplist/selectHpList">- 병원 목록</a></div>
							</td>
						</tr>
						
						<tr>
							<td>
								<div><a href="#" id="3" class="Admin_menu_subMenu">예약 관리<font style="float: right;">▼</font></a></div>
								<div class="Admin_menu_subMenu3"><a href="#" name="ShowInfo" id="reserv/AdminReservList">- 예약 목록</a></div>
							</td>
						</tr>
						
						<tr>
							<td>
								<div><a href="#" id="4" class="Admin_menu_subMenu">게시판 관리<font style="float: right;">▼</font></a></div>
								<div class="Admin_menu_subMenu4"><a href="#" name="ShowInfo" id="admin/notice/list">- 공지사항</a></div>
								<div class="Admin_menu_subMenu4"><a href="#" name="ShowInfo" id="admin/faq/list">- FAQ</a></div>
								<div class="Admin_menu_subMenu4"><a href="#" name="ShowInfo" id="admin/qna/list">- 1:1 문의내역</a></div>
								<div class="Admin_menu_subMenu4"><a href="#" name="ShowInfo" id="">- [추가]</a></div>
							</td>
						</tr>
						
						<tr>
							<td>
								<div><a href="#" id="5" class="Admin_menu_subMenu">후기 관리<font style="float: right;">▼</font></a></div>
								<div class="Admin_menu_subMenu5"><a href="#" name="ShowInfo" id="admin/rating/list">- 후기 목록</a></div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div class="Admin_body">	
				<h2>
				</h2>
				<table>
					<colgroup>
					</colgroup>
					<thead valign="top">
					</thead>
					<tbody>
					</tbody>
				</table>
				<div align="center" id="PAGE_NAVI"></div>
				
				<div align="right" id="MultiModify">
					<a href="#" id="MultiModify_btn">저장</a>
				</div>
				<input type="hidden" id="PAGE_INDEX" name="PAGE_INDEX" value="1"/>
			</div>
			
			<div class="Admin_EditDetail">
				<form>
					<table>
						<colgroup>
							<col width="10%"/>
							<col width="15%"/>
							<col width="10%"/>
							<col width="15%"/>
							<col width="10%"/>
							<col width="15%"/>
							<col width="10%"/>
							<col width="15%"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col"></th>
								<th scope="col"></th>
								<th scope="col"></th>
								<th scope="col"></th>
								<th scope="col"></th>
								<th scope="col"></th>
								<th scope="col"></th>
								<th scope="col"></th>
							</tr>
						</thead>
						<tbody>
						</tbody>					
					</table>
				</form>
			</div>
			
			<%@ include file="/WEB-INF/include/include-body.jspf" %>
		</div>
		<input type="hidden" id="ID" value="${ID }">
	</c:if>
	
	<script type="text/javascript">
		if($("#ID").val() == "admin") {
			$(document).ready(function() {
				window.onload = function() {
					$(".Admin_menu_subMenu").parent().css("display", "block");
					$(".Admin_menu_subMenu").parent().css("padding", "10px 0"); 
				};
				
				$("#logout").on("click", function(e) {
					e.preventDefault();
					var comSubmit = new ComSubmit();
					comSubmit.setUrl("<c:url value='/member/logout' />");
					
					comSubmit.submit();
				});
				
				$(".Admin_menu_subMenu").on("click", function(e) {
					subMenuShowMenu($(this));
				});
				$("a[name='ShowInfo']").on("click", function(e) {		
					Tag_toggle($(this));
					
					if(modify) {
						if(confirm("수정한 데이터를 저장하시겠습니까?") == true) {
							MultiDataModify();
							modify = false;
						}		
					}
					fn_selectList(1, $(this));
				});
				
				$("#MultiModify").css("display", "block");
				
				$("#MultiModify_btn").on("click", function() {
					Tag_toggle($(this));
					
					MultiDataModify();
				});
			});

			var modify = false;
			function subMenuShowMenu(obj) {
				if(obj.parent().parent().find(".Admin_menu_subMenu" + obj.attr("id")).css("display") == "none")
					obj.parent().parent().find(".Admin_menu_subMenu" + obj.attr("id")).css("display", "block");
				else 
					obj.parent().parent().find(".Admin_menu_subMenu" + obj.attr("id")).css("display", "none");
			}
			
			var URL;
			var pagerow = 20;
			var pageno = 0;
			
			function fn_selectList(pageNo, obj) {
				pageno = pageNo;
				
				if(obj != null)
					URL = obj.attr("id");;
				
				var comAjax = new ComAjax();
				comAjax.setUrl("<c:url value='/" + URL + "'/>");
				comAjax.setCallback("FaqList");
				comAjax.addParam("PAGE_INDEX", pageNo);
				comAjax.addParam("PAGE_ROW", pagerow);
				
				comAjax.ajax();
			}

			var paramData = null;
			
			function FaqList(data) {
				if(typeof(data) == "object") {
					paramData = data;
				}

				var total = paramData.TOTAL;
				
				if(total == 0){
					var str = "<tr><td colspan='4'>작성한 게시물이 없습니다.</td></tr>";
					
					tbody.append(str);
				} else {
					var params = {
						divId : "PAGE_NAVI",
						pageIndex : "PAGE_INDEX",
						totalCount : total,
						eventName : replaceAll(URL, '/', ''),
						recordCount : pagerow
					};
					gfn_renderPaging(params);

					focusTag1 = null;
					focusTag2 = null;
					NumArr = new Array();
					
					eval(replaceAll(URL, '/', '') + "();");
				}
			}
			
			function replaceAll(str, searchStr, replaceStr) {
			    return str.split(searchStr).join(replaceStr);
			}
			
			var focusTag1, focusTag2;
			var NumArr = new Array();
			var key;
			function focusEvent() {
				$('.focus').on("click", function() {
					Tag_toggle($(this));
				});
				
				$('.focus').on("focusout", function() {
					if(focusTag2 != focusTag1) {
						if(focusTag2.parent().parent().find("#" + focusTag2.attr("name")).val() != focusTag2.val()) {
							key = focusTag2.attr("id");			
							var colmn = focusTag2.attr("name").substring(0, focusTag2.attr("name").length - (key < 10 ? 1 : 2));	
							
							fn_switch(colmn, key);
							
							if(NumArr.indexOf(key) == -1) {
								NumArr.push(key);
							}

							modify = true;
						}
					}
				});
			}
			
			function Tag_toggle(obj) {
				focusTag1 = obj;
				
				if(focusTag2 != null) {
					focusTag2.focusout();
					focusTag1.focus();
				}
				
				focusTag2 = focusTag1;
			}
			
			function MultiDataModify() {				
				var data = new Array();
				
				// 수정된 데이터만 닮기
				$.each(NumArr, function(index, key) {
					data[index] = paramData.list[key];
				});
				
				modifyData(data, "Multi");
				modify = false;
			}
		}
	</script>
	<script src="<c:url value='/js/layoutAssist.js'/>" charset="utf-8"></script>
</body>
</body>
</html>