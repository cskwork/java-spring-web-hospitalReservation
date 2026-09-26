import { assertNoKnownSecrets } from '../scripts/lib/assert-public.mjs';
// 빌드 산출물 검사: 원본 템플릿에서 나왔는지(출처·해시·원본 마크업 재사용률),
// 남은 JSP 문법·외부 요청·비밀값·죽은 링크가 없는지.
// 실행 전 `node scripts/build.mjs` 로 dist/ 를 만든다(npm test 가 함께 실행).
import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import { fileURLToPath } from 'node:url';
import { createRequire } from 'node:module';
import { DEMO_PATCHES, DEMO_NOTICE } from '../scripts/lib/demo-patches.mjs';
import { applyPatches } from '../scripts/lib/jsp-render.mjs';

const require = createRequire(import.meta.url);
const MB = require('../runtime/mock-backend.js');
const DEMO = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const DIST = path.join(DEMO, 'dist');
const WEBAPP = path.join(DEMO, '..', 'src/main/webapp');
const read = (rel) => fs.readFileSync(path.join(DIST, rel), 'utf8');
const provenance = JSON.parse(read('hospital/demo/provenance.json'));
const pages = provenance.pages.map((p) => ({ ...p, html: read(p.output) }));
const sha = (abs) => crypto.createHash('sha256').update(fs.readFileSync(abs)).digest('hex');

test('every generated page records its original sources, and the hashes match the current originals', () => {
  assert.equal(pages.length, 18);
  const tiles = fs.readFileSync(path.join(WEBAPP, 'WEB-INF/tiles.xml'), 'utf8');
  assert.equal(provenance.tiles.sha256, sha(path.join(WEBAPP, 'WEB-INF/tiles.xml')));
  for (const p of pages) {
    const files = p.sources.map((s) => s.path);
    for (const f of ['WEB-INF/views/layout.jsp', 'WEB-INF/views/header.jsp', 'WEB-INF/views/footer.jsp']) assert.ok(files.includes(f), `${p.output} uses ${f}`);
    // 본문 템플릿은 tiles.xml 의 mainForm 속성값과 같아야 한다
    const m = tiles.match(new RegExp(`name="${p.tilesBody}" value="([^"]+)"`));
    assert.ok(m, `tiles attribute ${p.tilesBody}`);
    assert.equal(p.template, m[1]);
    assert.ok(files.includes(m[1].slice(1)), `${p.output} rendered from ${m[1]}`);
    for (const s of p.sources) assert.equal(s.sha256, sha(path.join(WEBAPP, s.path)), `hash of ${s.path}`);
    assert.match(p.html, new RegExp(`Original files: .*${m[1].slice(1).replace(/\//g, '\\/')}`));
  }
  for (const a of provenance.assets) {
    assert.equal(a.sha256, sha(path.join(DEMO, '..', a.source)), a.source);
    if (!a.transforms.length) assert.equal(sha(path.join(DIST, a.output)), a.sha256, `${a.output} is a byte copy`);
  }
});

