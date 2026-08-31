// Loads every built page in headless Chrome and fails on any console error.
//
//   node src/check-pages.js [--keep-open]
//
// The build cannot see this class of bug: a page can be byte-perfect and silently
// inert. A top-level `let` colliding with a global `var` once killed the whole
// script tag on the globals page - theme toggle, filter and deep links all dead -
// while every statically rendered part still looked right. Only a browser reports it.
//
// So: serve _site/ the way Pages does, drive a real browser over the DevTools
// protocol (src/cdp.js - no dependency, Node 22 has WebSocket and Chrome is on the
// runner), collect uncaught exceptions, console.error and severe log entries, and
// prove the scripts actually ran rather than merely not throwing.
//
// What this cannot see is where anything landed. src/measure-layout.js does that.

const fs = require('fs');
const path = require('path');
const { ROOT, listen } = require('./serve');
const { wait, findBrowser, launch, connect, openPage } = require('./cdp');

const KEEP_OPEN = process.argv.includes('--keep-open');
const PAGE_TIMEOUT = 20000;

// Every built page, as the URL path Pages would serve it under.
function pageUrls(dir = ROOT, base = '') {
  const out = [];
  for (const e of fs.readdirSync(dir, { withFileTypes: true }).sort((a, b) => a.name.localeCompare(b.name))) {
    if (e.isDirectory()) out.push(...pageUrls(path.join(dir, e.name), base + '/' + e.name));
    else if (e.name === 'index.html') out.push(base + '/');
    else if (e.name.endsWith('.html')) out.push(base + '/' + e.name);
  }
  return out;
}

// Runs in the page after load. Proves the scripts are alive, not merely quiet:
// the shell's theme toggle, its navigation toggle, the sticky bar's measured height,
// and the page's own filter actually narrowing the counter to nothing.
const PROBE = `(async () => {
  const fail = [], ran = [];
  const doc = document.documentElement;

  const btn = document.querySelector('button.theme');
  if (!btn) fail.push('no theme button in the shell');
  else {
    const was = doc.getAttribute('data-theme');
    btn.click();
    const now = doc.getAttribute('data-theme');
    if (!now || now === was) fail.push('the theme toggle did not change data-theme');
    else ran.push('theme');
    if (was === null) doc.removeAttribute('data-theme'); else doc.setAttribute('data-theme', was);
    try { localStorage.removeItem('theme'); } catch (e) {}
  }

  const nav = document.querySelector('button.navt'), side = document.querySelector('nav.side');
  if (!nav || !side) fail.push('no navigation panel in the shell');
  else if (!side.querySelector('a[href^="https://wiki.egosoft.com/"]')) {
    fail.push('the navigation panel carries no wiki pages');
  } else {
    // The panel is the one part of the shell that moves the page when it fails, so the
    // toggle is exercised rather than trusted, and the reader's own choice is put back.
    const was = doc.getAttribute('data-nav');
    nav.click();
    if (doc.getAttribute('data-nav') === was) fail.push('the navigation toggle did nothing');
    else ran.push('nav');
    if (was === null) doc.removeAttribute('data-nav'); else doc.setAttribute('data-nav', was);
    try { localStorage.removeItem('nav'); } catch (e) {}
  }

  if (document.querySelector('.bar')) {
    const h = parseFloat(getComputedStyle(doc).getPropertyValue('--barh'));
    if (!(h > 0)) fail.push('--barh was not published by the sticky-bar script');
    else ran.push('barh');
  }

  const q = document.getElementById('q'), n = document.getElementById('n');
  if (q && n) {
    if (!n.textContent.trim()) fail.push('the #n counter is empty');
    const was = n.textContent;
    q.value = 'zzq-no-such-global-or-command-zzq';
    q.dispatchEvent(new Event('input', { bubbles: true }));
    await new Promise((r) => setTimeout(r, 400));
    const now = n.textContent;
    if (now === was) fail.push('the filter did not update the counter');
    else if (!/^0 of /.test(now.trim())) fail.push('the filter matched something: ' + now);
    else ran.push('filter');
  }

  return JSON.stringify({ fail, ran });
})()`;

function exceptionText(d) {
  const where = d.url ? ' (' + d.url + ':' + ((d.lineNumber || 0) + 1) + ')' : '';
  return ((d.exception && d.exception.description) || d.text || 'uncaught exception') + where;
}

function argText(a) {
  if ('value' in a) return String(a.value);
  return a.description || a.unserializableValue || a.type;
}

async function main() {
  if (!fs.existsSync(ROOT)) throw new Error('_site/ is missing - run the build first');
  const urls = pageUrls();
  if (!urls.length) throw new Error('_site/ has no pages');

  const exe = findBrowser();
  const server = await listen(0);
  const origin = 'http://127.0.0.1:' + server.address().port;
  const browser = await launch(exe, { width: 1280, height: 900 });
  const cdp = await connect(browser.url);
  const sessionId = await openPage(cdp, ['Page', 'Runtime', 'Log']);

  let found = [];
  let onLoad = null;
  cdp.on((m) => {
    if (m.sessionId !== sessionId) return;
    const p = m.params || {};
    if (m.method === 'Page.loadEventFired' && onLoad) onLoad();
    else if (m.method === 'Runtime.exceptionThrown') found.push(exceptionText(p.exceptionDetails));
    else if (m.method === 'Runtime.consoleAPICalled' && (p.type === 'error' || p.type === 'assert')) {
      found.push('console.' + p.type + ': ' + (p.args || []).map(argText).join(' '));
    } else if (m.method === 'Log.entryAdded' && p.entry.level === 'error'
      // An uncaught error arrives twice, as an exception and as a javascript log entry.
      && p.entry.source !== 'javascript') {
      found.push(p.entry.source + ': ' + p.entry.text + (p.entry.url ? ' [' + p.entry.url + ']' : ''));
    }
  });

  console.log('Checking ' + urls.length + ' pages in ' + path.basename(exe) + '\n');
  let bad = 0;

  for (const url of urls) {
    found = [];
    const loaded = new Promise((res, rej) => {
      onLoad = res;
      setTimeout(() => rej(new Error('load timed out after ' + PAGE_TIMEOUT + 'ms')), PAGE_TIMEOUT);
    });
    let problems = [];
    let alive = [];
    try {
      await cdp.send('Page.navigate', { url: origin + url }, sessionId);
      await loaded;
      await wait(200);
      const r = await cdp.send('Runtime.evaluate',
        { expression: PROBE, awaitPromise: true, returnByValue: true }, sessionId);
      if (r.exceptionDetails) problems.push('probe failed: ' + exceptionText(r.exceptionDetails));
      else {
        const { fail, ran } = JSON.parse(r.result.value);
        problems.push(...fail);
        alive = ran;
      }
    } catch (e) {
      problems.push(e.message);
    }
    onLoad = null;
    problems = found.concat(problems);

    if (problems.length) {
      bad++;
      console.log('FAIL ' + url);
      for (const p of problems) console.log('       ' + p.split('\n')[0]);
    } else {
      console.log('ok   ' + url + (alive.length ? '  [' + alive.join(' ') + ']' : ''));
    }
  }

  cdp.close();
  if (!KEEP_OPEN) browser.child.kill();
  server.close();

  console.log('\n' + (bad ? bad + ' of ' + urls.length + ' pages failed' : 'all ' + urls.length + ' pages clean'));
  if (bad) process.exitCode = 1;
}

main().then(() => {
  if (!KEEP_OPEN) process.exit(process.exitCode || 0);
}, (e) => {
  console.error(e.message);
  process.exit(2);
});
