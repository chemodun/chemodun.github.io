// The one list of globals the reference must never contain, and why.
//
// Everything else in the pipeline is measured or derived; this is the single
// hand-maintained escape hatch. Add a name here only when it is genuinely not
// part of X4, and always with the reason - the report prints it, so a future
// reader can check the call rather than trust the list.
//
//   const { excluded, reasonOf } = require('./exclusions');
//   excluded.has('decoda_name')   // -> true
//
// Two sources feed it:
//
//   HARDCODED   - named here, because nothing in the data distinguishes them.
//                 Debugger tooling that is present only while a debugger is
//                 attached, and so appears in the game exactly like a real global.
//
//   the marker  - a "-- Source: extension <id>" line in an entry's comment block
//                 in globals.lua. Those entries stay in the file so the editor
//                 still completes them when writing code against that extension,
//                 but they are not X4 globals and never reach the reference.
//
// The measurement was taken on a modded install with a debugger attached, so
// every one of these really was present. They are bucketed as "excluded" and
// reported rather than dropped silently, which keeps the split auditable.

const fs = require('fs');
const path = require('path');

const SRC = path.join(__dirname, 'globals.lua');

const HARDCODED = {
  // EmmyLua. lua_debugger_loader.lua assigns LuaDebugger; the emmy_core DLL
  // registers its own module table and emmyHelperInit alongside it.
  LuaDebugger: 'EmmyLua debugger - assigned by the lua_debugger_loader extension',
  emmy_core: 'EmmyLua debugger - the emmy_core DLL module table',
  emmyHelperInit: 'EmmyLua debugger - exported by the emmy_core DLL',

  // Decoda. The debugger stamps the running chunk's name into this global.
  decoda_name: 'Decoda debugger - the script name it stamps on each chunk',
};

// NOT excluded, and worth recording so nobody adds them by pattern-matching:
//   trace   - looks like debugger tooling, but the property_expand_collapse mod
//             defines it; the mod heuristic catches it already.
//   winpipe - sn_mod_support_apis' C library, likewise caught as a mod global.
//   self    - a genuine Anark runtime global, documented in the reference.

// name -> the extension id its marker names.
const extensionSource = {};
{
  let src = fs.readFileSync(SRC, 'utf8');
  if (src.charCodeAt(0) === 0xFEFF) src = src.slice(1);
  let ext = null;
  for (const raw of src.split(/\r?\n/)) {
    const line = raw.trim();
    if (line.startsWith('--')) {
      const m = line.match(/^--+\s*Source:\s*extension\s+(\S+)/i);
      if (m) ext = m[1];
      continue;
    }
    const d = line.match(/^function\s+([A-Za-z_][\w]*)\s*\(/) ||
              line.match(/^([A-Za-z_][\w]*)\s*=\s*\S/);
    if (d) { if (ext) extensionSource[d[1]] = ext; ext = null; continue; }
    if (!line) ext = null;      // a blank line ends the block, as everywhere else
  }
}

const reason = { ...HARDCODED };
for (const n of Object.keys(extensionSource))
  reason[n] = 'extension ' + extensionSource[n] + ' - declared in globals.lua for editor support only';

const excluded = new Set(Object.keys(reason));
const reasonOf = (n) => reason[n] || null;

module.exports = { excluded, reasonOf, HARDCODED, extensionSource };

if (require.main === module) {
  console.log(excluded.size + ' globals are excluded from the reference:\n');
  for (const n of [...excluded].sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase())))
    console.log('  ' + n.padEnd(28) + reasonOf(n));
}
