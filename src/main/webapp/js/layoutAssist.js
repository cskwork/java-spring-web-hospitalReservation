var h2 = $(".Admin_body>h2");
var colgroup = $(".Admin_body>table>colgroup");
var thead = $(".Admin_body>table>thead");
var tbody = $(".Admin_body>table>tbody");

function memberlist2() {
	h2.empty();
	colgroup.empty();
	thead.empty();
	tbody.empty();
	
	var str = '관리자-회원 목록';
	h2.append(str);

	str = '' +
		'<col width="20%"/>' +
		'<col width="10%"/>' +
		'<col width="10%"/>' +
		'<col width="*%"/>' +
		'<col width="12%"/>' +
		'<col width="5%"/>' +
		'<col width="5%"/>';		
	colgroup.append(str);
					
	str = '' +
		'<th scope="col">아이디</th>' +
		'<th scope="col">이름</th>' +
		'<th scope="col">암호</th>' +
		'<th scope="col">주소</th>' +
		'<th scope="col">주민등록번호</th>' +
		'<th scope="col">포인트</th>' +
		'<th scope="col">관리</th>';
	thead.append(str);

	str = "";
	var num = 0;
	var first = ($("#PAGE_INDEX").val() - 1) * pagerow;
	var last = $("#PAGE_INDEX").val() * pagerow;
	
	$.each(paramData.list, function(key, value) {
		if (first <= num && num < last) {
			str += "" +
				"<tr>" +
				"	<td align='left'>" + value.ID + "</td>" +
				"	<td><input type='text' class='focus' id='" + key + "' name='NAME" + key + "' value='" + value.NAME + "'></td>" +
				"	<td><input type='text' class='focus' id='" + key + "' name='PWD" + key + "' value='비공개'></td>" +
				"	<td><input type='text' class='focus' id='" + key + "' name='ADDR" + key + "' value='" + value.ADDR + "'></td>" +
				"	<td><input type='text' class='focus' id='" + key + "' name='JUMIN" + key + "' value='" + value.JUMIN + "'></td>" +
				"	<td><input type='text' class='focus' id='" + key + "' name='POINT" + key + "' value='" + value.POINT + "'></td>" +
				"	<td><img name='editDetail' id='" + key + "'src='/hospital/img/EditDetail.png'></td>" +
				"	<td>" +
				"		<input type='hidden' id='ID" + key + "' value='" + value.ID + "'>" +
				"		<input type='hidden' id='NAME" + key + "' value='" + value.NAME + "'>" +
				"		<input type='hidden' id='PWD" + key + "' value='비공개'>" +
				"		<input type='hidden' id='ADDR" + key + "' value='" + value.ADDR + "'>" +
				"		<input type='hidden' id='JUMIN" + key + "' value='" + value.JUMIN + "'>" +
				"		<input type='hidden' id='POINT" + key + "' value='" + value.POINT + "'>" +
				"	</td>" +
				"</tr>";
				
			++num;
		} else {
			++num;
		}
	});
	tbody.append(str);
	
	focusEvent();
	moveToModifyDetail();
}

