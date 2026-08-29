'use strict';

// Builds the script commands reference.
//
//   OUT=path/to/index.html node build-html.js
//
// The page renders three sections. Attribute groups and types are the *shared* halves of the
// schema, so they are rendered once, statically. Commands reference them, and a command card
// is assembled in the browser when its row is opened: <find> alone is 89 attributes reused by
// 19 commands, so rendering every card up front would emit the same tables dozens of times.

const fs = require('fs');
const path = require('path');
const { shell, esc, wikiRef, versionRange } = require('../layout.js');

const DATA = path.join(__dirname, 'data');
const read = (name) => JSON.parse(fs.readFileSync(path.join(DATA, name), 'utf8'));

const meta = read('meta.json');
const commands = read('commands.json');
const groups = read('groups.json');
const params = read('params.json');
const types = read('types.json');

const URL = '/x4/modding-support/scripting-md-libraries-map/script-commands/';
const OUT = process.env.OUT || path.join(__dirname, '..', '..', '_site', ...URL.split('/').filter(Boolean), 'index.html');

const VERSIONS = meta.versions;
const NEWEST = VERSIONS[VERSIONS.length - 1];
const tokenOf = (v) => 'v' + v.replace('.', '');
const ALL_TOKENS = VERSIONS.map(tokenOf).join(' ');

// A thing with no "v" is in every version; the extractor only stamps the exceptions.
const versionsOf = (node) => (node && node.v ? node.v : ALL_TOKENS);
const inNewest = (node) => versionsOf(node).includes(tokenOf(NEWEST));
const isNew = (node) => versionsOf(node) === tokenOf(NEWEST) && VERSIONS.length > 1;

const id = (prefix, name) => prefix + '-' + String(name).replace(/[^a-zA-Z0-9_~-]/g, '_');

// Presence as a range rather than one tick per version: see versionRange in
// ../layout.js for why. Short in a collapsed header, a sentence in what it opens.
const rangeOf = (node) => versionRange(VERSIONS,
  VERSIONS.filter((v) => versionsOf(node).includes(tokenOf(v))));

const versionShort = (node) => {
  const r = rangeOf(node);
  return `<b class="t-${r.tone}" title="${esc(r.long)}">${esc(r.short)}</b>`;
};

const versionLine = (node) => {
  const r = rangeOf(node);
  return `<p class="vers"><span class="k">Game versions</span><b class="t-${r.tone}">${esc(r.long)}</b></p>`;
};

// Only what is this page's own. The theme, the tone palette and every shared component
// - the filter bar, the disclosure chevron and its type sizes, the callout strip, the
// chips - come from ../layout.js, so this page and the globals reference are one object.

const CSS = `
.lead{max-width:62ch}
.counts{color:var(--dim);font-size:.9em;margin:.4em 0 0}

.list{border:1px solid var(--line);border-radius:6px;overflow:hidden}
.row{border-top:1px solid var(--line);content-visibility:auto;contain-intrinsic-size:auto 41px}
.row:first-child{border-top:0}
.row.open{background:var(--soft)}
/* The card is built once and left in the DOM, so collapsing is this rule, not a
   removal: without it the chevron turned and nothing else did. */
.row:not(.open)>.card{display:none}
.hd{display:grid;grid-template-columns:minmax(10em,17em) 5.6em 4.2em 5.4em 1fr;gap:.6em;
  align-items:baseline;border-radius:0}
.row.open>.hd{border-bottom:1px solid var(--line)}

.card{padding:2px 14px 14px}
.card h4{margin:1.1em 0 .3em;font-size:.95em}
.card h4 .cnt{color:var(--dim);font-weight:400}
.card p.d{margin:.6em 0}
.card .meta{color:var(--dim);font-size:.88rem;margin:.4em 0 0}
table.at{display:block;overflow-x:auto}
table.at th{background:var(--bg);white-space:nowrap}
table.at td.n,table.at td.t,table.at td.fr{white-space:nowrap}
table.at td.n{font-family:var(--mono)}
table.at td.fr{font-size:.86em}
table.at td.fr a{font-family:var(--mono)}
.req{color:var(--acc);font-weight:700}
a.ref{font-family:var(--mono);font-size:.92em}

.shared{border:1px solid var(--line);border-radius:6px;padding:.6em .9em;margin:.7em 0;
  content-visibility:auto;contain-intrinsic-size:auto 90px}
.shared:target{border-color:var(--acc)}
.shared>h3{margin:0 0 .2em;font-size:1em;font-family:var(--mono)}
.shared p{margin:.2em 0;color:var(--dim);font-size:.92em}
.shared p.vers{color:inherit}
ul.ev{margin:.4em 0;padding-left:1.1em;columns:2;column-gap:2em}
ul.ev li{break-inside:avoid;margin:.1em 0}
ul.ev code{font-size:.92em}
ul.ev span{color:var(--dim)}
@media (max-width:640px){.hd{grid-template-columns:1fr;row-gap:.2em}.hd .vs,.hd .sc,.hd .kd{display:none}ul.ev{columns:1}}
`;

