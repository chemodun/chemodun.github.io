// The whole reference as one HTML page: a filter bar over 805 collapsible cards.
//
//   node build-html.js                 -> _site/x4/modding-support/ui-modding/lua-globals/
//   OUT=path/to/index.html node build-html.js
//
// Shares every input with build-wiki.js - classification.json and globals.lua, and
// nothing else - which is why CI can build the page from a clean checkout.

const fs = require('fs');
const path = require('path');

const { DATA, names } = require('./page-manifest.js');
const { docs, summaryOf } = require('./docs.js');
const { TONES } = require('./badges.js');
const { verdicts } = require('./usage.js');
const { shell } = require('../layout.js');

const VERSIONS = ['8.00', '9.00'];
const URL = '/x4/modding-support/ui-modding/lua-globals/';
const OUT = process.env.OUT ||
  path.join(__dirname, '..', '..', '_site', ...URL.split('/').filter(Boolean), 'index.html');

// The page's own input is also its most useful download: it is a LuaLS meta file, so it
// is published beside the page rather than left as a build input only.
const LUA = path.join(__dirname, 'globals.lua');
const LUA_KB = Math.round(fs.statSync(LUA).size / 1024);

/* ------------------------------------------------------------------ markup */

const esc = (s) => String(s ?? '')
  .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');

