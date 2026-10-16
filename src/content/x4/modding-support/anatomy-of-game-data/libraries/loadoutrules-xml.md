---
title: loadoutrules.xml
description: How libraries/loadoutrules.xml decides which drones and deployables a ship or station is fitted with - the unit and deployable categories, the macro tables that tie a category and mark to a macro, the rulesets with their class, purpose, cargo, faction and docking filters, where the rules apply, how the expansions add their drones, the script side, and how an extension adds a rule.
---

# loadoutrules.xml

A ship or a station that is fitted out gets its engines, shields and weapons from the equipment its owner can get, and its drones and deployables from `libraries/loadoutrules.xml`. The file names the drone and deployable macros the game may hand out, by **category** and **mark**, and holds the **rules** that say which categories an object of a given class, purpose and owner receives, and what share of its capacity each one takes. The same rules give the default stock a ship is restocked to.

This article covers the format, where the rules apply, the script side and how an extension adds a rule. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Unit**: a drone launched by a ship or a station: cargo, mining, building, repair, defence and police drones. A macro is a unit when its `<identification>` carries `unit="1"`.
- **Deployable**: an object a ship drops into space: a laser tower, a mine, a satellite, a navigation beacon, a resource probe.
- **Category**: the role of a unit or a deployable. Units: `build`, `defence`, `gascollector`, `orecollector`, `police`, `repair`, `transport`. Deployables: `lasertower`, `mine`, `navbeacon`, `resourceprobe`, `satellite`.
- **Mark** (`mk`): the version within a category. A category and a mark together name a row of the macro table.
- **Macro table**: the `<macros>` list of one kind, a `<macro>` row per category, mark and macro.
- **Ruleset**: a `<ruleset>` of one `type`; vanilla has `player`, `xenon` and `default`.
- **Rule**: one `<rule>` line: a category and a mark, a weight, and the filters that say which objects it applies to.
- **Capacity**: how many units an object holds, `<storage unit="..."/>` in its macro. Deployables sit in the ammunition storage, which scripts read through `ammostorage`.
- **Loadout level**: a value between 0 and 1 that says how completely an object is fitted out. `parameters.xml` holds the default.

