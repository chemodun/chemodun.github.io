'use strict';

// Builds the UIX callbacks reference.
//
//   node build-html.js                 -> _site/x4/modding-support/ui-modding/uix-callbacks/
//   OUT=path/to/index.html node build-html.js
//
// The page is built from uix-callbacks.lua, which is the reference: a Lua Language
// Server meta file carrying every hook kuertee's UI Extensions dispatches, everything
// the extraction measured about it, and the descriptions, which are written into that
// file and nowhere else. meta.js is the parser, copied here by the extraction half so
// the two readings of the format cannot drift.
//
// Callback names are not unique - `cleanup` is dispatched in ten menus - so the key is
// always (menu, name), and that pair is what an anchor, a facet and a card are keyed by.
// A card is assembled in the browser when its row is opened, the same way the C
// functions page does it, so the two references behave alike under a reader's hands.

const fs = require('fs');
const path = require('path');
const { shell, esc, versionRange, legend } = require('../layout.js');
const { parse } = require('./meta.js');

const DATA = path.join(__dirname, 'data');
const meta = JSON.parse(fs.readFileSync(path.join(DATA, 'meta.json'), 'utf8'));

const LUA = path.join(__dirname, 'uix-callbacks.lua');
const LUA_KB = Math.round(fs.statSync(LUA).size / 1024);
const byMenu = parse(fs.readFileSync(LUA, 'utf8'));

const VERSIONS = meta.versions.map((v) => v.version);
const NEWEST = VERSIONS[VERSIONS.length - 1];
const tokenOf = (v) => 'v' + v.replace(/\./g, '_');

const entries = [];
for (const list of byMenu.values()) entries.push(...list);
entries.sort((a, b) => a.menu.localeCompare(b.menu) || a.name.localeCompare(b.name));

const list = (s) => (s ? String(s).split(',').map((x) => x.trim()).filter(Boolean) : []);
const versionsOf = (e) => list(e.keys.Versions).map(tokenOf);
const isNew = (e) => VERSIONS.length > 1 && versionsOf(e).join(' ') === tokenOf(NEWEST);
const described = (e) => e.prose.length > 0;

// What the meta file parses to has to be what the extraction measured. Anything else
// means an edit reshaped an entry, and the page would publish the damage silently.
const problems = [];
if (entries.length !== meta.callbacks) problems.push(`${entries.length} callbacks in uix-callbacks.lua, ${meta.callbacks} in meta.json`);
if (byMenu.size !== meta.menus) problems.push(`${byMenu.size} menus in uix-callbacks.lua, ${meta.menus} in meta.json`);
// Only the structure is checked against meta.json. How many entries carry a description
// is counted from the file every build, because writing one is the whole point and must
// never need a regeneration to be publishable.
for (const e of entries) {
  for (const k of ['Function', 'Holder', 'Kind', 'Aggregation', 'Versions', 'Since']) {
    if (!e.keys[k]) problems.push(`${e.menu}::${e.name} has no ${k}`);
  }
  const unknown = versionsOf(e).filter((t) => !VERSIONS.map(tokenOf).includes(t));
  if (unknown.length) problems.push(`${e.menu}::${e.name} is in ${unknown.join(', ')}, which meta.json does not cover`);
}
if (problems.length) {
  console.error('uix-callbacks.lua does not agree with meta.json:');
  for (const p of problems) console.error('  ' + p);
  process.exit(1);
}

const URL = '/x4/modding-support/ui-modding/uix-callbacks/';
const OUT = process.env.OUT || path.join(__dirname, '..', '..', '_site', ...URL.split('/').filter(Boolean), 'index.html');

const id = (e) => 'c-' + (e.menu + '-' + e.name).replace(/[^a-zA-Z0-9_-]/g, '_');

// [tone, the word a row has room for, the sentence a card has room for].
const KIND = {
  event: ['ok', 'event', 'the return value is discarded: the hook only says that something happened'],
  override: ['new', 'override', 'the return value is used, so what a callback returns changes what the menu does'],
};

// The contract a reader cannot guess from the call site, and the reason this reference
// exists in the shape it does.
const AGG = {
  'none': ['no', 'none', 'nothing is done with the return value'],
  'last-wins': ['warn', 'last-wins', 'every registered callback runs and the last one to return decides'],
  'unanimous': ['gone', 'unanimous', 'every registered callback has to agree, and one dissenter flips the value'],
  'chained': ['new', 'chained', 'each callback is handed what the one before it returned'],
  'short-circuit': ['warn', 'short-circuit', 'the first truthy return stops the loop, so later callbacks never run'],
  'appended': ['new', 'appended', 'the return is concatenated onto what is there already'],
  'multi-value': ['new', 'multi-value', 'several values go in and the same several come back'],
};