// Prose is plain text with backticked code spans.
const x = (s) => esc(s).replace(/`([^`]+)`/g, (_, t) => `<code>${t}</code>`);
const mono = (s) => `<code>${esc(s)}</code>`;
const badge = (tone, label) => `<b class="t-${tone}">${esc(label)}</b>`;
const tint = (tone, html) => `<span class="t-${tone}">${html}</span>`;
const anchorOf = (n) => 'g-' + n;

/* ------------------------------------------------------------------ fields */

const ORIGIN_TONE = { engine: 'engine', widget: 'widget', addon: 'addon', core: 'new' };
const ORIGIN_LABEL = { engine: 'engine', widget: 'widget_fullscreen', addon: 'addon', core: 'core' };
const SCOPE = {
  all: ['ok', 'addons + core'], addons: ['addon', 'addons only'],
  core: ['new', 'core only'], none: ['gone', 'does not exist'],
};
const USAGE = {
  confirmed: ['ok', 'confirmed'], disputed: ['gone', 'disputed'], unverified: ['warn', 'unverified'],
};

// The index says "widget"; only the card has room for the file name it stands for.
const originBadge = (n, short) => {
  const o = DATA[n].origin;
  const label = short && o === 'widget' ? 'widget' : (ORIGIN_LABEL[o] || 'engine');
  return badge(ORIGIN_TONE[o] || 'engine', label);
};

const scopeBadge = (n, short) => {
  const [tone, label] = SCOPE[DATA[n].scope] || SCOPE.none;
  return badge(tone, short ? label.replace(' only', '').replace('does not exist', 'absent') : label);
};

const kindBadge = (n) => badge(DATA[n].kind === 'function' ? 'no' : 'warn', DATA[n].kind);
const savedOf = (n) => (docs[n] && docs[n].saved) || null;

function verState(n, v) {
  const e = DATA[n], s = e.versions[v];
  if (!s || !s.present) return { tone: 'no', tick: '—', text: 'absent' };
  if (e.delta === 'new in ' + v) return { tone: 'new', tick: 'NEW', text: 'NEW in ' + v };
  return { tone: 'ok', tick: '✓', text: 'present' };
}

function versCell(n, tick) {
  return VERSIONS.map((v) => {
    const s = verState(n, v);
    if (tick) return `<b>${v}</b> ${badge(s.tone, s.tick)}`;
    const areas = DATA[n].versions[v].areas || [];
    return `<b>${v}</b> ${badge(s.tone, s.text)}` +
      (s.tone === 'no' || !areas.length ? '' : ' — ' + esc(areas.join(' + ')));
  }).join('<br>');
}

function summaryCell(n) {
  if (DATA[n].note) return tint('warn', '⚠ ' + x(DATA[n].note));
  const sv = savedOf(n), s = summaryOf(docs[n]);
  return (sv ? badge('warn', 'saved: ' + sv) + ' ' : '') + (s ? x(s) : tint('warn', 'undocumented'));
}

// One line per distinct definition site, every version's line numbers behind it.
function originCell(n) {
  const e = DATA[n], sites = new Map();
  for (const v of VERSIONS) {
    for (const d of e.defs[v] || []) {
      const k = d.rel + '|' + d.via + '|' + (d.impl || '');
      if (!sites.has(k)) sites.set(k, { d, lines: {} });
      const ls = sites.get(k).lines;
      (ls[v] = ls[v] || []).push(d.line);
    }
  }

  const bits = [];
  for (const { d, lines } of sites.values()) {
    const where = VERSIONS.filter((v) => lines[v])
      .map((v) => v + ' ' + lines[v].map((l) => mono(':' + l)).join(' ')).join(', ');
    let s = mono(d.rel);
    if (d.via === 'AddGlobalAccess') s += ' — <code>AddGlobalAccess</code> → ' + mono(d.impl || '?');
    else if (d.via === 'MakeGlobalAvailable') s += ' — <code>MakeGlobalAvailable</code>';
    else if (d.via === 'function') s += ' — top-level <code>function</code>';
    else if (d.via === 'assignment') s += ' — table assignment';
    bits.push(s + (where ? ' (' + where + ')' : ''));
  }
  if (!sites.size) bits.push('<i>injected by the executable; defined in no <code>.lua</code> file</i>');

  if (e.overrides && e.overrides.length) {
    const o = e.overrides[e.overrides.length - 1];
    bits.push(tint('warn', '⚠ vanilla replaces it at runtime') + ' — ' + mono(o.rel + ':' + o.line));
  }
  if (docs[n] && docs[n].mapped) bits.push('maps to ' + mono(docs[n].mapped));
  return originBadge(n) + '<br>' + bits.join('<br>');
}

function availCell(n) {
  const e = DATA[n];
  return scopeBadge(n) + '<br>' + (e.usedIn && e.usedIn.length
    ? 'vanilla calls it from ' + esc(e.usedIn.join(' + '))
    : '<i>no vanilla call site in either version</i>');
}

function usageCell(n) {
  const u = verdicts[n], [tone, label] = USAGE[u.verdict];
  const seen = [...new Set(u.sites.map((s) => s.rel + ':' + s.line))];
  return badge(tone, label) + ' — ' + x(u.detail) +
    (seen.length ? '<br>Seen at ' + seen.map(mono).join(', ') : '');
}

const paramLine = (p) => mono(p.name) + ' <i>' + x(p.type) + '</i>' +
  (p.optional ? ' ' + badge('warn', 'optional') : '') + (p.desc ? ' — ' + x(p.desc) : '');

const returnLine = (r) => (r.name ? mono(r.name) + ' ' : '') + '<i>' + x(r.type) + '</i>' +
  (r.desc ? ' — ' + x(r.desc) : '');

function signature(n) {
  if (docs[n]) return docs[n].signature;
  return DATA[n].group === 'function'
    ? n + '(...)  -- parameters unknown'
    : n + '  -- ' + DATA[n].kind;
}

// Data attributes drive the filter; the haystack is what the text box searches. Only
// the card carries them - the filter reads every facet there and toggles the paired
// index row by position, so repeating 436 KB of haystack on the rows buys nothing.
function facets(n) {
  const e = DATA[n], u = verdicts[n];
  const hay = [n, (docs[n] && docs[n].prose) || '', e.note || ''].join(' ').toLowerCase();
  return `data-o="${e.origin}" data-a="${e.scope}" data-k="${e.group}" data-v="${vtokens(n).join(' ')}"` +
    ` data-u="${e.origin === 'engine' && u ? u.verdict : ''}" data-h="${esc(hay)}"`;
}

// Version is the one multi-valued facet, so it is a token list rather than one value:
// a global is in 8.00, in 9.00, new in 9.00, or in neither.
const vtok = (v) => 'v' + v.replace(/\W/g, '');
function vtokens(n) {
  const e = DATA[n];
  const t = VERSIONS.filter((v) => (e.versions[v] || {}).present).map(vtok);
  if (VERSIONS.some((v) => e.delta === 'new in ' + v)) t.push('new');
  return t.length ? t : ['none'];
}

/* -------------------------------------------------------------------- card */

function card(n) {
  const e = DATA[n], d = docs[n], u = verdicts[n];

  const head = [kindBadge(n), originBadge(n), scopeBadge(n)];
  for (const v of VERSIONS) {
    const s = verState(n, v);
    head.push(badge(s.tone, v + (s.tick === '✓' ? '' : ' ' + s.tick)));
  }
  if (savedOf(n)) head.push(badge('warn', 'saved: ' + savedOf(n)));
  if (u && e.origin === 'engine') {
    const [tone, label] = USAGE[u.verdict];
    head.push(badge(tone, (e.group === 'function' ? 'signature: ' : 'usage: ') + label));
  }

  const rows = [['Kind', kindBadge(n)]];
  if (d && d.classes.length) {
    for (const c of d.classes) {
      rows.push([esc(c.name), c.fields.map(paramLine).join('<br>') || '<i>no fields</i>']);
    }
  }
  if (e.group === 'function') {
    rows.push(['Parameters', d && d.params.length ? d.params.map(paramLine).join('<br>') : '<i>none documented</i>']);
    rows.push(['Returns', d && d.returns.length ? d.returns.map(returnLine).join('<br>') : '<i>none documented</i>']);
  }
  if (savedOf(n)) {
    rows.push(['Saved variable', badge('warn', savedOf(n)) + '<br>' +
      'Declared as a <code>&lt;savedvariable&gt;</code> in the addon’s <code>ui.xml</code>, so the engine ' +
      'restores it before that file runs. ' + (savedOf(n) === 'savegame'
        ? 'Stored in the savegame, so it travels with the save.'
        : 'Stored in <code>userdata.xml</code>, so it is per player profile, not per save.')]);
  }
  rows.push(['Origin', originCell(n)]);
  rows.push(['Availability', availCell(n)]);
  rows.push(['Game versions', versCell(n, false)]);
  if (e.origin === 'engine' && u) rows.push(['Vanilla usage', usageCell(n)]);

  const overloads = d && d.overloads.length
    ? d.overloads.map((o) => '\n-- overload: ' + o).join('') : '';

  const body = `<p class="badges">${head.join(' ')}</p>
