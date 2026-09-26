// 모의 백엔드(원본 Java 서비스/매퍼 포팅)의 상태 전이와 규칙 테스트
import test from 'node:test';
import assert from 'node:assert/strict';
import { createRequire } from 'node:module';

const require = createRequire(import.meta.url);
const fx = require('../runtime/fixtures.js');
const MB = require('../runtime/mock-backend.js');

const hosp = (id) => fx.HOSPITAL.find((h) => h.H_IDX === id);

function backendAt(now, seed = fx.SEED_STATE) {
  const store = MB.memoryStore(seed);
  let clock = now;
  const b = MB.createBackend({ fixtures: fx, session: fx.SESSION, store, now: () => clock });
  return { b, store, setNow: (d) => { clock = d; } };
}

function reserveParams(h, date, time) {
  const [Y, M, D] = date.split('/');
  return { H_IDX: String(h.H_IDX), HOSP: h.HOSP, CURED: h.MAJOR, YEAR: Y, MONTH: M, DAY: D, RESERV2: time, STEP: 'reserv' };
}

test('timeSlots follows ONHOUR/OFFHOUR/INTERVALL/MEAL_TIME and stops before closing time', () => {
  const s1 = MB.timeSlots(hosp(1)); // 0900-1800, 30분, 점심 13시
  assert.equal(s1[0], '09:00');
  assert.equal(s1.at(-1), '17:30');
  assert.ok(!s1.includes('13:00') && !s1.includes('13:30'), 'meal hour excluded');
  assert.ok(!s1.includes('18:00') && !s1.includes('18:30'), 'original loop produced slots after OFFHOUR; fixed');
  assert.equal(s1.length, 16);

  const s2 = MB.timeSlots(hosp(2)); // 0830-1730, 20분, 점심 12시
  assert.deepEqual(s2.slice(0, 3), ['08:30', '08:50', '09:10']);
  assert.ok(s2.every((t) => !t.startsWith('12:')));
  assert.equal(s2[s2.indexOf('11:50') + 1], '13:00', 'after the meal hour the original resumes on the hour');
  assert.equal(s2.at(-1), '17:20');

  assert.deepEqual(MB.timeSlots(hosp(7)), ['10:00', '11:00', '12:00', '14:00', '15:00', '16:00', '17:00', '18:00']);
});

test('availableTimes: 오늘은 현재+30분 이후만, 7일 뒤까지만, 예약된 시간 제외', () => {
  const now = new Date(2026, 8, 26, 10, 5);
  const today = '2026/09/26';
  const t = MB.availableTimes(hosp(1), [], today, now);
  assert.equal(t[0], '11:00', '10:30 < 10:35 is excluded');
  assert.deepEqual(MB.availableTimes(hosp(1), [], '2026/09/25', now), [], 'past date');
  assert.deepEqual(MB.availableTimes(hosp(1), [], '2026/10/04', now), [], 'beyond today+7');
  assert.ok(MB.availableTimes(hosp(1), [], '2026/10/03', now).length > 0, 'today+7 (next month) is bookable');
  const booked = [{ H_IDX: 1, RESERV1: '2026/09/28', RESERV2: '09:00', DEL_CHK: 'B' }];
  assert.ok(!MB.availableTimes(hosp(1), booked, '2026/09/28', now).includes('09:00'));
  const cancelled = [{ H_IDX: 1, RESERV1: '2026/09/28', RESERV2: '09:00', DEL_CHK: 'C' }];
  assert.ok(MB.availableTimes(hosp(1), cancelled, '2026/09/28', now).includes('09:00'));
});

test('ReservDate returns TIMELIST for the chosen calendar day (month/day are unpadded like the calendar sends)', () => {
  const { b } = backendAt(new Date(2026, 8, 26, 8, 0));
  const r = b.handleAjax('/hospital/reserv/ReservDate', { H_IDX: '7', HOSP: '하얀미소치과', MAJOR: '치과', year: '2026', month: '10', day: '1' });
  assert.equal(r.YEAR, '2026');
  assert.deepEqual(r.TIMELIST, MB.timeSlots(hosp(7)));
  const closed = b.handleAjax('/hospital/reserv/ReservDate', { H_IDX: '4', year: '2026', month: '9', day: '28' });
  assert.deepEqual(closed.TIMELIST, [], 'REG_CHK N hospital has no slots');
});

