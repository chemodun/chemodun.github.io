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
const { shell, esc, legend } = require('../layout.js');
const { parse } = require('./meta.js');

const DATA = path.join(__dirname, 'data');
const meta = JSON.parse(fs.readFileSync(path.join(DATA, 'meta.json'), 'utf8'));

const LUA = path.join(__dirname, 'uix-callbacks.lua');
const LUA_KB = Math.round(fs.statSync(LUA).size / 1024);
const byMenu = parse(fs.readFileSync(LUA, 'utf8'));

const VERSIONS = meta.versions.map((v) => v.version);
const NEWEST = VERSIONS[VERSIONS.length - 1];
const tokenOf = (v) => 'v' + v.replace(/\./g, '_');

// The axis is two PARALLEL lines, not one sequence: 8.0.4.10 and 9.0.0.7 were
// published the same day. A reader is on one line or the other, so presence is
// read per line and "current" means that line's head release.
const LINES = meta.lines;
const LINE_NAMES = Object.keys(LINES).sort();
const lineOf = (v) => String(v).split('.')[0] + '.x';
const releasesIn = (l) => LINES[l].releases;

const entries = [];
for (const list of byMenu.values()) entries.push(...list);
entries.sort((a, b) => a.menu.localeCompare(b.menu) || a.name.localeCompare(b.name));

const list = (s) => (s ? String(s).split(',').map((x) => x.trim()).filter(Boolean) : []);

// `Versions:` is stored collapsed - "8.0.4.9..8.0.4.10, 9.0.0.3..9.0.0.14" -
// because 33 release names is not a line anyone reads. Expanding it back needs
// each line's release order, which meta.json carries. The separator is `..` and
// not `-` because 8.0.0.7-rc1 has a hyphen of its own.
const expand = (s) => list(s).flatMap((r) => {
  const [a, b] = r.split('..');
  if (!b) return [a];
  const order = releasesIn(lineOf(a));
  return order.slice(order.indexOf(a), order.indexOf(b) + 1);
});
const inLine = (e, l) => expand(e.keys.Versions).filter((v) => lineOf(v) === l);
const firstIn = (e, l) => inLine(e, l)[0] || null;
const versionsOf = (e) => expand(e.keys.Versions).map(tokenOf);
const described = (e) => e.prose.length > 0;

// NEW marks the most recent additions, which is not the same as "in the head
// release": 9.0.0.14 added nothing, and a badge that matched it would mark none of
// the 17 hooks 9.0.0.13 brought. So it is the latest release on each line that
// introduced anything, its own floor excepted - everything is "new" there.
const NEWEST_ADDING = {};
for (const l of LINE_NAMES) {
  const rs = releasesIn(l);
  NEWEST_ADDING[l] = rs.slice(1).reverse().find((t) => entries.some((e) => firstIn(e, l) === t)) || null;
}
const isNew = (e) => LINE_NAMES.some((l) => NEWEST_ADDING[l] && firstIn(e, l) === NEWEST_ADDING[l]);

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
  const known = VERSIONS.map(tokenOf);
  const got = versionsOf(e);
  const unknown = got.filter((t) => !known.includes(t));
  if (unknown.length) problems.push(`${e.menu}::${e.name} is in ${unknown.join(', ')}, which meta.json does not cover`);
  // An unexpandable range reads as zero releases, which would otherwise publish as
  // a hook that exists in nothing at all.
  if (!got.length) problems.push(`${e.menu}::${e.name} has a Versions: no release order can expand`);
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

// ---- availability, per line -------------------------------------------------
// Computed here and shipped rendered, rather than recomputed in the browser: the
// row badge and the card must never disagree about which releases have a hook.

function availability(e) {
  return LINE_NAMES.map((l) => {
    const rs = releasesIn(l), on = inLine(e, l), head = LINES[l].head;
    if (!on.length) return { line: l, tone: 'no', text: `never in the ${l} line` };
    const whole = on.length === rs.length;
    const gaps = on.length !== rs.indexOf(on[on.length - 1]) - rs.indexOf(on[0]) + 1;
    if (whole) return { line: l, tone: 'ok', text: `every ${l} release (${rs[0]} to ${head})` };
    if (gaps) return { line: l, tone: 'warn', text: `${l}: ${e.keys.Versions.split(',').map((x) => x.trim()).filter((x) => lineOf(x) === l).join(', ').replace(/\.\./g, ' to ')}` };
    if (on[on.length - 1] === head) return { line: l, tone: 'new', text: `${l} from ${on[0]} onwards` };
    return { line: l, tone: 'gone', text: `${l} up to ${on[on.length - 1]}, gone since` };
  });
}

