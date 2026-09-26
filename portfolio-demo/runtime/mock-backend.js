/*
 * Dr.Her 모의 백엔드 (데모 전용).
 *
 * 원본 Spring 컨트롤러가 돌려주던 모델/JSON을 같은 키 이름으로 만들어 준다.
 * 서버·DB 대신 합성 데이터(fixtures.js)와 브라우저 저장소를 쓴다. 네트워크 호출은 없다.
 *
 * 포팅 원본 (메서드 단위):
 *  - hp/jw/controller/HpListController.java        selectHospitalList, openHpDetail
 *  - hp/Final/service/HpListServiceImpl.java       selectBoardList, selectHpDetail, GpstoMeter
 *  - mapper/jw/hplist_SQL.xml                      selectAllHpList, selectRateHpList, selectHpDetail
 *  - hp/sy/controller/ReservController.java        SelectHospitalList ~ CancelReserv
 *  - hp/Final/service/ReservServiceImpl.java       selectDate, insertReserv, selectReservation,
 *                                                  selectPastReservation, cancelReserv
 *  - mapper/sy/reserv_SQL.xml, mapper/sy/mypage_SQL.xml (FAV, POINT)
 *  - hp/common/controller/MainController.java + mapper/common/Common_SQL.xml (selectCount, selectReview)
 *
 * 원본과 다르게 동작하는 부분(원본 결함 보정)은 "[보정]" 주석으로 표시했다.
 */
