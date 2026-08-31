// The shared page shell: theme, tone palette, the shared components, header,
// breadcrumb and footer.
//
// Every builder renders through this - src/build.js for the Markdown pages,
// src/globals/build-html.js and src/commands/build-html.js for the generated
// references - so the site has one theme, one navigation and one set of component
// styles. A page's own CSS adds only what is genuinely its own; anything two pages
// would both want belongs here.

// `origin` is the published base, needed wherever a URL cannot be root-relative:
// sitemap.xml, robots.txt and the canonical link.
const SITE = {
  title: 'Chem O’Dun',
  tagline: 'References and Guides',
  origin: 'https://chemodun.github.io',
};

// The icon is the GitHub profile picture, at the sizes GitHub itself resized it to.
// favicon.ico is built from the two small PNGs so nothing derived is committed.
const ICON_LINKS = `<link rel="icon" href="/favicon.ico" sizes="16x16 32x32">
<link rel="icon" type="image/png" href="/favicon-32.png" sizes="32x32">
<link rel="apple-touch-icon" href="/apple-touch-icon.png">`;

const LIGHT = '--bg:#fff;--fg:#1f2328;--dim:#59636e;--line:#d1d9e0;--soft:#f6f8fa;--acc:#0969da';
const DARK = '--bg:#0d1117;--fg:#e6edf3;--dim:#9198a1;--line:#3d444d;--soft:#161b22;--acc:#4493f8';

// Tone palette. Hue is tied to meaning, not to a column:
//   blue = engine, magenta = widget system, cyan = addons,
//   green = all / verified / present, yellow = uncertain,
//   red = removed, orange = new, grey = absent.
// It lives here because both generated references badge with it; globals/badges.js
// re-exports it for the wiki builder, which needs the raw values not the CSS tokens.
const TONES = {
  engine: { hue: '#1d4ed8', pale: '#e5edff', dim: '#152a5e', lite: '#61afef' },  // blue     7.3
  widget: { hue: '#7c3aed', pale: '#f0e8ff', dim: '#2e1065', lite: '#c678dd' },  // magenta  5.9
  addon:  { hue: '#0d9488', pale: '#d9f2ef', dim: '#0b3d38', lite: '#56b6c2' },  // cyan     7.3
  ok:     { hue: '#15803d', pale: '#e3f5e9', dim: '#0d3320', lite: '#98c379' },  // green    8.6
  warn:   { hue: '#a16207', pale: '#fdf3e0', dim: '#3d2708', lite: '#e5c07b' },  // yellow  10.0
  gone:   { hue: '#b91c1c', pale: '#fdeaea', dim: '#450a0a', lite: '#e06c75' },  // red      5.4
  new:    { hue: '#0284c7', pale: '#e0f2fe', dim: '#0c3a52', lite: '#d19a66' },  // orange   7.0
  no:     { hue: '#475569', pale: '#eef1f3', dim: '#20272f', lite: '#8b929e' },  // grey     5.5
};

const toneVars = (pick) => Object.entries(TONES).map(([k, t]) => `--t-${k}:${pick(t)};`).join('');
const TONE_CLASSES = Object.keys(TONES).map((k) => `.t-${k}{color:var(--t-${k})}`).join('');