const HOLDER = {
  'menu': ['ok', 'menu', 'dispatched off the menu table, so it is registered on that menu'],
  'Helper': ['widget', 'Helper', 'dispatched off the global Helper table, so it is registered with Helper.registerCallback'],
  'uix_menu': ['warn', 'uix_menu', 'dispatched off a menu handed to a Helper function, so it is registered on whichever menu is calling'],
};

const badge = (m, k, short) => {
  const t = m[k];
  if (!t) return `<b class="t-no">${esc(k)}</b>`;
  return short
    ? `<b class="t-${t[0]}" title="${esc(t[2])}">${esc(t[1])}</b>`
    : `<b class="t-${t[0]}">${esc(t[2])}</b>`;
};

// Only what is this page's own. The theme, the tone palette and every shared component -
// the filter bar, the disclosure chevron, the callout strip, the chips - come from
// ../layout.js, so the four generated references are one object visually.

const CSS = `

.list{border:1px solid var(--line);border-radius:6px;overflow:hidden}
.row{border-top:1px solid var(--line);content-visibility:auto;contain-intrinsic-size:auto 41px}
.row:first-child{border-top:0}
.row.open{background:var(--soft)}
/* The card is built once and left in the DOM, so collapsing is this rule, not a removal. */
.row:not(.open)>.card{display:none}
:root{--cols:minmax(13em,22em) 11.5em 5em 7em 1fr}
.hd{display:grid;grid-template-columns:var(--cols);gap:.6em;align-items:baseline;border-radius:0}
.row.open>.hd{border-bottom:1px solid var(--line)}
.hd .mn,.hd .ar{color:var(--dim);font-family:var(--mono);font-size:.82rem;white-space:nowrap;
  overflow:hidden;text-overflow:ellipsis}
.hd b{white-space:nowrap;font-size:.82rem}

.card{padding:2px 14px 14px}
.card table{margin:.6em 0}
.card table th{width:150px;white-space:nowrap;text-align:left;vertical-align:top}
.card pre{margin:.6em 0;overflow-x:auto}
.card .none{color:var(--dim);font-style:italic}
.card p.d{margin:.6em 0;color:inherit;font-size:1em}
.card p.d.none{color:var(--dim);font-style:normal}

table.legend th{width:9em;white-space:nowrap;text-align:left;vertical-align:top}
@media (max-width:720px){:root{--cols:1fr}.hd{row-gap:.2em}
  .hd .kd,.hd .ag,.hd .ar{display:none}.bar .leg{display:none}
  .card table th,table.legend th{width:auto;white-space:normal}}
`;

// ---- the list --------------------------------------------------------------

const rows = entries.map((e) => {
  const facets = ['m-' + e.menu, 'k-' + e.keys.Kind, 'a-' + e.keys.Aggregation, 'h-' + e.keys.Holder,
    described(e) ? 'described' : 'undescribed', ...versionsOf(e), isNew(e) ? 'new' : ''].filter(Boolean).join(' ');
  return `<div class="row" id="${id(e)}" data-f="${esc(facets)}" data-k="${esc(e.menu + '::' + e.name)}">
<button class="hd disc" type="button">\
<span class="nm">${esc(e.name)}${isNew(e) ? '<span class="new">NEW</span>' : ''}</span>\
<span class="mn">${esc(e.keys['Menu name'] || e.menu)}</span>\
<span class="kd">${badge(KIND, e.keys.Kind, true)}</span>\
<span class="ag">${badge(AGG, e.keys.Aggregation, true)}</span>\
<span class="ar">(${esc(e.args.join(', '))})</span></button>
</div>`;
}).join('\n');

// ---- the embedded payload --------------------------------------------------
// Everything a card shows and nothing a row already carries. Parameters are lined up
// by position here: the meta file keys a parameter's text by the name its annotation
// carries, and a card knows parameters only by where they sit.

