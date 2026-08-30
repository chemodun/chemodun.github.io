'use strict';

// The LuaLS meta file: emit it from out/*.json, and read it back.
//
// The file is the reference. Everything the page shows lives in it, so the site
// half reads it instead of the JSON, and it doubles as an editor library: point a
// Lua Language Server at it and X4's C. namespace gets completion and signatures.
//
// Two halves share every entry:
//
//   generated   the `-- Key: value` lines and the declarations, rewritten in full
//               on every run of gen-meta.js
//   authored    the `---` prose, `-- Note:` lines and the text trailing a
//               ---@param / ---@return / ---@field, carried across untouched
//
// A C type cannot be written in LuaLS annotations - `const char*` is not a type name
// and `integer` is not a uint32_t - so every annotation carries the exact C text in
// backticks and the Lua type beside it. The backticks are what parse() reads; the
// Lua type is what the editor reads.
//
// The parser is duplicated in the site repo as src/c-functions-and-structures/meta.js,
// which is what builds the page. The two must agree, and the site build checks that it
// does by validating what it parses against meta.json's counts.

const KEYWORDS = new Set(('and break do else elseif end false for function goto if in local nil ' +
  'not or repeat return then true until while').split(' '));

const INT = /^(char|short|int|long|u?int(8|16|32|64)_t|size_t|ptrdiff_t|unsigned|signed)$/;

// "const char* name" -> { type: 'const char*', name: 'name' }, the split lib/cdef.js
// makes. A type with nothing after it is an unnamed parameter, of which there are 3.
function splitC(raw) {
  const t = raw.replace(/\s+/g, ' ').trim();
  if (!t || t === 'void') return null;
  const m = /^(.*?)([A-Za-z_][A-Za-z0-9_]*)$/.exec(t);
  if (!m || !m[1].trim()) return { type: t, name: '' };
  return { type: m[1].replace(/\s+/g, ' ').trim().replace(/\s+\*/g, '*'), name: m[2] };
}

// The closest thing an editor can offer for a C type. A pointer to a struct is that
// struct: LuaJIT indexes it the same way and LuaLS has no pointer to offer.
function luaType(ctype, types) {
  const arr = /\[[^\]]*\]/.test(ctype);
  const stars = (ctype.match(/\*/g) || []).length;
  const bare = ctype.replace(/\[[^\]]*\]/g, '').replace(/[*\s]+$/, '').replace(/^const\s+/, '').trim();
  if (bare === 'char' && stars) return stars > 1 ? 'string[]' : 'string';
  if (bare === 'void') return stars ? 'userdata' : 'nil';
  let t;
  if (types && types[bare]) t = bare;
  else if (bare === 'bool') t = 'boolean';
  else if (bare === 'float' || bare === 'double') t = 'number';
  else if (INT.test(bare)) t = 'integer';
  else t = 'any';
  // Every pointer in this API is the start of an array the caller sized, bar the
  // two above, so it reads as one rather than as a type an editor cannot express.
  return stars || arr ? t + '[]' : t;
}

// A parameter name has to survive being written as Lua. The C text in backticks is
// what round-trips, so a renamed one costs nothing.
function argNames(params) {
  const used = new Set();
  return params.map((p, i) => {
    let n = /^[A-Za-z_][A-Za-z0-9_]*$/.test(p.name) && !KEYWORDS.has(p.name) ? p.name : 'arg' + (i + 1);
    while (used.has(n)) n += '_';
    used.add(n);
    return n;
  });
}

const cText = (p) => (p.name ? `${p.type} ${p.name}` : p.type);
const token = (v) => 'v' + v.replace('.', '');
const ORPHANS = '--#region Descriptions with no matching name';

/* -------------------------------------------------------------------- emit */

const proseLines = (s) => String(s).split('\n').map((l) => ('--- ' + l).trimEnd());
const noteLines = (s) => String(s).split('\n').map((l, i) => ((i ? '--   ' : '-- Note: ') + l).trimEnd());
const contLines = (s) => String(s).split('\n').map((l) => ('--   ' + l).trimEnd());

// `text` is what the author wrote after the backticked C type, and only that.
const annotation = (tag, head, c, text) =>
  `---@${tag} ${head} \`${c}\`${text ? ' ' + String(text).replace(/\n/g, ' ') : ''}`;

const versionsLine = (node, versions) =>
  `-- Versions: ${versions.filter((v) => (node.v ? node.v.includes(token(v)) : true)).join(', ')}`;

