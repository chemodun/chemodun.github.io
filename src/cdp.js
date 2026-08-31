// Headless Chrome over the DevTools protocol, with no dependency: Node 22 has a global
// WebSocket and Chrome is on the runner as well as on any machine that can view the
// site.
//
// Shared by src/check-pages.js, which gates the deploy on a page being alive, and
// src/measure-layout.js, which reports where the shell's parts actually land. One copy
// rather than two, because a second copy is how the conversion files drifted.

const fs = require('fs');
const path = require('path');
const os = require('os');
const { spawn } = require('child_process');

const wait = (ms) => new Promise((r) => setTimeout(r, ms));

const BROWSERS = {
  linux: ['/usr/bin/google-chrome', '/usr/bin/google-chrome-stable', '/usr/bin/chromium',
    '/usr/bin/chromium-browser', '/opt/google/chrome/chrome'],
  win32: ['C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
    'C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe',
    'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe',
    'C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe'],
  darwin: ['/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    '/Applications/Chromium.app/Contents/MacOS/Chromium'],
};

function findBrowser() {
  const listed = [process.env.CHROME, ...(BROWSERS[process.platform] || [])].filter(Boolean);
  const found = listed.find((p) => fs.existsSync(p));
  if (!found) {
    throw new Error('no Chrome or Edge found. Set CHROME to the executable.\nLooked at:\n  '
      + listed.join('\n  '));
  }
  return found;
}

// The window size is the viewport every measurement is taken against, so it is an
// argument rather than a constant: a layout that is right at one width can be wrong at
// another, which is the whole point of measuring.
async function launch(exe, { width = 1280, height = 900 } = {}) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'x4docs-cdp-'));
  const child = spawn(exe, [
    '--headless=new', '--disable-gpu', '--no-sandbox', '--no-first-run',
    '--no-default-browser-check', '--disable-extensions', '--disable-background-networking',
    '--disable-search-engine-choice-screen', '--window-size=' + width + ',' + height,
    '--user-data-dir=' + dir, '--remote-debugging-port=0', 'about:blank',
  ], { stdio: ['ignore', 'ignore', 'pipe'] });

  let stderr = '';
  child.stderr.on('data', (d) => { stderr += d; });

  // Chrome writes the chosen port and the browser endpoint here once it is up.
  const portFile = path.join(dir, 'DevToolsActivePort');
  for (let i = 0; i < 200; i++) {
    if (child.exitCode !== null) throw new Error('browser exited (' + child.exitCode + ')\n' + stderr);
    if (fs.existsSync(portFile)) {
      const [port, endpoint] = fs.readFileSync(portFile, 'utf8').split('\n');
      if (endpoint) return { child, dir, url: 'ws://127.0.0.1:' + port + endpoint.trim() };
    }
    await wait(50);
  }
  throw new Error('browser did not open a debugging port in 10s\n' + stderr);
}

function connect(url) {
  return new Promise((resolve, reject) => {
    const ws = new WebSocket(url);
    const pending = new Map();
    const listeners = [];
    let id = 0;

    ws.onerror = () => reject(new Error('cannot reach the browser at ' + url));
    ws.onmessage = (ev) => {
      const m = JSON.parse(ev.data);
      if (m.id && pending.has(m.id)) {
        const { ok, fail } = pending.get(m.id);
        pending.delete(m.id);
        m.error ? fail(new Error(m.method + ': ' + m.error.message)) : ok(m.result);
      } else if (m.method) {
        for (const fn of listeners) fn(m);
      }
    };
    ws.onopen = () => resolve({
      send(method, params = {}, sessionId) {
        return new Promise((ok, fail) => {
          const msg = { id: ++id, method, params };
          if (sessionId) msg.sessionId = sessionId;
          pending.set(msg.id, { ok, fail });
          ws.send(JSON.stringify(msg));
        });
      },
      on: (fn) => listeners.push(fn),
      close: () => ws.close(),
    });
  });
}

// A tab, with the domains a caller needs already enabled. Every later call has to carry
// the session id, so it is what this returns.
async function openPage(cdp, domains = ['Page', 'Runtime']) {
  const { targetId } = await cdp.send('Target.createTarget', { url: 'about:blank' });
  const { sessionId } = await cdp.send('Target.attachToTarget', { targetId, flatten: true });
  for (const d of domains) await cdp.send(d + '.enable', {}, sessionId);
  return sessionId;
}

module.exports = { wait, findBrowser, launch, connect, openPage };
