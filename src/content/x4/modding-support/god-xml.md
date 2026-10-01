---
title: god.xml
description: How libraries/god.xml places stations, factories, ships and objects - the entry format, quotas and locations, when the game generates from it, what an extension needs to add entries, and the script actions and properties that work with them.
order: 8
---

# god.xml

Almost every station in a new X4 universe is placed by one part of the game, which the gamestart schema calls the **god engine**. Shipyards, wharfs, trading stations, defence platforms, faction factories, and many landmarks and anomalies all come from entries in `libraries/god.xml`. Each entry says what to create, how many, and where. The god engine places the objects, the scripts then finish them, and a script can create more objects from the same entries later.

This page covers the format, what the game does with each part of an entry and when, and the script side. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## How generation works

On a new game, after the map is built, the god engine works through every entry once:

1. **Zone entries first, then sector, cluster and galaxy.** Entries are grouped by the class of their location. Entries tied to a named zone are placed first and galaxy-wide entries last.
2. **Each entry creates up to its quota.** The quota sets a total for the galaxy and optional limits per cluster, sector and zone.
3. **Each object goes to a space that passes the entry's location filters**: owner, space tags, distance from the sector core, economy and security values, sunlight, regions.

The loading screen shows **station generation** while this runs. Next, the scripts take over. A `<product>` entry places only its production module, and vanilla's `md/finalisestations.xml` turns it into a working station. It adds habitation, docks, piers, defence and connection modules, then the loadout. A `<station>` entry under `<products>` builds a fixed construction plan instead, often only its first stages, and the owning faction adds the rest during play; see [Staged stations](#staged-stations). After that, `md/inituniverse.xml` gives each god station the same setup as other stations, such as its trade wares.

