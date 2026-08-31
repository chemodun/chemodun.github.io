// The site's page model, and the navigation panel every page carries.
//
// Two trees are merged into one. This site's pages come from src/content/**/*.md, and
// the Egosoft wiki's Modding Support branch comes from the committed snapshot in
// src/wiki/tree.json. A section that exists in both places is one row, not two: the
// site page's `wiki:` front matter names its segment over there, so the merge key is
// already written down and a rename on either side is one edit.
//
// A row says where it can be read - `local` for a page on this site, `Egosoft` for one
// that only exists on the wiki, both chips where the section is in both places. The
// point of showing the wiki's pages at all is that a reader looking for something this
// site does not carry should see that it exists, rather than conclude it does not.
//
// The page model lives here rather than in build.js because the three generated
// references are separate processes that render through the same shell and so need the
// same tree; build.js consumes what this exports.

const fs = require('fs');
const path = require('path');

const { esc, wikiUrl } = require('./layout.js');
const tree = require('./wiki/tree.json');

const CONTENT = path.join(__dirname, 'content');

/* ------------------------------------------------------------- site pages */

// Minimal front matter: `key: value` lines between --- fences. No YAML needed.
function frontMatter(text) {
  const m = /^---\r?\n([\s\S]*?)\r?\n---\r?\n?/.exec(text);
  if (!m) return { data: {}, body: text };
  const data = {};
  for (const line of m[1].split(/\r?\n/)) {
    const kv = /^([A-Za-z_][\w-]*)\s*:\s*(.*)$/.exec(line.trim());
    if (kv) data[kv[1]] = kv[2].replace(/^["']|["']$/g, '');
  }
  return { data, body: text.slice(m[0].length) };
}

function walk(dir, acc = []) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) walk(p, acc);
    else if (e.name.endsWith('.md')) acc.push(p);
  }
  return acc;
}

const pages = walk(CONTENT).map((file) => {
  const { data, body } = frontMatter(fs.readFileSync(file, 'utf8'));
  const rel = path.relative(CONTENT, file).split(path.sep).join('/');
  const segs = rel.replace(/\.md$/, '').split('/').filter((s) => s !== 'index');
  return {
    file, body, segs,
    url: segs.length ? '/' + segs.join('/') + '/' : '/',
    title: data.title || segs[segs.length - 1] || 'Home',
    description: data.description || '',
    order: Number(data.order || 100),
    generated: data.generated === 'true',
    wiki: data.wiki || '',
    wikiName: data.wikiName || '',
    wikiPath: data.wikiPath || '',
  };
});

const byUrl = new Map(pages.map((p) => [p.url, p]));

const childrenOf = (p) => pages
  .filter((c) => c !== p && c.segs.length === p.segs.length + 1 && c.url.startsWith(p.url))
  .sort((a, b) => a.order - b.order || a.title.localeCompare(b.title));

// A section names only its own segment on the Egosoft wiki; the rest is inherited from
// its parents, so a rename over there is one edit here. Only sections carry one: the
// wiki's own tree is what a reader follows for anything more, not a single document.
function wikiSegsFor(p) {
  if (!p.wiki) return [];
  const segs = [];
  for (let i = 0; i <= p.segs.length; i++) {
    const anc = byUrl.get(i ? '/' + p.segs.slice(0, i).join('/') + '/' : '/');
    if (anc && anc.wiki) segs.push(...anc.wiki.split('/').filter(Boolean));
  }
  return segs;
}

/* ------------------------------------------------------------- the merge */

// The key both trees are joined on: a wiki path below the wiki's own root, so
// "Modding Support/UI Modding support". null means the page claims nothing on the
// wiki; the empty string is the wiki's root itself, which /x4/ does claim.
//
// A document names its whole path in `wikiPath` where it has one, because only
// sections inherit segments from their parents - see wikiSegsFor.
function wikiKeyFor(p) {
  if (p.wikiPath) return p.wikiPath.replace(/^\/+|\/+$/g, '');
  const segs = wikiSegsFor(p);
  if (!segs.length) return null;
  return (segs[0] === tree.root ? segs.slice(1) : segs).join('/');
}

const wikiIndex = new Map(
  [...tree.pages, ...tree.branches].map((w) => [w.segs.join('/'), w]));

// The wiki's own root, under the empty key. The snapshot does not list it - it is the
// thing the paths are relative to - but /x4/ claims it, and a section that is on the
// wiki has to be marked as being on the wiki whether or not it was crawled.
wikiIndex.set('', { segs: [], title: tree.root });