(function (root, factory) {
  var api = factory();
  if (typeof module === 'object' && module.exports) module.exports = api;
  else root.DrHerMockBackend = api;
})(typeof self !== 'undefined' ? self : this, function () {
  'use strict';

  var BOOKING_DAYS_AHEAD = 7;      // reserv.jsp: "일주일 단위로 예약이 가능합니다" (오늘 ~ 7일 뒤)
  var BOOKING_LEAD_MINUTES = 30;   // mypage/reservation.jsp: "현재 시간 기준으로 + 30분은 예약 및 예약수정이 불가능"
  var RESERV_POINT = 100;          // ReservServiceImpl.insertReserv: 포인트 100 미만이면 예약 불가, 예약 시 100 차감

  // ComAjax 가 호출하는 원본 URL (컨텍스트 경로 /hospital 포함)
  var AJAX_ROUTES = [
    '/hospital/hplist/selectHpList',
    '/hospital/reserv/SelectHospitalList',
    '/hospital/reserv/SelectMajorList',
    '/hospital/reserv/SelectDate',
    '/hospital/reserv/ReservDate',
    '/hospital/reserv/ReservResult',
    '/hospital/reserv/Reservation',
    '/hospital/mypage/InsertFav',
    '/hospital/mypage/DelFavHp'
  ];

  // ComSubmit 이 이동하던 원본 URL 중 데모가 화면으로 제공하는 것
  var PAGE_ROUTES = [
    '/hospital/rate/RatingList',
    '/hospital/rate/OpenRating',
    '/hospital/main',
    '/hospital/hplist/List',
    '/hospital/hplist/HpDetail',
    '/hospital/reserv/OpenReserv',
    '/hospital/reserv/MyReserv',
    '/hospital/reserv/MyPastReserv',
    '/hospital/mypage/OpenMypageFavhp'
  ];

  // 화면 없이 처리 후 다른 화면으로 redirect 하던 원본 URL
  var ACTION_ROUTES = {
    '/hospital/rate/Rating': '/hospital/rate/RatingList',
    '/hospital/reserv/CancelReserv': '/hospital/reserv/MyReserv',     // "redirect:/reserv/MyReserv"
    '/hospital/mypage/DelFavHp': '/hospital/mypage/OpenMypageFavhp'   // "redirect:OpenMypageFavhp"
  };

  var LIST_QUERIES = ['hplist.selectAllHpList', 'hplist.selectRateHpList'];
  var SEARCH_TYPES = ['HOSP', 'ADDR', 'MAJOR'];

  function MockError(message) {
    this.name = 'DrHerMockError';
    this.message = message;
  }
  MockError.prototype = Object.create(Error.prototype);

  function clone(v) {
    return JSON.parse(JSON.stringify(v));
  }

  function pad2(n) {
    return (n < 10 ? '0' : '') + n;
  }

  // RESERV1 형식(YYYY/MM/DD). 원본은 TO_CHAR(SYSDATE,'YYYY/MM/DD') 와 문자열 비교한다.
  function dateKey(d) {
    return d.getFullYear() + '/' + pad2(d.getMonth() + 1) + '/' + pad2(d.getDate());
  }

  function addDays(d, n) {
    return new Date(d.getFullYear(), d.getMonth(), d.getDate() + n);
  }

  function hhmmToMinutes(hhmm) {
    return parseInt(hhmm.substring(0, 2), 10) * 60 + parseInt(hhmm.substring(2, 4), 10);
  }

  function timeToMinutes(t) {
    return parseInt(t.substring(0, 2), 10) * 60 + parseInt(t.substring(3, 5), 10);
  }

  function formatHour(onhour, offhour) {
    // HpListServiceImpl: "HH:MM ~ HH:MM"
    return onhour.substring(0, 2) + ':' + onhour.substring(2) + ' ~ ' + offhour.substring(0, 2) + ':' + offhour.substring(2);
  }

  // HpListServiceImpl.GpstoMeter (위도/경도 → 미터)
  function gpsToMeter(minLat, maxLat, minLon, maxLon) {
    var R = 6378.137;
    var d2r = Math.PI / 180;
    var dlong = (maxLon - minLon) * d2r;
    var dlat = (maxLat - minLat) * d2r;
    var a = Math.pow(Math.sin(dlat / 2), 2) + Math.cos(minLat * d2r) * Math.cos(maxLat * d2r) * Math.pow(Math.sin(dlong / 2), 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return Math.floor(R * c * 1000);
  }

  var ZOOM_DEFAULT = [20, 30, 50, 100, 250, 500, 1000, 2000, 4000, 8000, 16000, 32000, 64000, 128000];

  /*
   * 예약 가능 시간 (ReservServiceImpl.selectDate 포팅)
   * 원본 규칙: ONHOUR 부터 INTERVALL 분 간격, MEAL_TIME 의 '시' 한 시간 동안은 제외하고
   *           점심 뒤에는 정각부터 다시 시작한다.
   * [보정] 원본 반복 조건(on1 <= off1 || on2 < off2)은 OFFHOUR 이후 슬롯(예: 18:00, 18:30)까지 만들었다 → 종료 시각 전까지만.
   */
  function timeSlots(h) {
    var on1 = parseInt(h.ONHOUR.substring(0, 2), 10);
    var on2 = parseInt(h.ONHOUR.substring(2, 4), 10);
    var offMin = hhmmToMinutes(h.OFFHOUR);
    var inter = parseInt(h.INTERVALL, 10);
    var meal = parseInt(h.MEAL_TIME.substring(0, 2), 10);
    var out = [];
    if (!(inter > 0)) throw new MockError('INTERVALL 값이 올바르지 않습니다: ' + h.INTERVALL);
    for (;;) {
      if (on2 >= 60) {
        on1 += Math.floor(on2 / 60);
        on2 %= 60;
      }
      if (on1 * 60 + on2 >= offMin) break;
      if (on1 === meal) {
        on1 += 1;
        on2 = 0;
        continue;
      }
      out.push(pad2(on1) + ':' + pad2(on2));
      on2 += inter;
    }
    return out;
  }

  /*
   * 특정 날짜의 예약 가능 시간.
   * [보정] 원본은 로그인 사용자의 예약 목록을 순서대로 한 건씩만 비교해 이미 예약된 시간을 빼려 했다.
   *        여기서는 같은 병원·같은 날짜의 유효 예약(DEL_CHK='B') 시간을 모두 뺀다.
   * [보정] 오늘은 현재 시각 + 30분 이전 시간을 뺀다(마이페이지 안내 문구의 규칙).
   */
  function availableTimes(hospital, reservations, date, now) {
    var today = dateKey(now);
    var last = dateKey(addDays(now, BOOKING_DAYS_AHEAD));
    if (date < today || date > last) return [];
    var taken = {};
    reservations.forEach(function (r) {
      if (r.DEL_CHK === 'B' && String(r.H_IDX) === String(hospital.H_IDX) && r.RESERV1 === date) taken[r.RESERV2] = true;
    });
    var minMinutes = date === today ? now.getHours() * 60 + now.getMinutes() + BOOKING_LEAD_MINUTES : -1;
    return timeSlots(hospital).filter(function (t) {
      return !taken[t] && timeToMinutes(t) >= minMinutes;
    });
  }

  function isValidState(s) {
    return !!s && s.version === 1 && typeof s.POINT === 'number' && typeof s.RESERV_SEQ === 'number' &&
      Array.isArray(s.RESERVATION) && Array.isArray(s.FAV) &&
      (s.RATING === undefined || (Array.isArray(s.RATING) && s.RATING.every(function (r) {
        return r && typeof r.NUM === 'number' && typeof r.COMM === 'string' && typeof r.REG === 'string' &&
          [r.RATE1, r.RATE2, r.RATE3, r.RATE4].every(function (v) { return Number.isInteger(v) && v >= 1 && v <= 5; });
      }))) &&
      s.RESERVATION.every(function (r) {
        return r && typeof r.NUM === 'number' && /^\d{4}\/\d{2}\/\d{2}$/.test(r.RESERV1) && /^\d{2}:\d{2}$/.test(r.RESERV2) &&
          ['A', 'B', 'C'].indexOf(r.DEL_CHK) > -1;
      });
  }

  function createBackend(opts) {
    var fx = opts.fixtures;
    var session = opts.session || fx.SESSION;
    var store = opts.store;
    var nowFn = opts.now || function () { return new Date(); };

    function state() {
      var s = store.load();
      if (!isValidState(s)) {
        s = clone(fx.SEED_STATE);
        store.save(s);
      }
      if (!Array.isArray(s.RATING)) { s.RATING = []; store.save(s); }
      return s;
    }

    function hospital(hIdx) {
      for (var i = 0; i < fx.HOSPITAL.length; i++) {
        if (String(fx.HOSPITAL[i].H_IDX) === String(hIdx)) return fx.HOSPITAL[i];
      }
      return null;
    }

    function rateOf(hIdx) {
      // hplist_SQL.xml selectRateHpList: ROUND(SUM((RATE1+RATE2+RATE3+RATE4)/4)/COUNT(*), 2)
      var rows = fx.RATING.concat(state().RATING).filter(function (r) { return String(r.H_IDX) === String(hIdx); });
      if (!rows.length) return null;
      var sum = rows.reduce(function (acc, r) { return acc + (r.RATE1 + r.RATE2 + r.RATE3 + r.RATE4) / 4; }, 0);
      return Math.round((sum / rows.length) * 100) / 100;
    }

    // ---------- 병원 목록 (HpListController.selectHospitalList) ----------
    function selectBoardList(map) {
      var query = map.QUERY;
      if (LIST_QUERIES.indexOf(query) < 0) throw new MockError('지원하지 않는 목록 쿼리입니다: ' + query);
      var favs = state().FAV;
      var rows = fx.HOSPITAL.filter(function (h) { return h.DEL_CHK === '0'; });
      if (map.REG_CHK === 'Y') rows = rows.filter(function (h) { return h.REG_CHK === 'Y'; });
      if (map.SEARCH_CHK === 'Y') {
        // [보정] 원본 SQL "#{SEARCHTYPE} LIKE ..." 은 컬럼이 아니라 문자열 값을 비교해 검색이 동작하지 않았다.
        //        의도대로 선택한 컬럼(HOSP/ADDR/MAJOR)에서 부분 일치로 찾는다.
        if (SEARCH_TYPES.indexOf(map.SEARCHTYPE) < 0) throw new MockError('지원하지 않는 검색 조건입니다: ' + map.SEARCHTYPE);
        var q = String(map.SEARCHVALUE || '').trim().toLowerCase();
        rows = rows.filter(function (h) { return String(h[map.SEARCHTYPE]).toLowerCase().indexOf(q) > -1; });
      }
      rows = rows.map(function (h) {
        var r = clone(h);
        var fav = favs.some(function (f) { return String(f.H_IDX) === String(h.H_IDX) && f.ID === session.ID; });
        r.FAV = fav ? session.ID : null;
        r.RATE = rateOf(h.H_IDX);
        return r;
      });
      if (query === 'hplist.selectRateHpList') {
        // 평가가 있는 병원만(INNER JOIN), 평점 높은 순.
        // [보정] 로그인 상태 분기의 SQL 은 H_IDX 역순으로 정렬해 '평가 우수병원' 순서가 아니었다.
        rows = rows.filter(function (r) { return r.RATE !== null; });
        rows.sort(function (a, b) { return b.RATE - a.RATE || b.H_IDX - a.H_IDX; });
      } else {
        rows.sort(function (a, b) { return b.H_IDX - a.H_IDX; });
      }

      var lat = 0, lon = 0, minLat = 0, maxLat = 0, minLon = 0, maxLon = 0;
      rows.forEach(function (r, i) {
        r.RNUM = i + 1;
        r.TOTAL_COUNT = rows.length;
        r.HOUR = formatHour(r.ONHOUR, r.OFFHOUR);
        delete r.ONHOUR;
        delete r.OFFHOUR;
        var gps = r.ADDR_GPS.split(',');
        delete r.ADDR_GPS;
        r.LAT = gps[0];
        r.LON = gps[1];
        var tLat = parseFloat(gps[0]), tLon = parseFloat(gps[1]);
        lat += tLat;
        lon += tLon;
        if (minLat === 0) {
          minLat = maxLat = tLat;
          minLon = maxLon = tLon;
        } else {
          minLat = Math.min(minLat, tLat); maxLat = Math.max(maxLat, tLat);
          minLon = Math.min(minLon, tLon); maxLon = Math.max(maxLon, tLon);
        }
        r.DISTANCE = 0; // 위치 기반 검색(주소 찾기·거리순)은 데모에서 지원하지 않는다.
      });
      var zoom = gpsToMeter(minLat, maxLat, minLon, maxLon);
      var level = 0;
      for (var i = 0; i < ZOOM_DEFAULT.length; i++) {
        if (ZOOM_DEFAULT[i] > zoom) { level = Math.max(i - 1, 0); break; }
      }
      rows.push({ C_LAT: rows.length ? lat / rows.length : 0, C_LON: rows.length ? lon / rows.length : 0, zoom: level });
      return { list: rows, TOTAL: rows.length > 1 ? rows[0].TOTAL_COUNT : 0 };
    }

    // ---------- 병원 상세 (HpListServiceImpl.selectHpDetail) ----------
    function selectHpDetail(hIdx) {
      var h = hospital(hIdx);
      if (!h) return null;
      var r = clone(h);
      r.RATE = rateOf(h.H_IDX);
      r.HOUR = formatHour(r.ONHOUR, r.OFFHOUR);
      delete r.ONHOUR;
      delete r.OFFHOUR;
      return r;
    }

    // ---------- 메인 (MainController.mainForm) ----------
    function selectCount() {
      var raters = {};
      fx.RATING.concat(state().RATING).forEach(function (r) { raters[r.ID] = true; });
      return [
        { HPCOUNT: fx.HOSPITAL.length },
        { RATECOUNT1: Object.keys(raters).length },
        { RATECOUNT2: fx.RATING.length + state().RATING.length },
        { MEMBERCOUNT: fx.MEMBER.length - 1 }
      ];
    }

    function selectReview() {
      var names = {};
      fx.MEMBER.forEach(function (m) { names[m.ID] = m.NAME; });
      return fx.RATING.concat(state().RATING).slice()
        .sort(function (a, b) { return a.REG < b.REG ? 1 : a.REG > b.REG ? -1 : 0; })
        .slice(0, 6)
        .map(function (r, i) {
          return {
            NAME: names[r.ID], HOSP: hospital(r.H_IDX).HOSP, COMM: r.COMM,
            REG: r.REG.replace(/-/g, '.'), RATE: (r.RATE1 + r.RATE2 + r.RATE3 + r.RATE4) / 4, RN: i + 1
          };
        });
    }

    // ---------- 예약 (ReservController / ReservServiceImpl) ----------
    function selectReservHpList(map) {
      // reserv_SQL.xml selectHpList: REG_CHK = 'Y' [AND H_IDX = #{H_IDX}]
      return fx.HOSPITAL
        .filter(function (h) { return h.REG_CHK === 'Y' && (!map.H_IDX || String(h.H_IDX) === String(map.H_IDX)); })
        .map(function (h) { return { H_IDX: h.H_IDX, HOSP: h.HOSP, MAJOR: h.MAJOR }; });
    }

    function selectDate(map) {
      var h = hospital(map.H_IDX);
      if (!h || h.REG_CHK !== 'Y') return [];
      var date = map.year + '/' + pad2(parseInt(map.month, 10)) + '/' + pad2(parseInt(map.day, 10));
      return availableTimes(h, state().RESERVATION, date, nowFn());
    }

    function insertReserv(map) {
      var s = state();
      var now = nowFn();
      var h = hospital(map.H_IDX);
      var reserv1 = map.YEAR + '/' + map.MONTH + '/' + map.DAY; // ReservController.reservation
      // [보정] 원본은 입력값을 검증하지 않았다(예: 시간 미선택 '0' 저장). 데모는 서버 쪽 검증을 둔다.
      if (!h || h.REG_CHK !== 'Y') return { code: 3, message: '예약할 수 없는 병원입니다.' };
      if (map.CURED !== h.MAJOR) return { code: 3, message: '진료과목을 다시 선택해주세요.' };
      if (!/^\d{4}\/\d{2}\/\d{2}$/.test(reserv1)) return { code: 3, message: '예약일을 다시 선택해주세요.' };
      if (!/^\d{2}:\d{2}$/.test(String(map.RESERV2))) return { code: 3, message: '예약시간을 선택해주세요.' };
      if (availableTimes(h, s.RESERVATION, reserv1, now).indexOf(map.RESERV2) < 0) {
        return { code: 3, message: '선택한 시간은 예약할 수 없습니다. 다른 시간을 선택해주세요.' };
      }
      if (s.POINT < RESERV_POINT) return { code: 1, POINT: s.POINT };
      // [보정] 원본 안내는 "한 병원당 한 번만"이지만 SQL 은 같은 날짜만 막았다. 취소가 H_IDX 단위라
      //        같은 병원 예약이 여러 건이면 한꺼번에 취소되므로, 안내 문구대로 병원당 유효 예약 1건만 허용한다.
      var dup = s.RESERVATION.some(function (r) {
        return r.ID === session.ID && r.DEL_CHK === 'B' && String(r.H_IDX) === String(h.H_IDX);
      });
      if (dup) return { code: 2, POINT: s.POINT };
      s.POINT -= RESERV_POINT; // mypage_SQL.xml updatePoint2
      s.RESERVATION.push({
        NUM: s.RESERV_SEQ++, H_IDX: h.H_IDX, ID: session.ID, CURED: map.CURED,
        RESERV1: reserv1, RESERV2: map.RESERV2, DEL_CHK: 'B', STATE: '미완료'
      });
      store.save(s);
      return { code: 0, POINT: s.POINT };
    }

    function pastReserv(s, now) {
      // reserv_SQL.xml pastReserv: DEL_CHK 'B' → 'A' (RESERV1 < 오늘)
      var today = dateKey(now);
      var changed = false;
      s.RESERVATION.forEach(function (r) {
        if (r.ID === session.ID && r.DEL_CHK === 'B' && r.RESERV1 < today) {
          r.DEL_CHK = 'A';
          changed = true;
        }
      });
      if (changed) store.save(s);
    }

    function joinHosp(r) {
      var h = hospital(r.H_IDX);
      return {
        NUM: r.NUM, H_IDX: r.H_IDX, ID: r.ID, HOSP: h ? h.HOSP : '', CURED: r.CURED,
        RESERV1: r.RESERV1, RESERV2: r.RESERV2, DEL_CHK: r.DEL_CHK
      };
    }

    function byReservDate(a, b) {
      // ROW_NUMBER() OVER (ORDER BY RESERV1 DESC) RNUM ... ORDER BY RNUM DESC → 예약일 오름차순
      var ka = a.RESERV1 + ' ' + a.RESERV2, kb = b.RESERV1 + ' ' + b.RESERV2;
      return ka < kb ? -1 : ka > kb ? 1 : 0;
    }

    function selectReservation() {
      var s = state();
      pastReserv(s, nowFn());
      return s.RESERVATION
        .filter(function (r) { return r.ID === session.ID && r.DEL_CHK === 'B'; })
        .sort(byReservDate)
        .map(function (r, i) { var o = joinHosp(r); o.RNUM = i + 1; return o; });
    }

    function selectPastReservation() {
      var s = state();
      // [보정] 원본은 '예약내역' 화면을 열 때만 지난 예약을 만료 처리했다. 지난 예약 화면에서도 같은 처리를 한다.
      pastReserv(s, nowFn());
      return s.RESERVATION
        .filter(function (r) { return r.ID === session.ID && r.DEL_CHK !== 'B'; })
        .sort(byReservDate)
        .map(function (r, i) {
          var o = joinHosp(r);
          o.RNUM = i + 1;
          o.STATE = r.DEL_CHK === 'A' ? '기간만료' : r.DEL_CHK === 'C' ? '예약취소' : r.STATE;
          return o;
        });
    }

    function cancelReserv(map) {
      // ReservServiceImpl.cancelReserv: H_IDX 를 ',' 로 나눠 병원 단위로 취소하고 포인트를 돌려준다.
      var s = state();
      var now = nowFn();
      var limit = now.getTime() + BOOKING_LEAD_MINUTES * 60000;
      var ids = String(map.H_IDX || '').split(',').filter(Boolean);
      var cancelled = [], blocked = [];
      ids.forEach(function (id) {
        s.RESERVATION.forEach(function (r) {
          // [보정] 원본 UPDATE 에는 DEL_CHK 조건이 없어 이미 기간만료된 예약까지 '예약취소'로 바꿨다.
          if (r.ID !== session.ID || String(r.H_IDX) !== id || r.DEL_CHK !== 'B') return;
          var p = r.RESERV1.split('/');
          var at = new Date(+p[0], +p[1] - 1, +p[2], +r.RESERV2.substring(0, 2), +r.RESERV2.substring(3, 5)).getTime();
          if (at < limit) {
            blocked.push(r.NUM);
            return;
          }
          r.DEL_CHK = 'C';
          s.POINT += RESERV_POINT; // mypage_SQL.xml returnPoint
          cancelled.push(r.NUM);
        });
      });
      store.save(s);
      return { cancelled: cancelled, blocked: blocked };
    }

    // RateController / RateServiceImpl: insertRating followed by updateState.
    // Local demo validation only; this is not a claim about the original server.
    function ratingReservation(map) {
      var s = state(); pastReserv(s, nowFn());
      return s.RESERVATION.find(function (r) {
        return String(r.NUM) === String(map.NUM) && r.ID === session.ID && r.DEL_CHK === 'A' &&
          String(r.H_IDX) === String(map.H_IDX) && r.RESERV1 === map.RESERV1;
      });
    }
    function insertRating(map) {
      var visit = ratingReservation(map);
      if (!visit || (map.ID && map.ID !== session.ID)) throw new MockError('본인의 지난 방문만 평가할 수 있습니다.');
      var s = state();
      if (visit.STATE === '완료' || s.RATING.some(function (r) { return r.NUM === visit.NUM; })) throw new MockError('이미 작성한 후기입니다.');
      var review = { NUM: visit.NUM, H_IDX: visit.H_IDX, ID: session.ID, RESERV1: visit.RESERV1, REG: dateKey(nowFn()).replace(/\//g, '-'), COMM: String(map.COMM || '').trim() };
      for (var i = 1; i <= 4; i++) {
        if (!/^[1-5]$/.test(String(map['RATE' + i]))) throw new MockError('네 가지 평가를 모두 선택해주세요.');
        review['RATE' + i] = Number(map['RATE' + i]);
      }
      if (!review.COMM || review.COMM.length > 500) throw new MockError('후기를 1~500자로 작성해주세요.');
      s.RATING.push(review);
      s.RESERVATION.forEach(function (r) { if (r.NUM === visit.NUM) r.STATE = '완료'; });
      store.save(s);
      return review;
    }
    function ratingList() {
      var s = state(); pastReserv(s, nowFn());
      return s.RESERVATION.filter(function (r) { return r.ID === session.ID && r.DEL_CHK === 'A'; }).map(function (r) {
        var review = s.RATING.find(function (x) { return x.NUM === r.NUM; });
        return { NUM: r.NUM, H_IDX: r.H_IDX, ID: session.ID, HOSP: hospital(r.H_IDX).HOSP, NAME: session.NAME,
          RESERV1: r.RESERV1, REG: review ? review.REG : '—', STATE: review ? '완료' : '미완료' };
      });
    }

    // ---------- 관심병원 (MypageController / mypage_SQL.xml) ----------
    function insertFav(map) {
      var s = state();
      var exists = s.FAV.some(function (f) { return String(f.H_IDX) === String(map.H_IDX) && f.ID === session.ID; });
      if (!hospital(map.H_IDX)) throw new MockError('없는 병원입니다: ' + map.H_IDX);
      if (!exists) {
        s.FAV.push({ H_IDX: parseInt(map.H_IDX, 10), ID: session.ID });
        store.save(s);
      }
    }

    function delFavHp(map) {
      // [보정] 원본 DELETE 는 H_IDX = '1,2' 처럼 여러 건을 한 번에 지우지 못했다. ',' 로 나눠 지운다.
      var s = state();
      var ids = String(map.H_IDX || '').split(',');
      s.FAV = s.FAV.filter(function (f) { return !(f.ID === session.ID && ids.indexOf(String(f.H_IDX)) > -1); });
      store.save(s);
    }

    function selectFavList() {
      return state().FAV
        .filter(function (f) { return f.ID === session.ID; })
        .map(function (f) {
          var h = hospital(f.H_IDX);
          return { H_IDX: h.H_IDX, HOSP: h.HOSP, TEL: h.TEL, ADDR: h.ADDR };
        });
    }

    // ---------- ComAjax 라우팅 (jsonView 응답 모양 그대로) ----------
    function handleAjax(url, p) {
      switch (url) {
        case '/hospital/hplist/selectHpList':
          return selectBoardList(p);
        case '/hospital/reserv/SelectHospitalList': {
          var list = selectReservHpList(p);
          return list.length ? { list: list } : { list: list, TOTAL: 0 };
        }
        case '/hospital/reserv/SelectMajorList': {
          var majors = selectReservHpList(p);
          return majors.length ? { list: majors } : { list: majors, MAJOR_TOTAL: 0 };
        }
        case '/hospital/reserv/SelectDate':
          return { H_IDX: p.H_IDX, HOSP: p.HOSP, MAJOR: p.MAJOR };
        case '/hospital/reserv/ReservDate':
          return {
            H_IDX: p.H_IDX, HOSP: p.HOSP, MAJOR: p.MAJOR,
            YEAR: p.year, MONTH: p.month, DAY: p.day, TIMELIST: selectDate(p)
          };
        case '/hospital/reserv/ReservResult':
          return {
            H_IDX: p.H_IDX, HOSP: p.HOSP, MAJOR: p.MAJOR,
            YEAR: p.YEAR, MONTH: p.MONTH, DAY: p.DAY, TIME: p.TIME
          };
        case '/hospital/reserv/Reservation': {
          var r = insertReserv(p);
          var out = { STEP: p.STEP, reservFalse: r.code, POINT: r.POINT };
          if (r.message) out.message = r.message;
          return out;
        }
        case '/hospital/mypage/InsertFav':
          insertFav(p);
          return {};
        case '/hospital/mypage/DelFavHp':
          delFavHp(p);
          return {};
        default:
          throw new MockError('모의 백엔드에 없는 요청입니다: ' + url);
      }
    }

    // 서버가 JSP 를 그릴 때 넘기던 모델 중 브라우저 저장소에 따라 달라지는 값
    function pageModel(route) {
      switch (route) {
        case '/hospital/main': return { reviewlist: selectReview() };
        case '/hospital/rate/RatingList': return { list: ratingList() };
        case '/hospital/reserv/MyReserv':
          return { list: selectReservation() };
        case '/hospital/reserv/MyPastReserv':
          return { list: selectPastReservation() };
        case '/hospital/mypage/OpenMypageFavhp':
          return { list: selectFavList() };
        default:
          return {};
      }
    }

    return {
      state: state,
      insertRating: insertRating,
      ratingList: ratingList,
      ratingReservation: ratingReservation,
      handleAjax: handleAjax,
      pageModel: pageModel,
      selectBoardList: selectBoardList,
      selectHpDetail: selectHpDetail,
      selectCount: selectCount,
      selectReview: selectReview,
      selectDate: selectDate,
      insertReserv: insertReserv,
      selectReservation: selectReservation,
      selectPastReservation: selectPastReservation,
      cancelReserv: cancelReserv,
      insertFav: insertFav,
      delFavHp: delFavHp,
      selectFavList: selectFavList
    };
  }

  function memoryStore(initial) {
    var data = initial === undefined ? null : clone(initial);
    return {
      load: function () { return data === null ? null : clone(data); },
      save: function (s) { data = clone(s); }
    };
  }

  return {
    createBackend: createBackend,
    memoryStore: memoryStore,
    timeSlots: timeSlots,
    availableTimes: availableTimes,
    isValidState: isValidState,
    dateKey: dateKey,
    MockError: MockError,
    AJAX_ROUTES: AJAX_ROUTES,
    PAGE_ROUTES: PAGE_ROUTES,
    ACTION_ROUTES: ACTION_ROUTES,
    BOOKING_DAYS_AHEAD: BOOKING_DAYS_AHEAD,
    BOOKING_LEAD_MINUTES: BOOKING_LEAD_MINUTES,
    RESERV_POINT: RESERV_POINT
  };
});
