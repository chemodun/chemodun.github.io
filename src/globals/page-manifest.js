// The wiki page set, computed from classification.json. Decided 2026-08-25/26.
//
//   node page-manifest.js        prints the page list and verifies the partition
//   require('./page-manifest')   returns { pages, byId, WIKI }
//
// Split rules, in the order they apply:
//   1. one master index listing every global - this is the parent page itself
//   2. globals DEFINED IN LUA get their own pages, by where they are defined
//      (widget_fullscreen / addons / core)
//   3. ENGINE globals split alphabetically by first letter, but only once the
//      set is bigger than MAX_PER_PAGE - the 7 engine variables are one page,
//      not seven pages of one
//   4. a letter over MAX_PER_PAGE is divided on prefix boundaries, never
//      mid-prefix, so a name family never straddles two pages
//   5. variables and functions are always separate pages
//   6. a page with no members is not created at all
//
// Page NAME is the URL segment on the wiki and has to survive globals being
// added or removed, so a page is named by its section number within its group,
// never by the name range it holds today. Every engine letter is numbered even
// when it needs one page: growing past the cap then only adds Section 02.
// The range each page covers is reported from `first`/`last` - as a subtitle on
// the page and in the Covers column of the index - and is regenerated freely.
//
// Layout on every page is variant B: an index table, then one detail card each.

const fs = require('fs');
const path = require('path');

const MAX_PER_PAGE = 30;
// A page may run this far over rather than shed a stub page: N is 31 names, and
// its only prefix boundary is NewGame | Notify*, so splitting it costs a 1-entry page.
const OVER = 4;
const DATA = JSON.parse(fs.readFileSync(path.join(__dirname, 'classification.json'), 'utf8'));

// The wiki hierarchy. Every content page is a direct child of the parent, so a
// child reaches the index with `../` and the index reaches a child by name.
const WIKI = {
  space: 'X4 Foundations Wiki/Modding Support/UI Modding support',
  parent: 'Lua Globals Reference',
  renamedFrom: 'Lua function overview',
};

const names = Object.keys(DATA).sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()));
// group is 'function' or 'variable' - variables cover table, userdata, string
// and boolean, which the measured data distinguishes and globals.lua does not.
const of = (origin, group) => names.filter(n => DATA[n].origin === origin && DATA[n].group === group);

/* ------------------------------------------------- prefix-range splitting */

const key = (n, d) => n.slice(0, d).toLowerCase();

// The list is sorted case-insensitively, so equal keys are always contiguous.
function bucketsAt(list, d) {
  const out = [];
  let cur = null;
  for (const n of list) {
    const k = key(n, d);
    if (!cur || cur.k !== k) out.push(cur = { k, label: n.slice(0, d), members: [] });
    cur.members.push(n);
  }
  return out;
}

function packWith(buckets, cap) {
  const pages = [];
  let cur = [], size = 0;
  for (const b of buckets) {
    if (size && size + b.members.length > cap) { pages.push(cur); cur = []; size = 0; }
    cur.push(b);
    size += b.members.length;
  }
  if (cur.length) pages.push(cur);
  return pages;
}

// Fewest pages, then the most even split that still reaches that count, so a
// letter of 54 becomes 27 + 27 rather than 30 + 24.
function packBalanced(buckets, total) {
  const min = Math.ceil(total / MAX_PER_PAGE);
  for (let cap = Math.ceil(total / min); cap <= MAX_PER_PAGE; cap++) {
    const p = packWith(buckets, cap);
    if (p.length <= min) return p;
  }
  return packWith(buckets, MAX_PER_PAGE);
}

// The shallowest prefix depth that both fills every page reasonably and needs
// no extra page. Depth is how coarse a boundary a cut may land on, so shallow
// is worth a ragged split; only a depth that leaves a stub page is rejected.
const MIN_PAGE = Math.floor(MAX_PER_PAGE / 2);

function bestParts(list) {
  const want = Math.ceil(list.length / MAX_PER_PAGE);
  let best = null;
  for (let d = 1; d <= 16; d++) {
    const bs = bucketsAt(list, d);
    if (Math.max(...bs.map(b => b.members.length)) > MAX_PER_PAGE) continue;
    const parts = packBalanced(bs, list.length);
    if (parts.length > want) continue;
    const smallest = Math.min(...parts.map(p => p.reduce((s, b) => s + b.members.length, 0)));
    if (smallest >= MIN_PAGE) return parts;
    if (!best || smallest > best.smallest) best = { parts, smallest };
    if (bs.length === list.length) break;
  }
  return best ? best.parts : packWith(bucketsAt(list, 16), MAX_PER_PAGE);
}