function typeChip(type) {
  if (!type) return '<span class="tag">any</span>';
  const t = types[type];
  if (!t) return `<code>${esc(type)}</code>`;
  const n = t.values ? ` <span class="c">${t.values.length}</span>` : '';
  return `<a class="ref" href="#${id('t', type)}"><code>${esc(type)}</code>${n}</a>`;
}

// One attributes table. Used for groups and types statically, and mirrored by the page script
// for the command cards.
function attrTable(attrs) {
  const names = Object.keys(attrs).sort();
  if (!names.length) return '';
  const rows = names
    .map((n) => {
      const a = attrs[n];
      const req = a.required ? '<span class="req" title="required">*</span>' : '';
      const ver = inNewest(a) ? (isNew(a) ? '<span class="new">NEW</span>' : '') : ` ${versionShort(a)}`;
      return `<tr><td class="n"><code>${esc(n)}</code>${req}${ver}</td><td class="t">${typeChip(a.type)}</td><td>${esc(a.doc || '')}</td></tr>`;
    })
    .join('');
  return `<table class="at"><thead><tr><th>Attribute</th><th>Type</th><th>Description</th></tr></thead><tbody>${rows}</tbody></table>`;
}

// ---- static sections -------------------------------------------------------

const groupCards = Object.keys(groups)
  .sort()
  .map((name) => {
    const g = groups[name];
    const n = Object.keys(g.attrs || {}).length;
    const used = Object.values(commands).filter((c) => (c.groups || []).includes(name)).length;
    return `<section class="shared" id="${id('g', name)}">
<h3>${esc(name)} ${isNew(g) ? '<span class="new">NEW</span>' : ''}</h3>
<p>${n} attribute${n === 1 ? '' : 's'}, used by ${used} command${used === 1 ? '' : 's'}${g.doc ? '. ' + esc(g.doc) : ''}</p>
${g.v ? versionLine(g) : ''}
${attrTable(g.attrs || {})}
</section>`;
  })
  .join('\n');

const typeCards = Object.keys(types)
  .sort()
  .map((name) => {
    const t = types[name];
    const bits = [];
    if (t.base) bits.push(`based on <code>${esc(t.base)}</code>`);
    if (t.patterns) bits.push(`${t.patterns.length} pattern${t.patterns.length === 1 ? '' : 's'}`);
    for (const k of ['minInclusive', 'maxInclusive', 'minExclusive', 'maxExclusive', 'minLength', 'maxLength']) {
      if (t[k] !== undefined) bits.push(`${k} ${t[k]}`);
    }
    const values = t.values
      ? `<ul class="ev">${t.values
          .map((v) => `<li><code>${esc(v.v)}</code>${v.vs ? ' ' + versionShort({ v: v.vs }) : ''}${v.doc ? ` <span>${esc(v.doc)}</span>` : ''}</li>`)
          .join('')}</ul>`
      : '';
    const patterns = t.patterns
      ? `<p>Pattern: ${t.patterns.map((p) => `<code>${esc(p.length > 120 ? p.slice(0, 120) + '…' : p)}</code>`).join(' or ')}</p>`
      : '';
    return `<section class="shared" id="${id('t', name)}">
<h3>${esc(name)} <span class="tag">${esc(t.kind)}</span>${isNew(t) ? '<span class="new">NEW</span>' : ''}</h3>
${t.doc ? `<p>${esc(t.doc)}</p>` : ''}
${bits.length ? `<p>${bits.join(', ')}</p>` : ''}
${t.v ? versionLine(t) : ''}
${patterns}
${values}
</section>`;
  })
  .join('\n');

