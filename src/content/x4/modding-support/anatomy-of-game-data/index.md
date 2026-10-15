---
title: Anatomy of game data
description: How the game's own data is laid out - the installation folder, the nine catalogs and what each holds, the folder tree they unpack to, the kinds of file in it, and how the expansions repeat the same tree.
order: 2
wiki: Anatomy of game data
wikiRef: also
---

<!-- Canonical copy; the Egosoft wiki page is exported from it -->

# Anatomy of game data

Everything the game does beyond its executable is described in files, and an extension changes the game by adding to those files or patching them. Knowing where a thing lives is the first step of nearly every modding task: which folder holds a ship's macro, where a faction is defined, which file names the sectors, what a text id points at. This article maps the game's own data as version 9.00 ships it, folder by folder, and says which article covers each part in more detail.

It is the counterpart of [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/). That article describes the folder an extension is; this one describes the tree the extension merges into. The articles below this one go down one level at a time, starting with the data tables in `libraries/`.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## The installation folder

Leaving aside the libraries the executable links against, a fresh installation of 9.00 holds this:

```none
X4 Foundations/
  X4.exe                                the game
  01.cat  01.dat  ...  09.cat  09.dat   the game's own data, nine catalogs
  01_sig.cat  01_sig.dat  ...           Egosoft's signatures, one pair per catalog
  extensions/                           the expansions and every installed mod
    ego_dlc_split/  ego_dlc_terran/ ...
  t/                                    the launcher's dialog texts, one file per language
  videos/                               intro, game start and credits videos
  mousecursors/                         cursor images
  version.dat                           the version number, 900
```

The nine numbered catalogs are the game. `X4.exe` reads them in order, and everything in the sections below is a path inside one of them. The few folders left loose are the ones something reads before the catalogs are open, or that nothing gains from packing. The loose `t/` is one to be aware of: it holds only the launcher's dialog texts (`0002-l044.xml` and its translations) and is not the game's text folder, which is inside `09.cat` under the same name. The `_sig` pairs are signatures and carry no data.

[Catalogs](/x4/modding-support/anatomy-of-an-extension/catalogs/) explains the format and how an extension's own catalogs are read on top of these; [X Catalog Tool](/x4/modding-support/x-catalog-tool/) is the way to open one.

What each catalog holds, read from its index:

| Catalog | Holds |
| --- | --- |
| `01.cat` | `assets/`: models, textures, materials and the macros of everything physical |
| `02.cat` | `sfx/`, `particles/`, `maps/`, `textures/`, and two HTML viewers, `jobeditor.html` and `scriptproperties.html` |
| `03.cat` | `voice-l044/`, `voice-l049/`: the spoken lines, English and German |
| `04.cat` | `music/` |
| `05.cat` | more `assets/` |
| `06.cat` | `shadergl/`: the shaders, with a few more sound, particle and map files |
| `07.cat` | `ui/`: the Lua interface and its XML layouts |
| `08.cat` | `md/`, `aiscripts/`, `libraries/`, `cutscenes/`, `index/`, and the rest of `ui/` |
| `09.cat` | `t/`: the game's text files |

The split is by kind of content, and it has one practical consequence. `08.cat` and `09.cat` together hold nearly every file a script, data or text mod touches, and they are a small part of the installation; `01.cat` and `03.cat` are most of it by far and only matter to asset and voice work. Unpacking the two small catalogs is enough for most modding.