// Light is the bare :root so the palette is always complete; dark only redefines
// tokens, once for the system preference and once for an explicit choice.
const BASE_CSS = `
:root{${LIGHT};${toneVars((t) => t.hue)}}
@media (prefers-color-scheme:dark){:root:not([data-theme=light]){${DARK};${toneVars((t) => t.lite)}}}
:root[data-theme=dark]{${DARK};${toneVars((t) => t.lite)}}
/* One monospace stack for the whole site. Chrome on Windows knows neither ui-monospace
   nor SFMono-Regular, so whatever comes next is what a Windows reader actually sees. */
:root{--mono:ui-monospace,SFMono-Regular,Consolas,"Liberation Mono",Menlo,monospace}
${TONE_CLASSES}
b[class^=t-]{font-weight:700;white-space:nowrap}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--fg);
  font:15px/1.6 -apple-system,BlinkMacSystemFont,"Segoe UI",Helvetica,Arial,sans-serif}
.wrap{max-width:1100px;margin:0 auto;padding:0 16px 96px}
a{color:var(--acc)}
h1{font-size:1.9rem;margin:.2em 0 .4em}
h2{font-size:1.35rem;margin:2em 0 .6em;padding-bottom:.3em;border-bottom:1px solid var(--line)}
h3{font-size:1.1rem;margin:1.6em 0 .5em}
h1,h2,h3,h4{line-height:1.3;overflow-wrap:anywhere}
code{font-family:var(--mono);font-size:.9em;background:var(--soft);padding:.1em .35em;
  border-radius:4px}
pre{background:var(--soft);border:1px solid var(--line);border-radius:6px;padding:10px 12px;
  overflow-x:auto;margin:.7em 0}
pre code{background:none;padding:0;font-size:.88em}
blockquote{margin:.8em 0;padding:.1em 1em;border-left:3px solid var(--line);color:var(--dim)}
table{border-collapse:collapse;width:100%;margin:.8em 0;font-size:.92rem}
th,td{border:1px solid var(--line);padding:6px 9px;text-align:left;vertical-align:top}
th{background:var(--soft);font-weight:600}
.tw{overflow-x:auto}
hr{border:0;border-top:1px solid var(--line);margin:2em 0}
/* A lead is set apart by tone and size, not by a narrower measure: every authored page
   runs its prose the full width of .wrap, and a reference whose intro stopped short of
   that read as a different site. */
.lede{color:var(--dim);font-size:1.02rem}

header.top{border-bottom:1px solid var(--line);background:var(--soft)}
header.top .in{max-width:1100px;margin:0 auto;padding:11px 16px;display:flex;
  gap:1em;align-items:center;flex-wrap:wrap}
/* Everything but the panel toggle is one group, so the header can be split into the
   layout's two columns without the title and the theme button drifting apart. */
header.top .ttl{flex:1;min-width:0;display:flex;gap:1em;align-items:center;
  flex-wrap:wrap}
header.top .brand{font-weight:700;color:var(--fg);text-decoration:none}
header.top .tagline{color:var(--dim);font-size:.88rem;flex:1}
button.theme,button.navt{display:flex;align-items:center;justify-content:center;
  width:32px;height:32px;
  padding:0;border:1px solid var(--line);border-radius:6px;background:var(--bg);
  color:var(--dim);cursor:pointer}
button.theme:hover,button.navt:hover{color:var(--acc);border-color:var(--acc)}
button.theme svg,button.navt svg{width:16px;height:16px;fill:none;stroke:currentColor;
  stroke-width:1.6;stroke-linecap:round}
/* Show the theme you would switch TO. Default (no attribute) follows the system, so
   the swap has to be expressed once per media state and once per explicit choice. */
button.theme .sun{display:none}
@media (prefers-color-scheme:dark){
  :root:not([data-theme=light]) button.theme .moon{display:none}
  :root:not([data-theme=light]) button.theme .sun{display:block}}
:root[data-theme=dark] button.theme .moon{display:none}
:root[data-theme=dark] button.theme .sun{display:block}
nav.crumb{font-size:.86rem;color:var(--dim);padding:12px 0 4px}
nav.crumb a{text-decoration:none}
nav.crumb a:hover{text-decoration:underline}
nav.crumb .sep{padding:0 .45em;opacity:.6}

p.wikiref{margin:1em 0 1.5em;padding:12px 16px;border:1px solid var(--line);
  border-left:4px solid var(--acc);border-radius:8px;background:var(--soft)}
p.wikiref a{font-weight:600}

ul.cards{list-style:none;padding:0;margin:1.2em 0;display:grid;gap:10px}
ul.cards li{border:1px solid var(--line);border-radius:8px;padding:12px 15px}
ul.cards a{font-weight:600;text-decoration:none;font-size:1.02rem}
ul.cards a:hover{text-decoration:underline}
ul.cards p{margin:.35em 0 0;color:var(--dim);font-size:.92rem}

footer.bot{border-top:1px solid var(--line);margin-top:3em;padding:16px 0;
  color:var(--dim);font-size:.86rem}
@media(max-width:720px){.wrap{padding:0 10px 60px}}
`;