// 원본 템플릿의 "정적인" 줄(EL·JSTL·스크립틀릿·데모 패치 대상이 아닌 줄)이 결과에 그대로 남았는지 비율로 본다.
function reuseRatio(templateRel, html) {
  // 고정 가상 세션(ID='demo', 프로필 이미지 없음)에서는 렌더링되지 않는 분기(관리자 화면, 비로그인 링크, 프로필 이미지)와
  // 화면마다 다른 STEP 분기(예약내역/지난예약내역 — 어느 쪽이 렌더링됐는지는 다음 테스트에서 확인)는 비율 계산에서 뺀다.
  const dropBranches = (t) => t.replace(/<c:if test="\$\{(?:ID == 'admin' |ID == null|ID_IMG == 'Y' |STEP == '\w+')\}">[\s\S]*?<\/c:if>/g, '');
  const original = dropBranches(fs.readFileSync(path.join(WEBAPP, templateRel), 'utf8'));
  // 데모 패치가 지우거나 바꾼 줄은 분모에서 뺀다(패치 목록은 SOURCE-HANDOFF.md 에 기록)
  const patched = new Set(applyPatches(templateRel, original, DEMO_PATCHES).text.split('\n').map((l) => l.trim()));
  const out = new Set(html.split('\n').map((l) => l.trim()));
  const lines = original.split('\n').map((l) => l.trim()).filter((l) =>
    l.length > 12 && patched.has(l) && !/\$\{|<\/?c:|<%|<\/?tiles:|<!DOCTYPE|<\/?html|<\/?head|<\/?body|<meta|<title/i.test(l));
  const hit = lines.filter((l) => out.has(l)).length;
  return { hit, total: lines.length, ratio: hit / lines.length };
}

test('generated pages reuse the original template markup and scripts line for line', () => {
  const checked = new Set();
  const ratios = [];
  for (const p of pages) {
    for (const s of p.sources.filter((x) => x.path.endsWith('.jsp'))) {
      const key = `${p.output}:${s.path}`;
      if (checked.has(key)) continue;
      checked.add(key);
      const r = reuseRatio(s.path, p.html);
      assert.ok(r.total > 5, `${s.path} has static lines`);
      ratios.push(`${Math.round(r.ratio * 100)}% ${s.path} → ${p.output}`);
      assert.ok(r.ratio >= 0.9, `${p.output} keeps ${Math.round(r.ratio * 100)}% (${r.hit}/${r.total}) of static lines from ${s.path}`);
    }
  }
  if (process.env.SHOW_REUSE) console.log(ratios.join('\n'));
});

test('source-specific markup and original functions are present per page', () => {
  const byOut = Object.fromEntries(pages.map((p) => [p.output, p.html]));
  const expect = {
    'hospital/main/index.html': ['<main class="care-home">', 'id="careSearch"', '<h2>병원 후기</h2>', 'function findHospital(type, value)', 'data-jsp-foreach="reviewlist"'],
    'hospital/hplist/List/index.html': ['<table id="searchForm">', '<option value="MAJOR">진료과목</option>', 'function fn_selectHpListCallback(data)', '<h2>{{param.boardTitle}}</h2>', 'value="{{param.REG_CHK}}"'],
    'hospital/hplist/HpDetail/1/index.html': ['<table class="board_view" style="margin: auto;">', '<td>햇살내과의원</td>', "<td><input type='button' name='REG' value='예약'></td>", 'var H_IDX = "1";'],
    'hospital/reserv/OpenReserv/index.html': ['<table id="calendar">', 'function makeMonth(year, month', "comAjax.setUrl(\"/hospital/reserv/Reservation\");", "value='{{param.H_IDX}}'"],
    'hospital/reserv/MyReserv/index.html': ['<div class="myReservList">', '<h2>예약내역</h2>', '<template data-jsp-foreach="list" data-jsp-var="row">', '{{row.RESERV1}}', 'name="cancel"'],
    'hospital/reserv/MyPastReserv/index.html': ['<h2>지난예약내역</h2>', '<th scope="col">상태</th>', '{{row.STATE}}'],
    'hospital/mypage/OpenMypageFavhp/index.html': ['<div class="FavList">', '{{row.TEL}}', 'name="delFavHp"'],
  };
  for (const [out, needles] of Object.entries(expect)) {
    for (const n of needles) assert.ok(byOut[out].includes(n), `${out} contains ${n}`);
  }
  assert.ok(!byOut['hospital/hplist/HpDetail/4/index.html'].includes("<input type='button' name='REG'"), 'REG_CHK N hospital has no reservation button');
  assert.ok(!byOut['hospital/reserv/MyPastReserv/index.html'].includes('name="cancel"'));
});

test('no unprocessed JSP remains; runtime tokens only where the page expects them', () => {
  for (const p of pages) {
    assert.doesNotMatch(p.html, /<%|\$\{|<\/?c:\w|<\/?tiles:|<\/?fn:/, p.output);
    const outsideTemplates = p.html.replace(/<template\b[\s\S]*?<\/template>/g, '');
    const tokens = [...outsideTemplates.matchAll(/\{\{(\w+)\.(\w+)\}\}/g)].map((m) => m[1]);
    assert.ok(tokens.every((t) => t === 'param'), `${p.output}: only {{param.*}} outside templates`);
    if (tokens.length) assert.ok(['/hospital/hplist/List', '/hospital/reserv/OpenReserv', '/hospital/rate/OpenRating'].includes(p.route), p.output);
  }
});

test('no external network references, no unmocked request paths, no secrets or real contact data', () => {
  const files = fs.readdirSync(DIST, { recursive: true }).filter((f) => /\.(html|js|css|json)$/.test(f) && !f.includes('vendor'));
  // 원본 라이브러리 안에 있지만 데모에서 실행되지 않는 외부 주소 (옵션 video:false 기본값 → 영상 플러그인 미사용)
  const LIBRARY_EXCEPTIONS = { 'hospital/js/owl.carousel.min.js': /youtube\.com|vimeo\.com/ };
  for (const f of files) {
    let text = read(f);
    if (LIBRARY_EXCEPTIONS[f]) {
      assert.ok(!/video\s*:\s*true/.test(pages.map((p) => p.html).join('')), 'owl video plugin stays disabled');
      text = text.split('\n').map((l) => l.replace(/(?:https?:)?\/\/[^"'\s]*(?:youtube|vimeo)[^"'\s]*/g, '')).join('\n');
    }
    assert.doesNotMatch(text, /\b(?:src|href|action)\s*=\s*["'](?:https?:)?\/\//i, `${f}: external src/href`);
    assert.doesNotMatch(text, /url\(\s*['"]?(?:https?:)?\/\//i, `${f}: external url()`);
    assert.doesNotMatch(text, /@import\s+url\(\s*['"]?http/i, `${f}: external @import`);
    assert.doesNotThrow(() => assertNoKnownSecrets(text));
    for (const secret of ['appkey=', '377 655', 'IMP.request_pay', 'Kakao.init(']) {
      assert.ok(!text.includes(secret), `${f} must not contain ${secret}`);
    }
    if (f.endsWith('.html') || f.endsWith('.js')) {
      // $.ajax 는 원본 common.js(어댑터가 대체)와 어댑터의 차단 코드에만 있어야 한다
      if (/\$\.ajax\s*\(|(?<![\w.])fetch\s*\(|new XMLHttpRequest/.test(text)) assert.ok(['hospital/js/common.js'].includes(f), `${f}: raw network call`);
    }
  }
  const adapter = read('hospital/demo/mock-adapter.js');
  assert.match(adapter, /\$\.ajax = blocked/);
  assert.match(adapter, /window\.ComAjax = function/);
  assert.match(adapter, /window\.ComSubmit = function/);
  for (const p of pages) {
    assert.ok(p.html.includes(DEMO_NOTICE), `${p.output}: fixed notice`);
    assert.ok(p.html.indexOf('/hospital/demo/mock-adapter.js') > p.html.indexOf('/hospital/js/common.js'), 'adapter loads after common.js');
    assert.ok(p.html.indexOf('/hospital/demo/mock-adapter.js') < p.html.indexOf('<div class="header">'), 'adapter loads before page scripts');
  }
});

// 원본 스크립트가 서버로 보내던 URL 은 모두 모의 처리되거나, 그 요청을 일으키는 화면 요소가 없어야 한다.
const UNREACHABLE = {
  '/hospital/member/loginForm': ['id="loginForm"', '로그인 링크는 고정 세션이라 렌더링되지 않음'],
  '/hospital/member/logout': ['id="logout"', '로그아웃 링크 제거(header), 관리자 화면 미렌더링(layout)'],
  '/hospital/qna/writeform': ['id="qna"', '메인 1:1 문의 버튼을 "데모 미지원" 표시로 바꿈'],
  '/hospital/common/downloadFile.do': ['name="file"', 'Detail.jsp 에 남은 샘플 게시판 코드(대상 요소 없음)'],
  '/hospital/sample/openBoardList.do': ['id="list"', 'Detail.jsp 에 남은 샘플 게시판 코드(대상 요소 없음)'],
  '/hospital/sample/openBoardUpdate.do': ['id="update"', 'Detail.jsp 에 남은 샘플 게시판 코드(대상 요소 없음)'],
  '/hospital/sample/openBoardReply.do': ['id="reply"', 'Detail.jsp 에 남은 샘플 게시판 코드(대상 요소 없음)'],
};

test('every server URL in page scripts is mocked or its trigger is absent', () => {
  const handled = new Set([...MB.AJAX_ROUTES, ...MB.PAGE_ROUTES, ...Object.keys(MB.ACTION_ROUTES)]);
  for (const p of pages) {
    const urls = [...p.html.matchAll(/"(\/hospital\/[\w/]+(?:\.do)?)"/g)].map((m) => m[1])
      .filter((u) => !/\/(css|js|img|demo|vendor)\//.test(u) && !['/hospital/', '/hospital/hplist/', '/hospital/main/'].includes(u));
    for (const u of urls) {
      if (handled.has(u.replace(/\/$/, ''))) continue;
      assert.ok(UNREACHABLE[u], `${p.output}: ${u} is neither mocked nor listed as unreachable`);
      assert.ok(!p.html.includes(UNREACHABLE[u][0]), `${p.output}: trigger ${UNREACHABLE[u][0]} for ${u} must not be rendered`);
    }
    // header.jsp 의 동적 URL("/hospital/" + id) 대상
    for (const m of p.html.matchAll(/name="(?:mypageList|CustomService|QnaService|GuideService)" id="([^"]+)"/g)) {
      assert.ok(handled.has('/hospital/' + m[1]), `${p.output}: header link ${m[1]} is mocked`);
    }
    for (const hidden of ['notice/listform', 'faq/listform', 'qna/listform', 'guide/searchGuide', 'mypage/OpenMypageMain', 'class="point_payment"', 'execDaumPostcode()"']) {
      assert.ok(!p.html.includes(hidden), `${p.output}: unsupported control ${hidden} hidden`);
    }
  }
});

test('all local references resolve to files in dist; unsafe original images are not published', () => {
  for (const p of pages) {
    const refs = new Set([
      ...[...p.html.matchAll(/\b(?:src|href)=["'](\/hospital\/[^"'?#]+)["']/g)].map((m) => m[1]),
      ...[...p.html.matchAll(/["'](\/hospital\/[\w/.-]+\.(?:png|jpg|gif|svg|css|js))["']/g)].map((m) => m[1]),
    ]);
    for (const r of refs) assert.ok(fs.existsSync(path.join(DIST, r)), `${p.output}: ${r} exists`);
    assert.doesNotMatch(p.html, /\/hospital\/img\/(?:mainImg|UserImg|on\.png|off\.png)/, p.output);
    for (const m of p.html.matchAll(/<a\b[^>]*href="([^"]*)"/g)) {
      m[1] = m[1].split('?')[0];
      assert.ok(['#', '#this', '#top'].includes(m[1]) || fs.existsSync(path.join(DIST, m[1], m[1].endsWith('/') ? 'index.html' : '')), `${p.output}: link ${m[1]}`);
    }
  }
  const imgs = fs.readdirSync(path.join(DIST, 'hospital/img'));
  assert.deepEqual(imgs, ['logo2.gif']);
  assert.ok(fs.existsSync(path.join(DIST, 'hospital/vendor/jquery/LICENSE.txt')));
  assert.ok(fs.existsSync(path.join(DIST, 'hospital/vendor/font-awesome/LICENSE.txt')));
  assert.ok(fs.existsSync(path.join(DIST, 'hospital/vendor/font-awesome/fonts/fontawesome-webfont.woff2')));
});

test('no source docs or server config are published', () => {
  const all = fs.readdirSync(DIST, { recursive: true });
  for (const f of all) {
    assert.doesNotMatch(f, /\.(jsp|jspf|xml|java|class|properties|md)$|WEB-INF|META-INF|\.settings|\.classpath/, f);
  }
});

test('fixed-width original layouts that exceed a phone width are overridden in demo.css', () => {
  const css = read('hospital/demo/demo.css');
  const wide = new Set();
  for (const p of pages) {
    for (const m of p.html.matchAll(/style=["'][^"']*\bwidth:\s*(\d+)px/g)) if (+m[1] > 360) wide.add(m[0]);
  }
  // 남은 넓은 인라인 폭은 예약 내역 표(650px) 하나뿐이며, 모바일에서 100% 로 덮는다.
  assert.deepEqual([...wide], ['style="width: 650px']);
  assert.match(css, /\.myReservList > table,\s*\.FavList > table \{\s*width: 100% !important;/);
  for (const sel of ['.Tiles_wrap', '.gridForm', '.reserv', '#dialogbox', '.header > div:not(.subMenu)']) assert.ok(css.includes(sel), sel);
  const ui = read('hospital/css/ui.css');
  assert.match(ui, /\.Tiles_wrap \{\s*width: 1200px;/, 'original fixed widths kept in ui.css; override lives in demo.css');
});