const wikiChildren = (key) => [...wikiIndex.values()]
  .filter((w) => w.segs.slice(0, -1).join('/') === key && w.segs.join('/') !== key);

// Order, then title - the same rule the card lists on the pages themselves use, so the
// panel and the page body never disagree about what comes first. Only site pages
// declare an order, so a section written here leads and the wiki's own sections follow
// in the wiki's alphabetical order.
const inOrder = (nodes) => nodes.sort((a, b) => a.order - b.order || a.title.localeCompare(b.title));

const WIKI_ONLY = 100;

function wikiNode(w) {
  return {
    title: w.title,
    href: wikiUrl([tree.root, ...w.segs]),
    external: true,
    kind: 'wiki',
    order: WIKI_ONLY,
    kids: inOrder(wikiChildren(w.segs.join('/')).map(wikiNode)),
  };
}

function siteNode(p) {
  const key = wikiKeyFor(p);
  const kids = childrenOf(p).map(siteNode);

  // Anything the wiki has under this section that no page here already stands for.
  // Matched on the key rather than the title: ScriptingMD is titled
  // Scripting/MD/Libraries/Map, and the site's own segment is a third spelling again.
  if (key !== null) {
    const covered = new Set(childrenOf(p).map(wikiKeyFor).filter((k) => k !== null));
    for (const w of wikiChildren(key)) {
      if (!covered.has(w.segs.join('/'))) kids.push(wikiNode(w));
    }
  }

  return {
    title: p.title,
    href: p.url,
    kind: key !== null && wikiIndex.has(key) ? 'both' : 'local',
    order: p.order,
    kids: inOrder(kids),
  };
}

const roots = () => inOrder(childrenOf(byUrl.get('/')).map(siteNode));

/* ------------------------------------------------------------- rendering */

// One chip, and the colour answers the only question a reader has in a hurry: green
// means it can be read here, grey means following this row leaves the site. The word
// then separates a page of this site's own from one the wiki also carries. Two chips
// on a row was tried first and cost so much of the panel's width that titles wrapped
// to three lines; the exact meaning is a tooltip instead, as it is on the references'
// own column legend.
const CHIPS = {
  local: ['ok', 'local', 'on this site'],
  both: ['ok', 'both', 'on this site and on the Egosoft wiki'],
  wiki: ['no', 'Egosoft', 'on the Egosoft wiki only'],
};

// The chips sit in their own column at the right of the row rather than after the
// title, because a title long enough to wrap - and half of the wiki's are - otherwise
// pushes its chip alone onto a second line and the panel turns to rubble.
const chips = (kind) => {
  const chip = CHIPS[kind];
  return chip
    ? `<span class="mk"><b class="nb t-${chip[0]}" title="${esc(chip[2])}">${chip[1]}</b></span>`
    : '';
};

const has = (node, url) => node.href === url
  || node.kids.some((k) => has(k, url));

function row(node, url, depth) {
  const here = !node.external && node.href === url;
  const cls = [here ? 'here' : '', node.external ? 'ext' : ''].filter(Boolean).join(' ');
  // A slash is a word boundary here: Scripting/MD/Libraries/Map is one unbreakable
  // token to a browser, and in a column this narrow it broke mid-word instead.
  const label = esc(node.title).replace(/\//g, '/<wbr>');
  const link = `<a href="${esc(node.href)}"${cls ? ` class="${cls}"` : ''}`
    + `${here ? ' aria-current="page"' : ''}>${label}</a>${chips(node.kind)}`;

  // The section holding the current page is open and nothing else is, so a panel of 30
  // rows arrives as the handful around where the reader is. <details> does it without
  // script, and keeps working when the script is what broke.
  // The top of the tree is always open: on the home page nothing is current, and a
  // panel whose whole content is one folded row is not navigation.
  if (!node.kids.length) return `<li class="leaf">${link}</li>`;
  const open = depth === 0 || has(node, url) ? ' open' : '';
  return `<li><details${open}><summary>${link}</summary>`
    + list(node.kids, url, depth + 1) + '</details></li>';
}

const list = (nodes, url, depth = 0) => '<ul>'
  + nodes.map((n) => row(n, url, depth)).join('') + '</ul>';

// Home is the one row with no chip: which site it is on is not in question.
function navHtml(url = '') {
  return '<nav class="side" id="side" aria-label="Site navigation">'
    + `<ul><li class="leaf"><a href="/"${url === '/' ? ' class="here" aria-current="page"' : ''}>`
    + 'Home</a></li></ul>'
    + list(roots(), url)
    + '</nav>';
}

module.exports = { pages, byUrl, childrenOf, wikiSegsFor, wikiKeyFor, frontMatter, navHtml };