// Components every reference page draws from, so a filter bar, a disclosure header or
// a callout is the same object wherever it appears. Sizes are set once, here.
const COMPONENT_CSS = `
.hide{display:none!important}

/* the filter bar over a long list */
.bar{position:sticky;top:0;z-index:5;background:var(--bg);border-bottom:1px solid var(--line);
  padding:10px 0;margin-bottom:14px;display:flex;gap:10px;flex-wrap:wrap;align-items:center}
.bar input{flex:1;min-width:220px}
.bar input,.bar select,.bar button{padding:7px 10px;border:1px solid var(--line);
  border-radius:6px;background:var(--soft);color:var(--fg);font:inherit}
.bar button{cursor:pointer}
.bar button:hover{border-color:var(--acc);color:var(--acc)}
.bar .n{color:var(--dim);font-size:.86rem;white-space:nowrap}
/* The bar is sticky, so anything scrolled to by a deep link or an in-page anchor
   lands under it. --barh is measured by the script below - the bar's height changes as
   its controls wrap - and is unset on a page that has no bar, which is why the fallback
   is 0. */
[id]{scroll-margin-top:calc(var(--barh, 0px) + 10px)}

/* Column legend: the last line of a filter bar, naming the fixed columns of the list
   under it. It lives inside the bar so it sticks with it - a separate sticky element
   would need the bar's height, which changes as the controls wrap. The template is the
   list's own, so a page declares --cols once and the rows and the legend share it, and
   the font-size has to match the row header's .92rem or the em in that template
   resolves smaller here and every label drifts off its column. The padding is the
   disclosure chevron's gutter plus the 1px border of the box the rows sit in. */
.bar .leg{flex:1 0 100%;display:grid;grid-template-columns:var(--cols);gap:.6em;
  align-items:baseline;margin:-2px 0 -6px;padding:0 15px 0 33px;font-size:.92rem;
  color:var(--dim)}
.bar .leg span{font-size:.72em;letter-spacing:.06em;text-transform:uppercase;
  white-space:nowrap;overflow:hidden;text-overflow:ellipsis;cursor:default}

/* One disclosure control for the whole site. A page decides the header's own layout;
   the chevron, its gutter, the type sizes and the hover tone are defined only here.
   It has to work on a <summary> and on a <button>, so an [open] parent and a
   JS-driven .open parent both turn it. display:flex on a <summary> drops the native
   marker, which is why the chevron is drawn rather than inherited - and it is
   positioned, not laid out, or it centres against a wrapped header and leaves the
   first line. */
.disc{position:relative;width:100%;margin:0;padding:9px 14px 9px 32px;text-align:left;
  border:0;background:none;color:inherit;font:inherit;font-size:.92rem;line-height:1.6;
  cursor:pointer;border-radius:7px;list-style:none}
.disc::-webkit-details-marker{display:none}
.disc::before{content:"";position:absolute;left:15px;top:calc(9px + .58em);
  width:.45em;height:.45em;border:2px solid var(--dim);border-top:0;border-left:0;
  transform:rotate(-45deg);transition:transform .15s ease}
[open]>.disc::before,.open>.disc::before{transform:rotate(45deg)}
.disc:hover{background:var(--soft)}
.disc:hover::before{border-color:var(--acc)}
/* The name is what a reader most often wants out of the page, and a header is a
   button or a summary, both of which swallow a drag. Selectable, explicitly. */
.disc .nm{font-family:var(--mono);font-weight:600;font-size:.95rem;background:none;
  padding:0;overflow-wrap:anywhere;user-select:text;-webkit-user-select:text;cursor:text}
.disc:hover .nm{color:var(--acc)}
.disc .sum{color:var(--dim);font-size:.88rem}

/* copy controls, in what a header opens */
p.copyrow{display:flex;flex-wrap:wrap;gap:.45em;align-items:center;margin:.7em 0 0}
button.copy{font:inherit;font-size:.8rem;line-height:1.5;padding:2px 9px;cursor:pointer;
  border:1px solid var(--line);border-radius:5px;background:var(--bg);color:var(--dim)}
button.copy:hover{border-color:var(--acc);color:var(--acc)}
button.copy.done{border-color:var(--t-ok);color:var(--t-ok)}

/* version presence: a range in a header, spelled out in what the header opens */
.vs{white-space:nowrap;font-size:.85rem;font-weight:700}
.new{color:var(--t-new);font-weight:700;font-size:.72em;letter-spacing:.04em;
  margin-left:.35em;vertical-align:.12em}
p.vers{margin:.4em 0 0;font-size:.88rem}
p.vers .k{color:var(--dim);margin-right:.5em}

/* a row of badges, a small outline chip, a row of link chips */
.badges{display:flex;flex-wrap:wrap;gap:.15em .9em;margin:.2em 0 .7em;font-size:.86rem}
.tag{display:inline-block;font-size:.72rem;line-height:1.7;padding:0 .45em;
  border:1px solid var(--line);border-radius:3px;color:var(--dim);white-space:nowrap}
.tag.act{border-color:var(--acc);color:var(--acc)}
.chips{display:flex;flex-wrap:wrap;gap:.4em;margin:.4em 0}
.chips a{border:1px solid var(--line);border-radius:4px;padding:.15em .5em;
  text-decoration:none;font-family:var(--mono);font-size:.86rem}
.chips a:hover{background:var(--fg);color:var(--bg)}
.chips a .c{color:var(--dim)}
.chips a:hover .c{color:var(--bg)}

/* a callout strip: one action on the left, one sentence of context on the right */
.dl{display:flex;flex-wrap:wrap;gap:.6em 1.1em;align-items:center;margin:1.2em 0;
  padding:13px 16px;border:1px solid var(--line);border-radius:8px;background:var(--soft)}
.dl a.btn{font-weight:600;text-decoration:none;white-space:nowrap;padding:7px 14px;
  border:1px solid var(--acc);border-radius:6px;color:var(--acc)}
.dl a.btn:hover{background:var(--acc);color:var(--bg)}
.dl a.btn code{background:none;padding:0;color:inherit;font-size:.96em}
.dl p{flex:1 1 26em;margin:0;color:var(--dim);font-size:.9rem}

/* a standalone collapsible box in prose. Scoped to .box: the reference pages build
   their own cards out of <details> and must not pick this up. */
details.box{border:1px solid var(--line);border-radius:8px;padding:10px 14px;margin:1em 0;
  background:var(--soft)}
details.box>summary{cursor:pointer;font-weight:600}
`;