const payload = Object.fromEntries(entries.map((e) => [e.menu + '::' + e.name, {
  menu: e.menu, name: e.name,
  mn: e.keys['Menu name'] || null,
  fn: e.keys.Function,
  holder: e.keys.Holder,
  kind: e.keys.Kind,
  agg: e.keys.Aggregation,
  args: e.args,
  exprs: e.keys.Args === 'none' ? [] : list(e.keys.Args),
  ret: e.keys.Returns || null,
  rf: list(e.keys['Return fields']),
  since: e.keys.Since,
  v: versionsOf(e).join(' '),
  removed: e.keys.Removed || null,
  seen: e.keys['Seen at'] || null,
  by: e.keys['Added by'] || null,
  doc: {
    p: e.prose,
    params: e.paramOrder.map((n) => e.params[n] || ''),
    ret: e.ret || '',
  },
}]));

const menus = [...new Set(entries.map((e) => e.menu))].sort();
const countOf = (pred) => entries.filter(pred).length;
const describedCount = countOf(described);
const overrides = countOf((e) => e.keys.Kind === 'override');

// ---- the page script -------------------------------------------------------

const JS = `
var D=JSON.parse(document.getElementById('data').textContent);
var VS=${JSON.stringify(VERSIONS)},NEW='${tokenOf(NEWEST)}';
var KIND=${JSON.stringify(KIND)},AGG=${JSON.stringify(AGG)},HOLDER=${JSON.stringify(HOLDER)};
var E=function(s){return String(s==null?'':s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');};
// The one implementation, shipped rather than ported: the rows and the cards must
// never disagree about which versions something is in.
${versionRange.toString()}
var vrange=function(c){var h=' '+c.v+' ';
  return versionRange(VS,VS.filter(function(v){return h.indexOf(' v'+v.split('.').join('_')+' ')>=0;}));};
var says=function(m,k){return m[k]?'<b class="t-'+m[k][0]+'">'+E(m[k][2])+'</b>':'<b class="t-no">'+E(k)+'</b>';};
var word=function(m,k){return m[k]?'<b class="t-'+m[k][0]+'">'+E(m[k][1])+'</b>':'<b class="t-no">'+E(k)+'</b>';};

// How a mod hangs a function on this hook. The holder decides the shape, and the menu
// name is the string Helper.getMenu() takes - which is not the file name: the
// blueprint trader's file is menu_trader_blueprintsorlicences and its name is
// BlueprintOrLicenceTraderMenu.
function snippet(c){
  var body=c.kind==='override'
    ? '    -- return the value the menu should use'
    : '    -- ...';
  var call='registerCallback("'+c.name+'", function('+c.args.join(', ')+')\\n'+body+'\\nend, "my_mod_id")';
  if(c.holder==='Helper') return 'Helper.'+call;
  var who=c.holder==='uix_menu'?'<the menu being drawn>':(c.mn||c.menu);
  return 'local m = Helper.getMenu("'+who+'")\\nm.'+call;
}

function card(k){
  var c=D[k]; if(!c) return '';
  var d=c.doc||{};
  var out=[d.p&&d.p.length
    ? '<p class="d">'+d.p.map(E).join(' ')+'</p>'
    : '<p class="d none">No description yet. This one is still only what the extraction could measure.</p>'];

  out.push('<pre><code>'+E(snippet(c))+'</code></pre>');
  if(c.holder==='uix_menu'){
    out.push('<p class="none">Dispatched by a Helper function off the menu it was handed, so it is '+
      'registered on whichever menu is being drawn, not on Helper.</p>');
  }
  out.push('<p class="copyrow"><button class="copy" type="button" data-copy="'+E(c.name)+'">Copy name</button>'+
    '<button class="copy" type="button" data-copy-sel="pre code">Copy registration</button>'+
    '<button class="copy" type="button" data-copy-link="#'+E('c-'+(c.menu+'-'+c.name).replace(/[^a-zA-Z0-9_-]/g,'_'))+'">Copy link</button></p>');

  var rows=[];
  rows.push(['Dispatched from','<code>'+E(c.fn)+'</code> in <code>'+E(c.menu)+'.xpl</code>'+
    (c.seen?'<br><span class="k">at</span> <code>'+E(c.seen)+'</code>':'')]);
  rows.push(['Registered on',says(HOLDER,c.holder)+
    (c.mn?'<br><code>Helper.getMenu("'+E(c.mn)+'")</code>':'')]);
  rows.push(['Kind',says(KIND,c.kind)]);
  rows.push(['Aggregation',says(AGG,c.agg)]);
  if(c.args.length){
    rows.push(['Parameters',c.args.map(function(a,i){
      var t=(d.params||[])[i],x=(c.exprs||[])[i];
      return '<code>'+E(a)+'</code>'+(x&&x!==a?' <span class="k">passed as</span> <code>'+E(x)+'</code>':'')+
        (t?' - '+E(t):'');}).join('<br>')]);
  }else{
    rows.push(['Parameters','<i>none</i>']);
  }
  if(c.kind==='override'){
    rows.push(['Returns',(c.ret?'read into <code>'+E(c.ret)+'</code>':'a value the menu uses')+
      (c.rf&&c.rf.length?'<br><span class="k">fields read</span> '+c.rf.map(function(f){
        return '<code>.'+E(f)+'</code>';}).join(', '):'')+
      (d.ret?'<br>'+E(d.ret):'')]);
  }
  var r=vrange(c);
  rows.push(['Versions','<b class="t-'+r.tone+'">'+E(r.long)+'</b>'+
    '<br><span class="k">first seen in</span> '+E(c.since)+
    (c.removed?'<br><b class="t-gone">'+E(c.removed)+'</b>':'')]);
  if(c.by) rows.push(['Added by',E(c.by)]);

  return '<div class="card"><p class="badges">'+word(KIND,c.kind)+word(AGG,c.agg)+word(HOLDER,c.holder)+'</p>'+
    out.join('')+
    '<table>'+rows.map(function(kv){return '<tr><th>'+kv[0]+'</th><td>'+kv[1]+'</td></tr>';}).join('')+'</table></div>';
}

var box=document.querySelector('.list');
function open(row,scroll){
  if(!row) return;
  if(!row.classList.contains('open')){
    if(!row.querySelector('.card')) row.insertAdjacentHTML('beforeend',card(row.dataset.k));
    row.classList.add('open');
  }
  if(scroll) row.scrollIntoView({block:'start'});
}
box.addEventListener('click',function(e){
  var hd=e.target.closest('.hd'); if(!hd) return;
  var row=hd.parentElement;
  if(row.classList.contains('open')) row.classList.remove('open'); else open(row,false);
});

var q=document.getElementById('q'),n=document.getElementById('n'),
    sel=Array.prototype.slice.call(document.querySelectorAll('.bar select')),
    rows=Array.prototype.slice.call(box.children).map(function(r){
      var c=D[r.dataset.k]||{},d=c.doc||{};
      return {r:r,f:' '+r.dataset.f+' ',
        h:(r.dataset.k+' '+(c.mn||'')+' '+(c.fn||'')+' '+(c.args||[]).join(' ')+' '+
           ((d.p||[]).join(' '))).toLowerCase()};});
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

// A deep link has to survive the default filter and open its card.
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

// ---- the page --------------------------------------------------------------

const select = (label, vals, def = '') =>
  `<select data-def="${def}" aria-label="${esc(label)}"><option value="">${esc(label)}: all</option>` +
  vals.map(([v, l]) => `<option value="${esc(v)}"${v === def ? ' selected' : ''}>${esc(l)}</option>`).join('') +
  '</select>';

const aggRow = (k) => `<tr><th>${esc(AGG[k][1])}</th><td>${esc(AGG[k][2])}. ` +
  `${countOf((e) => e.keys.Aggregation === k)} of them.</td></tr>`;

const body = `<h1>UIX callbacks</h1>
<p class="lede">Every hook <a href="https://github.com/kuertee/x4-mod-ui-extensions">UI Extensions and HUD</a> puts
into X4's menus. UIX ships patched copies of the vanilla menu files with callback dispatch points added, and a mod
registers a function against one by name: that is how a UI mod changes a menu without replacing the file, and how two
mods change the same menu without fighting. Read out of the mod's own <code>.xpl</code> files at
${VERSIONS.join(' and ')}.</p>
<p class="lede">${meta.callbacks} callbacks across ${meta.menus} menus, ${overrides} of which are given a return value
the menu then uses. The mod's own readme says no list of them exists and to search the code, so this is that list, and
the descriptions are written by hand: ${describedCount} of ${meta.callbacks} so far.</p>

