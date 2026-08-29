// Builds the site: every src/content/**/*.md becomes _site/<url>/index.html.
//
//   node src/build.js
//
// The generated Lua Globals Reference is not built here - src/globals/build-html.js
// writes that page. It appears in navigation through a stub .md carrying only front
// matter and `generated: true`.

const fs = require('fs');
const path = require('path');
const MarkdownIt = require('markdown-it');

const { shell, esc, wikiRef } = require('./layout.js');

const ROOT = __dirname;
const CONTENT = path.join(ROOT, 'content');
const OUT = path.join(ROOT, '..', '_site');

/* ------------------------------------------------------------------ pages */

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
  };
});

const byUrl = new Map(pages.map((p) => [p.url, p]));
const byTitle = new Map(pages.map((p) => [p.title, p]));

const parentUrl = (p) => p.segs.length ? '/' + p.segs.slice(0, -1).join('/') + (p.segs.length > 1 ? '/' : '') : null;
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

function trailFor(p) {
  const out = [];
  for (let i = 0; i < p.segs.length; i++) {
    const url = '/' + p.segs.slice(0, i + 1).join('/') + '/';
    const page = byUrl.get(url);
    out.push({ label: page ? page.title : p.segs[i], href: url });
  }
  return out.length ? [{ label: 'Home', href: '/' }, ...out] : [];
}

/* -------------------------------------------------------------- markdown */

const md = new MarkdownIt({ html: true, linkify: true, typographer: false });

const slug = (s) => s.toLowerCase().replace(/<[^>]*>/g, '').replace(/[^\w\s-]/g, '')
  .trim().replace(/\s+/g, '-');

// Headings get a stable id so a deep link into a guide keeps working.
const headings = [];
md.renderer.rules.heading_open = (tokens, i) => {
  const tag = tokens[i].tag, inline = tokens[i + 1];
  const text = inline.content;
  let id = slug(text), n = 2;
  while (headings.some((h) => h.id === id)) id = slug(text) + '-' + n++;
  headings.push({ id, text, level: Number(tag[1]) });
  return `<${tag} id="${id}">`;
};

// A wide table must scroll inside its own box, never the page body.
md.renderer.rules.table_open = () => '<div class="tw"><table>';
md.renderer.rules.table_close = () => '</table></div>';

// The guides link by wiki page name - [Lua Globals Reference](<Lua Globals Reference>).
// Resolve those against the page titles; leave real URLs alone.
const defaultLink = md.renderer.rules.link_open ||
  ((t, i, o, e, s) => s.renderToken(t, i, o));
md.renderer.rules.link_open = (tokens, i, opts, env, self) => {
  const href = tokens[i].attrGet('href') || '';
  if (!/^([a-z]+:|\/|#)/i.test(href)) {
    const target = byTitle.get(decodeURIComponent(href));
    if (target) tokens[i].attrSet('href', target.url);
    else env.unresolved.push(href);
  }
  return defaultLink(tokens, i, opts, env, self);
};

// Only headings that come after the marker, so the "Contents" section the toc sits
// inside never lists itself.
function toc(list, html, at) {
  const items = list.filter((h) =>
    (h.level === 2 || h.level === 3) && html.indexOf(`id="${h.id}"`) > at);
  if (!items.length) return '';
  const link = (h) => `<a href="#${h.id}">${esc(h.text)}</a>`;

  // An h3 nests inside the h2 it belongs to, so the hierarchy is the markup rather
  // than an indent that survives nothing.
  const groups = [];
  for (const h of items) {
    if (h.level === 2 || !groups.length) groups.push({ h, kids: [] });
    else groups[groups.length - 1].kids.push(h);
  }
  return '<ul class="toc">' + groups.map(({ h, kids }) => `<li>${link(h)}` +
    (kids.length ? '<ul>' + kids.map((k) => `<li>${link(k)}</li>`).join('') + '</ul>' : '') +
    '</li>').join('') + '</ul>';
}

// One column, and a box that shrinks to its longest entry. Two columns broke a section
// away from its own subsections and left the halves an arm's length apart.
const TOC_CSS = `
ul.toc{list-style:none;display:inline-block;max-width:100%;margin:.7em 0;
  padding:11px 20px 12px;border:1px solid var(--line);border-radius:8px;background:var(--soft)}
ul.toc li{padding:.17em 0}
ul.toc a{text-decoration:none}
ul.toc a:hover{text-decoration:underline}
ul.toc ul{list-style:none;margin:.15em 0 .3em .3em;padding:0 0 0 1.1em;
  border-left:1px solid var(--line)}
ul.toc ul li{font-size:.94em}
ul.toc ul a{color:var(--dim)}
ul.toc ul a:hover{color:var(--acc)}
`;

/* ----------------------------------------------------------------- build */

const cardList = (kids) => kids.length
  ? '<ul class="cards">' + kids.map((c) =>
    `<li><a href="${c.url}">${esc(c.title)}</a>${c.description ? `<p>${esc(c.description)}</p>` : ''}</li>`)
    .join('') + '</ul>'
  : '';

let written = 0;
const unresolvedAll = [];

for (const p of pages) {
  if (p.generated) continue;

  headings.length = 0;
  const env = { unresolved: [] };
  let html = md.render(p.body, env);

  // {{children}} expands to the section's child pages, so an index page never
  // hand-maintains a list of what sits under it.
  html = html.replace(/<p>\{\{children\}\}<\/p>/g, cardList(childrenOf(p)));
  // The editing-copy note and the XWiki toc macro are both source-only markers.
  html = html.replace(/<!--\s*Editing copy[\s\S]*?-->\s*/g, '');
  html = html.replace(/<!--\s*xwiki:\s*toc[^>]*-->/g, (m, at) => toc(headings, html, at));

  // Under the page title, so the way out to the wiki is visible before the content.
  const wiki = wikiRef(wikiSegsFor(p), p.wikiName || p.wiki);
  if (wiki) html = html.replace('</h1>', () => '</h1>\n' + wiki);

  if (env.unresolved.length) unresolvedAll.push({ page: p.url, links: env.unresolved });

  const file = path.join(OUT, ...p.segs, 'index.html');
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, shell({
    title: p.title,
    description: p.description,
    trail: trailFor(p),
    body: html,
    css: TOC_CSS,
  }), 'utf8');
  written++;
}

console.log(`${written} markdown pages -> ${path.relative(process.cwd(), OUT)}`);
for (const p of pages.filter((x) => x.generated)) console.log(`  (generated elsewhere: ${p.url})`);
if (unresolvedAll.length) {
  console.log('\nunresolved links:');
  for (const u of unresolvedAll) console.log(`  ${u.page}  ->  ${u.links.join(', ')}`);
  process.exitCode = 1;
} else {
  console.log('all internal links resolve');
}
