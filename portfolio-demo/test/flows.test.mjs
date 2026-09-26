// 생성된 화면을 jsdom 에서 실제로 실행해(원본 jQuery 스크립트 + 모의 어댑터) 사용자 흐름을 확인한다.
// 브라우저 대신 DOM 구현을 쓰므로 배치(레이아웃)·가로 넘침은 여기서 확인하지 않는다.
import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { JSDOM, ResourceLoader, VirtualConsole } from 'jsdom';

const DIST = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', 'dist');
const ORIGIN = 'http://demo.local';
const KEY = 'drher-demo:v1';

class DistLoader extends ResourceLoader {
  constructor(external) {
    super();
    this.external = external;
  }
  fetch(url) {
    const u = new URL(url);
    if (u.origin !== ORIGIN) {
      this.external.push(url);
      return null;
    }
    const file = path.join(DIST, decodeURIComponent(u.pathname));
    if (!fs.existsSync(file) || fs.statSync(file).isDirectory()) return Promise.reject(new Error('404 ' + u.pathname));
    return Promise.resolve(fs.readFileSync(file));
  }
}

const tick = (ms = 30) => new Promise((r) => setTimeout(r, ms));

async function open(urlPath, { storage = null, confirm = true } = {}) {
  const external = [];
  const errors = [];
  const alerts = [];
  const navigations = [];
  const vc = new VirtualConsole();
  vc.on('jsdomError', (e) => {
    // jsdom 의 CSS 파서는 원본 스타일시트(bootstrap/ui/style.css)의 느슨한 문법을 거부한다. 브라우저는 읽으므로 스크립트 오류만 센다.
    if (/^Could not parse CSS stylesheet/.test(e.message)) return;
    errors.push(e.message + (e.detail ? ' :: ' + (e.detail.message || e.detail) : ''));
  });
  const file = path.join(DIST, new URL(urlPath, ORIGIN).pathname, 'index.html');
  const dom = new JSDOM(fs.readFileSync(file, 'utf8'), {
    url: ORIGIN + urlPath,
    runScripts: 'dangerously',
    resources: new DistLoader(external),
    pretendToBeVisual: true,
    virtualConsole: vc,
    beforeParse(window) {
      if (storage !== null) window.localStorage.setItem(KEY, storage);
      window.alert = (m) => alerts.push(String(m));
      window.confirm = () => confirm;
      window.scrollTo = () => {};
    },
  });
  const { window } = dom;
  await new Promise((resolve) => window.addEventListener('load', resolve));
  window.DrHerDemo.navigate = (u) => navigations.push(u);
  await tick();
  const $ = window.jQuery;
  return {
    window, $, external, errors, alerts, navigations,
    dialog: () => window.document.getElementById('dialogboxbody').innerHTML,
    storage: () => window.localStorage.getItem(KEY),
    state: () => JSON.parse(window.localStorage.getItem(KEY)),
    click: async (sel) => { $(sel).first().trigger('click'); await tick(); },
    close: () => window.close(),
  };
}

function clean(page, label) {
  assert.deepEqual(page.external, [], `${label}: no external requests`);
  assert.deepEqual(page.errors, [], `${label}: no script errors`);
}

test('메인: 원본 메인 화면이 모의 데이터로 뜨고, 버튼은 모의 경로로 이동한다', async () => {
  const p = await open('/hospital/main/');
  const $ = p.$;
  assert.equal($('.demo-notice').text().includes('실제 예약이 이루어지지 않습니다'), true);
  assert.equal($('.care-review').length, 6);
  assert.equal($('.stat-number,.slider-container,.partner-logo').length, 0);
  assert.equal($('.care-next a').length, 3);
  $('#careQuery').val('소아'); $('#careType').val('MAJOR'); $('#careSearch').trigger('submit');
  const list = new URL(p.navigations[0], ORIGIN);
  assert.equal(list.pathname, '/hospital/hplist/List/');
  assert.equal(list.searchParams.get('SEARCHTYPE'), 'MAJOR');
  assert.equal(list.searchParams.get('SEARCHVALUE'), '소아');
  assert.equal(p.navigations.length, 1);
  clean(p, 'main');
  p.close();
});

