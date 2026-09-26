// 원본 JSP 화면(src/main/webapp/WEB-INF/...)을 읽어 정적 모의(mock) 데모를 dist/ 에 만든다.
//
//  1. tiles.xml 의 mainForm 정의와 layout.jsp 를 그대로 따라 header/body/footer 를 조립한다.
//  2. 원본 컨트롤러가 넘기던 모델을 합성 데이터(runtime/fixtures.js + mock-backend.js)로 만든다.
//     브라우저 저장소에 따라 달라지는 값(내 예약 목록 등)과 요청 파라미터는 브라우저에서 채운다.
//  3. 원본 CSS/JS/이미지를 같은 경로(/hospital/...)로 복사하고, CDN 라이브러리는 npm 패키지로 바꾼다.
//  4. 화면마다 사용한 원본 파일과 해시를 dist/hospital/demo/provenance.json 에 남긴다.
//
// 사용: node scripts/build.mjs

import fs from 'node:fs';
import { assertNoKnownSecrets } from './lib/assert-public.mjs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { createRequire } from 'node:module';
import { createRenderer, parseTiles, flattenFragment, applyPatches, param, runtimeList, sha256, JspError } from './lib/jsp-render.mjs';
import { DEMO_PATCHES, DEMO_NOTICE } from './lib/demo-patches.mjs';
import { VENDOR, CSS_TRANSFORMS, IMAGES, lookupAsset, sanitizeUrl } from './lib/assets.mjs';

const require = createRequire(import.meta.url);
const DEMO_DIR = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const REPO_ROOT = path.resolve(DEMO_DIR, '..');
const WEBAPP = path.join(REPO_ROOT, 'src/main/webapp');
const DIST = path.join(DEMO_DIR, 'dist');
const CONTEXT_PATH = '/hospital';
const RUNTIME_FILES = ['fixtures.js', 'mock-backend.js', 'jsp-runtime.js', 'mock-adapter.js'];

const fixtures = require('../runtime/fixtures.js');
const MB = require('../runtime/mock-backend.js');

function fail(msg) {
  throw new JspError(msg);
}

function write(rel, content) {
  const abs = path.join(DIST, rel);
  fs.mkdirSync(path.dirname(abs), { recursive: true });
  fs.writeFileSync(abs, content);
}

function copy(fromAbs, rel) {
  const abs = path.join(DIST, rel);
  fs.mkdirSync(path.dirname(abs), { recursive: true });
  fs.cpSync(fromAbs, abs, { recursive: true });
}

// 빌드 시점 모델은 초기 저장값(SEED_STATE) 기준으로 계산한다. 결과는 결정적이다.
const buildBackend = MB.createBackend({
  fixtures,
  session: fixtures.SESSION,
  store: MB.memoryStore(fixtures.SEED_STATE),
  now: () => new Date(2026, 0, 1),
});

const PAGES = [
  {
    route: '/hospital/main', out: 'hospital/main/index.html', body: 'body',
    controller: 'hp.common.controller.MainController#mainForm',
    model: { list: buildBackend.selectCount(), reviewlist: buildBackend.selectReview() },
  },
  {
    route: '/hospital/hplist/List', out: 'hospital/hplist/List/index.html', body: 'hplist',
    controller: 'hp.jw.controller.HpListController#openHospitalPage',
    model: { boardTitle: param('boardTitle'), LIST: param('LIST'), QUERY: param('QUERY'), REG_CHK: param('REG_CHK'), ADDR: '' },
  },
  ...fixtures.HOSPITAL.map((h) => ({
    route: '/hospital/hplist/HpDetail', out: `hospital/hplist/HpDetail/${h.H_IDX}/index.html`, body: 'hpdetail',
    controller: 'hp.jw.controller.HpListController#openHpDetail',
    model: { map: buildBackend.selectHpDetail(h.H_IDX) },
  })),
  {
    route: '/hospital/reserv/OpenReserv', out: 'hospital/reserv/OpenReserv/index.html', body: 'reserv',
    controller: 'hp.sy.controller.ReservController#openReserv',
    model: { map: param('H_IDX') },
  },
  {
    route: '/hospital/reserv/MyReserv', out: 'hospital/reserv/MyReserv/index.html', body: 'mypageReservList',
    controller: 'hp.sy.controller.ReservController#myReserv',
    model: { STEP: 'reserv', list: runtimeList() },
  },
  {
    route: '/hospital/reserv/MyPastReserv', out: 'hospital/reserv/MyPastReserv/index.html', body: 'mypageReservList',
    controller: 'hp.sy.controller.ReservController#myPastReserv',
    model: { STEP: 'pastreserv', list: runtimeList() },
  },
  {
    route: '/hospital/mypage/OpenMypageFavhp', out: 'hospital/mypage/OpenMypageFavhp/index.html', body: 'myFavList',
    controller: 'hp.sy.controller.MypageController#openMypageFavhp',
    model: { list: runtimeList() },
  },
];