test('insertReserv: 0 success (100P 차감), 2 병원당 1건, 1 포인트 부족, 3 입력 오류', () => {
  const now = new Date(2026, 8, 26, 8, 0);
  const { b } = backendAt(now);
  const ok = b.handleAjax('/hospital/reserv/Reservation', reserveParams(hosp(1), '2026/09/28', '09:30'));
  assert.equal(ok.reservFalse, 0);
  assert.equal(ok.POINT, 900);
  const s = b.state();
  const row = s.RESERVATION.find((r) => r.H_IDX === 1);
  assert.deepEqual(
    { NUM: row.NUM, CURED: row.CURED, RESERV1: row.RESERV1, RESERV2: row.RESERV2, DEL_CHK: row.DEL_CHK, STATE: row.STATE },
    { NUM: 2, CURED: '내과', RESERV1: '2026/09/28', RESERV2: '09:30', DEL_CHK: 'B', STATE: '미완료' },
  );
  assert.equal(b.handleAjax('/hospital/reserv/Reservation', reserveParams(hosp(1), '2026/09/29', '10:00')).reservFalse, 2);

  for (const bad of [
    reserveParams(hosp(1), '2026/09/28', '0'),
    reserveParams(hosp(1), '2026/09/28', '09:30'),
    reserveParams(hosp(1), '2026/9/28', '10:00'),
    reserveParams(hosp(4), '2026/09/28', '10:00'),
    { ...reserveParams(hosp(2), '2026/09/28', '09:10'), CURED: '치과' },
    reserveParams(hosp(2), '2026/10/05', '09:10'),
  ]) {
    const r = b.handleAjax('/hospital/reserv/Reservation', bad);
    assert.equal(r.reservFalse, 3, JSON.stringify(bad));
    assert.ok(r.message);
  }

  const poor = backendAt(now, { ...fx.SEED_STATE, POINT: 50 }).b;
  const r1 = poor.handleAjax('/hospital/reserv/Reservation', reserveParams(hosp(2), '2026/09/28', '09:10'));
  assert.equal(r1.reservFalse, 1);
  assert.equal(r1.POINT, 50);
});

test('예약 내역 → 기간만료, 취소(포인트 반환), 30분 전 취소 불가, 지난 예약 상태', () => {
  const { b, setNow } = backendAt(new Date(2026, 8, 26, 8, 0));
  b.insertReserv(reserveParams(hosp(1), '2026/09/28', '09:30'));
  b.insertReserv(reserveParams(hosp(5), '2026/09/26', '09:00'));
  b.insertReserv(reserveParams(hosp(7), '2026/10/02', '10:00'));
  assert.equal(b.state().POINT, 700);

  const list = b.selectReservation();
  assert.deepEqual(list.map((r) => [r.RESERV1, r.HOSP]), [
    ['2026/09/26', '숲속이비인후과'], ['2026/09/28', '햇살내과의원'], ['2026/10/02', '하얀미소치과'],
  ]);

  setNow(new Date(2026, 8, 26, 8, 45)); // 09:00 예약까지 15분 → 취소 불가
  const c = b.cancelReserv({ H_IDX: '5,7' });
  assert.equal(c.blocked.length, 1);
  assert.equal(c.cancelled.length, 1);
  assert.equal(b.state().POINT, 800);

  setNow(new Date(2026, 8, 29, 9, 0)); // 26일·28일 예약은 지남
  assert.deepEqual(b.selectReservation().map((r) => r.HOSP), []);
  const past = b.selectPastReservation();
  const byHosp = Object.fromEntries(past.map((r) => [r.HOSP, r.STATE]));
  assert.deepEqual(byHosp, { 바른걸음정형외과: '기간만료', 숲속이비인후과: '기간만료', 햇살내과의원: '기간만료', 하얀미소치과: '예약취소' });

  const again = b.cancelReserv({ H_IDX: '1' });
  assert.equal(again.cancelled.length, 0, 'expired reservations are not turned into cancellations');
  assert.equal(b.selectPastReservation().find((r) => r.HOSP === '햇살내과의원').STATE, '기간만료');
});

