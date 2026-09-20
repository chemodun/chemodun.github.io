# chemodun.github.io

X4: Foundations modding references and guides, published at <https://chemodun.github.io/>.

Only source lives here. The site is built by GitHub Actions and served from the uploaded artifact, so `_site/` is generated, gitignored and never committed.

## Build

```sh
npm install
npm run build      # -> _site/
npm run serve      # build, then serve _site/ on http://localhost:8080
npm run wiki:fetch # refresh the Egosoft wiki snapshot the navigation panel is built from
npm run wiki:check # compare that snapshot with the wiki; exit 1 on drift, write nothing
npm run measure    # report where the shell's parts land, at three widths, and check they line up
npm start          # serve what is already built, without rebuilding
```

The site is served from the domain root, so every link on it is root-relative. Opening a built `_site/**/index.html` through `file://` therefore resolves `/` to the filesystem root and no link navigates - use `npm run serve`, which is a dependency-free static server (`src/serve.js`) and matches how Pages resolves a directory URL to its `index.html`.

## Layout

```
src/layout.js        the shared shell - theme, header, breadcrumb, navigation, footer
src/nav.js           the page model, and the navigation panel every page carries
src/wiki/            the Egosoft wiki snapshot and the fetcher that writes it
src/build.js         every src/content/**/*.md -> _site/<url>/index.html
src/serve.js         a static server for _site/, for local viewing only
src/cdp.js           headless Chrome over the DevTools protocol, shared by the two below
src/check-pages.js   loads every built page in headless Chrome, fails on a console error
src/measure-layout.js  measures the shell's boxes and checks the header lines up with the page
src/assets/          files served from the root as they are, currently the icons
src/content/         the authored pages, mirroring the URL tree
src/globals/         the Lua Globals Reference pipeline (see below)
src/commands/        the Script Commands reference (see below)
src/c-functions-and-structures/  the C functions and structures reference (see below)
src/uix-callbacks/    the UIX callbacks reference (see below)
src/changes/         two pages: the game delta and the site's own log (see below)
```

`src/build.js` also writes the root-level files: `favicon.ico` (built from the two PNGs in `src/assets/`, so nothing derived is committed), `404.html`, `sitemap.xml` and `robots.txt`.

`npm run check` builds and then loads every page in headless Chrome, failing on any uncaught exception, `console.error` or severe log entry. It also proves the scripts ran rather than merely not throwing: the theme toggle changes `data-theme`, the navigation toggle changes `data-nav` on a panel that carries wiki links, the sticky bar publishes `--barh`, and the filter narrows its counter to zero. The same step runs in CI before anything is uploaded, because a page can build byte-perfect and still be inert.

`npm run measure` is the hand tool beside it, and answers a different question: not whether a page works, but where its parts landed. It reports the boxes of the header, the panel and the page at 1280, 1520 and 760 pixels wide, in both panel states, and checks the rules the shell is built to keep - the title starts where the page starts, the theme button ends where the page ends, and with the panel hidden the toggle leads instead. Pass a path for another page, or a full URL to measure the published site rather than `_site/`. It is deliberately **not** part of `npm run check` and not in CI: the geometry it asserts is a design decision, and a layout choice should not fail a deploy. It exists because the title once shipped sitting 16px past the page's left edge, close enough to look deliberate in every screenshot - `header.top .in` carries `gap:1em` from its flex rule, and `gap` applies to a grid container just as well.

### Authored pages

A page is a Markdown file with front matter:

```markdown
---
title: Talking with MD and AI scripts
description: One sentence, shown on the parent page's card and as the meta description.
order: 2
wikiPath: Modding Support/UI Modding support/Talking with MD and AI scripts
---
```

`order` sorts a page among its siblings. `wikiPath` records where the same content lives on the Egosoft wiki, so a page can still be exported there with `xwiki-md.js`; the site ignores it and uses its own slug.

A **section** page can also carry `wiki`, naming its own segment of the Egosoft wiki tree and nothing more:

