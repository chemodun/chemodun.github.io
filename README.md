# chemodun.github.io

X4: Foundations modding references and guides, published at <https://chemodun.github.io/>.

Only source lives here. The site is built by GitHub Actions and served from the uploaded artifact, so `_site/` is generated, gitignored and never committed.

## Build

```sh
npm install
npm run build      # -> _site/
npm run serve      # build, then serve _site/ on http://localhost:8080
npm start          # serve what is already built, without rebuilding
```

The site is served from the domain root, so every link on it is root-relative. Opening a built `_site/**/index.html` through `file://` therefore resolves `/` to the filesystem root and no link navigates - use `npm run serve`, which is a dependency-free static server (`src/serve.js`) and matches how Pages resolves a directory URL to its `index.html`.

## Layout

```
src/layout.js        the shared shell - theme, header, breadcrumb, footer
src/build.js         every src/content/**/*.md -> _site/<url>/index.html
src/serve.js         a static server for _site/, for local viewing only
src/check-pages.js   loads every built page in headless Chrome, fails on a console error
src/assets/          files served from the root as they are, currently the icons
src/content/         the authored pages, mirroring the URL tree
src/globals/         the Lua Globals Reference pipeline (see below)
src/commands/        the Script Commands reference (see below)
```

`src/build.js` also writes the root-level files: `favicon.ico` (built from the two PNGs in `src/assets/`, so nothing derived is committed), `404.html`, `sitemap.xml` and `robots.txt`.

`npm run check` builds and then loads every page in headless Chrome, failing on any uncaught exception, `console.error` or severe log entry. It also proves the scripts ran rather than merely not throwing: the theme toggle changes `data-theme`, the sticky bar publishes `--barh`, and the filter narrows its counter to zero. The same step runs in CI before anything is uploaded, because a page can build byte-perfect and still be inert.

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
- `<!-- xwiki: toc ... -->` - a table of contents built from the headings that follow it.

Links may point at a page by its title (`[Lua Globals Reference](<Lua Globals Reference>)`); the build resolves those against the page tree and fails the build if one does not resolve.

### The Lua Globals Reference

`src/globals/` renders `/x4/modding-support/ui-modding/lua-globals/`. It holds **conversion only** - two inputs and the code that turns them into a published format:

| Input | What it is |
| --- | --- |
| `globals.lua` | the 805 declarations, with the prose, parameters and returns for each |
| `classification.json` | per global: origin, which Lua environments hold it, which versions have it, and the vanilla definition and call sites behind those claims |

Both are produced upstream, in a separate working repository, and land here already finished. Nothing in this repo re-derives them, which is why CI builds the page from a clean checkout with no game files present.

- `build-html.js` → the page on this site
- `build-wiki.js` + `check-wiki.js` → XWiki 2.1 pages for the Egosoft wiki
- `page-manifest.js`, `docs.js`, `usage.js`, `badges.js`, `exclusions.js` - shared by both

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
