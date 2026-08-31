// Fetches the shape of the Egosoft wiki into src/wiki/tree.json, so the navigation
// panel can show what the wiki carries beside what this site carries.
//
//   node src/wiki/fetch-tree.js           rewrite tree.json
//   node src/wiki/fetch-tree.js --check   compare only; exit 1 on drift, write nothing
//
// Only the Modding Support subtree is taken in full - that is the branch this site
// writes into, and the one where knowing what exists over there is worth a reader's
// attention. The other top-level branches are recorded as names alone: 423 of the
// wiki's 542 pages are ship and equipment stats under Manual and Guides, and a
// navigation panel that lists them is an index, not a way around.
//
// The snapshot is committed. The build reads it and never reaches the network, so a
// wiki outage cannot fail a deploy and a wiki rename arrives as a reviewable diff.

const fs = require('fs');
const path = require('path');

const OUT = path.join(__dirname, 'tree.json');

// XWiki's REST search endpoint accepts solr queries from guests; xwql is refused. The
// space_facet field holds every ancestor prefix of a page, so one depth-1 term matches
// the whole subtree under it, at any depth.
const REST = 'https://wiki.egosoft.com/rest/wikis/xwiki/query';
const WIKI_ROOT = 'X4 Foundations Wiki';
const BRANCH = 'Modding Support';
const PAGE_SIZE = 100;               // the endpoint refuses anything over 1000
const MAX_PAGES = 40;                // a stop, in case the cursor never runs out

const query = (q, start) => `${REST}?type=solr&number=${PAGE_SIZE}&start=${start}`
  + `&q=${encodeURIComponent(q)}`;

// The dotted <id> escapes a literal dot in a page name as \. - "Using patchactions\.xml"
// - which is one unescaping bug waiting to happen. The <link> carries the same path as
// URL segments instead, so the segments are read from there and only percent-decoded.
//
//   .../spaces/X4%20Foundations%20Wiki/spaces/Modding%20Support/pages/WebHome
//
// A terminal page need not be a WebHome; where it is not, its own name is the last
// segment. Returns the segments below the wiki root, so the root itself is not repeated
// on every entry.
function segsFromLink(href) {
  const spaces = [...href.matchAll(/\/spaces\/([^/]+)/g)].map((m) => decodeURIComponent(m[1]));
  const page = /\/pages\/([^/?]+)/.exec(href);
  const name = page ? decodeURIComponent(page[1]) : 'WebHome';
  const segs = name === 'WebHome' ? spaces : [...spaces, name];
  return segs[0] === WIKI_ROOT ? segs.slice(1) : segs;
}

// Two traps in one loop.
//
// A translation is its own document in the index, carrying the same path and a
// translated title - the German copy of User Generated Logos, the Turkish title of
// Game Updates and Patch History. Only the untranslated original has no <language>,
// so anything else is dropped, and the path is deduplicated on top of that.
//
// And a short page does not mean the last page: XWiki fetches `number` rows and only
// then drops the ones the reader may not view, so a page of 97 can still be followed
// by a full one. Stopping on a short page lost a whole top-level branch. Paging runs
// until a request comes back empty.
async function search(q) {
  const out = [];
  const seen = new Set();
  for (let i = 0; i < MAX_PAGES; i++) {
    const res = await fetch(query(q, i * PAGE_SIZE), { headers: { Accept: 'application/xml' } });
    if (!res.ok) throw new Error(`${res.status} ${res.statusText} from ${REST}`);
    const xml = await res.text();
    const hits = [...xml.matchAll(/<searchResult>([\s\S]*?)<\/searchResult>/g)].map((m) => m[1]);
    if (!hits.length) return out;
    for (const hit of hits) {
      const href = (/<link href="([^"]+)"/.exec(hit) || [])[1];
      const title = (/<title>([\s\S]*?)<\/title>/.exec(hit) || [])[1];
      const lang = (/<language>([\s\S]*?)<\/language>/.exec(hit) || [])[1];
      if (!href || (lang && lang !== 'en')) continue;
      const p = { segs: segsFromLink(href), title: unesc(title || '') };
      if (seen.has(key(p))) continue;
      seen.add(key(p));
      out.push(p);
    }
  }
  throw new Error(`more than ${MAX_PAGES * PAGE_SIZE} results for ${q}; the query is wrong`);
}