function emitType(name, t, doc, versions, types) {
  const out = [];
  if (doc.detailed) out.push(...proseLines(doc.detailed));
  if (doc.notes) out.push(...noteLines(doc.notes));
  out.push(`-- Kind: ${t.kind}`);
  if (t.target) out.push(`-- Target: ${t.target}`);
  if (t.env) out.push(`-- Environment: ${t.env}`);
  out.push(versionsLine(t, versions));
  if (t.size !== undefined) out.push(`-- Size: ${t.size}${t.sizeFrom ? ` measured in ${t.sizeFrom}` : ''}`);
  for (const s of t.sites || []) out.push(`-- Declared: ${s.file}:${s.line}`);
  for (const [v, d] of Object.entries(t.vDecl || {})) {
    out.push(`-- Declaration in: ${v}`, ...contLines(d));
  }

  if (t.kind === 'typedef') {
    out.push(`---@alias ${name} ${luaType(t.target, types)}`);
  } else {
    out.push(`---@class ${name}`);
    for (const f of t.fields || []) {
      out.push(annotation('field', `${f.name} ${luaType(f.type, types)}`, cText(f), (doc.fields || {})[f.name]));
    }
  }
  return out;
}

function emitFunction(name, f, doc, versions, types) {
  const out = [];
  if (doc.detailed) out.push(...proseLines(doc.detailed));
  if (doc.notes) out.push(...noteLines(doc.notes));
  out.push(`-- State: ${f.state}`);
  for (const [v, s] of Object.entries(f.vState || {})) out.push(`-- Was: ${v} ${s}`);
  if (f.env) out.push(`-- Environment: ${f.env}`);
  out.push(versionsLine(f, versions));
  if (f.declFrom) out.push(`-- Last declared: ${f.declFrom}`);
  for (const s of f.sites || []) out.push(`-- Declared: ${s.file}:${s.line}`);
  if (f.uses) out.push(`-- Called: ${f.uses} at ${f.use.file}:${f.use.line}`);
  for (const [v, s] of Object.entries(f.vSig || {})) out.push(`-- Signature in: ${v} ${s}`);
  if (f.state === 'restricted') out.push('---@deprecated');

  if (!f.params) {
    out.push('---@type function', `C.${name} = nil`);
    return out;
  }
  const args = argNames(f.params);
  f.params.forEach((p, i) => {
    out.push(annotation('param', `${args[i]} ${luaType(p.type, types)}`, cText(p), (doc.params || {})[args[i]]));
  });
  if (f.ret && f.ret !== 'void') out.push(annotation('return', `${luaType(f.ret, types)} #`, f.ret, doc.ret));
  out.push(`function C.${name}(${args.join(', ')}) end`);
  return out;
}

const HEADER = (meta) => `---@meta

-- X4: Foundations - every name the engine exposes to UI Lua through ffi.C.
--
-- Generated by gen-meta.js of the extraction half, from the ffi.cdef blocks of the
-- game's own Lua, the export table of X4.exe and a probe run inside the game.
-- Covers ${meta.versions.join(' and ')}. This file builds the reference page, and it is a
-- Lua Language Server library: add it to workspace.library for C. completion.
--
-- WRITE DESCRIPTIONS HERE. Regenerating carries these across and rewrites the rest:
--
--   "--- text" above an entry     what it is and what it is for
--   "-- Note: text"               a caveat, kept apart from the description
--   text after the \`C type\`       on a ---@param, ---@return or ---@field: what that
--                                 one value is
--
-- Every other line is generated. A \`backticked\` type is the exact C declaration and is
-- what the page reads; the LuaLS type beside it is the editor's approximation. A cdef
-- that does not match the real signature is undefined behaviour rather than an error,
-- so never write a signature for a name the game does not declare.
`;

function emit({ meta, functions, types, docs = {} }) {
  const versions = meta.versions;
  const fdocs = docs.functions || {};
  const tdocs = docs.types || {};
  const out = [HEADER(meta)];

  out.push('--#region Structs and typedefs\n');
  for (const name of Object.keys(types).sort()) {
    out.push(emitType(name, types[name], tdocs[name] || {}, versions, types).join('\n') + '\n');
  }
  out.push('--#endregion\n');

  out.push('--#region Functions\n');
  out.push('---@class X4C\nC = {}\n');
  for (const name of Object.keys(functions).sort()) {
    out.push(emitFunction(name, functions[name], fdocs[name] || {}, versions, types).join('\n') + '\n');
  }
  out.push('--#endregion\n');

  // Prose whose name the extraction no longer carries, commented out whole so it
  // declares nothing and read back unchanged, rather than dropped on the floor.
  const orphans = docs.orphans || {};
  if (Object.keys(orphans).length) {
    out.push(ORPHANS + '\n');
    out.push('-- Written for names this extraction does not carry. Nothing here declares\n' +
      '-- anything: move the text onto a live entry, or delete it.\n');
    for (const name of Object.keys(orphans).sort()) {
      out.push(orphans[name].split('\n').map((l) => ('-- ' + l).trimEnd()).join('\n') + '\n');
    }
    out.push('--#endregion\n');
  }
  return out.join('\n');
}

