// The deliverable: the 44 XWiki 2.1 pages, one file each, in wiki/.
//
//   node build-wiki.js                 -> wiki/*.xwiki + wiki/_pages.md
//   BADGE_MODE=solid node build-wiki.js    other badge style (see badges.js)
//   LINK_STYLE=absolute node build-wiki.js full paths instead of relative links
//
// Layout is variant B, settled in lab/: a scannable index table, then one
// detail card per global. The index page carries the legend and the 810-row
// master table; every content page links back up to it.

const fs = require('fs');
const path = require('path');

const { pages, WIKI, DATA, names } = require('./page-manifest.js');
const { docs, summaryOf } = require('./docs.js');
const { badge, colorText, MODE, BSEP } = require('./badges.js');
const { verdicts } = require('./usage.js');

const VERSIONS = ['8.00', '9.00'];
const OUT = path.join(__dirname, 'wiki');

/* ---------------------------------------------------------------- links */

// Relative by default. Every content page is a terminal page inside the parent's
// space, so a bare page name resolves sideways from the index down to a child,
// and "WebHome" - the space's own home document - resolves from a child back up
// to the parent. Absolute paths would all break the next time the parent page is
// renamed; LINK_STYLE=absolute switches the whole set if that is ever wanted.
const LINK_STYLE = process.env.LINK_STYLE || 'relative';
const FULL = WIKI.space.split('/').join('.') + '.' + WIKI.parent;

const refDown = (page) => LINK_STYLE === 'absolute' ? FULL + '.' + page.name : page.name;
const refUp = () => LINK_STYLE === 'absolute' ? FULL + '.WebHome' : 'WebHome';

const link = (label, ref, anchor) =>
  `[[${label}>>doc:${ref}${anchor ? `||anchor="${anchor}"` : ''}]]`;
const anchorLink = (label, anchor) => `[[${label}>>||anchor="${anchor}"]]`;

const anchorOf = (name) => 'g-' + name;

/* -------------------------------------------------- text -> XWiki 2.1 */

