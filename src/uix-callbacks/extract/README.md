# UIX callbacks reference - extraction half

Reads kuertee's [UI Extensions and HUD](https://github.com/kuertee/x4-mod-ui-extensions) `.xpl` files and emits the LuaLS meta file the page beside it is built from. It lives in the site repo so the weekly workflow can run it, and so the pipeline behind a published reference is versioned with the reference.

The meta file **is** the reference. Nothing lives beside it: the page is built by parsing it, and it doubles as an editor library, so a mod author who points a Lua Language Server at it gets completion and signatures for what each hook is handed.

## Run

```sh
npm run uix:check      # is there a UIX release data/history.json does not cover?
npm run uix:update     # extract what is new, regenerate the reference
npm run uix:rebuild    # throw the history away and extract all 33 releases again
```

Underneath:

```sh
node build-history.js --check          exit 3 when a release is missing, 0 when current
node build-history.js                  extract the missing ones -> data/history.json
node build-history.js --all            rebuild the whole axis from scratch
node build-history.js 9.0.0.13 ...     just these, re-extracting if already present
node build-history.js --keep-sources   leave the .xpl files in src/ for reading
node extract.js <src-root> <version>   one tree by hand -> out/<version>.json
node check.js   <src-root> <version>   completeness gate for that extraction
node gen-meta.js                       -> out/uix-callbacks.lua, a preview
node gen-meta.js --site                -> ../uix-callbacks.lua, the reference
```

No clone, no `gh`, no dependencies: releases come from the public GitHub API and a release's sources from one gzipped tarball on codeload, both over node's own `fetch`. That is what lets `.github/workflows/uix-releases.yml` skip `npm ci` entirely.

**The site copy is the reference.** `--site` writes `../uix-callbacks.lua`, which is what the page is built from, what it offers for download, and where every description lives. A no-flag run reads that same file for its authored half and writes a preview into `out/`, so the preview can never be the more current of the two.

## The version axis

`Since:` names a UIX **release** - the mod's own, not the game's. The axis runs from `8.0.0.1`, published as "8.0.0.1-beta" on 2025-07-12, which is the floor: a hook already dispatched there is stamped `pre-8.0` rather than given a number the scan cannot prove. Bare tags with no release behind them are not on the axis, because nobody installs one.

**The 8.x and 9.x lines run in parallel.** 8.0.4.10 and 9.0.0.7 were published the same day, so one number cannot answer "is this hook in the build my users run". Every key is computed per line and collapsed to a single number only when the lines agree, which happens in exactly one case: the hook was in 8.x before the 9.x line was cut, so 9.x has it by inheritance and its own first release says nothing about it.

```text
-- Since: pre-8.0                              already there at the floor
-- Since: 8.0.4.0                              added on 8.x, inherited by 9.x
-- Since: 9.0.0.13 (9.x only)                  the 8.x line never got it
-- Since: 8.0.4.9 (8.x), 9.0.0.3 (9.x)         different releases on each line
-- Versions: 8.0.4.9..8.0.4.10, 9.0.0.3..9.0.0.14
-- Removed: gone from 8.x after 8.0.1.0
```

`..` and not `-` in a range, because `8.0.0.7-rc1` and `8.0.0.7.1-beta` carry hyphens of their own.

## data/history.json

The committed record of which release dispatches what, and the reason the axis never has to be rebuilt: extracting 33 releases takes 33 downloads, extracting the release that just appeared takes one.

It stores each line as a delta chain rather than 33 full sets of 295 names - the file stays small, and the diff for a new release reads as exactly what that release changed. The chain is **per line** because the lines are parallel: chronologically 8.0.4.9 is followed by 9.0.0.6 and then by 8.0.4.10, so a single chain would record a churn of adds and removes at every switch, none of it real.

`out/` is not committed. A fresh checkout has none of it, so `build-history.js` re-extracts what it calls the **cover set**: the releases whose full extraction is still needed, which is the newest release plus the last release to carry each hook UIX has since dropped. Two such hooks exist, so that is three releases, not thirty-three.

## The two halves of every entry

| | rewritten every run | written by hand |
| --- | --- | --- |
| `-- Key: value` lines | yes | no |
| the `function` declaration | yes | no |
| `---` prose | no | yes |
| text after `---@param` / `---@return` | no | yes |

`Since:`, `Versions:` and `Removed:` are in the generated half. They used to be stamped once and owned by the file, because only two releases had ever been extracted and nothing could prove a first appearance; the history covers all of them now, so they are measured on every run and a hand-edit to them would be overwritten.

`gen-meta.js` reads the destination before writing it, so a regeneration can never cost a description, and a second run is byte-identical.

## Why (menu, name)

Callback names are not unique. `cleanup` is dispatched in ten menus, `refreshContextFrame_on_start` in three. The key is always the pair, and the meta file is one table per menu.

## The four dispatch forms

All of them bind each registered function to a loop variable, which is why sites are anchored on the loop rather than on the first mention of the name:

```lua
for id, cb in pairs (menu.uix_callbacks ["N"]) do   -- the common one
for _,  cb in pairs (cbs)                           -- cbs assigned just above
for _,  cb in next,  menu.uix_callbacks ["N"]       -- next instead of pairs
local cbs = menu.uix_callbacks and menu.uix_callbacks ["N"]
```

Three holders occur: `menu` (the menu's own table), `Helper` (global), and `uix_menu` (a menu passed into a Helper function).

## What a reader cannot guess: `Aggregation`

The return value is treated six different ways, and nothing at the call site announces which:

- `none` - the return is discarded; the hook is an event
- `last-wins` - the last registered callback's value is the one used
- `unanimous` - every callback must agree, or the value flips
- `chained` - each callback receives the previous one's value
- `short-circuit` - the first truthy return stops the loop
- `appended` - the return is concatenated onto what is already there
- `multi-value` - several values in, the same several out

It is classified heuristically here and corrected by hand in the meta file's prose.

## The menu name

`Helper.getMenu()` takes the name a menu registers itself under, and it is not the file name: `menu_trader_blueprintsorlicences.xpl` is `BlueprintOrLicenceTraderMenu`. It is read out of the `local menu = {` table and emitted as `Menu name:`, which is what lets the page print the exact registration call for a hook. `helper.xpl` has none, and its hooks are registered on `Helper` instead.

## Typo'd dispatch sites

Three existed, all of the same shape: a guard checking one name while the loop iterates another, leaving the callback behind it dead. `menu_playerinfo`'s `createLeftBar_on_start` was fixed in `9.0.0.6`; `menu_diplomacy`'s and `menu_map`'s `on_menu_minimize` were fixed upstream by [PR #115](https://github.com/kuertee/x4-mod-ui-extensions/pull/115), merged 2026-09-05, so `9.0.0.13` is the first release with none.

The extractor still detects them, because it has to: the name a mod would register against is the guard's, not the typo's, and the arguments come from the call the body actually makes. It prints them and stops there - **the meta file carries the callback, not the typo** - which is why the reports simply stopped once the releases carrying the fix were extracted.