// ---------- 준비 ----------

if (!fs.existsSync(path.join(WEBAPP, 'WEB-INF/tiles.xml'))) {
  fail(`original sources not found at ${WEBAPP}. The demo build reads the original JSP files; keep portfolio-demo inside the original repository.`);
}
if (path.basename(DIST) !== 'dist' || path.dirname(DIST) !== DEMO_DIR) fail('unexpected dist path');
fs.rmSync(DIST, { recursive: true, force: true });

const tilesRaw = fs.readFileSync(path.join(WEBAPP, 'WEB-INF/tiles.xml'));
const tiles = parseTiles(tilesRaw.toString('utf8'));
const mainForm = tiles.resolve('mainForm');
const renderer = createRenderer({ webappRoot: WEBAPP, contextPath: CONTEXT_PATH, tilesDefinition: mainForm, patches: DEMO_PATCHES });

const provenance = {
  project: 'cskwork/java-spring-web-hospitalReservation (Dr.Her 병원 예약, Spring MVC + MyBatis + JSP)',
  mode: 'static mock build — no server, no database, synthetic data, browser localStorage',
  notice: DEMO_NOTICE,
  mechanism: [
    'tiles.xml mainForm + WEB-INF/views/layout.jsp compose header/body/footer exactly as Tiles did',
    'restricted JSP renderer: static include, c:url, c:if/choose/forEach, EL; anything else fails the build',
    'controller models rebuilt from runtime/fixtures.js via runtime/mock-backend.js (port of the Java services/mappers)',
    'ComSubmit/ComAjax (js/common.js) replaced by runtime/mock-adapter.js with the same interface',
  ],
  tiles: { file: 'WEB-INF/tiles.xml', sha256: sha256(tilesRaw), definition: 'mainForm', template: mainForm.template },
  pages: [],
  assets: [],
  vendor: [],
  dropped: [],
  omittedImages: [
    { path: 'img/mainImg/slider-1..4.jpg', reason: '출처·사용 권리 확인 불가(카메라 EXIF 사진). 단색 구성으로 대체.' },
    { path: 'img/mainImg/portfolio-1..6.jpg, portfolio/*', reason: '출처·사용 권리 확인 불가. 단색 카드로 대체.' },
    { path: 'img/mainImg/author-*.jpg', reason: '제3자 저작권 표기(EXIF copyright) 사진. 화면에서도 쓰지 않음.' },
    { path: 'img/mainImg/partners-*.jpg/png', reason: '이용 가이드 캡처에 실제 사람 이름이 보임. 캡션 글만 남김.' },
    { path: 'img/on.png, img/off.png', reason: '출처 확인 불가 별 이미지. 자체 SVG(demo/img/fav-on.svg, fav-off.svg)로 대체.' },
    { path: 'img/UserImg/*, img/kakao_logout.PNG, img/close.jpg, img/EditDetail.png, img/back1.png, img/logo.png, img/f_logo.png, img/default.jpg', reason: '데모 화면에서 쓰지 않음(프로필·카카오·관리자 화면).' },
  ],
};

// ---------- 화면 ----------

