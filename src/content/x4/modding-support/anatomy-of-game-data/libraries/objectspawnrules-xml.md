---
title: objectspawnrules.xml
description: How libraries/objectspawnrules.xml decides which hidden lockbox a station gets and which crystal clusters an asteroid field grows, by owner, station type, field type, resource, object size and hazard, and how libraries/objectspawnpoints.xml fixes the positions on a station module where such an object sits - the layout and attributes of both files, the rule order, selections with weights and cooldowns, what the expansions leave out, the script side, and how an extension adds a rule and spawn points of its own.
---

# objectspawnrules.xml

The lockboxes tucked into the structure of a station and the crystal clusters on asteroids are placed by two tables. `libraries/objectspawnrules.xml` is the rule list: a station or an object of a field goes through it from top to bottom, takes the first rule that applies, and that rule's chance decides whether something is spawned and with which drop. `libraries/objectspawnpoints.xml` is the companion table: for a station module macro, the fixed positions and rotations where such an object sits. The rules give the what and the chance, the points give the where.

This article covers both files, how they work together, the script side and how an extension adds a rule and spawn points of its own. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Rule**: one `<rule>` of `objectspawnrules.xml`, under `<stations>` or `<regions>`: the filters that say which objects it applies to, a chance, and what is spawned.
- **Spawn point**: one `<spawnpoint>` of `objectspawnpoints.xml`: a position and a rotation in the coordinate space of a macro, and the macro of the object that appears there.
- **Space**: in `objectspawnpoints.xml`, the macro whose coordinate space the points use; in vanilla always a station module macro.
- **Hidden lockbox**: a lockbox placed by a station rule, with one of the `hidden_*` droplists of `drops.xml` as its contents.
- **Field**: an asteroid or debris field of a region, the `<asteroid>` and `<debris>` fields of `libraries/region_definitions.xml`; its objects are the asteroids and the wreck pieces.
- **Hazardous region**: a region the game treats as hazardous. In `region_definitions.xml` an influence field is hazardous when its definition says so, and a damage field carries a hazard warning by default; the script side tests the same notion with `isinhazardousregion`.
- **Selection**: the `<select>` entries of a rule, each a macro or a drop with a weight; one of them is picked by weight.
- **Cooldown**: the minutes after one of a selection's valuable entries is collected during which no valuable entry spawns again.

