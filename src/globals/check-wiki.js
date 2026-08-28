// Structural check on the generated pages. Nothing here proves how the wiki
// renders them - only a paste into the live wiki does that - but it catches a
// broken table row, a dangling link and a missing anchor before that.
//
//   node check-wiki.js

const fs = require('fs');
const path = require('path');
const { pages, names } = require('./page-manifest.js');

const DIR = path.join(__dirname, 'wiki');
const files = fs.readdirSync(DIR).filter(f => f.endsWith('.xwiki'));
const text = Object.fromEntries(files.map(f => [f, fs.readFileSync(path.join(DIR, f), 'utf8')]));

const problems = [];
const note = (s) => problems.push(s);

/* --- cells: a pipe inside [[...]] is part of the link, not a separator --- */

function cellCount(line) {
  let n = 0, depth = 0;
  for (let i = 0; i < line.length; i++) {
    if (line.startsWith('[[', i)) { depth++; i++; continue; }
    if (line.startsWith(']]', i) && depth) { depth--; i++; continue; }
    if (line[i] === '|' && !depth && line[i - 1] !== '~') n++;
  }
  return n;
}

for (const f of files) {
  let want = 0;
  // A cell with rowspan="N" is written once and covers the next N-1 rows, so
  // those rows legitimately carry fewer cells.
  let spans = [];
  text[f].split('\n').forEach((line, i) => {
    if (/^\|=/.test(line)) { want = cellCount(line); spans = []; return; }
    if (!line.startsWith('|')) { if (!line.trim()) { want = 0; spans = []; } return; }
    if (!want) return;

    const n = cellCount(line);
    const expect = want - spans.length;
    if (n !== expect) note(`${f}:${i + 1} row has ${n} cells, expected ${expect}`);

    spans = spans.map(s => s - 1).filter(s => s > 0);
    for (const m of line.matchAll(/rowspan="(\d+)"/g)) spans.push(Number(m[1]) - 1);
  });
}

/* ------------------------------------------------------------ anchors */

const anchors = new Set();
for (const f of files) {
  for (const m of text[f].matchAll(/\{\{id name="g-([^"]+)"\/\}\}/g)) {
    if (anchors.has(m[1])) note('duplicate anchor g-' + m[1]);
    anchors.add(m[1]);
  }
}
for (const n of names) if (!anchors.has(n)) note('no detail card for ' + n);

/* -------------------------------------------------------------- links */

const known = new Set(pages.filter(p => p.kind !== 'index').map(p => p.name));
for (const f of files) {
  for (const m of text[f].matchAll(/>>doc:([^|\]]+)/g)) {
    const ref = m[1];
    // "WebHome" is the up-link to the parent page; a dotted ref is absolute.
    if (ref === 'WebHome' || ref.includes('.')) continue;
    if (!known.has(ref)) note(f + ' links to unknown page "' + ref + '"');
  }
  // Same-page anchors must exist on that page.
  for (const m of text[f].matchAll(/>>\|\|anchor="([^"]+)"\]\]/g)) {
    if (!text[f].includes(`{{id name="${m[1]}"/}}`)) note(f + ' anchor "' + m[1] + '" has no target');
  }
}

/* -------------------------------------------- escaping and code blocks */

for (const f of files) {
  const lines = text[f].split('\n');
  let inCode = false, open = 0;
  lines.forEach((line, i) => {
    if (line.startsWith('{{code')) { inCode = true; open++; return; }
    if (line.startsWith('{{/code}}')) { inCode = false; open--; return; }
    if (inCode) return;
    // A bare "__" in body text renders as underline. Link targets and macro
    // parameters are not body text, so strip them before looking.
    const body = line.replace(/\[\[[\s\S]*?\]\]/g, '').replace(/\{\{[\s\S]*?\}\}/g, '');
    if (/(^|[^~])__/.test(body.replace(/~_/g, ''))) note(`${f}:${i + 1} unescaped __`);
  });
  if (open !== 0) note(f + ' has an unbalanced {{code}} block');
}

/* ------------------------------------------------------------- report */

console.log(files.length + ' files, ' + anchors.size + ' detail cards');
if (!problems.length) {
  console.log('no structural problems');
} else {
  console.log(problems.length + ' problems:');
  for (const p of problems.slice(0, 40)) console.log('  ' + p);
  if (problems.length > 40) console.log('  ... and ' + (problems.length - 40) + ' more');
  process.exitCode = 1;
}
