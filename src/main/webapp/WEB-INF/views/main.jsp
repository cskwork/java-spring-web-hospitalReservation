<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jspf" %>
<main class="care-home">
  <section class="care-hero">
    <div>

      <h1>필요한 진료를 찾고,<br>방문할 시간을 고르세요.</h1>
      <p>병원 정보와 진료시간을 비교하고 예약 내역까지 한곳에서 확인하세요.</p>
      <form id="careSearch" class="care-search">
        <label for="careQuery">병원명 또는 진료과목</label>
        <div><select id="careType" aria-label="검색 기준"><option value="HOSP">병원명</option><option value="MAJOR">진료과목</option><option value="ADDR">지역</option></select><input id="careQuery" placeholder="예: 소아청소년과" type="search"><button type="submit">병원 찾기</button></div>
      </form>
      <div class="care-specialties" aria-label="진료과목 바로 찾기">
        <button data-major="내과">내과</button><button data-major="소아청소년과">소아청소년과</button><button data-major="정형외과">정형외과</button><button data-major="치과">치과</button><a href="/hospital/hplist/List/">전체 병원 →</a>
      </div>
    </div>
    <aside class="care-next">
      <h2>예약부터 방문 후까지</h2>
      <a href="/hospital/reserv/MyReserv/"><b>예약 내역</b><span>예정된 방문 확인 및 취소 →</span></a>
      <a href="/hospital/mypage/OpenMypageFavhp/"><b>관심 병원</b><span>다시 찾고 싶은 병원 모아보기 →</span></a>
      <a href="/hospital/rate/RatingList/"><b>방문 후기</b><span>지난 진료를 평가하고 후기 남기기 →</span></a>
    </aside>
  </section>
  <section class="care-reviews">
    <div class="care-section-heading"><div><h2>병원 후기</h2></div><a href="/hospital/hplist/List/?QUERY=hplist.selectRateHpList">평가 우수 병원 보기 →</a></div>
    <div class="care-review-grid">
      <c:forEach items="${reviewlist}" var="rl">
        <article class="care-review"><p class="care-score">평점 ${rl.RATE} / 5</p><h3>${rl.HOSP}</h3><p><c:out value="${rl.COMM}"/></p><small>${rl.NAME} · ${rl.REG}</small></article>
      </c:forEach>
    </div>
  </section>
</main>
<%@ include file="/WEB-INF/include/include-body.jspf" %>
<script>
$(function () {
  function findHospital(type, value) {
    var submit = new ComSubmit();
    submit.setUrl('/hospital/hplist/List');
    submit.addParam('LIST', 'selectHpList'); submit.addParam('QUERY', 'hplist.selectAllHpList'); submit.addParam('REG_CHK', 'N'); submit.addParam('boardTitle', '병원 검색');
    submit.addParam('SEARCHTYPE', type); submit.addParam('SEARCHVALUE', value);
    submit.submit();
  }
  $('#careSearch').on('submit', function (e) { e.preventDefault(); findHospital($('#careType').val(), $('#careQuery').val()); });
  $('[data-major]').on('click', function () { findHospital('MAJOR', $(this).attr('data-major')); });
});
</script>