// The navigation panel. The page keeps its 1100px measure and the panel is added
// beside it rather than taken out of it, so the reference tables are exactly as wide
// as they were before the panel existed; --sw going to 0 restores the old layout
// pixel for pixel. The header's own block is widened to match, so its left edge lines
// up with the panel and its right edge with the content, at either width.
const NAV_CSS = `
:root{--sw:300px}
.layout{max-width:calc(1100px + var(--sw));margin:0 auto;
  display:grid;grid-template-columns:var(--sw) minmax(0,1fr)}
/* Both columns are named rather than left to auto-placement. Hiding the panel takes it
   out of the grid entirely, and the content then auto-places into what is now a
   zero-width first column: 1100px of layout with the page squeezed to 273px inside it,
   and no sign of it on a page whose tables are wide enough to overflow the column.
   The page's own auto margins go with it. They centred .wrap when it was a block in
   the body, but an auto margin on a grid item cancels the stretch it would otherwise
   get, so prose pages took their content's width and stopped short of the column.
   The layout box is what is centred now, and the page fills its column. */
.layout>nav.side{grid-column:1}
.layout>.wrap{grid-column:2;margin-inline:0}
header.top .in{max-width:calc(1100px + var(--sw))}

nav.side{position:sticky;top:0;align-self:start;max-height:100vh;overflow-y:auto;
  padding:14px 12px 40px;font-size:.9rem;border-right:1px solid var(--line)}
nav.side ul{list-style:none;margin:0;padding:0}
nav.side>ul>li,nav.side details{margin:1px 0}
/* Depth is a rule to the left of the nesting, not an indent that disappears the moment
   a title wraps to a second line. */
nav.side ul ul{margin:1px 0 3px .55em;padding-left:.75em;border-left:1px solid var(--line)}
nav.side a{flex:1 1 auto;min-width:0;overflow-wrap:break-word;color:var(--fg);
  text-decoration:none;border-radius:5px;padding:1px 4px}
nav.side a:hover{color:var(--acc);background:var(--soft)}
nav.side a.here{color:var(--acc);font-weight:600;background:var(--soft)}
/* A page that is only on the wiki is still a real destination, so it is dimmed rather
   than greyed out: the tree reads as this site's pages first, at a glance, without
   having to read a chip on every row. */
nav.side a.ext{color:var(--dim)}
nav.side a.ext:hover{color:var(--acc)}
nav.side li{padding:2px 0;line-height:1.45}
/* Title and chips are a row, not a run of text: a title long enough to wrap must take
   the width it needs and leave its chips where every other row's chips are. */
nav.side li.leaf,nav.side summary{display:flex;align-items:flex-start;gap:.35em}
/* A leaf lines up with the titles above it, not with their chevrons. */
nav.side li.leaf{padding-left:17px}
nav.side summary{list-style:none;cursor:pointer;position:relative;padding-left:17px;
  border-radius:5px}
nav.side summary::-webkit-details-marker{display:none}
nav.side summary::before{content:"";position:absolute;left:4px;top:.42em;
  width:.4em;height:.4em;border:2px solid var(--dim);border-top:0;border-left:0;
  transform:rotate(-45deg);transition:transform .15s ease}
nav.side details[open]>summary::before{transform:rotate(45deg)}
nav.side summary:hover::before{border-color:var(--acc)}

/* Where the page can be read. currentColor takes the tone class's colour into the
   border, so one rule covers both chips in both themes. */
nav.side .mk{flex:0 0 auto;padding-top:.15em}
nav.side .nb{display:inline-block;padding:0 .3em;
  border:1px solid currentColor;border-radius:3px;
  font-size:.6rem;font-weight:600;line-height:1.6;letter-spacing:.03em;
  text-transform:uppercase;white-space:nowrap;opacity:.8;cursor:default}

/* The desktop toggle is a preference and is remembered; the mobile drawer is not, so
   the two are separate attributes and the panel cannot be left hidden on a phone by a
   choice made on a desktop. */
@media(min-width:901px){
  :root[data-nav=off]{--sw:0px}
  :root[data-nav=off] nav.side{display:none}
  /* The title reads as the page's, not the panel's, so the header takes the layout's
     own two columns: the toggle keeps the panel's column and everything else starts
     where the page does. With the panel hidden there is no column to line up with, so
     the row closes back up behind the toggle. */
  header.top .in{display:grid;grid-template-columns:var(--sw) minmax(0,1fr);
    column-gap:0}
  :root[data-nav=off] header.top .in{grid-template-columns:auto minmax(0,1fr);
    column-gap:1em}
}
@media(max-width:900px){
  :root{--sw:0px}
  .layout{display:block;max-width:1100px}
  header.top .in{max-width:1100px}
  /* align-self has to go back to auto with the sticky layout it belongs to. It applies
     to a fixed box as much as to a grid item, and an explicit alignment makes the box
     shrink to its content instead of filling top:0/bottom:0 - which left the drawer
     ending halfway down the screen with the page showing under it. */
  nav.side{position:fixed;z-index:20;top:0;left:0;bottom:0;width:min(82vw,320px);
    align-self:auto;max-height:none;padding-top:16px;background:var(--bg);
    transform:translateX(-100%);transition:transform .18s ease;
    box-shadow:0 6px 24px rgba(0,0,0,.3)}
  :root[data-navopen=on] nav.side{transform:none}
  :root[data-navopen=on] body::after{content:"";position:fixed;inset:0;z-index:10;
    background:rgba(0,0,0,.4)}
}
@media(prefers-reduced-motion:reduce){nav.side{transition:none}}
`;

