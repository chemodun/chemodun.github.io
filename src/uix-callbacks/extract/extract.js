'use strict';

// UIX callbacks, one extracted tag at a time.
//
//   node extract.js <src-root> <version> [--repo=owner/name]
//
// <src-root> holds the tag's ui/ tree. Writes out/<version>.json: every
// (menu, name) pair the .xpl files dispatch, with the call sites behind it.
//
// The dispatch shapes are regular. All of them read as:
//
//   if menu.uix_callbacks ["NAME"] then
//       for uix_id, uix_callback in pairs (menu.uix_callbacks ["NAME"]) do
//           [<targets> =] uix_callback (<args>)
//       end
//   end
//
// with the intro sometimes `elseif` or a `local cbs = ...`, and the call
// sometimes wrapped in pcall. What varies, and what a reader cannot guess, is
// what happens to the return: that is `aggregation`, classified here and
// correctable by hand in the meta file's prose.

const fs = require('fs');
const path = require('path');
const L = require('./lib/lua');

const IDENT = /^[A-Za-z_][A-Za-z0-9_]*$/;
const REF = /\b([A-Za-z_]\w*)\.uix_callbacks\s*\[\s*"([^"]+)"\s*\]/;

function walk(dir, out = []) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true }).sort((a, b) => a.name.localeCompare(b.name))) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) walk(p, out);
    else if (e.name.endsWith('.xpl')) out.push(p);
  }
  return out;
}

// What the block does with the callback's return value.
function classify(block, targets, args) {
  if (!targets.length) return 'none';
  const t = targets[0];
  if (targets.length > 1) return 'multi-value';
  if (/(\w*[Cc]ount)\s*=\s*\1\s*\+\s*1/.test(block) && /==\s*\w*[Cc]allbacksCount/.test(block)) return 'unanimous';
  if (new RegExp('\\bbreak\\b').test(block) && new RegExp('if\\s+(not\\s+)?' + t + '\\b').test(block)) return 'short-circuit';
  if (new RegExp('\\b' + t + '\\s*=\\s*[^=\\n]*\\.\\.').test(block)) return 'appended';
  if (args.some(a => a === t)) return 'chained';
  if (/type\s*\(\s*\w+\s*\)\s*==\s*"table"/.test(block)) return 'chained';
  return 'last-wins';
}

// Fields read off the returned table, e.g. `result.active` -> ["active"].
function returnFields(block, targets) {
  const f = new Set();
  for (const t of targets) {
    for (const m of block.matchAll(new RegExp('\\b' + t + '\\.(\\w+)', 'g'))) f.add(m[1]);
  }
  return [...f];
}