```markdown
wiki: UI Modding support
```

The build joins that with the same key on the page's parents, so the section above it holds `wiki: Modding Support` and the one above that `wiki: X4 Foundations Wiki`, and the link comes out as `https://wiki.egosoft.com/X4%20Foundations%20Wiki/Modding%20Support/UI%20Modding%20support/`. A rename over there is then one edit here rather than one per page. It renders as a strip under the page title, using the value itself as the link text, and points a reader at the same section on the wiki for anything more.

Only sections carry it. A document links to the wiki's tree through its section, so the reader lands where every related page is, not on one of them.

Where the wiki page's title is not its URL segment, `wikiName` supplies the link text while `wiki` stays the segment. The scripting section is the case that needs it: the page sits at `ScriptingMD` but is titled `Scripting/MD/Libraries/Map`, and slashes in `wiki` would be read as further segments.

```markdown
wiki: ScriptingMD
wikiName: Scripting/MD/Libraries/Map
```

Two markers are expanded at build time:

- `{{children}}` - the section's child pages as a card list, so an index page never hand-maintains a list of what sits under it.
- `{{documents}}` - every page that is not a section, skipping the tree in between. The home page uses it, and `404.html` is built from the same list: a section's card points at another card, so a page whose job is to offer everything should offer what there is to read.
- `<!-- xwiki: toc ... -->` - a table of contents built from the headings that follow it.

Links may point at a page by its title (`[Lua Globals Reference](<Lua Globals Reference>)`); the build resolves those against the page tree and fails the build if one does not resolve.

### The navigation panel

`src/nav.js` builds one tree out of two: this site's pages, and the Modding Support branch of the Egosoft wiki. A section that exists in both places is one row rather than two, because the merge key is already written down - the `wiki` and `wikiPath` front matter above names where the page lives over there, and matching is on that key rather than on the title, which is a third spelling again in at least one case.

Each row says where it can be read, and the colour answers that before the word does: green for a page that is on this site, grey for one that following the row leaves the site for.

- **local** - a page of this site's own
- **both** - on this site and on the Egosoft wiki
- **Egosoft** - on the wiki only, and the row links there

Only Modding Support is carried in full. The wiki's other top-level branches are single rows linking out: 423 of its 542 pages are ship and equipment stats under Manual and Guides, and a panel listing those is an index rather than a way around.

The section holding the current page is open and nothing else is, which `<details>` does without script, so the panel still navigates when the script is what broke. The toggle in the header means one thing per width: on a desktop it hides the panel and remembers that, and on a phone it opens it as a drawer over the page, which the backdrop, Escape or following a link closes again.

#### The wiki snapshot

`src/wiki/tree.json` is committed, and the build reads it and never reaches the network. `npm run wiki:fetch` rewrites it from XWiki's REST search endpoint, which serves solr queries to guests; `xwql` is refused, and the `space_facet` field holds every ancestor prefix of a page, so one depth-1 term matches a whole subtree.

Two things about that index are worth knowing before changing the fetcher, because both are silent:

- A translation is a document of its own carrying the same path and a translated title. Only the untranslated original has no `<language>`, so everything else is dropped - without that, one page arrived twice and one branch was titled in Turkish.
- A short page of results does not mean the last page. XWiki fetches the row count asked for and only then drops what the reader may not view, so a page of 97 can be followed by a full one. Paging runs until a request comes back empty; stopping on a short page lost a whole top-level branch.

The deploy workflow refreshes the snapshot before building and falls back to the committed copy if the wiki is unreachable, so what is published is current but a wiki outage cannot fail a deploy. `.github/workflows/wiki-drift.yml` runs the same fetch weekly and opens an issue when the wiki no longer matches what is committed. It reports and does not commit: the refresh is meant to be read before it is pushed.

### The Lua Globals Reference

`src/globals/` renders `/x4/modding-support/ui-modding/lua-globals/`. It holds **conversion only** - two inputs and the code that turns them into a published format:

