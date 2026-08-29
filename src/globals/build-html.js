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
const { verdicts } = require('./usage.js');
const { shell, versionRange, legend } = require('../layout.js');

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
// [tone, what a collapsed row says, what an open card says]. A row states availability
// in one word; only the card has room to name the environments that word stands for.
const SCOPE = {
  all: ['ok', 'all', 'all (addons + core)'], addons: ['addon', 'addons', 'addons only'],
  core: ['new', 'core', 'core only'], none: ['gone', 'absent', 'does not exist'],
};
const USAGE = {
  confirmed: ['ok', 'confirmed'], disputed: ['gone', 'disputed'], unverified: ['warn', 'unverified'],
};

// A row is a fixed-width column, so it carries the short label and the long one as its
// tooltip.
const titled = (tone, label, title) =>
  `<b class="t-${tone}" title="${esc(title)}">${esc(label)}</b>`;

// The row says "widget"; only the card has room for the file name it stands for.
const originBadge = (n, short) => {
  const o = DATA[n].origin, tone = ORIGIN_TONE[o] || 'engine', label = ORIGIN_LABEL[o] || 'engine';
  return short
    ? titled(tone, o === 'widget' ? 'widget' : label, 'Origin: ' + label)
    : badge(tone, label);
};

const scopeBadge = (n, short) => {
  const [tone, s, long] = SCOPE[DATA[n].scope] || SCOPE.none;
  return short ? titled(tone, s, 'Availability: ' + long) : badge(tone, long);
};

const kindBadge = (n) => badge(DATA[n].kind === 'function' ? 'no' : 'warn', DATA[n].kind);
const savedOf = (n) => (docs[n] && docs[n].saved) || null;

function verState(n, v) {
  const e = DATA[n], s = e.versions[v];
  if (!s || !s.present) return { tone: 'no', tick: '✗', text: 'absent' };
  if (e.delta === 'new in ' + v) return { tone: 'new', tick: 'NEW', text: 'NEW in ' + v };
  return { tone: 'ok', tick: '✓', text: 'present' };
}

// Presence as a range: one column per version stops fitting once the game has a few
// more of them. The card still lists every version, because the areas differ per version.
const rangeOf = (n) => versionRange(VERSIONS, VERSIONS.filter((v) => (DATA[n].versions[v] || {}).present));
const versShort = (n) => {
  const r = rangeOf(n);
  return `<b class="t-${r.tone}" title="${esc(r.long)}">${esc(r.short)}</b>`;
};

function versCell(n, tick) {
  return VERSIONS.map((v) => {
    const s = verState(n, v);
    if (tick) return `<b>${v}</b> ${badge(s.tone, s.tick)}`;
    const areas = DATA[n].versions[v].areas || [];
    return `<b>${v}</b> ${badge(s.tone, s.text)}` +
      (s.tone === 'no' || !areas.length ? '' : ' - ' + esc(areas.join(' + ')));
  }).join('<br>');
}

// A row says only that the global is saved; which store holds it is the card's business.
function summaryCell(n) {
  if (DATA[n].note) return tint('warn', '⚠ ' + x(DATA[n].note));
  const sv = savedOf(n), s = summaryOf(docs[n]);
  return (sv ? titled('warn', 'saved',
    'A saved variable: the engine restores it before the file that declares it runs') + ' ' : '') +
    (s ? x(s) : tint('warn', 'undocumented'));
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
    if (d.via === 'AddGlobalAccess') s += ' - <code>AddGlobalAccess</code> → ' + mono(d.impl || '?');
    else if (d.via === 'MakeGlobalAvailable') s += ' - <code>MakeGlobalAvailable</code>';
    else if (d.via === 'function') s += ' - top-level <code>function</code>';
    else if (d.via === 'assignment') s += ' - table assignment';
    bits.push(s + (where ? ' (' + where + ')' : ''));
  }
  if (!sites.size) bits.push('<i>injected by the executable; defined in no <code>.lua</code> file</i>');

  if (e.overrides && e.overrides.length) {
    const o = e.overrides[e.overrides.length - 1];
    bits.push(tint('warn', '⚠ vanilla replaces it at runtime') + ' - ' + mono(o.rel + ':' + o.line));
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
  return badge(tone, label) + ' - ' + x(u.detail) +
    (seen.length ? '<br>Seen at ' + seen.map(mono).join(', ') : '');
}