<pre><code>${esc(signature(n) + overloads)}</code></pre>
${e.note ? `<p>${tint('gone', '⚠ ' + x(e.note))}</p>` : ''}
${d && d.prose ? `<p>${x(d.prose)}</p>` : ''}
<table>${rows.map(([k, v]) => `<tr><th>${k}</th><td>${v}</td></tr>`).join('')}</table>`;

  return `<details class="card" id="${anchorOf(n)}" ${facets(n)}>
<summary><code class="nm">${esc(n)}</code> ${originBadge(n, true)} ${scopeBadge(n, true)} \
<span class="vs">${versCell(n, true).replace('<br>', ' ')}</span> \
<span class="sum">${summaryCell(n)}</span></summary>
${body}</details>`;
}

/* -------------------------------------------------------------------- page */

const counts = (v) => names.filter((n) => DATA[n].origin === v).length;

// Only the badge tones live here; the base theme comes from ../layout.js.
const tokens = (pick) => Object.entries(TONES).map(([k, t]) => `--t-${k}:${pick(t)};`).join('');

const CSS = `
:root{${tokens((t) => t.hue)}}
@media (prefers-color-scheme:dark){:root:not([data-theme=light]){${tokens((t) => t.lite)}}}
:root[data-theme=dark]{${tokens((t) => t.lite)}}
${Object.keys(TONES).map((k) => `.t-${k}{color:var(--t-${k})}`).join('')}
b[class^=t-]{font-weight:700;white-space:nowrap}
.badges{display:flex;flex-wrap:wrap;gap:.15em .9em;margin:.2em 0 .7em;font-size:.86rem}
.card table{margin:.6em 0;font-size:.92rem}
.card table th{width:150px;white-space:nowrap;padding:6px 9px}
.card table td{padding:6px 9px}
/* the point of a single page: the browser skips layout and paint for offscreen cards */
.card{content-visibility:auto;contain-intrinsic-size:0 46px;border:1px solid var(--line);
  border-radius:8px;margin:0 0 8px;scroll-margin-top:76px}
