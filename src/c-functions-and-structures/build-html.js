'use strict';

// Builds the C functions and structures reference.
//
//   node build-html.js                 -> _site/x4/modding-support/ui-modding/c-functions-and-structures/
//   OUT=path/to/index.html node build-html.js
//
// The page is built from c-functions.lua, which is the reference: a Lua Language Server
// meta file carrying every declaration, everything the probe measured about it, and the
// descriptions, which are written into that file and nowhere else. meta.js is the parser,
// copied here by the extraction half so the two readings of the format cannot drift.
//
// Types are the shared half here - UniverseID is a parameter of well over a thousand
// functions - so they are rendered once, statically, and every function card links into
// them. A function card is assembled in the browser when its row is opened: 2,380 cards
// rendered up front would be several megabytes of markup for the few a reader opens.

const fs = require('fs');
const path = require('path');
const { shell, esc, versionRange, legend } = require('../layout.js');
const { parse, argNames } = require('./meta.js');

const DATA = path.join(__dirname, 'data');
const meta = JSON.parse(fs.readFileSync(path.join(DATA, 'meta.json'), 'utf8'));

const LUA = path.join(__dirname, 'c-functions.lua');
const LUA_KB = Math.round(fs.statSync(LUA).size / 1024);
const source = parse(fs.readFileSync(LUA, 'utf8'), meta.versions);
const { functions, types, docs } = source;

// What the meta file parses to has to be what the extraction measured. Anything else
// means an edit reshaped an entry, and the page would publish the damage silently.
const problems = [];
const tally = (label, got, want) => {
  if (got !== want) problems.push(`${label}: ${got} in c-functions.lua, ${want} in meta.json`);
};
const stateCount = (s) => Object.values(functions).filter((f) => f.state === s).length;
tally('functions', Object.keys(functions).length, meta.counts.functions);
tally('declared', stateCount('declared'), meta.counts.declared);
tally('exported', stateCount('exported'), meta.counts.exported);
tally('restricted', stateCount('restricted'), meta.counts.restricted);
tally('types', Object.keys(types).length, meta.counts.types);
tally('types with a size', Object.values(types).filter((t) => t.size !== undefined).length, meta.counts.typesSized);
// A description whose name is neither a function nor a type. gen-meta.js parks these at
// the end of the file rather than deleting them, and they are a build failure here.
for (const name of Object.keys(docs.orphans)) {
  problems.push(`a description for ${name}, which is neither a function nor a type`);
}
if (problems.length) {
  console.error('c-functions.lua does not agree with meta.json:');
  for (const p of problems) console.error('  ' + p);
  process.exit(1);
}

const URL = '/x4/modding-support/ui-modding/c-functions-and-structures/';
const OUT = process.env.OUT || path.join(__dirname, '..', '..', '_site', ...URL.split('/').filter(Boolean), 'index.html');

const VERSIONS = meta.versions;
const NEWEST = VERSIONS[VERSIONS.length - 1];
const tokenOf = (v) => 'v' + v.replace('.', '');
const ALL_TOKENS = VERSIONS.map(tokenOf).join(' ');

// A thing with no "v" is in every version; the extractor only stamps the exceptions.
const versionsOf = (node) => (node && node.v ? node.v : ALL_TOKENS);
const isNew = (node) => versionsOf(node) === tokenOf(NEWEST) && VERSIONS.length > 1;

const id = (prefix, name) => prefix + '-' + String(name).replace(/[^a-zA-Z0-9_~-]/g, '_');

const rangeOf = (node) => versionRange(VERSIONS, VERSIONS.filter((v) => versionsOf(node).includes(tokenOf(v))));

const versionShort = (node) => {
  const r = rangeOf(node);
  return `<b class="t-${r.tone}" title="${esc(r.long)}">${esc(r.short)}</b>`;
};

const versionLine = (node) => {
  const r = rangeOf(node);
  return `<p class="vers"><span class="k">Game versions</span><b class="t-${r.tone}">${esc(r.long)}</b></p>`;
};

