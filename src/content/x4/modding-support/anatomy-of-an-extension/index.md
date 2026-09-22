---
title: Anatomy of an extension
description: What an X4 extension is made of, from an empty folder to a package the game loads - content.xml, the folder map, how a file joins the game, text files, and packing into catalogs.
order: 1
wiki: Anatomy of an extension
wikiRef: also
---

<!-- Canonical copy; the Egosoft wiki page is exported from it -->

# Anatomy of an extension

Everything the game does is described in files, and almost all of them are XML. An extension is a folder of those files that the game merges with its own. Nothing is compiled, nothing is injected, and no executable is touched. That is why a text editor is the only tool strictly required to write one.

This page walks the whole shape of an extension, from an empty folder to a package that can be published. It assumes no prior modding, and builds one small example, `example_starter`, section by section.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## What an extension is

The game keeps its own data in catalog files in its installation folder, and reads extensions from the `extensions` folder beside them:

```none
X4 Foundations/
  01.cat  01.dat  02.cat  02.dat  ...      the game's own data
  extensions/
    ego_dlc_boron/                          a DLC is an extension too
    example_starter/                        yours
```

Three facts follow from that layout, and most of the rest of this page is a consequence of them.

**The folder name and the extension's id are two different names, used for two different things.** The **folder name is what every path uses**: a file in this extension is addressed as `extensions/example_starter/...`, and that is the form taken by an `index/macros.xml` entry, a `subst_` catalog path and a file-not-found message alike. The **`id` attribute in `content.xml` is what dependencies use**: one extension requires another by id, never by folder name.

The two may differ, and on anything published through the Steam Workshop they do. The Workshop rewrites `id` to `ws_<item id>` and leaves the folder alone, which is why SirNukes Mod Support APIs sits in a folder called `sn_mod_support_apis` while its `content.xml` reads `id="ws_2042901274"` - and why everything depending on it does so under that number. Where the id is still the author's to choose, matching it to the folder is worth doing, since two names for one thing is a reliable source of confusion; but a published extension cannot count on them matching, and nothing should be written that assumes they do.

**The contents are laid out as if the folder were the game root.** An extension's `libraries/wares.xml` lines up with the game's own `libraries/wares.xml`. There is no manifest listing files, and no registration step: position in the tree is what connects a file to the thing it affects.