// The prose in globals.lua is plain text with backticked code spans.
function x(s) {
  if (s === undefined || s === null) return '';
  return String(s)
    .replace(/`([^`]+)`/g, (_, t) => '##' + t + '##')
    .replace(/__/g, '~_~_')     // __EGO_GLOBALS would render as underline
    .replace(/\|/g, '~|')       // a pipe ends a table cell
    .replace(/^-/, '~-');       // a leading dash starts a list
}

const mono = (s) => '##' + String(s).replace(/__/g, '~_~_').replace(/\|/g, '~|') + '##';

// A cell whose content opens with "(%" is parsed as cell *parameters*, so any
// cell starting with a badge needs a "(%%)" guard first.
const cell = (c) => String(c).startsWith('(%') ? '(%%)' + c : String(c);

const NL = ' \\\\ ';   // line break inside a cell

/* ------------------------------------------------------------- badges */

const ORIGIN = {
  engine: () => badge('engine', 'engine'),
  widget: () => badge('widget', 'widget_fullscreen'),
  addon: () => badge('addon', 'addon'),
  core: () => badge('new', 'core'),
};

const SCOPE = {
  all: ['ok', 'addons + core'],
  addons: ['addon', 'addons only'],
  core: ['new', 'core only'],
  none: ['gone', 'does not exist'],
};
const scopeBadge = (s, short) => {
  const [tone, label] = SCOPE[s] || SCOPE.none;
  return badge(tone, short ? label.replace(' only', '').replace('does not exist', 'absent') : label);
};

const KIND = (k) => badge(k === 'function' ? 'no' : 'warn', k);

// A <savedvariable> in the owning addon's ui.xml. The engine restores it before the
// script runs, so the global already holds the last session's value - the one case
// where a global is not empty on the first line of the script that creates it.
const savedOf = (name) => (docs[name] && docs[name].saved) || null;
const savedBadge = (name) => {
  const st = savedOf(name);
  return st ? badge('warn', 'saved: ' + st) : null;
};

// What vanilla's own code says about the declaration. Engine globals only:
// everything else is defined in a file this reference already names, which is
// stronger evidence than a call site. See usage.js for how the verdict is made.
const USAGE = {
  confirmed: ['ok', 'confirmed'],
  disputed: ['gone', 'disputed'],
  unverified: ['warn', 'unverified'],
};
function usageBadge(name) {
  const e = DATA[name], u = verdicts[name];
  if (!u || e.origin !== 'engine') return null;
  const [tone, label] = USAGE[u.verdict];
  return badge(tone, (e.group === 'function' ? 'signature: ' : 'usage: ') + label);
}

function usageCell(name) {
  const u = verdicts[name];
  const [tone, label] = USAGE[u.verdict];
  const bits = [badge(tone, label) + ' — ' + x(u.detail)];
  const seen = [];
  for (const st of u.sites) {
    const at = st.rel + ':' + st.line;
    if (!seen.includes(at)) seen.push(at);
  }
  if (seen.length) bits.push('Seen at ' + seen.map(mono).join(', '));
  return bits.join(NL);
}

// Present / absent / new, per version, as measured in the game.
function verState(name, v) {
  const e = DATA[name];
  const s = e.versions[v];
  if (!s || !s.present) return { tone: 'no', tick: '—', text: 'absent' };
  if (e.delta === 'new in ' + v) return { tone: 'new', tick: 'NEW', text: 'NEW in ' + v };
  return { tone: 'ok', tick: '✓', text: 'present' };
}

// Chem's requirement: one line per version, always both, never collapsed.
function versCell(name, { tick = false } = {}) {
  return VERSIONS.map(v => {
    const s = verState(name, v);
    if (tick) return '**' + v + '** ' + badge(s.tone, s.tick);
    const areas = DATA[name].versions[v].areas || [];
    const where = areas.length ? ' — ' + areas.join(' + ') : '';
    return '**' + v + '** ' + badge(s.tone, s.text) + (s.tone === 'no' ? '' : where);
  }).join(NL);
}

/* -------------------------------------------------------- entry fields */

const isDocumented = (name) => !!(docs[name] && docs[name].prose);

function summaryCell(name) {
  const e = DATA[name];
  if (e.note) return colorText('warn', '⚠ ' + x(e.note));
  const sv = savedBadge(name);
  const s = summaryOf(docs[name]);
  const body = s ? x(s) : colorText('warn', 'undocumented');
  return sv ? sv + ' ' + body : body;
}

function originCell(name, { compact = false } = {}) {
  const e = DATA[name];
  const b = (ORIGIN[e.origin] || ORIGIN.engine)();
  if (compact) return b;

  // One line per distinct definition site, with the line numbers of every
  // version behind it. A file that assigns the same name twice is one site,
  // not two identical rows.
  const sites = new Map();
  for (const v of VERSIONS) {
    for (const d of e.defs[v] || []) {
      const k = d.rel + '|' + d.via + '|' + (d.impl || '');
      if (!sites.has(k)) sites.set(k, { d, lines: {} });
      const s = sites.get(k).lines;
      (s[v] = s[v] || []).push(d.line);
    }
  }

  const bits = [];
  for (const { d, lines } of sites.values()) {
    const where = VERSIONS
      .filter(v => lines[v])
      .map(v => v + ' ' + lines[v].map(l => mono(':' + l)).join(' '))
      .join(', ');
    let s = mono(d.rel);
    if (d.via === 'AddGlobalAccess') s += ' — ##AddGlobalAccess## → ' + mono(d.impl || '?');
    else if (d.via === 'MakeGlobalAvailable') s += ' — ##MakeGlobalAvailable##';
    else if (d.via === 'function') s += ' — top-level ##function##';
    else if (d.via === 'assignment') s += ' — table assignment';
    bits.push(s + (where ? ' (' + where + ')' : ''));
  }
  if (!sites.size) bits.push('//injected by the executable; defined in no ##.lua## file//');

  if (e.overrides && e.overrides.length) {
    const o = e.overrides[e.overrides.length - 1];
    bits.push(colorText('warn', '⚠ vanilla replaces it at runtime') + ' — ' + mono(o.rel + ':' + o.line));
  }
  const d = docs[name];
  if (d && d.mapped) bits.push('maps to ' + mono(d.mapped));
  return b + NL + bits.join(NL);
}

function availCell(name, { compact = false } = {}) {
  const e = DATA[name];
  const b = scopeBadge(e.scope, compact);
  if (compact) return b;
  const used = e.usedIn && e.usedIn.length
    ? 'vanilla calls it from ' + e.usedIn.join(' + ')
    : '//no vanilla call site in either version//';
  return b + NL + used;
}

function paramLine(p) {
  let l = mono(p.name) + ' //' + x(p.type) + '//';
  if (p.optional) l += BSEP + badge('warn', 'optional');
  return p.desc ? l + ' — ' + x(p.desc) : l;
}

function returnLine(r) {
  const head = (r.name ? mono(r.name) + ' ' : '') + '//' + x(r.type) + '//';
  return r.desc ? head + ' — ' + x(r.desc) : head;
}

// Only the declared names have a real signature; for the rest the measurement gives
// a type and nothing else, so the block says that instead of inventing arity.
function signature(name) {
  const d = docs[name];
  if (d) return d.signature;
  const e = DATA[name];
  return e.group === 'function'
    ? name + '(...)  -- parameters unknown'
    : name + '  -- ' + e.kind;
}

/* ---------------------------------------------------------- the card */

function card(name) {
  const e = DATA[name];
  const d = docs[name];
  const out = [];

  out.push(`{{id name="${anchorOf(name)}"/}}`);
  out.push('');
  out.push('=== ' + name.replace(/__/g, '~_~_') + ' ===');
  out.push('');

  const head = [KIND(e.kind), (ORIGIN[e.origin] || ORIGIN.engine)(), scopeBadge(e.scope)];
  for (const v of VERSIONS) {
    const s = verState(name, v);
    head.push(badge(s.tone, v + (s.tick === '✓' ? '' : ' ' + s.tick)));
  }
  const sv = savedBadge(name);
  if (sv) head.push(sv);
  const ub = usageBadge(name);
  if (ub) head.push(ub);
  if (!e.declared) head.push(badge('warn', 'not in globals.lua'));
  out.push(head.join(BSEP));
  out.push('');

  out.push('{{code language="lua"}}');
  out.push(signature(name));
  if (d && d.overloads.length) for (const o of d.overloads) out.push('-- overload: ' + o);
  out.push('{{/code}}');
  out.push('');

  if (e.note) {
    out.push(colorText('gone', '⚠ ' + x(e.note)));
    out.push('');
  }
  if (d && d.prose) {
    out.push(x(d.prose));
    out.push('');
  } else if (!e.note) {
    out.push(colorText('warn', '⚠ No description available.') + ' ' +
      (e.declared
        ? 'Declared in ##globals.lua## with no documentation text.'
        : 'Present in the running game, but no vanilla code mentions it, so nothing describes it.'));
    out.push('');
  }

  const rows = [['**Kind**', KIND(e.kind)]];
  if (d && d.classes.length) {
    for (const c of d.classes) {
      rows.push(['**' + x(c.name) + '**', c.fields.map(paramLine).join(NL) || '//no fields//']);
    }
  }
  if (e.group === 'function') {
    rows.push(['**Parameters**', d && d.params.length ? d.params.map(paramLine).join(NL) : '//none documented//']);
    rows.push(['**Returns**', d && d.returns.length ? d.returns.map(returnLine).join(NL) : '//none documented//']);
  }
  if (savedOf(name)) {
    rows.push(['**Saved variable**', badge('warn', savedOf(name)) + NL +
      'Declared as a ##<savedvariable>## in the addon\'s ##ui.xml##, so the engine restores ' +
      'it before that file runs. ' + (savedOf(name) === 'savegame'
        ? 'Stored in the savegame, so it travels with the save.'
        : 'Stored in ##userdata.xml##, so it is per player profile, not per save.')]);
  }
  rows.push(['**Origin**', originCell(name)]);
  rows.push(['**Availability**', availCell(name)]);
  rows.push(['**Game versions**', versCell(name)]);
  if (e.origin === 'engine') rows.push(['**Vanilla usage**', usageCell(name)]);

  out.push('|=Attribute|=Value');
  for (const [k, v] of rows) out.push('|' + k + '|' + cell(v));
  out.push('');
  out.push(anchorLink('↑ back to the index of this page', 'page-index') + ' · ' +
    link('↑ ' + WIKI.parent, refUp()));
  return out.join('\n');
}

/* ---------------------------------------------------------- the pages */

const content = pages.filter(p => p.kind !== 'index');

function contentPage(p) {
  const out = [];
  out.push('= ' + p.heading + ' =');
  out.push('');
  // The name range lives here, never in the page name: it moves whenever a
  // global is added or removed, and a page name that moved would break links.
  out.push('Covers ' + mono(p.first) + ' to ' + mono(p.last) + '.');
  out.push('');
  out.push(x(p.desc));
  out.push('');
  out.push('**' + p.members.length + '** globals on this page. ' +
    link('Back to ' + WIKI.parent, refUp()) + ' for the full index, the legend and the other ' +
    (content.length - 1) + ' pages.');
  out.push('');
  out.push('== Index ==');
  out.push('');
  out.push('{{id name="page-index"/}}');
  out.push('');
  out.push('|=Global|=Origin|=Availability|=Versions|=Summary');
  for (const n of p.members) {
    out.push('|' + anchorLink(mono(n), anchorOf(n)) +
      '|' + cell(originCell(n, { compact: true })) +
      '|' + cell(availCell(n, { compact: true })) +
      '|' + cell(versCell(n, { tick: true })) +
      '|' + cell(summaryCell(n)));
  }
  out.push('');
  out.push('== Details ==');
  out.push('');
  out.push(p.members.map(card).join('\n\n----\n\n'));
  out.push('');
  return out.join('\n');
}

/* ----------------------------------------------------------- the index */

const LEGEND = `== The two Lua environments ==

