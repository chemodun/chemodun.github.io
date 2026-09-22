---
title: Catalogs
description: The cat/dat archives an extension ships in - what the pair actually is, the kinds of catalog and what their paths are relative to, why ext_ and subst_ are not the same kind of thing, and the order the game applies them.
order: 2
wiki: Catalogs
wikiRef: also
---

<!-- Canonical copy; the Egosoft wiki page is exported from it -->

# Catalogs

An extension can be published as a folder of plain files, and the game will load it correctly. It can also be packed, and almost every published extension is, because a single archive loads faster than several hundred files and is far easier to distribute intact.

This page is what that archive is, the kinds of it an extension can hold, and what the game does with them. It follows on from [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/), which covers what goes into an extension in the first place. The tool that packs and unpacks the format is [X Catalog Tool](/x4/modding-support/x-catalog-tool/), and an archive whose content depends on the game version is [Multi-version extensions](/x4/modding-support/multi-version-extensions/).

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## What a catalog is

A `.cat` is a **plain text index**, one line per file:

```none
md/enhanced_info_center.xml 6312 1787240309 d3ae7c9e5a51e0e2f5a29c4e0f9c1b2a
t/0001-l044.xml 2238 1787300995 7c854bec9a7b06c42535d7f5f1a9e42a5
```

Four fields: the path inside the archive, the size in bytes, the modification time as a Unix timestamp, and the MD5 of the content. A path may contain spaces, so anything parsing this has to key on the **last three** whitespace separated fields, not the first.

The `.dat` beside it is those file bodies concatenated in index order. No header, no padding, no compression, no per-entry marker: the index is the only thing that says where one file ends and the next begins. The two are paired by name, so `ext_01.cat` needs `ext_01.dat` next to it and renaming one without the other breaks the archive.

Nothing about the format hides anything. Opening a `.cat` in a text editor is the quickest way to see exactly what a package holds, which is worth doing to any extension whose behaviour is a surprise.

### How the index is written

Four properties are worth knowing before writing anything that reads or produces one:

- Entries are sorted by the **lowercased** path in byte order, but the **original case is stored**. `my folder/a file.xml` sorts before `UPPER.TXT`, and a naive sort on the raw paths gets that pair the wrong way round.
- A **zero byte file** is written with 32 zeros as its hash, never the MD5 of the empty string.
- A **deletion marker** is size 0 *and* timestamp 0. A genuinely empty file keeps its real timestamp, and that timestamp is the only thing separating the two.
- The timestamp is the **source file's** modification time, not the time of packing. Repacking an unchanged tree produces an identical catalog.

