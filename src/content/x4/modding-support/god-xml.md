---
title: god.xml
description: How libraries/god.xml places stations, factories and objects (and, in some Timelines scenarios, ships) - the entry format, quotas and locations, when the game generates from it, what an extension needs to add entries, and the script actions and properties that work with them.
order: 8
---

# god.xml

Almost every station in a new X4 universe is placed by one part of the game, the **god engine**. Shipyards, wharfs, trading stations, defence platforms, faction factories, and many landmarks and anomalies all come from entries in `libraries/god.xml`. Each entry says what to create, how many, and where. The god engine places the objects, the scripts then finish them, and a script can create more objects from the same entries later.

This article covers the format, what the game does with each part of an entry and when, and the script side. It describes version 9.00.

Adding a station or factory from an [extension](/x4/modding-support/anatomy-of-an-extension/) needs [The file](#the-file), [How many: quotas](#how-many-quotas), [Where: locations](#where-locations), [Adding entries from an extension](#adding-entries-from-an-extension) and the checklist in [Traps](#traps).

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Entry**: one element in `god.xml` that says what to create, how many and where.
- **Space**: the galaxy holds clusters, a cluster holds sectors, and a sector holds zones. An entry's `<location>` names one of these spaces by its macro, its id in the game data, such as `xu_ep2_universe_macro` for the galaxy.
- **Kinds of entry**: object, ship, station, product and plan entries. Product and plan entries both create factories and together are the **production entries**; see [Kinds of entry](#kinds-of-entry).
- **Construction plan**: a station layout, stored in `libraries/constructionplans.xml`. A plan can be divided into **stages** that are built one after another.
- **Dataset**: one complete set of entries. A game uses exactly one; see [Which dataset is used](#which-dataset-is-used).
- **God object**: anything created from an entry; a **god station** is a station created from one.
- **Scripts**: Mission Director (MD) scripts in `md/` run the game's stories and faction logic. Vanilla's scripts finish what the god engine places and can create more objects from the same entries; see [Scripting/MD/Libraries/Map](/x4/modding-support/scripting-md-libraries-map/).
- **Schema**: `libraries/libraries.xsd`, which lists the allowed elements and attributes with short descriptions. This article quotes it where it is the only description.
- **Extension and vanilla**: an extension is a folder under `extensions/` with a `content.xml`, which adds files to the game or patches its files. Vanilla is the base game and its DLCs; each DLC is an extension too.

Plan entries and staged construction plans are new in 9.00; in 8.00 `<products>` holds only `<product>` entries.

[↑ Contents](#toc)

## How generation works

On a new game, after the map is built, the god engine works through every entry once:

1. **Zone entries first, then sector, cluster and galaxy.** Entries are grouped by the class of their [location](#where-locations). Entries tied to a named zone are placed first and galaxy-wide entries last.
2. **Each entry creates up to its quota.** The quota sets a total for the galaxy and optional limits per cluster, sector and zone.
3. **Each object goes to a space that passes the entry's location filters**: owner, space tags, distance from the sector core, economy and security values, sunlight, regions.

The loading screen shows **station generation** while this runs. The scripts then finish what was placed. A product entry places only a production module, and vanilla's `md/finalisestations.xml` adds the habitation, dock, pier, defence and connection modules, then the loadout. A plan entry builds the construction plan it names, often only its first stages, and the owning faction builds the rest during play; see [Staged stations](#staged-stations). Last, `md/inituniverse.xml` sets up every god station like any other station, for example with its trade wares.

During play, generation runs again only when a save is loaded, and **only for extensions that are enabled now but not yet recorded in the save**; see [Loading a save](#loading-a-save). Apart from that, an entry is used only when a script asks for it.

[↑ Contents](#toc)

## The file

### Layout

The root holds one dataset, and any number of gamestart datasets can follow it:

```xml
<god>
  <objects> ... </objects>                   <!-- object entries -->
  <ships> ... </ships>                       <!-- ship entries -->
  <stations>
    <defaults> ... </defaults>
    <station id="..."> ... </station>        <!-- station entries -->
  </stations>
  <products>
    <product id="..."> ... </product>        <!-- product entries -->
    <station id="..."> ... </station>        <!-- plan entries -->
  </products>

  <gamestart ref="x4ep1_gamestart_tutorial1"> <!-- the same four sections --> </gamestart>
  <gamestart galaxy="timelines_map_mining_1_galaxy_macro"> ... </gamestart>
</god>
```

The file has no schema of its own: `god.xml` points at `libraries/libraries.xsd`, which defines it completely.

### Which dataset is used

Exactly one dataset is used per game:

1. a `<gamestart ref="...">` whose `ref` is the id of the current gamestart, the start chosen on New Game (its `<gamestart id>` in `libraries/gamestarts.xml`);
2. otherwise a `<gamestart galaxy="...">` whose `galaxy` is the macro of the current galaxy;
3. otherwise the root.

A matching gamestart dataset **replaces** the root dataset; the two are not merged. **An entry in the root dataset is therefore absent from the starts that have a dataset of their own.** To appear there too, it has to be added to that dataset as well. The schema puts the rule as "default god entries if no gamestart-specific god dataset found".

The base game has three gamestart datasets. `x4ep1_gamestart_tutorial1` holds a single shipyard. `x4ep1_gamestart_workshop` holds two stations. The Timelines mining galaxy dataset is empty, marked "Used to patch DLC stations", and the DLCs add their entries to it. The Timelines DLC adds 16 more, one per scenario such as `scenario_tharkas_cascade`, with `<add sel="/god">`.

A gamestart can also switch the god engine off, and then no dataset is used. `libraries/gamestarts.xml` does that with `<god enabled="false"/>` inside `<universe>` for the `tutorial_*` starts, `x4ep1_gamestart_tutorial2`, the test starts, `thevoid` and most Timelines scenarios. `x4ep1_gamestart_tutorial1` keeps it on and uses its own dataset.

### Kinds of entry

Every entry has the same shape: the outer element carries the id, owner and other attributes, `<quotas>` says how many, `<location>` and `<position>` say where, and an inner element says what to build.

| Entry | Section and element | Creates | Inner element: what to build |
| --- | --- | --- | --- |
| object entry | `<objects>`, `<object>` | an object such as a landmark, anomaly or derelict | `<object macro="...">` |
| ship entry | `<ships>`, `<ship>` | a ship | `<ship>`, with the same content as the `create_ship` script action |
| station entry | `<stations>`, `<station>` | a station: shipyard, wharf, trading station, defence platform, headquarters, pirate base | `<station>`: a `<select>` or `constructionplan`, plus `<loadout>` |
| product entry | `<products>`, `<product>` | a factory for one ware, started from its production module | `<module>` with a `<select ware="..." race="...">` |
| plan entry | `<products>`, `<station>` | a factory for one ware, built from a given construction plan, possibly in [stages](#staged-stations) | `<station constructionplan="...">`, with an optional `<stage>` |

Product and plan entries are the **production entries**; script properties and find filters use that name, such as `isgodproductionentry`. `<select>` and `<loadout>` are shown in the first example below; script actions and find filters are covered in [The script side](#the-script-side).

Ships in the universe come from [`libraries/jobs.xml`](/x4/modding-support/jobs-xml/), not from god.xml. Vanilla's only ship entries are 10 in the Timelines scenario datasets, most of them the player's ship for [`shipgodentry`](#player-starts-on-a-god-entry).

A vanilla station entry, with comments added. Its inner element is also named `<station>`:

```xml
<station id="tradestation_argon_01" race="argon" owner="argon" type="tradingstation">
  <!-- how many -->
  <quotas>
    <quota galaxy="1" zone="1" />
  </quotas>
  <!-- where -->
  <location class="sector" macro="cluster_06_sector002_macro" />
  <position x="-48800" y="0" z="27800" pitch="0" roll="0" />
  <!-- what to build -->
  <station>
    <select faction="argon" tags="[tradestation]" />
    <loadout>
      <level exact="0.75" />
    </loadout>
  </station>
</station>
```

In a station entry, `<select faction="argon" tags="[shipyard]"/>` picks a station from `libraries/stations.xml` whose `<category>` matches the faction and tags, and `constructionplan="..."` names a plan instead. `<loadout><level exact="0.75"/></loadout>` sets how fully the station is equipped. `<loadout useplanloadout="true"/>` takes the loadout stored in the construction plan instead of generating one; a few vanilla station entries use it, most of them in the Split DLC.

A vanilla product entry:

```xml
<product id="arg_energycells" ware="energycells" owner="argon" type="factory">
  <quotas>
    <quota galaxy="10" sector="6" />
  </quotas>
  <location class="galaxy" macro="xu_ep2_universe_macro" faction="[argon, hatikvah]" relation="self" comparison="ge">
    <economy max="0.6" maxbound="false" />
    <sunlight min="0.5" />
  </location>
  <module>
    <select ware="energycells" race="argon"/>
  </module>
</product>
```

`<select ware race>` picks the production module, and the finalise scripts build the rest of the station around it; see [How generation works](#how-generation-works). A plan entry is shown in [Staged stations](#staged-stations).

The inner `<object>` and `<ship>` also take `state`, the initial state of the object: `construction`, `operational` or `wreck`. Vanilla does not use it.

### Attributes

Every entry accepts:

- `id`, required and unique within its section; it is what scripts use to refer to the entry.
- `name` and `description`, which may be text references such as `{1001,2}`.
- `priority`, the spawn priority, default `50`.
- `startactive`, default `true`; generation skips an inactive entry, see [Entries that start inactive](#entries-that-start-inactive).
- `respawnable`: whether the object may be respawned. Vanilla's faction scripts respawn a destroyed station only when this is set, and only the Boron DLC sets it.

Each kind adds its own:

| Attribute | Station entries | Production entries | Object and ship entries |
| --- | --- | --- | --- |
| `owner` | required | required | optional, ownerless by default |
| `race` | required | | |
| `ware` | | required | |
| `type` | optional | optional | |
| `set` | optional | optional | |
| `encyclopedia` | optional | | |
| `friendgroup` | | optional | |

- `set` names a module set; when it is given, the module is chosen from that set instead of by `race` and `type`.
- `encyclopedia="true"` lists the station in the encyclopedia; the default is `false`. Vanilla sets it on a few entries, most of them for stories and gamestarts.
- `friendgroup`: production entries in the same group with the same owner count towards each other's quotas when they form a complex with matching productions. Only the Terran DLC uses it.

The elements every entry accepts are `<quota>` or `<quotas>`, `<location>`, an optional `<position>`, and an optional `<category tags="...">`, which scripts can read back as the entry's tags.

[↑ Contents](#toc)

## How many: quotas

A quota has these five attributes, plus `gamestart` on a `<quota>` inside `<quotas>`, described below:

- `galaxy`: the total for the whole galaxy. **Required in practice**: a quota without `galaxy` creates nothing.
- `cluster`, `sector`, `zone`: the most allowed in any one cluster, sector or zone. A level that is left out has no limit of its own.
- `force`: "force the object to spawn, ignoring any global defaults", in the schema's words. It ignores the entry's own quota as well. In a test, two station entries for one sector with `<quota galaxy="30" sector="30" zone="30"/>` and `newzonechance="0"` were generated: the plain one created 30 stations, at most 3 per zone as the [station defaults](#station-defaults) allow; the one with `force="true"` created 293, up to 26 in one zone, until the log reported no suitable position left in the sector. Vanilla does not use it.

Each level is capped by the one above it. `cluster` is at most `galaxy`, `sector` is at most the smaller of the two, and `zone` likewise, so `<quota galaxy="1" zone="3"/>` still creates one object. A quota where every level comes out as zero disables the entry. `<quota galaxy="2" sector="1"/>` creates two objects, at most one per sector.

### One quota or one per gamestart

An entry has a single `<quota>`, a `<quotas>` list, or both:

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

The default quota applies where the god engine chooses the zone: each zone then gets at most 3 stations of a station entry, even when the entry's own quota allows more per zone. It does not limit an entry's total: a station entry without a `sector` value can place more than 30 stations in one sector, and one tied to a single zone more than 3 in that zone.

### Scaling by gamestart

A gamestart in `gamestarts.xml` can scale quotas:

```xml
<universe>
  <god>
    <quotas>
      <quota faction="..." tag="..." factor="..." />
    </quotas>
  </god>
</universe>
```

A factor of 0 disables the matching entries. Custom gamestarts have a matching property, `universegodquotafactors`, which no vanilla gamestart uses.

[↑ Contents](#toc)

## Where: locations

`<location>` names the space an entry may use, a zone, a sector, a cluster or the whole galaxy, and filters the places inside it. Common vanilla locations:

- anywhere in Argon-owned space: `<location class="galaxy" macro="xu_ep2_universe_macro" faction="argon" relation="self" comparison="ge"/>`;
- anywhere in unowned space: the same with `faction="[ownerless]"`;
- one sector: `<location class="sector" macro="cluster_06_sector002_macro"/>`;
- one exact spot: a sector location plus a [`<position>`](#a-fixed-position).

The attributes:

- `class`: `zone`, `sector`, `cluster` or `galaxy`, default `galaxy`. Together with `macro` it names the space. Vanilla's galaxy-wide entries use the main galaxy, `xu_ep2_universe_macro`.
- `faction`, `relation`, `comparison` (`ge`, `gt`, `le`, `lt`): a relation filter against `faction`, described in the schema only as a relation range; vanilla's forms are in the list above.
- `tags`, `excludedtags`: space tags; all of `tags` are required and any of `excludedtags` rules the space out.
- `solitary`: place the object in a zone of its own.
- `excluderinghighway`: keep away from ring highways.
- `newzonechance` (0 to 1): the chance to create a new zone instead of using an existing one. Not meaningful with a zone macro: the game logs an error and ignores the value.
- `coreboundaryzoneheight`: the vertical range, in metres, for new zones near the sector core boundary.
- `matchextension`: see [the next section](#matchextension).

Child elements narrow the choice further. Each may appear more than once:

- `<corerange min max>`: distance from the sector core, which is defined by gates and highways. 0 to 1 is inside the core; values above 1 place the object outside it by that factor.
- `<economy min max maxbound>`, `<security min max maxbound>`: the space's value, from 0 to 1. A space's tags and its economy, security and sunlight values are set on its `<area>` in `libraries/mapdefaults.xml`.
- `<sunlight min max maxbound>`: the space's sunlight, from 0 to 20 in the schema; vanilla's filters use values from 0.4 to 7.
- `<region>`: rules about regions.
  - `ware` and `matchall` select regions by their wares.
  - `min` and `max` set a distance from such a region.
  - `hazardous` and `gravidar` place the object at a damaging or gravidar-limiting position.
  - `allowhazardous` and `allowgravidar` allow placement inside such a region without asking for it.

With `maxbound="false"` on `<economy>`, `<security>` or `<sunlight>`, a space whose value lies above `max` still qualifies, as if its value were `max`; with the default `maxbound="true"` it is ruled out.

### `matchextension`

**By default an entry only uses spaces from its own extension.** Base-game entries use base-game spaces, and an extension's entries use the spaces that extension adds; the rule dates from version 3.0. An extension that places objects in vanilla space, or in a DLC's space, has to set `matchextension="false"` on the location. The DLCs set it on entries placed in space they do not add themselves, such as the Split DLC's shipyard for the first tutorial.

The same holds for an entry that an extension replaces as a whole: the new entry belongs to the extension, even when it is an exact copy of the vanilla one. A replacement aimed at vanilla space needs `matchextension="false"` on its `<location>`, or the log reports `no sectors in galaxy found` and the entry creates nothing. See [Adding entries from an extension](#adding-entries-from-an-extension).

### A fixed position

`<position x y z pitch yaw roll>` puts the object at an exact spot:

- It works only with `class="zone"` or `class="sector"`; with any other class the game logs an error.
- The quota has to come out at one object; a position with a larger quota is an error.
- Location filters next to a position may contradict it, and the game logs an error about the possible conflict.
- `pitch`, `yaw` and `roll` are in degrees. A station or other object gets a random angle where one is left out; ships ignore all three.
- `safepos`, default `true`: "position the object with a safe position", in the schema's words. Vanilla sets `safepos="false"` on many entries, in the base game and in Timelines. A position with `safepos` on that lies in a hazardous region logs a message suggesting either `safepos="false"` or `allowhazardous` on the location's `<region>`, and placement is attempted anyway.
- `<distance exact|min|max>` inside `<position>` sets a distance from the coordinates, which the schema says requires `safepos`. Vanilla does not use it.

[↑ Contents](#toc)

## Staged stations

A construction plan can be divided into stages. An entry with such a plan builds the station up to a chosen stage, and the owning faction adds the remaining stages during play. Vanilla builds its prefab factories this way, from plan entries with ids such as `arg_advancedcomposites_prefab_04_01`.

### Stages in a construction plan

In `libraries/constructionplans.xml`, `bookmark="1"` on an `<entry>` closes a stage with that module. Stage 1 runs from the first entry to the first bookmark, stage 2 up to the next one, and the entries after the last bookmark form the final stage. Vanilla's `arg_advancedcomposites_prefab_04` has 55 entries with bookmarks on entries 15, 23 and 37, which makes four stages:

```xml
<entry index="15" macro="pier_arg_harbor_03_macro" connection="connectionsnap003" bookmark="1">
```

**A staged plan needs its own habitation, docks and defence**, as vanilla's prefab plans have, because nothing is added to it: vanilla's finaliser, the library cue `NewStation_GenerateFactory` in `md/finalisestations.xml` that both of its callers there run, leaves a station with a staged plan as it is. No schema describes `bookmark`; vanilla's plans are the reference.

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

Every vanilla plan entry has a `<stage>`, mostly a range such as `min="1" max="3"`. The schema allows it in station entries as well, which vanilla does not use.

**A stage past the plan's last one gives an empty station.** The station is created operational, with no modules and only a generic name such as `BOR Factory`, and nothing is logged. So `exact` and `max` have to stay within the plan's stage count. Of vanilla's 101 ranges, 69 end at the plan's last stage, 31 before it, and one after it: the Boron DLC's `bor_hullparts_prefab_08_01` asks for `min="4" max="8"` on the seven-stage `bor_hullparts_prefab_08`, so a station from it can come out empty.

### Fixed plans

A `<plan>` in `constructionplans.xml` can carry `fixed="1"`. **A staged station with a fixed plan grows only stage by stage**, through the faction's regular expansion; without `fixed="1"`, the faction can also extend it for a ware it needs. See the next section. Every plan that a vanilla plan entry names is fixed, and so are the plans of the Kha'ak scrap processors in vanilla's station entries.

No schema describes `fixed` on a plan. On a construction sequence, the property `isfixed` is true when the sequence "is flagged as fixed and cannot be adjusted", and the find actions take `hasfixedconstruction`, which matches a station whose current or planned sequence is flagged as fixed. A station built from a plan with `fixed="1"` has such a sequence.

### Expansion during play

The owning faction builds the remaining stages during play, one stage at a time and hours apart. Vanilla's faction scripts do it in two ways:

- **`ExpandPrefabs`** in `md/factionlogic.xml` expands one station per faction at a time. It picks a random station of the faction that has a further stage, has no build in progress, has not been attacked for 30 minutes, and is in a sector that no enemy of the faction contests. It adds a build for the next stage with `add_build_to_expand_station` and waits 6 to 7 hours before the next expansion, or 2 to 3 hours when no station qualified. The candidates come from the faction's station reports in `md/factionlogic_economy.xml`: a station with a further stage is a candidate unless it reports insufficient resources, workforce or build wares, or overflowing products.
- **A demand for a ware**: when a faction wants more production of a ware in a sector, `md/factionlogic_economy.xml` looks for one of its stations there to extend, leaving out stations with a [fixed plan](#fixed-plans). Among the rest, a staged station whose next stage contains a production module for that ware is favoured, and that stage is built. The loop that looks through the next stage stops one entry short of the stage's last entry, in both the scoring and the build, so a production module placed last in its stage, or alone in it, is never seen there; in a test, a plan whose final stage was the single energy cell module was never matched until the loop was patched. When no station is extended, the faction builds a new one. It uses the plan from `get_god_production_construction_plan` with `<stage exact="1"/>` when it has no staged station producing the ware in that sector and a plan is found; otherwise it builds an ordinary factory.

So the stations of a staged entry keep growing after generation, and the faction can also place new ones from the same entry's plan. Since vanilla's prefab plans are all fixed, its staged stations grow through `ExpandPrefabs` only.

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

The entries of the chosen dataset are generated as described in [How generation works](#how-generation-works). The `save` attribute of an extension's `content.xml` plays no part here: in a test, the same extension generated the same factories on two new games, once with `save="false"` and once with `save="true"`. The attribute matters only on a load.

### Loading a save

On every load the game compares the extensions enabled now with the extensions recorded in the save. **Only the entries supplied by extensions that are new to the save are generated**; when there are none, nothing is generated. A save records only the extensions with `save="true"` in their `content.xml` (see [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/#attributes-on-the-root-element)), and only those count here. This has a few consequences:

- **Adding an extension with `save="true"` to a running game works.** Its entries are generated on the first load with the extension enabled, the same way a DLC's stations appear when the DLC is added to an existing game. They are finished the same way as at game start. Vanilla's `God_DefaultFinaliseFactory`, which handles only objects with `isgamestartgodentry`, runs for the new factories and logs `Universe generation is complete` at that load. In a test, the 48 factories an extension generated this way all had `isgamestartgodentry` true, were operational with their workforce and sell offers once the load finished, and the stations that already existed were buying the extension's new wares at once.
- **An extension with `save="false"` generates nothing on a load**, not even on the first one; its entries reach new games only.
- **Base-game entries are not generated again**, and neither are those of extensions the save already knows. The exception is an entry that an extension replaces as a whole, see [Adding entries from an extension](#adding-entries-from-an-extension).
- **An entry added in an update of an extension is not generated** in saves that already contain the extension. A changed quota or location does not add or move objects there either; existing saves need a script for that, see [Updating an extension](#updating-an-extension). The quota checks of vanilla's economy scripts during play read the current file; see [Production quotas during play](#production-quotas-during-play).

### Entries that start inactive

`startactive="false"` gives an entry an inactive starting state. **Generation skips an inactive entry**: nothing is created from it, on a new game or on a load. Creating an object from the entry with one of the `create_god_*` actions marks the entry active. Vanilla marks an entry inactive when only a script is meant to create its objects. The base game's `tel_*_new` and `par_*_new` production entries exist for saves made before 7.00 and sit next to active entries for the same wares: a cue in `md/setup.xml` creates them with `create_god_factory` when it patches such a save. The Timelines and Boron DLCs keep further inactive entries for their own scripts. There is no script action that switches an entry's active state.

### Player starts on a god entry

A gamestart's player `<location>` can name a god entry with `stationgodentry` or `shipgodentry`, and the player then starts at the station, or on the ship, created from that entry. A Pirate DLC gamestart and several Timelines scenarios use it. When the entry is invalid or its object is not found, the game logs a message and tries a random station or ship.

[↑ Contents](#toc)

## Adding entries from an extension

An extension patches `god.xml` with a diff file at the same path inside the extension, `extensions/<extension folder>/libraries/god.xml`, as all five DLCs do. The extension itself is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/), the patch syntax in [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

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

- **Ids are unique per section, and the first entry wins.** When two entries share an id, the one that comes first in the patched file is used and the log reports the other one as invalid. A prefix of the extension's own, such as `example_`, keeps new ids apart from vanilla's and other extensions'. When an extension's entry reuses a vanilla id:
  - An entry added with a plain `<add>` lands after the vanilla one and is rejected.
  - One added with `pos="prepend"` comes first and takes the id over: the vanilla entry is dropped, and the new one belongs to the extension, the same as a whole-entry `replace` below.
  - To change a vanilla entry, an extension patches that entry's attributes or child elements in place, or replaces it as a whole.
- **Swapping one entry for another** is a `replace` of the whole entry. The Split, Terran and Boron DLCs each replace the shipyard of the first tutorial with their own, and the selector lists every id an earlier DLC may have left there: `<replace sel="/god/gamestart[@ref='x4ep1_gamestart_tutorial1']/stations/station[@id='shipyard_argon_01' or @id='shipyard_split_01']">` in the Terran DLC.
- **A replaced entry belongs to the extension that replaced it.** Its location needs `matchextension="false"` to keep using vanilla space, even in an exact copy of the vanilla entry, as the DLCs' tutorial shipyards have. And a save the extension is new to generates the entry again with its full quota, on top of the objects the save already has from it: a quota of 2 in a save with one such station gives three. A patch of an attribute or a child element, such as `<replace sel="/god/products/product[@id='tel_engineparts']/quotas/quota/@galaxy">8</replace>` or a `replace` of the entry's whole `<location>`, leaves the entry the base game's: it keeps using vanilla space without `matchextension="false"`, and a load generates nothing from it.
- **A second production entry for an owner and ware that already have one** can break both on a new game. Raising the existing entry's quota adds more of the same factories without a second entry. The details:
  - When the two entries' spaces share sectors and their `faction` values are not written identically, no factory is built from either: the existing entry stops at its first failure and the new one creates nothing. Even the same factions listed in another order count as different.
  - The log shows `FactoryGenerator: No Station generated ...` and `station was not created for zone ...` for the existing entry, nothing for the new one.
  - Generation works when the new entry copies the existing entry's `<location>` attributes as they are, adding only `matchextension="false"`; when the two spaces share no sector; or with another owner.
  - A load that generates the new entry is not affected.
- **Changes reach new games.** With `save="true"` they also reach saves the extension is new to. A save that already contains the extension keeps what was generated at its start.
- **Gamestart datasets are separate.** An entry meant for the tutorial, the workshop or the Timelines mining galaxy goes into that dataset's section, as the DLCs do with `<add sel="/god/gamestart[@galaxy='timelines_map_mining_1_galaxy_macro']/stations">`.

### Updating an extension

Version 1.10 of `example_tradeposts` adds a Paranid trading post, `example_tradepost_paranid`, to its diff. New games and saves without the extension get it from generation. Saves made with 1.00 do not, so the update adds an MD script in the extension's `md/` folder (see [Scripting/MD/Libraries/Map](/x4/modding-support/scripting-md-libraries-map/)) that creates the station once, modelled on vanilla's own 9.00 patch cue `Patch900Stations_SV` in `extensions/ego_dlc_split/md/setup_dlc_split.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="ExampleTradePosts" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="AddParanidTradePost" namespace="this">
      <conditions>
        <!-- once per game: on a new game, or on the first load with this script -->
        <event_cue_signalled cue="md.Setup.Start" />
        <!-- only in the main galaxy -->
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

The `find_station_by_true_owner` check skips the creation when the station already exists, for example in a game where generation created it. `create_god_station` without `state` creates the station operational, so vanilla's `InitGodCreatedStation` initialises it one frame later: the station gets its trade wares, NPCs and AI, and the starting stock of a gamestart station. The example's own `'init station'` signal, copied from vanilla's patch, repeats that init; a station does not need it, a factory does. See [Creating from an entry](#creating-from-an-entry).

Both examples in this article were tested in game on version 9.00.

[↑ Contents](#toc)

## The script side

### Creating from an entry

`create_god_station`, `create_god_factory`, `create_god_ship` and `create_god_object` create one object from the entry with the given `id`. They take `name` or `groupname` for the result and an optional `state`; without it, the schema says, the god entry's default is used. An unknown id logs `Invalid god station entry ID: '...'` (and the same for the other kinds), and the action returns nothing.

Vanilla finishes what these actions create as follows:

- **`'init station'`**: `InitGodCreatedStation` in `md/inituniverse.xml` signals it to `player.galaxy` on `event_god_created_station` when the new station is operational, with the station as `param2` and `param3` true. The handler, `InitStation` in the same file, skips player-owned and non-operational stations and adds trade wares, the station's NPCs and its AI; with `param3` true it also adds a starting workforce, fills the production wares and adds ammunition. That holds for a station created by a script too: `create_god_station` without `state` creates it operational, and in a test a station created from an MD script got the signal with `param3` true one frame later, and with it the starting stock. The Timelines DLC's cues send the signal themselves, with `param3="false"`, only for the factories they create. Vanilla's save patch `Patch900Stations_SV` sends it for a station too, as the example above does, which repeats the init.
- **Factories**: `NewStation_GenerateFactory_God_Runtime` in `md/finalisestations.xml` runs on `event_god_created_factory` for every factory that was not created by generation and, through the same `NewStation_GenerateFactory` library, adds its modules and loadout the same way as at game start, except for a station with a [staged plan](#staged-stations). It does not send `'init station'`, which is why the save patches send it for factories too.

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
- **The debug log** carries the errors about entries; the `God` debug filter (`-debug God`) adds detail about generation. See [The debug log](/x4/modding-support/running-x4-for-modding/#the-debug-log).
- **`logs\god\`**: vanilla's finalise scripts write one file per station there when the game runs with `-scriptlogfiles`.

The messages most likely to come up while writing entries:

| Log message | Meaning |
| --- | --- |
| `GodDB::Import(): File '...' is an invalid god XML file` | A file that is not a diff has a root element other than `<god>`. |
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
| `Invalid god station entry ID: '...'` | A `create_god_station` names no station entry; the same message exists for the other kinds, and the action returns nothing. |

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
- **A product entry only places a production module**; the rest of the station comes from vanilla's finalise scripts. An extension that changes how stations are finished changes god factories too.
- **A staged plan gets no modules added.** Vanilla's finaliser, `NewStation_GenerateFactory`, leaves it as it is, so the plan needs its own habitation, docks and defence.
- **A staged station keeps growing.** The owning faction builds its next stages during play, so what generation creates is only its starting size.
- **A `<stage>` past the plan's last stage builds an empty station**, and nothing is logged.

[↑ Contents](#toc)
