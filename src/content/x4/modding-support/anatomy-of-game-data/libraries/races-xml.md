---
title: races.xml
description: How libraries/races.xml defines the nine races - names and name pools, the character defaults for walking, sitting and spacesuits, icons, race relations, and the engine trail colours - what a faction takes from its race, the script side, and how an extension changes a race.
---

# races.xml

Behind every faction stands a **race**: the species its people belong to. `libraries/races.xml` defines the nine the game knows, and each `<race>` holds what is the same for everyone of that species whichever faction they serve: the names, the pool the game draws personal names from, how tall a character is and how fast it walks, which chair animation it sits in, which spacesuit it wears, the icons, how the race stands to the others, and the colour of its engines' trails.

This article covers the format, what the game takes from each part, the script side and how an extension changes a race. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Race**: one `<race>` entry, named by its `id`. A script refers to it as `race.<id>`.
- **Faction**: an owner of ships and stations, from [factions.xml](/x4/modding-support/anatomy-of-game-data/libraries/factions-xml/). A faction names its race as `primaryrace` and inherits what the race defines.
- **Name pool**: the text page a race's personal names are generated from.
- **Workforce**: the people a station's habitats house; only some races supply it.

[↑ Contents](#toc)

## What a race defines

The race is where the game looks for anything that depends on the species rather than the owner:

1. **A faction's defaults.** A faction without a `constructionbias` of its own takes the race's, and a faction's stations use the race's build method unless `<buildrules>` says otherwise. The race's texts name the species where the faction's name the organisation.
2. **A character's body.** Height, width, walking and running speed, the chair configuration and animations, the position adjustment in an event monitor, and the spacesuit macro a character of that race uses when leaving a ship.
3. **A character's name.** When the game creates a person, the first and last name come from the race's name page.
4. **The engines.** Every ship flown by that race's faction draws its engine trail with the race's colour settings.
5. **Selection.** Scripts and tables select by race: `select race="race.argon"` in a script, the race in a `characters.xml` or `people.xml` category, the `race` of a station module set.

[↑ Contents](#toc)

## The file

### Layout

```xml
<races>
  <race id="argon" name="{20202,101}" description="{20202,102}" shortname="{20202,103}"
        spacename="{20202,105}" homespacename="{20202,106}" names="20301" tags="workforce">
    <character height="1.78">
      <speed slowwalk="0.8" walk="1.15" run="2.6" acceleration="4" />
      <eventmonitor adjusty="0.1" adjustz="-0.25" facecutscenekey="ShowNPCFaceArgon" />
      <spacesuit ref="ship_arg_xs_spacesuit_01_a_macro" />
    </character>
    <icon active="race_argon" inactive="race_argon" />
    <agent>
      <icon id="diplomacy_agent_human_male" female="diplomacy_agent_human_female" />
    </agent>
    <relations>
      <relation race="boron" relation="1" />
      <relation race="paranid" relation="-1" />
    </relations>
    <trail brightness="1" contrast="1" saturation="0.6" hue="140" />
    <engineeffect colorindex="1" />
  </race>
  ...
</races>
```

The base file holds all nine races, the five of the base game, the Boron and the Terran of the expansions, and the Kha'ak and the drones. No expansion ships a `races.xml`: the species of Split Vendetta, Cradle of Humanity and Kingdom End are defined here, and the expansions add their factions on top. The race ids the script schemas accept are the same nine: `argon`, `boron`, `split`, `paranid`, `teladi`, `terran`, `xenon`, `khaak` and `drone`.

The schema, `libraries/races.xsd`, documents every element and attribute.

[↑ Contents](#toc)

### Attributes

| Attribute | Meaning |
| --- | --- |
| `id` | The race id, `race.<id>` in a script |
| `name`, `description`, `shortname` | The name, the encyclopedia text and the abbreviation; vanilla's are on text page 20202 |
| `spacename`, `homespacename` | The names of the race's space and home |
| `names` | The id of the text page the race's personal names are generated from, see [Names](#names) |
| `constructionbias` | How stations of this race grow: below 1.0 prefers vertical connections, above 1.0 horizontal; default 1.0. A faction can override it |
| `tags` | Vanilla uses three: `workforce` on the six races whose people work in station habitats, `hidden` on the drones, and `nocockpitview` on the Xenon |

The Kha'ak, the Xenon and the drones have no `names` page and no `<character>`: nobody of those races walks a dock.

[↑ Contents](#toc)

### Names

The `names` page is a small generator. Vanilla's Argon page, 20301, starts like this:

```xml
<page id="20301" title="Argon Names" descr="0" voice="no">
  <t id="1">$P $F(Formatting)</t>
  <t id="2">10(Male personal name index)</t>
  <t id="3">12(Female personal name index)</t>
  <t id="5">11(Family name index)</t>
  <t id="10">100(Male first names)</t>
  <t id="11">100(Last names)</t>
  <t id="12">100(Female first names)</t>
  <t id="1001">Aiden</t>
  ...
</page>
```

Entry 1 is the format: `$P` is a personal name, `$F` a family name, `$M` a middle part and `$N` a numeral. Entries 2, 3 and 5 say which block holds the male, the female and the family names, and the block's own entry, 10, 11 or 12, says how many names it holds. The names themselves follow in blocks of a hundred ids, block 10 from id 1000, block 11 from 1100, block 12 from 1200.

The six vanilla pages differ in shape as the races' names do. The Argon and Terran pages are `$P $F` with a hundred names in each of three blocks. The Boron page is the same form with two blocks and no female block. The Split page is `$P $M$F` with a middle block of one entry, and the Paranid page `$P$M$F` with segments rather than names. The Teladi page is `$P $P $P $N`, three names from one block and a numeral from another.

A page of the same shape under an extension's own page id, named in a race's `names`, is what gives a race a new name pool.

[↑ Contents](#toc)

### Character

`<character>` holds what every person of the race shares in first person and on docks:

| Element or attribute | Meaning |
| --- | --- |
| `height`, `width` | The default size of a character in metres |
| `<speed>` | `slowwalk`, `walk` and `run` in metres per second, and `acceleration` |
| `<eventmonitor>` | How a face of this race is placed when shown in a ship's event monitor: `adjusty` and `adjustz` shift it, `facecutscenekey` names the face cutscene |
| `<spacesuit ref="..."/>` | The spacesuit macro a character of this race uses |
| `<chair>` | The chair configuration and sitting animation, and under `<steering>` the trigger and animation for steering from the chair. Vanilla sets them for the Boron and the Paranid; the others use the defaults the schema names |

The Terrans share the Argon spacesuit and face cutscene, which is how the file says that two races use one body.

[↑ Contents](#toc)

### Icons

`<icon active="..." inactive="..."/>` names the race icons from `libraries/icons.xml`, both required. `<agent>` holds the icon of a diplomacy agent of this race, with `id` as the default and `female` for a female agent where the race has two.

[↑ Contents](#toc)

### Relations

`<relations>` lists `<relation race="..." relation="..."/>` lines, and the value is one of -1, 0 and 1 only. Vanilla sets a handful: Argon and Boron like each other, Argon and Paranid do not, Boron and Split do not. These are the race-level sympathies, separate from the faction relations in `factions.xml`, which are what decides who shoots whom.

[↑ Contents](#toc)

### Trail and engine effect

`<trail>` shifts the colour of the race's engine trails: `brightness`, `contrast`, `saturation` and `hue`, each a multiplier or a shift with 1.0 or 0.0 as the neutral value. `<engineeffect colorindex="..."/>` picks the row of the engine effect colour atlas, and vanilla gives each race its own row, 0 to 8.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `race.<id>` | The race |
| `.name`, `.shortname`, `.spacename`, `.homespacename`, `.description` | The texts |
| `.height` | The default character height |
| `.facecutscene` | The face cutscene key, or null when the race has none |
| `.workforce.resources` | The wares the workforce of this race needs to prosper |
| `.agent.icon`, `.agent.femaleicon` | The agent icons |
| `faction.<id>.primaryrace` | A faction's race |
| `<select race="..."/>` | The race filter of the creation actions, such as the `<pilot>` of `create_ship` |

There is no action that changes a race at run time: the file is read when the game loads, and a race is what its entry says.

[↑ Contents](#toc)

## Changing a race from an extension

A new race is not something an extension adds in practice: the script schemas enumerate the nine ids, every character body, face and animation is an asset of one of them, and no expansion has added one. What an extension does is change a race, and that is a diff on `libraries/races.xml`. The example below, for a fictional extension `example_race`, makes Argon characters walk and run a little faster, adds an Argon race relation to the Teladi, and points Argon name generation at a page of the extension's own.

`libraries/races.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <replace sel="/races/race[@id='argon']/character/speed/@walk">1.4</replace>
  <replace sel="/races/race[@id='argon']/character/speed/@run">3.0</replace>
  <replace sel="/races/race[@id='argon']/@names">1234567</replace>
  <add sel="/races/race[@id='argon']/relations">
    <relation race="teladi" relation="1" />
  </add>
</diff>
```

`t/0001-l044.xml`, with the page id the extension owns, in the shape of the vanilla Argon page:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example Argon Names" descr="0" voice="no">
    <t id="1">$P $F</t>
    <t id="2">10</t>
    <t id="3">12</t>
    <t id="5">11</t>
    <t id="10">3</t>
    <t id="11">3</t>
    <t id="12">3</t>
    <t id="1000">Marten</t>
    <t id="1001">Elan</t>
    <t id="1002">Dal</t>
    <t id="1100">Holt</t>
    <t id="1101">Varn</t>
    <t id="1102">Brenner</t>
    <t id="1200">Lena</t>
    <t id="1201">Ilse</t>
    <t id="1202">Mira</t>
  </page>
</language>
```

Some points about the example:

- **A `<replace>` on an attribute** is the form for a single value. The Argon entry already has a `<relations>` element, so the relation is added into it; a race without one, such as the Teladi, needs the whole element added.
- **The name page replaces the vanilla one** for every Argon created from then on. Extending the vanilla pool instead is a diff on the text file: more entries in the three blocks of page 20301, and the counts in entries 10, 11 and 12 raised to match.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[factions.xml](/x4/modding-support/anatomy-of-game-data/libraries/factions-xml/) is where a race's factions are defined and where the relations that matter in play live.

[↑ Contents](#toc)