function hplistselectHpList() {
	h2.empty();
	colgroup.empty();
	thead.empty();
	tbody.empty();
	
	var str = '관리자-병원 목록';
	h2.append(str);

	str = '' +
		'<col width="*"/>' +
		'<col width="12%"/>' +
		'<col width="10%"/>' +
		'<col width="40%"/>' +
		'<col width="*"/>' +
		'<col width="5%"/>';			
	colgroup.append(str);
					
	str = '' +
		'<th scope="col">병원명</th>' +
		'<th scope="col">전화번호</th>' +
		'<th scope="col">진료과</th>' +
		'<th scope="col">주소</th>' +
		'<th scope="col">병원소개</th>' +
		'<th scope="col">관리</th>';
	thead.append(str);

	str = "";
	var num = 0;
	var first = ($("#PAGE_INDEX").val() - 1) * pagerow;
	var last = $("#PAGE_INDEX").val() * pagerow;
	
	$.each(paramData.list, function(key, value) {
		if (first <= num && num < last) {
			str += "" +
			"<tr>" +  
			"	<td><input type='text' class='focus' id='" + key + "' name='HOSP" + key + "' value='" + value.HOSP + "'></td>" +
			"	<td><input type='text' class='focus' id='" + key + "' name='TEL" + key + "' value='" + value.TEL + "'></td>" +
			"	<td><input type='text' class='focus' id='" + key + "' name='MAJOR" + key + "' value='" + value.MAJOR + "'></td>" +
			"	<td><input type='text' class='focus' id='" + key + "' name='ADDR" + key + "' value='" + value.ADDR + "'></td>" +
			"	<td><input type='text' class='focus' id='" + key + "' name='H_COMM" + key + "' value='" + value.H_COMM + "'></td>" +
			"	<td><img name='editDetail' id='" + key + "'src='/hospital/img/EditDetail.png'></td>" +
			"	<td>" +
			"		<input type='hidden' id='H_IDX" + key + "' value='" + value.H_IDX + "'>" +
			"		<input type='hidden' id='HOSP" + key + "' value='" + value.HOSP + "'>" +
			"		<input type='hidden' id='TEL" + key + "' value='" + value.TEL + "'>" +
			"		<input type='hidden' id='MAJOR" + key + "' value='" + value.MAJOR + "'>" +
			"		<input type='hidden' id='ADDR" + key + "' value='" + value.ADDR + "'>" +
			"		<input type='hidden' id='H_COMM" + key + "' value='" + value.H_COMM + "'>" +
			"	</td>" +
			"</tr>";
				
			++num;
		} else {
			++num;
		}
	});
	tbody.append(str);
	
	focusEvent();
	moveToModifyDetail();
}

function reservAdminReservList() {
	h2.empty();
	colgroup.empty();
	thead.empty();
	tbody.empty();
	
	var str = '관리자-진료 예약 목록';
	h2.append(str);

	str = '' +
		'<col width="20%"/>' +
		'<col width="*"/>' +
		'<col width="10%"/>' +
		'<col width="10%"/>' +
		'<col width="8%"/>';		
	colgroup.append(str);
					
	str = '' +
		'<th scope="col">아이디</th>' +
		'<th scope="col">병원명</th>' +
		'<th scope="col">진료과목</th>' +
		'<th scope="col">진료날짜</th>' +
		'<th scope="col">진료시간</th>';
	thead.append(str);

	str = "";
	var num = 0;
	var first = ($("#PAGE_INDEX").val() - 1) * pagerow;
	var last = $("#PAGE_INDEX").val() * pagerow;
	
	$.each(paramData.list, function(key, value) {
		if (first <= num && num < last) {
			str += "" +
			"<tr>" +  
			"	<td align='left'>" + value.ID + "</td>" +
			"	<td><input type='text' class='focus' id='" + key + "' name='HOSP" + key + "' value='" + value.HOSP + "'></td>" +
			"	<td><input type='text' class='focus' id='" + key + "' name='CURED" + key + "' value='" + value.CURED + "'></td>" +
			"	<td><input type='text' class='focus' id='" + key + "' name='RESERV1" + key + "' value='" + value.RESERV1 + "'></td>" +
			"	<td><input type='text' class='focus' id='" + key + "' name='RESERV2" + key + "' value='" + value.RESERV2 + "'></td>" +
			"	<td>" +
			"		<input type='hidden' id='ID" + key + "' value='" + value.ID + "'>" +
			"		<input type='hidden' id='HOSP" + key + "' value='" + value.HOSP + "'>" +
			"		<input type='hidden' id='CURED" + key + "' value='" + value.CURED + "'>" +
			"		<input type='hidden' id='RESERV1" + key + "' value='" + value.RESERV1 + "'>" +
			"		<input type='hidden' id='RESERV2" + key + "' value='" + value.RESERV2 + "'>" +
			"	</td>" +
			"</tr>";
			++num;
		} else {
			++num;
		}
	});
	tbody.append(str);
	
	focusEvent();
}

