'use strict';

// data/history.json: which callbacks each UIX release dispatches.
//
// This is the committed record of the version axis, and it exists so that the
// axis never has to be rebuilt. Extracting all 33 releases means downloading and
// parsing 33 tags; extracting the one release that just appeared means one. The
// backfill is a local job, the weekly job is an append.
//
// Stored per line as a delta chain rather than 33 full sets. Two reasons: a full
// set is 276 names, so 33 of them is most of a megabyte of the same strings; and
// the diff for a new release then reads as exactly what that release changed,
// which is the interesting part.
//
// The chain is PER LINE because the lines are parallel. Chronologically 8.0.4.9
// is followed by 9.0.0.6 and then by 8.0.4.10, so a single chain would record a
// churn of adds and removes at every switch between them, none of it real.

const fs = require('fs');
const path = require('path');
const R = require('./releases');

const FILE = path.join(__dirname, '..', '..', 'data', 'history.json');

function read(file = FILE) {
  if (!fs.existsSync(file)) return { repo: R.REPO, floor: R.FLOOR, generated: null, lines: {} };
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

// Replay one line's deltas into { tag -> Set(menu::name) }.
function presenceOf(history) {
  const out = new Map();
  for (const [line, entries] of Object.entries(history.lines)) {
    let cur = new Set();
    for (const e of entries) {
      cur = new Set(cur);
      for (const k of e.removed || []) cur.delete(k);
      for (const k of e.added || []) cur.add(k);
      out.set(e.tag, { line, published: e.published, prerelease: e.prerelease, counts: e.counts, keys: cur });
    }
  }
  return out;
}

// Every release the history covers, chronologically across both lines.
function releasesOf(history) {
  return Object.values(history.lines).flat().sort(R.cmpRelease);
}

const has = (history, tag) => releasesOf(history).some((r) => r.tag === tag);

// Fold an extracted release in, keeping each line's chain in publish order. A tag
// already recorded is replaced, so re-extracting one is safe and idempotent.
function put(history, release, keys, counts) {
  const line = R.lineOf(release.tag);

  // Back to full sets first: the deltas of the release AFTER an insert change too,
  // so the chain is rebuilt from sets rather than patched in place.
  const full = new Map();
  let running = new Set();
  for (const e of history.lines[line] || []) {
    running = new Set(running);
    for (const k of e.removed || []) running.delete(k);
    for (const k of e.added || []) running.add(k);
    full.set(e.tag, { tag: e.tag, name: e.name, published: e.published, prerelease: e.prerelease, counts: e.counts, keys: [...running] });
  }
  full.set(release.tag, { tag: release.tag, name: release.name, published: release.published, prerelease: release.prerelease, counts, keys: [...keys].sort() });
  const entries = [...full.values()].sort(R.cmpRelease);

  // Rebuild the whole chain: an insert in the middle changes the deltas of the
  // release after it as well as its own.
  let prev = new Set();
  history.lines[line] = entries.map((e) => {
    const set = new Set(e.keys);
    const out = {
      tag: e.tag, name: e.name, published: e.published, prerelease: e.prerelease, counts: e.counts,
      added: [...set].filter((k) => !prev.has(k)).sort(),
      removed: [...prev].filter((k) => !set.has(k)).sort(),
    };
    prev = set;
    return out;
  });
  history.lines = Object.fromEntries(Object.entries(history.lines).sort());
  return history;
}

function write(history, file = FILE) {
  history.generated = new Date().toISOString().slice(0, 10);
  // One line per name list: the structure stays readable, and a release that adds
  // nothing does not add 280 lines of unchanged text to the diff.
  const json = JSON.stringify(history, null, 1)
    .replace(/\[\n\s+((?:"[^"\n]*",?\n\s+)*"[^"\n]*")\n\s+\]/g, (m, body) => '[' + body.replace(/\s*\n\s*/g, ' ') + ']');
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, json + '\n');
  return json.length;
}

// The smallest set of releases that still has to be extracted in full.
//
// The history records presence; gen-meta.js also needs each hook's arguments and
// call sites, and it takes them from the newest release that still dispatches it.
// For almost everything that is the newest release outright - but a hook UIX has
// since dropped is only described by the last release that had it, so that one is
// needed too. Two such hooks exist, so this is three releases, not thirty-three.
function coverSet(history) {
  const present = presenceOf(history);
  const newestFor = new Map();
  for (const r of releasesOf(history)) for (const k of present.get(r.tag).keys) newestFor.set(k, r.tag);
  const order = releasesOf(history).map((r) => r.tag);
  return [...new Set(newestFor.values())].sort((a, b) => order.indexOf(a) - order.indexOf(b));
}

module.exports = { FILE, read, write, put, has, presenceOf, releasesOf, coverSet };