<div class="dl">
<a class="btn" href="#callbacks">Browse</a>
<p>Open a row for the registration call, what the hook is handed, what it may return and which releases have it.</p>
</div>

<div class="dl">
<a class="btn" href="${URL}uix-callbacks.lua" download>Download <code>uix-callbacks.lua</code></a>
<p>${LUA_KB} KB. This page as a Lua Language Server meta file, which is also the file it is built from: one table per
menu, every callback with its contract above it. Point an editor at it as a library and a handler gets completion and
signatures for what it is passed.</p>
</div>

<details class="box"><summary>How to register one</summary>
<p>A callback lives on the table that dispatches it, and there are two of those: the menu, and the global
<code>Helper</code>. A menu is reached by the name it registers itself under, which is not its file name.</p>
<pre><code>local function init()
    local m = Helper.getMenu("MapMenu")
    m.registerCallback("createPropertyOwned_on_start", function(config)
        -- ...
    end, "my_mod_id")
end
init()</code></pre>
<p>The third argument is an id of your own. It is optional, and worth passing anyway: it is what
<code>m.deregisterCallback(name, nil, "my_mod_id")</code> needs, and registering the same name twice under one id is
ignored rather than doubled. A <code>Helper</code> hook is <code>Helper.registerCallback(name, fn, id)</code> with no
menu in front of it.</p>
<p>Every card below carries the exact call for that hook, with its parameters filled in.</p>
</details>