test('병원 목록: 전체/예약가능/평가우수, 검색(병원명·위치·진료과목), 빈 결과, 관심병원 표시', () => {
  const { b } = backendAt(new Date(2026, 8, 26, 8, 0));
  const all = b.handleAjax('/hospital/hplist/selectHpList', { QUERY: 'hplist.selectAllHpList', PAGE_INDEX: '1', PAGE_ROW: '10' });
  assert.equal(all.TOTAL, 10);
  assert.equal(all.list.length, 11, 'last element is the map centre (C_LAT/C_LON/zoom) like the Java service');
  assert.deepEqual(all.list.slice(0, 3).map((r) => r.H_IDX), [10, 9, 8]);
  assert.equal(all.list[0].HOUR, '09:00 ~ 18:00');
  assert.ok('C_LAT' in all.list.at(-1) && 'zoom' in all.list.at(-1));
  assert.equal(all.list.find((r) => r.H_IDX === 2).FAV, 'demo');
  assert.equal(all.list.find((r) => r.H_IDX === 1).FAV, null);

  const reg = b.handleAjax('/hospital/hplist/selectHpList', { QUERY: 'hplist.selectAllHpList', REG_CHK: 'Y' });
  assert.equal(reg.TOTAL, 8);
  assert.ok(reg.list.slice(0, -1).every((r) => r.REG_CHK === 'Y'));

  const search = (SEARCHTYPE, SEARCHVALUE) =>
    b.handleAjax('/hospital/hplist/selectHpList', { QUERY: 'hplist.selectAllHpList', SEARCH_CHK: 'Y', SEARCHTYPE, SEARCHVALUE }).list.slice(0, -1).map((r) => r.H_IDX);
  assert.deepEqual(search('MAJOR', '소아'), [10, 2]);
  assert.deepEqual(search('ADDR', '숲마을'), [10, 8, 5]);
  assert.deepEqual(search('HOSP', '치과'), [7]);
  const none = b.handleAjax('/hospital/hplist/selectHpList', { QUERY: 'hplist.selectAllHpList', SEARCH_CHK: 'Y', SEARCHTYPE: 'HOSP', SEARCHVALUE: '없는병원' });
  assert.equal(none.TOTAL, 0);
  assert.equal(none.list.length, 1);
  assert.throws(() => search('ID', 'x'), /검색 조건/);
  assert.throws(() => b.handleAjax('/hospital/hplist/selectHpList', { QUERY: 'hplist.selectAdminHpList' }), /목록 쿼리/);

  const rate = b.handleAjax('/hospital/hplist/selectHpList', { QUERY: 'hplist.selectRateHpList' }).list.slice(0, -1);
  assert.equal(rate.length, 8, 'only hospitals with ratings');
  assert.equal(rate[0].H_IDX, 7);
  assert.equal(rate[0].RATE, 4.75);
  for (let i = 1; i < rate.length; i++) assert.ok(rate[i - 1].RATE >= rate[i].RATE);
});

test('관심병원: 등록(중복 없음), 여러 건 삭제, 목록', () => {
  const { b } = backendAt(new Date(2026, 8, 26));
  b.handleAjax('/hospital/mypage/InsertFav', { H_IDX: '5' });
  b.handleAjax('/hospital/mypage/InsertFav', { H_IDX: '5' });
  assert.deepEqual(b.selectFavList().map((f) => f.H_IDX), [2, 5]);
  b.delFavHp({ H_IDX: '2,5' });
  assert.deepEqual(b.selectFavList(), []);
});

test('메인 통계·후기와 상세는 원본 컬럼 이름을 쓴다', () => {
  const { b } = backendAt(new Date(2026, 8, 26));
  assert.deepEqual(b.selectCount(), [{ HPCOUNT: 10 }, { RATECOUNT1: 8 }, { RATECOUNT2: 10 }, { MEMBERCOUNT: 9 }]);
  const reviews = b.selectReview();
  assert.equal(reviews.length, 6);
  assert.deepEqual(Object.keys(reviews[0]).sort(), ['COMM', 'HOSP', 'NAME', 'RATE', 'REG', 'RN']);
  assert.equal(reviews[0].REG, '2026.08.25');
  const d = b.selectHpDetail(1);
  assert.equal(d.HOUR, '09:00 ~ 18:00');
  assert.ok(!('ONHOUR' in d) && 'ADDR_GPS' in d && 'DOC_COMM' in d && 'H_COMM' in d);
});

test('손상된 저장값은 초기값으로 되돌리고, 모르는 요청은 명시적으로 실패한다', () => {
  const store = MB.memoryStore({ version: 1, POINT: 'x', RESERVATION: 'nope' });
  const b = MB.createBackend({ fixtures: fx, session: fx.SESSION, store, now: () => new Date(2026, 8, 26) });
  assert.equal(b.state().POINT, 1000);
  assert.ok(MB.isValidState(store.load()));
  assert.throws(() => b.handleAjax('/hospital/member/login', {}), MB.MockError);
});
