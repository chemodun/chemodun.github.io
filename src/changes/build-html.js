'use strict';

// Builds the Changes page.
//
//   node build-html.js                 -> _site/x4/changes/
//   OUT=path/to/index.html node build-html.js
//
// Two clocks could fill this page. This is the first: the game's own, what changed for
// a mod author between the last two game versions the references cover. It is a pure
// function of committed data, so it is generated rather than written and cannot fall
// behind the references it summarises. sources.js does the reading; this renders it.
//
// Order is deliberate. Removals first, because that is the half that breaks a mod that
// already works; then names that stayed and changed shape; then additions. A reader
// arriving after a game update wants them in exactly that order.
//
// Every name on the page is a deep link into the reference that owns it, and an anchor
// that does not exist over there is a silent dead link. So this runs last in the build
// and checks each href against the built page, which is how the child-element chips
// that had no anchor at all were caught.

const fs = require('fs');
const path = require('path');

const { shell, esc, wikiUrl } = require('../layout.js');
const { references } = require('./sources.js');

const URL = '/x4/changes/';
const OUT = process.env.OUT ||
  path.join(__dirname, '..', '..', '_site', ...URL.split('/').filter(Boolean), 'index.html');
const SITE_ROOT = path.join(__dirname, '..', '..', '_site');

// Egosoft's own account of what a version changed: prose about behaviour, which this
// page cannot produce and does not try to.
const BREAKING = wikiUrl(['X4 Foundations Wiki', 'Modding Support', 'Breaking Changes']);

const plural = (n, one, many) => `${n} ${n === 1 ? one : many || one + 's'}`;

/* ------------------------------------------------------------ dead links */