// One word for the row: is it in both current releases, one, or neither.
function standing(e) {
  const heads = LINE_NAMES.filter((l) => inLine(e, l).includes(LINES[l].head));
  if (!heads.length) return 'gone';
  if (heads.length === LINE_NAMES.length) return 'both';
  return heads[0];
}

const publishedOf = new Map(meta.versions.map((v) => [v.version, v.published]));

// Present in the oldest release of its line for a reason that is not an addition:
// at the 8.x floor everything simply predates the scan, and at the 9.x floor a hook
// the 8.x line already had arrived with the branch rather than being written for it.
function inherited(e, l) {
  const rs = releasesIn(l);
  if (!inLine(e, l).length || inLine(e, l)[0] !== rs[0]) return false;
  const i = LINE_NAMES.indexOf(l);
  if (i === 0) return true; // the oldest line's floor is the pre-8.0 baseline
  const older = inLine(e, LINE_NAMES[i - 1]);
  return !!older.length && publishedOf.get(older[0]) < publishedOf.get(rs[0]);
}

// The releases of one line where this hook appeared or disappeared - the only thing
// a per-release filter can usefully say. "Present in 8.0.2.0" is true of 209 hooks
// and so tells a reader nothing; "changed in 8.0.2.0" is true of eight.
function changesIn(e, l) {
  const rs = releasesIn(l), on = new Set(inLine(e, l)), out = [];
  let prev = false;
  for (let i = 0; i < rs.length; i++) {
    const here = on.has(rs[i]);
    if (here && !prev && !(i === 0 && inherited(e, l))) out.push(rs[i]);
    if (!here && prev) out.push(rs[i]);
    prev = here;
  }
  return out;
}

const changedIn = new Map();      // release -> [added, dropped]
for (const l of LINE_NAMES) {
  const rs = releasesIn(l);
  for (const v of rs) changedIn.set(v, [0, 0]);
  for (const e of entries) {
    const on = new Set(inLine(e, l));
    for (const v of changesIn(e, l)) changedIn.get(v)[on.has(v) ? 0 : 1]++;
  }
}
// `(0)` and not an omission: a release that touched code without adding or dropping
// a hook is a fact about that release, and leaving it out reads as a gap in the list.
const changeLabel = (v) => {
  const [a, d] = changedIn.get(v);
  return `${v} (${[a ? '+' + a : '', d ? '-' + d : ''].filter(Boolean).join(' ') || '0'})`;
};

// ---- the list --------------------------------------------------------------