Generation does not run again during play. On a save load it runs once more, but **only for extensions that are enabled now and not yet recorded in the save**, as described in [Loading a save](#loading-a-save). Outside of these two cases, an entry is used only when a script asks for it.

A gamestart can switch the god engine off. `libraries/gamestarts.xml` does that with `<god enabled="false"/>` inside `<universe>` for the `tutorial_*` starts, `x4ep1_gamestart_tutorial2`, the test starts, `thevoid` and most Timelines scenarios. `x4ep1_gamestart_tutorial1` keeps it on and has a dataset of its own.

[↑ Contents](#toc)

## The file

### Layout

The file has no schema of its own: `god.xml` points at `libraries/libraries.xsd`, which defines it completely. The root holds one dataset, and any number of gamestart datasets can follow it:

```xml
<god>
  <objects> ... </objects>
  <ships> ... </ships>
  <stations>
    <defaults> ... </defaults>
    <station id="..."> ... </station>
  </stations>
  <products>
    <product id="..."> ... </product>
    <station id="..."> ... </station>
  </products>

  <gamestart ref="x4ep1_gamestart_tutorial1"> <!-- the same four sections --> </gamestart>
  <gamestart galaxy="timelines_map_mining_1_galaxy_macro"> ... </gamestart>
</god>
```

### Which dataset is used

Exactly one dataset is used per game:

1. a `<gamestart ref="...">` whose `ref` is the id of the current gamestart;
2. otherwise a `<gamestart galaxy="...">` whose `galaxy` is the macro of the current galaxy;
3. otherwise the root.

A matching gamestart dataset **replaces** the root dataset; the two are not merged. The schema puts it as "default god entries if no gamestart-specific god dataset found". The base game has three gamestart datasets. `x4ep1_gamestart_tutorial1` holds a single shipyard. `x4ep1_gamestart_workshop` holds two stations. The Timelines mining galaxy dataset is empty, marked "Used to patch DLC stations", and the DLCs add their entries to it. The Timelines DLC adds 16 more, one per scenario such as `scenario_tharkas_cascade`, with `<add sel="/god">`.

An entry added to `/god/stations` is therefore absent from those starts. To appear there too, it has to be added to the gamestart dataset as well.

### Kinds of entry

| Section | Entry | Creates | What to build |
| --- | --- | --- | --- |
| `<objects>` | `<object>` | an object such as a landmark, anomaly or derelict | `<object macro="...">` |
| `<ships>` | `<ship>` | a ship | `<ship>`, with the same content as the `create_ship` script action |
| `<stations>` | `<station>` | a station: shipyard, wharf, trading station, defence platform, headquarters, pirate base | `<station>`: a `<select>` or `constructionplan`, plus `<loadout>` |
| `<products>` | `<product>` | a factory for one ware, started from its production module | `<module>` with a `<select ware="..." race="...">` |
| `<products>` | `<station>` | a factory for one ware, built from a given construction plan, possibly in [stages](#staged-stations) | `<station constructionplan="...">`, with an optional `<stage>` |

The `<station>` kind under `<products>` is new in 9.00; in 8.00 `<products>` holds only `<product>` entries.

In a station entry, `<select faction="argon" tags="[shipyard]"/>` picks a station from `libraries/stations.xml` whose `<category>` matches the faction and tags, and `constructionplan="..."` names a plan instead. `<loadout><level exact="0.75"/></loadout>` sets how fully the station is equipped. `<loadout useplanloadout="true"/>` takes the loadout stored in the construction plan instead of generating one; 16 vanilla station entries use it, 14 of them in the Split DLC.

The inner `<object>` and `<ship>` also take `state`, the initial state of the object: `construction`, `operational` or `wreck`. Vanilla does not use it.

A vanilla station entry:

```xml
<station id="tradestation_argon_01" race="argon" owner="argon" type="tradingstation">
  <quotas>
    <quota galaxy="1" zone="1" />
  </quotas>
  <location class="sector" macro="cluster_06_sector002_macro" />
  <position x="-48800" y="0" z="27800" pitch="0" roll="0" />
  <station>
    <select faction="argon" tags="[tradestation]" />
    <loadout>
      <level exact="0.75" />
    </loadout>
  </station>
</station>
```

### Attributes

Every entry accepts:

- `id`, required and unique within its section; it is what scripts use to refer to the entry.
- `name` and `description`, which may be text references such as `{1001,2}`.
- `priority`, the spawn priority, default `50`.
- `startactive`, default `true`; generation skips an inactive entry, see [Entries that start inactive](#entries-that-start-inactive).
- `respawnable`: whether the object may be respawned. Vanilla's faction scripts respawn a destroyed station only when this is set, and only the Boron DLC sets it.

Station entries add `owner` and `race`, both required, `type`, `set` and `encyclopedia`. `encyclopedia="true"` lists the station in the encyclopedia; the default is `false`, and vanilla sets it on seven entries, most of them for stories and gamestarts. Production entries (`<product>`, and `<station>` under `<products>`) add `ware` and `owner`, both required, `type`, `set` and `friendgroup`. `set` names a module set and overrides `race` and `type` for choosing one. Production entries in the same `friendgroup` with the same owner count towards each other's quotas when they form a complex with matching productions; only the Terran DLC uses it. Objects and ships take an optional `owner`, ownerless by default.

The elements every entry accepts are `<quota>` or `<quotas>`, `<location>`, an optional `<position>`, and an optional `<category tags="...">`, which scripts can read back as the entry's tags.

[↑ Contents](#toc)

## How many: quotas

A quota has five attributes:

- `galaxy`: the total for the whole galaxy. **Required in practice**: a quota without `galaxy` creates nothing.
- `cluster`, `sector`, `zone`: the most allowed in any one cluster, sector or zone. A level that is left out has no limit of its own.
- `force`: "force the object to spawn, ignoring any global defaults", in the schema's words.

Each level is capped by the one above it. `cluster` is at most `galaxy`, `sector` is at most the smaller of the two, and `zone` likewise, so `<quota galaxy="1" zone="3"/>` still creates one object. A quota where every level comes out as zero disables the entry. `<quota galaxy="2" sector="1"/>` creates two objects, at most one per sector.

### One quota or one per gamestart

An entry has either a single `<quota>` or a `<quotas>` list:

```xml
<quotas>
  <quota galaxy="1" zone="1" gamestart="x4ep1_gamestart_trade" />
  <quota galaxy="3" />
</quotas>
```

The quota that applies is chosen in this order:

1. a direct `<quota>` child, if there is one;
2. the `<quota>` in `<quotas>` whose `gamestart` is the current gamestart;
3. the `<quota>` in `<quotas>` without a `gamestart`.

**When none of them applies, the entry is disabled, and nothing is logged.** An entry whose quotas all name gamestarts creates nothing in any other start. Vanilla uses this for player-owned entries such as `x4ep1_gamestart_trade_playerfactory`. An entry with neither `<quota>` nor `<quotas>`, or with an empty `<quotas>`, is disabled with an error in the log.

### Station defaults

`<stations><defaults>` holds the station defaults, including a quota. Vanilla's are 3 per zone and 30 per sector:

```xml
<defaults>
  <location newzonechance="0.25" coreboundaryzoneheight="40000">
    <corerange max="1.3"/>
    <region allowhazardous="false" allowgravidar="true"/>
  </location>
  <modules production="5" storage="10" />
  <quota zone="3" sector="30" />
</defaults>
```

`<modules>` limits how many modules of each kind a generated station gets: `production`, `build`, `storage`, `habitation`, `defence`, `comm`, `dock`, `pier`, `other`, `venture`, `welfare`, `processing` and `radar`. A kind left out defaults to 20, according to the schema. The `<location>` values are the defaults for entries that do not set their own.

### Scaling by gamestart

A gamestart can scale quotas with `<universe><god><quotas><quota faction="..." tag="..." factor="..."/></quotas></god>` in `gamestarts.xml`. A factor of 0 disables the matching entries. Custom gamestarts have a matching property, `universegodquotafactors`, which no vanilla gamestart uses.

[↑ Contents](#toc)

## Where: locations

`<location>` names the space an entry may use and filters the places inside it:

- `class`: `zone`, `sector`, `cluster` or `galaxy`, default `galaxy`. Together with `macro` it names the space. Vanilla's galaxy-wide entries use the main galaxy, `xu_ep2_universe_macro`.
- `faction`, `relation`, `comparison` (`ge`, `gt`, `le`, `lt`): a relation filter against `faction`, described in the schema only as a relation range. Vanilla keeps an entry in Argon space with `faction="argon" relation="self" comparison="ge"`, and in unowned space with `faction="[ownerless]"`.
- `tags`, `excludedtags`: space tags; all of `tags` are required and any of `excludedtags` rules the space out.
- `solitary`: place the object in a zone of its own.
- `excluderinghighway`: keep away from ring highways.
- `newzonechance` (0 to 1): the chance to create a new zone instead of using an existing one. Not meaningful with a zone macro: the game logs an error and ignores the value.
- `coreboundaryzoneheight`: the vertical range, in metres, for new zones near the sector core boundary.
- `matchextension`: see [the next section](#matchextension).

Child elements narrow the choice further. Each may appear more than once:

- `<corerange min max>`: distance from the sector core, which is defined by gates and highways. 0 to 1 is inside the core; values above 1 place the object outside it by that factor.
- `<economy min max maxbound>`, `<security min max maxbound>`: the space's value, from 0 to 1.
- `<sunlight min max maxbound>`: the space's sunlight, from 0 to 20 in the schema; vanilla's filters use values from 0.4 to 7.
- `<region>`: rules about regions. `ware` and `matchall` select regions by their wares, `min` and `max` set a distance from such a region, `hazardous` and `gravidar` place the object at a damaging or gravidar-limiting position, and `allowhazardous` and `allowgravidar` allow placement inside such a region without asking for it.

With `maxbound="false"` on `<economy>`, `<security>` or `<sunlight>`, a higher value is treated as `max` instead of ruling the space out.

### `matchextension`

**By default an entry only uses spaces from its own extension.** Base-game entries use base-game spaces, and an extension's entries use the spaces that extension adds; the rule dates from version 3.0. An extension that places objects in vanilla space, or in a DLC's space, has to set `matchextension="false"` on the location. The DLCs set it on entries placed in space they do not add themselves, such as the Split DLC's shipyard for the first tutorial.

The same holds for an entry that an extension replaces as a whole: the new entry belongs to the extension, even when it is an exact copy of the vanilla one. A replacement aimed at vanilla space needs `matchextension="false"` on its `<location>`, or the log reports `no sectors in galaxy found` and the entry creates nothing. See [Adding entries from an extension](#adding-entries-from-an-extension).

### A fixed position

`<position x y z pitch yaw roll>` puts the object at an exact spot:

- It works only with `class="zone"` or `class="sector"`; with any other class the game logs an error.
- The quota has to come out at one object; a position with a larger quota is an error.
- Location filters next to a position may contradict it, and the game logs an error about the possible conflict.
- `pitch`, `yaw` and `roll` are in degrees. A station or other object gets a random angle where one is left out; ships ignore all three.
- `safepos`, default `true`: "position the object with a safe position", in the schema's words. Vanilla sets `safepos="false"` on 41 base-game entries and 15 Timelines entries. A position with `safepos` on that lies in a hazardous region logs a message suggesting either `safepos="false"` or `allowhazardous` on the location's `<region>`, and placement is attempted anyway.
- `<distance exact|min|max>` inside `<position>` sets a distance from the coordinates, which the schema says requires `safepos`. Vanilla does not use it.

[↑ Contents](#toc)

## Staged stations

A construction plan can be divided into stages; staged construction plans are new in 9.00. A god entry with such a plan builds the station up to a chosen stage, and the owning faction adds the remaining stages during play. Vanilla builds its prefab factories this way: the `<station>` entries under `<products>` that name a `constructionplan`.

### Stages in a construction plan

In `libraries/constructionplans.xml`, `bookmark="1"` on an `<entry>` closes a stage with that module. Stage 1 runs from the first entry to the first bookmark, stage 2 up to the next one, and the entries after the last bookmark form the final stage. Vanilla's `arg_advancedcomposites_prefab_04` has 55 entries with bookmarks on entries 15, 23 and 37, which makes four stages:

```xml
<entry index="15" macro="pier_arg_harbor_03_macro" connection="connectionsnap003" bookmark="1">
```

No schema describes `bookmark`; vanilla's plans are the reference. A staged plan carries its own habitation, docks and defence, as vanilla's prefab plans do: vanilla's runtime finaliser, `NewStation_GenerateFactory` in `md/finalisestations.xml`, leaves a station with a staged plan as it is.

### The `<stage>` element

Inside the entry's `<station>` element, `<stage>` sets the stage the station is built to, as an `exact` value or a `min` to `max` range:

```xml
<station id="arg_advancedcomposites_prefab_04_01" ware="advancedcomposites" owner="argon" type="factory" priority="55">
  <quotas>
    <quota galaxy="2"/>
  </quotas>
  <location class="galaxy" macro="xu_ep2_universe_macro" faction="[argon, hatikvah]" relation="self" comparison="ge">
    <economy min="0.50" max="0.75" maxbound="false" />
  </location>
  <station constructionplan="arg_advancedcomposites_prefab_04">
    <stage min="1" max="4"/>
    <loadout>
      <level exact="0.7"/>
    </loadout>
  </station>
</station>
```

Each of the two stations from this entry starts with one to four of the plan's four stages, picked for each station separately. The schema describes `<stage>` as "the construction sequence stage index to initially expand this station to (defaults to 0)". In the script actions that take the same element, stage 0 stands for the whole sequence.

Vanilla uses `<stage>` in 101 entries (base game 70, Split 12, Terran 6, Boron 13), all of them `<station constructionplan>` entries under `<products>`, mostly with ranges such as `min="1" max="3"`. The schema allows it in `<stations>` entries as well, which vanilla does not use.

**A stage past the plan's last one gives an empty station.** The station is created operational, with no modules and only a generic name such as `BOR Factory`, and nothing is logged. So `exact` and `max` have to stay within the plan's stage count. Of vanilla's 101 ranges, 69 end at the plan's last stage, 31 before it, and one after it: the Boron DLC's `bor_hullparts_prefab_08_01` asks for `min="4" max="8"` on the seven-stage `bor_hullparts_prefab_08`, so a station from it can come out empty.

### Fixed plans

A `<plan>` in `constructionplans.xml` can carry `fixed="1"`. No schema describes it on a plan. On a construction sequence, the property `isfixed` is true when the sequence "is flagged as fixed and cannot be adjusted", and the find actions take `hasfixedconstruction`, which matches a station whose current or planned sequence is flagged as fixed. A station built from a plan with `fixed="1"` has such a sequence.

Vanilla flags 78 plans (base game 44, Boron 14, Split 13, Terran 7). Every plan named by a `<station>` entry under `<products>` is among them; the other five are the Kha'ak scrap processors of `<stations>` entries. The faction economy leaves fixed stations out when it looks for a station to extend for a ware it needs; see the next section.

### Expansion during play

Vanilla's faction scripts build the remaining stages:

- **`ExpandPrefabs`** in `md/factionlogic.xml` expands one station per faction at a time. It picks a random station of the faction that has a further stage, has no build in progress, has not been attacked for 30 minutes, and is in a sector that no enemy of the faction contests. It adds a build for the next stage with `add_build_to_expand_station` and waits 6 to 7 hours before the next expansion, or 2 to 3 hours when no station qualified. The candidates come from the faction's station reports in `md/factionlogic_economy.xml`: a station with a further stage is a candidate unless it reports insufficient resources, workforce or build wares, or overflowing products.
- **A demand for a ware**: when a faction wants more production of a ware in a sector, `md/factionlogic_economy.xml` looks for one of its stations there to extend, leaving out stations with a [fixed plan](#fixed-plans). Among the rest, a staged station whose next stage contains a production module for that ware is favoured, and that stage is built. When no station is extended, the faction builds a new one: from the plan of `get_god_production_construction_plan` with `<stage exact="1"/>` when it has no staged station producing the ware in that sector and a plan is found, and as an ordinary factory otherwise.

So the stations of a staged entry keep growing after generation, and the faction can also place new ones from the same entry's plan. Since vanilla's prefab plans are all fixed, its staged stations grow through `ExpandPrefabs`; a staged plan without `fixed="1"` can also be extended for a ware demand.

### Checking stages from a script

| Property | Result |
| --- | --- |
| `hasstagedconstruction` | the current or planned construction sequence has stages; also a filter of the find actions |
| `hasfutureconstructionstage` | the sequence has stages that are not built yet |
| `plannedconstruction.sequence` | the planned sequence, or the current one when no build is queued |
| `.stage.count`, `.stage.current` | on a sequence: the number of stages, and the stage it is set to build to |
| `.stage.{$n}.first`, `.stage.{$n}.last` | on a sequence: the indices of the first and last module of stage `$n` |
| `.finalsequence` | on a sequence: a copy of the full staged sequence |

On a staged station, `constructionsequence` covers only the stages already built, and the plan's stages are read from `plannedconstruction.sequence`: a station built to stage 4 of a seven-stage plan has a `constructionsequence.stage.count` of 4 and a `plannedconstruction.sequence.stage.count` of 7.

[↑ Contents](#toc)

## When entries are used

### New game

The entries of the chosen dataset are generated as described in [How generation works](#how-generation-works).

### Loading a save

On every load the game compares the extensions enabled now with the extensions recorded in the save. **Only the entries supplied by extensions that are new to the save are generated**; when there are none, nothing is generated. A save records only the extensions with `save="true"` in their `content.xml` (see [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/#attributes-on-the-root-element)), and only those count here. This has a few consequences:

- **Adding an extension with `save="true"` to a running game works.** Its entries are generated on the first load with the extension enabled, the same way a DLC's stations appear when the DLC is added to an existing game. They are finished as at game start: vanilla's `God_DefaultFinaliseFactory`, which handles only objects with `isgamestartgodentry`, runs for the new factories and logs `Universe generation is complete` at that load.
- **An extension with `save="false"` generates nothing on a load**, not even on the first one; its entries reach new games only.
- **Base-game entries are not generated again**, and neither are those of extensions the save already knows. The exception is an entry that an extension replaces as a whole, see [Adding entries from an extension](#adding-entries-from-an-extension).
- **An entry added in an update of an extension is not generated** in saves that already contain the extension. A changed quota or location does not add or move objects there either; existing saves need a script for that, see [Updating an extension](#updating-an-extension). The quota checks of vanilla's economy scripts during play read the current file; see [Production quotas during play](#production-quotas-during-play).

### Entries that start inactive

`startactive="false"` gives an entry an inactive starting state. **Generation skips an inactive entry**: nothing is created from it, on a new game or on a load. Creating an object from the entry with one of the `create_god_*` actions marks the entry active. Vanilla marks an entry inactive when only a script is meant to create its objects. The base game's `tel_*_new` and `par_*_new` production entries exist for saves made before 7.00 and sit next to active entries for the same wares: a cue in `md/setup.xml` creates them with `create_god_factory` when it patches such a save. The Timelines and Boron DLCs keep further inactive entries for their own scripts. There is no script action that switches an entry's active state.

### Player starts on a god entry

A gamestart's player `<location>` can name a god entry with `stationgodentry` or `shipgodentry`, and the player then starts at the station, or on the ship, created from that entry. A Pirate DLC gamestart and several Timelines scenarios use it. When the entry is invalid or its object is not found, the game logs a message and tries a random station or ship.

[↑ Contents](#toc)

## Adding entries from an extension

An extension patches `god.xml` with a diff file at the same path, `libraries/god.xml`, as all five DLCs do. The patch syntax is covered in [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

A complete example: an extension named `example_tradeposts` that adds one Argon trading station anywhere in Argon space.

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/god/stations">
    <station id="example_tradepost_argon" race="argon" owner="argon" type="tradingstation">
      <quotas>
        <quota galaxy="1" />
      </quotas>
      <location class="galaxy" macro="xu_ep2_universe_macro" faction="argon" relation="self" comparison="ge" matchextension="false" />
      <station>
        <select faction="argon" tags="[tradestation]" />
        <loadout>
          <level exact="1.0" />
        </loadout>
      </station>
    </station>
  </add>
</diff>
```

Without `matchextension="false"` this entry would look for Argon space added by `example_tradeposts` itself, find none, and create nothing; the log would report `no sectors in galaxy found`. For the station to appear in running games as well, the extension's `content.xml` needs `save="true"`; see [Loading a save](#loading-a-save).

Points to keep in mind:

- **Ids are unique per section, and the first entry wins.** When two entries share an id, the one that comes first in the patched file is used and the log reports the other one as invalid. An entry added with a plain `<add>` lands after the vanilla one and is rejected. One added with `pos="prepend"` comes first and takes the id over: the vanilla entry is dropped, and the new one belongs to the extension, the same as a whole-entry `replace` below. An extension that wants to change a vanilla entry patches that entry's attributes or child elements in place, or replaces it as a whole.
- **Swapping one entry for another** is a `replace` of the whole entry. The Split, Terran and Boron DLCs each replace the shipyard of the first tutorial with their own, and the selector lists every id an earlier DLC may have left there: `<replace sel="/god/gamestart[@ref='x4ep1_gamestart_tutorial1']/stations/station[@id='shipyard_argon_01' or @id='shipyard_split_01']">` in the Terran DLC.
- **A replaced entry belongs to the extension that replaced it.** Its location needs `matchextension="false"` to keep using vanilla space, even in an exact copy of the vanilla entry, as the DLCs' tutorial shipyards have. And a save the extension is new to generates the entry again with its full quota, on top of the objects the save already has from it: a quota of 2 in a save with one such station gives three. A patch of an attribute or a child element, such as `<replace sel="/god/products/product[@id='tel_engineparts']/quotas/quota/@galaxy">8</replace>` or a `replace` of the entry's whole `<location>`, leaves the entry the base game's: it keeps using vanilla space without `matchextension="false"`, and a load generates nothing from it.
- **A second production entry for an owner and ware that already have one** can break both on a new game. When the two entries' spaces share sectors and their `faction` values are not written identically, no factory is built from either: the existing entry stops at its first failure and the new one creates nothing. Even the same factions listed in another order count as different. The log shows `FactoryGenerator: No Station generated ...` and `station was not created for zone ...` for the existing entry, nothing for the new one. Generation works when the new entry copies the existing entry's `<location>` attributes as they are, adding only `matchextension="false"`; when the two spaces share no sector; or with another owner. Raising the existing entry's quota adds more of the same factories without a second entry. A load that generates the new entry is not affected.
- **Changes reach new games, and saves the extension is new to** when it has `save="true"`. A save that already contains the extension keeps what was generated at its start.
- **Gamestart datasets are separate.** An entry meant for the tutorial, the workshop or the Timelines mining galaxy goes into that dataset's section, as the DLCs do with `<add sel="/god/gamestart[@galaxy='timelines_map_mining_1_galaxy_macro']/stations">`.

### Updating an extension

Version 1.10 of `example_tradeposts` adds a Paranid trading post, `example_tradepost_paranid`, to its diff. New games and saves without the extension get it from generation. Saves made with 1.00 do not, so the update adds a script that creates the station once, modelled on vanilla's own 9.00 patch cue `Patch900Stations_SV` in `extensions/ego_dlc_split/md/setup_dlc_split.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="ExampleTradePosts" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="AddParanidTradePost" namespace="this">
      <conditions>
        <event_cue_signalled cue="md.Setup.Start" />
        <check_value value="player.galaxy.macro == macro.xu_ep2_universe_macro" />
      </conditions>
      <delay exact="5s" />
      <actions>
        <find_station_by_true_owner name="$Existing" faction="faction.paranid" godstationentry="'example_tradepost_paranid'" space="player.galaxy" checkoperational="false" />
        <do_if value="not $Existing">
          <create_god_station groupname="$Created" id="'example_tradepost_paranid'" />
          <do_for_each name="$Station" in="$Created">
            <signal_objects object="player.galaxy" param="'init station'" param2="$Station" param3="false" />
          </do_for_each>
        </do_if>
      </actions>
    </cue>
  </cues>
</mdscript>
```

The `find_station_by_true_owner` check skips the creation when the station already exists, for example in a game where generation created it. The `'init station'` signal with `param3="false"` gives the station its trade wares, NPCs and AI without the starting stock of a gamestart station, as vanilla's patch does; see [Creating from an entry](#creating-from-an-entry).

Both examples on this page were tested in game on version 9.00.

[↑ Contents](#toc)

## The script side

### Creating from an entry

`create_god_station`, `create_god_factory`, `create_god_ship` and `create_god_object` create one object from the entry with the given `id`. They take `name` or `groupname` for the result and an optional `state`, which defaults to the entry's own. An unknown id logs `Invalid god station entry ID: '...'` (and the same for the other kinds), and the action returns nothing.

Vanilla finishes what these actions create as follows:

- **`'init station'`**: vanilla's save patches signal it to `player.galaxy` for every station and factory they create, with the object as `param2` and `param3="false"`, as in the example above. `InitGodCreatedStation` in `md/inituniverse.xml` sends the same signal, with `param3` true, on `event_god_created_station` when the new station is operational. The handler, `InitStation` in the same file, skips player-owned and non-operational stations and adds trade wares, the station's NPCs and its AI. `param3` marks a gamestart station: only then does it also add a starting workforce, fill the production wares and add ammunition.
- **Factories**: `NewStation_GenerateFactory_God_Runtime` in `md/finalisestations.xml` runs on `event_god_created_factory` for every factory that is not from the gamestart and adds its modules and loadout the same way as at game start, except for a station with a [staged plan](#staged-stations). It does not send `'init station'`, which is why the save patches send it for factories too.

### Events

`event_god_created_station`, `event_god_created_factory`, `event_god_created_ship` and `event_god_created_object` fire for every object the god engine creates. `event.object` is the space it was created in, and `event.param` is the new object. For a factory, `event.param2` is the list of module macros and `event.param3` the base construction sequence.

### Properties

| Property | Result |
| --- | --- |
| `isgodobject` | created by the god engine |
| `isgodobjectentry`, `isgodshipentry`, `isgodstationentry`, `isgodproductionentry` | created from that kind of entry |
| `isgamestartgodentry` | created by generation, on a new game or on a load |
| `isrespawnablegodobject` | from an entry with `respawnable="true"` |
| `godentry` | the entry id |
| `godentryname` | the entry name |
| `godentrytags`, `hasgodentrytag.{$tag}` | the tags of the entry's `<category>` |
| `generationseed` | the seed defined by the object's source, such as the god engine, for use as `seed` in random evaluators; null if none |

On a space, `.god` tells whether god entries may use it.

### Finding objects by entry

`find_station` and `find_station_by_true_owner` take `godstationentry` and `godproductionentry`, `find_ship` takes `godshipentry`, and `find_object` takes `godobjectentry` and `godentrytags`. Vanilla's respawn logic in `md/factionlogic_stations.xml` uses `godstationentry` to check whether a respawnable station still exists before it calls `create_god_station`.

### Construction plans

`get_god_production_construction_plan` (faction, product, space) and `get_god_station_construction_plan` (faction, type, space) look up construction plans from the production and station entries. Vanilla's economy scripts use the first to start a new staged factory where the faction has no staged station for the ware in the sector; see [Expansion during play](#expansion-during-play).

### Allowing or blocking a space

`set_space_god_allowed space="..." allow="false"` stops god entries from using a space, and `reset_space_god_allowed` returns it to normal. A setting on a space overrides the one on its parent spaces.

### Production quotas during play

The quotas also matter after generation. Vanilla's economy scripts call `check_production_allowed` before building new production; its comment says it applies the module compatibilities from `modules.xml` and the quotas from `god.xml`. A production module in `modules.xml` can set `respectquota`, described as "respect the god.xml quota definitions for this ware for the station's owner and location (defaults to true)"; in vanilla only the Pirate DLC sets it.

[↑ Contents](#toc)

## Checking the result

- **`-godlog`** writes `godlog.xml` into the personal folder when a generation pass creates something: on a new game, or on a load that generates the entries of a new extension. The file holds only that pass's objects, one `<station>`, `<factory>` or `<object>` row each with `id`, `macro`, `seed`, `sector` and the position `x`, `y`, `z`; ships and stages are not listed. A load that generates nothing leaves the file as it is, so a `godlog.xml` may be left from an earlier session. See [Logging and diagnostics](/x4/modding-support/running-x4-for-modding/#logging-and-diagnostics).
- **The debug log** carries the errors about entries; the `god` filter adds detail about generation. See [The debug log](/x4/modding-support/running-x4-for-modding/#the-debug-log).
- **`logs\god\`**: vanilla's finalise scripts write one file per station there when the game runs with `-scriptlogfiles`.

The messages most likely to come up while writing entries:

| Log message | Meaning |
| --- | --- |
| `GodDB::Import(): File '...' is an invalid god XML file` | The file's root element is not `<god>`. |
| `[GODDB] Error: God Entry : '...' is invalid because neither <quota> or <quotas> is defined.` | The entry has no quota. |
| `[GODDB] Error: God Entry ID: '...' is invalid because <quotas> is empty.` | `<quotas>` has no `<quota>`. |
| `[GODDB] Error: God Entry : '...' has a position defined but not a zone nor sector.` | `<position>` with a cluster or galaxy location. |
| `[GODDB] Error: God Entry : '...' has a position defined but has multiple objects defined in its quota.` | A fixed position with a quota above one. |
| `[GODDB] Error: God Entry ID: '...' has a fixed position but also location evaluators which may conflict.` | A position plus location filters. |
| `[GODDB] Error: God Entry : '...' has a 'newzonechance' of ... while also having a specified zone.` | `newzonechance` on a zone entry; the value is ignored. |
| `[GodObjectDB] Error: GodEntryID: '...' is invalid because the ID is not unique - an entry with that ID already exists.` | Duplicate id; the entry that comes later in the patched file is invalid. Station and object entries use this prefix, ship and production entries `[GodShipDB]` and `[GodProductionDB]`. |
| `... God Entry ID: '...' - Zone ... with fixed position ... is selected for placement but does not fully suit the location criteria` | The fixed position lies in a zone that does not pass all of the location filters. |
| `... God Entry ID: '...' has a fixed map position flagged for safepos that places it in a hazardous region. ...` | A `safepos` position inside a hazardous region; the message suggests `safepos="false"` or `allowhazardous`. |
| `[God Engine] God Entry ID: '...' no sectors in galaxy found, error in map?` | No sector matched the location's space at all. Most often an entry, or a whole-entry replacement, tied by the default `matchextension` to space its extension does not add. |
| `[GodEngine] God Entry ID: '...' could not find sector '...'.` | The location's `macro` names no such sector; the same message exists for zones and clusters. |
| `[GodProductionEntry] Error: GodEntryID: '...' is unable to find suitable locations for ... remaining productions.` | No space passed the location filters for the rest of the quota. Station entries log the same text with the `[GodStationEntry]` prefix. |
| `... FactoryGenerator: No Station generated using group/ref/macro null and Ware ...` | No factory could be built for the ware named. One cause is a second production entry for the same owner and ware; see [Adding entries from an extension](#adding-entries-from-an-extension). |
| `[GodProductionEntry] God Entry ID: '...' station was not created for zone ...` | Follows the line above; the entry named creates nothing more. |
| `... is unable to resolve a valid macro.` | The `<select>`, plan or module selection found nothing. |
| `GodStationEntry() station id '...' in god.xml does not specify a valid owner, skipping!` | Bad `owner`; similar messages exist for `race` on stations, `owner` and `ware` on production entries, and `owner` on ships. |
| `Unable to instance god station from entry ID: '...'.` | Creating an object from the entry failed; the same message exists for factories, ships and objects. |
| `No matching god production entry for ware '...' (faction '...' in space '...').` | A lookup by ware, faction and space found no production entry. |

[↑ Contents](#toc)

## Traps

- **A quota without `galaxy` creates nothing.**
- **A gamestart-only quota disables the entry everywhere else**, also without a message.
- **`matchextension` defaults to `true`.** An extension entry aimed at vanilla space needs `matchextension="false"`, or it finds no space.
- **A gamestart dataset replaces the root dataset.** Entries added to `/god/stations` do not appear in the tutorial, the workshop or the Timelines mining galaxy.
- **Updates to an extension are not generated in saves that already contain it.** New entries, and changed quotas or locations, create objects only in new games and in saves the extension is new to; anything else needs a script.
- **An extension with `save="false"` adds nothing to a running game.** Its entries are generated on new games only.
- **A whole-entry `replace` makes the entry the extension's.** It needs `matchextension="false"` to keep using vanilla space, and a save the extension is new to gets the entry's full quota again, on top of the objects it already has. Patching attributes or child elements avoids both.
- **A duplicate id is an error, and the first entry wins.** An entry appended under a vanilla id is rejected and the vanilla one stays. One added with `pos="prepend"` takes the id over and becomes the extension's entry.
- **A second production entry for the same owner and ware** in space shared with the existing one stops both from building factories on a new game, unless the new `<location>` copies the existing one's attributes, adding only `matchextension="false"`. A `faction` list in another order already counts as different.
- **A `<product>` entry only places a production module**; the rest of the station comes from vanilla's finalise scripts. An extension that changes how stations are finished changes god factories too.
- **A staged plan gets no modules added.** Vanilla's runtime finaliser leaves it as it is, so the plan needs its own habitation, docks and defence.
- **A staged station keeps growing.** The owning faction builds its next stages during play, so what generation creates is only its starting size.
- **A `<stage>` past the plan's last stage builds an empty station**, and nothing is logged.

[↑ Contents](#toc)
