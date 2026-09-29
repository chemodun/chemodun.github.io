// What vanilla's own code says about a declaration.
//
//   node usage.js            the tally, and every disputed declaration
//   require('./usage')       { usageOf, verdicts }
//
// classify.js records, per version, how many arguments vanilla passes at every
// call site of a global, plus a few example sites. Compared against the
// parameter list globals.lua declares, that yields one of three verdicts:
//
//   confirmed   X4.exe's own argument check accepts exactly the declared range, or,
//               where it has none, vanilla calls it and every argument count it
//               passes fits the declaration - or, where vanilla never calls it
//               either, the global was called in the running game and the row's
//               "Probed:" line says with what
//   disputed    X4.exe accepts a different range (under a luaL_check* gate, a declared
//               minimum below the checked one), or vanilla passes a count the
//               declaration cannot take - so the declaration is wrong, or an
//               optional parameter is unmarked
//   unverified  none of these
//
// A variable is never called, so its evidence is a mention instead.
//
// arity.json is read statically from X4.exe by claude/tools/x4lua-arity.py: the
// engine's own count check, so it outranks both a call site and a probe. A probe
// reading still settles a signature the exe does not check. PARKED is the exception
// there: those probes ran and came back without a usable reading.

const DATA = require('./classification.json');
const ARITY = require('./arity.json');
const { docs } = require('./docs.js');

const NEWEST = '9.00', OLDER = '8.00';

// Probed names whose reading is not a measurement. Each stays unverified, with the
// reason kept here rather than in a session note, because the row's own "Probed:"
// line reads like every other one.
const PARKED = new Set([
  // Arity 1 settled, but every target returned an empty array, and empty is not a
  // measured return.
  'GetEfficiencyUpgrades',
  // Arity from the engine only: no tagged connection has ever been reachable to ask on.
  'GetTradesAtConnection',
  // UNSUPPORTED by Egosoft, and the one bare call printed a signature rather than
  // answering a call.
  'SetMainMissiontargetMessage',
  // What the probe measured is the deprecation, not the signature: "" on every call
  // on both versions, and 9.00 stops checking the argument at all.
  'GetRadarModuleName',
  // Same shape: the engine answers `Obsolete since version 3.20, returns empty data!`,
  // so the declared return is the documentation's and no call has confirmed it.
  'GetTradeRestrictions',
]);

// Called in the running game, with a reading worth having.
const probed = (name) => !!(docs[name] && docs[name].probed) && !PARKED.has(name);

// Evidence from outside vanilla, for a name vanilla never calls. Another mod's call
// site is weaker than a probe - it is a reading of someone else's code, not of the
// engine - so on its own it leaves the verdict unverified and the detail says where it
// came from. Where a probe has since answered, the probe sets the verdict and this only
// keeps the site: the reading is still worth linking, it is just no longer the evidence.
// It lives here because write-meta.js owns the "Usage:" and "Seen at:" lines and
// drops anything hand-written into them on its next run.
const EXTERNAL = {
  FindJumpRoute: {
    detail: 'no vanilla call site; signature and return confirmed against kuertee_ui_extensions',
    probedDetail: 'in-game probe, no vanilla call site; also read against kuertee_ui_extensions',
    sites: [{ rel: 'kuertee_ui_extensions ui/addons/ego_detailmonitor/menu_map.xpl', line: 34321 }],
  },
};

// What the declaration accepts. A trailing "..." makes the maximum open, and a
// parameter marked optional in its ---@param line lowers the minimum.
function arity(d) {
  const args = d && d.args ? d.args : [];
  const vararg = args[args.length - 1] === '...';
  const fixed = vararg ? args.slice(0, -1) : args;
  const opt = new Set(d ? d.params.filter(p => p.optional).map(p => p.name) : []);
  return { min: fixed.filter(a => !opt.has(a)).length, max: vararg ? Infinity : fixed.length, vararg };
}

const range = (lo, hi) => lo === hi ? String(lo) : lo + '-' + hi;
const plural = (n, w) => n + ' ' + w + (n === 1 ? '' : 's');

// The exe's reading for one version. max '*' means the walk was accepted at 40
// arguments, so the engine checks no upper bound. Under a 'silent' gate a count in
// noop_at returns nothing without a word, so it is not accepted. Under a logged one
// noop_at only means the walk saw no call: ScheduleReloadUI's whole job is a flag write.
function staticOf(name, v) {
  const r = ARITY[v] && ARITY[v][name];
  if (!r || r.gate === 'none' || r.min == null) return null;
  const noop = r.gate === 'silent' && !!r.noop_at;
  let min = r.min;
  while (noop && r.noop_at.includes(min)) min++;
  // Under 'raises' the count is Lua's own luaL_check* error, and a check behind a branch is
  // not seen, so the minimum is a floor rather than the exact count.
  return { min, max: r.max === '*' ? Infinity : r.max, warns: !!r.warn_runs_anyway, noop, floor: r.gate === 'raises' };
}

const staticRange = (s) => s.max === Infinity ? s.min + ' or more' : range(s.min, s.max);

function staticText(name, v) {
  const r = ARITY[v] && ARITY[v][name];
  if (!r) return null;
  const s = staticOf(name, v);
  if (s) return staticRange(s) + (s.warns ? ' (more are logged, then ignored)' : '') +
    (s.floor ? ' (fewer raise a Lua error)' : '') +
    (s.noop ? ' (fewer return silently, doing nothing)' : '');
  if (r.deprecated) return 'not checked (deprecated)';
  if (r.stub) return 'not checked (a no-op stub)';
  return 'not checked';
}