const paramLine = (p) => mono(p.name) + ' <i>' + x(p.type) + '</i>' +
  (p.optional ? ' ' + badge('warn', 'optional') : '') + (p.desc ? ' - ' + x(p.desc) : '');

const returnLine = (r) => (r.name ? mono(r.name) + ' ' : '') + '<i>' + x(r.type) + '</i>' +
  (r.desc ? ' - ' + x(r.desc) : '');

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
  const vr = rangeOf(n);
  head.push(badge(vr.tone, vr.short));
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
  rows.push(['Game versions', `${badge(vr.tone, vr.long)}<br>` + versCell(n, false)]);
  if (e.origin === 'engine' && u) rows.push(['Vanilla usage', usageCell(n)]);

  const overloads = d && d.overloads.length
    ? d.overloads.map((o) => '\n-- overload: ' + o).join('') : '';

  const body = `<p class="badges">${head.join(' ')}</p>
<pre><code>${esc(signature(n) + overloads)}</code></pre>
${e.note ? `<p>${tint('gone', '⚠ ' + x(e.note))}</p>` : ''}
${d && d.prose ? `<p>${x(d.prose)}</p>` : ''}
<table>${rows.map(([k, v]) => `<tr><th>${k}</th><td>${v}</td></tr>`).join('')}</table>`;

  return `<details class="card" id="${anchorOf(n)}" ${facets(n)}>
<summary class="disc"><code class="nm">${esc(n)}</code>\
<span class="og">${originBadge(n, true)}</span><span class="sc">${scopeBadge(n, true)}</span>\
<span class="vs">${versShort(n)}</span>\
<span class="sum">${summaryCell(n)}</span></summary>
${body}</details>`;
}

/* -------------------------------------------------------------------- page */

const counts = (v) => names.filter((n) => DATA[n].origin === v).length;

// Only what is this page's own. The theme, the tone palette and every shared
// component - the filter bar, the disclosure chevron, the callout strip - come from
// ../layout.js, so the two generated references are the same object visually.

const CSS = `
.card table{margin:.6em 0}
.card table th{width:150px;white-space:nowrap}
/* the point of a single page: the browser skips layout and paint for offscreen cards */
.card{content-visibility:auto;contain-intrinsic-size:0 46px;border:1px solid var(--line);
  border-radius:8px;margin:0 0 8px;padding:0;background:var(--soft)}
.card[open]{contain-intrinsic-size:0 480px;padding-bottom:12px}
/* Fixed columns, the shape the script commands list already uses: a name that starts in
   the same place on every row is what makes 805 of them scannable. The three badge
   columns are their own widest label plus a little; only the description takes the slack.
   19em covers all but 13 of the 805 names - sizing for the longest would cost every row. */
:root{--cols:minmax(12em,19em) 3.5em 3.7em 3.4em 1fr}
.card>summary{display:grid;grid-template-columns:var(--cols);gap:.6em;align-items:baseline}
.card[open]>summary{border-bottom:1px solid var(--line);border-radius:7px 7px 0 0;margin-bottom:10px}
.card>*:not(summary){margin-left:14px;margin-right:14px}
@media(max-width:720px){.card table th{width:auto;white-space:normal}.wrap{padding:16px 10px 60px}
  :root{--cols:1fr}
  .card>summary{row-gap:.2em}
  .card>summary .og,.card>summary .sc,.card>summary .vs{display:none}
  .bar .leg{display:none}}
`;