<details class="box"><summary>How to read a row</summary>
<table class="legend">
<tr><th>Kind</th><td>${badge(KIND, 'event', false)} and ${badge(KIND, 'override', false)}.
${countOf((e) => e.keys.Kind === 'event')} events, ${overrides} overrides.</td></tr>
<tr><th>Aggregation</th><td>What happens when more than one mod registers against the same hook. Nothing at the call
site announces it, and it is the field a reader cannot guess, so it is measured:
<table>${Object.keys(AGG).filter((k) => countOf((e) => e.keys.Aggregation === k)).map(aggRow).join('')}</table></td></tr>
<tr><th>Registered on</th><td>${badge(HOLDER, 'menu', false)}.<br>${badge(HOLDER, 'Helper', false)}.<br>
${badge(HOLDER, 'uix_menu', false)}.</td></tr>
<tr><th>Versions</th><td><b class="t-ok">all</b> in every release covered here (${VERSIONS.join(', ')}).<br>
<b class="t-new">${esc('≥ ' + NEWEST)}</b> from that release onwards, so new since the one before it, and marked
<span class="new">NEW</span> on its row.<br>
<b class="t-gone">${esc('≤ ' + VERSIONS[0])}</b> up to that release, and gone since. A hook that disappears takes every
mod registered against it with it, silently: the registration still succeeds and is simply never called.</td></tr>
<tr><th>Copying</th><td>An open card carries <b>Copy name</b>, <b>Copy registration</b> and <b>Copy link</b>; the last
gives a URL that reopens that card.</td></tr>
</table>
<p>The version axis here is the mod's own release tags, not the game's. A UIX release usually follows a game version,
but a callback appears when kuertee adds it, which is what a mod author is actually pinned to.</p>
</details>

<details class="box"><summary>Where a description comes from, and how to write one</summary>
<p>Nothing in UIX describes what a callback is for. The names carry a convention - <code>[function]_[action]</code>,
with <code>_on_</code> and a present-tense verb for an event - and that is the whole of what exists, which is why most
cards below say so. What descriptions there are have been written by hand into <code>uix-callbacks.lua</code> itself:
the file offered above is both what this page is built from and where its prose lives, so a description and the hook
it belongs to are never apart.</p>
<p>An entry takes three authored things, and nothing else in it is authored:</p>
<pre><code>-- Menu: menu_transporter (ego_detailmonitor)
-- Menu name: TransporterMenu
-- Function: menu.display
-- Holder: menu
-- Kind: override
-- Aggregation: unanimous
-- Args: active
-- Returns: result
-- Return fields: active
-- Since: ${VERSIONS[0]}
-- Versions: ${VERSIONS.join(', ')}
-- Seen at: menu_transporter.xpl:705 (${NEWEST})
-- Added by: kuertee
--- Decides whether the transporter room's "Go to" button is enabled.
---@param active any # what the menu decided on its own
---@return any # a table; only its \`active\` field is read
function menu_transporter.display_on_set_room_active(active) end</code></pre>
<p>The <code>---</code> lines are the description, and the text after the <code>#</code> on a <code>---@param</code> or
<code>---@return</code> says what that one value is. Everything reading <code>-- Key: value</code> is generated from the
extraction and rewritten whenever UIX moves on; the authored kinds are carried across untouched, and
<code>Since:</code> is stamped once and then owned by the file.
<a href="https://github.com/chemodun/chemodun.github.io/blob/main/src/uix-callbacks/uix-callbacks.lua">The file is on
GitHub</a>, and a description added to it is a pull request against that one file.</p>
</details>

