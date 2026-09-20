'use strict';

// The game delta, read out of the four references rather than written down.
//
//   node sources.js              prints what the Changes page will say
//   require('./sources')         returns { references }
//
// Every reference on this site already carries, per row, which of the covered versions
// has it. Nothing aggregated that, so the one question a reader actually arrives with -
// "what changed for me between 8.00 and 9.00" - had no page. This module answers it by
// reading the same committed data each reference builds from, through the same parsers,
// so the page cannot disagree with the reference it links into and cannot go stale.
//
// The delta is always between the last two versions a reference covers. A reference
// with one version contributes nothing rather than failing the build - that is what a
// brand new dataset looks like, not damage.
//
// Every name the page prints is a deep link into the reference that owns it, so every
// name needs an anchor over there. build-html.js checks that against the built pages
// and fails if one is missing; what a group can and cannot link is decided here.

const fs = require('fs');
const path = require('path');

const SRC = path.join(__dirname, '..');

/* ---------------------------------------------------------------- shared */

// The two versions a delta is taken between, newest last.
const pair = (versions) => (versions.length > 1 ? versions.slice(-2) : null);

// A version token is the version with its separators removed, which is what each
// reference's own filter uses.
const tok = (v) => 'v' + String(v).replace(/[.\s]/g, '');

// Most datasets stamp only the exceptions: no `v` means every covered version has it.
const tokens = (v, versions) => (v ? String(v).split(/\s+/) : versions.map(tok));

// A row id has to be built the way the reference that owns it builds it, or the deep
// link lands nowhere. Each reference's own escaping is reproduced by its caller.
const idFn = (prefix, keep) => (key) =>
  prefix + '-' + String(key).replace(new RegExp(`[^a-zA-Z0-9${keep}]`, 'g'), '_');

// First sentence, for a chip's tooltip. Long prose in a title attribute is unreadable.
const firstSentence = (s) => {
  const t = String(s || '').replace(/\s+/g, ' ').trim();
  const m = t.match(/^([\s\S]*?[.!?])(\s|$)/);
  return (m ? m[1] : t).slice(0, 220);
};

// added/removed/from/to for one countable kind of thing, out of rows of
// { name, toks, title, key } - key being what the reference anchors the row by, which
// is not the displayed name wherever a name alone is not unique.
function group(label, singular, url, anchor, rows, versions) {
  const [tPrev, tCur] = pair(versions).map(tok);
  const g = { label, singular, from: 0, to: 0, added: [], removed: [] };
  for (const r of rows) {
    const inPrev = r.toks.includes(tPrev), inCur = r.toks.includes(tCur);
    if (inPrev) g.from++;
    if (inCur) g.to++;
    const it = { name: r.name, href: url + '#' + anchor(r.key || r.name), title: r.title || '' };
    if (!inPrev && inCur) g.added.push(it);
    if (inPrev && !inCur) g.removed.push(it);
  }
  const byName = (a, b) => a.name.toLowerCase().localeCompare(b.name.toLowerCase());
  g.added.sort(byName);
  g.removed.sort(byName);
  return g;
}

/* --------------------------------------------------------- Lua globals */