test('병원 목록: 원본 콜백이 목록을 그리고, 검색·빈 결과·관심병원·상세/예약 이동이 동작한다', async () => {
  const p = await open('/hospital/hplist/List/?boardTitle=%EC%98%88%EC%95%BD%20%EA%B0%80%EB%8A%A5%ED%95%9C%20%EB%B3%91%EC%9B%90&LIST=selectHpList&QUERY=hplist.selectAllHpList&REG_CHK=Y');
  const $ = p.$;
  assert.equal($('.Tiles_wrap > h2').text(), '예약 가능한 병원');
  assert.equal($('#REG_CHK').val(), 'Y');
  assert.equal($('#listForm td.Hp_list').length, 8);
  assert.equal($("input[name='REG']").length, 8, 'every REG_CHK=Y hospital shows 예약가능');

  $('#SEARCHTYPE').val('MAJOR');
  $('#SEARCHVALUE').val('소아');
  await p.click('#SEARCH');
  assert.deepEqual([...$("a[name='title']").map((i, a) => $(a).text()).get()], ['새싹소아과의원', '강변어린이병원']);

  $('#SEARCHTYPE').val('HOSP');
  $('#SEARCHVALUE').val('없는병원');
  await p.click('#SEARCH');
  assert.match($('#listForm').text(), /검색 결과가 없습니다/);

  $('#SEARCHTYPE').val('');
  $('#SEARCHVALUE').val('내과');
  await p.click('#SEARCH');
  assert.match(p.dialog(), /검색 조건/);

  $('#SEARCHTYPE').val('ADDR');
  $('#SEARCHVALUE').val('햇살동');
  await p.click('#SEARCH');
  assert.equal($("a[name='title']").length, 1, '햇살동: 햇살내과의원 (맑은피부과는 예약 미참여라 제외)');
  const star = $("img[name='FAVCheck']").first();
  assert.equal(star.attr('data-fav'), 'N');
  star.trigger('click');
  await tick();
  assert.equal(star.attr('src'), '/hospital/demo/img/fav-on.svg');
  assert.deepEqual(p.state().FAV.map((f) => f.H_IDX).sort(), [1, 2]);

  await p.click("a[name='title']");
  await p.click("input[name='REG']");
  assert.deepEqual(p.navigations, ['/hospital/hplist/HpDetail/1/', '/hospital/reserv/OpenReserv/?H_IDX=1']);
  assert.equal($('#distance').prop('disabled'), true);
  clean(p, 'list');
  p.close();
});

test('병원 목록: 파라미터 없이 열어도 전체 병원(10곳)을 보여 준다', async () => {
  const p = await open('/hospital/hplist/List/');
  assert.equal(p.$('.Tiles_wrap > h2').text(), '전체 병원 검색');
  assert.equal(p.$('#listForm td.Hp_list').length, 10);
  clean(p, 'list-default');
  p.close();
});

test('병원 상세: 원본 상세 표와 예약 버튼(예약 가능 병원만)', async () => {
  const p = await open('/hospital/hplist/HpDetail/1/');
  assert.match(p.$('.board_view').text(), /햇살내과의원[\s\S]*09:00 ~ 18:00/);
  await p.click("input[name='REG']");
  assert.deepEqual(p.navigations, ['/hospital/reserv/OpenReserv/?H_IDX=1']);
  clean(p, 'detail');
  p.close();
  const q = await open('/hospital/hplist/HpDetail/4/');
  assert.equal(q.$("input[name='REG']").length, 0);
  clean(q, 'detail-4');
  q.close();
});