[↑ Contents](#toc)

## Where the rules apply

The rules do nothing on their own. They are read whenever the game generates a loadout, or a script asks what an object should hold by default:

1. **A new ship or station.** A ship from `jobs.xml`, from `god.xml` or from a script's `create_ship` with a `<loadout>` level gets its units and deployables together with the rest of the loadout. A station the faction logic builds goes through `generate_loadout` and `apply_loadout`, whose loadout flags include `units`. The level decides how much of the capacity is filled. The `<loadout>` block of `parameters.xml` holds the defaults: a level of 0.5 with a variation of 0.3, and a fill range for units with a narrower one for defence drones.
2. **Restocking.** The resupply interrupt of the AI scripts evaluates the default unit and deployable storage of a ship at its loadout level, compares it with what the ship holds and orders the difference. The game start setup fills the player's first station the same way, from `evaluate_unit_storage` into `add_units`.
3. **A script that asks.** `evaluate_unit_storage` and `evaluate_deployable_storage` return the categories, marks, macros and amounts the rules give an object at a level, and add nothing to the object.

Which ruleset an object falls under is not written in the file. The file's own comment says the `player` set is used for all player property; the `xenon` set serves the Xenon; the `default` set everybody else. The schema allows three more set types, `shipyard`, `military` and `highvalue`, and a `waregroups` attribute on a ruleset, whose documentation says the wares of the named groups are compared with the products and trade wares of a station to see whether the station fits that set. Vanilla uses none of these.

[↑ Contents](#toc)

## The file

### Layout

```xml
<rules>
  <unit>
    <macros>
      <macro category="transport" mk="1" macro="ship_gen_xs_cargodrone_empty_01_a_macro"/>
      ...
    </macros>
    <rules>
      <ruleset type="player">
        <rule category="repair" mk="1" weight="10" classes="ship_l ship_xl station"/>
        ...
      </ruleset>
      <ruleset type="xenon">...</ruleset>
      <ruleset type="default">...</ruleset>
    </rules>
  </unit>
  <deployable>
    <macros>...</macros>
    <rules>...</rules>
  </deployable>
</rules>
```

Two halves of the same shape, `<unit>` and `<deployable>`, each with a macro table and a list of rulesets. The schema, `libraries/loadoutrules.xsd`, documents every attribute; the category names are enumerated there, separately for units and deployables, and so are the ruleset types.

[↑ Contents](#toc)

### The macro tables

A row ties a category and a mark to a macro, and may narrow who gets it:

| Attribute of `<macro>` | Meaning |
| --- | --- |
| `category` | The unit or deployable category |
| `mk` | The mark of the row within its category |
| `macro` | The unit or deployable macro |
| `factions` | Space-separated faction ids; the row serves only objects owned by those factions |
| `tags` | Space-separated tags. The schema says no more; on the script side `add_units` and the `<unit>` of `create_ship` carry a `tags` attribute of the same shape |
| `restricted` | "Use is restricted" in the schema; vanilla sets it nowhere |

Vanilla's unit table, by category:

| Category | Rows |
| --- | --- |
| `transport` | Six cargo drone macros at mark 1: the untagged `ship_gen_xs_cargodrone_empty_01_a_macro` and five tagged ones, `container`, `solid`, `liquid`, `equipment` and `pickup` |
| `orecollector`, `gascollector` | The solid and the liquid mining drone |
| `build`, `repair`, `defence` | One macro each |
| `police` | One police drone per race, each row with the `factions` it serves: the Argon drone for Argon, Antigone and Hatikvah, the Paranid drone for Paranid, Holy Order and Alliance, the Teladi drone for Teladi, Ministry and Scale Plate, in three marks |

The five tagged cargo drone rows are not wares of their own. Each of their macros names the untagged one as its `alias`, so the ware that is bought and stored is the one cargo drone, and the tag names the kind of cargo the variant is for. Only the untagged row has an entry in `wares.xml`.

The deployable table holds the two laser towers, mark 1 for the XS and mark 2 for the S version, three marks of mine, two of satellite, the navigation beacon and the resource probe, none with `factions` or `tags`.

[↑ Contents](#toc)

### Rulesets

| `type` | What vanilla puts there |
| --- | --- |
| `player` | Units for player property: repair, transport, defence, build and mining drones by class and purpose, then a rule with an empty category whose comment says "keep the rest empty". Deployables: only the empty rule, so a player ship starts with its deployable space free |
| `xenon` | Defence drones for medium and larger ships and for defence modules, transport and repair drones for the station modules; laser towers and mines |
| `default` | Every other faction; the set described below |

[↑ Contents](#toc)

### A rule, part by part

The ore collector rule of the default set:

```xml
<rule category="orecollector" mk="1" weight="100" classes="ship_l ship_xl" important="true" purposes="mine" cargotags="solid" requiredocking="true" requireundocking="true"/>
```

It applies to a large or extra large ship whose primary purpose is mining, whose storage takes solid cargo, and which has a dock the drone can land on and leave from. For such a ship it claims the mining drone of mark 1 with a weight of 100, and `important` makes sure at least one is given.

| Attribute of `<rule>` | Meaning |
| --- | --- |
| `category` | The category to add. An empty category with `mk="0"` is a rule that holds its share of the capacity empty |
| `mk` | The mark, which picks the macro row of the same category and mark |
| `weight` | The share of the capacity this rule gets, relative to the other rules that match the same object |
| `important` | The category matters for the object's operation; the game makes sure at least one unit or deployable of it is added |
| `classes` | Only objects of exactly one of these classes: `ship_s`, `ship_m`, `ship_l`, `ship_xl`, `station`, or a station module class such as `production`, `buildmodule`, `defencemodule`, `dockarea`, `pier` |
| `purposes` | Only objects whose primary purpose is one of these; vanilla's rules use `trade`, `fight`, `build`, `mine`, `auxiliary` and `dismantling` |
| `cargotags` | Only objects whose storage takes cargo with one of these tags: `container`, `solid`, `liquid` |
| `factiontags` | Only objects whose owner carries one of these tags in `factions.xml` |
| `requiredocking`, `requireundocking` | Only objects with a docking bay that lets a unit or deployable of the matching size dock, or undock |

Where the matched values come from:

- **Class and purpose** are in the object's macro: `class="ship_l"` on `<macro>`, `<purpose primary="trade"/>` among its properties.
- **Cargo tags** are on the storage macro connected to the ship, or on a storage module of the station: `<cargo max="1000000" tags="container"/>`.
- **Faction tags** are the `tags` of the owner's entry in `factions.xml`. Vanilla's rules test three: `watchdoguser` for police drones, `plunder` for cargo drones on pirate fight ships, and `extrarepair` for extra repair drones on dock areas. The trading and military factions of the base game carry `watchdoguser`, the pirate factions `plunder`; `extrarepair` is set by one expansion faction only.
- **Capacity** is `<storage unit="10"/>` in the macro, beside the missile storage. A macro without it, such as the medium Argon transporter, gets no units whatever the rules say.
- **Docks** decide `requiredocking` and `requireundocking`; the file's comments say a mark 1 laser tower needs an XS dock and a mark 2 one an S dock.

A station is matched in two layers: `classes="station"` for the station as a whole, and the module classes for what a build module, a production module, a dock area or a pier should hold.

[↑ Contents](#toc)

### The default set

The unit rules of the default set, by what they match:

| Object | Units |
| --- | --- |
| The station | Transport drones, a few repair drones |
| Build module | Build and transport drones, both important; police drones for `watchdoguser` factions |
| Production module | Transport drones, important; a few repair drones; police drones for `watchdoguser` factions |
| Defence module | Defence drones |
| Pier | Transport drones, important; repair drones |
| Dock area | Extra repair drones for `extrarepair` factions |
| Large and extra large ships | A few repair drones for all; more, important, for auxiliaries; transport drones, important, for trade, mining and auxiliary ships; ore or gas collectors, important, for miners by cargo tag; build drones, important, for build and dismantling ships; cargo drones, important, on the fight ships of `plunder` factions |
| Medium and larger ships | A small share of defence drones on trade, mining and build ships, and on large fight ships and auxiliaries; on medium trade, mining and build ships an empty rule keeps part of the capacity free, "do not fill non-combat medium ships with defence drones completely" in the file's words |

The deployable rules of the default set: laser towers for every ship that can launch them, mines for fight ships, satellites for small fight ships (the comments call them scouts) and build ships, resource probes for small fight ships and miners, navigation beacons for small fight ships and for mining, trading and build ships. A mark 4 mine rule with a high weight is there too, commented "only available for some factions. always prefer when available"; in the base game alone no macro row answers it.

[↑ Contents](#toc)

## How the expansions change it

Two expansions ship a `libraries/loadoutrules.xml`, both as a diff that adds rows to the macro tables and leaves the rules alone:

- **Split Vendetta** (`ego_dlc_split`) adds the Split police drone for the Split factions.
- **Cradle of Humanity** (`ego_dlc_terran`) adds the Terran police drone for the Terran faction, and the cluster mine as the mine of mark 4. That is the macro the base game's mark 4 rule waits for. Which factions get it is decided on the ware side: loadout generation selects equipment for a faction, and the cluster mine ware of the expansion lists a single owner.

The other expansions add factions without a police drone row, so the police rules have nothing to give their stations.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `unitcategory.<name>`, `deployablecategory.<name>` | A category as a value; `.maxmk` is its highest mark in the table, `.mk.{$i}.list` the macros of one mark. The script lookup also knows `unitcategory.attack` and `unitcategory.guard`, which the file's schema does not accept |
| `<macro>.unitcategory`, `.deployablecategory`, `.isunit`, `.isdeployable` | The category of a macro, null unless the macro is in the table |
| `<object>.units.count`, `.units.maxcount`, `.units.{$category}.count`, `.list`, `.table`, `.mk.{$i}.count` | What an object holds, by category and mark; `availableunits` in place of `units` counts the ones available now |
| `<object>.ammostorage.{$category}.count`, `.list`, `.table`, `.mk.{$i}.count` | The deployables an object holds, by deployable category |
| `evaluate_unit_storage`, `evaluate_deployable_storage` | The default storage of an object at a level: lists of categories, marks, macros and amounts with matching indices; a level of -1 keeps the one set with `set_loadout_level` |
| `add_units`, `remove_units` | Add or remove units by `macro`, or by `category` and `mk` with optional `tags`; `request_units` and `return_units` are the other unit actions |
| `generate_loadout`, `apply_loadout` | Generate a whole loadout for a macro or a construction sequence at a level, and apply it; the flags select the parts, `units` among them |
| `<loadout><level .../></loadout>` under `create_ship` | A ship created with a generated loadout; `<units><unit category="..." mk="..."/></units>` beside it adds explicit units, which the schema says currently interfere with loadouts |
| `set_loadout_level`, `<object>.loadoutlevel`, `.loadoutvariation`, `player.loadoutlevel` | The level stored on an object, the variation it was generated with, and the player's global level |
| `event_unit_destroyed`, `event_unit_started_building`, `event_unit_stopped_building`, `event_unit_started_repairing`, `event_unit_stopped_repairing` | A unit was lost or changed its task |

Vanilla's own use follows the three cases above: the faction logic generates and applies loadouts for the stations it builds, the resupply interrupt evaluates the default storage against a ship's level less its variation and orders what is short, the game start setup fills the first station from the default, and mission scripts add units by category and mark.

[↑ Contents](#toc)

## Adding a rule from an extension

A rule needs a macro row to answer it, and a row needs a rule to ask for it, so a change is usually a pair. The example below, for a fictional extension `example_loadoutrules`, serves the Teladi trading guild `example_guild` from the [factions.xml](/x4/modding-support/anatomy-of-game-data/libraries/factions-xml/) article: its stations get police drones, and its large freighters a few defence drones and a satellite.

`libraries/loadoutrules.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <replace sel="//unit/macros/macro[@macro='ship_tel_xs_police_01_a_macro']/@factions">teladi ministry scaleplate example_guild</replace>
  <add sel="//unit/rules/ruleset[@type='default']">
    <rule category="defence" mk="1" weight="15" classes="ship_l ship_xl" purposes="trade" factiontags="example_escort" requiredocking="true" requireundocking="true"/>
  </add>
  <add sel="//deployable/rules/ruleset[@type='default']">
    <rule category="satellite" mk="1" weight="5" purposes="trade" factiontags="example_escort"/>
  </add>
</diff>
```

The faction entry of the guild gets two more words in its `tags`:

```xml
tags="economic standard privateship privateloadout watchdoguser example_escort"
```

Some points about the example:

- **The police row** is the Teladi one with the guild added to its `factions`; the guild is Teladi, so its police drone is the Teladi macro. An extension with a police drone of its own adds a row the way the expansions do. The row alone changes nothing: the police rules of the default set ask for the `watchdoguser` tag, so the faction carries it.
- **The faction tag** `example_escort` keeps the two new rules to the guild. Without it they would apply to every faction's traders under the default set. That is vanilla's own pattern, `extrarepair` and `plunder` being tags of the same kind, and `factions.xml` accepts any word as a tag.
- **The mark** ties each rule to its macro row: `defence` at mark 1 is the fighting drone, `satellite` at mark 1 the basic satellite. A rule for a mark with no row gives nothing.
- **The weights** are relative to the other rules the same ship matches: 15 for defence drones against the transport rule of a large trader, 5 for a satellite against the navigation beacon rule.
- **When it shows**: on ships and stations whose loadout is generated after the change. A ship that already exists keeps its units; the resupply interrupt reads the default storage when it restocks, so the rule reaches ships that restock.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[factions.xml](/x4/modding-support/anatomy-of-game-data/libraries/factions-xml/) holds the tags the rules test. [jobs.xml](/x4/modding-support/anatomy-of-game-data/libraries/jobs-xml/) and [god.xml](/x4/modding-support/anatomy-of-game-data/libraries/god-xml/) set the loadout level of the ships and stations they create. `libraries/loadouts.xml` holds the named loadouts a `<loadout ref="..."/>` takes instead of a generated one.

[↑ Contents](#toc)