function globals() {
  const DATA = require('../globals/classification.json');
  const { docs, summaryOf } = require('../globals/docs.js');
  const { names } = require('../globals/page-manifest.js');

  const URL = '/x4/modding-support/ui-modding/lua-globals/';
  const versions = ['8.00', '9.00'];
  const [prev, cur] = pair(versions);
  const anchor = (n) => 'g-' + n;
  const tip = (n) => summaryOf(docs[n]);

  // Presence here is measured, not inferred from a stamp: classification.json records
  // per version whether the name was in the namespace at all.
  const present = (n, v) => Boolean(DATA[n].versions && DATA[n].versions[v] && DATA[n].versions[v].present);
  const g = { label: 'globals', singular: 'global', from: 0, to: 0, added: [], removed: [] };
  const neither = [];
  for (const n of names) {
    const a = present(n, prev), b = present(n, cur);
    if (a) g.from++;
    if (b) g.to++;
    const it = { name: n, href: URL + '#' + anchor(n), title: tip(n) };
    if (!a && b) g.added.push(it);
    if (a && !b) g.removed.push(it);
    if (!a && !b) neither.push(n);
  }

  // Two things no count shows. A name can stay in the namespace and still change for a
  // mod author: the engine can retire it, or a Lua state that could not see it can
  // start to.
  const changes = [];
  for (const n of names) {
    if (!present(n, prev) || !present(n, cur)) continue;
    const areas = (v) => (DATA[n].versions[v].areas || []).slice().sort();
    const [a, b] = [areas(prev), areas(cur)];
    if (a.join('+') !== b.join('+')) {
      changes.push({
        name: n, href: URL + '#' + anchor(n), tone: 'new',
        text: `visible to ${a.join(' and ') || 'nothing'} in ${prev}, to ${b.join(' and ')} in ${cur}`,
      });
    }
  }
  // "Deprecated: 9.00 - ..." is hand-written into globals.lua and opens with the version
  // that retired the global, so a tag opening with the newer version belongs to this
  // delta and an older one does not.
  for (const n of names) {
    const d = docs[n] && docs[n].deprecated;
    if (d && String(d).trim().startsWith(cur)) {
      changes.push({
        name: n, href: URL + '#' + anchor(n), tone: 'gone',
        text: 'deprecated in ' + cur + ': ' + firstSentence(String(d).replace(/^\S+\s*-\s*/, '')),
      });
    }
  }
  changes.sort((a, b) => a.name.localeCompare(b.name));

  const builds = {};
  for (const v of versions) {
    const e = names.map((n) => DATA[n].versions && DATA[n].versions[v]).find((x) => x && x.build);
    if (e) builds[v] = (/\((\d+)\)/.exec(e.build) || [])[1] || '';
  }

  return {
    key: 'globals', title: 'Lua Globals Reference', url: URL,
    what: 'the names X4 puts into the global namespace of UI Lua code',
    versions, from: prev, to: cur, builds,
    groups: [g], changes,
    // 805 cards, 802 of them in 9.00: the rest are names the reference documents and
    // neither version has. They are not a removal and must not be counted as one.
    footnote: neither.length
      ? `${neither.length} further ${neither.length === 1 ? 'name is' : 'names are'} documented and present in neither version: ` +
        neither.map((n) => `<code>${n}</code>`).join(', ') + '.'
      : '',
  };
}

/* ------------------------------------------------- C functions and types */

function cFunctions() {
  const { parse } = require('../c-functions-and-structures/meta.js');
  const DIR = path.join(SRC, 'c-functions-and-structures');
  const meta = JSON.parse(fs.readFileSync(path.join(DIR, 'data', 'meta.json'), 'utf8'));
  const src = parse(fs.readFileSync(path.join(DIR, 'c-functions.lua'), 'utf8'), meta.versions);

  const URL = '/x4/modding-support/ui-modding/c-functions-and-structures/';
  const versions = meta.versions;
  const rows = (obj) => Object.entries(obj)
    .map(([name, e]) => ({ name, toks: tokens(e.v, versions), title: e.decl || '' }));

  return {
    key: 'c-functions', title: 'C functions and structures', url: URL,
    what: 'everything X4 exposes to UI Lua through <code>ffi.C</code>',
    versions, from: pair(versions)[0], to: pair(versions)[1],
    groups: [
      group('functions', 'function', URL, idFn('f', '_~-'), rows(src.functions), versions),
      group('types', 'type', URL, idFn('t', '_~-'), rows(src.types), versions),
    ],
    changes: [],
    // The meta file records which versions declare a name, not what the declaration
    // said in each of them, so this page can say a function is still there and cannot
    // say its signature is unchanged.
    footnote: 'A function present in both versions is not thereby unchanged: the reference ' +
      'carries one declaration per name, so a signature that moved between versions leaves no trace here.',
  };
}

/* ---------------------------------------------------- script commands */

