// globals.lua -> the prose half of the reference: description, parameters,
// returns, overloads and the widget_fullscreen mapping, per declared name.
//
//   node docs.js                 parses and reports coverage
//   require('./docs')            returns { docs, versions }
//
// classification.json says what a global IS; this says what it DOES. Only the
// 727 names declared in globals.lua have any of it - the 83 the measurement
// added carry no text at all, and the pages say so rather than inventing it.

const fs = require('fs');
const path = require('path');
const { excluded } = require('./exclusions');

const SRC = path.join(__dirname, 'globals.lua');

// Lines that are bookkeeping from the generator that wrote globals.lua, not prose.
const META = [
  [/^Global access to (.+)$/, 'access'],
  [/^Mapped from:\s*(.+)$/, 'mapped'],
  [/^Source:\s*(.+)$/, 'source'],
  // The engine restores a <savedvariable> before its script runs, so the global
  // already holds the last session's value. That deserves a badge of its own.
  [/^Saved variable:\s*(\S+)$/, 'saved'],
  [/^Since:\s*(.+)$/, 'since'],
  // Written by write-meta.js from the measured data, never by hand: which Lua
  // environment sees the global, and what vanilla's own call sites say about it.
  [/^Environment:\s*(.+)$/, 'env'],
  [/^Versions:\s*(.+)$/, 'versions'],
  [/^Usage:\s*(.+)$/, 'usage'],
  [/^Seen at:\s*(.+)$/, 'seenAt'],
];