.card[open]{contain-intrinsic-size:0 480px;padding-bottom:12px}
.card>summary{position:relative;padding:9px 14px 9px 32px;display:flex;gap:.6em .9em;
  align-items:baseline;flex-wrap:wrap;font-size:.92rem;cursor:pointer;border-radius:7px;
  list-style:none}
/* display:flex drops the native marker, so the chevron is drawn here instead. It is
   positioned, not a flex item: in flow it would centre against a wrapped summary and
   drift off the first line. */
.card>summary::-webkit-details-marker{display:none}
.card>summary::before{content:"";position:absolute;left:15px;top:calc(9px + .58em);
  width:.45em;height:.45em;border-right:2px solid var(--dim);border-bottom:2px solid var(--dim);
  transform:rotate(-45deg);transition:transform .15s ease}
.card[open]>summary::before{transform:rotate(45deg)}
.card>summary:hover{background:var(--soft)}
.card>summary:hover::before{border-color:var(--acc)}
.card>summary:hover .nm{color:var(--acc)}
.card>summary .nm{font-weight:600;background:none;padding:0;font-size:.95rem;overflow-wrap:anywhere}
.card>summary .vs{font-size:.85rem;white-space:nowrap}
.card>summary .sum{flex:1 1 22em;color:var(--dim);font-size:.88rem}
.card[open]>summary{border-bottom:1px solid var(--line);border-radius:7px 7px 0 0;margin-bottom:10px}
.card>*:not(summary){margin-left:14px;margin-right:14px}
.bar{position:sticky;top:0;z-index:5;background:var(--bg);border-bottom:1px solid var(--line);
  padding:10px 0;margin-bottom:14px;display:flex;gap:10px;flex-wrap:wrap;align-items:center}
.bar input{flex:1;min-width:220px}
.bar input,.bar select,.bar button{padding:7px 10px;border:1px solid var(--line);
  border-radius:6px;background:var(--soft);color:var(--fg);font:inherit}
.bar button{cursor:pointer}
.bar .n{color:var(--dim);font-size:.86rem;white-space:nowrap}
.hide{display:none!important}
.dl{display:flex;flex-wrap:wrap;gap:.6em 1.1em;align-items:center;margin:1.2em 0;
  padding:13px 16px;border:1px solid var(--line);border-radius:8px;background:var(--soft)}
.dl a.btn{font-weight:600;text-decoration:none;white-space:nowrap;padding:7px 14px;
  border:1px solid var(--acc);border-radius:6px;color:var(--acc)}
.dl a.btn:hover{background:var(--acc);color:var(--bg)}
.dl a.btn code{background:none;padding:0;color:inherit;font-size:.96em}
.dl p{flex:1 1 26em;margin:0;color:var(--dim);font-size:.9rem}
details{border:1px solid var(--line);border-radius:8px;padding:10px 14px;margin:1em 0;background:var(--soft)}
summary{cursor:pointer;font-weight:600}
@media(max-width:720px){.card table th{width:auto;white-space:normal}.wrap{padding:16px 10px 60px}}
`;

const JS = `
const q=document.getElementById('q'),out=document.getElementById('n'),
  sel=[...document.querySelectorAll('.bar select')],
  pairs=[...document.querySelectorAll('.card')].map(c=>({c,h:c.dataset.h,o:c.dataset.o,
    a:c.dataset.a,u:c.dataset.u,k:c.dataset.k,v:' '+c.dataset.v+' '}));