function adminnoticelist() {
	h2.empty();
	colgroup.empty();
	thead.empty();
	tbody.empty();
	
	var str = '관리자-공지사항 목록';
	h2.append(str);

	str = '' +
		'<col width="8%"/>' +
		'<col width="*"/>' +
		'<col width="15%"/>' +
		'<col width="8%"/>' +
		'<col width="5%"/>';				
	colgroup.append(str);
					
	str = '' +
		'<th scope="col">조회수</th>' +
		'<th scope="col">제목</th>' +
		'<th scope="col">작성일</th>' +
		'<th scope="col">삭제여부</th>' +
		'<th scope="col">관리</th>';
	thead.append(str);

	str = "";
	var num = 0;
	var first = ($("#PAGE_INDEX").val() - 1) * pagerow;
	var last = $("#PAGE_INDEX").val() * pagerow;
	
	$.each(paramData.list, function(key, value) {
		if (first <= num && num < last) {
			str += "" +
			"<tr>" +  
			"	<td><input type='text' class='focus' id='" + key + "' name='HITS" + key + "' value='" + value.HITS + "'></td>" +
			"	<td><input type='text' class='focus' id='" + key + "' name='TITLE" + key + "' value='" + value.TITLE + "'></td>" +
			"	<td><input type='text' class='focus' id='" + key + "' name='REG" + key + "' value='" + value.REG + "'></td>" +
			"	<td><input type='checkbox' class='focus' id='" + key + "' name='DEL_CHK" + key + "' value='" + paramData.list[key].DEL_CHK + "' /></td>" +
			"	<td><img name='editDetail' id='" + key + "'src='/hospital/img/EditDetail.png'></td>" +
			"	<td>" +
			"		<input type='hidden' id='HITS" + key + "' value='" + value.HITS + "'>" +
			"		<input type='hidden' id='TITLE" + key + "' value='" + value.TITLE + "'>" +
			"		<input type='hidden' id='REG" + key + "' value='" + value.REG + "'>" +
			"		<input type='hidden' id='DEL_CHK" + key + "' value='" + value.DEL_CHK + "'>" +
			"	</td>" +
			"</tr>";
			
			++num;
		} else {
			++num;
		}
	});
	tbody.append(str);
	
	fn_checkbox("Multi");
	focusEvent();
	moveToModifyDetail();
}

function adminfaqlist() {
	h2.empty();
	colgroup.empty();
	thead.empty();
	tbody.empty();
	
	var str = '관리자 FAQ 목록';
	h2.append(str);

	str = '' +
		'<col width="20%"/>' +
		'<col width="*"/>' +
		'<col width="8%"/>' +
		'<col width="5%"/>';			
	colgroup.append(str);
					
	str = '' +
		'<th scope="col">글</th>' + 
		'<th scope="col">내용</th>' +
		'<th scope="col">삭제여부</th>' +
		'<th scope="col">관리</th>';
	thead.append(str);

	str = "";
	var num = 0;
	var first = ($("#PAGE_INDEX").val() - 1) * pagerow;
	var last = $("#PAGE_INDEX").val() * pagerow;
	
	$.each(paramData.list, function(key, value) {
		if (first <= num && num < last) {
			str += "" + 
				"<tr>" + 
				"	<td><input type='text' class='focus' id='" + key + "' name='Q" + key + "' value='" + value.Q + "'></td>" +
				"	<td><input type='text' class='focus' id='" + key + "' name='A" + key + "' value='" + value.A + "'></td>" +
				"	<td><input type='checkbox' class='focus' id='" + key + "' name='DEL_CHK" + key + "' value='" + paramData.list[key].DEL_CHK + "' /></td>" +
				"	<td><img name='editDetail' id='" + key + "'src='/hospital/img/EditDetail.png'></td>" +
				"	<td>" +
				"		<input type='hidden' id='IDX" + key + "' value='" + value.IDX + "'>" +
				"		<input type='hidden' id='Q" + key + "' value='" + value.Q + "'>" +
				"		<input type='hidden' id='A" + key + "' value='" + value.A + "'>" +
				"		<input type='hidden' id='DEL_CHK" + key + "' value='" + value.DEL_CHK + "'>" +
				"	</td>" +
				"</tr>";
					
			++num;
		} else {
			++num;
		}
	});	
	tbody.append(str);
	
	fn_checkbox("Multi");
	focusEvent();
	moveToModifyDetail();
}