const esc = (s) => String(s ?? '')
  .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');

// Version presence as a range, not a tick per version. One column per version stops
// fitting as soon as the game has a few more of them, and the two answers a reader
// actually gets are "all of them" and "all of them from here on". `all` and `none`
// are named rather than ranged; a set with a hole in it falls back to listing itself,
// because there is no honest range for that.
//
// `all` is every version the reference covers, oldest first; `present` is the subset
// that has the thing. Returns a short token for a header, a sentence for what the
// header opens, and the tone both are drawn in.
function versionRange(all, present) {
  const on = all.filter((v) => present.includes(v));
  const last = on[on.length - 1];
  if (!on.length) return { short: 'none', long: `in none of ${all.join(', ')}`, tone: 'no' };
  if (on.length === all.length) {
    return { short: 'all', long: `in every covered version (${all.join(', ')})`, tone: 'ok' };
  }
  if (all.indexOf(last) - all.indexOf(on[0]) + 1 !== on.length) {
    return { short: on.join(', '), long: `in ${on.join(', ')} only`, tone: 'warn' };
  }
  if (last === all[all.length - 1]) {
    return {
      short: '≥ ' + on[0],
      long: on.length === 1 ? `new in ${on[0]}` : `from ${on[0]} onwards, not in ${all[0]}`,
      tone: 'new',
    };
  }
  return {
    short: '≤ ' + last,
    long: `up to ${last}, gone in ${all[all.indexOf(last) + 1]}`,
    tone: 'gone',
  };
}

