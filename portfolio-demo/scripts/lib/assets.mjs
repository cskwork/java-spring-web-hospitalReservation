// 렌더링된 화면이 참조하는 모든 <script src>/<link href> 의 처리 방법.
// 여기에 없는 주소가 나오면 빌드가 멈춘다.
//  copy   : 원본 src/main/webapp 파일을 같은 경로(/hospital/...)로 복사
//  vendor : 원본이 CDN 에서 받던 라이브러리를 npm 패키지에서 복사 (외부 요청 없음)
//  drop   : 싣지 않음 (이유 기록)

export const ASSETS = {
  // 원본 CSS/JS (src/main/webapp)
  '/hospital/css/ui.css': { copy: 'css/ui.css' },
  '/hospital/css/bootstrap.min.css': { copy: 'css/bootstrap.min.css' },
  '/hospital/css/owl.carousel.css': { copy: 'css/owl.carousel.css' },
  '/hospital/css/owl.theme.default.min.css': { copy: 'css/owl.theme.default.min.css' },
  '/hospital/css/animate.css': { copy: 'css/animate.css' },
  '/hospital/css/style.css': { copy: 'css/style.css' },
  '/hospital/js/common.js': { copy: 'js/common.js' },
  '/hospital/js/bootstrap.min.js': { copy: 'js/bootstrap.min.js' },
  '/hospital/js/owl.carousel.min.js': { copy: 'js/owl.carousel.min.js' },
  '/hospital/js/cbpAnimatedHeader.js': { copy: 'js/cbpAnimatedHeader.js' },
  '/hospital/js/jquery.appear.js': { copy: 'js/jquery.appear.js' },
  '/hospital/js/SmoothScroll.min.js': { copy: 'js/SmoothScroll.min.js' },
  '/hospital/js/theme-scripts.js': { copy: 'js/theme-scripts.js' },
  '/hospital/js/layoutAssist.js': { drop: '관리자(ID == admin) 화면 전용 스크립트. 데모에는 관리자 화면이 없다.' },
  'favicon.ico': { drop: '원본 저장소에 favicon.ico 파일이 없다(원본에서도 404).' },

  // 원본이 CDN 에서 받던 라이브러리
  'https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js': { vendor: 'jquery' },
  'https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js': { vendor: 'jquery' },
  'https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css': { vendor: 'font-awesome' },
  '//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css': {
    drop: 'Bootstrap 4 CDN 이 로컬 Bootstrap 3.3.5 와 함께 중복 로드되고 있었다. 템플릿(style.css)이 기준으로 삼는 3.3.5 만 남긴다.',
  },
  '//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js': { drop: '위와 같은 Bootstrap 4 중복 로드.' },
  'http://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js': { drop: '원본 스크립트 어디에서도 easing 함수를 쓰지 않는다.' },
  'http://developers.kakao.com/sdk/js/kakao.min.js': { drop: '카카오 로그인/로그아웃은 데모에서 지원하지 않는다.' },
  '//developers.kakao.com/sdk/js/kakao.min.js': { drop: '카카오 로그인/로그아웃은 데모에서 지원하지 않는다.' },
  'http://dmaps.daum.net/map_js_init/postcode.v2.js': { drop: '주소 찾기(다음 우편번호)는 데모에서 비활성화했다.' },
  '//dapi.kakao.com/v2/maps/sdk.js': { drop: '카카오 지도 SDK(앱 키 필요)는 mock-adapter.js 의 모의 객체로 대신한다.', matchPrefix: true },
  'https://cdn.iamport.kr/js/iamport.payment-1.1.5.js': { drop: '포인트 결제(아임포트)는 데모에서 지원하지 않는다.' },
};

export const VENDOR = {
  jquery: {
    url: '/hospital/vendor/jquery/jquery.min.js',
    files: [
      ['node_modules/jquery/dist/jquery.min.js', 'hospital/vendor/jquery/jquery.min.js'],
      ['node_modules/jquery/LICENSE.txt', 'hospital/vendor/jquery/LICENSE.txt'],
    ],
    note: 'jQuery 1.12.4 (MIT). 원본은 1.11.2/1.11.3 CDN 을 썼다. owl.carousel 이 쓰는 andSelf() 등 1.x API 호환을 위해 1.x 최종판을 쓴다.',
  },
  'font-awesome': {
    url: '/hospital/vendor/font-awesome/css/font-awesome.min.css',
    files: [
      ['node_modules/font-awesome/css/font-awesome.min.css', 'hospital/vendor/font-awesome/css/font-awesome.min.css'],
      ['node_modules/font-awesome/fonts', 'hospital/vendor/font-awesome/fonts'],
    ],
    note: 'Font Awesome 4.7.0 (글꼴 SIL OFL 1.1, CSS MIT). 원본은 4.4.0 CDN 을 썼다.',
    license: 'Font Awesome 4.7.0 by Dave Gandy - http://fontawesome.io\nFont: SIL OFL 1.1 (http://scripts.sil.org/OFL)\nCSS: MIT License (http://opensource.org/licenses/mit-license.html)\n',
  },
};

// 원본 CSS 를 복사할 때 외부 요청만 제거한다.
export const CSS_TRANSFORMS = {
  'css/style.css': [
    {
      id: 'style-no-google-fonts',
      reason: 'Google Fonts @import(http) 제거. 글꼴은 ui.css 의 Noto Sans KR/시스템 글꼴로 대체된다.',
      find: /@import url\(http:\/\/fonts\.googleapis\.com\/css\?family=[^)]*\);/,
      count: 2,
      replace: '/* [demo] Google Fonts @import 제거 */',
    },
  ],
  'css/ui.css': [
    {
      id: 'ui-no-daum-overlay-image',
      reason: '지도 오버레이 닫기 버튼 이미지(daumcdn) 제거. 지도는 데모에서 쓰지 않는다.',
      find: "url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/overlay_close.png')",
      count: 1,
      replace: 'none',
    },
    {
      id: 'ui-no-google-fonts',
      reason: '파일 중간의 Google Fonts @import(http) 제거. CSS 규칙상 맨 앞이 아닌 @import 는 무시되므로 원본에서도 적용되지 않았다.',
      find: '@import url(http://fonts.googleapis.com/earlyaccess/nanumgothic.css);',
      count: 1,
      replace: '/* [demo] Google Fonts @import 제거 */',
    },
  ],
};

// 복사하는 원본 이미지. 나머지 이미지는 싣지 않는다(SOURCE-HANDOFF.md 에 이유 기록).
export const IMAGES = {
  '/hospital/img/logo2.gif': 'img/logo2.gif',
};

export function lookupAsset(url) {
  if (ASSETS[url]) return ASSETS[url];
  for (const [key, v] of Object.entries(ASSETS)) {
    if (v.matchPrefix && url.startsWith(key)) return v;
  }
  return null;
}

// 공개 산출물에 앱 키가 남지 않도록 쿼리 문자열을 지운 주소
export function sanitizeUrl(url) {
  return url.replace(/\?.*$/, '');
}