[↑ Contents](#toc)

## How the two files work together

The rules file says in its own comment what its evaluation does: the rules are evaluated from top to bottom, every object goes through them and chooses the first one that applies to it. A rule applies when every filter it carries matches the object: for a station its owner, its type and whether it stands in a hazardous region; for the object of a field the field's type and resource, the object's size, the sector, the sector's owner and the hazard. A rule with no filter applies to everything, which is what the last rule of each list is in vanilla.

Once a rule applies, its `chance`, in percent, decides whether an object is spawned, at a randomly selected location. Where that location is comes from the other file: when the object's macro has spawn points, one of them is used, and the spawn point names the macro of what appears there; otherwise a random position on the surface is chosen, and the macro comes from the rule, its own `macro` or one of its `<select>` entries. The rule's `drop`, or the selected entry's, replaces the droplist the spawned macro carries; without one the macro's own list is used.

In vanilla the two halves split cleanly. The station rules name a drop and nothing else, and every spawn point names the rare lockbox macro, `sm_gen_lockbox_rare_01_macro`: a hidden lockbox on a station is always the four-lock box, and the rule decides what is in it. The region rules that place crystals name their macros in a selection, and no field object has spawn points, so a crystal cluster is put on the asteroid's surface at a random spot.

Neither file says when an object goes through the rules. A station built after a change, or a new game, is the safe test.

[↑ Contents](#toc)

## The file: objectspawnrules.xml

### Layout

```xml
<objectspawnrules>
  <stations>
    <rule owner="xenon" hazardousregion="true" chance="100" drop="hidden_rare_lockbox"/>
    <rule stationtype="shipyard" chance="20" drop="hidden_common_lockbox"/>
    ...
    <rule chance="30" drop="hidden_common_lockbox"/>
  </stations>
  <regions>
    <rule fieldtype="asteroid" owner="xenon" hazardousregion="false" chance="30" maxsize="250">
      <select macro="env_ast_crystal_detail_s_01_macro" weight="160"/>
      <select macro="env_ast_crystal_detail_s_02_macro" weight="110" cooldown="60"/>
      ...
    </rule>
    ...
    <rule fieldtype="debris" chance="0.01" drop="hidden_common_lockbox"/>
  </regions>
</objectspawnrules>
```

Two lists, each optional, each of one or more rules: `<stations>` for stations, `<regions>` for the objects of a region's fields. The schema is `libraries/objectspawnrules.xsd`; it includes `common.xsd` for the faction and station type lookups.

[↑ Contents](#toc)

### A station rule, part by part

| Attribute | Meaning |
| --- | --- |
| `chance` | Required. If the rule applies, the chance in percent that an object is spawned; a float, so `0.5` is half a percent |
| `drop` | The droplist of the spawned object, in place of the one its macro carries; an id from `drops.xml` |
| `owner` | Applies to stations of this faction only |
| `stationtype` | Applies to stations of this type only: `defence`, `equipmentdock`, `factory`, `tradingstation`, `shipyard`, `headquarters`, `piratebase` or `yakistation`, the module set types of `common.xsd` |
| `hazardousregion` | `true`: stations inside a hazardous region only; `false`: stations outside one only |
| `sector` | Applies in this sector only; unused in vanilla |
| `<select>` | A weighted selection of what to spawn, see below |

A station rule has no `macro` attribute: what it spawns is the macro of the spawn point, or of a `<select>` entry.

[↑ Contents](#toc)

### A region rule, part by part

| Attribute | Meaning |
| --- | --- |
| `chance`, `drop`, `sector` | As for a station rule |
| `fieldtype` | `asteroid` or `debris`: the kind of field the object belongs to |
| `resource` | Applies to fields with this resource only: `ore`, `silicon`, `ice`, `nividium`, `hydrogen`, `helium` or `methane`; unused in vanilla |
| `minsize`, `maxsize` | Applies where the field's objects are at least, or at most, this large; vanilla splits at 250 |
| `owner` | Applies in sectors owned by this faction only |
| `hazardousregion` | As for a station rule, for the region the field belongs to |
| `region` | Applies to regions with this region definition only, a name from `region_definitions.xml`; unused in vanilla |
| `macro` | The macro of the spawned object, used when no spawn point names one |
| `<select>` | A weighted selection of what to spawn, see below |

[↑ Contents](#toc)

### Selection, weights and cooldowns

```xml
<rule fieldtype="asteroid" hazardousregion="true" chance="30" maxsize="250">
  <select macro="env_ast_crystal_detail_s_01_macro" weight="160"/>
  <select macro="env_ast_crystal_detail_s_02_macro" weight="110" cooldown="60"/>
  <select macro="env_ast_crystal_detail_s_03_macro" weight="50" cooldown="60"/>
  <select macro="env_ast_crystal_detail_s_04_macro" weight="30" cooldown="60"/>
  <select macro="env_ast_crystal_detail_s_05_macro" weight="1" cooldown="120"/>
</rule>
```

A `<select>` entry carries `macro`, `drop`, `weight` and `cooldown`; a selection overrides the `macro` and `drop` of the rule itself, and one entry of it is picked by weight. The cooldown is what keeps the valuable finds rare: an entry with a cooldown is valuable, and collecting one of these prevents new valuable spawns for that many minutes; entries without a cooldown are not valuable and are not held back. In the rule above the common cluster has no cooldown, three better ones share an hour, and the best one is held for two hours at a weight of 1 against 160.

The macros are the five crystal clusters, Bandannite, Menelaene, Aguilite, Mitonene and Burnite, each in a small and a medium size. What a cluster gives when it is shot is its own droplist, named in its macro, one of the `drops_crystal_*` lists of `drops.xml`; the rules give no `drop` for them.

[↑ Contents](#toc)

### Rule order and the vanilla rules

The station list, in order: a Xenon station in a hazardous region always gets a rare box, any other Xenon station an unusual one at half the chance; a pirate base an unusual one, more often in a hazardous region; any station in a hazardous region an unusual one; a shipyard or an equipment dock a common one; a trading station a common one, with one line per race and a general one behind them; and every other station a common one at the end. Order is what makes the list work: a Xenon station in a hazardous region never reaches the general hazardous line because the first rule takes it, and the race lines of the trading stations would be dead behind the general one. The file's own note says the definitions are an example of what could be done and not a fully thought-out design, which is worth knowing before reading intent into every line.

The region list places crystals first, by sector owner (Xenon or not), hazard and object size: objects up to 250 get the small clusters and objects of 250 and more the medium ones, at a chance between a tenth and two fifths. Behind the crystal rules sit eight lockbox lines for asteroid and debris fields at a chance of a percent down to a hundredth of a percent, by Xenon ownership and hazard. These name a drop and no macro, and no field object has spawn points, so the files do not say what object they would place. By the file's comment the first rule that applies takes the object, and every asteroid matches one of the crystal rules; whether a failed chance roll passes the object on to the next rule is not written anywhere.

[↑ Contents](#toc)

## The file: objectspawnpoints.xml

### Layout

```xml
<objectspawnpoints>
  <space macro="storage_tel_s_solid_01_macro">
    <spawnpoint id="1" macro="sm_gen_lockbox_rare_01_macro">
      <position x="-146.993" y="130.262" z="-95.204"/>
      <rotation yaw="41.25433" pitch="-24.94598"/>
    </spawnpoint>
    <spawnpoint id="2" macro="sm_gen_lockbox_rare_01_macro">
      <position x="0.9239" y="63.164" z="-33.831"/>
      <rotation yaw="1.69411" pitch="-1.21625"/>
    </spawnpoint>
  </space>
  ...
</objectspawnpoints>
```

One `<space>` per macro, one or more `<spawnpoint>` each, with ids unique within the space. The schema, `libraries/objectspawnpoints.xsd`, stands alone. Its wording calls the space a sector and the coordinates sector coordinates, with a `space` attribute for "another coordinate space (usually a station)"; vanilla's file names no sector at all. Every space is a station module macro, and the positions, a few hundred metres at most, are in the module's own space.

[↑ Contents](#toc)

### A spawn point, part by part

| Attribute or element | Meaning |
| --- | --- |
| `macro` on `<space>` | Required. The macro whose coordinate space the points use |
| `id` | Required. Unique within the space |
| `macro` on `<spawnpoint>` | Required. The macro of the object that appears here |
| `<position>` | Required. `x`, `y` and `z` in the space's coordinates, in metres |
| `<rotation>` or `<quaternion>` | Optional, one of the two: `yaw`, `pitch` and `roll` in degrees, or `qw`, `qx`, `qy` and `qz` |
| `space` | A macro path to another coordinate space to use instead; unused in vanilla |
| `respawn` | The minimum time after which the object may respawn, which only happens out of sector; unused in vanilla |
| `drop` | A droplist id to use instead of the macro's own; unused in vanilla, where the rule's `drop` does that job |
| `comment` | No in-game effect |

[↑ Contents](#toc)

### The vanilla points

The file lists the module macros of the base game's Argon, Paranid and Teladi sets and the generic production modules, nearly a hundred of them: storage, production, habitation, piers, struts, defence and build modules. Most have two points, a few three or four, a couple one. Every point names the rare lockbox macro; the rotation is given as yaw and pitch, with roll where needed, and one point has none. No point uses `space`, `respawn`, `drop`, `comment` or a `<quaternion>`.

[↑ Contents](#toc)

## Where the other lockboxes come from

Not every lockbox in space comes from these two files. A region definition can place lockboxes as objects of the region: a `<object groupref="lockboxes_extra"/>` field in `region_definitions.xml`, at a very low density, draws from a group of `regionobjectgroups.xml` that holds the big, common, explosive, fragile, rare, special, trap and unusual lockbox macros by weight; a box placed this way keeps its macro's own droplist. Scripts create lockboxes too: the generic missions for their crates, the game start, and `md/placedobjects.xml`, which spawns a lockbox of the sector's typical macro at the edge of a ship's radar range, with a chance built from the ship's crew skill and the sector's average distance to a lockbox.

[↑ Contents](#toc)

## How the expansions change it

No expansion ships either file. The station modules of the expansions, Split, Terran, Boron, Pirate and Timelines, have no spawn points, and the base station rules name no macro, so by the two files there is nothing for those rules to place on such a module. The regions of the Split expansion get lockboxes the way the base game's regions do, through the `lockboxes_extra` group in their region definitions.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `class.lockbox` | The class of a lockbox, for `find_object`, `count_gravidar_contacts` and `isclass` |
| `<lockbox>.rarity` | The rarity of a lockbox, an integer; the `rarity` attribute of a droplist is the only place the data sets one, 1 on `hidden_unusual_lockbox` and 2 on `hidden_rare_lockbox` |
| `<lockbox>.locks.operational.count`, `.list`, `.random` | The locks still to be shot |
| `<object>.drop` | The droplist id of an object, null when it has none |
| `<sector>.averagedistancetolockbox`, `<sector>.typicallockboxmacro` | The average distance to a lockbox from any point of the sector, -1m when none can be reached; the macro of a lockbox typically found there |
| `<object>.isinhazardousregion`, `<sector>.hashazardousregion`, `<sector>.hashazardousregionat.{$position}` | The hazard tests, the notion the rules' `hazardousregion` filters on |
| `create_lockbox` | Creates a lockbox from a lockbox macro, at a position or a safe position in a zone or sector |
| `event_player_opened_lockbox`, `event_object_opened_lockbox`, `event_lockbox_opened` | A lockbox was opened; `param` is the lockbox in the first two and the opener in the last |

No script reads a rule or a spawn point; scripts meet what the rules place. The found-lockbox interrupt makes a player-owned ship report a lockbox its gravidar has seen and asks the player what to do about it only from a rarity of 2 up, so a common hidden box does not interrupt. The notification script counts the boxes the player opens, rare and common apart.

[↑ Contents](#toc)

## Adding a rule and spawn points from an extension

The example below, for a fictional extension `example_spawns`, gives Teladi trading stations a chance of a luxury box ahead of vanilla's own line for them, gives the small asteroids of ice fields a crystal rule of their own, and gives the small Argon solid storage module, which has no points in vanilla, two spawn points.

`libraries/objectspawnrules.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/objectspawnrules/stations" pos="prepend">
    <rule stationtype="tradingstation" owner="teladi" chance="15" drop="hidden_luxury_lockbox"/>
  </add>
  <add sel="/objectspawnrules/regions" pos="prepend">
    <rule fieldtype="asteroid" resource="ice" hazardousregion="false" chance="5" maxsize="250">
      <select macro="env_ast_crystal_detail_s_01_macro" weight="100"/>
      <select macro="env_ast_crystal_detail_s_05_macro" weight="5" cooldown="120"/>
    </rule>
  </add>
</diff>
```

`libraries/objectspawnpoints.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/objectspawnpoints">
    <space macro="storage_arg_s_solid_01_macro">
      <spawnpoint id="1" macro="sm_gen_lockbox_rare_01_macro">
        <position x="-38.5" y="21.0" z="-57.0"/>
        <rotation yaw="90" pitch="0"/>
      </spawnpoint>
      <spawnpoint id="2" macro="sm_gen_lockbox_rare_01_macro" comment="below the walkway">
        <position x="14.0" y="-26.5" z="49.0"/>
        <rotation yaw="-135" pitch="12" roll="0"/>
      </spawnpoint>
    </space>
  </add>
</diff>
```

Some points about the example:

- **The station rule goes first.** `pos="prepend"` puts it above vanilla's rules, so a Teladi trading station meets it before vanilla's Teladi line; appended at the end it would sit behind the catch-all rule and never apply. By the file's comment the first rule that applies takes the station, so those stations no longer reach vanilla's line, and the new rule's chance is their whole chance of a box.
- **The luxury list** is vanilla's own, defined in `drops.xml` with a rarity of 2 and used by no rule. A list of the extension's own goes into `drops.xml` the way [drops.xml](/x4/modding-support/anatomy-of-game-data/libraries/drops-xml/) shows. The box itself stays the rare macro, the one the spawn points name.
- **The ice rule** names its own selection, so neither a `macro` on the rule nor a spawn point is needed, and it gives no `drop`, so each cluster keeps the droplist of its macro. Being first, it takes the small asteroids of ice fields outside hazardous regions away from vanilla's general rule, so it has to carry the whole selection those asteroids should get; with `hazardousregion="false"` the hazardous ice fields pass it by and keep vanilla's hazardous rules.
- **The spawn points** are in the module's own coordinate space, in metres from its origin, as vanilla's are; a point inside the geometry hides the box, a point outside leaves it floating beside the module. Where a surface of the model is lies in its geometry, not in any table, so the numbers come from looking at the module. Ids restart at 1 in every space.
- **When it shows** is not written in the files; a station built after the change, or a new game, is the safe test, and `find_object` with `class="class.lockbox"` in the sector lists what was placed.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[drops.xml](/x4/modding-support/anatomy-of-game-data/libraries/drops-xml/) holds the droplists a rule names and the ones the crystal clusters carry. [god.xml](/x4/modding-support/anatomy-of-game-data/libraries/god-xml/) places the stations and picks the module set a station is built from. [Resource areas](/x4/modding-support/resource-areas/) covers the regions and their fields.

[↑ Contents](#toc)