async function bookFirstSlot(p, { pickLastDay = true } = {}) {
  const $ = p.$;
  await p.click("a[name='hosp']");
  await p.click("a[name='major']");
  const days = $("a[name='cal']");
  assert.ok(days.length >= 1 && days.length <= 8, `bookable days: ${days.length}`);
  (pickLastDay ? days.last() : days.first()).trigger('click');
  await tick();
  const options = $('#reservTime option');
  assert.ok(options.length > 1, 'time options');
  const time = options.eq(1).val();
  $('#reservTime').val(time).trigger('change');
  await tick();
  return time;
}

test('예약: 병원 → 진료과목 → 날짜 → 시간 → 확인 → 예약, 필수 선택·중복 예약 안내', async () => {
  const p = await open('/hospital/reserv/OpenReserv/?H_IDX=7');
  const $ = p.$;
  assert.equal($('#H_IDX').val(), '7');
  assert.deepEqual([...$("a[name='hosp']").map((i, a) => $(a).text()).get()], ['하얀미소치과']);

  await p.click('#reservation');
  assert.match(p.alerts.at(-1), /모두 선택/, 'required selection message before choosing a time');

  const time = await bookFirstSlot(p);
  assert.match($('#reservResult').text(), /병원명 :하얀미소치과[\s\S]*진료과목 :치과/);
  const [y, m, d] = [$('#reservResult #YEAR').val(), $('#reservResult #MONTH').val(), $('#reservResult #DAY').val()];
  assert.match(`${y}/${m}/${d}`, /^\d{4}\/\d{2}\/\d{2}$/, 'month and day are zero padded');

  $('#reservTime').val('0').trigger('change');
  await tick();
  assert.equal($('#reservResult').text().trim(), '', 'choosing ---선택--- clears the confirmation');
  $('#reservTime').val(time).trigger('change');
  await tick();

  await p.click('#reservation');
  assert.deepEqual(p.navigations, ['/hospital/reserv/MyReserv/?STEP=reserv']);
  const s = p.state();
  const r = s.RESERVATION.find((x) => x.H_IDX === 7);
  assert.equal(r.DEL_CHK, 'B');
  assert.equal(r.RESERV2, time);
  assert.equal(r.CURED, '치과');
  assert.equal(s.POINT, 900);

  // 같은 병원 다시 예약 → 원본 안내 문구
  await bookFirstSlot(p); // 마지막 예약 가능일(오늘+7)은 시각과 무관하게 빈 시간이 있다
  await p.click('#reservation');
  assert.equal(p.alerts.at(-1), '예약은 한 병원당 한 번만 가능합니다.');
  clean(p, 'reserv');
  p.close();
});

test('예약: 병원을 다시 고르면 이전 날짜·시간·확인 내용이 지워진다 (H_IDX 없이 열면 예약 가능 병원 전체)', async () => {
  const p = await open('/hospital/reserv/OpenReserv/');
  const $ = p.$;
  assert.equal($("a[name='hosp']").length, 8);
  await bookFirstSlot(p);
  assert.ok($('#reservResult #TIME').length);
  $("a[name='hosp']").eq(1).trigger('click');
  await tick();
  assert.equal($('#reservResult').children().length, 0);
  assert.equal($('#calendar a[name="cal"]').length, 0);
  assert.equal($('#reservdate').children().length, 0);
  clean(p, 'reserv-reset');
  p.close();
});

test('포인트가 부족하면 결제 대신 모의 포인트 안내', async () => {
  const seed = JSON.stringify({ version: 1, POINT: 50, RESERV_SEQ: 1, RESERVATION: [], FAV: [] });
  const p = await open('/hospital/reserv/OpenReserv/?H_IDX=1', { storage: seed });
  await bookFirstSlot(p);
  await p.click('#reservation');
  assert.match(p.alerts.at(-1), /모의 포인트가 부족합니다[\s\S]*현재 포인트는: 50/);
  assert.equal(p.navigations.length, 0);
  assert.equal(p.$('.point_payment').length, 0);
  clean(p, 'point');
  p.close();
});

