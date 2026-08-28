// What vanilla's own code says about a declaration.
//
//   node usage.js            the tally, and every disputed declaration
//   require('./usage')       { usageOf, verdicts }
//
// classify.js records, per version, how many arguments vanilla passes at every
// call site of a global, plus a few example sites. Compared against the
// parameter list globals.lua declares, that yields one of three verdicts:
//
//   confirmed   vanilla calls it, and every argument count it passes fits the
//               declaration
//   disputed    vanilla passes a count the declaration cannot take - so the
//               declaration is wrong, or an optional parameter is unmarked
//   unverified  no vanilla call site at all: the signature is inherited from
//               the old wiki list or inferred, and nothing here backs it
//
// A variable is never called, so its evidence is a mention instead.

const DATA = require('./classification.json');
const { docs } = require('./docs.js');

const NEWEST = '9.00', OLDER = '8.00';

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
    return refs
      ? { verdict: 'confirmed', detail: plural(refs, 'vanilla reference') + only, sites, kind: 'variable' }
      : { verdict: 'unverified', detail: 'no vanilla reference', sites: [], kind: 'variable' };
  }

  const a = e.args[v] || { counts: {}, open: 0, unreadable: 0 };
  const n = total(v);
  if (!n) return { verdict: 'unverified', detail: 'no vanilla call site', sites: [], kind: 'function' };

  const seen = Object.keys(a.counts).map(Number).sort((x, y) => x - y);
  const decl = arity(d);
  const takes = decl.vararg
    ? decl.min + (decl.min === 1 ? ' argument' : ' arguments') + ' plus a vararg tail'
    : decl.min === decl.max ? plural(decl.min, 'argument')
    : decl.min + '-' + decl.max + ' arguments';

  const head = plural(n, 'vanilla call site') + only;
  if (!seen.length)  // every site forwards "..." or unpack(), so no count is readable
    return { verdict: 'confirmed', detail: head + ', all forwarding an unread argument list', sites, kind: 'function' };

  const lo = seen[0], hi = seen[seen.length - 1];
  const passes = lo === hi ? plural(lo, 'argument') : range(lo, hi) + ' arguments';
  if (lo >= decl.min && hi <= decl.max)
    return { verdict: 'confirmed', detail: head + ', ' + passes, sites, kind: 'function', seen, decl };

  return {
    verdict: 'disputed', kind: 'function', sites, seen, decl,
    detail: head + ' pass ' + passes + ', the declaration takes ' + takes,
  };
}

const verdicts = {};
for (const n of Object.keys(DATA)) verdicts[n] = usageOf(n);

module.exports = { usageOf, verdicts, arity };

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
  console.log(dis.length + ' disputed declarations - vanilla passes a count the declaration cannot take:\n');
  for (const n of dis) {
    const u = verdicts[n];
    console.log('  ' + n);
    console.log('    declared  ' + (docs[n] ? docs[n].signature : '?') +
      '   -> takes ' + range(u.decl.min, u.decl.max === Infinity ? '...' : u.decl.max));
    console.log('    vanilla   passes ' + u.seen.join(', ') + '   ' + u.detail);
    for (const s of u.sites.slice(0, 3)) console.log('      ' + s.rel + ':' + s.line + '  (' + s.n + ' args)');
  }
}
