'use strict';

// Completeness gate: every callback name the source mentions as a literal must
// appear in the extraction, and every extracted site must have an invocation.
//
//   node check.js <src-root> <version>

const fs = require('fs');
const path = require('path');

const [root, version] = process.argv.slice(2);
const IDENT = /^[A-Za-z_][A-Za-z0-9_]*$/;

function walk(dir, out = []) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) walk(p, out);
    else if (e.name.endsWith('.xpl')) out.push(p);
  }
  return out;
}

const uiDir = fs.existsSync(path.join(root, 'ui')) ? path.join(root, 'ui') : root;
const mentioned = new Map(); // menu::name -> first line
for (const f of walk(uiDir)) {
  const menu = path.basename(f, '.xpl');
  const lines = fs.readFileSync(f, 'utf8').split(/\r?\n/);
  lines.forEach((l, i) => {
    for (const m of l.matchAll(/\b[A-Za-z_]\w*\.uix_callbacks\s*\[\s*"([^"]+)"\s*\]/g)) {
      if (!IDENT.test(m[1])) continue;
      const k = menu + '::' + m[1];
      if (!mentioned.has(k)) mentioned.set(k, `${path.basename(f)}:${i + 1}`);
    }
  });
}

const data = JSON.parse(fs.readFileSync(path.join(__dirname, 'out', version + '.json'), 'utf8'));
const got = new Set(data.callbacks.map(c => c.menu + '::' + c.name));

// A typo'd name quoted by a broken dispatch is not a callback of its own: it is
// recorded against the guard's name, which is the one a mod registers.
const aliases = new Set();
for (const c of data.callbacks) {
  for (const s of c.sites) {
    for (const d of s.defects || []) {
      for (const m of d.matchAll(/"([A-Za-z_]\w*)"/g)) if (m[1] !== c.name) aliases.add(c.menu + '::' + m[1]);
    }
  }
}
const missing = [...mentioned].filter(([k]) => !got.has(k) && !aliases.has(k));
const noInvoke = [];
for (const c of data.callbacks) for (const s of c.sites) if (!s.invoke) noInvoke.push(`${c.menu}::${c.name} @${s.file}:${s.dispatchLine}`);
const noArgsOverride = data.callbacks.filter(c => c.sites.every(s => s.invoke && !s.args.length && s.kind === 'override'));

console.log(`${version}: mentioned ${mentioned.size}, extracted ${got.size}`);
if (missing.length) { console.log('MISSING (mentioned but not extracted):'); for (const [k, w] of missing) console.log('  ', k, 'at', w); }
if (noInvoke.length) { console.log('NO INVOCATION:'); noInvoke.forEach(x => console.log('  ', x)); }
if (noArgsOverride.length) console.log('override with no args:', noArgsOverride.map(c => c.menu + '::' + c.name).join(', '));
if (!missing.length && !noInvoke.length) console.log('  complete: every mentioned name extracted, every site has an invocation');