function adminqnalist() {
	h2.empty();
	colgroup.empty();
	thead.empty();
	tbody.empty();
	
	var str = '관리자-1:1문의 목록';
	h2.append(str);

	str = '' +
		'<col width="20%"/>' +
		'<col width="20%"/>' +
		'<col width="*%"/>' +
		'<col width="15%"/>' +
		'<col width="8%"/>' +
		'<col width="5%"/>';
	colgroup.append(str);
					
	str = '' +
		'<th scope="col">아이디</th>' +	
		'<th scope="col">제목</th>' +	
		'<th scope="col">문의내용</th>' +	
		'<th scope="col">작성일</th>' +	
		'<th scope="col">삭제여부</th>' +	
		'<th scope="col">관리</th>';
	thead.append(str);

	str = "";
	var num = 0;
	var first = ($("#PAGE_INDEX").val() - 1) * pagerow;
	var last = $("#PAGE_INDEX").val() * pagerow;
	
	$.each(paramData.list, function(key, value) {
		if (first <= num && num < last) {
			str += "" + 
			"<tr>" + 
			"	<td align='left'>" + value.ID + "</td>" +
			"	<td><input type='text' class='focus' id='" + key + "' name='TITLE" + key + "' value='" + value.TITLE + "'></td>" +
			"	<td><input type='text' class='focus' id='" + key + "' name='CONTENT" + key + "' value='" + value.CONTENT + "'></td>" +
			"	<td><input type='text' class='focus' id='" + key + "' name='REG" + key + "' value='" + value.REG + "'></td>" +
			"	<td><input type='checkbox' class='focus' id='" + key + "' name='DEL_CHK" + key + "' value='" + paramData.list[key].DEL_CHK + "' /></td>" +
			"	<td><img name='editDetail' id='" + key + "'src='/hospital/img/EditDetail.png'></td>" +
			"	<td>" +
			"		<input type='hidden' id='IDX" + key + "' value='" + value.IDX + "'>" +
			"		<input type='hidden' id='ID" + key + "' value='" + value.ID + "'>" +
			"		<input type='hidden' id='TITLE" + key + "' value='" + value.TITLE + "'>" +
			"		<input type='hidden' id='CONTENT" + key + "' value='" + value.CONTENT + "'>" +
			"		<input type='hidden' id='REG" + key + "' value='" + value.REG + "'>" +
			"		<input type='hidden' id='DEL_CHK" + key + "' value='" + value.DEL_CHK + "'>" +
			"	</td>" +
			"</tr>";
			
			++num;
		} else {
			++num;
		}
	});
	tbody.append(str);

	fn_checkbox("Multi");
	focusEvent();
	moveToModifyDetail();
}

function adminratinglist() {
	h2.empty();
	colgroup.empty();
	thead.empty();
	tbody.empty();
	
	var str = '관리자-후기 목록';
	h2.append(str);

	str = '' +
		'<col width="20%"/>' +
		'<col width="10%"/>' +
		'<col width="*"/>' +
		'<col width="15%"/>' +
		'<col width="8%"/>' +
		'<col width="5%"/>';			
	colgroup.append(str);
					
	str = '' +
		'<th scope="col">아이디</th>' +
		'<th scope="col">의사진료 만족도</th>' +
		'<th scope="col">후기</th>' +
		'<th scope="col">작성날짜</th>' +
		'<th scope="col">삭제여부</th>' +
		'<th scope="col">관리</th>';
	thead.append(str);

	str = "";
	var num = 0;
	var first = ($("#PAGE_INDEX").val() - 1) * pagerow;
	var last = $("#PAGE_INDEX").val() * pagerow;
	
	$.each(paramData.list, function(key, value) {
		if (first <= num && num < last) {
			str += "" +
			"<tr>" + 
			"	<td align='left'>" + value.ID + "</td>" +
			"	<td>" + (value.RATE1 + value.RATE2 + value.RATE3 + value.RATE4) / 4 + "</td>" +
			"	<td><input type='text' class='focus' id='" + key + "' name='COMM" + key + "' value='" + value.COMM + "'></td>" +
			"	<td><input type='text' class='focus' id='" + key + "' name='REG" + key + "' value='" + value.REG + "'></td>" +
			"	<td><input type='checkbox' class='focus' id='" + key + "' name='DEL_CHK" + key + "' value='" + paramData.list[key].DEL_CHK + "' /></td>" +
			"	<td><img name='editDetail' id='" + key + "'src='/hospital/img/EditDetail.png'></td>" +
			"	<td>" +
			"		<input type='hidden' id='IDX" + key + "' value='" + value.IDX + "'>" +
			"		<input type='hidden' id='ID" + key + "' value='" + value.ID + "'>" +
			"		<input type='hidden' id='COMM" + key + "' value='" + value.COMM + "'>" +
			"		<input type='hidden' id='REG" + key + "' value='" + value.REG + "'>" +
			"		<input type='hidden' id='DEL_CHK" + key + "' value='" + value.DEL_CHK + "'>" +
			"	</td>" +
			"</tr>";
			
			++num;
		} else {
			++num;
		}
	});
	tbody.append(str);

	fn_checkbox("Multi");
	focusEvent();
	moveToModifyDetail();
}