<details class="box"><summary>Using it in an editor</summary>
<p>The Lua Language Server reads a meta file when it is listed as a workspace library. In VS Code that is
<code>.luarc.json</code> beside the workspace root, or the same key in settings:</p>
<pre><code>{
  "workspace.library": [ "path/to/uix-callbacks.lua" ]
}</code></pre>
<p>The declarations exist so an editor has something to complete against and are never loaded by the game. Parameters
are typed <code>any</code> deliberately: what a hook is handed is a menu's own local, and naming a type it does not
have would be a guess an editor then enforces. For the wider set of X4 Lua definitions there is a packaged addon,
<a href="https://github.com/chemodun/X4-LuaLSAddon">X4-LuaLSAddon</a>, and for the rest of the UI namespace the
<a href="/x4/modding-support/ui-modding/lua-globals/">globals</a> and
<a href="/x4/modding-support/ui-modding/c-functions-and-structures/">C functions</a> references.</p>
</details>

<h2 id="callbacks">Callbacks</h2>
<div class="bar">
<input id="q" type="search" placeholder="Filter by name, menu or description…" autocomplete="off">
${select('Menu', menus.map((m) => ['m-' + m, `${m} (${countOf((e) => e.menu === m)})`]))}
${select('Kind', Object.keys(KIND).map((k) => ['k-' + k, `${KIND[k][1]} (${countOf((e) => e.keys.Kind === k)})`]))}
${select('Aggregation', Object.keys(AGG).filter((k) => countOf((e) => e.keys.Aggregation === k))
    .map((k) => ['a-' + k, `${AGG[k][1]} (${countOf((e) => e.keys.Aggregation === k)})`]))}
${select('Registered on', Object.keys(HOLDER).filter((k) => countOf((e) => e.keys.Holder === k))
    .map((k) => ['h-' + k, `${HOLDER[k][1]} (${countOf((e) => e.keys.Holder === k)})`]))}
${select('Description', [['described', `described (${describedCount})`],
    ['undescribed', `not described yet (${meta.callbacks - describedCount})`]])}
${select('Release', [...VERSIONS.map((v) => [tokenOf(v), `in ${v} (${countOf((e) => versionsOf(e).includes(tokenOf(v)))})`]),
    ['new', `new in ${NEWEST} (${countOf(isNew)})`]])}
<button id="clr" type="button">Reset</button><span class="n" id="n"></span>
${legend([['Name'], ['Menu', 'The name Helper.getMenu() takes'],
  ['Kind', 'Kind: whether the return value is used'],
  ['Aggregation', 'Aggregation: what happens when more than one mod registers'],
  ['Parameters', 'What the hook is handed']])}
</div>
<div class="list">
${rows}
</div>

<script id="data" type="application/json">${JSON.stringify(payload).replace(/</g, '\\u003c')}</script>`;

const html = shell({
  title: 'UIX callbacks',
  description: `Every callback kuertee's UI Extensions and HUD puts into X4: Foundations' menus - what dispatches it, `
    + `what it is handed, what it may return and which release has it, for ${VERSIONS.join(' and ')}.`,
  trail: [
    { label: 'Home', href: '/' },
    { label: 'For X4: Foundations', href: '/x4/' },
    { label: 'Modding Support', href: '/x4/modding-support/' },
    { label: 'UI Modding support', href: '/x4/modding-support/ui-modding/' },
    { label: 'UIX callbacks', href: URL },
  ],
  body,
  css: CSS,
  js: JS,
});

fs.mkdirSync(path.dirname(OUT), { recursive: true });
fs.writeFileSync(OUT, html, 'utf8');
// The meta file ships beside the page: it is the download, and it is the source.
fs.copyFileSync(LUA, path.join(path.dirname(OUT), 'uix-callbacks.lua'));
console.log('wrote ' + OUT + ' (' + (fs.statSync(OUT).size / 1024).toFixed(0) + ' KB)');
console.log('wrote ' + path.join(path.dirname(OUT), 'uix-callbacks.lua') + ' (' + LUA_KB + ' KB)');
console.log(`${entries.length} callbacks in ${byMenu.size} menus, read from uix-callbacks.lua`);
console.log(`described: ${describedCount}`);