test('내 예약: 목록 → 선택 취소(포인트 반환) → 지난 예약에 예약취소/기간만료 표시', async () => {
  const future = new Date(Date.now() + 3 * 86400000);
  const pad = (n) => String(n).padStart(2, '0');
  const date = `${future.getFullYear()}/${pad(future.getMonth() + 1)}/${pad(future.getDate())}`;
  const seed = JSON.stringify({
    version: 1, POINT: 900, RESERV_SEQ: 3,
    RESERVATION: [
      { NUM: 1, H_IDX: 3, ID: 'demo', CURED: '정형외과', RESERV1: '2026/08/14', RESERV2: '10:30', DEL_CHK: 'A', STATE: '미완료' },
      { NUM: 2, H_IDX: 5, ID: 'demo', CURED: '이비인후과', RESERV1: date, RESERV2: '11:00', DEL_CHK: 'B', STATE: '미완료' },
    ],
    FAV: [],
  });
  const p = await open('/hospital/reserv/MyReserv/?STEP=reserv', { storage: seed });
  const $ = p.$;
  const rows = $('.myReservList tbody tr');
  assert.equal(rows.length, 1);
  assert.match(rows.text(), new RegExp(`2[\\s\\S]*${date}[\\s\\S]*11:00[\\s\\S]*숲속이비인후과`));
  assert.equal($('template').length, 0, 'runtime templates expanded');

  await p.click("a[name='cancel']");
  assert.equal(p.alerts.at(-1), '예약취소할 병원을 선택하세요');
  $("input[name='checkRow']").prop('checked', true);
  await p.click("a[name='cancel']");
  assert.deepEqual(p.navigations, ['/hospital/reserv/MyReserv/?STEP=reserv']);
  const after = p.state();
  assert.equal(after.RESERVATION.find((r) => r.NUM === 2).DEL_CHK, 'C');
  assert.equal(after.POINT, 1000);
  clean(p, 'myreserv');
  p.close();

  const empty = await open('/hospital/reserv/MyReserv/?STEP=reserv', { storage: JSON.stringify(after) });
  assert.match(empty.$('.myReservList tbody').text(), /조회된 결과가 없습니다/);
  empty.close();

  const past = await open('/hospital/reserv/MyPastReserv/?STEP=pastreserv', { storage: JSON.stringify(after) });
  const text = past.$('.myReservList tbody').text();
  assert.match(text, /바른걸음정형외과[\s\S]*기간만료/);
  assert.match(text, /숲속이비인후과[\s\S]*예약취소/);
  assert.equal(past.$("a[name='cancel']").length, 0);
  clean(past, 'past');
  past.close();
});

test('관심병원: 목록 → 병원명으로 상세 이동 → 선택 삭제', async () => {
  const p = await open('/hospital/mypage/OpenMypageFavhp/');
  const $ = p.$;
  assert.match($('.FavList tbody').text(), /강변어린이병원[\s\S]*000-0102-0002/);
  await p.click(".FavList a[name='title']");
  assert.deepEqual(p.navigations, ['/hospital/hplist/HpDetail/2/']);
  $("input[name='checkRow']").prop('checked', true);
  await p.click("a[name='delFavHp']");
  assert.equal(p.navigations[1], '/hospital/mypage/OpenMypageFavhp/');
  assert.deepEqual(p.state().FAV, []);
  clean(p, 'fav');
  p.close();
});