function moveToModifyDetail() {
	$("img[name='editDetail']").on("click", function() {
		key = $(this).attr("id");	
		
		eval(replaceAll(URL, '/', '') + "2();");
		
		$(".Admin_EditDetail").css("display", "block");
	});
}

function fn_switch(colmn, key) {
	if (colmn == "ID")
		paramData.list[key].ID = focusTag2.val();
	else if (colmn == "NAME")
		paramData.list[key].NAME = focusTag2.val();
	else if (colmn == "PWD")
		paramData.list[key].PWD = focusTag2.val();		
	else if (colmn == "ADDR")
		paramData.list[key].ADDR = focusTag2.val();		
	else if (colmn == "JUMIN")
		paramData.list[key].JUMIN = focusTag2.val();		
	else if (colmn == "POINT")
		paramData.list[key].POINT = focusTag2.val();		
	else if (colmn == "HOSP")
		paramData.list[key].HOSP = focusTag2.val();		
	else if (colmn == "TEL")
		paramData.list[key].TEL = focusTag2.val();		
	else if (colmn == "MAJOR")
		paramData.list[key].MAJOR = focusTag2.val();		
	else if (colmn == "H_COMM")
		paramData.list[key].H_COMM = focusTag2.val();		
	else if (colmn == "DEL_CHK")
		paramData.list[key].DEL_CHK = focusTag2.val();		
	else if (colmn == "RESERV1")
		paramData.list[key].RESERV1 = focusTag2.val();		
	else if (colmn == "RESERV2")
		paramData.list[key].RESERV2 = focusTag2.val();		
	else if (colmn == "HITS")
		paramData.list[key].HITS = focusTag2.val();		
	else if (colmn == "TITLE")
		paramData.list[key].TITLE = focusTag2.val();		
	else if (colmn == "HITS")
		paramData.list[key].HITS = focusTag2.val();		
	else if (colmn == "REG")
		paramData.list[key].REG = focusTag2.val();		
	else if (colmn == "Q")
		paramData.list[key].Q = focusTag2.val();		
	else if (colmn == "A")
		paramData.list[key].A = focusTag2.val();		
	else if (colmn == "CONTENT")
		paramData.list[key].CONTENT = focusTag2.val();		
	else if (colmn == "CHK")
		paramData.list[key].CHK = focusTag2.val();		
	else if (colmn == "COMM")
		paramData.list[key].COMM = focusTag2.val();		
	else
		alert("에러: " + colmn);
}


var tbody2 = $(".Admin_EditDetail>form>table>tbody");
var baseStr = "" +
'<tr valign="top" style="height: 30px;">' +
'	<td align="right" colspan="8">' +
'		<img name="close" src="/hospital/img/close.jpg" width="25px">' +
'	</td>' +
'</tr>';
function memberlist22() {
	tbody2.empty();
	
	var str = baseStr + 
	'	<td>IDX</td>' +
	'	<td>'+ paramData.list[key].IDX + '</td>' +
	'	<td>아이디</td>' +
	'	<td>' + paramData.list[key].ID + '</td>' +
	'	<td>비밀번호</td>' +
	'	<td><input type="text" name="PWD" value="비공개"></td>' +
	'	<td>포인트</td>' +
	'	<td><input type="text" name="POINT" value="' + paramData.list[key].POINT + '"></td>' +
	'</tr>'+ 
	'<tr>' +
	'	<td colspan="2">프로필 이미지</td>' +
	'	<td>이름</td>' +
	'	<td><input type="text" name="NAME" value="' + paramData.list[key].NAME + '"></td>' +
	'	<td>주민번호 앞자리</td>' +
	'	<td><input type="text" name="JUMIN" value="' + paramData.list[key].JUMIN + '"></td>' +
	'	<td>성별</td>' +
	'	<td><input type="text" name="GENDER" value="' + paramData.list[key].GENDER + '"></td>' +
	'</tr>'+ 
	'<tr>' +
	'	<td colspan="2" rowspan="2">' + paramData.list[key].IMG + '</td>' +
	'	<td>주소</td>' +
	'	<td colspan="5"><input type="text" name="ADDR" value="' + paramData.list[key].ADDR + '"></td>' +
	'</tr>'+ 
	'<tr>' +
	'	<td>삭제여부</td>' +
	'	<td><input type="checkbox" name="DEL_CHK" value="' + paramData.list[key].DEL_CHK + '" /></td>' +
	'	<td colspan="4"></td>' +
	'	<td colspan="2"><input type="button" id="submit" value="수정"></td>' +
	'</tr>';

	tbody2.append(str);

	fn_checkbox("Detail");
	fn_detailSubmit();
}

