---
title: quotas.xml
description: How libraries/quotas.xml sets a weight and a zone limit per mission type for the whole galaxy and overrides them per cluster, sector and zone - the file's layout, the inheritance between spaces, which mission types it accepts and which of them the scripts know, how the value reaches a script through the quota keyword, how vanilla limits its offers instead, and how an extension adds a quota of its own.
---

# quotas.xml

`libraries/quotas.xml` is the mission offer quota table: for every mission type a **weight** and a **zone limit**, set once for the whole galaxy and overridden for a cluster, a sector or a single zone. The engine reads it and hands the result to scripts through one keyword, `quota`, which gives the quota of a mission type in the player's current zone.

This article covers the format, how the value reaches a script, how vanilla limits its offers, and how an extension adds a quota. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Offer**: a mission offer, created by a script with `create_offer` and shown in the mission offer list, usually at a station.
- **Mission type**: the `type` of an offer, `missiontype.trade`, `missiontype.deliver` and the rest of the script lookup; the four guild types `trade`, `fight`, `build` and `think` are among them.
- **Space**: a cluster, a sector or a zone, named by its macro from the universe map.
- **Zone limit**: `zonelimit`, a number or `none`, on a space's `<offers>` as a default and on each `<offer>` for one type.
- **Weight**: `weight`, a number per type and space. The schema and the file say no more about what the weight does.
- **Quota**: the value the `quota` keyword gives a script for a type in the player's zone.