// Split a list into pages, cutting only on a prefix boundary so a name family
// stays on one page. The pages are numbered, so where the cut lands changes
// what a page holds but never what it is called.
function prefixSplit(list) {
  if (list.length <= MAX_PER_PAGE + OVER) return [list];
  return bestParts(list).map(bs => bs.flatMap(b => b.members));
}

const slug = (s) => s.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');

const pages = [];

// name = URL segment, displayed title and index link label, all the same text.
// section 0 means the group is one page and needs no number.
function addPage(base, members, section, extra) {
  const name = section ? base + ' Section ' + String(section).padStart(2, '0') : base;
  pages.push(Object.assign({
    id: slug(name),
    name,
    heading: name,
    members,
    first: members[0],
    last: members[members.length - 1],
  }, extra));
}

/* --------------------------------------------------------------- pages */

pages.push({
  id: 'index',
  name: WIKI.parent,
  heading: WIKI.parent,
  kind: 'index',
  members: names,
  desc: 'Every global, one row each: name, origin, availability, versions, summary. Each name links to its detail page.',
});

// -- defined in Lua, by environment ----------------------------------------

const LUA_ENVS = [
  ['widget', 'Widget Fullscreen', 'Published from ui/widget/lua/widget_fullscreen.lua, either with AddGlobalAccess or as a plain top-level definition. That file runs in the addons Lua environment itself, so these are reachable from addon code directly.'],
  ['addon',  'Addon',             'Defined by a ui/addons file, which leaks it into the shared addons Lua environment. Monkey-patchable by any addon that loads later.'],
  ['core',   'Core',              'Defined by a ui/core HUD file. The core Lua environment is separate: these nine are the only globals an addon cannot reach.'],
];

for (const [origin, label, desc] of LUA_ENVS) {
  for (const [group, plural] of [['function', 'Functions'], ['variable', 'Variables']]) {
    const members = of(origin, group);
    if (!members.length) continue;  // rule 6 - no empty pages on the wiki
    const parts = prefixSplit(members);
    parts.forEach((part, i) => addPage(label + ' ' + plural, part,
      parts.length > 1 ? i + 1 : 0, { group, origin, desc }));
  }
}

// -- engine, alphabetical ---------------------------------------------------

for (const [group, plural] of [['function', 'Functions'], ['variable', 'Variables']]) {
  const all = of('engine', group);
  if (!all.length) continue;
  const base = 'Engine ' + plural;

  // Small enough to keep whole: one page, no alphabetical split.
  if (all.length <= MAX_PER_PAGE) {
    addPage(base, all, 0, {
      group, origin: 'engine',
      desc: 'Every engine-injected ' + plural.toLowerCase().replace(/s$/, '') + ', in one page.',
    });
    continue;
  }

  const byLetter = new Map();
  for (const n of all) {
    const L = n[0].toUpperCase();
    if (!byLetter.has(L)) byLetter.set(L, []);
    byLetter.get(L).push(n);
  }

  for (const L of [...byLetter.keys()].sort()) {
    const parts = prefixSplit(byLetter.get(L));
    // Numbered even when the letter needs only one page, so outgrowing it later
    // adds "Section 02" instead of renaming "Engine Functions A".
    parts.forEach((part, i) => addPage(base + ' ' + L, part, i + 1, {
      group, origin: 'engine', letter: L,
      desc: 'Engine-injected globals beginning with ' + L + '.',
    }));
  }
}

const byId = Object.fromEntries(pages.map(p => [p.id, p]));

module.exports = { MAX_PER_PAGE, WIKI, pages, byId, DATA, names };

/* ------------------------------------------------------------- report */

if (require.main === module) {
  let content = 0;
  const seen = new Set(), dup = [];
  console.log(WIKI.space + '/' + WIKI.parent + '/\n');
  for (const p of pages) {
    if (p.kind === 'index') continue;
    content += p.members.length;
    for (const n of p.members) { if (seen.has(n)) dup.push(n); seen.add(n); }
    console.log(String(p.members.length).padStart(4), p.name.padEnd(34), p.first + ' to ' + p.last);
  }
  const missing = names.filter(n => !seen.has(n));
  const dupName = pages.length - new Set(pages.map(p => p.name)).size;
  console.log('\n' + pages.length + ' pages (1 index + ' + (pages.length - 1) + ' content)');
  console.log('assigned ' + content + ' of ' + names.length);
  console.log('unassigned:      ' + (missing.length ? missing.join(', ') : 'none'));
  console.log('double-assigned: ' + (dup.length ? dup.join(', ') : 'none'));
  console.log('duplicate names: ' + (dupName || 'none'));
  const over = pages.filter(p => p.kind !== 'index' && p.members.length > MAX_PER_PAGE + OVER);
  console.log('over ' + (MAX_PER_PAGE + OVER) + ' per page:  ' + (over.length ? over.map(p => p.name + '=' + p.members.length).join(', ') : 'none'));
}
