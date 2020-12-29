<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>홈페이지</title>
<script>
		function NoticeList() {
			location.href="/hospital/notice/listform";
		}
		function FAQList() {
			location.href="/hospital/faq/listform";
		}
		function QNAList() {
			location.href="/hospital/qna/listform";
		}
		function adminNoticeList() {
			location.href="/hospital/admin/notice/listform";
		}
		function adminFAQList() {
			location.href="/hospital/admin/faq/listform";
		}
		function adminQNAList() {
			location.href="/hospital/admin/qna/listform";
		}
		function adminRatingList() {
			location.href="/hospital/admin/rating/listform";
		}
</script>
</head>
<body>
	사용자 게시판<br>
	<input type="button" value="공지사항" onclick="NoticeList()"/>
	<input type="button" value="FAQ" onclick="FAQList()"/>
	<input type="button" value="QNA" onclick="QNAList()"/>
	<br><br>
	관리자 게시판<br>
	<input type="button" value="- 공지사항" onclick="adminNoticeList()"/>
	<input type="button" value="- FAQ" onclick="adminFAQList()"/>
	<input type="button" value="- QNA" onclick="adminQNAList()"/>
	<br><br>
	<input type="button" value="- 진료후기" onclick="adminRatingList()"/>
</body>
</html>