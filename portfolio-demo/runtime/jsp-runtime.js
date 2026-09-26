/*
 * 서버가 JSP 를 그릴 때 채우던 값 중 빌드 시점에 알 수 없는 것을 브라우저에서 채운다.
 *  - <template data-jsp-foreach="list" data-jsp-var="row"> : 원본 <c:forEach items="${list}" var="row"> 본문
 *  - <template data-jsp-empty="list">                       : 원본 <c:otherwise> (목록이 비었을 때)
 *  - {{param.NAME}}                                        : 원본 ${NAME} (컨트롤러가 요청 파라미터를 모델로 넘기던 값)
 * 값은 모두 HTML 이스케이프하거나 textContent/속성값으로만 넣는다.
 */
(function (root, factory) {
  var api = factory();
  if (typeof module === 'object' && module.exports) module.exports = api;
  else root.DrHerJspRuntime = api;
})(typeof self !== 'undefined' ? self : this, function () {
  'use strict';

  function escapeHtml(v) {
    return String(v)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function expandRow(html, varName, item) {
    return html.replace(/\{\{(\w+)\.(\w+)\}\}/g, function (m, rootName, key) {
      if (rootName !== varName) return m;
      var v = item[key];
      return v === null || v === undefined ? '' : escapeHtml(v);
    });
  }

  function replaceParams(text, params) {
    return text.replace(/\{\{param\.(\w+)\}\}/g, function (m, key) {
      var v = params[key];
      return v === null || v === undefined ? '' : String(v);
    });
  }

  function render(doc, model, params) {
    var i;
    var loops = doc.querySelectorAll('template[data-jsp-foreach]');
    for (i = 0; i < loops.length; i++) {
      var t = loops[i];
      var name = t.getAttribute('data-jsp-foreach');
      var items = model[name];
      if (!Array.isArray(items)) throw new Error('[demo] 화면 모델에 목록이 없습니다: ' + name);
      var varName = t.getAttribute('data-jsp-var');
      var html = items.map(function (item) { return expandRow(t.innerHTML, varName, item); }).join('');
      t.insertAdjacentHTML('beforebegin', html);
      t.parentNode.removeChild(t);
    }
    var empties = doc.querySelectorAll('template[data-jsp-empty]');
    for (i = 0; i < empties.length; i++) {
      var e = empties[i];
      var list = model[e.getAttribute('data-jsp-empty')];
      if (!Array.isArray(list)) throw new Error('[demo] 화면 모델에 목록이 없습니다: ' + e.getAttribute('data-jsp-empty'));
      if (list.length === 0) e.insertAdjacentHTML('beforebegin', e.innerHTML);
      e.parentNode.removeChild(e);
    }

    // 요청 파라미터 토큰: 글자 노드와 속성값만 바꾼다(HTML 로 해석하지 않는다).
    var walker = doc.createTreeWalker(doc.body, 1 | 4, null);
    var node;
    while ((node = walker.nextNode())) {
      if (node.nodeType === 3) {
        if (node.parentNode.tagName !== 'SCRIPT' && node.nodeValue.indexOf('{{') > -1) node.nodeValue = replaceParams(node.nodeValue, params);
      } else if (node.tagName !== 'SCRIPT') {
        for (var a = 0; a < node.attributes.length; a++) {
          var attr = node.attributes[a];
          if (attr.value.indexOf('{{') > -1) attr.value = replaceParams(attr.value, params);
        }
      }
    }
  }

  return { render: render, escapeHtml: escapeHtml, expandRow: expandRow };
});
