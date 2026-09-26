// 원본 JSP 를 정적 HTML 로 바꾸는 제한된 렌더러.
// 범용 JSP 엔진이 아니다. 데모에 쓰는 원본 템플릿에 실제로 나오는 문법만 처리하고,
// 그 밖의 문법(스크립틀릿, 다른 태그 라이브러리 등)을 만나면 빌드를 멈춘다.
//
// 처리하는 것
//  - <%@ include file="..." %> 정적 include, <%@ page %>/<%@ taglib %> 지시어 제거
//  - <c:url value='...'/> → 컨텍스트 경로(/hospital) 붙이기
//  - <c:if>, <c:choose>/<c:when>/<c:otherwise>, <c:forEach>, <tiles:insertAttribute>
//  - ${...} EL (비교·논리 연산, fn:length, 점/대괄호 접근)
//
// 빌드 시점에 값을 알 수 없는 모델은 표식 객체로 넘긴다.
//  - param(name)  : 요청 파라미터. {{param.NAME}} 토큰으로 남기고 브라우저에서 채운다.
//  - runtimeList(): 브라우저 저장소에서 오는 목록. <c:forEach> 가 <template data-jsp-foreach> 가 된다.

import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';

export class JspError extends Error {}

const MARK = Symbol('jsp-runtime');
export const param = (name) => ({ [MARK]: 'param', name });
export const runtimeList = () => ({ [MARK]: 'list' });
const runtimeRow = (name) => ({ [MARK]: 'row', name });
const markOf = (v) => (v && typeof v === 'object' && v[MARK]) || null;

export function escapeHtml(v) {
  return String(v)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

export function sha256(buf) {
  return crypto.createHash('sha256').update(buf).digest('hex');
}

// ---------- 패치 ----------

// 원본 파일 내용에 데모 전용 패치를 적용한다. 기대한 횟수만큼 맞지 않으면 빌드를 멈춘다
// (원본이 바뀌면 조용히 넘어가지 않도록).
export function applyPatches(file, text, patches) {
  const applied = [];
  for (const p of patches.filter((x) => x.file === file)) {
    const expected = p.count ?? 1;
    const re = p.find instanceof RegExp ? new RegExp(p.find.source, p.find.flags.includes('g') ? p.find.flags : p.find.flags + 'g') : null;
    const found = re ? (text.match(re) || []).length : text.split(p.find).length - 1;
    if (found !== expected) {
      throw new JspError(`demo patch "${p.id}" expected ${expected} match(es) in ${file}, found ${found}`);
    }
    text = re ? text.replace(re, p.replace) : text.split(p.find).join(p.replace);
    applied.push(p.id);
  }
  return { text, applied };
}

// ---------- tiles.xml ----------

export function parseTiles(xml) {
  const defs = {};
  const defRe = /<definition\s+name="([^"]+)"(?:\s+template="([^"]+)")?(?:\s+extends="([^"]+)")?\s*>([\s\S]*?)<\/definition>/g;
  let m;
  while ((m = defRe.exec(xml))) {
    const attrs = {};
    const putRe = /<put-attribute\s+name="([^"]+)"\s+value="([^"]+)"/g;
    let a;
    while ((a = putRe.exec(m[4]))) attrs[a[1]] = a[2];
    defs[m[1]] = { name: m[1], template: m[2], extends: m[3], attrs };
  }
  const resolve = (name) => {
    const d = defs[name];
    if (!d) throw new JspError(`tiles definition not found: ${name}`);
    if (!d.extends) return { template: d.template, attrs: { ...d.attrs } };
    const parent = resolve(d.extends);
    return { template: d.template || parent.template, attrs: { ...parent.attrs, ...d.attrs } };
  };
  return { defs, resolve };
}

// ---------- EL ----------

const EL_KEYWORDS = new Set(['null', 'true', 'false', 'empty', 'not', 'and', 'or', 'eq', 'ne', 'lt', 'gt', 'le', 'ge', 'div', 'mod', '__len', '__empty']);