function processAssets(html, out) {
  const tagRe = /<script\b[^>]*\bsrc=(["'])([^"']+)\1[^>]*>\s*<\/script>|<link\b[^>]*\bhref=(["'])([^"']+)\3[^>]*>/gi;
  const found = [];
  let m;
  while ((m = tagRe.exec(html))) {
    const url = m[2] || m[4];
    const kind = m[2] ? 'script' : 'link';
    const entry = lookupAsset(url);
    if (!entry) fail(`${out}: no asset mapping for ${kind} ${sanitizeUrl(url)}`);
    let target = null;
    if (entry.copy) target = CONTEXT_PATH + '/' + entry.copy;
    else if (entry.vendor) target = VENDOR[entry.vendor].url;
    else if (!provenance.dropped.some((d) => d.url === sanitizeUrl(url))) provenance.dropped.push({ url: sanitizeUrl(url), reason: entry.drop });
    found.push({ start: m.index, end: tagRe.lastIndex, kind, target, tag: m[0], url });
  }
  // 스크립트는 처음 것만(중복 jQuery/common.js 가 이미 붙은 플러그인을 지우지 않도록),
  // 스타일시트는 마지막 것만 남긴다(원본에서 ui.css 가 맨 마지막에 한 번 더 읽혀 우선 적용되던 순서 유지).
  const keep = new Set();
  const seen = new Set();
  for (const f of found.filter((x) => x.target && x.kind === 'script')) {
    if (!seen.has(f.target)) { keep.add(f); seen.add(f.target); }
  }
  const lastLink = new Map();
  for (const f of found.filter((x) => x.target && x.kind === 'link')) lastLink.set(f.target, f);
  for (const f of lastLink.values()) keep.add(f);

  let result = '';
  let pos = 0;
  for (const f of found) {
    result += html.slice(pos, f.start);
    if (keep.has(f)) result += f.tag.replace(f.url, f.target);
    pos = f.end;
  }
  return result + html.slice(pos);
}

function injectRuntime(html, page) {
  const common = `<script src="${CONTEXT_PATH}/js/common.js" charset="utf-8"></script>`;
  if (html.split(common).length !== 2) fail(`${page.out}: expected exactly one common.js script tag`);
  const runtime = RUNTIME_FILES.map((f) => `\n<script src="${CONTEXT_PATH}/demo/${f}"></script>`).join('');
  html = html.replace(common, common + runtime);

  const links = [...html.matchAll(/<link\b[^>]*rel=["']stylesheet["'][^>]*>/gi)];
  if (!links.length) fail(`${page.out}: no stylesheet`);
  const lastLink = links[links.length - 1];
  const at = lastLink.index + lastLink[0].length;
  html = html.slice(0, at) + `\n<link rel="stylesheet" type="text/css" href="${CONTEXT_PATH}/demo/demo.css" />` + html.slice(at);

  if (html.split('<head>').length !== 2) fail(`${page.out}: expected one <head>`);
  html = html.replace('<head>', `<head>\n<meta name="drher-route" content="${page.route}">`);
  return html;
}

for (const page of PAGES) {
  const used = [];
  const scope = { ...fixtures.SESSION, ...page.model, body: page.body };
  const hooks = {
    insertTile(name, target, s) {
      const file = target.replace(/^\//, '');
      used.push({ tilesAttribute: name, file });
      let html = flattenFragment(renderer.render(file, s, hooks));
      // 본문 화면 끝에서 브라우저 쪽 "서버 렌더링" 대체 처리를 한 번 실행한다.
      if (name === page.body) html += '\n<script>DrHerDemo.renderRuntime();</script>\n';
      return html;
    },
  };
  const layoutFile = mainForm.template.replace(/^\//, '');
  let html = renderer.render(layoutFile, scope, hooks);
  html = processAssets(html, page.out);
  html = injectRuntime(html, page);

  const external = html.match(/\b(?:src|href)\s*=\s*["'](?:https?:)?\/\/[^"']+/i);
  if (external) fail(`${page.out}: external reference left: ${sanitizeUrl(external[0])}`);

  const header =
    `<!DOCTYPE html>\n<!--\n  Generated by portfolio-demo/scripts/build.mjs — do not edit.\n` +
    `  Source of truth: original JSP views of Dr.Her (src/main/webapp). Tiles definition "mainForm", body attribute "${page.body}".\n` +
    `  Controller: ${page.controller}\n` +
    `  Original files: ${[...new Set([layoutFile, ...used.map((u) => u.file)])].join(', ')}\n-->\n`;
  html = header + html.replace(/^\s*<!DOCTYPE html>\s*/i, '');
  write(page.out, html);

  const files = [...new Set([layoutFile, ...used.map((u) => u.file)])];
  provenance.pages.push({
    output: page.out,
    route: page.route,
    controller: page.controller,
    tilesBody: page.body,
    template: mainForm.attrs[page.body],
    tilesAttributes: used,
    sources: files.map((f) => renderer.sources.get(f)).concat(
      // 정적 include 로 끼워 넣은 파일
      [...renderer.sources.values()].filter((s) => s.path.startsWith('WEB-INF/include/') && !files.includes(s.path)),
    ),
  });
}

// 데모 패치가 하나라도 적용되지 않았다면(대상 파일을 읽지 않았거나 경로가 틀림) 멈춘다.
const appliedPatchIds = new Set([...renderer.sources.values()].flatMap((s) => s.demoPatches));
const unusedPatches = DEMO_PATCHES.filter((p) => !appliedPatchIds.has(p.id)).map((p) => p.id);
if (unusedPatches.length) fail(`demo patches never applied: ${unusedPatches.join(', ')}`);

// ---------- 원본 CSS/JS/이미지 ----------

const copied = new Set();
for (const html of PAGES.map((p) => fs.readFileSync(path.join(DIST, p.out), 'utf8'))) {
  for (const m of html.matchAll(/\b(?:src|href)=["'](\/hospital\/(?:css|js)\/[^"']+)["']/g)) copied.add(m[1]);
}
for (const url of [...copied].sort()) {
  const rel = url.slice(CONTEXT_PATH.length + 1);
  const abs = path.join(WEBAPP, rel);
  if (!fs.existsSync(abs)) fail(`original asset missing: ${rel}`);
  const raw = fs.readFileSync(abs);
  let content = raw;
  let transforms = [];
  if (CSS_TRANSFORMS[rel]) {
    const r = applyPatches(rel, raw.toString('utf8'), CSS_TRANSFORMS[rel].map((t) => ({ ...t, file: rel })));
    content = r.text;
    transforms = r.applied;
  }
  write('hospital/' + rel, content);
  provenance.assets.push({ output: 'hospital/' + rel, source: 'src/main/webapp/' + rel, sha256: sha256(raw), transforms });
}
for (const [url, rel] of Object.entries(IMAGES)) {
  const raw = fs.readFileSync(path.join(WEBAPP, rel));
  write(url.slice(1), raw);
  provenance.assets.push({ output: url.slice(1), source: 'src/main/webapp/' + rel, sha256: sha256(raw), transforms: [] });
}

// ---------- 외부 라이브러리 (npm) ----------

for (const [name, v] of Object.entries(VENDOR)) {
  for (const [from, to] of v.files) {
    const abs = path.join(DEMO_DIR, from);
    if (!fs.existsSync(abs)) fail(`vendor file missing: ${from} (run npm install in portfolio-demo)`);
    copy(abs, to);
  }
  if (v.license) write(path.join(path.dirname(v.files[0][1]), '..', 'LICENSE.txt'), v.license);
  provenance.vendor.push({ name, url: v.url, note: v.note });
}

// ---------- 데모 런타임 ----------

for (const f of [...RUNTIME_FILES, 'demo.css']) copy(path.join(DEMO_DIR, 'runtime', f), `hospital/demo/${f}`);
copy(path.join(DEMO_DIR, 'runtime/img'), 'hospital/demo/img');
copy(path.join(DEMO_DIR, 'runtime/favicon.ico'), 'favicon.ico');
copy(path.join(DEMO_DIR, 'licenses'), 'licenses');

const redirect = (to) =>
  `<!DOCTYPE html>\n<html lang="ko"><head><meta charset="utf-8"><meta http-equiv="refresh" content="0; url=${to}">` +
  `<title>Dr.Her 병원 예약 · 원본 기반 데모</title></head>` +
  `<body><p>${DEMO_NOTICE}</p><p><a href="${to}">메인 화면으로 이동</a></p></body></html>\n`;
write('index.html', redirect('/hospital/main/'));
write('hospital/index.html', redirect('/hospital/main/'));

write('hospital/demo/provenance.json', JSON.stringify(provenance, null, 2) + '\n');

// 공개 산출물에 앱 키 등 비밀값이 남지 않았는지 확인

for (const file of fs.readdirSync(DIST, { recursive: true })) {
  const abs = path.join(DIST, file);
  if (!fs.statSync(abs).isFile() || !/\.(html|js|css|json)$/.test(file)) continue;
  const text = fs.readFileSync(abs, 'utf8');
  assertNoKnownSecrets(text);
}

console.log(`built ${PAGES.length} pages from ${renderer.sources.size} original view files into ${path.relative(REPO_ROOT, DIST)}/`);
