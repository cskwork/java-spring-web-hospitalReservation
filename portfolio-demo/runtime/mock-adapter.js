/*
 * Dr.Her 데모 어댑터 (브라우저 전용).
 *
 * 원본 common.js 의 ComSubmit(폼 POST 로 화면 이동)과 ComAjax($.ajax POST)를 같은 사용법 그대로
 * 다시 정의해, 서버 대신 모의 백엔드(mock-backend.js)와 정적 화면으로 연결한다.
 *  - ComSubmit.submit() : 원본 URL(/hospital/reserv/MyReserv 등) → 같은 경로의 정적 화면(…/MyReserv/?파라미터)
 *  - ComAjax.ajax()     : 원본 URL → DrHerMockBackend.handleAjax() 결과를 원본 콜백에 그대로 전달
 * 모의 백엔드에 없는 요청과 실제 네트워크 요청($.ajax, fetch, XHR)은 명시적으로 실패시킨다.
 * 카카오 지도 SDK(daum.maps)는 아무것도 그리지 않는 모의 객체로 대신한다.
 */
(function (window, document) {
  'use strict';

  var STORAGE_KEY = 'drher-demo:v1';
  var MB = window.DrHerMockBackend;
  var fixtures = window.DrHerFixtures;
  var $ = window.jQuery;
  var notices = [];
  document.addEventListener('DOMContentLoaded', function () {
    try {
      var full=JSON.parse(window.localStorage.getItem(STORAGE_KEY)||'null');
      if(full&&full.members){
        var current=routeOfPage(),views={'/hospital/main':'search','/hospital/hplist/List':'search','/hospital/hplist/HpDetail':'detail','/hospital/reserv/OpenReserv':'detail','/hospital/reserv/MyReserv':'reservations','/hospital/reserv/MyPastReserv':'past','/hospital/rate/RatingList':'past','/hospital/rate/OpenRating':'past','/hospital/mypage/OpenMypageFavhp':'favorites'};
        var id=new URLSearchParams(window.location.search).get('H_IDX')||window.location.pathname.split('/').filter(Boolean).slice(-1)[0];
        if(views[current]){demo.navigate('/hospital/workspace/?view='+views[current]+(views[current]==='detail'?'&H_IDX='+encodeURIComponent(id):''));return;}
      }
    } catch(e) { /* existing storage validation below presents recovery */ }
    var nav = document.createElement('nav'); nav.className = 'complete-nav'; nav.setAttribute('aria-label','전체 업무');
    nav.innerHTML = '<a href="/hospital/workspace/?view=search">전체 병원 찾기</a><a href="/hospital/workspace/?view=accounts">계정·로그인</a><a href="/hospital/workspace/?view=profile">건강수첩</a><a href="/hospital/workspace/?view=points">포인트</a><a href="/hospital/workspace/?view=notice">공지사항</a><a href="/hospital/workspace/?view=faq">FAQ</a><a href="/hospital/workspace/?view=qna">문의</a><a href="/hospital/workspace/?view=admin">관리자</a><a href="/hospital/workspace/?view=guide">이용 가이드</a>';
    document.body.insertBefore(nav, document.body.firstChild);
  });
  var memoryFallback = null;
  var STORAGE_WARNING = '브라우저 저장소를 사용할 수 없어 새로고침하면 데모 데이터가 사라집니다.';

  function unsupportedError(what) {
    return new MB.MockError('[demo] 데모에서 지원하지 않는 기능입니다: ' + what);
  }

  function showMessage(msg) {
    if (window.Alert && typeof window.Alert.render === 'function') window.Alert.render(msg);
    else window.alert(msg);
  }

  // ---------- 저장소 (localStorage, 손상 시 초기화) ----------
  var store = {
    load: function () {
      var raw;
      try {
        raw = window.localStorage.getItem(STORAGE_KEY);
      } catch (e) {
        return memoryFallback;
      }
      if (raw === null) return memoryFallback;
      try {
        var s = JSON.parse(raw);
        if (MB.isValidState(s)) return s;
      } catch (e) { /* 아래에서 초기화 */ }
      notices.push('저장된 데모 데이터가 손상되어 처음 상태로 되돌렸습니다.');
      return null;
    },
    save: function (s) {
      memoryFallback = JSON.parse(JSON.stringify(s));
      try {
        window.localStorage.setItem(STORAGE_KEY, JSON.stringify(s));
      } catch (e) {
        if (notices.indexOf(STORAGE_WARNING) < 0) notices.push(STORAGE_WARNING);
      }
    }
  };

  var backend = MB.createBackend({ fixtures: fixtures, session: fixtures.SESSION, store: store });

  function routeOfPage() {
    var meta = document.querySelector('meta[name="drher-route"]');
    return meta ? meta.getAttribute('content') : '';
  }

  // 요청 파라미터가 없을 때 컨트롤러에 넘어가던 값의 기본값 (header.jsp moveToHpList 의 '전체 병원')
  var PARAM_DEFAULTS = {
    '/hospital/hplist/List': { boardTitle: '전체 병원 검색', LIST: 'selectHpList', QUERY: 'hplist.selectAllHpList', REG_CHK: 'N', SEARCHTYPE: '', SEARCHVALUE: '' },
    '/hospital/reserv/OpenReserv': { H_IDX: '' },
    '/hospital/rate/OpenRating': { NUM: '', H_IDX: '', RESERV1: '' }
  };

  function requestParams(route) {
    var out = {};
    var defaults = PARAM_DEFAULTS[route] || {};
    var q = new URLSearchParams(window.location.search);
    Object.keys(defaults).forEach(function (k) {
      out[k] = q.has(k) && q.get(k) !== '' ? q.get(k) : defaults[k];
    });
    if (route === '/hospital/hplist/List') {
      if (out.LIST !== 'selectHpList') out.LIST = defaults.LIST;
      if (out.REG_CHK !== 'Y') out.REG_CHK = 'N';
    }
    return out;
  }

  function toObject(pairs) {
    var o = {};
    pairs.forEach(function (p) { o[p[0]] = p[1]; });
    return o;
  }

  function query(params) {
    var keys = Object.keys(params);
    if (!keys.length) return '';
    return '?' + keys.map(function (k) { return encodeURIComponent(k) + '=' + encodeURIComponent(params[k]); }).join('&');
  }

  var demo = {
    STORAGE_KEY: STORAGE_KEY,
    backend: backend,
    route: routeOfPage,
    navigate: function (url) { window.location.assign(url); },

    // 원본 ComSubmit 의 폼 POST 를 정적 화면 이동으로 바꾼다.
    submit: function (url, pairs) {
      var params = toObject(pairs);
      if (url === '/hospital/rate/Rating') {
        try { backend.insertRating(params); }
        catch (e) { var error = document.getElementById('rateError'); if (error) error.textContent = e.message; return false; }
        return demo.navigate('/hospital/rate/RatingList/?saved=1');
      }
      if (url === '/hospital/rate/OpenRating' && !backend.ratingReservation(params)) {
        showMessage('본인의 지난 방문을 목록에서 선택해주세요.'); return false;
      }
      if (url === '/hospital/reserv/CancelReserv') {
        var r = backend.cancelReserv(params);
        if (r.blocked.length) window.alert('예약 시간 30분 전부터는 취소할 수 없는 예약이 있어 제외했습니다.');
        return demo.navigate(MB.ACTION_ROUTES[url] + '/' + query({ STEP: 'reserv' }));
      }
      if (url === '/hospital/mypage/DelFavHp') {
        backend.delFavHp(params);
        return demo.navigate(MB.ACTION_ROUTES[url] + '/');
      }
      if (url === '/hospital/hplist/HpDetail') {
        if (!backend.selectHpDetail(params.H_IDX)) throw unsupportedError('없는 병원 ' + params.H_IDX);
        return demo.navigate('/hospital/hplist/HpDetail/' + encodeURIComponent(params.H_IDX) + '/');
      }
      if (MB.PAGE_ROUTES.indexOf(url) > -1) return demo.navigate(url + '/' + query(params));
      showMessage('데모에서는 지원하지 않는 기능입니다.');
      throw unsupportedError(url);
    },

    // 원본 ComAjax 의 $.ajax POST 를 모의 백엔드 호출로 바꾼다(응답은 비동기로 콜백에 전달).
    ajax: function (url, pairs, callback) {
      var params = toObject(pairs);
      window.setTimeout(function () {
        var data;
        try {
          data = backend.handleAjax(url, params);
        } catch (e) {
          showMessage('데모에서 처리할 수 없는 요청입니다.');
          throw e;
        }
        if (typeof callback === 'function') callback(data);
        else if (typeof callback === 'string' && callback !== '') {
          if (typeof window[callback] !== 'function') throw new MB.MockError('[demo] 콜백 함수가 없습니다: ' + callback);
          window[callback](data);
        }
      }, 0);
    },

    // 서버 렌더링 대신: 목록 템플릿과 요청 파라미터를 채운다(화면 조각 끝에서 한 번 호출).
    renderRuntime: function () {
      var route = routeOfPage();
      window.DrHerJspRuntime.render(document, backend.pageModel(route), requestParams(route));
    },

    reset: function () {
      if (!window.confirm('데모에서 만든 예약·관심병원·후기를 모두 지우고 처음 상태로 되돌릴까요?')) return;
      memoryFallback = null;
      try { window.localStorage.removeItem(STORAGE_KEY); } catch (e) { /* 저장소 없음 */ }
      demo.navigate('/hospital/main/');
    }
  };
  window.DrHerDemo = demo;

  // ---------- common.js 의 ComSubmit / ComAjax 를 같은 인터페이스로 교체 ----------
  window.ComSubmit = function () {
    this.url = '';
    this.pairs = [];
    this.setUrl = function (url) { this.url = url; };
    this.addParam = function (key, value) { this.pairs.push([key, value === undefined || value === null ? '' : String(value)]); };
    this.submit = function () { return demo.submit(this.url, this.pairs); };
  };

  window.ComAjax = function () {
    this.url = '';
    this.pairs = [];
    this.setUrl = function (url) { this.url = url; };
    this.setCallback = function (cb) { window.fv_ajaxCallback = cb; };
    this.addParam = function (key, value) { this.pairs.push([key, value === undefined || value === null ? '' : String(value)]); };
    this.ajax = function () { demo.ajax(this.url, this.pairs, window.fv_ajaxCallback); };
  };

  // ---------- 실제 네트워크 요청 차단 ----------
  function blocked(name) {
    return function () { throw new MB.MockError('[demo] 모의 처리되지 않은 네트워크 요청: ' + name); };
  }
  if ($) $.ajax = blocked('$.ajax');
  if (window.fetch) window.fetch = blocked('fetch');
  if (window.XMLHttpRequest) window.XMLHttpRequest.prototype.open = blocked('XMLHttpRequest');

  // ---------- 카카오 지도 SDK 모의 객체 (hplist/List.jsp 의 지도 코드가 오류 없이 돌도록) ----------
  function noop() {}
  function Marker(opts) {
    this.getPosition = function () { return opts && opts.position; };
    this.setVisible = noop;
    this.setMap = noop;
  }
  window.daum = {
    maps: {
      LatLng: function (lat, lon) { this.lat = lat; this.lon = lon; },
      Map: function () { this.setCenter = noop; },
      Marker: Marker,
      InfoWindow: noop,
      CustomOverlay: function () { this.setMap = noop; },
      Size: noop,
      MarkerImage: noop,
      event: { addListener: noop },
      services: {
        Status: { OK: 'OK' },
        Geocoder: function () { this.addressSearch = function () { throw unsupportedError('주소 검색'); }; }
      }
    },
    Postcode: function () { this.open = function () { throw unsupportedError('주소 찾기'); }; }
  };

  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('[data-hospital-rate]').forEach(function (el) {
      var h = backend.selectHpDetail(el.getAttribute('data-hospital-rate'));
      el.textContent = h && h.RATE !== null ? h.RATE + ' / 5' : '아직 평가 없음';
    });
    if (routeOfPage() === '/hospital/rate/OpenRating') {
      var visit = backend.ratingReservation(requestParams(routeOfPage()));
      if (!visit || visit.STATE === '완료') {
        document.getElementById('rateError').textContent = visit ? '이미 작성한 후기입니다. 목록에서 완료 상태를 확인해주세요.' : '본인의 지난 방문을 목록에서 선택해주세요.';
        document.getElementById('rate').disabled = true;
      }
    }
    var btn = document.getElementById('demoReset');
    if (btn) btn.addEventListener('click', demo.reset);
  });
  window.addEventListener('load', function () {
    backend.state(); // 저장값 점검(손상 시 초기화)
    if (notices.length) showMessage(notices.join('<br>'));
  });
})(window, document);