function hplistselectHpList2() {
	tbody2.empty();
	
	var str = baseStr + 
	'<tr>' +
	'	<td>H_IDX</td>' +
	'	<td>'+ paramData.list[key].H_IDX + '</td>' +
	'	<td>병원명</td>' +
	'	<td colspan="5"><input type="text" name="HOSP" value="' + paramData.list[key].HOSP + '"</td>' +
	'</tr>'+ 
	'<tr>' +
	'	<td>진료과</td>' +
	'	<td><input type="text" name="MAJOR" value="' + paramData.list[key].MAJOR + '"></td>' +
	'	<td>전화번호</td>' +
	'	<td><input type="text" name="TEL" value="' + paramData.list[key].TEL + '"></td>' +
	'	<td>진료예약 가능여부</td>' +
	'	<td><input type="text" name="REG_CHK" value="' + paramData.list[key].REG_CHK + '"></td>' +
	'</tr>'+ 
	'<tr>' +
	'	<td>주소</td>' +
	'	<td colspan="7"><input type="text" name="ADDR" value="' + paramData.list[key].ADDR + '"></td>' +
	'</tr>'+ 
	'<tr>' +
	'	<td>개원시간</td>' +
	'	<td><input type="text" name="ONHOUR" value="' + paramData.list[key].ONHOUR + '"></td>' +
	'	<td>마감시간</td>' +
	'	<td><input type="text" name="OFFHOUR" value="' + paramData.list[key].OFFHOUR + '"></td>' +
	'	<td>진료소요 시간</td>' +
	'	<td><input type="text" name="INTERVALL" value="' + paramData.list[key].INTERVALL + '"></td>' +
	'</tr>'+
	'<tr style="height: 100px; vertical-align: top;">' +
	'	<td>병원소개</td>' +
	'	<td colspan="7"><textarea name="H_COMM">' + paramData.list[key].H_COMM + '</textarea></td>' +
	'</tr>' + 
	'<tr style="height: 100px; vertical-align: top;">' +
	'	<td>의사소개</td>' +
	'	<td colspan="7"><textarea name="DOC_COMM">' + paramData.list[key].DOC_COMM + '</textarea></td>' +
	'</tr>' + 
	'<tr>' +
	'	<td>삭제여부</td>' +
	'	<td><input type="checkbox" name="DEL_CHK" value="' + paramData.list[key].DEL_CHK + '" /></td>' +
	'	<td colspan="4"></td>' +
	'	<td colspan="2"><input type="button" id="submit" value="수정"></td>' +
	'</tr>';

	tbody2.append(str);

	fn_checkbox("Detail");
	fn_detailSubmit();
}

function adminnoticelist2() {
	tbody2.empty();
	
	var str = baseStr + 
	'<tr>' +
	'	<td>IDX</td>' +
	'	<td>'+ paramData.list[key].IDX + '</td>' +
	'	<td>조회수</td>' +
	'	<td COLSPAN="2"><input type="text" name="HITS" value="' + paramData.list[key].HITS + '"></td>' +
	'	<td>등록날짜</td>' +
	'	<td colspan="2"><input type="text" name="REG" value="' + paramData.list[key].REG + '"</td>' +
	'</tr>' + 
	'<tr>' +
	'	<td>제목</td>' +
	'	<td colspan="7"><input type="text" name="TITLE" value="' + paramData.list[key].TITLE + '"</td>' +
	'</tr>' + 
	'<tr style="height: 100px; vertical-align: top;">' +
	'	<td>글 내용</td>' +
	'	<td colspan="7"><input type="text" name="CONTENT" value="' + paramData.list[key].CONTENT + '"></td>' +
	'</tr>' + 
	'<tr>' +
	'	<td>삭제여부</td>' +
	'	<td><input type="checkbox" name="DEL_CHK" value="' + paramData.list[key].DEL_CHK + '" /></td>' +
	'	<td colspan="4"></td>' +
	'	<td colspan="2"><input type="button" id="submit" value="수정"></td>' +
	'</tr>';

	tbody2.append(str);

	fn_checkbox("Detail");
	fn_detailSubmit();
}

