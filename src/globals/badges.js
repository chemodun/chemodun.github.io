// Badge rendering for the wiki builder.
//
// The palette itself is the site's, in ../layout.js: hue is tied to meaning, not to a
// column, and both the HTML and the wiki output badge with the same eight tones. Only
// the wiki's own encoding of a badge lives here.

const { TONES } = require('../layout.js');

// Chosen 2026-08-25: pill shape, roomy padding.
const PAD = 'padding:.15em .6em;border-radius:999px;font-weight:bold;white-space:nowrap';

const MODES = {
  chip:      { label: 'chip',           desc: 'pale fill, dark text - built for a light theme',
               style: t => `color:${t.hue};background-color:${t.pale};${PAD}` },
  solid:     { label: 'solid',          desc: 'saturated fill, white text - the only one that survives both themes',
               style: t => `color:#ffffff;background-color:${t.hue};${PAD}` },
  dark:      { label: 'dark fill',      desc: 'dark tinted fill, bright text - sits inside a dark theme rather than on top of it',
               style: t => `color:${t.lite};background-color:${t.dim};${PAD}` },
  outline:   { label: 'outline',        desc: 'no fill at all, so the page background shows through either theme',
               style: t => `color:${t.lite};border:1px solid ${t.lite};${PAD}` },
  colortext: { label: 'coloured text',  desc: 'no pill - survives a sanitizer that strips background-color',
               style: t => `color:${t.lite};font-weight:bold;white-space:nowrap` },
};

// Chosen 2026-08-25: colortext - no pill at all. The wiki is dark and filled
// badges glared; coloured bold text sits below the body-text brightness.
const MODE = process.env.BADGE_MODE || 'colortext';
if (!MODES[MODE]) {
  console.error(`unknown BADGE_MODE "${MODE}" - pick one of: ${Object.keys(MODES).join(', ')}`);
  process.exit(1);
}

// colortext repeats ~14k times across the 44 pages, and the style string is
// most of the bytes. Bold is markup rather than CSS there, and nowrap is only
// emitted for a label that actually has a space to break at - same rendering,
// roughly a third of the characters.
function badge(tone, text, mode = MODE) {
  if (mode === 'colortext') {
    const wrap = / /.test(text) ? ';white-space:nowrap' : '';
    return `(% style="color:${TONES[tone].lite}${wrap}" %)**${text}**(%%)`;
  }
  return `(% style="${MODES[mode].style(TONES[tone])}" %)${text}(%%)`;
}

// Colouring a run of body text, not a badge. Uses the bright tone so it reads
// on the dark wiki theme; badges use the saturated fill instead.
function colorText(tone, text) {
  return `(% style="color:${TONES[tone].lite}" %)${text}(%%)`;
}

// Without a pill there is no boundary, so adjacent badges need a visible separator.
const BSEP = MODE === 'colortext' ? ' · ' : ' ';

module.exports = { TONES, MODES, MODE, badge, colorText, BSEP };