const rows = entries.map((e) => {
  // A token per release the hook merely existed in would be up to 33 of them and
  // nothing in the bar asks for it any more. What the bar asks for is the current
  // releases and the ones that changed something, which is at most a handful.
  const facets = ['m-' + e.menu, 'k-' + e.keys.Kind, 'a-' + e.keys.Aggregation, 'h-' + e.keys.Holder,
    described(e) ? 'described' : 'undescribed', 'in-' + standing(e),
    inLine(e, LINE_NAMES[LINE_NAMES.length - 1]).includes(NEWEST) ? 'latest' : '',
    ...LINE_NAMES.filter((l) => inLine(e, l).includes(LINES[l].head)).map((l) => 'head-' + l),
    ...LINE_NAMES.filter((l) => inherited(e, l)).map((l) => 'base-' + l),
    ...LINE_NAMES.flatMap((l) => changesIn(e, l)).map((v) => 'chg-' + tokenOf(v)),
    isNew(e) ? 'new' : ''].filter(Boolean).join(' ');
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
  av: availability(e),
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
var LINES=${JSON.stringify(LINES)};
var KIND=${JSON.stringify(KIND)},AGG=${JSON.stringify(AGG)},HOLDER=${JSON.stringify(HOLDER)};
var E=function(s){return String(s==null?'':s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');};
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
  rows.push(['Available',c.av.map(function(a){
      return '<b class="t-'+a.tone+'">'+E(a.text)+'</b>';}).join('<br>')+
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
    if(el.classList.contains('hide')){q.value='';
      // '' is no longer an option on every select, and setting it anyway leaves one
      // blank. Widen each to the first of its options the target actually satisfies.
      var f=' '+el.dataset.f+' ';
      sel.forEach(function(s){
        if(s.querySelector('option[value=""]')){s.value='';return;}
        var opt=[].slice.call(s.querySelectorAll('option')).filter(function(o){
          return f.indexOf(' '+o.value+' ')>=0;})[0];
        if(opt) s.value=opt.value;});
      apply();}
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

// 33 releases in one flat list is unreadable, and the two lines are the division a
// reader already has in mind.
// No "all" option: every hook belongs to some release, so the honest default is the
// current one rather than a mixture of live and long-dropped entries. A deep link
// into something the default hides is handled in the page script instead.
const selectGrouped = (label, groups, def) =>
  `<select data-def="${esc(def)}" aria-label="${esc(label)}">` +
  groups.map(([g, vals]) => (g ? `<optgroup label="${esc(g)}">` : '') +
    vals.map(([v, l]) => `<option value="${esc(v)}"${v === def ? ' selected' : ''}>${esc(l)}</option>`).join('')
    + (g ? '</optgroup>' : '')).join('') +
  '</select>';

const aggRow = (k) => `<tr><th>${esc(AGG[k][1])}</th><td>${esc(AGG[k][2])}. ` +
  `${countOf((e) => e.keys.Aggregation === k)} of them.</td></tr>`;

const body = `<h1>UIX callbacks</h1>
<p class="lede">Every hook <a href="https://github.com/kuertee/x4-mod-ui-extensions">UI Extensions and HUD</a> puts
into X4's menus. UIX ships patched copies of the vanilla menu files with callback dispatch points added, and a mod
registers a function against one by name: that is how a UI mod changes a menu without replacing the file, and how two
mods change the same menu without fighting. Read out of the mod's own <code>.xpl</code> files at every one of its
${VERSIONS.length} releases from ${VERSIONS[0]} onwards, so each hook carries the release it appeared in. The current
ones are ${LINE_NAMES.map((l) => `${LINES[l].head} (${l})`).join(' and ')}.</p>
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
<tr><th>Available</th><td>The <b>8.x</b> and <b>9.x</b> lines run in parallel - ${LINES['8.x'].head} and
${LINES['9.x'].head} are both current - so a card answers per line, and the row's
<span class="new">NEW</span> marks the latest additions to either
(${LINE_NAMES.filter((l) => NEWEST_ADDING[l]).map((l) => NEWEST_ADDING[l]).join(' and ')}).<br>
<b class="t-ok">every 8.x release</b> present throughout that line.<br>
<b class="t-new">9.x from ${LINES['9.x'].releases[1]} onwards</b> added there, and still current.<br>
<b class="t-no">never in the 8.x line</b> a hook that line never had, so a mod using it will not run on it.<br>
<b class="t-gone">8.x up to …, gone since</b> dropped. A hook that disappears takes every mod registered against it
with it, silently: the registration still succeeds and is simply never called.<br>
The <b>Available in</b> filter reads the same way: each line offers what its current release has, then what every
release <b>changed</b>. <code>9.0.0.13 (+17)</code> is the seventeen hooks that release introduced, not the 293 it
carries - "present in" is true of nearly everything and so says nothing. <code>${NEWEST} (0)</code> means that
release altered UIX without adding or dropping a hook, which is most of them.</td></tr>
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
-- Since: pre-8.0
-- Versions: ${LINES['8.x'].releases[0]}..${LINES['8.x'].head}, ${LINES['9.x'].releases[0]}..${LINES['9.x'].head}
-- Seen at: menu_transporter.xpl:705 (${NEWEST})
-- Added by: kuertee
--- Decides whether the transporter room's "Go to" button is enabled.
---@param active any # what the menu decided on its own
---@return any # a table; only its \`active\` field is read
function menu_transporter.display_on_set_room_active(active) end</code></pre>
<p>The <code>---</code> lines are the description, and the text after the <code>#</code> on a <code>---@param</code> or
<code>---@return</code> says what that one value is. Everything reading <code>-- Key: value</code> is generated from the
extraction and rewritten whenever UIX moves on, <code>Since:</code> included - it is measured against every release,
not remembered - while the authored kinds are carried across untouched.
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
${selectGrouped('Available in',
  // Newest line first, and within a line the head's "everything here" over what each
  // release changed, newest first. Every release is listed, including the ones that
  // changed nothing - the oldest line's floor excepted, since the baseline item at
  // the bottom of that group is the same release said properly.
  [...LINE_NAMES].reverse().map((l) => [l, [
    ['head-' + l, `available in ${LINES[l].head} (${countOf((e) => inLine(e, l).includes(LINES[l].head))})`],
    ...releasesIn(l).slice().reverse()
      .filter((v) => !(LINE_NAMES.indexOf(l) === 0 && v === releasesIn(l)[0]))
      .map((v) => ['chg-' + tokenOf(v), changeLabel(v)]),
    ...(countOf((e) => inherited(e, l)) && LINE_NAMES.indexOf(l) === 0
      ? [['base-' + l, `${releasesIn(l)[0]} and earlier (${countOf((e) => inherited(e, l))})`]] : []),
  ]]),
  'head-' + LINE_NAMES[LINE_NAMES.length - 1])}
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
    + `what it is handed, what it may return and which UIX release it appeared in, across all ${VERSIONS.length}`
    + ` releases from ${VERSIONS[0]} to ${NEWEST}.`,
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
