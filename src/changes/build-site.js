'use strict';

// Builds the Changes page: the site's own clock.
//
//   node build-site.js                 -> _site/x4/changes/
//   OUT=path/to/index.html node build-site.js
//
// What changed here, day by day and page by page, out of site-log.json because the build
// has no git history to read. Scope is usable content under /x4/ only, which site-log.js
// enforces as a map rather than as a rule anyone has to remember.
//
// The game's clock is a different question with a different audience, and lives under
// Modding Support on /x4/modding-support/game-changes/, built by build-game.js.
//
// The log names whole pages, so it runs after everything else in the build and checks
// that each page it names is still a page.

const fs = require('fs');
const path = require('path');

const { shell, esc } = require('../layout.js');
const { load } = require('./site-log.js');

const URL = '/x4/changes/';
const GAME_URL = '/x4/modding-support/game-changes/';
const OUT = process.env.OUT ||
  path.join(__dirname, '..', '..', '_site', ...URL.split('/').filter(Boolean), 'index.html');
const SITE_ROOT = path.join(__dirname, '..', '..', '_site');

/* ------------------------------------------------------------ dead links */

// The log links whole pages rather than rows, and a page it names can be renamed out
// from under it. This page itself is excluded: it is what this run is writing.
function checkLogged(log) {
  const bad = [];
  for (const day of log.days) {
    for (const p of day.pages) {
      if (p.kind === 'gone' || p.path === URL) continue;
      const file = path.join(SITE_ROOT, ...p.path.split('/').filter(Boolean), 'index.html');
      if (!fs.existsSync(file)) bad.push(`site log ${day.date}: ${p.path} is not a page any more`);
    }
  }
  return bad;
}

/* ------------------------------------------------------------ components */

// A log line is plain text with backticked code spans, the convention every description
// on the site already uses.
const prose = (s) => esc(s).replace(/`([^`]+)`/g, (_, t) => `<code>${t}</code>`);

// One day, then the pages that changed in it, then the lines - written by hand or
// drafted from the commits, which the page cannot tell apart.
function siteLog(log) {
  return '<div class="log">' + log.days.map((d) => `<section><h3>${esc(d.date)}</h3><ul>` +
    d.pages.map((p) => {
      const name = p.kind === 'gone'
        ? `<span class="pg">${esc(p.title)}</span>`
        : `<a class="pg" href="${esc(p.path)}">${esc(p.title)}</a>`;
      const tag = p.kind ? ` <span class="k t-${p.kind}">${p.kind === 'new' ? 'new page' : 'removed'}</span>` : '';
      return `<li>${name}${tag}<ul>` + p.lines.map((l) => `<li>${prose(l)}</li>`).join('') + '</ul></li>';
    }).join('') + '</ul></section>').join('\n') + '</div>';
}

/* ------------------------------------------------------------------ page */

const log = load();
const logged = log.days.reduce((n, d) => n + d.pages.length, 0);
const lines = log.days.reduce((n, d) => n + d.pages.reduce((m, p) => m + p.lines.length, 0), 0);

const CSS = `
.log section{border-top:1px solid var(--line);padding:.9em 0}
.log h3{margin:0 0 .5em;font-family:var(--mono);font-size:.9rem;font-weight:600;color:var(--dim)}
.log ul{list-style:none;padding:0;margin:0;display:grid;gap:.7em}
.log .pg{font-weight:600;text-decoration:none}
.log a.pg:hover{text-decoration:underline}
.log .k{font-size:.75rem;font-weight:600;border:1px solid currentColor;border-radius:5px;
  padding:0 6px;margin-left:.5em;vertical-align:.08em}
.log ul ul{margin:.25em 0 0;gap:.1em;color:var(--dim);font-size:.92rem}
.log ul ul li{list-style:disc;margin-left:1.25em}
`;

const body = `<h1>Changes</h1>
<p class="lede">What changed on this site, newest first: one entry per day, and within a day one per
page. Only pages under <a href="/x4/">For X4: Foundations</a> appear - how the site is built, deployed
and checked is not content and is left out of this. What changed in the game itself, between the last
two versions the references cover, is on <a href="${GAME_URL}">Game Changes</a>.</p>

<h2 id="log">By day</h2>
${siteLog(log)}

<h2 id="method">How this page is built</h2>
<p>The log is drafted from this site's own repository history and then corrected by hand, so its dates
are the commits' and its wording is a person's. It is committed as data rather than read from history
when the site is built, because the build checks the repository out without any history to read. Every
page named here is checked against the built site before the build is allowed to finish.</p>
`;

const problems = checkLogged(log);
if (problems.length) {
  console.error('Changes page: ' + problems.length + ' dead link(s)');
  for (const p of problems) console.error('  ' + p);
  process.exit(1);
}

const html = shell({
  title: 'Changes',
  description: 'What changed on this site, day by day - every page added or corrected, newest first.',
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
console.log(`site log: ${lines} line(s) over ${logged} page-entr${logged === 1 ? 'y' : 'ies'} over ` +
  `${log.days.length} day(s)`);