test('헤더: 지원 메뉴만 보이고, 내 예약 드롭다운은 모의 경로로 이동한다', async () => {
  const p = await open('/hospital/main/');
  const $ = p.$;
  assert.deepEqual([...$('.header .menu a').map((i, a) => $(a).text()).get()], ['병원검색']);
  assert.equal($('#logout').length + $('#loginForm').length, 0);
  await p.click("a[name='mypageList'][id='reserv/MyPastReserv']");
  await p.click("a[name='HpList']#RATE");
  assert.equal(p.navigations[0], '/hospital/reserv/MyPastReserv/?STEP=pastreserv');
  assert.equal(new URL(p.navigations[1], ORIGIN).searchParams.get('QUERY'), 'hplist.selectRateHpList');
  clean(p, 'header');
  p.close();

  const rate = await open(p.navigations[1]);
  assert.equal(rate.$('#listForm td.Hp_list').length, 8);
  assert.match(rate.$("a[name='title']").first().text(), /하얀미소치과/);
  clean(rate, 'rate');
  rate.close();
});

test('저장값: 손상되면 초기화 안내, 데모 초기화 버튼은 저장값을 지운다', async () => {
  const p = await open('/hospital/main/', { storage: '{not json' });
  assert.match(p.dialog(), /손상되어 처음 상태로/);
  assert.equal(p.state().POINT, 1000);
  await p.click('#demoReset');
  assert.equal(p.storage(), null);
  assert.deepEqual(p.navigations, ['/hospital/main/']);
  p.close();
});

test('모의 처리되지 않은 요청은 명시적으로 실패한다', async () => {
  const p = await open('/hospital/main/');
  const w = p.window;
  assert.throws(() => w.jQuery.ajax({ url: '/x' }), /모의 처리되지 않은 네트워크 요청/);
  assert.throws(() => { const s = new w.ComSubmit(); s.setUrl('/hospital/qna/writeform'); s.submit(); }, /지원하지 않는 기능/);
  assert.equal(p.navigations.length, 0);
  p.close();
});

test('후기: 지난 방문 목록 → 네 항목 검증 → 저장 → 재로딩 완료와 홈·상세 평점 반영 → 초기화', async () => {
  const list = await open('/hospital/rate/RatingList/');
  assert.equal(list.$('a[name=rate]').length,1);
  await list.click('a[name=rate]');
  const target=list.navigations[0]; clean(list,'rating-list'); list.close();
  const form=await open(target);
  form.window.fn_Rating();
  assert.match(form.$('#rateError').text(),/네 가지/);
  assert.equal(form.state().RATING.length,0);
  for(let i=1;i<=4;i++) form.$('input[name=rate'+i+'][value=5]').prop('checked',true);
  form.$('#COMM').val('좋은 방문 경험 <script>bad</script>'); form.window.fn_Rating();
  assert.equal(form.state().RATING.length,1);
  form.window.fn_Rating(); assert.equal(form.state().RATING.length,1,'double click stays single');
  assert.equal(form.navigations[0],'/hospital/rate/RatingList/?saved=1');
  const saved=form.storage(); clean(form,'rating-form'); form.close();
  const done=await open('/hospital/rate/RatingList/?saved=1',{storage:saved});
  assert.equal(done.$('a[name=rate]').length,0); assert.match(done.$('#ratingSaved').text(),/저장되었습니다/);
  assert.match(done.$('.RateList').text(),/작성 완료/); clean(done,'rating-done'); done.close();
  const repeat=await open(target,{storage:saved}); assert.equal(repeat.$('#rate').prop('disabled'),true); clean(repeat,'rating-repeat'); repeat.close();
  const home=await open('/hospital/main/',{storage:saved}); assert.match(home.$('.care-review').first().text(),/좋은 방문 경험 <script>bad<\/script>/);
  assert.equal(home.$('.care-review script').length,0); clean(home,'review-home'); home.close();
  const detail=await open('/hospital/hplist/HpDetail/3/',{storage:saved}); assert.equal(detail.$('[data-hospital-rate]').text(),'4.63 / 5'); clean(detail,'review-detail');
  await detail.click('#demoReset'); assert.equal(detail.storage(),null); detail.close();
  const reset=await open('/hospital/rate/RatingList/'); assert.equal(reset.$('a[name=rate]').length,1); clean(reset,'review-reset'); reset.close();
});

