<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<main class="RateWrite care-panel">
<a href="/hospital/rate/RatingList/">← 방문 후기 목록</a>
<p class="care-eyebrow">방문 경험 나누기</p>
<h1>진료는 어떠셨나요?</h1>
<p>네 가지 항목을 1점(아쉬움)부터 5점(만족)까지 선택해주세요.</p>
<p>진료일 <strong>${RESERV1}</strong></p>
<form id="ratingForm">
<input type="hidden" id="NUM" value="${NUM}">
<input type="hidden" id="ID" value="${ID}">
<input type="hidden" id="H_IDX" value="${H_IDX}">
<input type="hidden" id="RESERV1" value="${RESERV1}">
<fieldset class="rating-field"><legend>1. 의사진료 만족도</legend><div><label><input type="radio" name="rate1" value="1" required><span>1점</span></label><label><input type="radio" name="rate1" value="2" required><span>2점</span></label><label><input type="radio" name="rate1" value="3" required><span>3점</span></label><label><input type="radio" name="rate1" value="4" required><span>4점</span></label><label><input type="radio" name="rate1" value="5" required><span>5점</span></label></div></fieldset>
<fieldset class="rating-field"><legend>2. 간호사 친절성</legend><div><label><input type="radio" name="rate2" value="1" required><span>1점</span></label><label><input type="radio" name="rate2" value="2" required><span>2점</span></label><label><input type="radio" name="rate2" value="3" required><span>3점</span></label><label><input type="radio" name="rate2" value="4" required><span>4점</span></label><label><input type="radio" name="rate2" value="5" required><span>5점</span></label></div></fieldset>
<fieldset class="rating-field"><legend>3. 청결성</legend><div><label><input type="radio" name="rate3" value="1" required><span>1점</span></label><label><input type="radio" name="rate3" value="2" required><span>2점</span></label><label><input type="radio" name="rate3" value="3" required><span>3점</span></label><label><input type="radio" name="rate3" value="4" required><span>4점</span></label><label><input type="radio" name="rate3" value="5" required><span>5점</span></label></div></fieldset>
<fieldset class="rating-field"><legend>4. 대기시간 만족도</legend><div><label><input type="radio" name="rate4" value="1" required><span>1점</span></label><label><input type="radio" name="rate4" value="2" required><span>2점</span></label><label><input type="radio" name="rate4" value="3" required><span>3점</span></label><label><input type="radio" name="rate4" value="4" required><span>4점</span></label><label><input type="radio" name="rate4" value="5" required><span>5점</span></label></div></fieldset>
<label for="COMM">방문 후기 <small>필수 · 최대 500자</small></label>
<textarea id="COMM" name="COMM" maxlength="500" rows="5" required placeholder="방문 경험을 남겨주세요. 개인정보와 건강정보는 입력하지 마세요."></textarea>
<p id="rateError" role="alert"></p>
<button id="rate" type="submit">후기 저장하기</button>
</form>
</main>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
<script>
$(function () { $('#ratingForm').on('submit', function (e) { e.preventDefault(); fn_Rating(); }); });
function fn_Rating() {
  if ($('#rate').prop('disabled')) return;
  var valid = true;
  for (var j = 1; j < 5; j++) {
    var value = $('input[name=rate' + j + ']:checked').val();
    if (!value) valid = false;
  }
  var comment = $.trim($('#COMM').val());
  if (!valid || !comment || comment.length > 500) { $('#rateError').text('네 가지 평가와 1~500자 후기를 모두 작성해주세요.'); return; }
  var comSubmit = new ComSubmit();
  comSubmit.setUrl("<c:url value='/rate/Rating'/>");
  for (var rating = 1; rating < 5; rating++) comSubmit.addParam('RATE' + rating, $('input[name=rate' + rating + ']:checked').val());
  ['NUM','ID','H_IDX','RESERV1'].forEach(function (key) { comSubmit.addParam(key, $('#' + key).val()); });
  comSubmit.addParam('COMM', comment);
  $('#rateError').text(''); $('#rate').prop('disabled', true).text('저장 중…');
  try { if (comSubmit.submit() === false) $('#rate').prop('disabled', false).text('후기 저장하기'); }
  catch (error) { $('#rateError').text('저장하지 못했습니다. 다시 시도해주세요.'); $('#rate').prop('disabled', false).text('후기 저장하기'); }
}
</script>