// Root-relative: this is a user site, so the domain root is the site root.
const href = (p) => '/' + String(p).replace(/^\/+|\/+$/g, '').split('/').filter(Boolean)
  .map(encodeURIComponent).join('/') + (p === '' || p === '/' ? '' : '/');

// The same section on the Egosoft wiki, where the material is also published. A page
// names only its own wiki segment; the full path is assembled from its parents.
const WIKI = 'https://wiki.egosoft.com/';
const wikiUrl = (segs) => WIKI + segs.map(encodeURIComponent).join('/') + '/';

// The link text is the page's own wiki value - or its wikiName, where the wiki page's
// title is not its URL segment - so what a reader clicks is the name of the page they land on.
const wikiRef = (segs, name) => segs.length
  ? `<p class="wikiref">For more details and additional information, check ` +
    `<a href="${wikiUrl(segs)}">${esc(name || segs[segs.length - 1])}</a>` +
    ` on the Egosoft wiki.</p>`
  : '';

// The legend over a fixed-column list: [what the column is called here, what the card
// calls it]. The short label is all the column's width allows, so the long one is its
// tooltip - the same trick the badges in a row use.
const legend = (cols) => '<div class="leg">' +
  cols.map(([short, long]) => `<span${long ? ` title="${esc(long)}"` : ''}>${esc(short)}</span>`).join('') +
  '</div>';

function crumbs(trail) {
  if (!trail.length) return '';
  const parts = trail.map((c, i) => i === trail.length - 1
    ? `<span>${esc(c.label)}</span>`
    : `<a href="${c.href}">${esc(c.label)}</a>`);
  return `<nav class="crumb">${parts.join('<span class="sep">/</span>')}</nav>`;
}