// The four iteration forms in use, all of them binding each registered function
// to a loop variable:
//   for id, cb in pairs (menu.uix_callbacks ["N"])
//   for _,  cb in pairs (cbs)                       -- cbs assigned just above
//   for _,  cb in next,  menu.uix_callbacks ["N"]
//   for     cb in pairs (...)
const LOOP = /\bfor\s+([A-Za-z_]\w*)(?:\s*,\s*([A-Za-z_]\w*))?\s+in\s+(?:pairs\s*\(|next\s*,)\s*([^)\s]+(?:\s*\[\s*"[^"]*"\s*\])?)/;
// `local cbs = menu.uix_callbacks["N"]`, and the guarded variant
// `local cbs = menu.uix_callbacks and menu.uix_callbacks["N"]`.
const LOCAL_BIND = /\blocal\s+([A-Za-z_]\w*)\s*=\s*(?:[A-Za-z_]\w*\.uix_callbacks\s+and\s+)?([A-Za-z_]\w*)\.uix_callbacks\s*\[\s*"([A-Za-z_]\w*)"\s*\]/;

// The name Helper.getMenu() takes. Not derivable from the file name:
// menu_trader_blueprintsorlicences registers as BlueprintOrLicenceTraderMenu.
function menuName(lines) {
  const i = lines.findIndex(l => /^\s*local\s+menu\s*=\s*\{/.test(l));
  if (i < 0) return null;
  for (let j = i; j < Math.min(lines.length, i + 40); j++) {
    const m = /^\s*name\s*=\s*"([^"]+)"/.exec(lines[j]);
    if (m) return m[1];
  }
  return null;
}

function extractFile(file, rel) {
  const raw = fs.readFileSync(file, 'utf8').replace(/^﻿/, '');
  const lines = raw.split(/\r?\n/);
  const sites = [];
  const inMenu = menuName(lines);

  // Locals that alias a callback list, so a loop over one resolves to its name.
  const alias = new Map();
  for (let i = 0; i < lines.length; i++) {
    const b = LOCAL_BIND.exec(lines[i]);
    if (b && IDENT.test(b[3])) alias.set(b[1], { holder: b[2], name: b[3], line: i });
  }

  for (let i = 0; i < lines.length; i++) {
    const lm = LOOP.exec(lines[i]);
    if (!lm) continue;
    const loopVar = lm[2] || lm[1];
    const over = lm[3];

    // What is being iterated: a direct index, or a local that aliases one.
    let holder = null, name = null;
    const direct = REF.exec(lines[i]);
    if (direct && IDENT.test(direct[2])) { holder = direct[1]; name = direct[2]; }
    else if (alias.has(over)) {
      const a = alias.get(over);
      if (i - a.line <= 12) { holder = a.holder; name = a.name; }
    }
    if (!name) continue;

    // The guard the dispatch sits behind, so the recorded block starts where a
    // reader would start reading. Some guards are a whole function away.
    const defects = [];
    let start = i, guardName = null;
    for (let j = i - 1; j >= Math.max(0, i - 35); j--) {
      const g = REF.exec(lines[j]);
      if (g && IDENT.test(g[2])) { start = j; guardName = g[2]; break; }
      if (/^\s*function\s/.test(lines[j])) break;
    }
    // A guard and a loop that disagree is a typo, and the callback is dead: the
    // guard admits a registration the loop then cannot find. The name a mod would
    // register against is the guard's, so that is the one the reference carries.
    // Defects are reported here only; the meta file carries the callback, not the typo.
    if (guardName && guardName !== name) {
      defects.push(`guard checks "${guardName}" but the loop iterates "${name}" - registering it raises a Lua error`);
      name = guardName;
    }
    const end = Math.max(L.blockExtent(lines, start), L.blockExtent(lines, i));
    const block = lines.slice(start, end + 1).join('\n');

    let args = [], targets = [], invoke = null;
    let callVar = loopVar;
    const mkCallRe = v => new RegExp('(?:(local\\s+[\\w,\\s]+|[\\w.\\[\\]]+(?:\\s*,\\s*[\\w.\\[\\]]+)*)\\s*=\\s*)?' +
      '(pcall\\s*\\(\\s*)?\\b' + v + '\\b\\s*[(,]');
    // The loop variable is normally what the body calls. Where it is not, the body
    // is calling a nil global: another typo, and another dead callback.
    if (!new RegExp('\\b' + loopVar + '\\b\\s*[(,]').test(lines.slice(i + 1, end + 1).join('\n'))) {
      const alt = /\b(uix_callback\w*|cb\w*)\s*\(/.exec(lines.slice(i + 1, end + 1).join('\n'));
      if (alt && alt[1] !== loopVar) {
        defects.push(`the loop binds "${loopVar}" but the body calls "${alt[1]}" - dispatching it raises a Lua error`);
        callVar = alt[1];
      }
    }
    const callRe = mkCallRe(callVar);
    for (let j = i + 1; j <= end; j++) {
      if (LOOP.test(lines[j])) continue;
      const c = callRe.exec(lines[j]);
      if (!c) continue;
      invoke = c[2] ? 'pcall' : 'direct';
      // pcall takes the callback as its first argument, so read the pcall's own
      // parentheses and drop that first entry.
      const from = c[2] ? lines[j].indexOf('pcall') : c.index + (c[1] ? c[1].length : 0);
      const inner = L.balanced(lines.slice(j, Math.min(end + 1, j + 4)).join('\n'), from);
      args = inner === null ? [] : L.splitArgs(inner);
      if (c[2]) args = args.slice(1);
      if (c[1]) {
        targets = c[1].replace(/^local\s+/, '').split(',').map(s => s.trim()).filter(Boolean);
        if (invoke === 'pcall') targets = targets.slice(1); // ok, then the real returns
      }
      break;
    }

    const { func, inner } = L.enclosingFunction(lines, i);
    const agg = classify(block, targets, args);
    sites.push({
      name, holder, menuName: inMenu, file: rel, line: start + 1, dispatchLine: i + 1,
      func, innerFunc: inner,
      invoke, args, targets,
      returnFields: returnFields(block, targets),
      aggregation: agg,
      kind: agg === 'none' ? 'event' : 'override',
      attribution: L.attribution(lines, start, end),
      defects,
      block,
    });
  }
  return sites;
}

// One tag's ui/ tree -> the extraction object. Split out of the CLI so the history
// builder can extract a release in process, without a child node per tag.
function extractTree(root, version, repo) {
  const uiDir = fs.existsSync(path.join(root, 'ui')) ? path.join(root, 'ui') : root;

  const all = [];
  for (const file of walk(uiDir)) {
    const rel = path.relative(root, file).replace(/\\/g, '/');
    all.push(...extractFile(file, rel));
  }

  // Fold sites into one entry per (menu, name): the same hook is dispatched from
  // more than one place in a few menus, and that is a property of the hook.
  const byKey = new Map();
  for (const s of all) {
    const menu = path.basename(s.file, '.xpl');
    const addon = s.file.split('/').includes('addons') ? s.file.split('/')[s.file.split('/').indexOf('addons') + 1] : null;
    const key = menu + '::' + s.name;
    if (!byKey.has(key)) byKey.set(key, { name: s.name, menu, addon, holder: s.holder, menuName: s.menuName, sites: [] });
    byKey.get(key).sites.push(s);
  }

  const callbacks = [...byKey.values()].sort((a, b) => a.menu.localeCompare(b.menu) || a.name.localeCompare(b.name));
  const counts = {
    files: walk(uiDir).length,
    sites: all.length,
    callbacks: callbacks.length,
    byAggregation: {}, byKind: {}, byHolder: {},
  };
  for (const c of callbacks) {
    const s = c.sites[0];
    counts.byAggregation[s.aggregation] = (counts.byAggregation[s.aggregation] || 0) + 1;
    counts.byKind[s.kind] = (counts.byKind[s.kind] || 0) + 1;
    counts.byHolder[c.holder] = (counts.byHolder[c.holder] || 0) + 1;
  }

  return { version, repo, source: `${repo}@${version}`, counts, callbacks };
}

// What an extracted release is worth saying out loud, shared by the CLI and the
// history builder so a backfill reads like 33 runs of the one-tag command.
function report(data, prefix = '') {
  const { version, counts, callbacks } = data;
  console.log(`${prefix}${version}: ${counts.files} files, ${counts.sites} sites, ${counts.callbacks} callbacks`);
  const noArgs = callbacks.filter(c => !c.sites[0].invoke);
  if (noArgs.length) console.log(`${prefix}  no invocation found:`, noArgs.map(c => c.menu + '::' + c.name).join(', '));
  const broken = callbacks.filter(c => c.sites.some(s => s.defects.length));
  if (broken.length) {
    console.log(`${prefix}  defects in UIX itself (${broken.length}):`);
    for (const c of broken) for (const s of c.sites) for (const d of s.defects) console.log(`${prefix}    ${c.menu}::${c.name} (${s.file}:${s.dispatchLine}) - ${d}`);
  }
}

function main() {
  const [root, version] = process.argv.slice(2);
  const repo = (process.argv.find(a => a.startsWith('--repo=')) || '--repo=kuertee/x4-mod-ui-extensions').slice(7);
  if (!root || !version) {
    console.error('usage: node extract.js <src-root> <version> [--repo=owner/name]');
    process.exit(2);
  }
  const data = extractTree(root, version, repo);
  const counts = data.counts;

  const outDir = path.join(__dirname, 'out');
  fs.mkdirSync(outDir, { recursive: true });
  fs.writeFileSync(path.join(outDir, version + '.json'), JSON.stringify(data, null, 1));

  report(data);
  console.log(`  -> out/${version}.json`);
  console.log('  kind:       ', JSON.stringify(counts.byKind));
  console.log('  holder:     ', JSON.stringify(counts.byHolder));
  console.log('  aggregation:', JSON.stringify(counts.byAggregation));
}

module.exports = { extractTree, report };

if (require.main === module) main();