function adminfaqlist2() {
	tbody2.empty();
	
	var str = baseStr + 
	'<tr>' +
	'	<td>IDX</td>' +
	'	<td>'+ paramData.list[key].IDX + '</td>' +
	'</tr>' + 
	'<tr style="height: 100px; vertical-align: top;">' +
	'	<td>Q</td>' +
	'	<td colspan="7"><textarea name="Q">' + paramData.list[key].Q + '</textarea></td>' +
	'</tr>' + 
	'<tr style="height: 100px; vertical-align: top;">' +
	'	<td>A</td>' +
	'	<td colspan="7"><textarea name="A">' + paramData.list[key].A + '</textarea></td>' +
	'</tr>' + 
	'<tr>' +
	'	<td>삭제여부</td>' +
	'	<td><input type="checkbox" name="DEL_CHK" value="' + paramData.list[key].DEL_CHK + '" /></td>' +
	'	<td colspan="4"></td>' +
	'	<td colspan="2"><input type="button" id="submit" value="수정"></td>' +
	'</tr>';

	tbody2.append(str);

	fn_checkbox("Detail");
	fn_detailSubmit();
}

function adminqnalist2() {
	tbody2.empty();
	
	var str = baseStr + 
	'<tr>' +
	'	<td>IDX</td>' +
	'	<td>'+ paramData.list[key].IDX + '</td>' +
	'	<td>ID</td>' +
	'	<td>'+ paramData.list[key].ID + '</td>' +
	'</tr>' + 
	'<tr>' +
	'	<td>제목</td>' +
	'	<td colspan="3"><input type="text" name="TITLE" value="' + paramData.list[key].TITLE + '"</td>' +
	'	<td></td>' +
	'	<td>등록날짜</td>' +
	'	<td colspan="2"><input type="text" name="REG" value="' + paramData.list[key].REG + '"</td>' +
	'</tr>' + 
	'<tr style="height: 100px; vertical-align: top;">' +
	'	<td>A</td>' +
	'	<td colspan="7"><textarea name="CONTENT">' + paramData.list[key].CONTENT + '</textarea></td>' +
	'</tr>' + 
	'<tr>' +
	'	<td>삭제여부</td>' +
	'	<td><input type="checkbox" name="DEL_CHK" value="' + paramData.list[key].DEL_CHK + '" /></td>' +
	'	<td colspan="4"></td>' +
	'	<td colspan="2"><input type="button" id="submit" value="수정"></td>' +
	'</tr>';

	tbody2.append(str);

	fn_checkbox("Detail");
	fn_detailSubmit();
}

function adminratinglist2() {
	tbody2.empty();
	
	var str = baseStr + 
	'<tr>' +
	'	<td>IDX</td>' +
	'	<td>'+ paramData.list[key].IDX + '</td>' +
	'	<td>ID</td>' +
	'	<td>'+ paramData.list[key].ID + '</td>' +
	'	<td></td>' +
	'	<td>등록날짜</td>' +
	'	<td colspan="2"><input type="text" name="REG" value="' + paramData.list[key].REG + '"</td>' +
	'</tr>' + 
	'<tr>' +
	'	<td colspan="2">진료 만족도</td>' +
	'	<td><input type="text" name="RATE1" value="' + paramData.list[key].RATE1 + '"</td>' +
	'	<td></td>' +
	'	<td colspan="2">간호사 친절도</td>' +
	'	<td><input type="text" name="RATE2" value="' + paramData.list[key].RATE2 + '"</td>' +
	'</tr>' + 
	'<tr>' +
	'	<td colspan="2">청결도</td>' +
	'	<td><input type="text" name="RATE3" value="' + paramData.list[key].RATE3 + '"</td>' +
	'	<td></td>' +
	'	<td colspan="2">대기시간 만족도</td>' +
	'	<td><input type="text" name="RATE4" value="' + paramData.list[key].RATE4 + '"</td>' +
	'</tr>' + 
	'<tr style="height: 100px; vertical-align: top;">' +
	'	<td>A</td>' +
	'	<td colspan="7"><textarea name="COMM">' + paramData.list[key].COMM + '</textarea></td>' +
	'</tr>' + 
	'<tr>' +
	'	<td>삭제여부</td>' +
	'	<td><input type="checkbox" name="DEL_CHK" value="' + paramData.list[key].DEL_CHK + '" /></td>' +
	'	<td colspan="4"></td>' +
	'	<td colspan="2"><input type="button" id="submit" value="수정"></td>' +
	'</tr>';

	tbody2.append(str);

	fn_checkbox("Detail");
	fn_detailSubmit();
}