// ---- the command list ------------------------------------------------------

const names = Object.keys(commands).sort();
const rows = names
  .map((name) => {
    const c = commands[name];
    const schemas = c.in.length === 2 ? 'both' : c.in[0] === 'aiscripts' ? 'AI' : 'MD';
    const facets = [c.kind, ...c.in, ...versionsOf(c).split(' '), isNew(c) ? 'new' : ''].filter(Boolean).join(' ');
    const hay = (name + ' ' + (c.doc || '')).toLowerCase();
    return `<div class="row" id="${id('c', name)}" data-f="${facets}" data-h="${esc(hay)}" data-n="${esc(name)}">
<button class="hd disc" type="button">\
<span class="nm">${esc(name)}${isNew(c) ? '<span class="new">NEW</span>' : ''}</span>\
<span class="kd tag${c.kind === 'action' ? ' act' : ''}">${esc(c.kind)}</span><span class="sc tag" title="accepted by ${c.in.length === 2 ? 'both schemas' : c.in[0]}">${esc(schemas)}</span>\
<span class="vs">${versionShort(c)}</span>\
<span class="sum">${esc(c.doc || '')}</span></button>
</div>`;
  })
  .join('\n');

const counts = meta.counts;

// ---- the embedded payload --------------------------------------------------
// Only what a card cannot get from the page it is already on. Groups and types are
// rendered statically above, so the script carries their sizes for the chip labels
// and links to the real thing rather than shipping either catalogue twice.

const payload = {
  commands,
  params,
  groups: Object.fromEntries(Object.entries(groups).map(([n, g]) => [n, Object.keys(g.attrs || {}).length])),
  types: Object.fromEntries(Object.entries(types).map(([n, t]) => [n, t.values ? t.values.length : 0])),
};

// ---- the page script -------------------------------------------------------
// Builds a card from the embedded catalogues on first open, then leaves it in the DOM.

