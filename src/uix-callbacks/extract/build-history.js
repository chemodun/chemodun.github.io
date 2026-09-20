'use strict';

// Fetch UIX releases, extract each, and record what it dispatches in
// data/history.json - the committed answer to "since which release is this hook
// available".
//
//   node build-history.js --check        is there a release the history lacks?
//   node build-history.js                extract the ones it lacks, append them
//   node build-history.js --all          rebuild every release from scratch
//   node build-history.js 9.0.0.13 ...   just these, re-extracting if present
//
// `--check` is the weekly workflow's first step and touches nothing; it exits 0
// when the history is current and 3 when it is not, so a run can branch on it.
//
// A release is fetched as one gzipped tar and its .xpl files are dropped again
// once read; `--keep-sources` leaves them in src/ when they are wanted for
// reading. What survives a run is data/history.json, which is committed, and the
// full extractions in out/, which are not - see ensureCover for why a fresh
// checkout with no out/ still produces the same reference.

const fs = require('fs');
const path = require('path');
const R = require('./lib/releases');
const H = require('./lib/history');
const { readTarGz } = require('./lib/targz');
const { extractTree, report } = require('./extract');

const SRC = path.join(__dirname, 'src');
const isXpl = (name) => /(^|\/)ui\/.*\.xpl$/.test(name);

async function fetchTree(release) {
  const r = await fetch(R.tarballUrl(release.tag), { headers: { 'user-agent': 'x4-uix-callbacks' } });
  if (!r.ok) throw new Error(`${r.status} ${r.statusText} fetching ${release.tag}`);
  const files = readTarGz(Buffer.from(await r.arrayBuffer()), isXpl);
  if (!files.length) throw new Error(`${release.tag} carries no ui/**/*.xpl`);
  // The tarball's top directory is the repo name and tag; extract.js wants a root
  // with ui/ directly under it, so that one segment is dropped.
  const dir = path.join(SRC, release.tag);
  fs.rmSync(dir, { recursive: true, force: true });
  for (const f of files) {
    const dest = path.join(dir, f.name.split('/').slice(1).join('/'));
    fs.mkdirSync(path.dirname(dest), { recursive: true });
    fs.writeFileSync(dest, f.data);
  }
  return dir;
}

async function main() {
  const args = process.argv.slice(2);
  const check = args.includes('--check');
  const all = args.includes('--all');
  const keep = args.includes('--keep-sources');
  const named = args.filter((a) => !a.startsWith('--'));

  const releases = await R.fetchReleases();
  const history = all ? { repo: R.REPO, floor: R.FLOOR, generated: null, lines: {} } : H.read();

  let todo;
  if (named.length) {
    todo = named.map((t) => releases.find((r) => r.tag === t) || (() => { throw new Error(`no release tagged ${t}`); })());
  } else {
    todo = releases.filter((r) => !H.has(history, r.tag));
  }

  const known = H.releasesOf(history).length;
  console.log(`${releases.length} releases on the axis (${R.FLOOR} onwards), ${known} in the history, ${todo.length} to extract`);

  if (check) {
    if (!todo.length) { console.log('history is current'); return; }
    for (const r of todo) console.log(`  new: ${r.tag}  ${r.published}  ${R.lineOf(r.tag)}${r.prerelease ? '  (prerelease)' : ''}`);
    process.exitCode = 3;
    return;
  }
  for (const r of todo) {
    const data = await extractRelease(r, keep);
    report(data, '  ');
    H.put(history, r, data.callbacks.map((c) => c.menu + '::' + c.name), data.counts);
    // What the release changed against the one before it ON ITS OWN LINE, which is
    // the only comparison that means anything and the line the pull request quotes.
    const e = history.lines[R.lineOf(r.tag)].find((x) => x.tag === r.tag);
    const prev = history.lines[R.lineOf(r.tag)].findIndex((x) => x.tag === r.tag) === 0;
    if (!prev) {
      console.log(`    +${e.added.length} -${e.removed.length} against the previous ${R.lineOf(r.tag)} release`);
      for (const k of e.added) console.log(`      + ${k}`);
      for (const k of e.removed) console.log(`      - ${k}`);
    }
  }

  if (todo.length) {
    const size = H.write(history);
    const lines = Object.entries(history.lines).map(([l, e]) => `${l}: ${e.length}`).join(', ');
    console.log(`history: ${H.releasesOf(history).length} releases (${lines}) -> data/history.json, ${(size / 1024).toFixed(0)} KB`);
  }

  // Runs even with nothing new: out/ is not committed, so a fresh checkout needs
  // the cover set rebuilt before gen-meta.js can describe anything.
  await ensureCover(history, releases, keep);
}

// out/ is not committed, so a fresh checkout has none of it. Re-extract whatever
// the cover set is missing: on a weekly run that is the release that just
// appeared, and nothing else.
async function ensureCover(history, releases, keep) {
  const cover = H.coverSet(history);
  const missing = cover.filter((t) => !fs.existsSync(path.join(__dirname, 'out', t + '.json')));
  console.log(`cover set: ${cover.join(', ')}${missing.length ? ` (${missing.length} to re-extract)` : ' (all present)'}`);
  for (const tag of missing) {
    const r = releases.find((x) => x.tag === tag);
    await extractRelease(r, keep);
    console.log(`  re-extracted ${tag} for its detail`);
  }
}

// One release: fetch, extract, write out/<tag>.json. The sources are dropped
// again unless they are wanted for reading.
async function extractRelease(release, keep) {
  const dir = await fetchTree(release);
  const data = extractTree(dir, release.tag, R.REPO);
  fs.mkdirSync(path.join(__dirname, 'out'), { recursive: true });
  fs.writeFileSync(path.join(__dirname, 'out', release.tag + '.json'), JSON.stringify(data, null, 1));
  if (!keep) fs.rmSync(dir, { recursive: true, force: true });
  return data;
}

main().catch((e) => { console.error(e.message); process.exit(1); });
