'use strict';

// The site's own clock for the Changes page: what changed here, one entry per day and
// per page.
//
//   node site-log.js              drafts the days not yet logged and prints them
//   node site-log.js --write      appends that draft to site-log.json
//   node site-log.js --rebuild    regenerates the whole log from git history
//   require('./site-log')         returns { load } for the build
//
// Why a committed file rather than git at build time: Pages checks the repo out at
// fetch-depth 1, so the build has no history to read, and reading it would tie a
// published page to a history that can be rewritten. So history is read here, where it
// exists, and the result is committed for the build to render.
//
// It reports; it does not commit. And it is append-only: everything down to `through`
// is left exactly as written, so a line corrected by hand stays corrected. --rebuild is
// the backfill and throws hand edits away.
//
// Scope is usable content under /x4/ only. A file that maps to no page is invisible to
// this, which is how tooling, CI, the sitemap and the favicon stay off the page without
// anyone having to remember the rule. In a reference's directory the data is the
// content - the .lua and .json it is built from - and the .js is presentation, so a
// builder counts only in a `feat` commit: a page gaining a feature is something a
// reader sees, the same file refactored is not.

const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');

const REPO = path.join(__dirname, '..', '..');
const LOG = path.join(__dirname, 'site-log.json');

/* -------------------------------------------------------------- the map */

// Each reference page is built from data that lives outside src/content. A prefix is a
// directory or a single file; src/changes/ holds two pages, and the log's own files are
// deliberately absent, because a log that records its own updates says nothing.
const DATA = [
  ['src/globals/', '/x4/modding-support/ui-modding/lua-globals/'],
  ['src/c-functions-and-structures/', '/x4/modding-support/ui-modding/c-functions-and-structures/'],
  ['src/commands/', '/x4/modding-support/scripting-md-libraries-map/script-commands/'],
  ['src/uix-callbacks/', '/x4/modding-support/ui-modding/uix-callbacks/'],
  ['src/changes/sources.js', '/x4/modding-support/game-changes/'],
  ['src/changes/build-game.js', '/x4/modding-support/game-changes/'],
  ['src/changes/build-site.js', '/x4/changes/'],
];

const CONTENT = 'src/content/';
const SCOPE = 'x4/';

// src/content/x4/a/b.md -> /x4/a/b/, and index.md -> the directory it sits in.
function contentPage(file) {
  if (!file.startsWith(CONTENT + SCOPE) || !file.endsWith('.md')) return null;
  const rel = file.slice(CONTENT.length).replace(/\.md$/, '').replace(/(^|\/)index$/, '');
  return '/' + (rel ? rel + '/' : '');
}

// An article's images and downloads live in a folder named after the article.
function assetPage(file, slugs) {
  const m = /^src\/assets\/([^/]+)\//.exec(file);
  return m && slugs.has(m[1]) ? slugs.get(m[1]) : null;
}

// Every page under /x4/ that exists now, by the slug an asset folder would use.
function slugMap() {
  const out = new Map();
  const walk = (dir, base) => {
    for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
      const p = path.join(dir, e.name);
      if (e.isDirectory()) walk(p, base + e.name + '/');
      else if (e.name.endsWith('.md') && e.name !== 'index.md') {
        out.set(e.name.replace(/\.md$/, ''), '/' + base + e.name.replace(/\.md$/, '') + '/');
      }
    }
  };
  walk(path.join(REPO, CONTENT, SCOPE), SCOPE);
  return out;
}

// The page a changed file belongs to, and whether it is the page's content or the
// script that renders it. Null means the file is out of scope.
function pageOf(file, slugs) {
  const content = contentPage(file) || assetPage(file, slugs);
  if (content) return { path: content, content: true };
  for (const [dir, url] of DATA) {
    if (!file.startsWith(dir)) continue;
    return { path: url, content: /\.(lua|json)$/.test(file) };
  }
  return null;
}

/* ------------------------------------------------------------- the title */