X4 runs UI Lua in **two separate environments**, and every row below says which of them a global lives in. They are separate global namespaces: a name in one is not automatically in the other.

|=Environment|=Runs|=Runtime
|**addons**|##ui/addons/*## — the menus, and ##ui/widget/lua/widget~_fullscreen.lua## with them|the **usual LuaJIT** the game embeds
|**core**|##ui/core/*## — the HUD: target monitor, radar, message ticker, crosshair|**Anark's LuaJIT**, the runtime built into the Anark presentation engine

That is why the core environment is where the scene-graph API belongs — ##self##, ##getElement##, ##setAttribute##, ##play##, ##Vector## — and why ##ui/core/*## code is written as an element behaviour (##function self:onInitialize()##) rather than as a menu. Most of that API is published into the addons environment as well, so the availability badge, not the origin, is what tells you where you can call something.

== How to read a row ==

|=Column|=Value|=Meaning
|(% rowspan="4" %)**Origin**|${cell(ORIGIN.engine())}|Injected by the game executable. Defined in no ##.lua## file — it simply exists. It cannot be replaced or wrapped, and it changes only with a game patch.
|${cell(ORIGIN.widget())}|Written in ##ui/widget/lua/widget~_fullscreen.lua##, then published either with ##AddGlobalAccess()## or as a plain top-level ##function##. That file runs in the addons Lua environment itself, so addon code reaches it directly.
|${cell(ORIGIN.addon())}|A top-level definition in one of the ##ui/addons/*## files, leaked into the shared addons Lua environment. A later-loading addon can monkey-patch it.
|${cell(ORIGIN.core())}|A top-level definition in a ##ui/core/*## HUD file, visible only inside the core Lua environment.
|(% rowspan="4" %)**Availability**|${cell(scopeBadge('all'))}|Present in both Lua environments: the addons one that ##ui/addons/*## menus run in, and the core one that ##ui/core/*## HUD code runs in.
|${cell(scopeBadge('addons'))}|Present only in the addons Lua environment. The core one runs separately and never sees it.
|${cell(scopeBadge('core'))}|Present only in the core Lua environment. These are the only globals addon code cannot reach.
|${cell(scopeBadge('none'))}|Declared in ##globals.lua## but absent from both measured Lua environments. See the note on the entry.
|(% rowspan="3" %)**Versions**|${cell(badge('ok', '✓'))}|Measured present in that version.
|${cell(badge('new', 'NEW'))}|Introduced in that version. Calling it on the older one is a nil-call crash — guard with ##if Name then##.
|${cell(badge('no', '—'))}|Measured absent in that version.

