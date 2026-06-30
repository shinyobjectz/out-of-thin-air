/* Code-as component UI — custom controls on Basecoat (https://basecoatui.com).
   No native selects, range inputs, checkboxes, or media controls in the shell. */
(function (global) {
  'use strict';

  var CHEV = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-muted-foreground opacity-50 shrink-0"><path d="m6 9 6 6 6-6"/></svg>';
  var PLAY = '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>';
  var PAUSE = '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/></svg>';

  function esc(s) {
    return String(s == null ? '' : s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;');
  }

  function uid(prefix) {
    return prefix + '-' + Math.random().toString(36).slice(2, 9);
  }

  function fmtTime(s) {
    s = Math.max(0, Math.floor(s || 0));
    var m = Math.floor(s / 60), sec = s % 60;
    return m + ':' + (sec < 10 ? '0' : '') + sec;
  }

  function initBasecoat() {
    if (global.basecoat && global.basecoat.initAll) global.basecoat.initAll();
  }

  /** Draggable rail width — persists per surface type. */
  function initResize(shell, rail, handle, key) {
    if (!shell || !rail || !handle) return;
    key = key || 'cc-rail-w';
    var saved = parseInt(localStorage.getItem(key) || '280', 10);
    if (saved >= 200 && saved <= 520) shell.style.setProperty('--cc-rail-w', saved + 'px');

    var dragging = false;
    function onMove(e) {
      if (!dragging) return;
      var x = e.clientX != null ? e.clientX : (e.touches && e.touches[0] && e.touches[0].clientX);
      if (x == null) return;
      var w = Math.min(520, Math.max(200, x));
      shell.style.setProperty('--cc-rail-w', w + 'px');
      localStorage.setItem(key, String(Math.round(w)));
    }
    function stop() { dragging = false; document.body.classList.remove('cc-resizing'); }
    handle.addEventListener('mousedown', function (e) { e.preventDefault(); dragging = true; document.body.classList.add('cc-resizing'); });
    handle.addEventListener('touchstart', function (e) { dragging = true; document.body.classList.add('cc-resizing'); }, { passive: true });
    window.addEventListener('mousemove', onMove);
    window.addEventListener('touchmove', onMove, { passive: true });
    window.addEventListener('mouseup', stop);
    window.addEventListener('touchend', stop);
  }

  /** Div-based scrubber — syncs to a hidden video element. */
  function bindVideoTransport(container, video) {
    if (!container || !video) return;
    container.innerHTML =
      '<button type="button" class="btn" data-variant="ghost" data-size="icon-sm" id="cc-transport-toggle" aria-label="Play">' + PLAY + '</button>' +
      '<div class="ca-scrub" id="cc-scrub" role="slider" aria-valuemin="0" aria-valuemax="1000" aria-valuenow="0" tabindex="0">' +
      '  <div class="ca-scrub-track"><div class="ca-scrub-fill"></div></div>' +
      '  <div class="ca-scrub-thumb"></div>' +
      '</div>' +
      '<span class="ca-time" id="cc-time">0:00 / 0:00</span>';

    var toggle = container.querySelector('#cc-transport-toggle');
    var scrub = container.querySelector('#cc-scrub');
    var fill = scrub.querySelector('.ca-scrub-fill');
    var thumb = scrub.querySelector('.ca-scrub-thumb');
    var timeEl = container.querySelector('#cc-time');
    var ratio = 0, scrubbing = false;

    function setRatio(r) {
      ratio = Math.min(1, Math.max(0, r));
      fill.style.width = (ratio * 100) + '%';
      thumb.style.left = (ratio * 100) + '%';
      scrub.setAttribute('aria-valuenow', String(Math.round(ratio * 1000)));
      if (video.duration && !scrubbing) video.currentTime = ratio * video.duration;
    }

    function sync() {
      if (!video.duration) return;
      if (!scrubbing) ratio = video.currentTime / video.duration;
      fill.style.width = (ratio * 100) + '%';
      thumb.style.left = (ratio * 100) + '%';
      scrub.setAttribute('aria-valuenow', String(Math.round(ratio * 1000)));
      timeEl.textContent = fmtTime(video.currentTime) + ' / ' + fmtTime(video.duration);
      toggle.innerHTML = video.paused ? PLAY : PAUSE;
      toggle.setAttribute('aria-label', video.paused ? 'Play' : 'Pause');
    }

    function posFromEvent(e) {
      var rect = scrub.getBoundingClientRect();
      var x = e.clientX != null ? e.clientX : (e.touches && e.touches[0] && e.touches[0].clientX);
      return Math.min(1, Math.max(0, (x - rect.left) / rect.width));
    }

    toggle.addEventListener('click', function () { video.paused ? video.play() : video.pause(); });
    video.addEventListener('loadedmetadata', sync);
    video.addEventListener('timeupdate', sync);
    video.addEventListener('play', sync);
    video.addEventListener('pause', sync);

    scrub.addEventListener('mousedown', function (e) { scrubbing = true; setRatio(posFromEvent(e)); });
    scrub.addEventListener('touchstart', function (e) { scrubbing = true; setRatio(posFromEvent(e)); }, { passive: true });
    window.addEventListener('mousemove', function (e) { if (scrubbing) setRatio(posFromEvent(e)); });
    window.addEventListener('touchmove', function (e) { if (scrubbing) setRatio(posFromEvent(e)); }, { passive: true });
    window.addEventListener('mouseup', function () { if (scrubbing) { scrubbing = false; sync(); } });
    window.addEventListener('touchend', function () { if (scrubbing) { scrubbing = false; sync(); } });
    scrub.addEventListener('keydown', function (e) {
      var step = e.shiftKey ? 0.05 : 0.01;
      if (e.key === 'ArrowRight') { setRatio(ratio + step); e.preventDefault(); }
      if (e.key === 'ArrowLeft') { setRatio(ratio - step); e.preventDefault(); }
    });
  }

  /** Custom div slider for player.work range fields. */
  function bindFieldSlider(root, min, max, step, value, onChange) {
    min = +min || 0; max = +max || 100; step = +step || 1;
    var val = +value || min;
    var ratio = (val - min) / (max - min || 1);
    var fill = root.querySelector('.ca-scrub-fill');
    var thumb = root.querySelector('.ca-scrub-thumb');
    var label = root.querySelector('.ca-field-val');
    var dragging = false;

    function emit(v) {
      val = Math.min(max, Math.max(min, v));
      ratio = (val - min) / (max - min || 1);
      fill.style.width = (ratio * 100) + '%';
      thumb.style.left = (ratio * 100) + '%';
      if (label) label.textContent = String(val);
      root.setAttribute('aria-valuenow', String(Math.round(val)));
      if (onChange) onChange(String(val));
    }

    function posFromEvent(e) {
      var rect = root.getBoundingClientRect();
      var x = e.clientX != null ? e.clientX : (e.touches && e.touches[0] && e.touches[0].clientX);
      var r = Math.min(1, Math.max(0, (x - rect.left) / rect.width));
      var stepped = Math.round((min + r * (max - min)) / step) * step;
      emit(stepped);
    }

    emit(val);
    root.addEventListener('mousedown', function (e) { dragging = true; posFromEvent(e); });
    root.addEventListener('touchstart', function (e) { dragging = true; posFromEvent(e); }, { passive: true });
    window.addEventListener('mousemove', function (e) { if (dragging) posFromEvent(e); });
    window.addEventListener('touchmove', function (e) { if (dragging) posFromEvent(e); }, { passive: true });
    window.addEventListener('mouseup', function () { dragging = false; });
    window.addEventListener('touchend', function () { dragging = false; });
    return { get: function () { return String(val); } };
  }

  function fieldHint(h) {
    return h ? '<p class="ca-hint">' + esc(h) + '</p>' : '';
  }

  function fieldText(key, label, value, hint) {
    var id = uid('fld');
    return '<div role="group" class="field" data-k="' + esc(key) + '" data-type="text">' +
      '<label for="' + id + '">' + esc(label) + '</label>' +
      '<div class="ca-text" id="' + id + '" role="textbox" contenteditable="plaintext-only" spellcheck="false" data-k="' + esc(key) + '">' + esc(value) + '</div>' +
      fieldHint(hint) +
      '<input type="hidden" name="' + esc(key) + '" value="' + esc(value) + '" data-k="' + esc(key) + '">' +
      '</div>';
  }

  function fieldTextarea(key, label, value, hint) {
    var id = uid('fld');
    return '<div role="group" class="field" data-k="' + esc(key) + '" data-type="textarea">' +
      '<label for="' + id + '">' + esc(label) + '</label>' +
      '<div class="ca-text ca-text-area" id="' + id + '" role="textbox" contenteditable="plaintext-only" spellcheck="false" data-k="' + esc(key) + '">' + esc(value) + '</div>' +
      fieldHint(hint) +
      '<input type="hidden" name="' + esc(key) + '" value="' + esc(value) + '" data-k="' + esc(key) + '">' +
      '</div>';
  }

  function fieldSelect(key, label, options, value, hint) {
    var sid = uid('sel');
    var opts = (options || '').split(',').map(function (o) { return o.trim(); }).filter(Boolean);
    var items = opts.map(function (o) {
      var sel = o === value ? ' aria-selected="true"' : '';
      return '<div role="option" data-value="' + esc(o) + '"' + sel + '>' + esc(o) + '</div>';
    }).join('');
    return '<div role="group" class="field" data-k="' + esc(key) + '" data-type="select">' +
      '<label for="' + sid + '-trigger">' + esc(label) + '</label>' +
      '<div id="' + sid + '" class="select w-full" data-placeholder="' + esc(label) + '">' +
      '  <button type="button" class="w-full" id="' + sid + '-trigger" aria-haspopup="listbox" aria-expanded="false" aria-controls="' + sid + '-listbox">' +
      '    <span class="truncate">' + esc(value || label) + '</span>' + CHEV +
      '  </button>' +
      '  <div data-popover aria-hidden="true">' +
      '    <div role="listbox" id="' + sid + '-listbox" aria-orientation="vertical" aria-labelledby="' + sid + '-trigger">' + items + '</div>' +
      '  </div>' +
      '  <input type="hidden" name="' + esc(key) + '" value="' + esc(value) + '" data-k="' + esc(key) + '">' +
      '</div></div>' + fieldHint(hint);
  }

  function fieldRange(key, label, min, max, step, value, hint) {
    return '<div role="group" class="field" data-k="' + esc(key) + '" data-type="range">' +
      '<div class="ca-field-head"><label>' + esc(label) + '</label><span class="ca-field-val">' + esc(value || min) + '</span></div>' +
      '<div class="ca-scrub ca-scrub-sm" role="slider" aria-valuemin="' + esc(min) + '" aria-valuemax="' + esc(max) + '" tabindex="0" data-k="' + esc(key) + '">' +
      '  <div class="ca-scrub-track"><div class="ca-scrub-fill"></div></div>' +
      '  <div class="ca-scrub-thumb"></div>' +
      '</div>' +
      '<input type="hidden" name="' + esc(key) + '" value="' + esc(value || min) + '" data-k="' + esc(key) + '">' +
      '</div>' + fieldHint(hint);
  }

  function fieldToggle(key, label, value, hint) {
    var on = value === 'true' || value === '1';
    return '<div role="group" class="field ca-toggle-field" data-k="' + esc(key) + '" data-type="toggle">' +
      '<span>' + esc(label) + '</span>' +
      '<button type="button" class="ca-switch' + (on ? ' on' : '') + '" role="switch" aria-checked="' + (on ? 'true' : 'false') + '" data-k="' + esc(key) + '">' +
      '  <span class="ca-switch-thumb"></span>' +
      '</button>' +
      '<input type="hidden" name="' + esc(key) + '" value="' + (on ? 'true' : 'false') + '" data-k="' + esc(key) + '">' +
      '</div>' + fieldHint(hint);
  }

  function fieldColor(key, label, value, hint) {
    value = value || '#09090b';
    return '<div role="group" class="field" data-k="' + esc(key) + '" data-type="color">' +
      '<label>' + esc(label) + '</label>' +
      '<div class="ca-color">' +
      '  <button type="button" class="ca-color-swatch" style="--swatch:' + esc(value) + '" aria-label="' + esc(label) + '" data-k="' + esc(key) + '"></button>' +
      '  <div class="ca-color-panel" hidden>' +
      '    <input type="color" class="ca-color-native" value="' + esc(value) + '" data-k="' + esc(key) + '" tabindex="-1" aria-hidden="true">' +
      '  </div>' +
      '  <span class="ca-color-val">' + esc(value) + '</span>' +
      '</div>' +
      '<input type="hidden" name="' + esc(key) + '" value="' + esc(value) + '" data-k="' + esc(key) + '">' +
      '</div>' + fieldHint(hint);
  }

  function wireFields(container) {
    if (!container) return;
    container.querySelectorAll('.ca-text[contenteditable]').forEach(function (el) {
      var hidden = container.querySelector('input[type="hidden"][data-k="' + el.dataset.k + '"]');
      el.addEventListener('input', function () { if (hidden) hidden.value = el.textContent.trim(); });
    });
    container.querySelectorAll('.field[data-type="range"] .ca-scrub').forEach(function (scrub) {
      var field = scrub.closest('.field');
      var hidden = field.querySelector('input[type="hidden"]');
      var min = field.querySelector('[aria-valuemin]') && scrub.getAttribute('aria-valuemin');
      var max = scrub.getAttribute('aria-valuemax');
      bindFieldSlider(scrub, min, max, 1, hidden && hidden.value, function (v) { if (hidden) hidden.value = v; });
    });
    container.querySelectorAll('.ca-switch').forEach(function (btn) {
      var hidden = container.querySelector('input[type="hidden"][data-k="' + btn.dataset.k + '"]');
      btn.addEventListener('click', function () {
        var on = btn.getAttribute('aria-checked') !== 'true';
        btn.classList.toggle('on', on);
        btn.setAttribute('aria-checked', on ? 'true' : 'false');
        if (hidden) hidden.value = on ? 'true' : 'false';
      });
    });
    container.querySelectorAll('.ca-color').forEach(function (wrap) {
      var swatch = wrap.querySelector('.ca-color-swatch');
      var panel = wrap.querySelector('.ca-color-panel');
      var native = wrap.querySelector('.ca-color-native');
      var valEl = wrap.querySelector('.ca-color-val');
      var hidden = wrap.parentElement.querySelector('input[type="hidden"]');
      swatch.addEventListener('click', function () { panel.hidden = !panel.hidden; if (!panel.hidden && native) native.click(); });
      if (native) native.addEventListener('input', function () {
        swatch.style.setProperty('--swatch', native.value);
        if (valEl) valEl.textContent = native.value;
        if (hidden) hidden.value = native.value;
      });
    });
    container.querySelectorAll('.select').forEach(function (sel) {
      sel.addEventListener('change', function (e) {
        var hidden = sel.querySelector('input[type="hidden"]');
        if (hidden && e.detail && e.detail.value != null) hidden.value = e.detail.value;
      });
    });
    initBasecoat();
  }

  function renderControls(container, controls, params) {
    if (!container) return;
    var html = (controls || []).map(function (c) {
      var key = c.param || c.key;
      var val = params && params[key] != null ? params[key] : '';
      var hint = c.hint || '';
      if (c.type === 'select') return fieldSelect(key, c.label || key, c.options, val, hint);
      if (c.type === 'range') return fieldRange(key, c.label || key, c.min || 0, c.max || 100, c.step || 1, val, hint);
      if (c.type === 'toggle') return fieldToggle(key, c.label || key, val, hint);
      if (c.type === 'color') return fieldColor(key, c.label || key, val, hint);
      if (c.type === 'textarea') return fieldTextarea(key, c.label || key, val, hint);
      return fieldText(key, c.label || key, val, hint);
    }).join('');
    container.innerHTML = html || '<p class="text-muted-foreground text-sm">Agent defines controls in <code>player.work</code>.</p>';
    wireFields(container);
  }

  function readParams(container) {
    var o = {};
    if (!container) return o;
    container.querySelectorAll('input[type="hidden"][data-k]').forEach(function (el) { o[el.dataset.k] = el.value; });
    return o;
  }

  function renderScenes(list, compositions, videos, onPick) {
    if (!list) return;
    list.innerHTML = '';
    (compositions || []).forEach(function (c, i) {
      var li = document.createElement('li');
      var btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'ca-scene-btn';
      btn.textContent = c.label || c.composition;
      btn.dataset.composition = c.composition;
      if (c.default && i === 0) btn.classList.add('on');
      btn.addEventListener('click', function () {
        list.querySelectorAll('.ca-scene-btn').forEach(function (n) { n.classList.toggle('on', n === btn); });
        var vid = (videos || []).find(function (v) { return v.composition === c.composition; });
        if (onPick) onPick(c, vid);
      });
      li.appendChild(btn);
      list.appendChild(li);
      if (c.default) btn.click();
    });
  }

  /** Render one artifact into the stage. Returns the media element (video/audio) or null. */
  function renderArtifact(stage, art) {
    if (!stage) return null;
    stage.innerHTML = '';
    art = art || {};
    var kind = art.kind, url = art.url;
    if (!url) {
      stage.innerHTML = '<div class="ca-art-empty"><p class="text-muted-foreground">Nothing to preview yet.</p></div>';
      return null;
    }
    var el, media = null;
    if (kind === 'video' || kind === 'audio') {
      media = document.createElement(kind);
      media.preload = 'metadata';
      if (kind === 'video') media.playsInline = true;
      media.src = url + (url.indexOf('?') < 0 ? '?' : '&') + 't=' + Date.now();
      el = media;
    } else if (kind === 'image' || kind === 'svg') {
      el = document.createElement('img');
      el.src = url;
      el.alt = art.label || 'artifact';
    } else if (kind === 'pdf' || kind === 'html') {
      el = document.createElement('iframe');
      el.src = url;
      el.setAttribute('title', art.label || 'preview');
    } else if (kind === 'model3d') {
      el = document.createElement('model-viewer');
      el.setAttribute('src', url);
      el.setAttribute('camera-controls', '');
      el.setAttribute('auto-rotate', '');
    } else {
      el = document.createElement('pre');
      el.textContent = 'Loading…';
      fetch(url).then(function (r) { return r.text(); })
        .then(function (t) { el.textContent = t; })
        .catch(function () { el.textContent = '(could not load)'; });
    }
    el.classList.add('ca-art-el', 'ca-art-' + (kind || 'text'));
    stage.appendChild(el);
    return media;
  }

  /** Center version tabs — one per artifact. Calls onPick(artifact) on select. */
  function renderVersionTabs(container, artifacts, onPick) {
    if (!container) return;
    container.innerHTML = '';
    (artifacts || []).forEach(function (a, i) {
      var b = document.createElement('button');
      b.type = 'button';
      b.className = 'ca-vtab' + (a.default ? ' on' : '');
      b.textContent = a.label || String(i + 1);
      b.dataset.id = a.id != null ? a.id : String(i);
      b.addEventListener('click', function () {
        container.querySelectorAll('.ca-vtab').forEach(function (n) { n.classList.toggle('on', n === b); });
        if (onPick) onPick(a);
      });
      container.appendChild(b);
    });
    container.style.display = (artifacts && artifacts.length > 1) ? 'flex' : 'none';
  }

  /** Collapse the rail to preview-only; persists per key. */
  function initCollapse(shell, btn, key) {
    if (!shell || !btn) return;
    key = key || 'cc-rail-collapsed';
    var collapsed = localStorage.getItem(key) === '1';
    function apply(c) {
      shell.classList.toggle('rail-collapsed', c);
      btn.setAttribute('aria-pressed', c ? 'true' : 'false');
    }
    apply(collapsed);
    btn.addEventListener('click', function () {
      collapsed = !collapsed;
      localStorage.setItem(key, collapsed ? '1' : '0');
      apply(collapsed);
    });
  }

  /** Dirty-aware Save button. opts: {watch, getParams, baseline, onSave}. */
  function initSaveState(btn, opts) {
    if (!btn) return { refresh: function () {}, setBaseline: function () {} };
    var baseline = opts.baseline || {};
    function dirty() {
      var p = opts.getParams();
      return Object.keys(p).some(function (k) {
        return String(p[k]) !== String(baseline[k] == null ? '' : baseline[k]);
      });
    }
    function refresh() {
      var d = dirty();
      btn.disabled = !d;
      btn.textContent = d ? 'Save changes' : 'Saved';
      btn.classList.toggle('is-dirty', d);
    }
    if (opts.watch) {
      opts.watch.addEventListener('input', refresh);
      opts.watch.addEventListener('change', refresh);
    }
    btn.addEventListener('click', function () {
      if (btn.disabled) return;
      btn.disabled = true;
      btn.textContent = 'Saving…';
      Promise.resolve(opts.onSave(opts.getParams())).then(function (ok) {
        if (ok !== false) baseline = opts.getParams();
        refresh();
      }).catch(function () { refresh(); });
    });
    refresh();
    return { refresh: refresh, setBaseline: function (b) { baseline = b || {}; refresh(); } };
  }

  global.CodeAsUI = {
    esc: esc, fmtTime: fmtTime, uid: uid,
    ready: function (fn) {
      function run() {
        if (!global.CodeAsUI) return requestAnimationFrame(run);
        fn(global.CodeAsUI);
      }
      if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', run);
      else run();
    },
    initResize: initResize,
    bindVideoTransport: bindVideoTransport,
    renderControls: renderControls,
    readParams: readParams,
    renderScenes: renderScenes,
    renderArtifact: renderArtifact,
    renderVersionTabs: renderVersionTabs,
    initCollapse: initCollapse,
    initSaveState: initSaveState,
    initBasecoat: initBasecoat
  };
})(typeof window !== 'undefined' ? window : globalThis);