// The page's own title, so the log reads as pages rather than as paths. A page that no
// longer exists keeps whatever title it was logged under.
function titleOf(url) {
  const rel = url.replace(/^\/|\/$/g, '');
  for (const f of [rel + '.md', rel + '/index.md']) {
    const file = path.join(REPO, CONTENT, f);
    if (!fs.existsSync(file)) continue;
    const m = /^---[\s\S]*?\btitle:\s*(.+)$/m.exec(fs.readFileSync(file, 'utf8'));
    if (m) return m[1].trim().replace(/^["']|["']$/g, '');
  }
  return null;
}

/* ------------------------------------------------------------------ git */

const git = (...args) => execFileSync('git', args, { cwd: REPO, encoding: 'utf8', maxBuffer: 64 << 20 });

// A record separator git writes for us: argv cannot carry a literal NUL.
const SEP = '\u0000';

// Commits oldest first, each with the status letter of every file it touched.
function commits(since) {
  const range = since ? [since + '..HEAD'] : [];
  const out = git('log', '--reverse', '--name-status', '--date=short',
    '--format=%x00%H%x1f%ad%x1f%s', ...range);
  return out.split(SEP).slice(1).map((block) => {
    const [head, ...lines] = block.split('\n');
    const [hash, date, subject] = head.split('\x1f');
    const files = lines.filter(Boolean).map((l) => {
      const [status, ...paths] = l.split('\t');
      return { status: status[0], file: paths[paths.length - 1].replace(/\\/g, '/') };
    });
    return { hash, date, subject, files };
  });
}

// `docs(globals): finish the 9.00 probe pass` is a line about the reference once the
// bookkeeping in front of it is gone.
const CONVENTIONAL = /^(\w+)(?:\(([^)]*)\))?!?:\s*/;
const typeOf = (subject) => (CONVENTIONAL.exec(subject) || [])[1] || '';
const textOf = (subject) => subject.replace(CONVENTIONAL, '').trim();

// The log's own commits. Its files map to no page already, so this matters only when
// one of them touches the log and a real page together - but the workflow that writes
// this file pushes exactly that kind of commit, and a log reporting its own updates
// says nothing. Skipped for content too: the day belongs to the work, not the logging.
const scopeOf = (subject) => (CONVENTIONAL.exec(subject) || [])[2] || '';
const isOwn = (subject) => typeOf(subject) === 'docs' && scopeOf(subject) === 'changes';

/* ---------------------------------------------------------------- draft */

// A commit contributes a line to every page it touched, and nothing at all when it
// touched no page: that is a refactor, the workflow, the favicon or the tooling.
function entriesFor(c, slugs) {
  const feat = typeOf(c.subject) === 'feat';
  const seen = new Map();
  for (const f of c.files) {
    const hit = pageOf(f.file, slugs);
    if (!hit || (!hit.content && !feat)) continue;
    const kind = contentPage(f.file) && f.status !== 'M' ? (f.status === 'A' ? 'new' : 'gone') : '';
    const prev = seen.get(hit.path);
    if (prev) { prev.kind = prev.kind || kind; continue; }
    seen.set(hit.path, { path: hit.path, kind });
  }
  return [...seen.values()];
}

// One day, one page, one line per commit - in the order they were made.
function draft(since, slugs) {
  const days = new Map();
  let through = since || null;
  for (const c of commits(since)) {
    through = c.hash;
    if (isOwn(c.subject)) continue;   // advance past it, write nothing
    const text = textOf(c.subject);
    for (const e of entriesFor(c, slugs)) {
      if (!days.has(c.date)) days.set(c.date, new Map());
      const pages = days.get(c.date);
      const page = pages.get(e.path) ||
        { path: e.path, title: titleOf(e.path) || e.path, kind: '', lines: [] };
      page.kind = e.kind === 'gone' ? 'gone' : page.kind || e.kind;
      if (!page.lines.includes(text)) page.lines.push(text);
      pages.set(e.path, page);
    }
  }
  const out = [...days.entries()].map(([date, pages]) => ({ date, pages: [...pages.values()] }));
  out.sort((a, b) => b.date.localeCompare(a.date));
  return { through, days: out };
}

/* ------------------------------------------------------------- the file */

function load() {
  if (!fs.existsSync(LOG)) return { through: null, days: [] };
  const data = JSON.parse(fs.readFileSync(LOG, 'utf8'));
  return { through: data.through || null, days: Array.isArray(data.days) ? data.days : [] };
}

const save = (data) => fs.writeFileSync(LOG, JSON.stringify(data, null, 2) + '\n', 'utf8');

// New days go on top. A day already in the log can still gain commits, and merging into
// it rather than pushing a second copy is what keeps "one entry per day" true.
function merge(existing, fresh) {
  const days = existing.days.slice();
  for (const day of fresh.days.slice().reverse()) {
    const known = days.find((d) => d.date === day.date);
    if (!known) { days.unshift(day); continue; }
    for (const page of day.pages) {
      const p = known.pages.find((x) => x.path === page.path);
      if (!p) { known.pages.push(page); continue; }
      p.kind = p.kind || page.kind;
      for (const line of page.lines) if (!p.lines.includes(line)) p.lines.push(line);
    }
  }
  days.sort((a, b) => b.date.localeCompare(a.date));
  return { through: fresh.through || existing.through, days };
}

module.exports = { load };

/* ------------------------------------------------------------------ cli */

if (require.main === module) {
  const arg = (f) => process.argv.includes(f);
  const rebuild = arg('--rebuild');
  const slugs = slugMap();
  const existing = rebuild ? { through: null, days: [] } : load();
  const fresh = draft(existing.through, slugs);

  const lines = fresh.days.reduce((n, d) => n + d.pages.reduce((m, p) => m + p.lines.length, 0), 0);
  for (const d of fresh.days) {
    console.log('\n' + d.date);
    for (const p of d.pages) {
      console.log(`  ${p.title}${p.kind ? ` [${p.kind}]` : ''}`);
      for (const l of p.lines) console.log('    - ' + l);
    }
  }
  if (!fresh.days.length) console.log('nothing to add: the log is current');

  if (!arg('--write') && !rebuild) {
    console.log(`\n${lines} line(s) over ${fresh.days.length} day(s). Pass --write to append them.`);
  } else {
    const data = rebuild ? fresh : merge(existing, fresh);
    save(data);
    console.log(`\nwrote ${path.relative(REPO, LOG)}: ${data.days.length} day(s), through ${String(data.through).slice(0, 7)}`);
  }
}