Availability and version presence are **verified in the game, not inferred from the code**: every row here reports what the addons Lua environment and the core one actually hold, on 8.00 and on 9.00.

== What vanilla's own code confirms ==

An engine global is injected by the executable, so no file declares its parameters: the signature shown for one is inherited from the older function list or inferred from how it is used. Every engine card therefore carries one more badge, saying what vanilla's own code proves about that signature. Every ##.lua## and ##.xpl## file of the extracted game was read, and every call of every global counted — together with how many arguments that call passes.

|=Badge|=What it means
|${cell(badge('ok', 'signature: confirmed'))}|Vanilla calls it, and every argument count it passes fits the parameter list shown. The card names the call sites, so you can read a real call.
|${cell(badge('gone', 'signature: disputed'))}|Vanilla calls it with an argument count the parameter list cannot take. The declaration is wrong, or an optional parameter is unmarked — believe the call site over the signature.
|${cell(badge('warn', 'signature: unverified'))}|No vanilla code calls it at all. Nothing here backs the signature: treat it as a starting point and check it in game before relying on it.

A variable is never called, so a mention is the only evidence there is; its badge counts vanilla references instead of call sites.

== Saved variables ==

A few of the addon globals carry an extra ${cell(badge('warn', 'saved: userdata'))} or ${cell(badge('warn', 'saved: savegame'))} badge. Those are a special case. The owning addon declares them as a ##<savedvariable>## in its ##ui.xml##, and the engine **restores the previous value before that file runs**. They are the only globals that already hold a value on the first line of the code that creates them, which is why vanilla creates every one of them with the ##X = X or { ... }## idiom instead of a plain assignment — a plain assignment would throw the restored value away.

