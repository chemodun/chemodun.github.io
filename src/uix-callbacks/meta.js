'use strict';

// The LuaLS meta file: emit it from out/*.json, and read it back.
//
// The file is the reference. Everything the page shows lives in it, so the site
// half reads it instead of the JSON, and it doubles as an editor library: point a
// Lua Language Server at it and a mod author writing a UIX callback gets
// completion and signatures for what the hook is handed.
//
// Two halves share every entry:
//
//   generated   the `-- Key: value` lines and the declaration, rewritten in full
//               on every run of gen-meta.js
//   authored    the `---` prose and the text trailing a ---@param / ---@return,
//               carried across untouched
//
// One key is neither: `Since:` is generated once, when a callback is first seen,
// and then left alone. A later tag that adds a callback stamps only that one.
//
// Callback names collide across menus - `cleanup` is in ten files - so the file
// is one table per menu and the key is always (menu, name).

const IDENT = /^[A-Za-z_][A-Za-z0-9_]*$/;
const KEYWORDS = new Set(('and break do else elseif end false for function goto if in local nil ' +
  'not or repeat return then true until while').split(' '));

// Generated keys, in the order they are written.
const KEYS = ['Menu', 'Menu name', 'Function', 'Holder', 'Kind', 'Aggregation', 'Args', 'Returns', 'Return fields', 'Since', 'Versions', 'Removed', 'Seen at', 'Added by'];

// A call-site expression -> a parameter name an editor can show. `menu.infoFrame`
// is `infoFrame`, `menu.actions[subsection.id]` is `actions`, a literal is positional.
function paramName(expr, i) {
  let e = String(expr).trim();
  if (/^["']/.test(e)) {
    const lit = e.replace(/^["']|["']$/g, '');
    return IDENT.test(lit) && !KEYWORDS.has(lit) ? lit : 'arg' + i;
  }
  e = e.replace(/\([^)]*\)/g, '').replace(/\[[^\]]*\]/g, '');
  const segs = e.split(/[.:]/).map(s => s.trim()).filter(Boolean);
  const last = segs[segs.length - 1] || '';
  const m = /([A-Za-z_]\w*)\s*$/.exec(last);
  if (!m) return 'arg' + i;
  const n = m[1];
  return IDENT.test(n) && !KEYWORDS.has(n) ? n : 'arg' + i;
}

function uniqueNames(exprs) {
  const seen = new Map();
  return exprs.map((e, i) => {
    let n = paramName(e, i + 1);
    if (seen.has(n)) { const c = seen.get(n) + 1; seen.set(n, c); n = n + c; } else seen.set(n, 1);
    return n;
  });
}

// ---- emit ----------------------------------------------------------------

function emitEntry(e, authored) {
  const a = authored || {};
  const out = [];
  const gen = (k, v) => { if (v !== null && v !== undefined && v !== '') out.push(`-- ${k}: ${v}`); };

  gen('Menu', e.addon ? `${e.menu} (${e.addon})` : e.menu);
  gen('Menu name', e.menuName);
  gen('Function', e.func);
  gen('Holder', e.holder);
  gen('Kind', e.kind);
  gen('Aggregation', e.aggregation);
  gen('Args', e.args.length ? e.args.join(', ') : 'none');
  if (e.targets && e.targets.length) gen('Returns', e.targets.join(', '));
  if (e.returnFields && e.returnFields.length) gen('Return fields', e.returnFields.join(', '));
  gen('Since', e.since);
  gen('Versions', e.versions.join(', '));
  gen('Removed', e.removed);
  gen('Seen at', e.seenAt);
  gen('Added by', e.attribution);

  const prose = (a.prose && a.prose.length) ? a.prose : [];
  for (const p of prose) out.push(`--- ${p}`.trimEnd());
  if (!prose.length) out.push('---');

  const names = uniqueNames(e.args);
  names.forEach((n, i) => {
    const t = (a.params && a.params[n]) || '';
    out.push(`---@param ${n} any${t ? ' # ' + t : ''}`);
  });
  if (e.kind === 'override') {
    const t = a.ret || '';
    out.push(`---@return any${t ? ' # ' + t : ''}`);
  }
  out.push(`function ${e.menu}.${e.name}(${names.join(', ')}) end`);
  return out.join('\n');
}

function emit(byMenu, header) {
  const parts = [header.trimEnd(), '', '---@meta', ''];
  for (const menu of [...byMenu.keys()].sort()) {
    parts.push(`---@class uix.${menu}`, `local ${menu} = {}`, '');
    const entries = byMenu.get(menu);
    for (const e of entries) { parts.push(e.text, ''); }
  }
  return parts.join('\n').replace(/\n{3,}/g, '\n\n').trimEnd() + '\n';
}

// ---- parse ---------------------------------------------------------------

// Read a meta file back into { menu -> [entry] }. Used to carry the authored half
// across a regeneration, and by the site to build the page.
function parse(src) {
  const lines = src.replace(/^﻿/, '').split(/\r?\n/);
  const out = new Map();
  let block = [];

  for (const line of lines) {
    const t = line.trim();
    if (t.startsWith('--')) { block.push(t); continue; }
    const fn = /^function\s+([A-Za-z_]\w*)\.([A-Za-z_]\w*)\s*\(([^)]*)\)\s*end\s*$/.exec(t);
    if (!fn) { if (t) block = []; continue; }

    const [, menu, name, argstr] = fn;
    const entry = { menu, name, keys: {}, prose: [], params: {}, ret: '', paramOrder: [] };
    for (const b of block) {
      const kv = /^--\s([A-Za-z][A-Za-z ]*?):\s*(.*)$/.exec(b);
      if (kv && KEYS.includes(kv[1])) { entry.keys[kv[1]] = kv[2]; continue; }
      const p = /^---@param\s+([A-Za-z_]\w*)\s+\S+(?:\s*#\s*(.*))?$/.exec(b);
      if (p) { entry.paramOrder.push(p[1]); if (p[2]) entry.params[p[1]] = p[2].trim(); continue; }
      const r = /^---@return\s+\S+(?:\s*#\s*(.*))?$/.exec(b);
      if (r) { if (r[1]) entry.ret = r[1].trim(); continue; }
      if (/^---@/.test(b)) continue;
      const pr = /^---\s?(.*)$/.exec(b);
      if (pr && pr[1].trim()) entry.prose.push(pr[1].trimEnd());
    }
    entry.args = argstr.split(',').map(s => s.trim()).filter(Boolean);
    if (!out.has(menu)) out.set(menu, []);
    out.get(menu).push(entry);
    block = [];
  }
  return out;
}

// The authored half only, keyed menu::name, for carrying across a regeneration.
function authoredFrom(src) {
  const m = new Map();
  for (const [menu, entries] of parse(src)) {
    for (const e of entries) {
      if (e.prose.length || Object.keys(e.params).length || e.ret) {
        m.set(menu + '::' + e.name, { prose: e.prose, params: e.params, ret: e.ret });
      }
      // Since is written once and then owned by the file, not by the extraction.
      if (e.keys.Since) {
        const k = menu + '::' + e.name;
        m.set(k, Object.assign(m.get(k) || { prose: [], params: {}, ret: '' }, { since: e.keys.Since }));
      }
    }
  }
  return m;
}

module.exports = { emit, emitEntry, parse, authoredFrom, paramName, uniqueNames, KEYS };