// Runs before the body paints, so a stored choice never shows as a flash of the
// other theme. localStorage throws in some embedding contexts - never let it break
// the page. The IIFE is not decoration: a bare `var` here is a global binding, and a
// page script that later declares the same name with let/const fails to parse whole.
// The navigation panel is read here too: a collapsed panel that paints and then
// vanishes is the same flash as the wrong theme, and it moves the whole page sideways.
const THEME_HEAD = `(function(){try{var d=document.documentElement,
t=localStorage.getItem('theme');if(t)d.dataset.theme=t;
if(localStorage.getItem('nav')==='off')d.dataset.nav='off'}catch(e){}})()`;

const THEME_JS = `
(function(){
  var b=document.querySelector('button.theme');if(!b)return;
  b.addEventListener('click',function(){
    var d=document.documentElement,dark=d.dataset.theme
      ? d.dataset.theme==='dark'
      : matchMedia('(prefers-color-scheme:dark)').matches;
    d.dataset.theme=dark?'light':'dark';
    try{localStorage.setItem('theme',d.dataset.theme)}catch(e){}
  });
})();`;

// One clipboard handler for the site, delegated from the document so a card built
// after load is covered without rewiring. A button carries one of `data-copy` (the
// text itself), `data-copy-sel` (a selector, read out of the card the button is in,
// so text already on the page is never shipped twice) or `data-copy-link` (a
// fragment, joined to this page's URL). navigator.clipboard needs a secure context,
// so there is an execCommand path for a local file:// view.
const COPY_JS = `
(function(){
  function put(s){
    if(navigator.clipboard&&window.isSecureContext)return navigator.clipboard.writeText(s);
    return new Promise(function(res,rej){
      var t=document.createElement('textarea');t.value=s;
      t.style.cssText='position:fixed;top:-1000px';document.body.appendChild(t);
      t.select();var ok=false;try{ok=document.execCommand('copy')}catch(e){}
      document.body.removeChild(t);ok?res():rej();
    });
  }
  document.addEventListener('click',function(e){
    var b=e.target.closest?e.target.closest('button.copy'):null;if(!b)return;
    e.preventDefault();e.stopPropagation();
    var s=b.dataset.copy||'';
    if(!s&&b.dataset.copySel){
      var scope=b.closest('.card,.row,details,section')||document,
          el=scope.querySelector(b.dataset.copySel);
      s=el?el.textContent:'';
    }
    if(!s&&b.dataset.copyLink!==undefined){
      var frag=b.dataset.copyLink||('#'+((b.closest('[id]')||{}).id||''));
      if(frag.length>1)s=location.origin+location.pathname+frag;
    }
    if(!s)return;
    var was=b.getAttribute('data-label')||b.textContent;
    b.setAttribute('data-label',was);
    put(s).then(function(){b.textContent='Copied';b.classList.add('done');},
                function(){b.textContent='Copy failed';})
      .then(function(){setTimeout(function(){b.textContent=was;b.classList.remove('done');},1400);});
  });
})();`;

// Publishes the sticky bar's height as --barh, so scroll-margin-top can clear it at
// whatever width the controls happen to wrap at.
const BAR_JS = `
(function(){
  var bar=document.querySelector('.bar');if(!bar)return;
  function set(){document.documentElement.style.setProperty('--barh',bar.offsetHeight+'px');}
  set();addEventListener('resize',set);
})();`;