let t;
function run(){
  const s=q.value.trim().toLowerCase(),f=Object.fromEntries(sel.map(e=>[e.name,e.value]));
  let n=0;
  for(const p of pairs){
    const ok=(!s||p.h.includes(s))&&(!f.o||p.o===f.o)&&(!f.a||p.a===f.a)&&(!f.u||p.u===f.u)
      &&(!f.k||p.k===f.k)&&(!f.v||p.v.includes(' '+f.v+' '));
    p.c.classList.toggle('hide',!ok);if(ok)n++;
  }
  out.textContent=n+' of '+pairs.length;
}
q.addEventListener('input',()=>{clearTimeout(t);t=setTimeout(run,120)});
sel.forEach(e=>e.addEventListener('change',run));
// Reset returns to the page's default view (9.00), not to no filter at all.
document.getElementById('clr').addEventListener('click',()=>{
  q.value='';sel.forEach(e=>e.value=e.dataset.def);run();q.focus();
});
run();
// A deep link must reach its card: open it, and drop the filters if the default
// view hides it - the three globals in neither version are hidden on load.
function openHash(){
  if(!location.hash)return;
  const el=document.querySelector(location.hash);
  if(!el)return;
  if(el.classList.contains('hide')){q.value='';sel.forEach(e=>e.value='');run();}
  if(el.tagName==='DETAILS')el.open=true;
  el.scrollIntoView();
}
addEventListener('hashchange',openHash);openHash();
`;

const select = (name, label, vals, def = '') =>
  `<select name="${name}" data-def="${def}" aria-label="${label}"><option value="">${label}: all</option>` +
  vals.map(([v, l]) => `<option value="${v}"${v === def ? ' selected' : ''}>${l}</option>`).join('') +
  '</select>';

const vcount = (t) => names.filter((n) => vtokens(n).includes(t)).length;
const VERSION_OPTS = [
  ...VERSIONS.map((v) => [vtok(v), `in ${v} (${vcount(vtok(v))})`]),
  ['new', `new in ${VERSIONS[VERSIONS.length - 1]} (${vcount('new')})`],
  ['none', `in neither (${vcount('none')})`],
];
const DEFAULT_VERSION = vtok(VERSIONS[VERSIONS.length - 1]);

function body() {
  return `
<h1>Lua Globals Reference</h1>
<p class="lede">Every name X4: Foundations puts into the global namespace of X4 UI Lua code — what creates it, which of the two Lua environments can see it, and which game version has it.</p>
<p class="lede"><b>${names.length} globals</b> in 9.00: ${counts('engine')} injected by the executable, ${counts('widget')} from <code>widget_fullscreen.lua</code>, ${counts('addon')} from an addon file, ${counts('core')} from a core file. Availability and version presence are <b>verified in the game</b>, not inferred from the code: every row reports what each Lua environment actually holds, on each version.</p>

<div class="dl">
<a class="btn" href="${URL}globals.lua" download>Download <code>globals.lua</code></a>
<p>${LUA_KB} KB. The same ${names.length} declarations as a Lua Language Server meta file — every global with its description, parameters and returns. Point an editor at it as a library and X4's globals get completion and signatures while UI Lua is being written.</p>
</div>

<details><summary>Using it in an editor</summary>
<p>The Lua Language Server reads a meta file when it is listed as a workspace library. In VS Code that is <code>.luarc.json</code> beside the workspace root, or the same key in settings:</p>
<pre><code>{
  "workspace.library": [ "path/to/globals.lua" ]
}</code></pre>
<p>The file declares names only — it is never executed and never loaded by the game. It covers the global namespace; for the wider set of X4 Lua definitions there is a packaged addon, <a href="https://github.com/chemodun/X4-LuaLSAddon">X4-LuaLSAddon</a>, installable through the Lua extension's addon manager.</p>
</details>

