// The shared page shell: theme, header, breadcrumb, footer.
//
// Both builders render through this - src/build.js for the Markdown pages and
// src/globals/build-html.js for the generated reference - so the site has one
// theme and one navigation, defined here only.

const SITE = { title: 'Chem O’Dun', tagline: 'X4: Foundations modding' };

const LIGHT = '--bg:#fff;--fg:#1f2328;--dim:#59636e;--line:#d1d9e0;--soft:#f6f8fa;--acc:#0969da';
const DARK = '--bg:#0d1117;--fg:#e6edf3;--dim:#9198a1;--line:#3d444d;--soft:#161b22;--acc:#4493f8';

// Light is the bare :root so the palette is always complete; dark only redefines
// tokens, once for the system preference and once for an explicit choice.
const BASE_CSS = `
:root{${LIGHT}}
@media (prefers-color-scheme:dark){:root:not([data-theme=light]){${DARK}}}
:root[data-theme=dark]{${DARK}}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--fg);
  font:15px/1.6 -apple-system,BlinkMacSystemFont,"Segoe UI",Helvetica,Arial,sans-serif}
.wrap{max-width:1100px;margin:0 auto;padding:0 16px 96px}
a{color:var(--acc)}
h1{font-size:1.9rem;margin:.2em 0 .4em}
h2{font-size:1.35rem;margin:2em 0 .6em;padding-bottom:.3em;border-bottom:1px solid var(--line)}
h3{font-size:1.1rem;margin:1.6em 0 .5em}
h1,h2,h3,h4{line-height:1.3;overflow-wrap:anywhere}
code{font-family:ui-monospace,SFMono-Regular,Consolas,monospace;font-size:.9em;
  background:var(--soft);padding:.1em .35em;border-radius:4px}
pre{background:var(--soft);border:1px solid var(--line);border-radius:6px;padding:10px 12px;
  overflow-x:auto;margin:.7em 0}
pre code{background:none;padding:0;font-size:.88em}
blockquote{margin:.8em 0;padding:.1em 1em;border-left:3px solid var(--line);color:var(--dim)}
table{border-collapse:collapse;width:100%;margin:.8em 0;font-size:.94rem}
th,td{border:1px solid var(--line);padding:6px 10px;text-align:left;vertical-align:top}
th{background:var(--soft);font-weight:600}
.tw{overflow-x:auto}
hr{border:0;border-top:1px solid var(--line);margin:2em 0}
.lede{color:var(--dim);max-width:72ch;font-size:1.02rem}

header.top{border-bottom:1px solid var(--line);background:var(--soft)}
header.top .in{max-width:1100px;margin:0 auto;padding:11px 16px;display:flex;
  gap:1em;align-items:center;flex-wrap:wrap}
header.top .brand{font-weight:700;color:var(--fg);text-decoration:none}
header.top .tag{color:var(--dim);font-size:.88rem;flex:1}
button.theme{display:flex;align-items:center;justify-content:center;width:32px;height:32px;
  padding:0;border:1px solid var(--line);border-radius:6px;background:var(--bg);
  color:var(--dim);cursor:pointer}
button.theme:hover{color:var(--acc);border-color:var(--acc)}
button.theme svg{width:16px;height:16px;fill:none;stroke:currentColor;stroke-width:1.6;
  stroke-linecap:round}
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

ul.cards{list-style:none;padding:0;margin:1.2em 0;display:grid;gap:10px}
ul.cards li{border:1px solid var(--line);border-radius:8px;padding:12px 15px}
ul.cards a{font-weight:600;text-decoration:none;font-size:1.02rem}
ul.cards a:hover{text-decoration:underline}
ul.cards p{margin:.35em 0 0;color:var(--dim);font-size:.92rem}

footer.bot{border-top:1px solid var(--line);margin-top:3em;padding:16px 0;
  color:var(--dim);font-size:.86rem}
@media(max-width:720px){.wrap{padding:0 10px 60px}}
`;

const esc = (s) => String(s ?? '')
  .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');

// Root-relative: this is a user site, so the domain root is the site root.
const href = (p) => '/' + String(p).replace(/^\/+|\/+$/g, '').split('/').filter(Boolean)
  .map(encodeURIComponent).join('/') + (p === '' || p === '/' ? '' : '/');

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
const THEME_HEAD = `(function(){try{var t=localStorage.getItem('theme');
if(t)document.documentElement.dataset.theme=t}catch(e){}})()`;

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

const ICONS = `<svg class="moon" viewBox="0 0 16 16" aria-hidden="true">\
<path d="M13.5 9.5A5.6 5.6 0 016.5 2.5a5.6 5.6 0 107 7z"/></svg>\
<svg class="sun" viewBox="0 0 16 16" aria-hidden="true">\
<circle cx="8" cy="8" r="3.1"/><path d="M8 .9v1.7M8 13.4v1.7M2 2l1.2 1.2M12.8 12.8L14 14\
M.9 8h1.7M13.4 8h1.7M2 14l1.2-1.2M12.8 3.2L14 2"/></svg>`;

// The page's own js gets its own <script> and its own scope: a parse error or a name
// clash in it must not take the theme toggle down with it.
function shell({ title, description = '', trail = [], body, css = '', js = '' }) {
  const full = title === SITE.title ? title : `${title} — ${SITE.title}`;
  return `<!doctype html>
<html lang="en"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>${esc(full)}</title>
${description ? `<meta name="description" content="${esc(description)}">` : ''}
<script>${THEME_HEAD}</script>
<style>${BASE_CSS}${css}</style>
</head><body>
<header class="top"><div class="in">
<a class="brand" href="/">${esc(SITE.title)}</a><span class="tag">${esc(SITE.tagline)}</span>
<button class="theme" type="button" title="Switch between light and dark"
  aria-label="Switch between light and dark">${ICONS}</button>
</div></header>
<div class="wrap">
${crumbs(trail)}
${body}
<footer class="bot">Corrections welcome on
<a href="https://github.com/chemodun/chemodun.github.io">GitHub</a>.</footer>
</div>
<script>${THEME_JS}</script>
${js ? `<script>(function(){${js}})();</script>` : ''}
</body></html>`;
}

module.exports = { SITE, BASE_CSS, shell, esc, href, crumbs };