**Loose files and packed catalogs are read the same way.** The game looks inside `.cat` archives and at plain files on disk without distinguishing them. An extension can therefore be developed entirely as loose files and packed only when it is published, which is what [Packing it up](#packing-it-up) covers.

A DLC is an ordinary extension by these rules. Nothing an official expansion does is unavailable to a mod, which makes the shipped DLCs the most reliable examples to learn from. Several of the rules below were established by reading them.

[↑ Contents](#toc)

## The smallest extension that loads

An extension needs exactly one file to exist as far as the game is concerned: `content.xml`, in the root of its folder.

```none
extensions/example_starter/
  content.xml
```

```xml
<?xml version="1.0" encoding="utf-8"?>
<content id="example_starter"
         name="Example Starter"
         description="A worked example."
         author="Example Author"
         version="100"
         date="2026-09-21"
         save="false">
</content>
```

Start the game and open the Extensions menu from the main menu. `Example Starter` is listed there, with its version and description, and it can be enabled and disabled. It does nothing at all yet, which is the point: the entry in that list is confirmation that the folder's placement, the file name and the XML are all right, before any content exists to be blamed for a problem.

If it is not listed, the cause is almost always one of three things: the folder is not directly under `extensions`, the file is not named `content.xml` exactly, or the XML is malformed. Enabling the game's debug log will name the last of those.

[↑ Contents](#toc)

## content.xml in full

`content.xml` is a description of the extension, not a list of its contents. The game builds the file list by looking, so nothing here needs updating when a file is added.

### Attributes on the root element

| Attribute | Meaning |
|---|---|
| `id` | The name other extensions use to declare a dependency on this one. Not the same thing as the folder name, which is what paths use, and the Steam Workshop overwrites it with `ws_<item id>` on publication. |
| `name` | The display name in the Extensions menu. |
| `description` | The blurb shown below it. Plain text, in English. |
| `author` | Shown beside the name. |
| `version` | An **integer**, not a dotted string. Three digits, so `100` is version 1.00 and `205` is 2.05. The game compares these numerically when resolving dependencies. |
| `date` | `YYYY-MM-DD`. Displayed only. |
| `save` | Whether the extension is recorded as affecting saved games. |
| `enabled` | Whether it is active. The game writes this when the player toggles the extension, so it is not something to maintain by hand. |

Boolean attributes accept either spelling: `true`/`false` and `1`/`0` both appear across shipped DLCs and published mods, and both work.

Two more attributes appear on published extensions and are written by the Steam Workshop tool rather than by hand. `sync="false"` stops the game replacing a locally edited copy with the published one, which is what makes it safe to keep a work-in-progress version of a published extension in the game folder. `lastupdate` is a timestamp the tool maintains.

### Translated names and descriptions

The root `name` and `description` are English. Any other language is given its own element:

```xml
<text language="49" name="Beispiel-Starter" description="Ein Beispiel." />
<text language="33" description="Un exemple." />
```

The `language` attribute is a numeric language code, and `name` may be omitted when only the description is translated. The shipped DLCs demonstrate the pattern: `ego_dlc_boron` carries twelve `<text>` elements and no element for English, because the root attributes already cover it.

The codes are the same ones used for text files, listed in [Text and translations](#text-and-translations).

### Dependencies

A dependency does two jobs: it refuses to load when a requirement is missing, and it fixes load order. The second matters more often than the first.

```xml
<dependency version="760" />
<dependency id="ego_dlc_split" version="100" optional="true" />
```

**With no `id`, it is the minimum game version**, in the same three-digit form as `version`. The example above requires 7.60 or newer.

**With an `id`, it names another extension.** The game loads dependencies before the extension that declares them, so declaring one is how an extension guarantees it sees another's files already in place.

**That id is the target's `content.xml` id, not the folder it installs into**, and for anything published on the Steam Workshop those are different. A dependency on SirNukes Mod Support APIs reads `id="ws_2042901274"` even though the folder is `sn_mod_support_apis`. Open the target's own `content.xml` and copy what is there; a dependency naming the folder does not resolve.

`optional="true"` keeps the ordering guarantee while dropping the requirement. Egosoft documents this in a comment in `ego_dlc_boron/content.xml`, beside the dependencies that expansion declares on the others:

> `optional="true"`: No error if dependency missing/disabled. This is only used to define the loading order of extensions (dependencies are loaded first).

That sentence is worth keeping in mind, because it names the common case. An extension that must be applied *after* another one, but works perfectly well without it, wants an optional dependency. A hard dependency is for something genuinely required.

[↑ Contents](#toc)

## The folder map

Below `content.xml`, the folders mirror the game's own. Only the folders an extension actually uses need to exist.

| Folder | Holds |
|---|---|
| `md/` | Mission Director scripts: the cue-driven scripts that run the game's missions, economy events and most mod logic |
| `aiscripts/` | AI scripts: the orders and behaviours ships and stations run |
| `libraries/` | The data tables. Wares, ships, jobs, factions, god, icons and around forty more |
| `maps/` | The universe: clusters, sectors, zones, highways and the galaxy that joins them |
| `index/` | Name-to-path lookups for components and macros, so the rest of the game can refer to an asset by name |
| `assets/` | Models, textures and the macros that describe physical things |
| `t/` | Text, one file per language |
| `ui/` | Lua files for interface extensions, with a `ui.xml` manifest in the extension root |
| `cutscenes/` | Scripted camera and scene sequences |
| `extensions/` | Changes aimed at *another* extension. See [Patching a DLC or another extension](#patching-a-dlc-or-another-extension) |

The example being built here uses three of them:

```none
extensions/example_starter/
  content.xml
  libraries/
    wares.xml
  t/
    0001-l044.xml
```

[↑ Contents](#toc)

## How a file joins the game

This is the one idea the rest of the page rests on, and the one that most often surprises people coming from games where a mod replaces files.

A file in an extension does **not** simply overwrite the game file at the same path. What happens depends on the file's root element.

**A file whose root element is `<diff>` is a patch.** It is a list of changes to apply to whatever is already there, expressed as XPath selections. The original file stays; the patch edits it in place as it loads. This is the form to reach for by default, and it has a page of its own: [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

**A file with an ordinary root element contributes its contents to a collection gathered from every source.** It does not erase what the game or another extension put there.

That second rule is easy to disbelieve, so here is the proof. The Boron expansion ships `libraries/ships.xml`, exactly the path the game's own ship table occupies. Its file is 305 lines and contains only Boron ships. The game's own is 2000 lines and contains everything else. Both are in effect at once, and Argon ships are not missing from a game with the Boron DLC installed. The whole file added its entries; it did not replace anything.

### Which form to use

The distinction that decides it is not the folder and not the file. It is what the change needs to do.

**To add something new, a whole file is enough.** Its entries join the collection.

**To change or extend something that already exists, a patch is required**, because a whole file has no way to refer to an entry it does not itself contain.

The shipped expansions divide almost perfectly along that line. `ships.xml`, `icons.xml`, `loadouts.xml`, `people.xml`, `constructionplans.xml` and the rest of the add-only tables are whole files in every DLC. `wares.xml`, `factions.xml`, `god.xml`, `diplomacy.xml`, `themes.xml` and the other tables that expansions must reach into are patches in every DLC.

A few files appear in both forms across different expansions, and those are the ones that confirm the rule rather than muddying it. `ego_dlc_pirate` ships 40 new jobs as a whole `libraries/jobs.xml`; `ego_dlc_boron` adds two jobs with a patch. Both work, because both are only adding.

Why `wares.xml` is always a patch shows the other half. The Boron expansion's version performs 72 `add` operations, and their targets are vanilla wares:

```xml
<add sel="/wares/ware[@id='ship_gen_m_tugboat_01_a']">
```

It is adding production details to wares the base game defined. No whole file can do that, because the element being extended is not in the extension.

### When a whole file really does replace

Files that are not collections have nothing to gather, so a whole file at that path stands in for the original. That is the behaviour of a Lua file, a texture or a model, and the reason those are usually shipped in a `subst_` catalog rather than an `ext_` one. See [Packing it up](#packing-it-up).

[↑ Contents](#toc)

## Adding something of your own

The example extension adds one ware. An inventory ware is the least demanding thing to add, because it needs no production chain, no station module and no 3D model.

`libraries/wares.xml`, patching because the ware has to be inserted into the existing `<wares>` list:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/wares">
    <ware id="inv_example_datachip" name="{9999001,101}" description="{9999001,102}"
          group="hardware" transport="inventory" volume="1" tags="inventory tradeonly">
      <price min="800" average="1000" max="1200" />
      <container ref="sm_gen_wares_common_01_macro" />
      <icon video="ware_inventory_advencedtargetingmodule_macro" />
      <sources>
        <source type="{20224,1}" />
      </sources>
    </ware>
  </add>
</diff>
```

`sel="/wares"` selects the root element of the game's ware table, and with no `pos` attribute the new `<ware>` is appended inside it as the last child.

Two details in there are worth naming, because they are conventions rather than syntax. `container ref` and `icon video` point at macros the base game already defines, which is how a new ware borrows an existing appearance instead of shipping assets. And the `name` and `description` are not text: they are references into a text file.

[↑ Contents](#toc)

## Text and translations

Anything the player reads lives in `t/`, never inline in the data. A string is referenced as `{page,id}`, so `{9999001,101}` means entry 101 on page 9999001.

`t/0001-l044.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="9999001" title="Example Starter" descr="Text for the Example Starter extension" voice="no">
    <t id="101">Example Data Chip</t>
    <t id="102">A chip of no particular consequence.</t>
  </page>
</language>
```

### File names

Two forms are valid, and they can be used together.

`0001.xml` has no language suffix and is used for **every** language. It is the right choice for an extension that is English-only, because it means an Italian player sees English text rather than nothing at all.

`0001-lNNN.xml` applies to language `NNN` only, and takes precedence over `0001.xml` where both define the same entry. This is the form to add as translations arrive.

Nothing here is mandatory. Published extensions ship anything from a single file to a complete set, and one shipping both `0001.xml` and `0001-l044.xml` together is a perfectly ordinary arrangement.

### Language codes

`44` is English, `49` German, `33` French, `34` Spanish, `39` Italian, `7` Russian, `42` Czech, `48` Polish, `55` Portuguese, `81` Japanese, `82` Korean, `86` Chinese Simplified, `88` Chinese Traditional, `90` Turkish, `359` Bulgarian, `380` Ukrainian. They are international dialling codes, which makes them easy to recognise and hard to guess wrong.

### Choosing a page id

Page ids are global. Two extensions that pick the same one will overwrite each other's entries, and the symptom is a menu showing another mod's text.

The base game uses 473 pages, and the highest is `30622`. **Pick a page id far above that**, at least six digits, and something distinctive rather than a round number. Then use the same page for everything the extension needs, giving each string its own `t id`, rather than claiming several pages.

Before minting one, it is worth checking whether the base game already has the string. Common words such as ware names, ship classes and menu verbs are all in the game's own pages, and referencing one gets every translation for free.

[↑ Contents](#toc)

## Changing something that already exists

The example so far only adds. Changing a value the game already defines is the same patch file with a different operation:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/wares">
    ...
  </add>
  <replace sel="/wares/ware[@id='ice']/price/@average">32</replace>
</diff>
```

`sel` here walks to an attribute rather than an element, and the text inside `<replace>` becomes its new value.

That is the whole shape of it, and the syntax has a page of its own: [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/) covers the three operations, what `sel` accepts, where added content lands, conditional patches, and how to write a selection that survives the next game update.

[↑ Contents](#toc)

## Patching a DLC or another extension

Everything so far has been aimed at the base game. To change a file belonging to another extension, mirror its path inside an `extensions` folder of your own:

```none
extensions/example_starter/
  content.xml
  extensions/
    ego_dlc_split/
      assets/
        units/
          size_xl/
            macros/
              ship_spl_xl_battleship_01_a_macro.xml
```

The path reads as what it is: the file at `extensions/ego_dlc_split/assets/units/size_xl/macros/ship_spl_xl_battleship_01_a_macro.xml`, seen from the game root. The patch applies to the Split expansion's copy of that ship macro, and the base game has no file at that path at all.

The patch is an ordinary `<diff>`, written against the file it is aimed at:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <replace sel="/macros/macro[@name='ship_spl_xl_battleship_01_a_macro']/properties/hull/@max">260000</replace>
</diff>
```

This works because the expansion ships that macro as a whole file, with `<macros>` as its root element. The selection walks the document the expansion itself wrote. When the target is a patch instead, none of that holds, and the section below is about what to do then.

This needs a dependency to be reliable. Without one, there is no guarantee the target extension has been loaded when the patch is applied:

```xml
<dependency id="ego_dlc_split" version="100" optional="true" />
```

`optional="true"` is usually right here. It keeps the load-order guarantee, so the patch lands after the expansion when the expansion is present, and the extension still loads for players who do not own it. The patch simply finds nothing to patch, which is what [the `silent` attribute](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/) is for.

### When the other extension's file is itself a patch

Mirroring the path works when the file being aimed at holds data of its own, as that ship macro does. It does not work when that file is itself a `<diff>`, and that is not a rare case: 168 of the 573 XML files in the shipped expansions are patches.

Keep the same expansion and move to its ware table, and this is what is waiting at `extensions/ego_dlc_split/libraries/wares.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/wares/production">
    ...
```

The mirrored path names a real file, and a patch applied to it patches *that document*. So a patch at that path is editing a list of operations, not the ware table. Its `sel` would have to read something like `/diff/add[@sel="/wares/production"]`, selecting one of the other author's operations by the text of that operation's own selector. That is brittle in a way nothing else here is, and it is almost never what was wanted.

**The way through is to stop aiming at their file and aim at the original.** Patch the base game file from the extension's own root, as normal, and rely on load order to arrive after their patch has already been applied:

```none
extensions/example_starter/
  content.xml
  libraries/
    wares.xml            patches the base game file, after the expansion has patched it
```

```xml
<dependency id="ego_dlc_split" version="100" optional="true" />
```

That dependency is doing only one job, and it is the job the Egosoft comment quoted above describes: it sorts the load order. Dependencies load first, so by the time this extension's patch runs, the expansion's patch has already been applied to the base file and its results are part of the document being selected against.

Two consequences are worth holding on to.

**The selection must describe the state after their patch, not before.** An element the other extension added is there to be selected; an element it removed is not. Reading their patch file is the only way to know which.

**That state exists only when the other extension is present.** For a player without the expansion, the selection finds nothing. An extension that has to work either way should pair this with `if` or `silent` so the absence is handled deliberately rather than logged as a failure. Both are on [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

This also explains an asymmetry that otherwise looks arbitrary. Mirroring the path is the right tool for assets, macros and map files, which expansions ship as whole files. For the data tables, which expansions mostly ship as patches, the base file plus an ordering dependency is the only approach that holds up.

[↑ Contents](#toc)

## If your extension has a UI

The interface is Lua, and it is the one part of an extension that does need a manifest. A `ui.xml` in the extension root declares which Lua files to load:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<addon name="example_starter" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:noNamespaceSchemaLocation="../../ui/core/addon.xsd">
  <environment type="menus">
    <dependency name="ego_detailmonitor" />
    <file name="ui/example_starter.lua" />
  </environment>
</addon>
```

`<environment type="menus">` is the part that carries a warning. The interface runs in two separate Lua environments: the **menus** environment, which is everything the map, the station menus and the options screens are built from, and the **core** environment, which is the HUD in flight. Only the menus environment accepts a registered file. There is no `type` value that adds a file to the core environment, and an extension that needs to reach the HUD has to get there another way.

`<dependency name="...">` inside the environment names another UI addon, and orders loading the same way a `content.xml` dependency orders extensions. `ego_detailmonitor` is the vanilla addon most menus belong to, so an extension patching a menu usually declares it.

Everything past the manifest, which is to say the Lua itself, is a subject of its own: see [UI Modding support](/x4/modding-support/ui-modding/).

[↑ Contents](#toc)

## Packing it up

Loose files work. An extension can be published as a folder of plain XML and it will load correctly. Packing is worth doing anyway, because a single archive loads faster than several hundred files and is far easier to distribute intact.

An extension's files are packed into pairs: a `.cat` holding the index and a `.dat` holding the file bodies. There are two kinds, and picking the wrong one is a common first mistake.

**`ext_01.cat` / `ext_01.dat` hold paths relative to the extension folder.** This is where everything discussed on this page belongs. An `ext_` catalog is the extension folder in packed form and nothing more: an entry in it merges or patches exactly as the same file would loose, by the rules in [How a file joins the game](#how-a-file-joins-the-game).

**`subst_01.cat` / `subst_01.dat` hold paths relative to the game root**, and stand in for the file that is already there. Nothing is merged and nothing is patched, so a substitute has to be a complete, valid file of its kind. This is the form for the cases in [When a whole file really does replace](#when-a-whole-file-really-does-replace), and it has no loose equivalent, because a file in an extension folder is addressed as `extensions/<folder>/...` and never as a game root path.

`content.xml` always stays loose beside the catalogs, never inside them. The game has to read it before it knows anything else about the extension.

The format itself, the two version-named kinds, load order, and what is worth leaving loose while developing are on [Catalogs](/x4/modding-support/anatomy-of-an-extension/catalogs/). For the packing itself, see [X Catalog Tool](/x4/modding-support/x-catalog-tool/).

[↑ Contents](#toc)

## The finished example

```none
extensions/example_starter/
  content.xml                    id, version, dependencies
  libraries/
    wares.xml                    <diff>: adds a ware, adjusts a vanilla price
  t/
    0001-l044.xml                page 9999001, entries 101 and 102
```

Three files, and every mechanism on this page is in one of them. A larger extension is not a different shape, only more of the same one: more folders from [the folder map](#the-folder-map), more patches, and eventually a `ui.xml` and a catalog.

The next thing to read depends on what the extension needs to do. To change what the game already defines, which is most mods, it is [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/). To add an interface, it is [UI Modding support](/x4/modding-support/ui-modding/). To publish it as a package rather than a folder, it is [Catalogs](/x4/modding-support/anatomy-of-an-extension/catalogs/).

[↑ Contents](#toc)

{{children}}
