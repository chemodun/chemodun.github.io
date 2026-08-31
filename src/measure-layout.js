// Reports where the shell's parts actually land, at several viewport widths and in
// both navigation-panel states.
//
//   node src/measure-layout.js [path-or-url] [--widths=1280,1520,760] [--sel=.a,.b]
//
//   node src/measure-layout.js                        the home page from _site/
//   node src/measure-layout.js /x4/modding-support/   another built page
//   node src/measure-layout.js https://chemodun.github.io/   the published site
//
// Why this exists as well as check-pages.js: a page can be alive, console-clean and
// still misplaced, and a screenshot is a poor witness to a small offset. The header
// title once sat 16px past the page's left edge - `.in` carries `gap:1em` from its
// flex rule, and `gap` applies to a grid container just as well - which looked
// deliberate in every screenshot and was obvious the moment two numbers were compared.
//
// So the shell's alignment rules are stated here as invariants and checked, rather
// than left for the eye. It is a hand tool, not a gate: it is deliberately not in
// `npm run check` and not in CI, because the geometry it asserts is a design decision
// Chem can change, and a layout choice should not fail a deploy.

const fs = require('fs');
const { ROOT, listen } = require('./serve');
const { wait, findBrowser, launch, connect, openPage } = require('./cdp');

const args = process.argv.slice(2);
const opt = (name, fallback) => {
  const hit = args.find((a) => a.startsWith('--' + name + '='));
  return hit ? hit.slice(name.length + 3) : fallback;
};
const TARGET = args.find((a) => !a.startsWith('--')) || '/';
const WIDTHS = opt('widths', '1280,1520,760').split(',').map(Number);
const HEIGHT = Number(opt('height', '900'));

// The shell's landmarks. --sel replaces them for a page-specific question.
const SELECTORS = opt('sel', [
  'button.navt', 'header .brand', 'header .tagline', 'button.theme',
  'nav.side', '.wrap', '.wrap h1',
].join(',')).split(',').map((s) => s.trim()).filter(Boolean);

// The rules the header and the panel are built to keep, as pairs of edges that must
// agree. Each is checked only in the states where it is meant to hold - the collapsed
// panel has no column for the title to line up with, so the title is not asked to.
const INVARIANTS = [
  { when: 'on', a: ['header .brand', 'left'], b: ['.wrap h1', 'left'],
    why: 'the title starts where the page does' },
  { when: 'on', a: ['button.theme', 'right'], b: ['.wrap h1', 'right'],
    why: 'the theme button ends where the page does' },
  { when: 'off', a: ['button.navt', 'left'], b: ['.wrap h1', 'left'],
    why: 'with no panel, the toggle leads the page' },
  { when: 'off', a: ['button.theme', 'right'], b: ['.wrap h1', 'right'],
    why: 'the theme button ends where the page does' },
];

// getBoundingClientRect in the page, rounded: sub-pixel noise is not a fault and
// reporting it as one would make every run look broken.
const READ = (selectors) => `(() => {
  const out = {};
  for (const s of ${JSON.stringify(selectors)}) {
    const e = document.querySelector(s);
    if (!e) { out[s] = null; continue; }
    const r = e.getBoundingClientRect();
    out[s] = { left: Math.round(r.left), right: Math.round(r.right),
      width: Math.round(r.width), top: Math.round(r.top), height: Math.round(r.height) };
  }
  return JSON.stringify(out);
})()`;

const pad = (s, n) => String(s).padEnd(n);
const num = (s, n) => String(s).padStart(n);

async function measure(cdp, sessionId, url, state) {
  await cdp.send('Page.navigate', { url }, sessionId);
  await wait(900);
  if (state) {
    await cdp.send('Runtime.evaluate', {
      expression: `document.documentElement.setAttribute('data-nav',${JSON.stringify(state)})`,
    }, sessionId);
    await wait(150);
  }
  const r = await cdp.send('Runtime.evaluate',
    { expression: READ(SELECTORS), returnByValue: true }, sessionId);
  if (r.exceptionDetails) throw new Error('measuring failed in the page');
  return JSON.parse(r.result.value);
}

function report(boxes, state, width) {
  const w = Math.max(...SELECTORS.map((s) => s.length));
  for (const s of SELECTORS) {
    const b = boxes[s];
    console.log('   ' + pad(s, w) + (b
      ? '  left ' + num(b.left, 5) + '   right ' + num(b.right, 5)
        + '   width ' + num(b.width, 5) + '   top ' + num(b.top, 4)
      : '  (not on this page)'));
  }
  // Only the states an invariant is written for, and only when both edges exist: a
  // page with no h1, or a width where the panel is a drawer, is not a failure.
  let bad = 0;
  for (const inv of INVARIANTS) {
    if (inv.when !== state) continue;
    const a = boxes[inv.a[0]] && boxes[inv.a[0]][inv.a[1]];
    const b = boxes[inv.b[0]] && boxes[inv.b[0]][inv.b[1]];
    if (a === undefined || b === undefined || a === null || b === null) continue;
    const ok = a === b;
    if (!ok) bad++;
    console.log('   ' + (ok ? 'ok  ' : 'OFF ')
      + inv.a[0] + '.' + inv.a[1] + ' ' + a + (ok ? ' = ' : ' vs ') + b + ' '
      + inv.b[0] + '.' + inv.b[1] + (ok ? '' : '   (' + (a - b) + 'px)  ' + inv.why));
  }
  return bad;
}

async function main() {
  const remote = /^https?:\/\//.test(TARGET);
  let server = null;
  let url = TARGET;
  if (!remote) {
    if (!fs.existsSync(ROOT)) throw new Error('_site/ is missing - run the build first');
    server = await listen(0);
    url = 'http://127.0.0.1:' + server.address().port + (TARGET.startsWith('/') ? TARGET : '/' + TARGET);
  }

  const exe = findBrowser();
  console.log('Measuring ' + url + '\n');
  let bad = 0;

  for (const width of WIDTHS) {
    const browser = await launch(exe, { width, height: HEIGHT });
    const cdp = await connect(browser.url);
    const sessionId = await openPage(cdp);
    // Below 901px the panel is a drawer over the page and takes no column, so there is
    // one state to report rather than two.
    const states = width > 900 ? ['on', 'off'] : [''];
    for (const state of states) {
      const boxes = await measure(cdp, sessionId, url, state);
      console.log(width + 'px' + (state ? '  panel ' + state : '  (drawer width)'));
      bad += report(boxes, state, width);
      console.log('');
    }
    cdp.close();
    browser.child.kill();
  }

  if (server) server.close();
  console.log(bad ? bad + ' alignment rule(s) not held' : 'every alignment rule held');
  if (bad) process.exitCode = 1;
}

main().then(() => process.exit(process.exitCode || 0), (e) => {
  console.error(e.message);
  process.exit(2);
});