// One button, two jobs, because a panel means something different at each width: on a
// desktop it is a preference that persists, on a phone it is a drawer that opens over
// the page and is closed again by anything - the backdrop, Escape, following a link.
const NAV_JS = `
(function(){
  var b=document.querySelector('button.navt'),side=document.querySelector('nav.side');
  if(!b||!side)return;
  var d=document.documentElement;
  var narrow=function(){return matchMedia('(max-width:900px)').matches;};
  var open=function(){return narrow()?d.dataset.navopen==='on':d.dataset.nav!=='off';};
  function set(v){
    if(narrow())d.dataset.navopen=v?'on':'off';
    else{d.dataset.nav=v?'on':'off';try{localStorage.setItem('nav',d.dataset.nav)}catch(e){}}
    b.setAttribute('aria-expanded',String(v));
  }
  set(open());
  b.addEventListener('click',function(e){e.stopPropagation();set(!open());});
  document.addEventListener('keydown',function(e){
    if(e.key==='Escape'&&narrow()&&open())set(false);});
  document.addEventListener('click',function(e){
    if(!narrow()||!open())return;
    if(e.target.closest('nav.side'))return;
    set(false);});
  // The title of a section is a link and a fold at once. A click on the link is going
  // somewhere, so it must not also fold the section on the way out.
  side.addEventListener('click',function(e){
    if(e.target.closest('summary a'))e.stopPropagation();});
})();`;

const NAV_ICON = `<svg viewBox="0 0 16 16" aria-hidden="true">\
<path d="M2 4h12M2 8h12M2 12h12"/></svg>`;

const ICONS = `<svg class="moon" viewBox="0 0 16 16" aria-hidden="true">\
<path d="M13.5 9.5A5.6 5.6 0 016.5 2.5a5.6 5.6 0 107 7z"/></svg>\
<svg class="sun" viewBox="0 0 16 16" aria-hidden="true">\
<circle cx="8" cy="8" r="3.1"/><path d="M8 .9v1.7M8 13.4v1.7M2 2l1.2 1.2M12.8 12.8L14 14\
M.9 8h1.7M13.4 8h1.7M2 14l1.2-1.2M12.8 3.2L14 2"/></svg>`;

// The page's own js gets its own <script> and its own scope: a parse error or a name
// clash in it must not take the theme toggle down with it.
// `url` is the page's own address, which the navigation panel marks as where the reader
// is. Every builder already ends its trail there, so only a page with no trail - the
// home page, the 404 - has to say so itself.
//
// nav.js is required here rather than at the top because it requires this file back,
// for the escaping and the wiki URLs. By the time a page is rendered this module is
// fully loaded, so the cycle never resolves to a half-built object.
function shell({ title, description = '', trail = [], body, css = '', js = '',
                 url = trail.length ? trail[trail.length - 1].href : '' }) {
  const { navHtml } = require('./nav.js');
  const full = title === SITE.title ? title : `${title} - ${SITE.title}`;
  return `<!doctype html>
<html lang="en"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>${esc(full)}</title>
${description ? `<meta name="description" content="${esc(description)}">` : ''}
${ICON_LINKS}
<script>${THEME_HEAD}</script>
<style>${BASE_CSS}${COMPONENT_CSS}${NAV_CSS}${css}</style>
</head><body>
<header class="top"><div class="in">
<button class="navt" type="button" aria-controls="side" aria-expanded="true"
  title="Show or hide the navigation" aria-label="Show or hide the navigation">${NAV_ICON}</button>
<div class="ttl">
<a class="brand" href="/">${esc(SITE.title)}</a><span class="tagline">${esc(SITE.tagline)}</span>
<button class="theme" type="button" title="Switch between light and dark"
  aria-label="Switch between light and dark">${ICONS}</button>
</div>
</div></header>
<div class="layout">
${navHtml(url)}
<div class="wrap">
${crumbs(trail)}
${body}
<footer class="bot">Corrections welcome on
<a href="https://github.com/chemodun/chemodun.github.io">GitHub</a>.</footer>
</div>
</div>
<script>${THEME_JS}${COPY_JS}${BAR_JS}${NAV_JS}</script>
${js ? `<script>(function(){${js}})();</script>` : ''}
</body></html>`;
}

module.exports = { SITE, TONES, BASE_CSS, COMPONENT_CSS, shell, esc, href, crumbs,
  wikiUrl, wikiRef, versionRange, legend };
