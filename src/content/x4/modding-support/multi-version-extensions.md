---
title: Multi-version extensions
description: One extension package that carries different content for different game versions, using version-named catalogs - the naming rule, the four loading rules, and how to build one.
order: 4
---

<!-- Canonical copy; the Egosoft wiki page is exported from it -->

# Multi-version extensions

A game update can move exactly the piece an extension depends on: a vanilla Lua file it substitutes, a signature it calls, a menu it patches. The usual answers are both unpleasant - freeze the extension on the old version, or publish a second package and ask everyone to pick the right one.

There is a third. **One package can carry different content for different game versions**, in the same folder, selected by the engine at load time. The mechanism is a catalog whose name carries a version number, and it has been in the engine since X Rebirth. It is described for X Rebirth in the Steam guide [Steam Workshop for X Rebirth and X4](https://steamcommunity.com/sharedfiles/filedetails/?id=245117855), under the `-buildvcat` switch of the Workshop tool, and it works in X4 - though not on quite the terms that guide implies.

Everything below was established by running a probe extension on 8.00 and 9.00 and reading which catalog actually answered for each file. That package is [available to download](#the-test-package) so the results can be reproduced.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## The naming rule

An extension folder normally holds numbered catalogs - `ext_01.cat` / `ext_01.dat` for its own files, `subst_01.cat` / `subst_01.dat` for files that replace vanilla ones. A **version catalog** is the same thing with a version in place of the number:

```none
ext_v800.cat    ext_v800.dat        content for game version 8.00
ext_v900.cat    ext_v900.dat        content for game version 9.00
subst_v800.cat  subst_v800.dat      vanilla replacements for 8.00
subst_v900.cat  subst_v900.dat      vanilla replacements for 9.00
```

The number is the game version written as three digits, without the dot: **major, then minor as two digits**. 7.60 is `760`, 8.00 is `800`, 9.00 is `900`. The build number the game reports in brackets after the version plays no part.

Paths inside a version catalog are the same virtual paths as anywhere else - relative to the extension folder for `ext_`, relative to the game root for `subst_`. A version catalog is not a sub-folder at runtime; it is an alternative source for the very same paths.

[↑ Contents](#toc)

## The four rules

### 1. A version catalog loads only on an exact version match

`ext_v800` loads on 8.00 and on nothing else. On 9.00 it is not merely outranked, it is **absent** - files that exist only there cannot be found at all.

This is the rule that most needs stating, because it is not what the X Rebirth guide leads one to expect. A version catalog is not "this version and older", and not "this version and newer". Running on 8.00 with all three of `ext_v760`, `ext_v800` and `ext_v900` present, only `ext_v800` answered; both of the others were as good as not shipped. On 9.00, only `ext_v900`.

The practical consequence is the whole shape of the technique: **a version catalog is needed for every game version that requires different content**, and any version without one falls back to the numbered catalogs alone.

### 2. A version catalog is applied after every numbered catalog of its kind

Where the same path exists in both, the version catalog wins. `ext_v800` overrides `ext_01`, and it overrides `ext_02` as well, so it does not matter how many numbered catalogs a package already has - the version catalog sits above all of them.

`subst_vNNN` behaves identically over `subst_01`, `subst_02` and the rest.

### 3. The two kinds rank only within themselves

`ext_` and `subst_` are separate stacks and neither reaches into the other. A `subst_vNNN` catalog outranks the numbered `subst_` catalogs and nothing else; the ordering between `ext_` and `subst_` as a whole is what it always was.

### 4. A version catalog does not need a numbered catalog to exist

With every `ext_01` / `ext_02` removed and only `ext_v800` shipped, the extension loaded and worked on 8.00. The version catalog is a complete, self-sufficient source, not a patch that requires a base to apply to.

That makes both models available:

- **Differential** - the numbered catalogs carry everything common, and each version catalog carries only the handful of files that differ. This is the smaller package and the one to reach for by default.
- **Complete** - each version catalog carries the whole extension, and there are no numbered catalogs at all. Worth it only when the versions diverge so much that "what is common" is nearly empty.

[↑ Contents](#toc)

## Building one

The source tree needs one folder per catalog, each rooted where that catalog's paths are relative to:

```none
my_extension/
    content.xml                     never packed - see below
    src/
        base/                       -> ext_01
            ui.xml
            ui/my_extension.lua
        v800/                       -> ext_v800
            ui/my_extension.lua         the 8.00 variant of that one file
        v900/                       -> ext_v900
            ui/my_extension.lua         the 9.00 variant
        subst_v800/                 -> subst_v800
            ui/addons/ego_detailmonitor/menu_map.xpl
        subst_v900/                 -> subst_v900
            ui/addons/ego_detailmonitor/menu_map.xpl
```

Each folder is packed with the [X Catalog Tool](<X Catalog Tool>) into the catalog it corresponds to:

```bat
XRCatTool.exe -dump -in "src\base"       -out "dist\my_extension\ext_01.cat"
XRCatTool.exe -dump -in "src\v800"       -out "dist\my_extension\ext_v800.cat"
XRCatTool.exe -dump -in "src\v900"       -out "dist\my_extension\ext_v900.cat"
XRCatTool.exe -dump -in "src\subst_v800" -out "dist\my_extension\subst_v800.cat"
XRCatTool.exe -dump -in "src\subst_v900" -out "dist\my_extension\subst_v900.cat"
copy content.xml "dist\my_extension\"
```

The Workshop tool's `-buildvcat` does the equivalent from `v800`-style sub-folders of a single tree, for anyone publishing through it. Packing each folder by hand is the same result and needs no convention about where the version folders sit.

**`content.xml` is never packed.** The engine reads it before it mounts any catalog, so it has to stay loose in the extension folder. Its `<dependency version="...">` is the *lowest* game version the package supports - the one below which the extension should not load at all, not the version any particular catalog serves:

```xml
<dependency version="800"></dependency>
```

[↑ Contents](#toc)

## What belongs in a version catalog

Only the files that actually differ. Every file that is the same across versions belongs in the numbered catalogs, where it is packed once and maintained once.

The cost of forgetting this is not disk space, it is drift: a file duplicated into three version catalogs is a file that will be fixed in one of them and left stale in the other two.

For substitutions specifically, the question to answer before writing anything is whether the vanilla file changed at all between the versions in question. If `ui/addons/ego_movie/movie.xpl` is byte-identical in 8.00 and 9.00, then one `subst_01` carrying the modified copy covers both, and no version catalog is needed for it. Comparing the extracted vanilla trees of the two versions is what settles it, and it is worth doing per file rather than per version - a game update rarely touches everything.

[↑ Contents](#toc)

## Gotchas

**A registered file that lives only in a non-matching version catalog is a hard error.** Because a non-matching catalog is absent rather than outranked, a `ui.xml` that registers `ui/thing_900.lua` will, on 8.00, produce:

```none
File I/O: Could not find file '.\extensions\my_extension\ui\thing_900.lua'
Addon::LoadLuaFile() - Failed to open specified filename: ... referenced in addon: 'my_extension'
```

The addon still loads and its other files still run, so this is survivable, but it fills the log with errors that look like the extension is broken. Keep `ui.xml` registering only paths that exist on every supported version, and let the version catalogs override those paths rather than add new ones.

**`ui.xml` itself is a normal file and can be overridden too.** If two versions genuinely need different file lists, ship a different `ui.xml` in each version catalog rather than one union list that is wrong everywhere.

**Nothing warns about a version that has no catalog.** Ship `ext_v800` and `ext_v900`, and a player on 8.10 silently gets the numbered catalogs only. If that combination is not viable, the `<dependency version>` floor and a runtime version check are the only things standing between the player and a confusing failure.

**Vanilla UI Lua is stored as `.xpl`.** A `subst_` catalog replacing one must use that path and extension - `ui/addons/ego_movie/movie.xpl`, not `.lua`. Plain Lua source is accepted as the content; it does not have to be compiled the way the shipped file is.

[↑ Contents](#toc)

<a id="the-test-package"></a>

## The test package

**Download: [version-content-test.zip](https://chemodun.github.io/multi-version-extensions/version-content-test.zip)** (11 KB) - the probe the rules above were read off, cut down to 8.00 and 9.00.

Unpack it into the game's `extensions/` folder and start the game with `-debug all -logfile debuglog.txt`, then search the log for `version_content_test`. It ships eight catalogs and writes one line per question:

- `ext_01`, `ext_02` and `ext_v800`, `ext_v900`, each carrying a uniquely named Lua file. Those lines report **which catalogs are mounted at all** on the running version.
- A file at one shared path in `ext_01` and both version catalogs, and a second shared path in `ext_02` and both version catalogs. Those two lines report **which catalog won the override**, one contest per numbered catalog.
- `subst_01` and `subst_02` carrying `ui/addons/ego_debug/debug.xpl` and `ui/addons/ego_movie/movie.xpl`, with `subst_v800` and `subst_v900` carrying both. Each is the vanilla source with a single log line added before its closing `init()` call, so behaviour is unchanged. Those lines repeat the same two contests for substitutions.

Deleting catalogs from the folder and restarting is what proves rule 4: with `ext_01` and `ext_02` removed the version catalog still answers for everything, and with `subst_v800` and `subst_v900` removed the numbered substitution catalogs take back over.

[↑ Contents](#toc)