| Input | What it is |
| --- | --- |
| `globals.lua` | the 805 declarations, with the prose, parameters and returns for each |
| `classification.json` | per global: origin, which Lua environments hold it, which versions have it, and the vanilla definition and call sites behind those claims |

Both are produced upstream, in a separate working repository, and land here already finished. Nothing in this repo re-derives them, which is why CI builds the page from a clean checkout with no game files present.

- `build-html.js` → the page on this site
- `page-manifest.js`, `docs.js`, `usage.js`, `exclusions.js` - its inputs, copies of the upstream originals

`globals.lua` doubles as a LuaLS meta file: pointed at as a library, it gives completion and signatures for all 805 globals while writing UI Lua. `build-html.js` therefore copies it into the page's own directory, so it is downloadable from the reference at `/x4/modding-support/ui-modding/lua-globals/globals.lua` and can never drift from the page built beside it.

#### Where it comes from

The reference carries on from two earlier repositories, both built around the same idea - that a description of what X4 exposes to Lua should be written down and shared, instead of being re-derived from the vanilla source by every modder in turn:

- [X4-LuaLSAddonPrep](https://github.com/chemodun/X4-LuaLSAddonPrep) - the source data, kept as Hjson: the documented functions taken from the Egosoft wiki's Lua function overview, plus what the extracted Lua yields on its own - the ffi/C definitions and types, the `Helper` functions, the names exposed through `AddGlobalAccess`, and the undocumented ones.
- [X4-LuaLSAddon](https://github.com/chemodun/X4-LuaLSAddon) - that data generated into a [Lua Language Server](https://luals.github.io/) addon and published through [LLS-Addons](https://github.com/LuaLS/LLS-Addons), so an editor can offer completion and signatures while UI Lua is being written.

What this reference adds is evidence and scope. It covers the global namespace whole rather than the exposed functions alone, it separates the two Lua environments - a name available to an addon menu is not automatically available to the HUD - and it reports presence per game version. None of that is inferred from reading the code: each claim is what the running game was found to hold. The LuaLS route is unchanged, since `globals.lua` is still a meta file.


### The Script Commands reference

`src/commands/build-html.js` builds `/x4/modding-support/scripting-md-libraries-map/script-commands/` from five JSON files in `src/commands/data/`.

```
data/meta.json      versions covered, counts
data/commands.json  919 actions + 431 conditions
data/groups.json    64 attribute groups
data/params.json    629 child parameter elements
data/types.json     217 named types and their allowed values
```

The page has three sections, and the split is the whole point of it. Attribute groups and types are the schema's *shared* halves, so they are rendered once, statically. Commands are not: a command card is assembled in the browser when its row is opened, from a payload embedded in the page.

That is what keeps the page finite. `find` is 89 attributes reused by 19 commands and `action` is 3 attributes reused by over 700, so rendering every card up front would emit the same tables dozens of times over. Instead the list carries one row per command - name, kind, schemas, version ticks, description - and the card is built on demand, linking into the two static sections rather than repeating them. The embedded payload therefore carries commands and child elements in full, but only the *sizes* of groups and types, since the real thing is already on the page.

2,527 KB, 293 KB gzipped. The version filter defaults to the newest version, so the button is Reset rather than Clear, and a deep link drops the filters when its target is hidden.

### The C functions and structures reference

`src/c-functions-and-structures/build-html.js` builds `/x4/modding-support/ui-modding/c-functions-and-structures/` from three JSON files in `src/c-functions-and-structures/data/`.

```text
data/meta.json       versions covered, counts, and what the in-game probe established
data/functions.json  2,380 functions, each with its state, signature and evidence
data/types.json      302 structs and typedefs, with the size measured in the running game
```

They are produced upstream, in a separate working repository that needs the game files, and land here already finished - the same split as the globals reference, and for the same reason: CI builds the page from a clean checkout with no game installed.

`ffi.C` is a userdata with no `__pairs`, so it can never be enumerated and no list of it can come from the game alone. The names come from the `ffi.cdef` blocks of vanilla's own Lua and from the export table of `X4.exe`; what the game was asked is whether each one resolves, and in which of the two Lua states. That is what the three states mean - **declared**, where vanilla writes the cdef and the signature is known; **exported**, where the engine has the name and no vanilla file declares it; and **restricted**, where the engine refuses it outright with a message of its own.

The layout follows the commands reference, because the shape of the data is the same: types are the shared half - `UniverseID` is a parameter of 871 functions - so they are rendered once, statically, and a function card is assembled in the browser when its row is opened, linking into them. `usedBy` is computed here at build time rather than stored, since storing it would put a list of 871 names in the data file for a number the page can count itself.

2,699 KB, 179 KB gzipped. The version filter defaults to the newest version, and a deep link drops the filters when its target is hidden.

### The UIX callbacks reference

`src/uix-callbacks/build-html.js` builds `/x4/modding-support/ui-modding/uix-callbacks/` from `src/uix-callbacks/uix-callbacks.lua`.

```text
uix-callbacks.lua  the reference itself: 295 callbacks in 19 menus, one table per menu
meta.js            the parser, shared with the extraction half beside it
data/meta.json     the releases covered, and the counts the extraction measured
data/history.json  which callbacks each UIX release dispatches: the version axis
extract/           the extraction half, and the pipeline the weekly workflow runs
```

kuertee's [UI Extensions and HUD](https://github.com/kuertee/x4-mod-ui-extensions) ships patched copies of the vanilla menu files with callback dispatch points added, and a mod registers a function against one by name. The mod's own readme says no list of them exists and to search the code, so this is that list, read out of its `.xpl` files at every one of its 33 releases from 8.0.0.1 onwards.

**The `.lua` file is the reference, not a rendering of it.** It is a Lua Language Server meta file, which means it is also an editor library: point a language server at it and a handler gets completion and signatures. The descriptions live in it and nowhere else, so a description and the hook it belongs to are never apart, and adding one is a pull request against a single file. Everything reading `-- Key: value` is generated and rewritten whenever UIX moves on, `Since:` included - it is measured against every release rather than remembered - while the `---` prose and the text after a `---@param` or `---@return` `#` are authored and carried across untouched.

The version axis is the **mod's** releases, not the game's, because a callback appears when kuertee adds it. Its 8.x and 9.x lines run in parallel, so availability is answered per line and a hook already present at the 8.0.0.1 floor is `pre-8.0` rather than given a number the scan cannot prove. `Aggregation` is the field the page exists for: nothing at a dispatch site says what happens when two mods register against the same hook, and the answer is one of six contracts.

The layout follows the C functions page - a filter bar over a flat list, with each card assembled in the browser when its row is opened. Facets are menu, kind, aggregation, holder, whether a description has been written, and release. The release filter is grouped by line, newest line first, and defaults to the current release rather than to everything: each group offers its head, then what every release of that line changed (`9.0.0.13 (+17)`, `9.0.0.14 (0)`), because "present in 8.0.2.0" is true of 209 hooks and tells a reader nothing. 435 KB.

The extraction half is `src/uix-callbacks/extract/`, with [its own README](src/uix-callbacks/extract/README.md). It needs no dependencies and no clone: the releases come from the GitHub API and a release's sources from one tarball, both over node's `fetch`. `.github/workflows/uix-releases.yml` runs `npm run uix:check` weekly and, when a release appears that `data/history.json` does not cover, runs the pipeline and opens a pull request with the regenerated reference. Merging it puts a line on the Changes page, which is why the commit subject names the releases rather than counting them; squash the pull request and that line is dated the day it was accepted rather than the day the job ran.

### The two changes pages

Two clocks run at different speeds and answer different questions, so they are two pages. `build-game.js` writes **Game Changes** at `/x4/modding-support/game-changes/`: what the game changed for a mod author, aggregated out of the references. `build-site.js` writes **Changes** at `/x4/changes/`: what changed on the site itself. The game's belongs under Modding Support because it is a modding fact like everything else there; the site's sits a level up, because its scope is every page under `/x4/`.

```text
sources.js      reads each game reference through its own parser, returns the delta
build-game.js   renders the game delta, and checks every name against the built references
site-log.js     drafts the site's own log out of git history, and reads it back
site-log.json   that log, committed, because the build has no history to read
build-site.js   renders the log, and checks that every page it names still exists
```

The game's is the longer page. Every reference already records, per row, which of the versions it covers has that row, and nothing aggregated it, so the question a reader actually arrives with after a game update had no page. The delta is always between the last two versions a reference covers, so nothing here names 8.00 or 9.00 except the data. Only the game references feed it: the UIX callbacks reference tracks a mod, which ships on its own releases rather than the game's, so it is no part of a game delta.

It is generated for the same reason the references are: a hand-written changelog is one edit away from disagreeing with the page it summarises. Reading the same committed data through the same parsers means it cannot, and rebuilding it on every build means it cannot go stale.

The page is ordered removals, then names that stayed and changed shape, then additions, because that is the order a reader wants them in after an update. What "changed shape" means is per reference and is whatever the data actually records: for globals, an availability change or a `Deprecated:` tag naming the newer version; for script commands, an attribute or child element the command gained or lost.

Both run **last** in `npm run build`, the game's first, because each verifies itself against output the rest of the build produced. Every name on the game page is a deep link into the reference that owns it, and an anchor that does not exist over there is a dead link nothing else on the site would notice; `checkAnchors()` reads the built pages and fails the build on one. It caught a real case on the first run: child elements are rendered inside their parent command's card and have no anchor at all, which is why they are counted inside the command that accepts them rather than listed on their own. `checkLogged()` is the same idea for the site page, against the pages the log names.

The site's clock is one entry per day and per page, and it is read from git rather than computed from the tree: `node --run changes:log` drafts the days that are missing and prints them, `node --run changes:log -- --write` appends them to `site-log.json`, and `-- --rebuild` regenerates the whole file from history. What the page renders is that committed file, not git, because reading history at build time would tie a published page to a history that can be rewritten, and to wording that can only ever be a commit subject. Written down, a line can be rewritten afterwards in the words a reader needs: the drafter never rewrites a day already logged, so a hand correction stands.

The drafter runs inside `.github/workflows/pages.yml`, not beside it. It drafts and writes before `npm run build`, so the deploy carries the line the push earned, and commits the file after `check-pages.js`, so a build that fails commits nothing and a log that cannot be pushed stops the deploy instead of publishing a line the repository does not have. Drafted in a workflow of its own, it could only ever deploy twice: once without the line and once with it. Nothing loops, because a push made with `GITHUB_TOKEN` triggers no workflow. Two details the order depends on: the checkout is `fetch-depth: 0`, because the drafter needs history the deploy does not; and `git checkout -- .` runs between the `add` and the `commit`, because the wiki refresh earlier in the job leaves the tracked `src/wiki/tree.json` dirty and an unstaged change aborts a rebase.

What reaches that log is decided by a map from file to page, not by anyone remembering the rule: a file that belongs to no page under `/x4/` is invisible to it, which is how the workflows, the sitemap, the favicon and the tooling stay off the page. In a reference's own directory the `.lua` and `.json` it is built from are content and the `.js` is presentation, so a builder script counts only in a `feat` commit - a page gaining a feature is something a reader sees, the same file refactored is not. Nothing tests who committed, deliberately: CI landing a commit is not the question, what a reader sees is, and the map already answers it. A job that refreshes the wiki snapshot or bumps a dependency touches no page and is invisible without being named, while `uix-releases.yml` regenerating the UIX callbacks reference earns a line exactly as a hand edit to the same file would - which is why its commit subject is written to be read on the page rather than in `git log`. A `docs(changes)` subject is the one thing skipped outright, and the log's own two files are on no page in the first place - two independent reasons, which is what lets the job commit into the repository it is reading.