const JS = `
var D=JSON.parse(document.getElementById('data').textContent);
var VS=${JSON.stringify(VERSIONS)},NEW='${tokenOf(NEWEST)}',ALL='${ALL_TOKENS}';
var E=function(s){return String(s==null?'':s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');};
var ID=function(p,n){return p+'-'+String(n).replace(/[^a-zA-Z0-9_~-]/g,'_');};
var vof=function(x){return x&&x.v?x.v:ALL;};
var isNew=function(x){return vof(x)===NEW&&VS.length>1;};
// The one implementation, shipped rather than ported: the static half and the cards
// must never disagree about which versions something is in.
${versionRange.toString()}
var vrange=function(x){var h=vof(x);
  return versionRange(VS,VS.filter(function(v){return h.indexOf('v'+v.replace('.',''))>=0;}));};
var ticks=function(x){var r=vrange(x);
  return '<b class="t-'+r.tone+'" title="'+E(r.long)+'">'+E(r.short)+'</b>';};
var vline=function(x){var r=vrange(x);
  return '<p class="vers"><span class="k">Game versions</span><b class="t-'+r.tone+'">'+E(r.long)+'</b></p>';};

function chip(t){
  if(!t) return '<span class="tag">any</span>';
  var n=D.types[t]; if(n===undefined) return '<code>'+E(t)+'</code>';
  return '<a class="ref" href="#'+ID('t',t)+'"><code>'+E(t)+'</code>'+(n?' <span class="c">'+n+'</span>':'')+'</a>';
}
// One table per element: its own attributes, then everything its attribute groups bring in.
// The group rows are not rendered here - hydrate() clones them out of the static group
// section further down the page, so no group's attributes are ever emitted twice.
function table(attrs,groups){
  var ns=Object.keys(attrs||{}).sort(), gs=(groups||[]).filter(function(g){return D.groups[g];});
  if(!ns.length&&!gs.length) return '';
  return '<table class="at"><thead><tr><th>Attribute</th><th>Type</th><th>From</th><th>Description</th></tr></thead>'+
    '<tbody data-g="'+E(gs.join('|'))+'">'+
    ns.map(function(n){var a=attrs[n];
      var ver=vof(a).indexOf(NEW)<0?' '+ticks(a):(isNew(a)?'<span class="new">NEW</span>':'');
      return '<tr><td class="n"><code>'+E(n)+'</code>'+(a.required?'<span class="req" title="required">*</span>':'')+ver+
        '</td><td class="t">'+chip(a.type)+'</td><td class="fr"></td><td>'+E(a.doc||'')+'</td></tr>';}).join('')+
    '</tbody></table>';
}

// Pull each group's rows in from the section that already holds them.
function hydrate(scope){
  var bodies=scope.querySelectorAll('tbody[data-g]');
  for(var i=0;i<bodies.length;i++){
    var tb=bodies[i], names=tb.getAttribute('data-g'); tb.removeAttribute('data-g');
    if(!names) continue;
    names.split('|').forEach(function(g){
      var src=document.getElementById(ID('g',g)); if(!src) return;
      var rows=src.querySelectorAll('tbody tr');
      for(var j=0;j<rows.length;j++){
        var tr=rows[j].cloneNode(true), td=document.createElement('td');
        td.className='fr';
        td.innerHTML='<a href="#'+ID('g',g)+'">'+E(g)+'</a>';
        tr.insertBefore(td,tr.children[2]);
        tb.appendChild(tr);
      }
    });
  }
}
function paramBlock(pid,depth){
  var p=D.params[pid]; if(!p) return '';
  var kids=(p.params||[]).map(function(k){var q=D.params[k];
    return '<a class="ref" href="#" data-p="'+E(k)+'"><code>&lt;'+E(q?q.name:k)+'&gt;</code></a>';}).join(' ');
  return '<section class="shared" id="'+ID('p',pid)+'">'+
    '<h3>&lt;'+E(p.name)+'&gt;'+(p.recursive?' <span class="tag">nests itself</span>':'')+'</h3>'+
    (p.doc?'<p>'+E(p.doc)+'</p>':'')+
    (p.v?vline(p):'')+
    table(p.attrs,p.groups)+
    (kids?'<p>Can contain: '+kids+'</p>':'')+'</section>';
}
function card(name){
  var c=D.commands[name]; if(!c) return '';
  var own=Object.keys(c.attrs||{}).length;
  var out=[];
  out.push('<p class="d">'+E(c.doc||'No description in the schema.')+'</p>');
  var meta=[c.kind, 'in '+c.in.join(' and '), 'declared in <code>'+E(c.declaredIn)+'</code>'];
  if(c.src&&c.src.file) meta.push('<code>'+E(c.src.file)+':'+c.src.line+'</code>');
  if(c.body) meta.push('contains nested <code>&lt;'+E(c.body==='action'?'actions':'conditions')+'&gt;</code>');
  out.push('<p class="meta">'+meta.join(' &middot; ')+'</p>');
  out.push(vline(c));
  // The skeleton is filled in after hydrate(), which is when the group attributes -
  // and so the full set of required ones - are actually in the table.
  out.push('<p class="copyrow"><button class="copy" type="button" data-copy="'+E(name)+'">Copy name</button>'+
    '<button class="copy skel" type="button">Copy element</button>'+
    '<button class="copy" type="button" data-copy-link="#'+ID('c',name)+'">Copy link</button></p>');

  var tot=own,gs=(c.groups||[]).filter(function(g){return D.groups[g];});
  gs.forEach(function(g){tot+=D.groups[g]||0;});
  if(tot){
    var from=gs.length?' <span class="cnt">&middot; '+own+' of its own, plus '+gs.map(function(g){
      return '<a href="#'+ID('g',g)+'">'+E(g)+'</a> '+(D.groups[g]||0);}).join(', ')+'</span>':'';
    out.push('<h4>Attributes <span class="cnt">'+tot+'</span>'+from+'</h4>'+table(c.attrs,c.groups));
  }
  if((c.params||[]).length){
    out.push('<h4>Child elements <span class="cnt">'+c.params.length+'</span></h4>'+
      c.params.map(function(p){return paramBlock(p,1);}).join(''));
  }
  return '<div class="card">'+out.join('')+'</div>';
}

// A pasteable element: the command with every required attribute, its own and its
// groups'. Read off the assembled table rather than the payload, because that is the
// only place the group attributes exist once hydrate() has cloned them in.
function skeleton(row){
  var name=row.dataset.n,c=D.commands[name]||{},req=[];
  var tb=row.querySelector('.card > h4 + table.at tbody')||row.querySelector('.card table.at tbody');
  if(tb){var trs=tb.children;
    for(var i=0;i<trs.length;i++){
      if(!trs[i].querySelector('.req'))continue;
      var cell=trs[i].querySelector('td.n code');
      if(cell&&req.indexOf(cell.textContent)<0)req.push(cell.textContent);}}
  var open='<'+name+req.map(function(a){return ' '+a+'=""';}).join('');
  return c.body?open+'>\\n  \\n</'+name+'>':open+' />';
}

var list=document.querySelector('.list');
function open(row,scroll){
  if(!row) return;
  if(!row.classList.contains('open')){
    if(!row.querySelector('.card')){
      row.insertAdjacentHTML('beforeend',card(row.dataset.n));hydrate(row);
      var sk=row.querySelector('button.skel');if(sk)sk.dataset.copy=skeleton(row);
    }
    row.classList.add('open');
  }
  if(scroll) row.scrollIntoView({block:'start'});
}
list.addEventListener('click',function(e){
  var ref=e.target.closest('a[data-p]');
  if(ref){e.preventDefault();
    var host=ref.closest('.card');
    if(host&&!host.querySelector('#'+CSS.escape(ID('p',ref.dataset.p)))){host.insertAdjacentHTML('beforeend',paramBlock(ref.dataset.p,2));hydrate(host);}
    var t=document.getElementById(ID('p',ref.dataset.p)); if(t) t.scrollIntoView({block:'center'});
    return;}
  var hd=e.target.closest('.hd'); if(!hd) return;
  var row=hd.parentElement;
  if(row.classList.contains('open')) row.classList.remove('open'); else open(row,false);
});

var q=document.getElementById('q'),fk=document.getElementById('fk'),fs=document.getElementById('fs'),fv=document.getElementById('fv'),
    n=document.getElementById('n'),rows=Array.prototype.slice.call(list.children);
function apply(){
  var text=q.value.trim().toLowerCase(),k=fk.value,s=fs.value,v=fv.value,shown=0;
  for(var i=0;i<rows.length;i++){var r=rows[i],f=r.dataset.f;
    var ok=(!k||f.indexOf(k)>=0)&&(!s||f.indexOf(s)>=0)&&(!v||f.indexOf(v)>=0)&&(!text||r.dataset.h.indexOf(text)>=0);
    r.classList.toggle('hide',!ok); if(ok) shown++;}
  n.textContent=shown+' of '+rows.length;
}
var timer;
q.addEventListener('input',function(){clearTimeout(timer);timer=setTimeout(apply,120);});
fk.addEventListener('change',apply);fs.addEventListener('change',apply);fv.addEventListener('change',apply);
document.getElementById('reset').addEventListener('click',function(){q.value='';fk.value='';fs.value='';fv.value=NEW;apply();});
fv.value=NEW;apply();

// A deep link has to survive the default version filter and open its card.
function jump(){
  var h=location.hash.slice(1); if(!h) return;
  var el=document.getElementById(h); if(!el) return;
  if(el.classList.contains('row')){
    if(el.classList.contains('hide')){q.value='';fk.value='';fs.value='';fv.value='';apply();}
    open(el,true);
  }
}
window.addEventListener('hashchange',jump);jump();
`;

