'use strict';

// Small Lua source helpers. Not a parser: the callback dispatch blocks are a
// handful of regular shapes, so scanning is enough and is checked by the counts
// extract.js reports.

// Blank out -- comments and string bodies so keyword counting cannot trip over
// an "end" inside either. Length is preserved so column offsets still line up.
function blank(line) {
  let out = '', i = 0;
  while (i < line.length) {
    if (line[i] === '-' && line[i + 1] === '-') { out += ' '.repeat(line.length - i); break; }
    const c = line[i];
    if (c === '"' || c === "'") {
      let j = i + 1;
      while (j < line.length && line[j] !== c) { if (line[j] === '\\') j++; j++; }
      out += ' '.repeat(Math.min(j, line.length) - i + 1);
      i = j + 1;
      continue;
    }
    out += c; i++;
  }
  return out.length >= line.length ? out.slice(0, line.length) : out + ' '.repeat(line.length - out.length);
}

const OPENS = /\b(if|for|while|function)\b/g;
const ENDS = /\bend\b/g;

// Net block depth a line contributes. "if ... then ... end" on one line nets 0.
function depthDelta(line) {
  const b = blank(line);
  let d = 0;
  // A `do` that belongs to a for/while is already counted by that keyword.
  for (const m of b.matchAll(OPENS)) { void m; d++; }
  for (const m of b.matchAll(ENDS)) { void m; d--; }
  // `elseif` re-enters the same block: it matched `if` above but opens nothing.
  for (const m of b.matchAll(/\belseif\b/g)) { void m; d--; }
  return d;
}

// Extent of the block introduced at `start`, capped so a mis-count cannot run away.
function blockExtent(lines, start, cap = 45) {
  let d = depthDelta(lines[start]);
  if (d <= 0) return Math.min(start + 3, lines.length - 1);
  for (let i = start + 1; i < Math.min(lines.length, start + cap); i++) {
    d += depthDelta(lines[i]);
    if (d <= 0) return i;
  }
  return Math.min(start + cap, lines.length - 1);
}

// Split an argument list on top-level commas.
function splitArgs(s) {
  const out = [];
  let depth = 0, cur = '', q = null;
  for (let i = 0; i < s.length; i++) {
    const c = s[i];
    if (q) { cur += c; if (c === '\\') { cur += s[++i] || ''; } else if (c === q) q = null; continue; }
    if (c === '"' || c === "'") { q = c; cur += c; continue; }
    if ('([{'.includes(c)) depth++;
    if (')]}'.includes(c)) { if (depth === 0) break; depth--; }
    if (c === ',' && depth === 0) { out.push(cur.trim()); cur = ''; continue; }
    cur += c;
  }
  if (cur.trim()) out.push(cur.trim());
  return out.filter(Boolean);
}

// Text inside the parentheses opening at or after `from`, across lines if needed.
function balanced(text, from) {
  const open = text.indexOf('(', from);
  if (open < 0) return null;
  let depth = 0, q = null;
  for (let i = open; i < text.length; i++) {
    const c = text[i];
    if (q) { if (c === '\\') i++; else if (c === q) q = null; continue; }
    if (c === '"' || c === "'") { q = c; continue; }
    if (c === '(') depth++;
    else if (c === ')') { depth--; if (depth === 0) return text.slice(open + 1, i); }
  }
  return null;
}

// The named function a line sits in: nearest preceding declaration, preferring
// one at column 0, which in these files is always the menu-level function.
const FUNC = /^(\s*)(?:local\s+)?function\s+([A-Za-z_][\w.:]*)\s*\(/;
function enclosingFunction(lines, at) {
  let inner = null;
  for (let i = at; i >= 0; i--) {
    const m = FUNC.exec(lines[i]);
    if (!m) continue;
    if (m[1].length === 0) return { func: m[2], inner: inner && inner !== m[2] ? inner : null };
    if (!inner) inner = m[2];
  }
  return { func: inner || null, inner: null };
}

// "-- kuertee start: callback", "-- end: mycu callback", "-- Damonya2 start: callback",
// "-- End Subsystem Targeting Orders callback". Who asked for the hook, when it says.
const MARKS = [
  /--\s*([A-Za-z][\w' ]*?)\s+(?:start|begin)\s*:\s*call-?back/i,
  /--\s*(?:end|start)\s*:\s*([A-Za-z][\w' ]*?)\s+call-?back/i,
  /--\s*(?:End|Start)\s+([A-Z][\w' ]*?)\s+call-?back/,
];
function attribution(lines, start, end) {
  for (let i = Math.max(0, start - 2); i <= Math.min(lines.length - 1, end + 2); i++) {
    for (const re of MARKS) {
      const m = re.exec(lines[i]);
      if (m && m[1]) {
        const a = m[1].trim();
        if (a && !/^(the|a|new)$/i.test(a)) return a;
      }
    }
  }
  return null;
}

module.exports = { blank, depthDelta, blockExtent, splitArgs, balanced, enclosingFunction, attribution };

