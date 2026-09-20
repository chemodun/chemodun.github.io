'use strict';

// Turn "which releases dispatch this hook" into the three keys a reader acts on:
// Since, Versions and Removed.
//
// The hard part is that 8.x and 9.x are PARALLEL lines, not one sequence. A mod
// author's real question is "does the build my users run have this hook", and
// their users are on one line or the other. So every answer here is computed per
// line first and only collapsed to a single number when the lines agree.
//
// They agree in exactly one case: the hook was already in 8.x before the 9.x line
// was cut, so 9.x has it by inheritance and its own first release says nothing.
// Anything else - added on one line only, added to 9.x and back-ported later,
// dropped at the branch and restored - is printed as two numbers, because those
// two numbers are different facts.

const R = require('./releases');

// Contiguous stretches of presence within one line: [[first, last], ...]. A gap
// is real and gets its own run, so a hook that came and went and came back says so.
function runs(line, present) {
  const out = [];
  for (let i = 0; i < line.length; i++) {
    if (!present.has(line[i])) continue;
    const start = line[i];
    while (i + 1 < line.length && present.has(line[i + 1])) i++;
    out.push([start, line[i]]);
  }
  return out;
}

// `..`, not `-`: 8.0.0.7-rc1 and 8.0.0.7.1-beta carry hyphens of their own, so a
// hyphenated range could not be split back apart.
const range = ([a, b]) => (a === b ? a : `${a}..${b}`);

// history -> { lines: { '8.x': [tag...] }, order: [tag...], newest, publishedOf }
function axisOf(history) {
  const releases = require('./history').releasesOf(history);
  const lines = {};
  for (const r of releases) (lines[R.lineOf(r.tag)] ||= []).push(r.tag);
  return {
    lines,
    order: releases.map((r) => r.tag),
    newest: releases[releases.length - 1].tag,
    publishedOf: new Map(releases.map((r) => [r.tag, r.published])),
  };
}

// The keys for one callback, from the set of tags that dispatch it.
function keysFor(axis, present) {
  const per = {};
  for (const [line, tags] of Object.entries(axis.lines)) {
    const on = tags.filter((t) => present.has(t));
    if (!on.length) continue;
    per[line] = { first: on[0], last: on[on.length - 1], head: tags[tags.length - 1], floor: tags[0], runs: runs(tags, present) };
  }

  const a = per['8.x'], b = per['9.x'];
  // Present in the oldest release the scan covers: it predates the axis, and a
  // number here would claim more than the scan can prove.
  const label8 = a && a.first === a.floor ? R.FLOOR_LABEL : a && a.first;

  let since;
  if (a && b) {
    // Inherited: 9.x has had it since its own first release, and 8.x had it before
    // that release was published. Then 9.0.0.3 is just where the branch was cut.
    const inherited = b.first === b.floor
      && axis.publishedOf.get(a.first) < axis.publishedOf.get(b.floor);
    since = inherited ? label8 : `${label8} (8.x), ${b.first} (9.x)`;
  } else if (a) {
    since = `${label8} (8.x only)`;
  } else {
    since = `${b.first} (9.x only)`;
  }

  const versions = Object.keys(per).sort()
    .flatMap((l) => per[l].runs.map(range)).join(', ');

  const removed = Object.keys(per).sort()
    .filter((l) => per[l].last !== per[l].head)
    .map((l) => `gone from ${l} after ${per[l].last}`).join('; ');

  return { since, versions, removed: removed || null, per };
}

module.exports = { axisOf, keysFor, runs, range };