// The same section reference build.js puts on an authored page, joined by hand because this
// page is generated outside it. Segments are the wiki's URL path; the name is its title.
const WIKI_SEGS = ['X4 Foundations Wiki', 'Modding Support', 'ScriptingMD'];
const WIKI_NAME = 'Scripting/MD/Libraries/Map';

const body = `<h1>Script commands</h1>
${wikiRef(WIKI_SEGS, WIKI_NAME)}
<p class="lead">Every action and condition the Mission Director and AI script schemas accept, with its attributes,
the attribute groups it pulls in and the child elements it can contain. Generated from the schemas that ship with
the game, for ${VERSIONS.join(' and ')}.</p>
<p class="counts">${counts.action} actions and ${counts.condition} conditions, over ${counts.groups} attribute groups,
${counts.params} child elements and ${counts.types} types.</p>

<div class="dl">
<a class="btn" href="#commands">Browse</a>
<p>Open a command to see its full card: own attributes, the groups it inherits and every child element it accepts.
The shared halves - attribute groups and types - are listed once, further down, and every card links into them.</p>
</div>

<details class="box"><summary>How to read a row</summary>
<table>
<tr><th>Kind</th><td><span class="tag act">action</span> does something;
<span class="tag">condition</span> is tested by one. The chip beside it is which schema accepts the command:
<code>both</code>, <code>AI</code> for AI scripts only, <code>MD</code> for the Mission Director only.</td></tr>
<tr><th>Game versions</th><td><b class="t-ok">all</b> in every version covered here (${VERSIONS.join(', ')}).<br>
<b class="t-new">${esc('≥ ' + NEWEST)}</b> from that version onwards, so new since the one before it.<br>
<b class="t-gone">${esc('≤ ' + VERSIONS[0])}</b> up to that version, and gone in the next.<br>
A version list instead of a range means presence with a hole in it, which no range states honestly.</td></tr>
<tr><th>Attributes</th><td>A card lists the command's own attributes first, then everything its attribute
groups bring in, with the group named in the <b>From</b> column. <span class="req">*</span> marks a required
attribute. A number beside a type is how many values the schema fixes for it.</td></tr>
<tr><th>Copying</th><td><b>Copy element</b> gives the command with every required attribute, ready to paste
into a script. <b>Copy link</b> gives a URL that reopens this card, filters and all.</td></tr>
</table></details>

<h2 id="commands">Commands</h2>
<div class="bar">
<input id="q" type="search" placeholder="Search name and description" aria-label="Search commands">
<select id="fk" aria-label="Kind"><option value="">Any kind</option><option value="action">Actions</option><option value="condition">Conditions</option></select>
<select id="fs" aria-label="Schema"><option value="">Both schemas</option><option value="aiscripts">AI scripts</option><option value="md">Mission Director</option></select>
<select id="fv" aria-label="Version">${['<option value="">Any version</option>', ...VERSIONS.map((v) => `<option value="${tokenOf(v)}">${esc(v)}</option>`), `<option value="new">New in ${esc(NEWEST)}</option>`].join('')}</select>
<button id="reset" type="button">Reset</button>
<span class="n" id="n"></span>
</div>
<div class="list">
${rows}
</div>

<h2 id="groups">Attribute groups</h2>
<p>An attribute group is the schema's own unit of reuse. <code>find</code> is 89 attributes shared by 19 commands,
<code>action</code> is 3 attributes shared by over 700, so each is documented here once and referenced from the cards above.</p>
${groupCards}

<h2 id="types">Types</h2>
<p>The named types the attributes above are declared with, with their allowed values where the schema fixes them.</p>
${typeCards}

<script id="data" type="application/json">${JSON.stringify(payload).replace(/</g, '\\u003c')}</script>`;

const html = shell({
  title: 'Script commands',
  description: `Every action and condition in the X4: Foundations Mission Director and AI script schemas, with all attributes expanded, for ${VERSIONS.join(' and ')}.`,
  trail: [
    { label: 'Home', href: '/' },
    { label: 'For X4: Foundations', href: '/x4/' },
    { label: 'Modding Support', href: '/x4/modding-support/' },
    { label: 'Scripting/MD/Libraries/Map', href: '/x4/modding-support/scripting-md-libraries-map/' },
    { label: 'Script commands', href: URL },
  ],
  body,
  css: CSS,
  js: JS,
});

fs.mkdirSync(path.dirname(OUT), { recursive: true });
fs.writeFileSync(OUT, html, 'utf8');
console.log('wrote ' + OUT + ' (' + (fs.statSync(OUT).size / 1024).toFixed(0) + ' KB)');