function translateEl(expr) {
  const src = expr.trim();
  if (/[;{}=]\s*>|=>|\bfunction\b|\bnew\b|`/.test(src)) throw new JspError(`unsupported EL: ${expr}`);
  return src
    .replace(/\bfn:length\s*\(/g, '__len(')
    .replace(/\bempty\s+([\w.[\]]+)/g, '__empty($1)')
    .replace(/\bnot\s+/g, '!')
    .replace(/\band\b/g, '&&')
    .replace(/\bor\b/g, '||')
    .replace(/\beq\b/g, '==')
    .replace(/\bne\b/g, '!=');
}

function rootIdentifiers(js) {
  const noStrings = js.replace(/'[^']*'|"[^"]*"/g, '""');
  const ids = new Set();
  const re = /(^|[^\w$.])([A-Za-z_$][\w$]*)/g;
  let m;
  while ((m = re.exec(noStrings))) if (!EL_KEYWORDS.has(m[2])) ids.add(m[2]);
  return [...ids];
}

function lookup(scope, name) {
  return Object.prototype.hasOwnProperty.call(scope, name) ? scope[name] : undefined;
}

function evalJs(js, scope) {
  const proxy = new Proxy(scope, {
    has: (t, k) => typeof k === 'string' && k !== '__len' && k !== '__empty',
    get: (t, k) => (k === Symbol.unscopables ? undefined : lookup(t, k)),
  });
  const len = (v) => (v == null ? 0 : v.length ?? Object.keys(v).length);
  const empty = (v) => v == null || v === '' || len(v) === 0;
  // eslint-disable-next-line no-new-func
  const fn = new Function('__scope', '__len', '__empty', `with (__scope) { return (${js}); }`);
  return fn(proxy, len, empty);
}

// ---------- 파서 ----------

const TAG_RE = /<(\/?)(c:(?:if|choose|when|otherwise|forEach|out)|tiles:insertAttribute)\b((?:[^>"']|"[^"]*"|'[^']*')*?)(\/?)>/g;

function parseAttrs(s) {
  const out = {};
  const re = /([\w:-]+)\s*=\s*(?:"([^"]*)"|'([^']*)')/g;
  let m;
  while ((m = re.exec(s))) out[m[1]] = m[2] ?? m[3];
  return out;
}

function parse(text, file) {
  const root = { type: 'root', children: [] };
  const stack = [root];
  let last = 0;
  let m;
  TAG_RE.lastIndex = 0;
  while ((m = TAG_RE.exec(text))) {
    const top = stack[stack.length - 1];
    if (m.index > last) top.children.push({ type: 'text', value: text.slice(last, m.index) });
    last = TAG_RE.lastIndex;
    const [, closing, tag, attrText, selfClose] = m;
    if (closing) {
      if (top.tag !== tag) throw new JspError(`${file}: unexpected </${tag}> (open: ${top.tag || 'none'})`);
      stack.pop();
      continue;
    }
    const node = { type: 'tag', tag, attrs: parseAttrs(attrText), children: [] };
    top.children.push(node);
    if (!selfClose) stack.push(node);
  }
  if (stack.length !== 1) throw new JspError(`${file}: unclosed <${stack[stack.length - 1].tag}>`);
  if (last < text.length) root.children.push({ type: 'text', value: text.slice(last) });
  return root;
}

// ---------- 렌더러 ----------

export function createRenderer({ webappRoot, contextPath, tilesDefinition, patches, onSource }) {
  const sources = new Map();

  function read(file) {
    file = file.replace(/^\//, '');
    const abs = path.join(webappRoot, file);
    if (!fs.existsSync(abs)) throw new JspError(`original source missing: ${file}`);
    const raw = fs.readFileSync(abs);
    const { text, applied } = applyPatches(file, raw.toString('utf8'), patches);
    if (!sources.has(file)) {
      const rec = { path: file, sha256: sha256(raw), demoPatches: applied };
      sources.set(file, rec);
      onSource?.(rec);
    }
    return text;
  }

  function preprocess(file) {
    let text = read(file);
    // 정적 include (JSP 번역 시점에 붙여 넣는 방식 그대로)
    text = text.replace(/<%@\s*include\s+file="([^"]+)"\s*%>/g, (_, inc) => preprocess(inc));
    text = text.replace(/<%@\s*(page|taglib)\b[\s\S]*?%>/g, '');
    if (/<%/.test(text)) throw new JspError(`${file}: unsupported JSP scriptlet/directive`);
    text = text.replace(/<c:url\s+value=(['"])(.*?)\1\s*\/>/g, (_, q, v) => (v.startsWith('/') ? contextPath + v : v));
    if (/<c:url\b/.test(text)) throw new JspError(`${file}: unsupported <c:url> form`);
    return text;
  }

  function evalOut(expr, scope, file) {
    const js = translateEl(expr);
    const roots = rootIdentifiers(js);
    const marked = roots.map((r) => [r, markOf(lookup(scope, r))]).filter(([, k]) => k);
    if (marked.length) {
      const [rootName, kind] = marked[0];
      const simple = js.match(/^([A-Za-z_$][\w$]*)(?:\.([A-Za-z_$][\w$]*))?$/);
      if (!simple || marked.length > 1) throw new JspError(`${file}: runtime value in complex EL \${${expr}}`);
      const v = lookup(scope, rootName);
      if (kind === 'param' && !simple[2]) return `{{param.${v.name}}}`;
      if (kind === 'row' && simple[2]) return `{{${v.name}.${simple[2]}}}`;
      throw new JspError(`${file}: cannot print runtime value \${${expr}}`);
    }
    const v = evalJs(js, scope);
    return v == null ? '' : escapeHtml(v);
  }

  function evalTest(expr, scope, file) {
    const m = expr.match(/^\s*\$\{([\s\S]*)\}\s*$/);
    if (!m) throw new JspError(`${file}: test must be a single EL expression: ${expr}`);
    const js = translateEl(m[1]);
    const marked = rootIdentifiers(js).filter((r) => markOf(lookup(scope, r)));
    if (marked.length) return { runtime: true, js, marked };
    return { runtime: false, value: !!evalJs(js, scope) };
  }

  function renderText(value, scope, file) {
    return value.replace(/\$\{([^}]*)\}/g, (_, expr) => evalOut(expr, scope, file));
  }

  function renderNodes(nodes, scope, file, hooks) {
    return nodes.map((n) => renderNode(n, scope, file, hooks)).join('');
  }

  function renderNode(n, scope, file, hooks) {
    if (n.type === 'text') return renderText(n.value, scope, file);
    const kids = (s = scope) => renderNodes(n.children, s, file, hooks);
    switch (n.tag) {
      case 'c:out': {
        if (n.attrs.escapeXml === 'false') throw new JspError(`${file}: unescaped c:out is unsupported`);
        const expr = (n.attrs.value || '').match(/^\$\{([^}]*)\}$/);
        if (!expr) throw new JspError(`${file}: c:out requires one EL value`);
        return evalOut(expr[1], scope, file);
      }
      case 'c:if': {
        const t = evalTest(n.attrs.test, scope, file);
        if (t.runtime) throw new JspError(`${file}: <c:if> on runtime value (${n.attrs.test})`);
        return t.value ? kids() : '';
      }
      case 'c:choose': {
        const whens = n.children.filter((c) => c.type === 'tag');
        for (const c of n.children) {
          if (c.type === 'text' && c.value.trim()) throw new JspError(`${file}: text directly inside <c:choose>`);
        }
        for (const w of whens) {
          if (w.tag === 'c:otherwise') return renderNodes(w.children, scope, file, hooks);
          if (w.tag !== 'c:when') throw new JspError(`${file}: <${w.tag}> inside <c:choose>`);
          const t = evalTest(w.attrs.test, scope, file);
          if (t.runtime) {
            // 허용하는 유일한 형태: <c:when test="${fn:length(list) > 0}"> ... <c:otherwise>
            const lm = t.js.match(/^__len\(\s*([A-Za-z_$][\w$]*)\s*\)\s*>\s*0$/);
            if (!lm || markOf(lookup(scope, lm[1])) !== 'list') throw new JspError(`${file}: unsupported runtime test ${w.attrs.test}`);
            const other = whens.find((x) => x.tag === 'c:otherwise');
            const otherHtml = other ? renderNodes(other.children, scope, file, hooks) : '';
            return renderNodes(w.children, scope, file, hooks) +
              `<template data-jsp-empty="${lm[1]}">${otherHtml}</template>`;
          }
          if (t.value) return renderNodes(w.children, scope, file, hooks);
        }
        return '';
      }
      case 'c:forEach': {
        const { items, var: v, varStatus, begin, end, step } = n.attrs;
        if (items !== undefined) {
          const im = items.match(/^\s*\$\{\s*([A-Za-z_$][\w$]*)\s*\}\s*$/);
          if (!im) throw new JspError(`${file}: unsupported forEach items ${items}`);
          const list = lookup(scope, im[1]);
          if (markOf(list) === 'list') {
            if (!v) throw new JspError(`${file}: runtime forEach needs var`);
            const inner = kids({ ...scope, [v]: runtimeRow(v), ...(varStatus ? { [varStatus]: runtimeRow(varStatus) } : {}) });
            return `<template data-jsp-foreach="${im[1]}" data-jsp-var="${v}">${inner}</template>`;
          }
          const arr = list == null ? [] : Array.isArray(list) ? list : Object.values(list);
          return arr.map((item, i) => kids({
            ...scope,
            ...(v ? { [v]: item } : {}),
            ...(varStatus ? { [varStatus]: { index: i, count: i + 1, current: item, first: i === 0, last: i === arr.length - 1 } } : {}),
          })).join('');
        }
        const b = Number(begin), e = Number(end), s = Number(step || 1);
        if (![b, e, s].every(Number.isFinite) || s <= 0) throw new JspError(`${file}: unsupported forEach range`);
        let out = '';
        for (let i = b, c = 1; i <= e; i += s, c++) {
          out += kids({
            ...scope,
            ...(v ? { [v]: i } : {}),
            ...(varStatus ? { [varStatus]: { index: i, count: c, current: i, first: i === b, last: i + s > e } } : {}),
          });
        }
        return out;
      }
      case 'tiles:insertAttribute': {
        let name = n.attrs.name;
        const em = name.match(/^\s*\$\{([\s\S]*)\}\s*$/);
        if (em) name = String(evalJs(translateEl(em[1]), scope));
        const target = tilesDefinition.attrs[name];
        if (!target) throw new JspError(`${file}: tiles attribute "${name}" not in definition`);
        return hooks.insertTile(name, target, scope);
      }
      default:
        throw new JspError(`${file}: unsupported tag <${n.tag}>`);
    }
  }

  function render(file, scope, hooks) {
    const text = preprocess(file);
    const html = renderNodes(parse(text, file).children, scope, file, hooks);
    const left = html.match(/<\/?(c|fn|fmt|tiles|jsp):[\w]+|<%|\$\{/);
    if (left) throw new JspError(`${file}: unprocessed JSP syntax "${left[0]}"`);
    return html;
  }

  return { render, sources };
}

// tiles 로 끼워 넣은 화면(자체 <html>/<head>/<body> 를 가진 JSP)을 조각으로 만든다.
// 원래도 브라우저는 중첩된 html/head/body 태그를 무시하고 안의 요소만 배치했다.
export function flattenFragment(html) {
  return html
    .replace(/<!DOCTYPE[^>]*>/gi, '')
    .replace(/<\/?html\b[^>]*>/gi, '')
    .replace(/<\/?head\b[^>]*>/gi, '')
    .replace(/<\/?body\b[^>]*>/gi, '')
    .replace(/<meta\b[^>]*>/gi, '')
    .replace(/<title>[\s\S]*?<\/title>/gi, '');
}