// The generated "Arity:" line, or null where X4.exe registers no such name.
function arityLine(name) {
  const read = ['8.00', '9.00'].filter(v => ARITY[v] && ARITY[v][name]);
  if (!read.length) return null;
  const texts = read.map(v => staticText(name, v));
  return texts.every(t => t === texts[0])
    ? texts[0] + ' - X4.exe ' + read.join(', ')
    : read.map((v, i) => texts[i] + ' on ' + v).join(', ') + ' - X4.exe';
}

function usageOf(name) {
  const e = DATA[name];
  if (!e) return null;
  const d = docs[name];

  // Read the evidence from the newest version that has any, so a global whose
  // last call site went away in 9.00 still reports the 8.00 one.
  const total = (v) => {
    const a = e.args[v] || { counts: {}, open: 0, unreadable: 0 };
    return Object.values(a.counts).reduce((s, n) => s + n, 0) + a.open + a.unreadable;
  };
  const isVar = e.group !== 'function';
  const has = (v) => isVar ? (e.refs[v] || 0) : total(v);
  const v = has(NEWEST) ? NEWEST : has(OLDER) ? OLDER : NEWEST;
  const only = v === OLDER ? ' (8.00 only)' : '';
  const sites = e.sites && e.sites[v] ? e.sites[v] : [];

  if (isVar) {
    const refs = e.refs[v] || 0;
    if (refs) return { verdict: 'confirmed', detail: plural(refs, 'vanilla reference') + only, sites, kind: 'variable' };
    return probed(name)
      ? { verdict: 'confirmed', detail: 'in-game probe, no vanilla reference', sites: [], kind: 'variable' }
      : { verdict: 'unverified', detail: 'no vanilla reference', sites: [], kind: 'variable' };
  }

  const a = e.args[v] || { counts: {}, open: 0, unreadable: 0 };
  const n = total(v);
  const decl = arity(d);
  const takes = decl.vararg
    ? decl.min + (decl.min === 1 ? ' argument' : ' arguments') + ' plus a vararg tail'
    : decl.min === decl.max ? plural(decl.min, 'argument')
    : decl.min + '-' + decl.max + ' arguments';

  // The declaration describes the newest game, so 8.00's reading counts only for a name 9.00 lacks.
  const st = staticOf(name, ARITY[NEWEST][name] ? NEWEST : OLDER);
  if (st && ((st.floor ? decl.min < st.min : decl.min !== st.min) || (st.max !== Infinity && decl.max !== st.max)))
    return {
      verdict: 'disputed', kind: 'function', sites, decl,
      detail: 'X4.exe accepts ' + staticRange(st) + ', the declaration takes ' + takes,
    };
  const exe = st ? 'X4.exe count check, ' : '';

  if (!n) {
    const ex = EXTERNAL[name];
    if (st)
      return {
        verdict: 'confirmed', kind: 'function',
        detail: exe + (ex ? ex.probedDetail.replace(/^in-game probe, /, '') : 'no vanilla call site'),
        sites: ex ? ex.sites : [],
      };
    if (probed(name))
      return {
        verdict: 'confirmed', kind: 'function',
        detail: ex ? ex.probedDetail : 'in-game probe, no vanilla call site',
        sites: ex ? ex.sites : [],
      };
    if (ex) return { verdict: 'unverified', detail: ex.detail, sites: ex.sites, kind: 'function' };
    return { verdict: 'unverified', detail: 'no vanilla call site', sites: [], kind: 'function' };
  }

  const seen = Object.keys(a.counts).map(Number).sort((x, y) => x - y);

  const head = plural(n, 'vanilla call site') + only;
  if (!seen.length)  // every site forwards "..." or unpack(), so no count is readable
    return { verdict: 'confirmed', detail: exe + head + ', all forwarding an unread argument list', sites, kind: 'function' };

  const lo = seen[0], hi = seen[seen.length - 1];
  const passes = lo === hi ? plural(lo, 'argument') : range(lo, hi) + ' arguments';
  if (lo >= decl.min && hi <= decl.max)
    return { verdict: 'confirmed', detail: exe + head + ', ' + passes, sites, kind: 'function', seen, decl };

  return {
    verdict: 'disputed', kind: 'function', sites, seen, decl,
    detail: head + ' pass ' + passes + ', the declaration takes ' + takes,
  };
}

const verdicts = {};
for (const n of Object.keys(DATA)) verdicts[n] = usageOf(n);

module.exports = { usageOf, verdicts, arity, arityLine, staticOf };

/* ------------------------------------------------------------- report */

if (require.main === module) {
  const names = Object.keys(DATA);
  const by = (o, f) => names.filter(n => verdicts[n] && verdicts[n].verdict === o && f(n));
  const engine = (n) => DATA[n].origin === 'engine';
  const tally = (f) => ['confirmed', 'disputed', 'unverified']
    .map(o => o + ': ' + by(o, f).length).join('   ');

  console.log('all globals   ' + tally(() => true));
  console.log('engine only   ' + tally(engine));
  console.log('');

  const dis = by('disputed', () => true);
  console.log(dis.length + ' disputed declarations - X4.exe or vanilla disagrees with the declared count:\n');
  for (const n of dis) {
    const u = verdicts[n];
    console.log('  ' + n);
    console.log('    declared  ' + (docs[n] ? docs[n].signature : '?') +
      '   -> takes ' + range(u.decl.min, u.decl.max === Infinity ? '...' : u.decl.max));
    console.log('    ' + (u.seen ? 'vanilla   passes ' + u.seen.join(', ') + '   ' : '') + u.detail);
    for (const s of u.sites.slice(0, 3)) console.log('      ' + s.rel + ':' + s.line + '  (' + s.n + ' args)');
  }
}