test('잘못된 후기 직접 진입은 저장 불가이고 홈 진료과 검색이 목록에 반영된다', async()=>{
  const bad=await open('/hospital/rate/OpenRating/?NUM=99&H_IDX=3&RESERV1=2026%2F08%2F14');
  assert.equal(bad.$('#rate').prop('disabled'),true); assert.match(bad.$('#rateError').text(),/본인의/); clean(bad,'rating-invalid');bad.close();
  const list=await open('/hospital/hplist/List/?SEARCHTYPE=MAJOR&SEARCHVALUE=소아');
  assert.equal(list.$('a[name=title]').length,2); clean(list,'home-search');list.close();
});

test('예약: 목록에서 선택한 병원은 다시 클릭하지 않아도 진료과가 열린다', async()=>{
  const p=await open('/hospital/reserv/OpenReserv/?H_IDX=1');
  await tick();
  assert.equal(p.$('#hp td.selected').length,1);
  assert.equal(p.$('#major a[name=major]').text(),'내과');
  clean(p,'preselected-hospital');p.close();
});

test('홈 평가우수 링크는 원본 QUERY 계약으로 평점순 목록을 연다', async()=>{
  const home=await open('/hospital/main/');
  const href=home.$('.care-section-heading>a').attr('href'); home.close();
  const list=await open(href);
  assert.equal(list.$('#QUERY').val(),'hplist.selectRateHpList');
  assert.equal(list.$('a[name=title]').length,8);
  assert.equal(list.$('a[name=title]').first().text(),'하얀미소치과');
  clean(list,'home-rated-link');list.close();
});

test('후기 저장 거절은 입력을 보존하고 버튼을 다시 사용할 수 있게 한다', async()=>{
  const p=await open('/hospital/rate/OpenRating/?NUM=1&H_IDX=3&RESERV1=2026%2F08%2F14');
  for(let i=1;i<=4;i++) p.$('input[name=rate'+i+'][value=4]').prop('checked',true);
  p.$('#COMM').val('재시도할 후기'); p.$('#NUM').val('999'); p.window.fn_Rating();
  assert.match(p.$('#rateError').text(),/본인의/); assert.equal(p.$('#rate').prop('disabled'),false);
  assert.equal(p.$('#COMM').val(),'재시도할 후기'); assert.equal(p.state().RATING.length,0);
  p.$('#NUM').val('1');p.window.fn_Rating();assert.equal(p.state().RATING.length,1);
  clean(p,'rating-retry');p.close();
});

test('원본 ComSubmit: 공백 후기 거절 후 재시도해도 RATE 파라미터는 하나씩만 전송한다', async()=>{
  const p=await open('/hospital/rate/OpenRating/?NUM=1&H_IDX=3&RESERV1=2026%2F08%2F14');
  // Execute the actual source implementation instead of the mock ComSubmit.
  p.window.eval(fs.readFileSync(path.join(DIST,'hospital/js/common.js'),'utf8'));
  const posts=[];
  p.window.HTMLFormElement.prototype.submit=function(){ posts.push([...new p.window.FormData(this).entries()]); };
  for(let i=1;i<=4;i++) p.$('input[name=rate'+i+'][value=4]').prop('checked',true);
  p.$('#COMM').val('   ');p.window.fn_Rating();
  assert.equal(p.$('#commonForm input').length,0);
  assert.equal(posts.length,0);
  p.$('#COMM').val('정상 후기');p.window.fn_Rating();
  assert.equal(posts.length,1);
  for(let i=1;i<=4;i++) assert.deepEqual(posts[0].filter(([key])=>key==='RATE'+i).map(([,v])=>v),['4']);
  assert.equal(posts[0].filter(([key])=>key==='COMM').length,1);
  clean(p,'original-submit-retry');p.close();
});