const unesc = (s) => s.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"')
  .replace(/&#(\d+);/g, (m, d) => String.fromCharCode(d)).replace(/&amp;/g, '&');

// A page's own title is what the wiki shows, and it is not always its URL segment:
// the ScriptingMD space is titled Scripting/MD/Libraries/Map. Both are kept - the
// segments address the page, the title names it.
const key = (p) => p.segs.join('/');
const byPath = (a, b) => key(a).localeCompare(key(b));

// A page whose parent is not itself a result - the wiki serves the parent's URL
// regardless, and the panel needs a node to hang the child under. UI Modding support is
// exactly this today: its child is indexed and it is not.
function withSynthesisedParents(pages) {
  const have = new Set(pages.map(key));
  const out = [...pages];
  for (const p of pages) {
    for (let i = 1; i < p.segs.length; i++) {
      const segs = p.segs.slice(0, i);
      const k = segs.join('/');
      if (!have.has(k)) {
        have.add(k);
        out.push({ segs, title: segs[segs.length - 1], implied: true });
      }
    }
  }
  return out.sort(byPath);
}

async function build() {
  const sub = await search(`space_facet:"1/${WIKI_ROOT}.${BRANCH}."`);
  const all = await search(`space_facet:"0/${WIKI_ROOT}."`);

  const pages = withSynthesisedParents(
    sub.filter((p) => p.segs.length && p.segs[0] === BRANCH));

  // Every other top-level branch, by name only. Depth 1 below the root, and never the
  // root's own WebHome.
  const seen = new Set();
  const branches = all
    .filter((p) => p.segs.length && p.segs[0] !== BRANCH)
    .map((p) => ({ segs: [p.segs[0]], title: p.segs.length === 1 ? p.title : p.segs[0] }))
    .filter((b) => !seen.has(b.segs[0]) && seen.add(b.segs[0]))
    .sort(byPath);

  if (!pages.length) throw new Error('the Modding Support query returned nothing');
  return { root: WIKI_ROOT, branch: BRANCH, pages, branches };
}

// The fetch date is what the file is for a reader, and noise for a diff. Compared
// without it, so an unchanged wiki produces no drift.
const shape = (t) => JSON.stringify({ ...t, fetched: undefined });

function report(before, after) {
  const was = new Map([...before.pages, ...before.branches].map((p) => [key(p), p.title]));
  const now = new Map([...after.pages, ...after.branches].map((p) => [key(p), p.title]));
  const lines = [];
  for (const [k, title] of now) {
    if (!was.has(k)) lines.push(`+ ${k}${title === k.split('/').pop() ? '' : `  (${title})`}`);
    else if (was.get(k) !== title) lines.push(`~ ${k}  "${was.get(k)}" -> "${title}"`);
  }
  for (const k of was.keys()) if (!now.has(k)) lines.push(`- ${k}`);
  return lines;
}

build().then((tree) => {
  const check = process.argv.includes('--check');
  const old = fs.existsSync(OUT) ? JSON.parse(fs.readFileSync(OUT, 'utf8')) : null;
  const drift = old ? report(old, tree) : [];

  if (check) {
    if (old && shape(old) === shape(tree)) {
      console.log(`tree.json matches the wiki: ${tree.pages.length} pages, `
        + `${tree.branches.length} other branches`);
      return;
    }
    console.log(old ? 'tree.json no longer matches the wiki:' : 'tree.json does not exist yet');
    for (const line of drift) console.log('  ' + line);
    process.exitCode = 1;
    return;
  }

  fs.writeFileSync(OUT, JSON.stringify({ fetched: new Date().toISOString().slice(0, 10), ...tree },
    null, 2) + '\n', 'utf8');
  console.log(`${path.relative(process.cwd(), OUT)}: ${tree.pages.length} pages under `
    + `${BRANCH}, ${tree.branches.length} other branches`);
  if (old) {
    if (!drift.length) console.log('unchanged');
    else for (const line of drift) console.log('  ' + line);
  }
}).catch((e) => {
  console.error(`wiki fetch failed: ${e.message}`);
  process.exitCode = 1;
});
