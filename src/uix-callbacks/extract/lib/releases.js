'use strict';

// The version axis: UIX's own GitHub releases, and the ordering rules the rest of
// the pipeline reads them by.
//
// Two facts shape everything here.
//
// The axis is the MOD's releases, not the game's. `Since: 9.0.0.3` names a UIX
// release, which a user installs; a bare tag with no release behind it does not,
// so tags without a release are not on the axis at all.
//
// The 8.x and 9.x lines run in PARALLEL, not in sequence. 8.0.4.10 and 9.0.0.7
// were published the same day. So a single number cannot answer "is this hook in
// the build my users run" - that is asked per line, and `lineOf` is what splits
// them.

const REPO = 'kuertee/x4-mod-ui-extensions';

// The oldest release the reference covers: the one published as "8.0.0.1-beta",
// whose tag is the bare 8.0.0.1. Anything already dispatched there predates the
// scan and is stamped `pre-8.0` rather than given a number the scan cannot prove.
const FLOOR = '8.0.0.1';
const FLOOR_LABEL = 'pre-8.0';

// 8.0.4.10 < 9.0.0.12, and 9.0.0.0.12.4 < 9.0.0.2, by segment and not by string.
// A trailing -beta / -rc1 sorts before the same numbers without one.
function cmpVersion(a, b) {
  const split = (v) => {
    const [num, tail] = String(v).split(/-(.+)/);
    return { parts: num.split('.').map(Number), tail: tail || '' };
  };
  const x = split(a), y = split(b);
  for (let i = 0; i < Math.max(x.parts.length, y.parts.length); i++) {
    const p = x.parts[i] || 0, q = y.parts[i] || 0;
    if (p !== q) return p - q;
  }
  if (x.tail === y.tail) return 0;
  if (!x.tail) return 1;
  if (!y.tail) return -1;
  return x.tail.localeCompare(y.tail);
}

// Which parallel line a release belongs to. The major alone decides it: every
// 9.0.* tag is the 9.x line whatever its depth.
const lineOf = (tag) => String(tag).split('.')[0] + '.x';

// Chronological, because that is the order the callbacks actually appeared in.
// Within a day the version order breaks the tie, so a run is reproducible.
function cmpRelease(a, b) {
  return a.published.localeCompare(b.published) || cmpVersion(a.tag, b.tag);
}

async function api(url) {
  const headers = { accept: 'application/vnd.github+json', 'user-agent': 'x4-uix-callbacks' };
  const token = process.env.GH_TOKEN || process.env.GITHUB_TOKEN;
  if (token) headers.authorization = 'Bearer ' + token;
  const r = await fetch(url, { headers });
  if (!r.ok) throw new Error(`${r.status} ${r.statusText} for ${url}`);
  return r.json();
}

// Every release on the axis, oldest first. Unauthenticated works: this is one
// request per 100 releases against a public repo.
async function fetchReleases() {
  const all = [];
  for (let page = 1; page <= 10; page++) {
    const batch = await api(`https://api.github.com/repos/${REPO}/releases?per_page=100&page=${page}`);
    all.push(...batch);
    if (batch.length < 100) break;
  }
  return all
    .filter((r) => !r.draft)
    .map((r) => ({
      tag: r.tag_name,
      name: r.name || r.tag_name,
      published: (r.published_at || r.created_at || '').slice(0, 10),
      prerelease: !!r.prerelease,
    }))
    .filter((r) => r.published && cmpVersion(r.tag, FLOOR) >= 0 && /^[0-9]/.test(r.tag))
    .sort(cmpRelease);
}

// A release's sources, without a clone and without the API: codeload serves the
// whole tag as one gzipped tar, which is 1.7 MB against 21 blob requests.
function tarballUrl(tag) {
  return `https://codeload.github.com/${REPO}/tar.gz/refs/tags/${encodeURIComponent(tag)}`;
}

module.exports = { REPO, FLOOR, FLOOR_LABEL, cmpVersion, cmpRelease, lineOf, fetchReleases, tarballUrl, api };