function fn_detailSubmit() {
	$('img[name="close"]').on("click", function() {
		$(".Admin_EditDetail").css("display", "none");
	});
	
	$("#submit").on("click", function() {
		changeData();
		
		var formData = new Array(paramData.list[key]);
		modifyData(formData, "Detail");
	});
}

function fn_checkbox(modifyType) {
	if (modifyType == "Multi") {
		var num = 0;
		var first = ($("#PAGE_INDEX").val() - 1) * pagerow;
		var last = $("#PAGE_INDEX").val() * pagerow;
		$.each(paramData.list, function(key, value) {
			if (first <= num && num < last) {
				if (value.DEL_CHK == 0)
					$("input[name='DEL_CHK" + key + "']").prop("checked", false);
				else
					$("input[name='DEL_CHK" + key + "']").prop("checked", true);
			}
		});
	} else if (modifyType == "Detail") {
		if (paramData.list[key].DEL_CHK == 0)
			$("input[name='DEL_CHK']").prop("checked", false);
		else
			$("input[name='DEL_CHK']").prop("checked", true);
	}
	
	
	$('input[type="checkbox"]').on("click", function() {
		if ($(this).is(":checked"))
			$(this).val(1);
		else 
			$(this).val(0);
	});
}
function modifyData(data, SYSTEM) {
	var dataParam = {list:JSON.stringify(data), URL:URL, SYSTEM:SYSTEM};

	// 입력값 전송
	$.ajax({
    	url: '/hospital/admin/AdminMultiModify',
    	type : 'POST',  
    	dataType : 'json',
    	data: dataParam,
    	success : function() {
    		alert("수정 완료");
    		$(".Admin_EditDetail").css("display", "none");
    		fn_selectList($("#PAGE_INDEX").val(), null);
		}
    });
	
}

function changeData() {
	paramData.list[key].POINT = $("input[name='POINT']").val();
	paramData.list[key].NAME = $("input[name='NAME']").val();
	paramData.list[key].JUMIN = $("input[name='JUMIN']").val();
	paramData.list[key].GENDER = $("input[name='GENDER']").val();
	paramData.list[key].IMG = $("input[name='IMG']").val();
	paramData.list[key].ADDR = $("input[name='ADDR']").val();
	paramData.list[key].DEL_CHK = $("input[name='DEL_CHK']").val();
	paramData.list[key].HOSP = $("input[name='HOSP']").val();
	paramData.list[key].MAJOR = $("input[name='MAJOR']").val();
	paramData.list[key].TEL = $("input[name='TEL']").val();
	paramData.list[key].REG_CHK = $("input[name='REG_CHK']").val();
	paramData.list[key].ONHOUR = $("input[name='ONHOUR']").val();
	paramData.list[key].OFFHOUR = $("input[name='OFFHOUR']").val();
	paramData.list[key].INTERVALL = $("input[name='INTERVALL']").val();
	paramData.list[key].H_COMM = $("input[name='H_COMM']").val();
	paramData.list[key].DOC_COMM = $("input[name='DOC_COMM']").val();
	paramData.list[key].CURED = $("input[name='CURED']").val();
	paramData.list[key].RESERV1 = $("input[name='RESERV1']").val();
	paramData.list[key].RESERV2 = $("input[name='RESERV2']").val();
	paramData.list[key].TITLE = $("input[name='TITLE']").val();
	paramData.list[key].REG = $("input[name='REG']").val();
	paramData.list[key].HITS = $("input[name='HITS']").val();
	paramData.list[key].CONTENT = $("input[name='CONTENT']").val();
	paramData.list[key].CONTENT = $("textarea[name='CONTENT']").val();
	paramData.list[key].Q = $("textarea[name='Q']").val();
	paramData.list[key].A = $("textarea[name='A']").val();
	paramData.list[key].RATE1 = $("input[name='RATE1']").val();
	paramData.list[key].RATE2 = $("input[name='RATE2']").val();
	paramData.list[key].RATE3 = $("input[name='RATE3']").val();
	paramData.list[key].RATE4 = $("input[name='RATE4']").val();	
	paramData.list[key].COMM = $("textarea[name='COMM']").val();
}