function commands() {
  const DIR = path.join(SRC, 'commands', 'data');
  const read = (f) => JSON.parse(fs.readFileSync(path.join(DIR, f + '.json'), 'utf8'));
  const meta = read('meta');
  const [cmds, groups, params, types] = ['commands', 'groups', 'params', 'types'].map(read);

  const URL = '/x4/modding-support/scripting-md-libraries-map/script-commands/';
  const versions = meta.versions;
  const [tPrev, tCur] = pair(versions).map(tok);
  const cid = idFn('c', '_~-');
  const rows = (obj, filter) => Object.entries(obj)
    .filter(([, e]) => (filter ? filter(e) : true))
    .map(([name, e]) => ({ name, toks: tokens(e.v, versions), title: firstSentence(e.doc) }));

  // A command that is in both versions and changed shape. This is the half of the
  // delta a version filter cannot show - `find_resource` losing `snap` breaks a script
  // that still parses - and nothing on the reference aggregates it.
  const changes = [];
  for (const [name, c] of Object.entries(cmds)) {
    if (c.v) continue;
    const add = [], rem = [];
    for (const [a, d] of Object.entries(c.attrs || {})) {
      if (d.v === tCur) add.push(a);
      if (d.v === tPrev) rem.push(a);
    }
    // A child element is listed by the command that accepts it: the reference renders
    // one inside its parent's card and gives it no anchor of its own.
    for (const p of c.params || []) {
      const d = params[p];
      if (!d) continue;
      if (d.v === tCur) add.push('&lt;' + d.name + '&gt;');
      if (d.v === tPrev) rem.push('&lt;' + d.name + '&gt;');
    }
    if (!add.length && !rem.length) continue;
    const part = [];
    if (rem.length) part.push('dropped ' + rem.map((s) => `<code>${s}</code>`).join(', '));
    if (add.length) part.push('gained ' + add.map((s) => `<code>${s}</code>`).join(', '));
    changes.push({
      name, href: URL + '#' + cid(name), tone: rem.length ? 'gone' : 'new',
      text: part.join('; '), html: true,
    });
  }
  changes.sort((a, b) => (b.tone === 'gone') - (a.tone === 'gone') || a.name.localeCompare(b.name));

  return {
    key: 'commands', title: 'Script commands', url: URL,
    what: 'the actions and conditions the Mission Director and AI script schemas accept',
    versions, from: pair(versions)[0], to: pair(versions)[1],
    groups: [
      group('actions', 'action', URL, cid, rows(cmds, (e) => e.kind === 'action'), versions),
      group('conditions', 'condition', URL, cid, rows(cmds, (e) => e.kind === 'condition'), versions),
      group('attribute groups', 'attribute group', URL, idFn('g', '_~-'), rows(groups), versions),
      group('types', 'type', URL, idFn('t', '_~-'), rows(types), versions),
    ],
    changes,
    // params.json is deliberately not a group of its own: a child element has no anchor
    // to link to, and every one that changed here is either a condition already listed
    // or an addition to a command, which is what the changed-command list carries.
    footnote: 'Child elements are counted inside the command that accepts them rather than on their own.',
  };
}

/* -------------------------------------------------------- UIX callbacks */

function uixCallbacks() {
  const { parse } = require('../uix-callbacks/meta.js');
  const DIR = path.join(SRC, 'uix-callbacks');
  const meta = JSON.parse(fs.readFileSync(path.join(DIR, 'data', 'meta.json'), 'utf8'));
  const byMenu = parse(fs.readFileSync(path.join(DIR, 'uix-callbacks.lua'), 'utf8'));

  const URL = '/x4/modding-support/ui-modding/uix-callbacks/';
  const versions = meta.versions.map((v) => v.version);
  const entries = [];
  for (const list of byMenu.values()) entries.push(...list);

  // The key is (menu, name) - `cleanup` is dispatched in ten menus - so the anchor is
  // built from the pair and the chip shows the pair.
  const rows = entries.map((e) => ({
    name: e.menu + '.' + e.name,
    key: e.menu + '-' + e.name,
    toks: String(e.keys.Versions || '').split(',').map((s) => tok(s.trim())).filter((s) => s !== 'v'),
    title: firstSentence((e.prose || []).join(' ')),
  }));

  return {
    key: 'uix-callbacks', title: 'UIX callbacks', url: URL,
    what: "the callbacks kuertee's UI Extensions puts into X4's menus",
    // Not the game's clock: UIX ships on its own releases, so its delta is between two
    // of those and only lines up with 8.00 and 9.00 because the mod follows the game.
    clock: 'mod',
    versions, from: pair(versions)[0], to: pair(versions)[1],
    groups: [group('callbacks', 'callback', URL, idFn('c', '_-'), rows, versions)],
    changes: [],
  };
}

/* ------------------------------------------------------------- assembly */

const references = [globals(), cFunctions(), commands(), uixCallbacks()];

module.exports = { references };

if (require.main === module) {
  const strip = (s) => String(s).replace(/<[^>]*>/g, '').replace(/&lt;/g, '<').replace(/&gt;/g, '>');
  for (const r of references) {
    console.log(`\n${r.title}  ${r.from} -> ${r.to}${r.clock === 'mod' ? "  (the mod's own releases)" : ''}`);
    for (const g of r.groups) {
      console.log(`  ${g.label}: ${g.from} -> ${g.to}   +${g.added.length} -${g.removed.length}`);
      if (g.removed.length) console.log('    gone: ' + g.removed.map((i) => i.name).join(', '));
    }
    for (const c of r.changes) console.log(`  changed: ${c.name} - ${strip(c.text)}`);
    if (r.footnote) console.log('  note: ' + strip(r.footnote));
  }
}