[↑ Contents](#toc)

## The data tree

Unpacked together, the nine catalogs make one tree, and every extension mirrors a part of it. The folder names here are the ones [the folder map](/x4/modding-support/anatomy-of-an-extension/#the-folder-map) lists for an extension, seen from the game's side.

| Folder | What it holds | Mostly | Covered in |
| --- | --- | --- | --- |
| [`libraries/`](/x4/modding-support/anatomy-of-game-data/libraries/) | The data tables: wares, ships, factions, jobs, god, loadouts, icons, parameters and over a hundred more, with the XSD schemas that describe them beside them | XML | [libraries](/x4/modding-support/anatomy-of-game-data/libraries/), with [jobs.xml](/x4/modding-support/anatomy-of-game-data/libraries/jobs-xml/), [god.xml](/x4/modding-support/anatomy-of-game-data/libraries/god-xml/), [gamestarts.xml](/x4/modding-support/anatomy-of-game-data/libraries/gamestarts-xml/) and [startmenu.xml](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/) |
| `md/` | Mission Director scripts: game start setup, faction logic, missions, tutorials, the shared `lib` and `gm` families | XML | [Scripting/MD/Libraries/Map](/x4/modding-support/scripting-md-libraries-map/) |
| `aiscripts/` | AI scripts: orders, movement, trade, fight, mining, mass traffic and the interrupt handlers | XML | [Scripting/MD/Libraries/Map](/x4/modding-support/scripting-md-libraries-map/) |
| `maps/` | The universe: the galaxy, clusters, sectors, zones and highways in `xu_ep2_universe/`, plus the small galaxies the tutorials, the main menu scene, the demo and the editor use | XML | [Resource areas](/x4/modding-support/resource-areas/) |
| `index/` | `components.xml` and `macros.xml`: the name to path lookups that let every other file refer to an asset by name | XML | [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/#adding-something-of-your-own) |
| `assets/` | Everything physical: `structures/` (station modules), `units/` (ships by size), `props/` (weapons, engines, ad signs), `environments/`, `interiors/`, `characters/`, `fx/`, `wares/`; each thing has its XML component and macro beside the binary model | XML and binary | Assets Modding on the Egosoft wiki |
| `t/` | Text, one file per language, holding every page the game, the expansions and the interface use | XML | [Text and translations](/x4/modding-support/anatomy-of-an-extension/#text-and-translations) |
| `ui/` | The interface: `core/` (the HUD, its Lua and its XML presentations), `widget/` (the widget layer), `addons/` (the menus) | Lua, XML | [UI Modding support](/x4/modding-support/ui-modding/) |
| `cutscenes/` | Camera and scene sequences | XML | |
| `sfx/`, `music/`, `voice-l0NN/` | Sound effects, music, spoken lines | wav, ogg | |
| `particles/`, `shadergl/`, `textures/` | Particle definitions, shaders, dynamic textures | binary, glsl, dds | |

Two folders carry names rather than things. `index/` is the one that makes names work: a ship macro is referred to everywhere as `ship_arg_m_frigate_01_a_macro`, and `index/macros.xml` is where that name becomes a path under `assets/`. An extension adding a macro adds an entry there too, which is why it appears in [the folder map](/x4/modding-support/anatomy-of-an-extension/#the-folder-map) of an extension at all. `t/` is the other: a text is referred to by page and id, `{20101,10101}`, and the file for the current language is where that pair becomes a string.

The folders are also of two sizes. `libraries/`, `md/`, `aiscripts/`, `maps/`, `index/` and `t/` are a few hundred XML files between them and are where data and script modding happens. `assets/` is tens of thousands of files, and each thing in it is a small group: an XML component describing the parts, an XML macro describing the thing built from them, and the binary model, animation and texture files they point at.

[↑ Contents](#toc)

## Three kinds of file

What can be done with a file depends on its kind, and the tree has three.

**XML** is almost everything that is not an asset's model: the libraries, the scripts, the maps, the index, the texts, the components and macros under `assets/`, the UI layouts. An extension changes an XML file with a diff file of the same path, and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/) covers how. The schemas beside the libraries, `libraries/*.xsd`, and `md.xsd`, `aiscripts.xsd` and `common.xsd` for the scripts, are the authoritative description of what each file may contain.

**Lua** is the interface, under `ui/`. The menus in `ui/addons/` are extended by registering a file of the extension's own; the HUD in `ui/core/` is not. [UI Modding support](/x4/modding-support/ui-modding/) covers both sides.

**Binary** is the rest: `.xmf` meshes, `.xac` characters and `.xsm` character animations, `.ani` animations, `.gz` and `.dds` textures, `.ogg` and `.wav` sound, `.psb` particles, `.glsl` shaders. A diff does not apply to these; a file of the same path replaces the original whole, and producing one needs the tools the Assets Modding guides on the Egosoft wiki describe.

[↑ Contents](#toc)

## The expansions repeat the tree

Each expansion is an extension, and sits in `extensions/` beside any mod: a `content.xml`, its `ext_01.cat` to `ext_03.cat` with their signature pairs, and for some a loose `videos/` folder. Inside the catalogs the tree is the same one: `assets/`, `libraries/`, `md/`, `maps/`, `index/`, `cutscenes/`, `music/` and `sfx/`, with `aiscripts/` only where an expansion brings a behaviour of its own. An expansion's `libraries/wares.xml` is a diff over the base file, exactly as a mod's is, and its `libraries/jobs.xml` is a whole file whose jobs are gathered with the base ones; the two forms are the ones [How a file joins the game](/x4/modding-support/anatomy-of-an-extension/#how-a-file-joins-the-game) describes, so reading an expansion is a good way to see how a large extension is written.

Two things an expansion does not carry. There is no `t/`: the texts for every expansion ship in the base game's text files, under pages of their own. And there is no `ui/`: the interface that shows an expansion's content is the base game's.

[↑ Contents](#toc)

## Reading on

The articles below take one folder each. `libraries/` comes first, because it is where the universe is defined: what wares exist, which factions own what, which ships and stations the game creates and where. [jobs.xml](/x4/modding-support/anatomy-of-game-data/libraries/jobs-xml/), [god.xml](/x4/modding-support/anatomy-of-game-data/libraries/god-xml/), [gamestarts.xml](/x4/modding-support/anatomy-of-game-data/libraries/gamestarts-xml/) and [startmenu.xml](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/) are the tables already covered in full, the last with [Start menu background](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/background/) below it, and [Resource areas](/x4/modding-support/resource-areas/) follows one subject across `libraries/` and `maps/`.

For the two folders that are a language rather than a table, the sections of their own are the place: [Scripting/MD/Libraries/Map](/x4/modding-support/scripting-md-libraries-map/) for `md/` and `aiscripts/`, [UI Modding support](/x4/modding-support/ui-modding/) for `ui/`.

[↑ Contents](#toc)

{{children}}