const JS = `
// The copy row is inserted the first time a card is opened rather than emitted 805
// times: identical markup on every card is a quarter of a megabyte and 2,400 nodes
// for something only an open card can use. Every button reads its text out of the
// card it sits in, so nothing is shipped twice. \`toggle\` does not bubble, but a
// capturing listener on the document still sees it.
const COPYROW='<p class="copyrow">'+
  '<button class="copy" type="button" data-copy-sel="summary .nm">Copy name</button>'+
  '<button class="copy" type="button" data-copy-sel="pre code">Copy signature</button>'+
  '<button class="copy" type="button" data-copy-link="">Copy link</button></p>';
document.addEventListener('toggle',function(e){
  const d=e.target;
  if(!d.open||!d.classList||!d.classList.contains('card')||d.querySelector('.copyrow'))return;
  const pre=d.querySelector('pre');if(pre)pre.insertAdjacentHTML('afterend',COPYROW);
},true);

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
<p class="lede">Every name X4: Foundations puts into the global namespace of X4 UI Lua code - what creates it, which of the two Lua environments can see it, and which game version has it.</p>
<p class="lede"><b>${names.length} globals</b> in 9.00: ${counts('engine')} injected by the executable, ${counts('widget')} from <code>widget_fullscreen.lua</code>, ${counts('addon')} from an addon file, ${counts('core')} from a core file. Availability and version presence are <b>verified in the game</b>, not inferred from the code: every row reports what each Lua environment actually holds, on each version.</p>

<div class="dl">
<a class="btn" href="${URL}globals.lua" download>Download <code>globals.lua</code></a>
<p>${LUA_KB} KB. The same ${names.length} declarations as a Lua Language Server meta file - every global with its description, parameters and returns. Point an editor at it as a library and X4's globals get completion and signatures while UI Lua is being written.</p>
</div>

<details class="box"><summary>Using it in an editor</summary>
<p>The Lua Language Server reads a meta file when it is listed as a workspace library. In VS Code that is <code>.luarc.json</code> beside the workspace root, or the same key in settings:</p>
<pre><code>{
  "workspace.library": [ "path/to/globals.lua" ]
}</code></pre>
<p>The file declares names only - it is never executed and never loaded by the game. It covers the global namespace; for the wider set of X4 Lua definitions there is a packaged addon, <a href="https://github.com/chemodun/X4-LuaLSAddon">X4-LuaLSAddon</a>, installable through the Lua extension's addon manager.</p>
</details>

<details class="box"><summary>How to read a row</summary>
<table>
<tr><th>Origin</th><td>${badge('engine', 'engine')} injected by the game executable, defined in no <code>.lua</code> file.<br>
${badge('widget', 'widget_fullscreen')} written in <code>ui/widget/lua/widget_fullscreen.lua</code>.<br>
${badge('addon', 'addon')} a top-level definition in a <code>ui/addons/*</code> file.<br>
${badge('new', 'core')} a top-level definition in a <code>ui/core/*</code> HUD file.</td></tr>
<tr><th>Availability</th><td>${badge('ok', 'all')} present in both Lua environments; an open card spells that out as <b>all (addons + core)</b>.<br>
${badge('addon', 'addons')} only where <code>ui/addons/*</code> menus run.<br>
${badge('new', 'core')} only in the HUD environment - addon code cannot reach these.<br>
${badge('gone', 'absent')} declared, but present in neither version.<br>
The column is headed <b>Seen in</b>; a row carries the short word, and hovering it or opening the card gives the full wording.</td></tr>
<tr><th>Signature</th><td>${badge('ok', 'confirmed')} vanilla calls it, and every argument count fits the declaration.<br>
${badge('gone', 'disputed')} vanilla passes a count the declaration cannot take - believe the call site.<br>
${badge('warn', 'unverified')} no vanilla code calls it at all.</td></tr>
<tr><th>Game versions</th><td>${badge('ok', 'all')} in every version covered here (${VERSIONS.join(', ')}).<br>
${badge('new', '≥ ' + VERSIONS[VERSIONS.length - 1])} from that version onwards, so new since the one before it.<br>
${badge('gone', '≤ ' + VERSIONS[0])} up to that version, and gone in the next.<br>
The card still names every version, because which Lua environment holds it can differ between them.</td></tr>
<tr><th>Copying</th><td>An open card carries <b>Copy name</b>, <b>Copy signature</b> and <b>Copy link</b>; the last gives a URL that reopens that card.</td></tr>
<tr><th>Saved</th><td>${badge('warn', 'saved')} - a <code>&lt;savedvariable&gt;</code> in the addon’s <code>ui.xml</code>. The engine restores the previous value <i>before</i> that file runs, which is why vanilla creates every one of them with <code>X = X or { }</code>. The card names the store: ${badge('warn', 'saved: userdata')} is per player profile, ${badge('warn', 'saved: savegame')} travels with the save.</td></tr>
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
${legend([['Name'], ['Origin', 'Origin: what puts the name in the global namespace'],
  ['Seen in', 'Availability: which Lua environments hold it'],
  ['Version', 'Game versions: which of the covered versions have it'],
  ['Description']])}
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