// Three description separators occur in the file: " -- ", LuaLS's " # ", and
// nothing at all. Split on whichever is there, and fall back to position.
function splitDash(s) {
  const m = s.match(/^([\s\S]*?)\s+(?:--|#)\s*([\s\S]*)$/);
  return m ? [m[1], m[2].trim()] : [s, ''];
}

// A type is one token, except that a comma keeps the list going:
// "number, number, number, number" is one return type, not four.
function splitTypeRest(s) {
  const toks = s.trim().split(/\s+/).filter(Boolean);
  if (!toks.length) return ['', ''];
  const type = [toks.shift()];
  while (type[type.length - 1].endsWith(',') && toks.length) type.push(toks.shift());
  return [type.join(' '), toks.join(' ')];
}

function parseParam(rest) {
  const m = rest.match(/^([A-Za-z_][\w]*)(\??)\s*([\s\S]*)$/);
  if (!m) return null;
  const [body, dashed] = splitDash(m[3]);
  const [type, tail] = splitTypeRest(body);
  return { name: m[1], optional: m[2] === '?', type: type || 'any', desc: dashed || tail.trim() };
}

// "---@return string localizedName -- desc", "---@return number, number -- desc",
// "---@return number qualityOption The current setting.", "---@return any".
function parseReturn(rest) {
  const [body, dashed] = splitDash(rest);
  const [type, tail] = splitTypeRest(body);
  const toks = tail.trim().split(/\s+/).filter(Boolean);
  const name = toks.length && /^[A-Za-z_][\w]*$/.test(toks[0]) ? toks.shift() : '';
  return { type, name, desc: dashed || toks.join(' ') };
}

function parse() {
  const lines = fs.readFileSync(SRC, 'utf8').replace(/^﻿/, '').split(/\r?\n/);
  const docs = {};
  const fresh = () => ({ prose: [], params: [], returns: [], overloads: [], meta: {} });
  let b = fresh();
  // A ---@class block sits above the doc comment with a blank line between, so
  // it has to outlive the block reset and clear only when a name is emitted.
  let classes = [];

  for (const raw of lines) {
    const line = raw.trim();

    // "--- @param" with a space parses in LuaLS and used to land here as prose,
    // taking the parameter list of 71 entries with it. Read both forms.
    if (/^---\s*@/.test(line)) {
      const [, tag, rest = ''] = line.match(/^---\s*@(\w+)\s*([\s\S]*)$/) || [];
      if (tag === 'param') { const p = parseParam(rest); if (p) b.params.push(p); }
      else if (tag === 'return') b.returns.push(parseReturn(rest));
      else if (tag === 'overload') b.overloads.push(rest.trim());
      else if (tag === 'class') classes.push({ name: rest.trim(), fields: [] });
      else if (tag === 'field') {
        const f = parseParam(rest);
        if (f && classes.length) classes[classes.length - 1].fields.push(f);
      }
      continue;
    }

    if (line.startsWith('--')) {
      const text = line.replace(/^-{2,}\s?/, '').trim();
      if (!text) continue;
      const hit = META.find(([re]) => re.test(text));
      if (hit) b.meta[hit[1]] = text.match(hit[0])[1].trim();
      else b.prose.push(text);
      continue;
    }

    const fn = line.match(/^function\s+([A-Za-z_][\w]*)\s*\(([^)]*)\)/);
    const va = line.match(/^([A-Za-z_][\w]*)\s*=\s*(.+)$/);
    if (fn || va) {
      const name = (fn || va)[1];
      const args = fn ? fn[2].split(',').map(s => s.trim()).filter(Boolean) : null;
      docs[name] = {
        name,
        signature: fn ? `${name}(${args.join(', ')})` : `${name} = ${va[2].replace(/\s*$/, '')}`,
        args,
        prose: b.prose.join(' '),
        params: b.params,
        returns: b.returns.filter(r => r.type !== 'nil' || r.desc),
        overloads: b.overloads,
        classes,
        source: b.meta.source ? b.meta.source.replace(/\\/g, '/') : null,
        mapped: b.meta.mapped || null,
        saved: b.meta.saved || null,
        since: b.meta.since || null,
        env: b.meta.env || null,
        versions: b.meta.versions || null,
        usage: b.meta.usage || null,
        seenAt: b.meta.seenAt ? b.meta.seenAt.split(/,\s*/) : [],
      };
      b = fresh();
      classes = [];
      continue;
    }

    // A blank or unrecognised line ends the block, so stray prose never
    // attaches itself to whatever is declared next.
    if (!line) b = fresh();
  }

  return docs;
}

const docs = parse();
// globals.lua documents a few non-X4 names so the editor completes them; they never
// reach the reference. See exclusions.js.
for (const n of excluded) delete docs[n];

// First sentence of the prose, for the index table's Summary column.
function summaryOf(d) {
  if (!d || !d.prose) return '';
  const m = d.prose.match(/^([\s\S]*?[.!?])(\s|$)/);
  return (m ? m[1] : d.prose).trim();
}

module.exports = { docs, summaryOf };

if (require.main === module) {
  const all = Object.values(docs);
  const n = (f) => all.filter(f).length;
  console.log('declared parsed:  ' + all.length);
  console.log('  with prose:     ' + n(d => d.prose));
  console.log('  with params:    ' + n(d => d.params.length));
  console.log('  with returns:   ' + n(d => d.returns.length));
  console.log('  with overloads: ' + n(d => d.overloads.length));
  console.log('  with classes:   ' + n(d => d.classes.length));
  console.log('  mapped to widgetSystem: ' + n(d => d.mapped));
  const bare = all.filter(d => !d.prose).map(d => d.name);
  console.log('  no prose at all: ' + (bare.length ? bare.join(', ') : 'none'));

  const CLS = require('./classification.json');
  const declared = Object.keys(CLS).filter(k => CLS[k].declared);
  const missing = declared.filter(k => !docs[k]);
  const extra = Object.keys(docs).filter(k => !CLS[k]);
  console.log('\nclassification says declared: ' + declared.length);
  console.log('  not parsed here: ' + (missing.length ? missing.join(', ') : 'none'));
  console.log('  parsed but unclassified: ' + (extra.length ? extra.join(', ') : 'none'));
}