/* ------------------------------------------------------------------- parse */

// "name type `C text` authored text" - the backticks are the boundary, so neither
// half has to be guessed at.
const BACKTICK = /^(.*?)\s*`([^`]*)`\s*(.*)$/;

const site = (s) => {
  const m = /^(.*):(\d+)$/.exec(s);
  return { file: m[1], line: Number(m[2]) };
};

// One blank-line-separated block: its comment lines split into prose, notes,
// generated keys and annotations.
function readBlock(lines) {
  const meta = new Map();
  const prose = [], notes = [], anns = [];
  let cont = null;   // 'note', or the meta key a "--   " line continues

  for (const raw of lines) {
    const line = raw.trimEnd();
    let m;
    if (line.startsWith('---@')) {
      const tag = line.slice(4).split(/\s/)[0];
      anns.push([tag, line.slice(4).slice(tag.length).trim()]);
      cont = null;
    } else if ((m = /^---\s?(.*)$/.exec(line))) {
      prose.push(m[1]);
      cont = null;
    } else if ((m = /^--\s{3}(.*)$/.exec(line))) {
      if (cont === 'note') notes.push(m[1]);
      else if (cont) {
        const v = meta.get(cont);
        v[v.length - 1] += '\n' + m[1];
      }
    } else if ((m = /^--\s*Note:\s?(.*)$/.exec(line))) {
      notes.push(m[1]);
      cont = 'note';
    } else if ((m = /^--\s*([A-Z][A-Za-z ]*?):\s*(.*)$/.exec(line))) {
      if (!meta.has(m[1])) meta.set(m[1], []);
      meta.get(m[1]).push(m[2]);
      cont = m[1];
    }
  }
  return { meta, prose, notes, anns };
}

const first = (meta, key) => (meta.has(key) ? meta.get(key)[0] : undefined);
const all = (meta, key) => meta.get(key) || [];
const joined = (a) => a.join('\n').replace(/\s+$/, '');
const backticks = (anns, tag) => anns.filter((a) => a[0] === tag).map((a) => BACKTICK.exec(a[1]));

// The versions line is the reader-facing fact; `v` exists only when something is
// not in all of them, which is how the JSON stamps it too.
function stampV(entry, meta, versions) {
  const listed = (first(meta, 'Versions') || '').split(',').map((s) => s.trim()).filter(Boolean);
  if (listed.length && listed.length !== versions.length) entry.v = listed.map(token).join(' ');
}

function docOf(prose, notes) {
  const doc = {};
  if (prose.length) doc.detailed = joined(prose);
  if (notes.length) doc.notes = joined(notes);
  return doc;
}

function typeFrom(name, b, versions) {
  const t = { kind: first(b.meta, 'Kind') };
  const target = first(b.meta, 'Target');
  if (target) t.target = target;
  if (t.kind !== 'typedef') t.fields = backticks(b.anns, 'field').map((m) => splitC(m[2]));
  t.decl = t.kind === 'typedef'
    ? `typedef ${t.target} ${name};`
    : `typedef struct {\n${t.fields.map((f) => `  ${f.type} ${f.name};`).join('\n')}\n} ${name};`;
  const env = first(b.meta, 'Environment');
  if (env) t.env = env;
  t.sites = all(b.meta, 'Declared').map(site);
  const size = first(b.meta, 'Size');
  if (size !== undefined) {
    const m = /^(\d+)(?: measured in (.+))?$/.exec(size);
    t.size = Number(m[1]);
    if (m[2]) t.sizeFrom = m[2];
  }
  const vDecl = {};
  for (const d of all(b.meta, 'Declaration in')) {
    const m = /^(\S+)\n([\s\S]*)$/.exec(d);
    if (m) vDecl[m[1]] = m[2];
  }
  if (Object.keys(vDecl).length) t.vDecl = vDecl;
  stampV(t, b.meta, versions);
  return t;
}

function functionFrom(name, b, versions, declared) {
  const f = { state: first(b.meta, 'State') };
  const vState = {};
  for (const w of all(b.meta, 'Was')) {
    const m = /^(\S+)\s+(\S+)$/.exec(w);
    if (m) vState[m[1]] = m[2];
  }
  if (Object.keys(vState).length) f.vState = vState;

  if (declared) {
    const params = backticks(b.anns, 'param').map((m) => splitC(m[2]));
    const ret = backticks(b.anns, 'return')[0];
    f.ret = ret ? ret[2] : 'void';
    f.params = params;
    f.decl = `${f.ret} ${name}(${params.length
      ? params.map((p) => (p.name ? `${p.type} ${p.name}` : p.type)).join(', ') : 'void'});`;
    const declFrom = first(b.meta, 'Last declared');
    if (declFrom) f.declFrom = declFrom;
    const env = first(b.meta, 'Environment');
    if (env) f.env = env;
    f.sites = all(b.meta, 'Declared').map(site);
    const called = first(b.meta, 'Called');
    if (called) {
      const m = /^(\d+) at (.*):(\d+)$/.exec(called);
      f.uses = Number(m[1]);
      f.use = { file: m[2], line: Number(m[3]) };
    }
    const vSig = {};
    for (const s of all(b.meta, 'Signature in')) {
      const m = /^(\S+)\s+(.*)$/.exec(s);
      if (m) vSig[m[1]] = m[2];
    }
    if (Object.keys(vSig).length) f.vSig = vSig;
  }
  stampV(f, b.meta, versions);
  return f;
}

// What a block declares, if anything: the header and the region markers declare nothing.
function subjectOf(lines) {
  for (const line of lines) {
    let m;
    if ((m = /^---@class\s+(\S+)/.exec(line))) return m[1] === 'X4C' ? null : { kind: 'type', name: m[1] };
    if ((m = /^---@alias\s+(\S+)/.exec(line))) return { kind: 'type', name: m[1] };
    if ((m = /^function C\.([A-Za-z_][A-Za-z0-9_]*)\(/.exec(line))) return { kind: 'fn', name: m[1], declared: true };
    if ((m = /^C\.([A-Za-z_][A-Za-z0-9_]*)\s*=/.exec(line))) return { kind: 'fn', name: m[1], declared: false };
  }
  return null;
}

function parse(text, versionsHint) {
  const versions = versionsHint
    || ((/^-- Covers (.+?)\./m.exec(text) || [, ''])[1].split(/\s+and\s+|,\s*/).map((s) => s.trim()).filter(Boolean));

  const functions = {}, types = {};
  const docs = { functions: {}, types: {}, orphans: {} };

  // Entries are separated by a blank line, which is what makes a ---@class and the
  // ---@field lines under it one block rather than two.
  const blocks = [];
  const orphanBlocks = [];
  let cur = [], inOrphans = false;
  for (const raw of text.split(/\r?\n/)) {
    const line = raw.trimEnd();
    if (line.startsWith(ORPHANS)) { inOrphans = true; cur = []; continue; }
    if (/^--#(region|endregion)/.test(line)) { (inOrphans ? orphanBlocks : blocks).push(cur); cur = []; inOrphans = inOrphans && !/^--#endregion/.test(line); continue; }
    if (!line) { (inOrphans ? orphanBlocks : blocks).push(cur); cur = []; continue; }
    cur.push(inOrphans ? line.replace(/^-- ?/, '') : line);
  }
  blocks.push(cur);

  for (const lines of blocks) {
    const subject = subjectOf(lines);
    if (!subject) continue;
    const b = readBlock(lines);
    const doc = docOf(b.prose, b.notes);

    if (subject.kind === 'type') {
      types[subject.name] = typeFrom(subject.name, b, versions);
      const fields = {};
      for (const m of backticks(b.anns, 'field')) if (m[3]) fields[splitC(m[2]).name] = m[3];
      if (Object.keys(fields).length) doc.fields = fields;
      if (Object.keys(doc).length) docs.types[subject.name] = doc;
    } else {
      functions[subject.name] = functionFrom(subject.name, b, versions, subject.declared);
      const params = {};
      for (const m of backticks(b.anns, 'param')) if (m[3]) params[m[1].trim().split(/\s+/)[0]] = m[3];
      if (Object.keys(params).length) doc.params = params;
      const ret = backticks(b.anns, 'return')[0];
      if (ret && ret[3]) doc.ret = ret[3];
      if (Object.keys(doc).length) docs.functions[subject.name] = doc;
    }
  }

  for (const lines of orphanBlocks) {
    const subject = subjectOf(lines);
    if (subject) docs.orphans[subject.name] = lines.join('\n');
  }

  return { versions, functions, types, docs };
}

module.exports = { emit, parse, luaType, splitC, argNames, cText };