// [tone, what a collapsed row says, what an open card says].
const STATE = {
  declared: ['ok', 'declared', 'declared by vanilla, so the signature is known'],
  exported: ['warn', 'exported', 'exported by the engine and declared by no vanilla file, so the signature is unknown'],
  restricted: ['gone', 'restricted', 'the engine refuses this name outright'],
};
const ENV = {
  addons: ['addon', 'addons', 'declared in ui/addons or ui/widget, so it is reachable in the shared addons state'],
  core: ['new', 'core', 'declared only in a ui/core file, which shares nothing: declare it yourself to use it'],
  both: ['ok', 'both', 'declared on both sides'],
};

const stateBadge = (f, short) => {
  const [tone, s, long] = STATE[f.state];
  return short ? `<b class="t-${tone}" title="${esc('State: ' + long)}">${esc(s)}</b>` : `<b class="t-${tone}">${esc(long)}</b>`;
};

const envBadge = (f, short) => {
  if (!f.env) return short ? '<b class="t-warn" title="No vanilla file declares it">-</b>' : '';
  const [tone, s, long] = ENV[f.env];
  return short ? `<b class="t-${tone}" title="${esc('Declared in: ' + long)}">${esc(s)}</b>` : `<b class="t-${tone}">${esc(long)}</b>`;
};

// The parameter list a row shows, which is also the whole of what a reader scans for.
const paramText = (f) => (f.params ? `(${f.params.map((p) => p.type + (p.name ? ' ' + p.name : '')).join(', ') || 'void'})` : '');

// Only what is this page's own. The theme, the tone palette and every shared component -
// the filter bar, the disclosure chevron, the callout strip, the chips - come from
// ../layout.js, so the three generated references are one object visually.

const CSS = `

.list{border:1px solid var(--line);border-radius:6px;overflow:hidden}
.row{border-top:1px solid var(--line);content-visibility:auto;contain-intrinsic-size:auto 41px}
.row:first-child{border-top:0}
.row.open{background:var(--soft)}
/* The card is built once and left in the DOM, so collapsing is this rule, not a removal. */
.row:not(.open)>.card{display:none}
:root{--cols:minmax(14em,23em) 5.2em 4.2em 3.6em 1fr}
.hd{display:grid;grid-template-columns:var(--cols);gap:.6em;align-items:baseline;border-radius:0}
.row.open>.hd{border-bottom:1px solid var(--line)}
.hd .sig{color:var(--dim);font-family:var(--mono);font-size:.82rem;white-space:nowrap;
  overflow:hidden;text-overflow:ellipsis}
.hd .sig i{font-family:var(--sans);font-style:normal}

.card{padding:2px 14px 14px}
.card table{margin:.6em 0}
.card table th{width:150px;white-space:nowrap;text-align:left;vertical-align:top}
.card pre{margin:.6em 0}
.card .none{color:var(--dim);font-style:italic}
.card p.d,.shared p.d{margin:.6em 0;color:inherit;font-size:1em}
.card p.d.none,.shared p.d.none{color:var(--dim)}

.shared{border:1px solid var(--line);border-radius:6px;padding:.6em .9em;margin:.7em 0;
  content-visibility:auto;contain-intrinsic-size:auto 120px}
.shared:target{border-color:var(--acc)}
.shared>h3{margin:0 0 .2em;font-size:1em;font-family:var(--mono)}
.shared p{margin:.2em 0;color:var(--dim);font-size:.92em}
.shared p.vers{color:inherit}
.shared table{margin:.4em 0}
.shared td.n,.shared td.t{font-family:var(--mono);white-space:nowrap}
a.ref{font-family:var(--mono);font-size:.92em}
@media (max-width:720px){:root{--cols:1fr}.hd{row-gap:.2em}
  .hd .st,.hd .ev,.hd .vs{display:none}.bar .leg{display:none}
  .card table th{width:auto;white-space:normal}}
`;