<details><summary>How to read a row</summary>
<table>
<tr><th>Origin</th><td>${badge('engine', 'engine')} injected by the game executable, defined in no <code>.lua</code> file.<br>
${badge('widget', 'widget_fullscreen')} written in <code>ui/widget/lua/widget_fullscreen.lua</code>.<br>
${badge('addon', 'addon')} a top-level definition in a <code>ui/addons/*</code> file.<br>
${badge('new', 'core')} a top-level definition in a <code>ui/core/*</code> HUD file.</td></tr>
<tr><th>Availability</th><td>${badge('ok', 'addons + core')} present in both Lua environments.<br>
${badge('addon', 'addons only')} only where <code>ui/addons/*</code> menus run.<br>
${badge('new', 'core only')} only in the HUD environment — addon code cannot reach these.<br>
${badge('gone', 'absent')} declared, but present in neither version.</td></tr>
<tr><th>Signature</th><td>${badge('ok', 'confirmed')} vanilla calls it, and every argument count fits the declaration.<br>
${badge('gone', 'disputed')} vanilla passes a count the declaration cannot take — believe the call site.<br>
${badge('warn', 'unverified')} no vanilla code calls it at all.</td></tr>
<tr><th>Saved</th><td>${badge('warn', 'saved: userdata')} / ${badge('warn', 'saved: savegame')} — a <code>&lt;savedvariable&gt;</code> in the addon’s <code>ui.xml</code>. The engine restores the previous value <i>before</i> that file runs, which is why vanilla creates every one of them with <code>X = X or { }</code>.</td></tr>
</table></details>

<h2 id="index">All globals</h2>
<div class="bar">
<input id="q" type="search" placeholder="Filter by name or description…" autocomplete="off">
${select('o', 'Origin', [['engine', 'engine'], ['widget', 'widget_fullscreen'], ['addon', 'addon'], ['core', 'core']])}
${select('a', 'Availability', [['all', 'addons + core'], ['addons', 'addons only'], ['core', 'core only'], ['none', 'absent']])}
${select('u', 'Signature', [['confirmed', 'confirmed'], ['unverified', 'unverified'], ['disputed', 'disputed']])}
${select('k', 'Kind', [['function', 'functions'], ['variable', 'variables']])}
${select('v', 'Version', VERSION_OPTS, DEFAULT_VERSION)}
<button id="clr" type="button">Reset</button><span class="n" id="n">${vcount(DEFAULT_VERSION)} of ${names.length}</span>
</div>
${names.map(card).join('\n')}
`;
}

const html = shell({
  title: 'Lua Globals Reference',
  description: 'Every name X4: Foundations puts into the global namespace of X4 UI Lua code: ' +
    'what creates it, which Lua environment sees it, and which game version has it.',
  trail: [
    { label: 'Home', href: '/' },
    { label: 'For X4: Foundations', href: '/x4/' },
    { label: 'Modding Support', href: '/x4/modding-support/' },
    { label: 'UI Modding support', href: '/x4/modding-support/ui-modding/' },
    { label: 'Lua Globals Reference', href: URL },
  ],
  body: body(),
  css: CSS,
  js: JS,
});
fs.mkdirSync(path.dirname(OUT), { recursive: true });
fs.writeFileSync(OUT, html, 'utf8');
fs.copyFileSync(LUA, path.join(path.dirname(OUT), 'globals.lua'));

const nodes = (html.match(/<(article|tr|td|th|p|pre|code|span|b|i|br|a)\b/g) || []).length;
console.log('wrote ' + OUT);
console.log('wrote ' + path.join(path.dirname(OUT), 'globals.lua') + ' (' + LUA_KB + ' KB)');
console.log(names.length + ' globals, ' + Math.round(html.length / 1024) + ' KB, ~' +
  nodes.toLocaleString('en-US') + ' elements');