[↑ Contents](#toc)

## How the value reaches the game

The visible surface of the file is one keyword of the Mission Director: `quota.{missiontype.deliver}` is "the quota for the given mission type, based on the current player zone", an integer. No vanilla script asks it.

The offers vanilla creates keep their own count. The manager cue of `md/genericmissions.xml` holds a limit of generic missions per sector, counts the ones whose offering object sits in the player's sector and creates new ones only up to that limit, with the number per round scaled by the stations around and lowered while the player has an active mission. The comment on that cue says the count is "not based on mission type like the quota.xml system". Whether the engine holds an offer back on its own when a zone is at its limit is not visible in the data; the file's own comments speak of settings that can be overridden or restricted for specific spaces, and the keyword is what a script gets.

[↑ Contents](#toc)

## The file

### Layout

```xml
<quotas loadmacros="false">
  <offers zonelimit="10">
    <offer type="trade" weight="100"/>
    <offer type="fight" weight="100"/>
    ...
  </offers>
  <cluster macro="Cluster_01_macro">
    <offers>...</offers>
    <sector macro="Cluster_01_Sector001_macro">
      <offers>...</offers>
      <zone macro="Zone001_Cluster_01_Sector001_macro">
        <offers>...</offers>
      </zone>
    </sector>
  </cluster>
</quotas>
```

The root holds the galaxy-wide `<offers>` and then any number of spaces. A `<cluster>` may hold sectors and zones, a `<sector>` zones, and each space may carry its own `<offers>`. Vanilla's file is the galaxy-wide block alone: every type it lists at the same weight, under one zone limit, and no space of its own; the spaces above are from the commented example at the end of the file. The schema, `libraries/quotas.xsd`, documents the rest.

[↑ Contents](#toc)

### Offers, part by part

```xml
<offers zonelimit="10">
  <offer type="build" weight="200" zonelimit="1"/>
  <offer type="think" zonelimit="1"/>
</offers>
```

| Attribute | Meaning |
| --- | --- |
| `zonelimit` on `<offers>` | The limit for every type of this space that has none of its own; a non-negative integer or `none` |
| `type` on `<offer>` | The mission type, required |
| `weight` on `<offer>` | The weight of the type in this space |
| `zonelimit` on `<offer>` | The limit of this type in this space |

The file's comment gives the defaults and the inheritance: the global default weight is 0 and the global default limit is none, and the values of a space are derived from its parent nodes. A type with no `<offer>` anywhere has weight 0; a sector that lists two types takes the others from its cluster or, failing that, from the galaxy-wide block. In the example above the sector raises the weight of build missions and holds both build and think missions to one per zone, and a zone with `<offers zonelimit="0"/>` gets no offers at all.

[↑ Contents](#toc)

### Spaces and macros

A space is named by its macro, `Cluster_01_macro`, `Cluster_01_Sector001_macro`, `Zone001_Cluster_01_Sector001_macro`, as `maps/xu_ep2_universe/` defines them in `clusters.xml`, `sectors.xml` and `zones.xml`; `libraries/mapdefaults.xml` gives their names, here Grand Exchange and Grand Exchange I. The root's `loadmacros` is a check: with `true` the named macros are loaded even where the universe does not use them, so a misspelt macro gives an error; the default `false` lets a typo pass in silence.

[↑ Contents](#toc)

### Mission types

The schema enumerates the types an `<offer>` accepts; the script side has its own list, `missiontype.<name>`, which `create_offer` takes. The two lists overlap but are not the same:

| Where | Types |
| --- | --- |
| In the schema and in the script lookup | `plot`, `trade`, `fight`, `build`, `think`, `other`, `station`, `board`, `deliver`, `destroy`, `drop`, `escort`, `explore`, `find`, `follow`, `hack`, `kill`, `patrol`, `pickup`, `protect`, `race`, `repair`, `restock`, `scan`, `talkto`, `transport`, `intelligence`, `military`, `police` |
| In the schema only | `build_ship`, `build_station`, `buy`, `dockat`, `flyto`, `sell`, `hazardousmaterials`, `intoxicants`, `pharmaceuticals`, `protectedspecies`; no offer can carry them and no script can ask for them |
| In the script lookup only | `chain`, `collect`, `crisis`, `extend`, `guidance`, `procure`, `raid`, `rescue`, `research`, `smuggle`, `tutorial`, `completed_tutorial`, `hints` and the six `upkeep_` types; the file cannot hold a quota for them |

Vanilla's file lists the first group without `plot` and `station`. Of the types vanilla's scripts give their offers, `plot` is the most common, then `deliver`, `tutorial`, `fight` and `destroy`.

The schema also defines a dock population type (`build`, `trade`, `drones`, `ships`, `repair`, `ammo`, `bar`) and a ware amount attribute group; no element uses either.

[↑ Contents](#toc)

## How the expansions change it

No expansion ships a `libraries/quotas.xml`. The clusters and sectors they add fall under the galaxy-wide block.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `quota.{$missiontype}` | The quota of a mission type in the player's current zone, an integer; Mission Director only |
| `missiontype.<name>` | A mission type as a value, for `quota` and for the `type` of an offer |
| `create_offer`, `create_mission`, `update_offer`, `update_mission` | Create or change an offer; `type` is required for an offer created from scratch, `location`, `distance` and `space` say where the player sees it |
| `md.GenericMissions.Manager` | Vanilla's own limit of generic missions per sector, a variable of that cue |

[↑ Contents](#toc)

## Adding a quota from an extension

Since no vanilla script reads the keyword, a quota of an extension's own has an effect where the extension's own script asks for it. The example below, for a fictional extension `example_quotas`, lowers the galaxy-wide zone limit, gives the Grand Exchange cluster a block of its own with one zone kept empty, and offers a courier run in the player's sector only while the zone's quota for delivery missions is above zero.

`libraries/quotas.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <replace sel="/quotas/offers/@zonelimit">8</replace>
  <add sel="/quotas">
    <cluster macro="Cluster_01_macro">
      <offers zonelimit="5">
        <offer type="trade" weight="200"/>
        <offer type="fight" zonelimit="2"/>
      </offers>
      <sector macro="Cluster_01_Sector001_macro">
        <zone macro="Zone001_Cluster_01_Sector001_macro">
          <offers zonelimit="0"/>
        </zone>
      </sector>
    </cluster>
  </add>
</diff>
```

`md/Example_Quotas.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="Example_Quotas" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="CourierOffer" checkinterval="1min">
      <conditions>
        <check_value value="player.zone.exists and quota.{missiontype.deliver} gt 0"/>
      </conditions>
      <actions>
        <find_station name="$Station" space="player.sector" owner="faction.argon"/>
        <do_if value="$Station.exists">
          <create_offer cue="this" location="$Station" name="{1234567,1}" description="{1234567,2}" faction="faction.argon" type="missiontype.deliver" difficulty="level.easy" reward="25000Cr"/>
        </do_if>
      </actions>
    </cue>
  </cues>
</mdscript>
```

`t/0001-l044.xml`, with the page id the extension owns:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example Quotas" descr="Texts of the example_quotas extension">
    <t id="1">Courier run</t>
    <t id="2">A crate is waiting for a pilot with time to spare.</t>
  </page>
</language>
```

Some points about the example:

- **The galaxy-wide limit** is one attribute, so a `replace` on it changes every zone that has no closer setting.
- **The cluster block** lists two types; the others keep the galaxy-wide weight, and the cluster's `<offers zonelimit="5">` is their limit there. The fight line sets a limit and no weight, so the weight stays the galaxy-wide one.
- **The empty zone** needs no `<offers>` on its sector: a sector without a block passes the cluster's values through, and the zone's own block with a limit of 0 overrides them for that zone alone.
- **The script gate** is where the quota takes effect. The condition reads the player's zone, so the cue checks only while the player is somewhere; what follows is an ordinary offer. The mission behind it is not part of the example.
- **Generic missions are untouched**: their count per sector is the generic mission script's own, so the new limits change nothing about them.
- **A typo in a macro** passes in silence with `loadmacros="false"`; setting it to `true` on the root while testing turns it into an error.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[missiongroups.xml](/x4/modding-support/anatomy-of-game-data/libraries/missiongroups-xml/) groups the offers in the mission list, which is where the types an offer carries become visible.

[↑ Contents](#toc)