[↑ Contents](#toc)

## The kinds of catalog

The game's own data sits in catalogs numbered plainly, `01.cat` upwards, in the installation folder. Inside an extension folder the name carries a prefix as well, and that prefix is the part that matters: it says what the paths inside the catalog are relative to. Picking the wrong one is a common first mistake.

| Name | Read as | Used for |
| --- | --- | --- |
| `ext_01.cat`, `ext_02.cat` ... | paths relative to the **extension folder** | the normal way to ship a mod |
| `ext_v###.cat` | the same, for one game version | a version specific build |
| `ext_NN_diff_v###.cat` | the same, for that game version and every later one | a layer over `ext_NN`, from 9.00 |
| `subst_01.cat`, `subst_02.cat` ... | paths relative to the **game root** | replacing base game files |
| `subst_v###.cat` | the same, for one game version | a version specific replacement |

`###` is the game version with no separator, so `ext_v900.cat` is loaded by 9.00 and ignored by everything else. `ext_NN_diff_v###.cat` is the exception and is new in 9.00: it names the numbered catalog it layers over, and it applies on the version in its name and on every version above it rather than on one. Both have rules of their own, and they are stricter than they look: see [Multi-version extensions](/x4/modding-support/multi-version-extensions/).

An `ext_` catalog is where everything an extension normally ships belongs. `libraries/wares.xml` in an `ext_` catalog is the extension's own ware file, exactly as the loose file was. A `subst_` catalog is the exception rather than the other half of a pair, and most extensions never need one.

[↑ Contents](#toc)

## ext_ and subst_ are not the same kind of thing

The two prefixes look like a matched pair, and they are not. The difference is worth stating on its own, because it decides what can go in each.

**An `ext_` catalog is the extension folder in packed form and nothing more.** An entry in it behaves exactly as the same file would loose in the extension folder, merging into a collection or patching as a `<diff>` by the rules in [How a file joins the game](/x4/modding-support/anatomy-of-an-extension/#how-a-file-joins-the-game). Packing changes how the file is stored and nothing about how it is applied. Unpack an `ext_` catalog back into the folder and the extension behaves identically.

**A `subst_` catalog is not a packed folder at all.** Its entries stand in for a file that already exists: `ui/core/lua/monitors.xpl` in a `subst_` catalog is handed to the game in place of the original. Nothing is merged and nothing is patched, so a substitute has to be a complete, valid file of its kind. This is the form for the cases in [When a whole file really does replace](/x4/modding-support/anatomy-of-an-extension/#when-a-whole-file-really-does-replace): an interface Lua file, a texture, a model.

The asymmetry follows from the paths. A loose file in an extension is addressed as `extensions/<folder>/...`, never as a game root path, so the paths a `subst_` catalog holds are ones the extension folder cannot express. Packing is what makes the substitution sayable in the first place, which is why there is no loose equivalent of it, and why unpacking one into the extension folder does not reproduce the extension.

Because an extension's own folder also lives under the game root, a `subst_` catalog can address a file belonging to *another* extension, as `extensions/<their-folder>/<path>` - the other extension's **folder name**, which for a Workshop mod is not its `content.xml` id. That is the heavy-handed counterpart of [Patching a DLC or another extension](/x4/modding-support/anatomy-of-an-extension/#patching-a-dlc-or-another-extension): the patch edits what is there, the substitution takes the file over entirely.

Substitution is a blunt instrument either way. Two extensions substituting the same file cannot both take effect, and neither one can tell that the other tried. It is worth being certain no patch can do the job first.

[↑ Contents](#toc)

## Load order

The game reads `01.cat` upwards in its own root folder and stops at the first missing number, so a gap in the numbering hides everything after it. Then it reads the catalogs of every enabled extension.

Within an extension, four rules decide what beats what:

- **The number is load order within the kind.** `ext_02` is applied after `ext_01`, and the same for `subst_`.
- **A version catalog is applied after every numbered catalog of its kind.** `ext_v900` beats both `ext_01` and `ext_02` on 9.00.
- **A diff catalog is applied after the numbered catalog it names**, on the version in its name and on every version above it. `ext_01_diff_v900` follows `ext_01` from 9.00 onward.
- **The two kinds rank only among themselves.** A `subst_` catalog is never in competition with an `ext_` one, because the two are not addressing the same paths.

Neither kind is required, and neither requires the other. An extension can ship a single `subst_` pair and leave the rest of its files loose, or a single version catalog with no numbered catalog at all.

Load order between extensions is a separate question, and `content.xml` answers it: see [Dependencies](/x4/modding-support/anatomy-of-an-extension/#dependencies).

[↑ Contents](#toc)

## What stays outside

`content.xml` always stays loose beside the catalogs, never inside them. The game has to read it before it knows anything else about the extension, including whether it is enabled.

Anything else may stay loose too, because packing is not all-or-nothing. A packed expansion on disk looks like this:

```none
ego_dlc_boron/
  content.xml  content.xml.sig
  ext_01.cat  ext_01.dat  ext_01_sig.cat  ext_01_sig.dat
  ext_02.cat  ext_02.dat  ext_02_sig.cat  ext_02_sig.dat
  ext_03.cat  ext_03.dat  ext_03_sig.cat  ext_03_sig.dat
  videos/
```

The `_sig` pairs and the `.sig` file are Egosoft signatures, and are not something an extension produces or needs. The loose `videos/` folder shows the other half: a folder can stay outside the catalogs when there is no reason to pack it.

[↑ Contents](#toc)

## While developing

An extension's own files are comfortable left loose. Nothing has to be packed for the game to load it, and editing a file in place beats repacking after every change.

Substitutions are the exception to that, with one exception of their own: an interface Lua file left at its game root path inside the extension folder, as `ui/core/lua/<name>.lua`, does take effect. A substitution of one can be edited and reloaded without a catalog, which leaves packing as a release step rather than a working requirement.

For the packing itself, and for reading the game's own catalogs, see [X Catalog Tool](/x4/modding-support/x-catalog-tool/).

[↑ Contents](#toc)