// A deep link into a reference is only as good as the anchor at the other end, and
// nothing else on the site would notice it rotting. The references are built before
// this page, so their output is on disk to check against.
function checkAnchors() {
  const bad = [];
  const ids = new Map();
  const idsFor = (url) => {
    if (!ids.has(url)) {
      const file = path.join(SITE_ROOT, ...url.split('/').filter(Boolean), 'index.html');
      if (!fs.existsSync(file)) return null;
      const html = fs.readFileSync(file, 'utf8');
      ids.set(url, new Set([...html.matchAll(/\sid="([^"]+)"/g)].map((m) => m[1])));
    }
    return ids.get(url);
  };
  for (const r of references) {
    const known = idsFor(r.url);
    if (!known) { bad.push(`${r.url} has not been built, so its anchors cannot be checked`); continue; }
    const links = [...r.groups.flatMap((g) => [...g.added, ...g.removed]), ...r.changes];
    for (const l of links) {
      const anchor = l.href.split('#')[1];
      if (!known.has(anchor)) bad.push(`${r.key}: ${l.name} points at #${anchor}, which ${r.url} does not have`);
    }
  }
  return bad;
}

/* ------------------------------------------------------------ components */

// Prose out of the references is plain text with backticked code spans, the convention
// globals.lua and every description on the site already use.
const prose = (s) => esc(s).replace(/`([^`]+)`/g, (_, t) => `<code>${t}</code>`);

const chip = (i) => `<a href="${esc(i.href)}"${i.title ? ` title="${esc(i.title)}"` : ''}>${esc(i.name)}</a>`;
const chips = (items) => `<div class="chips">${items.map(chip).join('')}</div>`;

// The version pair a reference's delta is taken between. UIX ships on its own releases,
// so its pair is not the game's and the page says so wherever it shows one.
const span = (r) => `${r.from} to ${r.to}` + (r.clock === 'mod' ? ', the mod’s own releases' : '');

const delta = (n, tone) => (n ? `<b class="t-${tone}">${tone === 'gone' ? '−' : '+'}${n}</b>` : '<span class="z">0</span>');

function summaryTable() {
  const rows = [];
  for (const r of references) {
    r.groups.forEach((g, i) => {
      const head = i === 0
        ? `<th rowspan="${r.groups.length}" scope="rowgroup"><a href="${esc(r.url)}">${esc(r.title)}</a>` +
          `<span class="ver">${esc(span(r))}</span></th>`
        : '';
      rows.push(`<tr>${head}<td>${esc(g.label)}</td>` +
        `<td class="num">${g.from}</td><td class="num">${g.to}</td>` +
        `<td class="num">${delta(g.added.length, 'new')}</td>` +
        `<td class="num">${delta(g.removed.length, 'gone')}</td></tr>`);
    });
  }
  return `<div class="tw"><table class="sum">
<thead><tr><th>Reference</th><th>Counted</th><th class="num">Before</th><th class="num">After</th>
<th class="num">New</th><th class="num">Gone</th></tr></thead>
<tbody>${rows.join('\n')}</tbody></table></div>`;
}

// One reference's contribution to a section, or nothing at all when it has none. The
// heading carries the version pair because the four references do not share one.
function section(pick, label) {
  const out = [];
  for (const r of references) {
    const blocks = r.groups
      .map((g) => ({ g, items: pick(g) }))
      .filter((b) => b.items.length);
    if (!blocks.length) continue;
    out.push(`<h3><a href="${esc(r.url)}">${esc(r.title)}</a> <span class="ver">${esc(span(r))}</span></h3>`);
    for (const b of blocks) {
      out.push(`<p class="cnt">${esc(plural(b.items.length, b.g.singular))} ${label}.</p>`);
      out.push(chips(b.items));
    }
  }
  return out.join('\n');
}

function changedSection() {
  const out = [];
  for (const r of references) {
    if (!r.changes.length) continue;
    out.push(`<h3><a href="${esc(r.url)}">${esc(r.title)}</a> <span class="ver">${esc(span(r))}</span></h3>`);
    out.push('<ul class="chg">' + r.changes.map((c) =>
      `<li><a class="nm t-${c.tone}" href="${esc(c.href)}">${esc(c.name)}</a> ` +
      `<span>${c.html ? c.text : prose(c.text)}</span></li>`).join('\n') + '</ul>');
  }
  return out.join('\n');
}

/* ------------------------------------------------------------------ page */

const count = (pick) => references.reduce((n, r) => n + r.groups.reduce((m, g) => m + pick(g).length, 0), 0);
const gone = count((g) => g.removed);
const added = count((g) => g.added);
const changed = references.reduce((n, r) => n + r.changes.length, 0);

const GAME = references.filter((r) => r.clock !== 'mod');
const FROM = GAME[0].from, TO = GAME[0].to;
const builds = references.find((r) => r.builds) || { builds: {} };

const CSS = `
table.sum th[scope=rowgroup]{vertical-align:middle;background:var(--soft)}
table.sum th a{text-decoration:none;font-weight:600}
table.sum td.num,table.sum th.num{text-align:right;white-space:nowrap;
  font-variant-numeric:tabular-nums}
.ver{display:block;color:var(--dim);font-weight:400;font-size:.82rem;margin-top:.15em}
h3 .ver{display:inline;margin:0 0 0 .5em;font-size:.86rem}
.z{color:var(--dim)}
p.cnt{margin:1.2em 0 .2em;color:var(--dim);font-size:.9rem}
ul.chg{list-style:none;padding:0;margin:.6em 0;display:grid;gap:8px}
ul.chg li{border:1px solid var(--line);border-radius:7px;padding:9px 13px;font-size:.92rem}
ul.chg .nm{font-family:var(--mono);font-weight:700;text-decoration:none;margin-right:.5em}
ul.chg .nm:hover{text-decoration:underline}
ul.chg span{color:var(--dim)}
ul.note{color:var(--dim);font-size:.92rem}
ul.note li{margin:.4em 0}
`;

const body = `<h1>Changes</h1>
<p class="lede">What changed for a mod author between X4 ${esc(FROM)} and ${esc(TO)}, gathered from the
references on this site. Every name here links to its own row in the reference that carries it.</p>

<p class="wikiref">Egosoft's <a href="${esc(BREAKING)}">Breaking Changes</a> on the wiki describes in prose
what a game version changed and why. This page answers the narrower half of that question: which names
moved, counted, each one linked to its own row over here.</p>

<div class="dl">
<a class="btn" href="#gone">${gone} gone</a>
<p>The half that breaks a mod that already works. ${changed} more names are still there and
<a href="#changed">changed shape</a>, and <a href="#new">${added} are new</a>.</p>
</div>

<h2 id="summary">Summary</h2>
${summaryTable()}

<h2 id="gone">Gone in ${esc(TO)}</h2>
<p>Names the newer version no longer has. A script or a UI file that still calls one of these
parses exactly as before and fails at the point of the call.</p>
${section((g) => g.removed, 'gone')}

<h2 id="changed">Still there, changed</h2>
<p>Names both versions have, where something about them moved: an attribute appeared or was
dropped, the engine retired the name, or a Lua state that could not reach it now can.</p>
${changedSection()}

<h2 id="new">New in ${esc(TO)}</h2>
<p>Names the newer version added. Anything here is unavailable to a mod that also has to run on
${esc(FROM)}.</p>
${section((g) => g.added, 'new')}

<h2 id="method">How this page is built</h2>
<p>Nothing on this page is written by hand. Each reference records, per row, which of the versions
it covers has that row; this page is the difference between the last two of them, taken from the
same committed data the references themselves are built from, through the same parsers. It is
rebuilt whenever the site is, so it cannot fall behind a reference, and every link is checked
against the built reference page before the build is allowed to finish.</p>
<ul class="note">
${builds.builds && builds.builds[FROM] && builds.builds[TO]
    ? `<li>The game versions measured are build ${esc(builds.builds[FROM])} for ${esc(FROM)} and build ${esc(builds.builds[TO])} for ${esc(TO)}.</li>`
    : ''}
${references.filter((r) => r.footnote).map((r) =>
      `<li><a href="${esc(r.url)}">${esc(r.title)}</a>: ${r.footnote}</li>`).join('\n')}
<li>What is on this page is what the game changed. It is not a log of edits to this site.</li>
</ul>
`;

const problems = checkAnchors();
if (problems.length) {
  console.error('Changes page: ' + problems.length + ' dead deep link(s)');
  for (const p of problems) console.error('  ' + p);
  process.exit(1);
}

const html = shell({
  title: 'Changes',
  description: `What changed for a mod author between X4: Foundations ${FROM} and ${TO}: ` +
    'every name the game dropped, added or reshaped, gathered from the references on this site.',
  trail: [
    { label: 'Home', href: '/' },
    { label: 'For X4: Foundations', href: '/x4/' },
    { label: 'Changes', href: URL },
  ],
  body,
  css: CSS,
});
fs.mkdirSync(path.dirname(OUT), { recursive: true });
fs.writeFileSync(OUT, html, 'utf8');

console.log('wrote ' + OUT + ' (' + Math.round(html.length / 1024) + ' KB)');
console.log(`${FROM} to ${TO}: ${added} new, ${gone} gone, ${changed} changed, over ` +
  `${references.length} references`);