##userdata## is kept in ##userdata.xml## and belongs to the player profile, so every savegame shares it. ##savegame## is kept inside the save and travels with it. A mod can persist its own globals the same way, by adding a ##<savedvariable>## line to its own ##ui.xml##.`;

function indexPage() {
  const counts = {
    engine: names.filter(n => DATA[n].origin === 'engine').length,
    widget: names.filter(n => DATA[n].origin === 'widget').length,
    addon: names.filter(n => DATA[n].origin === 'addon').length,
    core: names.filter(n => DATA[n].origin === 'core').length,
  };
  const undoc = names.filter(n => !isDocumented(n)).length;

  const out = [];
  out.push('= ' + WIKI.parent + ' =');
  out.push('');
  out.push('Every name X4: Foundations puts into the global namespace of X4 UI Lua code — what creates it, which of the two Lua environments can see it, and which game version has it.');
  out.push('');
  out.push(`**${names.length} globals** in 9.00: ${counts.engine} injected by the executable, ${counts.widget} from ##widget~_fullscreen.lua##, ${counts.addon} from an addon file, ${counts.core} from a core file. ${names.length - undoc} carry a description; ${undoc} do not.`);
  out.push('');
  out.push(LEGEND);
  out.push('');
  out.push('== The pages ==');
  out.push('');
  out.push('|=Page|=Globals|=Covers');
  for (const p of content) {
    out.push('|' + link(p.name, refDown(p)) + '|' + p.members.length +
      '|' + mono(p.first) + ' to ' + mono(p.last));
  }
  out.push('');
  out.push('== All globals ==');
  out.push('');
  out.push('|=Global|=Origin|=Availability|=Versions|=Summary');
  const home = {};
  for (const p of content) for (const n of p.members) home[n] = p;
  for (const n of names) {
    out.push('|' + link(mono(n), refDown(home[n]), anchorOf(n)) +
      '|' + cell(originCell(n, { compact: true })) +
      '|' + cell(availCell(n, { compact: true })) +
      '|' + cell(versCell(n, { tick: true })) +
      '|' + cell(summaryCell(n)));
  }
  out.push('');
  return out.join('\n');
}

/* ------------------------------------------------------------- write */

fs.mkdirSync(OUT, { recursive: true });
for (const f of fs.readdirSync(OUT)) if (f.endsWith('.xwiki')) fs.unlinkSync(path.join(OUT, f));

let total = 0;
const written = [];
function write(id, name, text) {
  const file = id + '.xwiki';
  fs.writeFileSync(path.join(OUT, file), text, 'utf8');
  total += text.length;
  written.push({ file, name, bytes: text.length });
}

write('index', WIKI.parent, indexPage());
for (const p of content) write(p.id, p.name, contentPage(p));

fs.writeFileSync(path.join(OUT, '_pages.md'),
  '# Paste map\n\nGenerated by `../build-wiki.js` — do not edit.\n\n' +
  'Parent page: `' + WIKI.space + '/' + WIKI.parent + '`, renamed from `' + WIKI.renamedFrom + '`. ' +
  'Every content page is a direct child of it. Badge mode `' + MODE + '`, link style `' + LINK_STYLE + '`.\n\n' +
  written.map(w => '- `' + w.file + '` → **' + w.name + '**' +
    (w.name === WIKI.parent ? ' (the parent page itself)' : '')).join('\n') + '\n', 'utf8');

console.log(written.length + ' pages, ' + Math.round(total / 1024) + ' KB total');
console.log('badge mode ' + MODE + ', link style ' + LINK_STYLE);
const big = written.slice().sort((a, b) => b.bytes - a.bytes).slice(0, 3);
for (const w of big) console.log('  largest: ' + w.file + ' ' + Math.round(w.bytes / 1024) + ' KB');
