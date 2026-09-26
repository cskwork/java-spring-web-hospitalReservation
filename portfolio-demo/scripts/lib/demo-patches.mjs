// 데모 빌드에서만 적용하는 변경. 원본 파일은 건드리지 않고, 빌드할 때 원본 내용에 덧씌운다.
// 모두 원본 문자열에 고정(anchor)되어 있어 원본이 바뀌면 빌드가 멈춘다.
//
// 원본 자체의 결함 수정(데모와 무관하게 원본 앱에도 필요한 것)은 여기 두지 않고
// 원본 파일을 직접 고쳤다. 목록은 SOURCE-HANDOFF.md 참고.

const NOTICE = '원본 프로젝트 기반 데모 · 모의 데이터 · 실제 예약이 이루어지지 않습니다';

export const DEMO_NOTICE = NOTICE;

export const DEMO_PATCHES = [
  // ---------------- layout / head ----------------
  {
    file: 'WEB-INF/views/layout.jsp',
    id: 'layout-demo-notice',
    reason: '모든 화면 상단에 고정 안내문과 데모 초기화 버튼을 둔다.',
    find: '<body>\n',
    replace:
      '<body>\n\t<div class="demo-notice" role="note"><span class="demo-notice__text">' + NOTICE + '</span>' +
      '<button type="button" id="demoReset" class="demo-notice__reset">데모 초기화</button></div>\n',
  },
  {
    file: 'WEB-INF/include/include-header.jspf',
    id: 'head-title-viewport',
    reason: '빈 <title> 을 채우고 모바일 viewport 를 선언한다.',
    find: '<title></title>',
    replace: '<meta name="viewport" content="width=device-width, initial-scale=1">\n<title>Dr.Her 병원 예약 · 원본 기반 데모</title>',
  },

  // ---------------- header.jsp ----------------
  {
    file: 'WEB-INF/views/header.jsp',
    id: 'header-hide-unsupported-menus',
    reason: '고객지원(공지·FAQ·1:1 문의)과 사이트 이용 가이드는 데모에 포함하지 않아 메뉴에서 뺀다.',
    find: /\n\t*<li><a name="showMenu" id="subMenu[23]" href="#">[^<]*<\/a><\/li>/,
    count: 2,
    replace: '',
  },
  {
    file: 'WEB-INF/views/header.jsp',
    id: 'header-hide-unsupported-submenus',
    reason: '위 메뉴의 하위 메뉴(ul#subMenu2, ul#subMenu3)도 뺀다.',
    find: /\n\t*<ul id="subMenu[23]">[\s\S]*?<\/ul>[ \t]*/,
    count: 2,
    replace: '',
  },
  {
    file: 'WEB-INF/views/header.jsp',
    id: 'header-no-logout',
    reason: '로그인/로그아웃(카카오 포함)은 지원하지 않는다. 고정 가상 별칭 세션만 쓴다.',
    find: '\n\t\t\t\t\t<a href="#" id="logout">로그아웃</a>',
    replace: '',
  },
  {
    file: 'WEB-INF/views/header.jsp',
    id: 'header-hide-unsupported-mypage-items',
    reason: '내 정보(건강수첩)와 후기 남기기는 데모에 포함하지 않는다.',
    find: /\n\t*<a href="#" name="mypageList" id="(?:mypage\/OpenMypageMain|rate\/RatingList)"[^\n]*/,
    count: 2,
    replace: '',
  },
  {
    file: 'WEB-INF/views/header.jsp',
    id: 'header-remove-kakao-app-key',
    reason: '카카오 SDK 앱 키를 공개 빌드에 싣지 않는다(SDK 스크립트도 제외).',
    find: /Kakao\.init\('[0-9a-f]+'\);/,
    replace: '// [demo] Kakao SDK 초기화(앱 키) 제거: 로그인/로그아웃은 데모에서 지원하지 않는다.',
  },

  // ---------------- footer.jsp ----------------
  {
    file: 'WEB-INF/views/footer.jsp',
    id: 'footer-contact-title',
    reason: '연락처 섹션을 사이트 정보 섹션으로 바꾼다.',
    find: '<h2>연락처</h2>\n\t\t\t\t\t\t<p>문의 사항이 있으면 연락해주세요!<br></p>',
    replace: '<h2>사이트 정보</h2>\n\t\t\t\t\t\t<p>원본 프로젝트 화면을 정적 데모로 옮겼습니다.<br></p>',
  },
  {
    file: 'WEB-INF/views/footer.jsp',
    id: 'footer-remove-contact-data',
    reason: '원본의 주소·전화·이메일은 공개하지 않는다. 원본 제작팀 표기는 남긴다.',
    find: /<h4>회사 주소<\/h4>[\s\S]*?<i class="fa fa-envelope"><\/i>[^<]*<\/p>/,
    replace:
      '<h4>원본 프로젝트</h4>\n' +
      '\t\t\t\t\t\t<p>Dr.Her 병원 통합 예약 사이트 · Spring MVC + MyBatis + JSP 팀 프로젝트 (KH정보교육원 자바개발자과정)</p>\n' +
      '\t\t\t\t\t\t<p>원본 제작팀 표기: 소영이 · 양구그리 · 꾸기 · 쭈노</p>\n' +
      '\t\t\t\t\t\t<p>이 데모는 연락처를 싣지 않습니다. 병원·예약 정보는 모두 가상 데이터입니다.</p>',
  },
  {
    file: 'WEB-INF/views/footer.jsp',
    id: 'footer-dead-link',
    reason: '이동할 곳이 없는 링크(href="#")를 글자로 바꾼다.',
    find: '<p>약관 <a href="#"><span>KH정보교육원</span>자바개발자과정</a></p>',
    replace: '<p><span>KH정보교육원</span> 자바개발자과정 · Nantes / MOOZ Themes · <a href="/licenses/NOTICE.txt">출처·라이선스</a></p>',
  },

  // ---------------- main.jsp ----------------
  {
    file: 'WEB-INF/views/main.jsp',
    id: 'main-slider-neutral',
    reason: '권리 확인이 안 된 슬라이더 사진(slider-1~4.jpg)을 단색 구성으로 바꾼다.',
    find: /<img src="\/hospital\/img\/mainImg\/slider-(\d)\.jpg"[^>]*>/,
    count: 4,
    replace: '<div class="demo-neutral-visual demo-neutral-visual--$1"><strong>Dr.Her</strong><span>전국 병원 검색 및 예약</span></div>',
  },
  {
    file: 'WEB-INF/views/main.jsp',
    id: 'main-slider-fixed-size',
    reason: '고정 크기(2000px/740px)가 모바일에서 가로 넘침을 만든다.',
    find: ' style="height:740px; width:2000px;"',
    count: 4,
    replace: '',
  },
  {
    file: 'WEB-INF/views/main.jsp',
    id: 'main-slider-container-size',
    reason: '슬라이더 높이는 데모 CSS 에서 화면 너비에 맞춘다.',
    find: '<div class="slider-container" style="width: 100%; height: 740px">',
    replace: '<div class="slider-container demo-slider">',
  },
  {
    file: 'WEB-INF/views/main.jsp',
    id: 'main-review-neutral-figure',
    reason: '후기 카드의 사진(portfolio-N.jpg)은 권리 확인이 안 되어 단색 카드로 바꾼다.',
    find: '<img src="/hospital/img/mainImg/portfolio-${rl.RN}.jpg" alt="img02" class="img-responsive" />',
    replace: '<div class="demo-neutral-figure" aria-hidden="true"><span>${rl.HOSP }</span></div>',
  },
  {
    file: 'WEB-INF/views/main.jsp',
    id: 'main-guide-screenshots',
    reason: '가이드 캡처(partners-N.jpg)에는 실제 이름이 보여 싣지 않는다. 캡션 글은 남긴다.',
    find: '<img src="/hospital/img/mainImg/partners-${stat.current}.jpg" alt="partners">',
    replace: '<span class="demo-guide-mark" aria-hidden="true"><i class="fa fa-file-text-o"></i></span>',
  },
  {
    file: 'WEB-INF/views/main.jsp',
    id: 'main-disable-qna',
    reason: '1:1 문의는 데모에서 지원하지 않는다.',
    find: '<a href="#" id="qna" class="mz-module-button">이동하기</a>',
    replace: '<span class="mz-module-button demo-disabled" aria-disabled="true">데모 미지원</span>',
  },

  // ---------------- hplist/List.jsp ----------------
  {
    file: 'WEB-INF/views_jw/hplist/List.jsp',
    id: 'list-disable-distance',
    reason: '거리순 검색은 브라우저 위치·지도 API 가 필요해 비활성화한다.',
    find: '<select id="distance">',
    replace: '<select id="distance" disabled="disabled" title="거리순 검색은 데모에서 지원하지 않습니다">',
  },
  {
    file: 'WEB-INF/views_jw/hplist/List.jsp',
    id: 'list-disable-postcode',
    reason: '주소 찾기(다음 우편번호 API)는 비활성화한다.',
    find: '<input type="button" onclick="execDaumPostcode()" value="주소 찾기" />',
    replace: '<input type="button" value="주소 찾기" disabled="disabled" title="주소 찾기는 데모에서 지원하지 않습니다" />',
  },
  {
    file: 'WEB-INF/views_jw/hplist/List.jsp',
    id: 'list-location-note',
    reason: '비활성화한 이유를 화면에 적는다.',
    find: /(<\/table>\s*<\/div>\s*)(<div class="gridForm">)/,
    replace: '$1<p class="demo-note">※ 거리순·주소 찾기·지도(카카오/다음 API)는 데모에서 사용하지 않습니다. 병원명·위치·진료과목 검색은 사용할 수 있습니다.</p>\n\t\t$2',
  },
  {
    file: 'WEB-INF/views_jw/hplist/List.jsp',
    id: 'list-map-note',
    reason: '지도 자리에 안내를 둔다(지도 SDK 는 모의 객체로 대체).',
    find: '<table id="daumMap"></table>',
    replace: '<table id="daumMap"></table>\n\t\t\t\t\t<p class="demo-map-note">지도 영역(카카오맵)은 데모에서 제외했습니다.</p>',
  },
  {
    file: 'WEB-INF/views_jw/hplist/List.jsp',
    id: 'list-fav-icon-off',
    reason: '관심병원 별 이미지(off.png)는 권리 확인이 안 되어 자체 SVG 로 바꾼다.',
    find: '"/hospital/img/off.png"',
    count: 2,
    replace: '"/hospital/demo/img/fav-off.svg"',
  },
  {
    file: 'WEB-INF/views_jw/hplist/List.jsp',
    id: 'list-fav-icon-on',
    reason: '관심병원 별 이미지(on.png)도 자체 SVG 로 바꾼다.',
    find: '"/hospital/img/on.png"',
    count: 2,
    replace: '"/hospital/demo/img/fav-on.svg"',
  },
  {
    file: 'WEB-INF/views_jw/hplist/List.jsp',
    id: 'list-no-external-marker',
    reason: '외부 지도 마커 이미지 주소를 싣지 않는다.',
    find: "var imageSrc = 'http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';",
    replace: "var imageSrc = ''; // [demo] 외부 지도 마커 이미지 제거",
  },

  // ---------------- reservation/reserv.jsp ----------------
  {
    file: 'WEB-INF/views_sy/mypage/reservation.jsp',
    id: 'reservation-synthetic-notice',
    reason: '다른 실제 예약 서비스의 개인정보 통지 문구를 모의 데이터 안내로 바꾼다.',
    find: /※ 『정보통신망[^\n]+<br>/,
    replace: '※ 이 목록은 브라우저에만 저장되는 가상 예약 내역입니다. 실제 개인정보 이용내역이나 병원 예약이 아닙니다.<br>',
  },
  {
    file: 'WEB-INF/views_sy/reservation/reserv.jsp',
    id: 'reserv-remove-payment-box',
    reason: '포인트 결제(아임포트·카카오페이) 창은 싣지 않는다.',
    find: /\n\t<div class="point_payment">[\s\S]*?<div class="bbg"><\/div>\n\t<\/div>/,
    replace: '',
  },
  {
    file: 'WEB-INF/views_sy/reservation/reserv.jsp',
    id: 'reserv-remove-payment-code',
    reason: '결제 가맹점 코드와 결제 호출을 제거한다.',
    find: /function fn_Point\(amount\) \{[\s\S]*?\n\t\t\}\n/,
    replace:
      'function fn_Point(amount) {\n' +
      '\t\t\t// [demo] 아임포트(카카오페이) 결제 호출과 가맹점 코드를 제거했다.\n' +
      '\t\t\tAlert.render("결제(포인트 충전)는 데모에서 지원하지 않습니다.");\n' +
      '\t\t}\n',
  },
  {
    file: 'WEB-INF/views_sy/reservation/reserv.jsp',
    id: 'reserv-point-shortage-message',
    reason: '포인트 부족 시 결제 창 대신 모의 포인트 안내를 보여 준다.',
    find: /if\(confirm\("포인트가 부족합니다\.[\s\S]*?\n\t\t\t\t\}/,
    replace:
      'alert("모의 포인트가 부족합니다.\\n현재 포인트는: " + data.POINT + "입니다.\\n' +
      '예약을 취소하면 포인트가 돌아오고, 상단의 \'데모 초기화\'로 처음 상태(1000포인트)로 되돌릴 수 있습니다.");',
  },
];