// ---- types, rendered once --------------------------------------------------

// Computed here rather than stored: UniverseID would carry a list of well over a
// thousand function names in the data file, for a number the page can count itself.
const usedBy = new Map();
for (const [name, f] of Object.entries(functions)) {
  const seen = new Set();
  for (const p of f.params || []) seen.add(p.type.replace(/[*\s]+$/, '').replace(/^const\s+/, ''));
  if (f.ret) seen.add(f.ret.replace(/[*\s]+$/, '').replace(/^const\s+/, ''));
  for (const t of seen) {
    if (!types[t]) continue;
    if (!usedBy.has(t)) usedBy.set(t, []);
    usedBy.get(t).push(name);
  }
}

const USED_BY_SHOWN = 18;

const typeChip = (raw) => {
  const bare = raw.replace(/[*\s]+$/, '').replace(/^const\s+/, '');
  if (!types[bare]) return `<code>${esc(raw)}</code>`;
  return `<a class="ref" href="#${id('t', bare)}"><code>${esc(raw)}</code></a>`;
};

const typeCards = Object.keys(types)
  .sort()
  .map((name) => {
    const t = types[name];
    const doc = docs.types[name] || {};
    const users = usedBy.get(name) || [];
    const facts = [];
    if (t.size !== undefined) facts.push(`<code>ffi.sizeof</code> ${t.size} byte${t.size === 1 ? '' : 's'}${t.sizeFrom ? ` in ${esc(t.sizeFrom)}` : ''}`);
    else facts.push('no size measured: no probed file declares it');
    facts.push(ENV[t.env] ? ENV[t.env][2] : 'declared nowhere');
    facts.push(`used by ${users.length} function${users.length === 1 ? '' : 's'}`);

    // A third column only where a field has been described, so an undescribed type
    // keeps the two-column shape it had.
    const fdoc = doc.fields || {};
    const described = t.fields && t.fields.some((f) => fdoc[f.name]);
    const fields = t.fields
      ? `<table><thead><tr><th>Field</th><th>Type</th>${described ? '<th>What it is</th>' : ''}</tr></thead><tbody>${t.fields
          .map((f) => `<tr><td class="n"><code>${esc(f.name)}</code></td><td class="t">${typeChip(f.type)}</td>` +
            (described ? `<td>${esc(fdoc[f.name] || '')}</td>` : '') + '</tr>')
          .join('')}</tbody></table>`
      : '';

    const list = users.length
      ? `<p>Used by ${users
          .slice(0, USED_BY_SHOWN)
          .map((n) => `<a class="ref" href="#${id('f', n)}"><code>${esc(n)}</code></a>`)
          .join(', ')}${users.length > USED_BY_SHOWN ? ` and ${users.length - USED_BY_SHOWN} more` : ''}</p>`
      : '<p>No function in either version takes or returns it.</p>';

    return `<section class="shared" id="${id('t', name)}">
<h3>${esc(name)} <span class="tag">${esc(t.kind)}</span>${isNew(t) ? '<span class="new">NEW</span>' : ''}</h3>
${doc.detailed ? `<p class="d">${esc(doc.detailed)}</p>` : ''}
<p>${facts.join(' &middot; ')}</p>
${t.v ? versionLine(t) : ''}
<pre><code>${esc(t.decl)}</code></pre>
${doc.notes ? `<p class="d"><span class="t-warn">&#9888; ${esc(doc.notes)}</span></p>` : ''}
${fields}
${list}
<p>Declared in ${t.sites.map((s) => `<code>${esc(s.file)}:${s.line}</code>`).join(', ')}</p>
</section>`;
  })
  .join('\n');

// ---- the function list -----------------------------------------------------

const names = Object.keys(functions).sort();
const rows = names
  .map((name) => {
    const f = functions[name];
    const facets = [f.state, 'e' + (f.env || 'none'), f.uses ? 'called' : 'uncalled',
      (docs.functions[name] || {}).detailed ? 'described' : 'undescribed',
      ...versionsOf(f).split(' '), isNew(f) ? 'new' : ''].filter(Boolean).join(' ');
    const sig = f.params
      ? `<code>${esc(f.ret)}</code> ${esc(paramText(f))}`
      : '<i>signature unknown</i>';
    return `<div class="row" id="${id('f', name)}" data-f="${facets}" data-n="${esc(name)}">
<button class="hd disc" type="button">\
<span class="nm">${esc(name)}${isNew(f) ? '<span class="new">NEW</span>' : ''}</span>\
<span class="st">${stateBadge(f, true)}</span><span class="ev">${envBadge(f, true)}</span>\
<span class="vs">${versionShort(f)}</span>\
<span class="sig">${sig}</span></button>
</div>`;
  })
  .join('\n');

// ---- the embedded payload --------------------------------------------------
// `decl` is dropped: it is ret + name + params, which the card rebuilds. Everything
// else a card shows is here, and nothing a row already carries is shipped twice.

const payload = Object.fromEntries(
  Object.entries(functions).map(([n, f]) => {
    const { decl, ...rest } = f;
    const d = docs.functions[n];
    // The meta file keys a parameter's text by the name its annotation carries; a card
    // knows parameters by position, so the two are lined up once, here.
    if (d) rest.doc = { ...d, params: d.params && f.params ? argNames(f.params).map((a) => d.params[a] || '') : undefined };
    return [n, rest];
  })
);

const counts = meta.counts;
const countOf = (pred) => names.filter((n) => pred(functions[n])).length;
const uncalled = countOf((f) => f.decl && !f.uses);
const describedFns = names.filter((n) => (docs.functions[n] || {}).detailed).length;
const describedTypes = Object.keys(types).filter((n) => (docs.types[n] || {}).detailed).length;

// ---- the page script -------------------------------------------------------

const JS = `
var D=JSON.parse(document.getElementById('data').textContent);
var T=JSON.parse(document.getElementById('typenames').textContent);
var VS=${JSON.stringify(VERSIONS)},NEW='${tokenOf(NEWEST)}',ALL='${ALL_TOKENS}';
var STATE=${JSON.stringify(STATE)},ENV=${JSON.stringify(ENV)};
var E=function(s){return String(s==null?'':s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');};
var ID=function(p,n){return p+'-'+String(n).replace(/[^a-zA-Z0-9_~-]/g,'_');};
var vof=function(x){return x&&x.v?x.v:ALL;};
// The one implementation, shipped rather than ported: the static half and the cards
// must never disagree about which versions something is in.
${versionRange.toString()}
var vrange=function(x){var h=vof(x);
  return versionRange(VS,VS.filter(function(v){return h.indexOf('v'+v.replace('.',''))>=0;}));};
var vline=function(x){var r=vrange(x);
  return '<p class="vers"><span class="k">Game versions</span><b class="t-'+r.tone+'">'+E(r.long)+'</b></p>';};
// A badge strip carries the short word; the table under it has room for the sentence.
var badge=function(m,k){return m[k]?'<b class="t-'+m[k][0]+'">'+E(m[k][1])+'</b>':'';};
var says=function(m,k){return m[k]?'<b class="t-'+m[k][0]+'">'+E(m[k][2])+'</b>':'';};
var bare=function(t){return t.replace(/[*\\s]+$/,'').replace(/^const\\s+/,'');};
var chip=function(t){return T[bare(t)]?'<a class="ref" href="#'+ID('t',bare(t))+'"><code>'+E(t)+'</code></a>':'<code>'+E(t)+'</code>';};
var sigOf=function(n,f){return f.ret+' '+n+'('+(f.params.length?f.params.map(function(p){
  return p.type+(p.name?' '+p.name:'');}).join(', '):'void')+');';};

function card(name){
  var f=D[name]; if(!f) return '';
  var d=f.doc||{};
  // Nothing describes a C. function anywhere, so an empty card is the normal case and
  // says so plainly rather than leaving the reader wondering what is missing.
  var out=[d.detailed?'<p class="d">'+E(d.detailed)+'</p>':'<p class="d none">No description yet.</p>'];
  if(f.params){
    out.push('<pre><code>'+E(sigOf(name,f))+'</code></pre>');
    out.push('<p class="copyrow"><button class="copy" type="button" data-copy="'+E(name)+'">Copy name</button>'+
      '<button class="copy" type="button" data-copy-sel="pre code">Copy declaration</button>'+
      '<button class="copy" type="button" data-copy-link="#'+ID('f',name)+'">Copy link</button></p>');
  }else{
    out.push('<p class="none">No vanilla file declares it, so its parameters and return type are unknown. '+
      'The engine exports the name and it resolves once declared - but a cdef that does not match the real '+
      'signature is undefined behaviour, not an error, so do not guess one.</p>');
    out.push('<p class="copyrow"><button class="copy" type="button" data-copy="'+E(name)+'">Copy name</button>'+
      '<button class="copy" type="button" data-copy-link="#'+ID('f',name)+'">Copy link</button></p>');
  }

  if(d.notes) out.push('<p class="d"><span class="t-warn">⚠ '+E(d.notes)+'</span></p>');

  var rows=[['State',says(STATE,f.state)+(f.vState?'<br>'+Object.keys(f.vState).map(function(v){
    return 'in '+E(v)+' it was '+E(STATE[f.vState[v]][1]);}).join(', '):'')]];
  if(f.params&&f.params.length){
    rows.push(['Parameters',f.params.map(function(p,i){
      var t=(d.params||[])[i];
      return chip(p.type)+(p.name?' <code>'+E(p.name)+'</code>':'')+(t?' - '+E(t):'');}).join('<br>')]);
  }else if(f.params){rows.push(['Parameters','<i>none</i>']);}
  if(f.ret) rows.push(['Returns',chip(f.ret)+(d.ret?' - '+E(d.ret):'')]);
  // A name vanilla has since dropped still has declaration sites; they are just no longer
  // the current version's, so the whole cell has to read in the past tense.
  if(f.env) rows.push(['Declared in',(f.declFrom
      ? badge(ENV,f.env)+' - last declared in '+E(f.declFrom)+
        ', and only the export table has carried it since'
      : says(ENV,f.env))+'<br>'+
    f.sites.map(function(s){return '<code>'+E(s.file)+':'+s.line+'</code>';}).join('<br>')]);
  rows.push(['Vanilla usage',f.uses
    ? E(f.uses)+' call site'+(f.uses===1?'':'s')+', for example <code>'+E(f.use.file)+':'+f.use.line+'</code>'
    : '<i>no vanilla code calls it in either version</i>']);
  var r=vrange(f);
  rows.push(['Game versions','<b class="t-'+r.tone+'">'+E(r.long)+'</b>']);

  return '<div class="card"><p class="badges">'+badge(STATE,f.state)+' '+(f.env?badge(ENV,f.env):'')+'</p>'+
    out.join('')+
    '<table>'+rows.map(function(kv){return '<tr><th>'+kv[0]+'</th><td>'+kv[1]+'</td></tr>';}).join('')+'</table></div>';
}

var list=document.querySelector('.list');
function open(row,scroll){
  if(!row) return;
  if(!row.classList.contains('open')){
    if(!row.querySelector('.card')) row.insertAdjacentHTML('beforeend',card(row.dataset.n));
    row.classList.add('open');
  }
  if(scroll) row.scrollIntoView({block:'start'});
}
list.addEventListener('click',function(e){
  var hd=e.target.closest('.hd'); if(!hd) return;
  var row=hd.parentElement;
  if(row.classList.contains('open')) row.classList.remove('open'); else open(row,false);
});

var q=document.getElementById('q'),n=document.getElementById('n'),
    sel=Array.prototype.slice.call(document.querySelectorAll('.bar select')),
    rows=Array.prototype.slice.call(list.children).map(function(r){
      var d=(D[r.dataset.n]||{}).doc||{};
      return {r:r,f:' '+r.dataset.f+' ',
        h:(r.dataset.n+' '+(d.detailed||'')+' '+(d.notes||'')).toLowerCase()};});
function apply(){
  var text=q.value.trim().toLowerCase(),shown=0;
  var want=sel.map(function(s){return s.value;}).filter(Boolean);
  for(var i=0;i<rows.length;i++){
    var ok=(!text||rows[i].h.indexOf(text)>=0);
    for(var j=0;ok&&j<want.length;j++) ok=rows[i].f.indexOf(' '+want[j]+' ')>=0;
    rows[i].r.classList.toggle('hide',!ok); if(ok) shown++;
  }
  n.textContent=shown+' of '+rows.length;
}
var timer;
q.addEventListener('input',function(){clearTimeout(timer);timer=setTimeout(apply,120);});
sel.forEach(function(s){s.addEventListener('change',apply);});
// Reset returns to the page's default view, not to no filter at all.
document.getElementById('clr').addEventListener('click',function(){
  q.value='';sel.forEach(function(s){s.value=s.dataset.def;});apply();q.focus();});
apply();

// A deep link has to survive the default version filter and open its card.
function jump(){
  var h=location.hash.slice(1); if(!h) return;
  var el=document.getElementById(h); if(!el) return;
  if(el.classList.contains('row')){
    if(el.classList.contains('hide')){q.value='';sel.forEach(function(s){s.value='';});apply();}
    open(el,true);
  }else{el.scrollIntoView();}
}
window.addEventListener('hashchange',jump);jump();
`;

const select = (label, vals, def = '') =>
  `<select data-def="${def}" aria-label="${esc(label)}"><option value="">${esc(label)}: all</option>` +
  vals.map(([v, l]) => `<option value="${v}"${v === def ? ' selected' : ''}>${esc(l)}</option>`).join('') +
  '</select>';

const VERSION_OPTS = [
  ...VERSIONS.map((v) => [tokenOf(v), `in ${v} (${countOf((f) => versionsOf(f).includes(tokenOf(v)))})`]),
  ['new', `new in ${NEWEST} (${countOf(isNew)})`],
];

const body = `<h1>C functions and structures</h1>
<p class="lede">Every name the X4: Foundations engine exposes to UI Lua through <code>ffi.C</code> - the other half of
the namespace a UI mod works in, beside the <a href="/x4/modding-support/ui-modding/lua-globals/">globals</a>.
Read out of the <code>ffi.cdef</code> blocks of the game's own Lua, the export table of <code>X4.exe</code>, and a probe
run inside the game, for ${VERSIONS.join(' and ')}.</p>
<p class="lede">${counts.functions} functions - ${counts.declared} declared, ${counts.exported} exported, ${counts.restricted} restricted -
and ${counts.types} structs and typedefs, ${counts.typesSized} of them with a size measured in game.
Nothing in the game files describes any of them, so the descriptions are written by hand and there are
${describedFns} on a function and ${describedTypes} on a type so far.</p>

<div class="dl">
<a class="btn" href="#functions">Browse</a>
<p>Open a row for the full declaration, where it is declared, what vanilla does with it and which versions have it.
The types are listed once, further down, and every card links into them.</p>
</div>

<div class="dl">
<a class="btn" href="${URL}c-functions.lua" download>Download <code>c-functions.lua</code></a>
<p>${LUA_KB} KB. This page as a Lua Language Server meta file, which is also the file it is built from: every
declaration with its state, its environment and its versions above it. Point an editor at it as a library and
<code>C.</code> gets completion and signatures while UI Lua is being written.</p>
</div>

<details class="box"><summary>What this covers, and what a state means</summary>
<p><code>ffi.C</code> is a userdata that resolves one symbol at a time. It has no <code>__pairs</code>, so it cannot be
enumerated and no list of it can come from the game alone: these names come from the declarations in vanilla's own Lua
and from the export table of the executable, and what the game was asked is whether each one resolves.</p>
<table>
<tr><th>${esc(STATE.declared[1])}</th><td>Vanilla writes a <code>ffi.cdef</code> for it, so the full signature is known and
right. ${counts.declared} of them.</td></tr>
<tr><th>${esc(STATE.exported[1])}</th><td>The engine exports the name and no vanilla file declares it, so the signature is
unknown. ${counts.exported} of them, and every one resolves once declared - none is a stale entry in the export table.
A cdef that does not match the real signature is undefined behaviour rather than an error, so these are an invitation to
experiment, not to guess.</td></tr>
<tr><th>${esc(STATE.restricted[1])}</th><td>The engine has its own guard above LuaJIT's and refuses the name outright:
<code>Access to FFI function '&lt;name&gt;' is restricted!</code> ${counts.restricted} of them, whether or not vanilla
declares one.</td></tr>
</table>
</details>

<details class="box"><summary>How to read a row</summary>
<table>
<tr><th>Declared in</th><td><b class="t-addon">addons</b> some <code>ui/addons</code> or <code>ui/widget</code> file
declares it. Those files share one Lua state, so the name is already reachable there with no cdef of your own - measured,
not assumed.<br>
<b class="t-new">core</b> only a <code>ui/core</code> file declares it. The core state shares nothing: a core script sees
only the cdefs of its own file, so there you declare what you use, every time.<br>
<b class="t-ok">both</b> declared on both sides.</td></tr>
<tr><th>Vanilla usage</th><td>How many times vanilla's own code calls it, outside any cdef block, with one example. ${uncalled}
declared names are never called by vanilla at all, which makes them the same kind of frontier as the exported ones.</td></tr>
<tr><th>Game versions</th><td><b class="t-ok">all</b> in every version covered here (${VERSIONS.join(', ')}).<br>
<b class="t-new">${esc('≥ ' + NEWEST)}</b> from that version onwards, so new since the one before it.<br>
<b class="t-gone">${esc('≤ ' + VERSIONS[0])}</b> up to that version, and gone in the next.<br>
A name vanilla stops declaring is not gone: the export table is all but append-only, so it usually turns from
<b class="t-ok">declared</b> into <b class="t-warn">exported</b> and still resolves. The card says so, and keeps the last
signature vanilla had for it.</td></tr>
<tr><th>Copying</th><td>An open card carries <b>Copy name</b>, <b>Copy declaration</b> and <b>Copy link</b>; the last gives
a URL that reopens that card.</td></tr>
</table></details>

<details class="box"><summary>Where a description comes from, and how to write one</summary>
<p>Nothing in the game files, and nothing anywhere else, describes a <code>C.</code> function. The names are
self-documenting and that is the whole of what exists, which is why most cards below say so. What descriptions there
are have been written by hand into <code>c-functions.lua</code> itself: the file offered above is both what this page
is built from and where its prose lives, so a description and the declaration it belongs to are never apart.</p>
<p>An entry takes three authored things, and nothing else in it is authored:</p>
<pre><code>--- The running game version, as the launcher shows it.
-- Note: addons only. Vanilla cdefs it in ego_debuglog alone, so a core
--   script that calls it raises a missing declaration.
-- State: declared
-- Environment: addons
-- Versions: ${VERSIONS.join(', ')}
-- Declared: ui/addons/ego_debuglog/debuglog.lua:26
---@return GameVersion # \`GameVersion\` the version struct
function C.GetGameVersion() end</code></pre>
<p>The <code>---</code> lines are the description, <code>-- Note:</code> is a caveat kept apart from it, and the text
after the backticked C type on a <code>---@param</code>, <code>---@return</code> or <code>---@field</code> says what
that one value is. Everything reading <code>-- Key: value</code> is generated from the extraction and rewritten
whenever the game moves on; the three authored kinds are carried across untouched.
<a href="https://github.com/chemodun/chemodun.github.io/blob/main/src/c-functions-and-structures/c-functions.lua">The
file is on GitHub</a>, and a description added to it is a pull request against that one file.</p>
</details>

<details class="box"><summary>Using it in an editor</summary>
<p>The Lua Language Server reads a meta file when it is listed as a workspace library. In VS Code that is
<code>.luarc.json</code> beside the workspace root, or the same key in settings:</p>
<pre><code>{
  "workspace.library": [ "path/to/c-functions.lua" ]
}</code></pre>
<p>Every annotation carries the exact C declaration in backticks beside the Lua type: <code>integer</code> is not a
<code>uint32_t</code>, <code>const char*</code> is not a type name at all, and a pointer reads as an array because
that is what the caller sizes and passes. The file declares names only, is never executed and is never loaded by the
game. For the wider set of X4 Lua definitions there is a packaged addon,
<a href="https://github.com/chemodun/X4-LuaLSAddon">X4-LuaLSAddon</a>.</p>
</details>

<h2 id="functions">Functions</h2>
<div class="bar">
<input id="q" type="search" placeholder="Filter by name or description…" autocomplete="off">
${select('State', [['declared', 'declared'], ['exported', 'exported'], ['restricted', 'restricted']])}
${select('Declared in', [['eaddons', 'addons'], ['ecore', 'core only'], ['eboth', 'both'], ['enone', 'nowhere']])}
${select('Vanilla use', [['called', 'called by vanilla'], ['uncalled', 'never called']])}
${select('Description', [['described', `described (${describedFns})`], ['undescribed', `not described yet (${counts.functions - describedFns})`]])}
${select('Version', VERSION_OPTS, tokenOf(NEWEST))}
<button id="clr" type="button">Reset</button><span class="n" id="n"></span>
${legend([['Name'], ['State', 'State: declared, exported or restricted'],
  ['Where', 'Declared in: which Lua state vanilla declares it in'],
  ['Version', 'Game versions: which of the covered versions have it'],
  ['Signature']])}
</div>
<div class="list">
${rows}
</div>

<h2 id="types">Structs and typedefs</h2>
<p>The ${counts.types} named types the declarations above are written in. A size is <code>ffi.sizeof</code> measured in the
running game, which is also the check that the field list here matches the real layout.</p>
${typeCards}

<script id="data" type="application/json">${JSON.stringify(payload).replace(/</g, '\\u003c')}</script>
<script id="typenames" type="application/json">${JSON.stringify(Object.fromEntries(Object.keys(types).map((n) => [n, 1]))).replace(/</g, '\\u003c')}</script>`;

const html = shell({
  title: 'C functions and structures',
  description: `Every function and type X4: Foundations exposes to UI Lua through ffi.C: signature, where it is declared, ` +
    `which Lua state can see it and which game version has it, for ${VERSIONS.join(' and ')}.`,
  trail: [
    { label: 'Home', href: '/' },
    { label: 'For X4: Foundations', href: '/x4/' },
    { label: 'Modding Support', href: '/x4/modding-support/' },
    { label: 'UI Modding support', href: '/x4/modding-support/ui-modding/' },
    { label: 'C functions and structures', href: URL },
  ],
  body,
  css: CSS,
  js: JS,
});

fs.mkdirSync(path.dirname(OUT), { recursive: true });
fs.writeFileSync(OUT, html, 'utf8');
// The meta file ships beside the page: it is the download, and it is the source.
fs.copyFileSync(LUA, path.join(path.dirname(OUT), 'c-functions.lua'));
console.log('wrote ' + OUT + ' (' + (fs.statSync(OUT).size / 1024).toFixed(0) + ' KB)');
console.log('wrote ' + path.join(path.dirname(OUT), 'c-functions.lua') + ' (' + LUA_KB + ' KB)');
console.log(`${names.length} functions, ${Object.keys(types).length} types, read from c-functions.lua`);
console.log(`described: ${describedFns} functions, ${describedTypes} types`);
