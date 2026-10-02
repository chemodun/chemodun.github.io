---
title: jobs.xml
description: How libraries/jobs.xml keeps the universe's NPC ships in place - the job format, quotas and locations, how the job engine populates, replaces and retires job ships, what an extension needs to add jobs, and the script actions, events and properties that work with them.
order: 9
---

# jobs.xml

Most NPC ships in X4 belong to a **job**. Traders, miners, patrols, police, carriers with their escorts, construction vessels, Xenon and Kha'ak raiders and the mass traffic around stations are all defined in `libraries/jobs.xml`. Each job says what ship to create, which orders it gets, how many of them the universe should have, and where. A part of the game called the **job engine** keeps the active jobs near their quota for the whole game: it creates the ships at the start, replaces lost ones and retires ships when a job is above its maximum.

This article covers the format, what the game does with each part of a job and when, and the script side. It describes version 9.00.

Adding a job from an extension needs [A job, part by part](#a-job-part-by-part), [How many: quotas](#how-many-quotas), [Where: locations](#where-locations), [How ships appear](#how-ships-appear), [Adding jobs from an extension](#adding-jobs-from-an-extension) and the checklist in [Traps](#traps). Changing a vanilla job is covered in [Changing a vanilla job](#changing-a-vanilla-job), and how changes reach running games in [Loading a save](#loading-a-save). The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Job**: one `<job>` element: what ship to create, which orders it gets, how many and where.
- **Job ship**: a ship created from a job. The job engine counts it towards that job's quota.
- **Space**: the galaxy holds clusters, a cluster holds sectors, and a sector holds zones. A job's `<location>` names one of these by its macro, its id in the game data, such as `xu_ep2_universe_macro` for the galaxy.
- **Quota**: how many ships a job should have, in the galaxy and at most per cluster, sector or zone; see [How many: quotas](#how-many-quotas).
- **Active and inactive**: only an active job gets ships from the job engine. An inactive one waits until a script activates it; see [Inactive jobs](#inactive-jobs).
- **Waiting ship**: a complete ship with its job, loadout and crew that is not yet in the universe; a shipyard builds it. A **requested ship** is a waiting ship that a script asks a job for, regardless of the job's quota.
- **Commander and subordinates**: a job ship can lead ships of other jobs, such as a frigate with its fighter escort. Those other jobs are **subordinate jobs**; see [Subordinates](#subordinates).
- **Orders**: the AI scripts in `aiscripts/` that a ship runs, such as `Patrol` in `order.fight.patrol.xml`. A job sets the ship's **default order**, which the game shows as its Default Behaviour.
- **Faction logic**: vanilla's Mission Director (MD) scripts in `md/` that run each faction's economy and military. They request job ships and have waiting ships built.
- **Extension and vanilla**: an extension is a folder under `extensions/` with a `content.xml`, which adds files to the game or patches its files. Vanilla is the base game and its DLCs; each DLC is an extension, so what this article says about an extension's jobs holds for a DLC's jobs too.

[↑ Contents](#toc)

## How the job engine works

The job engine works on one job at a time. When an active job comes up, the engine counts the job's ships, in the universe and waiting, compares the count with the job's quota and acts on the difference:

1. **Missing ships are created** in spaces that pass the job's [location](#where-locations) filters. The engine decides on all of them in that one pass and, in a running game, creates up to 10 every 5 seconds. By default each one is created directly in space. A job with `buildatshipyard="true"` gets its first ships in space too, but after that each missing ship becomes a **waiting** ship that the owning faction's scripts order from a shipyard; it enters the universe when the build is finished. See [How ships appear](#how-ships-appear).
2. **Ships above the `maxgalaxy` quota are retired.** A job with more ships than its `maxgalaxy` quota sends some of its old ships away; see [Retiring ships](#retiring-ships).

**Each job comes up in turn.** Every 5 seconds of game time the engine processes the next job of a fixed rotation over all jobs without `<time>`, together with every job with [`<time>`](#timing-and-expiry) that is due. Inactive and [mass traffic](#mass-traffic) jobs take their turn in the rotation too, so with all DLCs more than 900 of the 1189 jobs share it, and a job without `<time>` comes up about once every 75 to 80 minutes of game time. [Subordinate jobs](#subordinates) are not in the rotation; their ships come with their commander.

On a new game every active job without `<time>` is populated right at the start, which is why the universe is full of ships from the first minute; a job with `<time>` gets its ships at its first scheduled pass. A job with `rebuild="false"` is populated only at the start, and not refilled later; see [Modifiers](#modifiers). Loading a save processes the jobs once more; see [Loading a save](#loading-a-save).

The ships of a job are ordinary ships. Each one runs the orders the job defines, usually a single default order such as `TradeRoutine`, `MiningRoutine` or `Patrol`. Commanders get their subordinates from other jobs, defined in the commander's `<subordinates>`.

Scripts can also **request** a job ship for a purpose. Vanilla's faction economy asks for extra miners, traders and tugs where a ware is short, NPC shipyards, wharfs and equipment docks ask for their own traders, and stations for their own miners. A requested ship is created as a waiting ship regardless of the job's quota and state, and counts towards the quota from then on, so a job can exceed its quota this way.

A gamestart can switch the job engine off with `<jobs enabled="false"/>` inside `<universe>` in `libraries/gamestarts.xml`. Vanilla does that for all `tutorial_*` starts, `x4ep1_gamestart_tutorial1` and `x4ep1_gamestart_tutorial2`, `x4ep1_gamestart_workshop`, the test starts `test_weapon_debugger`, `test_spacesuit_mazes` and `test_platform_npc_walk`, and `thevoid`, and the Timelines DLC does it for all 40 of its starts, the scenarios and the hub, in its own `libraries/gamestarts.xml`. `<masstraffic enabled="false"/>` in the same place switches off mass traffic only.

[↑ Contents](#toc)

## The file

### Layout

The vanilla file sits in the game's catalogs; the [X Catalog Tool](/x4/modding-support/x-catalog-tool/) unpacks it. The root `<jobs>` holds one dataset of `<job>` elements, and any number of gamestart datasets can follow it:

```xml
<jobs>
  <job id="..."> ... </job>
  <job id="..."> ... </job>

  <gamestart ref="some_gamestart_id"> <job id="..."> ... </job> </gamestart>
  <gamestart galaxy="some_galaxy_macro"> ... </gamestart>
</jobs>
```

**Vanilla has no gamestart datasets in any jobs.xml**: every job of the base game and the DLCs sits in the root dataset. Where gamestart datasets exist, the game reads one dataset only: the first `<gamestart ref="...">` whose `ref` matches the current gamestart, failing that a `<gamestart galaxy="...">` that matches the current galaxy macro, and failing both the root dataset; the schema calls the root "default job entries if no gamestart-specific job dataset found". The file has no schema of its own: `jobs.xml` points at `libraries/libraries.xsd`, which defines it completely.

The base game defines 604 jobs. The DLCs add their own: the Split DLC 227, the Terran DLC 171, the Boron DLC 120, the Pirate DLC 39 and the Timelines DLC 28.

### A job, part by part

A job says what ship to create (`<ship>`), what it does (`<orders>`), how many (`<quota>`) and where (`<location>`). Without a quota, or without a `<ship>` or `<masstraffic>`, the log reports the job as invalid. A typical job, a frigate patrol of the base game with fighters as its escort:

```xml
<job id="argon_frigate_patrol_m_sector_exp" name="{20204,2901}" friendgroup="argon_defence">
  <!-- faction scripts may not take these ships away from the job -->
  <modifiers commandeerable="false"/>
  <!-- what each ship does -->
  <orders>
    <order order="Patrol" default="true">
      <param name="range" value="class.sector"/>
    </order>
  </orders>
  <!-- how scripts find the job -->
  <category faction="argon" tags="[military, frigate, fleetphase_1]" size="ship_m"/>
  <!-- how many: 35 in the galaxy, at most 1 per sector -->
  <quota galaxy="35" maxgalaxy="90" sector="1"/>
  <!-- where: Argon space -->
  <location class="galaxy" macro="xu_ep2_universe_macro" faction="argon" relation="self" comparison="exact"/>
  <!-- lost ships are built at a shipyard -->
  <environment buildatshipyard="true"/>
  <!-- which ship, how well equipped, which owner -->
  <ship>
    <select faction="argon" tags="[military, frigate]" size="ship_m"/>
    <loadout>
      <quantity exact="1.0"/>
      <quality exact="0.99">
        <variation exact="0.6"/>
      </quality>
    </loadout>
    <owner exact="argon" overridenpc="true"/>
  </ship>
  <!-- its escort, from another job -->
  <subordinates>
    <subordinate job="argon_fighter_escort_s_frigate"/>
  </subordinates>
</job>
```

The child elements can come in any order, except that `<ship>` and then `<subordinates>`, or `<masstraffic>` alone, come after every other child:

| Element | What it sets | Details |
| --- | --- | --- |
| `<ship>` | the ship to create, with the same content as the `create_ship` script action | [The ship](#the-ship) |
| `<subordinates>` | jobs whose ships serve this job's ships as subordinates | [Subordinates](#subordinates) |
| `<masstraffic>` | a mass traffic ship instead of a real one | [Mass traffic](#mass-traffic) |
| `<orders>`, `<order>` | the orders of a new ship | [Orders](#orders) |
| `<quota>`, `<quotas>` | how many ships, and where at most | [How many: quotas](#how-many-quotas) |
| `<location>` | which spaces the ships work in | [Where: locations](#where-locations) |
| `<environment>` | how ships enter the universe | [How ships appear](#how-ships-appear) |
| `<modifiers>` | `commandeerable`, `rebuild`, `subordinate`, `invincible` | [Modifiers](#modifiers) |
| `<category>` | faction, tags and size by which scripts find the job | [Category tags](#category-tags) |
| `<basket>` | the default ware basket for trading and mining | [Category tags](#category-tags) |
| `<time>` | a schedule of its own instead of the rotation | [Timing and expiry](#timing-and-expiry) |
| `<expirationtime>` | when a ship is retired | [Timing and expiry](#timing-and-expiry) |
| `<encounters>` | a player encounter type | [Events](#events) |
| `<task>`, `<tasks>` | the AI task of a mass traffic ship | [Mass traffic](#mass-traffic) |
| `<commander>` | an object macro the ships are based at; unused in vanilla | [Where: locations](#where-locations) |
| `<position>` | a place in the zone, used with `zone="true"`; unused in vanilla | [How ships appear](#how-ships-appear) |

### Attributes

| Attribute | Meaning |
| --- | --- |
| `id` | Unique id; scripts and saves refer to the job by it. |
| `name` | Job name, a `{page,id}` reference to a text in the game's text files; vanilla uses page 20204, "Jobs", such as `{20204,2901}`. Scripts read it as `jobname`. It is also part of the ship's displayed name, ahead of the ship type and variation. |
| `startactive` | `false` makes the job start inactive; see [Inactive jobs](#inactive-jobs). Defaults to `true`. |
| `disabled` | `true` skips the job completely, "as if commented out". Vanilla disables seven jobs this way. |
| `friendgroup` | A job counts the ships of the inactive jobs of its friend group as its own; see [Friend groups](#friend-groups). |
| `activefriendsaffectquotas` | Whether ships of active jobs of the friend group count towards this job's quota. Defaults to `false`. Unused in vanilla. |
| `fullname` | Whether the ship's name may include its ship type and variation. Defaults to `true`. Unused in vanilla. |
| `ignorecommanderwares` | Skips the check that the job's basket wares match the production wares of the station given by `<commander>`. Defaults to `false`. Unused in vanilla. |
| `description`, `comment` | Free text. |

[↑ Contents](#toc)

## The ship

### Ship definition

`<ship>` holds the same content as the `create_ship` script action. A `<select>` with `faction`, `tags` and `size` picks a ship macro from `libraries/ships.xml`, and `<loadout>` sets how fully the ship is equipped. `<owner exact="..." overridenpc="true"/>` sets the owner; `overridenpc="true"` gives the crew the same owner, which every vanilla job does. A `macro`, `ref` or `group` attribute on `<ship>` itself can pick the macro instead, as for [mass traffic](#mass-traffic); no vanilla `<ship>` job does that. A `<cargo>`, `<units>` with drones and a `<pilot>` can follow.

The `<wares>` under `<cargo>` are skipped when the job engine re-creates a ship, so a replacement starts without them. `<wares ... onjobrespawn="true"/>` processes them every time; the schema puts it as "By default cargo nodes are skipped for ships that are RE-spawned by the Job Engine".

### Orders

`<orders>` lists the orders a new ship gets, each `<order order="..." default="true">` with `<param name="..." value="..."/>` children. Each order is an AI script in `aiscripts/` that declares the order's id and parameters, such as `order.fight.patrol.xml` for `Patrol`. Every vanilla `<ship>` job gives exactly one order, as the default order; mass traffic jobs have a `<task>` instead. A single `<order>` outside `<orders>` also works, as in the Boron DLC's `argon_construction_m_boron`; when both exist, `<orders>` wins. The most used orders are `TradeRoutine`, `Patrol`, `MiningRoutine`, `Escort`, `Middleman` and `DeployStaticDefenseStrategy`.

### Subordinates

A commander job lists its escorts and other subordinates in `<subordinates>`:

```xml
<subordinates>
  <subordinate job="argon_destroyer_escort_l_phase2" assignment="defence"/>
  <subordinate job="argon_resupplier_escort_xl" assignment="supplyfleet" group="10"/>
</subordinates>
```

- **`job`** names the subordinate job. That job carries `<modifiers subordinate="true"/>`, a `wing` quota and `startactive="false"`:

  ```xml
  <job id="argon_fighter_escort_s_frigate" name="{20204,2901}" startactive="false">
    <orders>
      <order order="Escort" default="true">
        <param name="formation" value="formationshape.pointguard"/>
        <param name="overrideformationskill" value="true"/>
      </order>
    </orders>
    <quota wing="4"/>
    <category faction="argon" tags="[military, fighter]" size="ship_s"/>
    <location class="galaxy" macro="xu_ep2_universe_macro"/>
    <environment buildatshipyard="true"/>
    <modifiers subordinate="true"/>
    <ship> ... </ship>
  </job>
  ```

  Its `<quota wing="...">` is the number of ships of that job per commander. `variation` in the same `<quota>` (allowed only with `wing`) varies it from commander to commander, from `wing` minus `variation` to `wing` plus `variation` minus one: `wing="3" variation="1"` gives two or three ships.
- **`assignment`** is the subordinate assignment: vanilla uses `attack`, `defence` and `supplyfleet`; the schema lists 15, among them `interception`, `positiondefence`, `mining` and `trade`.
- **`group`** is the subordinate group, 1 to 10. Subordinates of the same group need the same assignment; without `group` the game picks a free one.
- **`rebuild`** decides whether lost subordinates of that entry are replaced. Defaults to `true`.

A subordinate job is not processed on its own: its ships come with their commander. When the engine creates a commander directly in space, it fills every `<subordinate>` entry of that commander at once, next to the commander, in space. A commander built at a shipyard gets its subordinates from a shipyard too, through vanilla's `RestockSubordinates` order (`aiscripts/order.restock.subordinates.xml`), which also has lost subordinates built again; see [Waiting ships](#waiting-ships). In a test, the escorts of two new frigates left the same shipyard two minutes after them. The subordinate job's own `<location>` and `buildatshipyard` are not used: escorts of a job that named another sector and had `buildatshipyard="false"` appeared next to their commander, and `RestockSubordinates` builds replacements at the shipyard the commander flies to.

An escort whose commander is destroyed gets two hours from its `Escort` order before it expires. A new commander of the same job takes it over if one arrives first: in a test, orphaned escorts joined a new commander about a minute after it entered the universe, and `RestockSubordinates` clears the expiry when a commander takes an escort over.

**Subordinate jobs start inactive.** Every vanilla subordinate job does; the schema says `startactive` "should not be true when defining wing quota", and the log warns that an active job with a `wing` quota "may result in double the ships!". In a test, an active job with `wing="2"` under one commander got its two escorts and two more ships without a commander, which did not run the job's `Escort` order.

A subordinate job can list subordinates of its own: the destroyers that escort an Argon carrier have frigates as their own escort, or in fleet phase 2 another destroyer.

[↑ Contents](#toc)

## How many: quotas

`<quota>` sets the numbers the job engine works towards:

| Attribute | Meaning |
| --- | --- |
| `galaxy` | Ships in the whole galaxy; the number the job engine fills for a job whose location is the galaxy. Requested ships may exceed it. |
| `maxgalaxy` | Above this number the engine retires old ships; see [Retiring ships](#retiring-ships). Defaults to twice `galaxy`; a lower value counts as `galaxy`. |
| `cluster`, `sector`, `zone` | At most this many ships per cluster, sector or zone when the engine picks where to create a ship. |
| `station` | Mass traffic ships per station. |
| `wing` | Ships per commander, for a subordinate job. |
| `variation` | Variation of the `wing` count. |

The number the engine fills depends on the class of the job's `<location>`. It uses the first of these quotas that is set:

| Location class | Quota filled |
| --- | --- |
| galaxy | `galaxy` |
| cluster | `cluster`, else `galaxy` |
| sector | `sector`, else `cluster`, else `galaxy` |
| zone | `zone`, else `sector`, else `cluster`, else `galaxy` |

So `sector` is a limit per sector for a galaxy-wide job, and the number to fill for a job located in a sector. A job whose location is the galaxy needs a `galaxy` quota: vanilla's `loanshark_police_common`, with `<quota sector="1"/>` and a galaxy location, gets no ships.

`<quota galaxy="35" maxgalaxy="90" sector="1"/>` fills up to 35 frigates, at most one per sector. The sectors that count are those that pass the location filters: base-game sectors, as `matchextension` defaults to `true`, owned by Argon or by a player at +30 with Argon; see [Where: locations](#where-locations). With 35 such sectors available, every one gets a frigate; with fewer, the job stays below its quota until the faction holds more sectors. That is the design described at the top of vanilla's file: the galaxy quota is the absolute limit, and a job whose galaxy quota exceeds the faction's starting space lets the faction cover more space as it expands. Vanilla marks such jobs with `_exp` in the id.

`<quotas>` holds several `<quota>` elements, each with an optional `gamestart` attribute, for numbers that depend on the gamestart; no vanilla job uses it.

### Friend groups

A job counts the ships, live and waiting, of every **inactive** job of its `friendgroup` as its own. Ships of **active** jobs of the group count only when the job has `activefriendsaffectquotas="true"`.

Vanilla uses this to hand a role from one job to another: `argon_defence` holds the frigate patrol shown in [A job, part by part](#a-job-part-by-part) (a fleet phase 1 job) and a phase 2 destroyer patrol, both with `galaxy="35"`. Once [fleet evolution](#inactive-jobs) deactivates the frigates' job and activates the destroyers', the destroyer job counts the remaining frigates as its own, so the faction does not get a full set of destroyers on top of its frigates. Vanilla groups jobs that do the same work for a faction, such as `argon_defence` or `argon_factionlogic`.

### Retiring ships

When a pass finds a job at its quota with more ships than its `maxgalaxy` quota, the engine retires at least one of the job's ships that are older than `minage`. It picks one at random, cancels its orders and gives it the `MoveDie` order, so the ship leaves and is removed, and goes on while more than `maxgalaxy` times `maxfactor` such old ships remain. Both values sit in `libraries/parameters.xml`: `<jobs><cleanup maxfactor="1.5" minage="10800"/>`, so only ships older than three hours are retired. A job gets above `maxgalaxy` through requested ships, through ships of inactive jobs of its [friend group](#friend-groups), or when an update lowers its quota.

`maxgalaxy` defaults to twice `galaxy`, so a job located in a cluster, sector or zone with neither quota has a `maxgalaxy` of 0: once it reaches its quota, every pass retires its ships older than three hours.

### Scaling

`libraries/parameters.xml` also holds a commented-out `<factor galaxy="2.0" cluster="2.0" sector="2.0" zone="2.0" />` in `<jobs>`, which `libraries/parameters.xsd` describes as a factor of job quotas. A gamestart can scale the quotas per faction or tag with `<jobs><quotas><quota faction="..." tag="..." factor="..."/></quotas></jobs>` in its `<universe>`; no vanilla gamestart does.

[↑ Contents](#toc)

## Where: locations

`<location>` describes the spaces the job's ships work in. Each new ship gets a **main sector** and **main zone** in the space the engine picked for it, and its orders read them, for example as the patrol or mining range.

```xml
<location class="galaxy" macro="xu_ep2_universe_macro" faction="argon" relation="self" comparison="exact"/>
```

- **`class` and `macro`** set the space to look in. Almost every vanilla job has `class="galaxy"`, all of them but one with the galaxy macro `xu_ep2_universe_macro` (the Timelines DLC's `xenon_terraformer_patrol_l_matrix` names `cluster_708_macro`); others name one sector, cluster or zone by macro. Mass traffic uses station classes and `sector`; see [Mass traffic](#mass-traffic).
- **`faction`, `relation` and `comparison`** filter the spaces by how their owner stands with the faction. `relation` names a level of the faction's relation scale, where `self` is the top level and `ally` the next; `comparison="exact"` keeps owners at that level, `ge` at that level or above. `relation="self" comparison="exact"` means space owned by the faction itself, or by a faction it rates at that same top level, and `relation="ally" comparison="ge"` adds space owned by its allies. **A player at +30 with the faction counts as that top level**: in a save where the player stood at +30 with Argon, two of the three patrols of the [example](#adding-jobs-from-an-extension) were created in player-owned sectors. `negatefaction="true"` turns the faction filter around.
- **`tags` and `excludedtags`**: space tags that must all match, and tags to avoid, such as `excludedtags="boronborder"`.
- **`regionbasket`**: only spaces with a region yielding the wares of that basket, such as `minerals`, `gases` or `ice`; vanilla's miners use it.
- **`hasgravidarregion`**: only sectors with a region that obscures the gravidar.
- **`policefaction`, `stationfaction`, `factionrace`, `stationfactionrace`**, each with a `negate...` twin, filter by police faction, by the owners of stations in the space, and by primary race. **`stationtype`**, such as `[wharf, shipyard]`, works together with `stationfaction` and `stationfactionrace` and narrows the stations they look at; vanilla uses it only beside `stationfaction`. Child elements `<factions>`, `<policefactions>`, `<stationfactions>`, `<factionraces>`, `<stationfactionraces>` add further conditions of the same kinds.
- **`<factionlicences>`**: `<factionlicence faction="..." licence="..." negatefactionlicence="true"/>` keeps the ships out of space that requires a licence. The Terran DLC adds this to a few galaxy-wide jobs of the base game and the Split DLC to keep them out of the Terran core: "Disable galaxy-wide jobs in terran space (added by base game)".
- **`<economy>`, `<security>`, `<sunlight>`**: value ranges of the space.

A space's tags and its economy, security and sunlight values are set on its `<area>` in `libraries/mapdefaults.xml`.

`<commander macro="..."/>`, unused in vanilla, limits the job to zones with an object of that macro and bases each new ship there. With a `<basket>`, that object has to share a ware with the basket, unless the job has `ignorecommanderwares="true"`.

### `matchextension`

**An extension job meant for space of the base game or a DLC needs `matchextension="false"`.** `matchextension` defaults to `true`: a job uses only space from the same source as the job. A base-game job uses only base-game space, a DLC's job only that DLC's space, and an extension's job only the space that extension adds. 45 vanilla jobs set `matchextension="false"` to work everywhere, among them the scouts, police and construction vessels of the base game and some Xenon patrols; the Terran DLC keeps the scouts and Xenon patrols among them out of its core sectors with the licence filters above.

### Allowing or blocking a space

**Closing a space.** `<area jobs="false">` in `libraries/mapdefaults.xml` closes a space to jobs. The Timelines DLC closes seven of its sectors this way and opens them with `set_space_jobs_allowed allow="true"` as the story progresses. `reset_space_jobs_allowed` resets a space to the default. A job whose location names one sector (`class="sector"` with a `macro`) is not affected by this setting.

**Reserving a space.** `<area extensionexclusivejobs="true">` in the map reserves a space for the jobs of its own extension. The Boron DLC reserves nine of its spaces this way in its `libraries/mapdefaults.xml`, so jobs of the base game and other extensions do not use them, even with `matchextension="false"`. `set_space_job_exclusivity` does the same from a script, for a space and its children; vanilla does not use it.

[↑ Contents](#toc)

## How ships appear

`<environment>` decides how the job's ships enter the universe:

| Attribute | Meaning |
| --- | --- |
| `buildatshipyard` | `true`: after the job's first population, missing ships are built at a shipyard that builds for the owner. Defaults to `false`: every ship is created directly in space. Most vanilla jobs set `true`. |
| `preferbuilding` | With `buildatshipyard="true"`: the first population is built at shipyards too, instead of being created in space. 59 vanilla jobs. |
| `gate` | The ship is created at a random point in its zone, not at a station. Vanilla sets it on every job with `buildatshipyard="false"`: jobs of the Kha'ak, the Scale Plate Pact, the Buccaneers and the Hatikvah, such as Hatikvah's free miners. The last three also have jobs built at shipyards, such as Buccaneer patrols and Hatikvah mining fleets. |
| `chancedocked` | Chance in percent that a ship without a commander starts docked at a station in its zone that is not hostile to it. An order that leaves the dock, such as `Patrol`, undocks it within seconds. No effect with `gate` or `zone`. Unused in vanilla. |
| `spawninsector`, `spawnoutofsector` | Create the ship only in zones near the player, or only in zones away from the player. Away includes the far part of the player's own sector: in a test, `spawninsector` ships were created about 30 to 60 km from the player, `spawnoutofsector` ships 150 to 200 km away in the same sector. Setting both logs a warning, and the job gets no ships. Unused in vanilla. |
| `zone` | The ship is created at the job's `<position>` in its zone, or at a random point without one. Unused in vanilla. |

Without `gate` or `zone`, an L or XL ship created after the first two minutes of a game tries to start at a station dock; other ships start at a random point in the zone. Subordinates start next to their commander.

**The schema misspells `spawnoutofsector` as `spwanoutofsector`.** The game reads `spawnoutofsector`; an attribute written as the schema has it is ignored, and the log reports `The key name "spwanoutofsector" is not recognized in lookup JobDBXML`.

**A waiting ship is built only when its faction has a faction logic manager and a shipyard that can build the ship.** `Job_Helper` in `md/job_helper.xml` orders the builds, and it runs only for factions with a manager in `md/factionlogic.xml`: 23 factions have one, the Kha'ak do not. Without the manager or such a shipyard, a waiting ship is not built at a shipyard; a script can still put it into the universe with `spawn_waiting_job_ship`. The build runs like this:

- `Job_Helper` in `md/job_helper.xml` runs for each of these factions every 20 to 40 seconds and finds the faction's waiting ships.
- It finds shipyards that can build for the faction and have free build slots, ranks them by price and by distance to the ship's future area, that is the cluster of its commander or of its main sector, and adds a build order to one picked at random, weighted towards the best.
- The build is free, unless the shipyard belongs to the player: then the faction pays the shipyard's price.
- When the build is finished, the shipyard's ship trader script (`aiscripts/build.shiptrader.xml`) hands the ship to the job engine with `activate_waiting_job_ship`.

[↑ Contents](#toc)

## Modifiers

`<modifiers>` holds four flags:

- **`commandeerable`**: defaults to `false`. With `true`, vanilla's faction scripts and missions may take the ship away from its job (commandeer it, with `commandeer_object`): for a faction goal such as an attack or the defence of a sector, to carry a ware a sector lacks, or as a station's miner; see [Category tags](#category-tags). They find such ships with `find_ship_by_true_owner ... commandeerable="true"` or `find_ship ... commandeerable="true"`, some filtered by job tags and some not; `get_suitable_job ... onlycommandeerable="true"` limits the jobs they request new ships from to commandeerable ones.
- **`rebuild`**: defaults to `true`. With `false` the job gets ships only once, at the start, and lost ships are not replaced; new ships come only from requests. Vanilla sets it on 322 jobs, nearly all of them traders and miners of the faction economy and of stations, which get their ships by request.
  - The start is a new game, or the first load of a save with the job's extension.
  - A `rebuild="false"` job with `<time>` is populated on a new game only if its first scheduled time has already come at the start, as with `start="0"`; without `start` it gets no ships.
  - One added by an update of an extension that the save already knows gets none on the load.
  - Activating it with `set_job_active` creates no ships either.
  - A `<subordinate>` entry that names a `rebuild="false"` job needs `rebuild="false"` itself, or the log reports an error.
- **`subordinate`**: the job's ships are subordinates of other job ships, and the job is not processed on its own; see [Subordinates](#subordinates). A job listed in another job's `<subordinates>` needs it; the log asks "Missing 'subordinate' modifier flag?" otherwise.
- **`invincible`**: has no effect on the ships of a `<ship>` job. Unused in vanilla.

[↑ Contents](#toc)

## Timing and expiry

`<time interval="..." start="..."/>` takes a job out of the rotation and gives it a schedule of its own, in seconds of game time. The engine processes the job first when the game time reaches `start`, then each time 75 % to 125 % of `interval` has passed since the last time. Without `start`, the first time is a random game time between 0 and `interval`; the schema says the interval without variation is used, but in a test six jobs with `interval="600"` and no `start` were first processed between 60 and 577 seconds into a new game. Both are game times, so a timed job added to a game that is already older is processed within seconds. Timed jobs are checked every 5 seconds, so a shorter interval acts as 5 seconds.

Vanilla uses it mostly for the deep-space free miners, with `interval="1"` for the single miners, `600` for small groups and `3600` for large groups. The rest are patrols, scouts, scavengers, raiders, plunderers and intervention fleets of the Scale Plate Pact, the Buccaneers, the Boron, the Court of Curbs, the Fallen Split, the Terrans and the Yaki. One of them is `yaki_raider_m_sector` with `start="3600" interval="60"`: no ships in the first hour of a game, then a pass every minute.

`<expirationtime min="..." max="..."/>` gives each new ship of the job a limited life, a random time between `min` and `max` seconds. After it, the ship's `jobexpired` property is true. The routine orders `TradeRoutine`, `MiningRoutine`, `Patrol`, `Escort`, `ProtectShip`, `Middleman`, `Recon` and `Plunder`, and the idle and enemy search scripts, check it and give an expired ship the `MoveDie` order, which takes the ship away and removes it; `SalvageRoutine` gives it the `RecycleDefault` order instead. They check only between their own steps, so an expired `Patrol` ship can go on patrolling for 10 minutes or more. Away from the player, `MoveDie` removes the ship at once, without an explosion; near the player, the ship flies on until the player moves away. The job engine replaces it like any lost ship. The engine itself does nothing to an expired ship: in a test, a ship whose default order was `Wait`, which does not check `jobexpired`, expired after 60 seconds and was still in place 12 minutes later. In vanilla only `dummy_job` uses it; see [Removing a job](#removing-a-job).

[↑ Contents](#toc)

## Category tags

`<category faction="..." tags="[...]" size="..."/>` is how scripts find jobs, and **the tags decide which vanilla scripts use a job**. A job that has none of the tags below and is not commandeerable runs on its quota only. `get_suitable_job` returns the jobs that match a faction, tags, a ship size and a ware, and vanilla's scripts request or activate job ships through it:

| Tags | Used by |
| --- | --- |
| `factionlogic` with `miner`, `trader` or `tug` | The faction economy (`md/factionlogic_economy.xml`) requests a ship from such a job for a sector that lacks a ware the job's `<basket>` contains. |
| `factionlogic` with `freighter` | The faction economy takes a commandeerable ship of such a job away from its job to carry a ware that a sector lacks, for 1.5 hours, or 3 hours for a priority ware. |
| `stationtrader` | The ship trader of an NPC shipyard, wharf or equipment dock (`aiscripts/build.shiptrader.xml`) requests station traders of the size it needs. |
| `stationminerliquid`, `stationminersolid` | A station's trade script (`aiscripts/trade.station.xml`) takes a free commandeerable miner of such a job nearby as its own, or requests one. |
| `staticdefense` | The faction's static defence script (`md/factionlogic_staticdefense.xml`) requests ships of such a job for a sector. Vanilla's 44 such jobs have `galaxy="0"` and a `maxgalaxy` of 2 or 3, so they get ships only by request. |
| `fleetphase_1`, `fleetphase_2` | Fleet evolution in `md/job_helper.xml` swaps a faction's phase 1 jobs for its phase 2 jobs; see [Inactive jobs](#inactive-jobs). |
| `military` or `scout` with `factionlogic` | Faction goals request ships from such jobs by size, and take commandeerable ships of them for an attack or the defence of a sector. |

Some faction goals and missions also take commandeerable ships of a faction without looking at their tags, by size or purpose only; see [Modifiers](#modifiers). DLC stories pick their own factions' jobs by further tags, such as `colonial`, `colonialpolice` and `terrandefence`.

`<basket basket="..."/>` names a ware basket from `libraries/baskets.xml`. It is the default for the ship's cargo, the ship's `warebasket` property returns it, `TradeRoutine` takes it as the default list of wares to trade, and `get_suitable_job ware="..."` matches against it.

[↑ Contents](#toc)

## Mass traffic

The small craft around stations, the police and the criminals in station traffic are mass traffic: lightweight objects rather than full ships. A mass traffic job has `<masstraffic>` in place of `<ship>`:

```xml
<job id="masstraffic_argon_police">
  <task task="masstraffic.police"/>
  <location class="station" policefaction="argon"/>
  <quota station="5"/>
  <masstraffic ref="masstraffic_argon_police"/>
</job>
```

- `<masstraffic>` takes a `ref`, `group` or `macro` like `<ship>`; with more than one, `ref` wins over `group`, and `group` over `macro`. `relaunchdelay` and `respawndelay` set the minimum delay in seconds after a ship arrives or is destroyed before a new one appears (vanilla: 60 and 300 on 8 jobs); both default to 0.
- `<task>` names the AI task the craft performs, `masstraffic.generic` or `masstraffic.police` in vanilla. The schema also lists `entitytype` on `<task>` and `<commander>`; the game does not read it, and the log reports `The key name "entitytype" is not recognized in lookup JobDBXML`.
- The location classes are station parts: `station`, `habitation`, `dockarea`, `pier`, `storage`, `production`, `buildmodule` and `defencemodule`, plus `class="sector"` for the seven civilian traffic jobs of whole sectors, with `<quota sector="1000"/>`, and one effect zone job with `class="zone"`. The quota is per station (`station`), per sector (`sector`) or per zone (`zone`).

Mass traffic jobs take their turn in the rotation, but the craft come from the game's separate mass traffic system, which reads their quotas. `add_mass_traffic_quota` adds a quota to a zone's mass traffic from a script: an `amount` of craft from a `job`, a `macro` or a ship `group`, optionally between a `start` and an `end` station and from `starttime` to `endtime`; without an end time it runs until `stop_mass_traffic_quota`. A gamestart switches mass traffic off with `<masstraffic enabled="false"/>`.

[↑ Contents](#toc)

## When jobs are used

A first population is created in space, or as waiting ships for a job with `preferbuilding="true"`; that holds in every case below.

### New game

Every active job of the chosen dataset without `<time>` is populated at the start. A job with `<time>` is populated at its first scheduled pass; with `interval="60"` and no `start`, that came about a minute in. The start is the only population a `rebuild="false"` job gets; for one with `<time>`, see `rebuild` in [Modifiers](#modifiers).

### Loading a save

A save stores a job's state: whether it is active, where that differs from its `startactive`; whether its first population is still pending; for a job with `<time>`, when it was last processed; its waiting ships and its open requests. **The definitions themselves are read from the files on every start.** So:

- **Every load processes the jobs once.** Missing ships of jobs without `<time>` are created during the load, without waiting for their turn in the rotation.
- **The first load with a new extension** populates the extension's active jobs at once, and those with `<time>` once the save's game time has passed their first scheduled time. `rebuild="false"` jobs are included only from an extension with `save="true"` in its `content.xml`: in a test, the same `rebuild="false"` job got two ships on the first load from such an extension and none from one with `save="false"`, on any load. A new game populates it either way.
- **A job added in a later version of an extension the save already knows** is populated during the load. A `rebuild="false"` job added this way gets no ships.
- **Changed quotas, orders and locations apply to running games.** The engine works towards the current quota from the load on, so a raised quota leads to more ships, built at shipyards for a job with `buildatshipyard="true"`. Ships that already exist keep the orders and loadout they were created with; changed orders and locations reach the ships created after the load. A lowered quota does not replace losses until the job is below the new quota. It removes ships only when the count ends up above the new `maxgalaxy`: then ships older than three hours are retired; see [Retiring ships](#retiring-ships).
- **A changed `startactive`** applies to a running game unless the job's state there already differs from the old `startactive`, for example after a `set_job_active`.

### Removing a job

A job disappears from a running game when an update of its extension drops it, or when its extension is removed or disabled. On the next load the job's saved state is dropped. Its ships stay, moved to vanilla's `dummy_job`, an inactive job with `<expirationtime min="60" max="3600"/>`: each ship expires within one hour and is removed the next time its order script checks `jobexpired`; see [Timing and expiry](#timing-and-expiry).

### Inactive jobs

`startactive="false"` makes a job start inactive. An inactive job is not populated, and its ships are not replaced. About a third of vanilla's jobs start inactive, among them all subordinate jobs, the `fleetphase_2` jobs, and jobs that the story activates.

The MD action `set_job_active job="'...'" activate="true"`, which AI scripts do not have, activates a job and processes it at the job engine's next step, within seconds, whether the job was active before or not: a job that has not been populated yet gets its ships at once. A `rebuild="false"` job gets none. `activate="false"` deactivates a job: its ships stay and keep their orders, but are no longer replaced. The optional `successor` names a job that takes over the deactivated job's ships, waiting ships and open requests, with `updatemainzone` deciding whether they get new main zones. The successor is not activated by this; it needs a `set_job_active` of its own. `check_job_active` reads the state.

Vanilla activates jobs from story scripts, such as `md/setup.xml` and the DLCs' setup and story files, and through **fleet evolution**. `Fleet_Evolution` in `md/job_helper.xml` waits until the game is 20 hours old, the faction's evolution cue has existed for 2 hours (which delays it in a save that gets the cue from an update), and the player's military value reaches 425,340,968 credits. Then it deactivates the faction's jobs tagged `fleetphase_1` and activates those tagged `fleetphase_2`, which add larger ships such as destroyers with escorts. The phase 1 ships stay until they are lost.

The Paranid story's unification in `md/story_paranid.xml` deactivates vanilla's Paranid and Holy Order jobs by id, with Trinity jobs as successors, and then logs an error for every Paranid or Holy Order job that is still active. An extension's job for those factions stays active unless the extension deactivates it itself, for example on `event_cue_signalled cue="md.Story_Paranid.Unification_Stage_3_FactionMerge_Complete"`.

[↑ Contents](#toc)

## Adding jobs from an extension

An extension adds jobs with a diff file at the same path, `libraries/jobs.xml`, as the Boron, Terran and Timelines DLCs do. The patch syntax is covered in [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/). A file with a `<jobs>` root works too: its jobs are added to the vanilla ones, which is how the Pirate and Split DLCs ship theirs.

A complete example: an extension named `example_patrols` that adds frigate patrols with two fighters each to three Argon sectors. Its folder holds a `content.xml` with `id="example_patrols"` and `save="true"` (see [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/)), and this file as `libraries/jobs.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/jobs">
    <job id="example_argon_frigate_patrol" name="{20204,2901}">
      <!-- the default, written out as vanilla does -->
      <modifiers commandeerable="false" />
      <orders>
        <order order="Patrol" default="true">
          <param name="range" value="class.sector" />
        </order>
      </orders>
      <category faction="argon" tags="[military, frigate]" size="ship_m" />
      <!-- three frigates, at most one per sector -->
      <quota galaxy="3" sector="1" />
      <!-- any Argon space, not only this extension's -->
      <location class="galaxy" macro="xu_ep2_universe_macro" faction="argon" relation="self" comparison="exact" matchextension="false" />
      <environment buildatshipyard="true" />
      <ship>
        <select faction="argon" tags="[military, frigate]" size="ship_m" />
        <loadout>
          <quantity exact="1.0" />
          <quality exact="0.9">
            <variation exact="0.5" />
          </quality>
        </loadout>
        <owner exact="argon" overridenpc="true" />
      </ship>
      <subordinates>
        <subordinate job="example_argon_frigate_escort" assignment="defence" />
      </subordinates>
    </job>

    <!-- the escort: inactive, filled with each frigate -->
    <job id="example_argon_frigate_escort" name="{20204,2901}" startactive="false">
      <orders>
        <order order="Escort" default="true">
          <param name="formation" value="formationshape.pointguard" />
        </order>
      </orders>
      <category faction="argon" tags="[military, fighter]" size="ship_s" />
      <!-- two fighters per frigate -->
      <quota wing="2" />
      <location class="galaxy" macro="xu_ep2_universe_macro" matchextension="false" />
      <environment buildatshipyard="true" />
      <modifiers subordinate="true" />
      <ship>
        <select faction="argon" tags="[military, fighter]" size="ship_s" />
        <loadout>
          <quantity exact="1.0" />
          <quality exact="0.9">
            <variation exact="0.5" />
          </quality>
        </loadout>
        <owner exact="argon" overridenpc="true" />
      </ship>
    </job>
  </add>
</diff>
```

Without `matchextension="false"` the patrol job would look for Argon space added by `example_patrols` itself and create nothing. Both jobs reuse vanilla's job name `{20204,2901}`; `name` can also point at a text in the extension's own text file. The escort job is inactive, flagged as a subordinate and counted per commander with `wing`. Neither job has the `factionlogic` tag or is commandeerable, so no faction script requests their ships or takes them away. On a new game, or on the first load of a save with the extension, the three frigates appear at once, each with its two fighters. Lost frigates are built at Argon shipyards.

Points to keep in mind:

- **Ids are unique.** To change a vanilla job, patch its attributes or child elements in place; see [Changing a vanilla job](#changing-a-vanilla-job). Of several jobs with the same id, the first in the file is used, and each later one is dropped with an error in the log. An `<add sel="/jobs">` appends at the end, so a job with a vanilla id is dropped and the vanilla one stays. Added with `pos="prepend"`, the extension's copy comes first and replaces the vanilla job, and the log reports the duplicate on every start.
- **Jobs of a DLC.** The Pirate and Split DLCs ship their jobs as files of their own, so a patch to one of those jobs mirrors the DLC's path inside the extension's folder, such as `extensions/ego_dlc_split/libraries/jobs.xml`. The Boron, Terran and Timelines DLCs add their jobs to the base game's file with patches, so a patch to one of their jobs goes into the extension's own `libraries/jobs.xml`. Either way the extension needs a dependency on the DLC with `optional="true"`; see [Patching a DLC or another extension](/x4/modding-support/anatomy-of-an-extension/#patching-a-dlc-or-another-extension).
- **Changes reach running games.** Unlike [god.xml](/x4/modding-support/god-xml/), jobs are not generated once: the job engine works from the current definitions every time, see [Loading a save](#loading-a-save).

The defaults and requirements that most often go wrong, such as `buildatshipyard`, tags and subordinate jobs, are in [Traps](#traps).

### Updating an extension

Version 1.10 of `example_patrols` raises the patrol's quota to five sectors:

```xml
<quota galaxy="5" sector="1" />
```

No script is needed. Saves made with 1.00 keep their three patrols, and the first load with 1.10 adds two waiting frigates, which Argon shipyards build. New games, and saves new to the extension, get five at the start.

While a game runs, a job without `<time>` waits for its turn in the rotation before it replaces a lost ship. `set_job_active job="'example_argon_frigate_patrol'" activate="true"` from an MD script processes the job within seconds, active or not.

### Changing a vanilla job

A patch changes a vanilla job in place, for example the quota of the single Argon deep-space free miner:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <replace sel="/jobs/job[@id='argon_free_miner_ml_solid_deepspace_single']/quota/@galaxy">3</replace>
</diff>
```

Like an update of an extension, the change reaches running games on the next load. In a test, a save with the job's one miner got two waiting miners on the first load with the patch, and a new game had three.

A `<replace>` of the whole job, `sel="/jobs/job[@id='...']"`, makes the job the extension's, so the default `matchextension` then finds no space for it. In a test, an Argon frigate patrol replaced this way got no ships on a new game; in a save, its existing frigates stayed, but no sector was suitable for new ones. The same replacement with `matchextension="false"` in its `<location>` got its ships. Patching single attributes or child elements avoids the question.

[↑ Contents](#toc)

## The script side

### Activating and deactivating

`set_job_active` and `check_job_active`, see [Inactive jobs](#inactive-jobs).

### Requesting ships

`request_job_ship job="..." requester="..." zone="..." ware="..." name="$Ship"` requests a new ship from a job for a purpose. The requester is an object or a space, `zone` becomes the ship's main zone, and `ware` the ware it is meant to transport. The result is a waiting ship that a shipyard still has to build, created regardless of the job's quota and state; it counts towards the job's quota. `set_requested_job_ship_timeout` sets when the request lapses: once it has, a requested ship that is still not in the universe is removed with its request at the job's next turn. Without a timeout, a request lapses 30 minutes after it was made: in a test, a requested ship that no shipyard could build was removed within half a minute after the 30 minutes had passed. Vanilla sets one to four hours, or `player.age` to let a request lapse at once. `remove_job_ship_request` cancels a request (a ship that is not in the universe yet is removed), and `find_requested_job_ship` finds requested ships by `requester` and `ware`, with `includeexisting` and `includewaiting`.

`get_suitable_job` finds the jobs to request from: `faction`, `tags`, `size` and `ware` (matched against the job's basket) filter them; `includeinactive` and `exceedquota` include inactive jobs and jobs above their `maxgalaxy` quota; `onlycommandeerable` keeps commandeerable jobs only; `force` searches even with the job engine off.

### Waiting ships

`find_waiting_job_ship` and `find_waiting_subordinate` find ships that wait to be built. `spawn_waiting_job_ship` puts one into the universe directly, in a dock, a zone or a sector position, instead of having it built; `activate_waiting_job_ship` tells the job engine that a waiting ship is ready, as the shipyard script does after the build. `activate_job_ship_orders` cancels a ship's orders and gives it the default order of its job: in a test, a ship with a `Wait` default and a queued `Wait` was back on its job's `Patrol` with an empty queue.

For commanders: `get_subordinate_jobs` returns the subordinate jobs and the number of ships missing for a commander or a job, `get_subordinate_macro` the macros they may use, `create_replacement_subordinates` creates the missing ones as waiting ships that a given shipyard can build, and `organise_job_ship_subordinates` sorts a commander's subordinates according to its job. Vanilla's `RestockSubordinates` order (`aiscripts/order.restock.subordinates.xml`) uses them.

### Other actions

`release_job_ship` releases a ship from its job. `set_job_ship_mainsector` and `set_job_ship_mainzone` move a ship's main sector or zone. `set_ship_expiration_time` sets the game time at which a ship counts as expired, such as `player.age + 2h`; vanilla's `RestockSubordinates` sets `-1s`, which clears the expiry, on an orphaned escort it takes over.

### Events

`event_job_ship_activated` fires when a job ship enters the galaxy, "either spawned directly in space or when being finished at a shipyard"; `event.param` is the ship. Vanilla's `md/encounters.xml` uses it for player encounters: it reads the new ship's `encounterid`, the `<encounters id="..."/>` of its job, and starts the matching encounter, such as `lone_miner`, `mining_group_small` or `khaak_s_lone`. The DLC setup and story scripts wait for ships of particular jobs the same way.

### Properties

| Property | Result |
| --- | --- |
| `job` | the job id |
| `jobname` | the job name |
| `isjobship` | a ship of a job |
| `iswaitingjobship` | a job ship not yet in the universe |
| `isrequestedjobship` | a requested job ship |
| `isvalidjobship` | a job ship whose place in its command hierarchy matches its job |
| `jobexpired` | a job ship, not commandeered, past its expiration time |
| `iscommandeerable`, `iscommandeered` | the ship may be commandeered, or is commandeered now |
| `jobcommander` | the commander the ship was created for |
| `jobmainsector`, `jobmainzone` | the ship's main sector and zone |
| `isvalidjobspace.{$space}` | whether a space is valid for the ship's job |
| `jobsubordinates.valid`, `jobsubordinates.invalid` | subordinates whose place does or does not match the job |
| `jobloadoutfaction` | the faction the loadout was generated for |
| `encounterid` | the job's encounter id |
| `warebasket` | the wares of the job's basket |

On a space: `jobs` (whether jobs may use it), `isexclusiveforextensionjobs`, `freejobquota.{$jobid}` (free quota for the job in that space, without checking the location filters) and `issuitableforjob.{$jobid}` (whether the space passes the job's location filters).

### Finding job ships

`find_ship` takes `job` (an id or a list of ids) and `jobtags` (compared with the job's category tags); `hasjob`, `validjobship`, `requestedjobship` and `subordinatejobship` filter by those states, and `encounterid` by the job's encounter id. `find_sector` and the other space finders take `jobspacefor`, a job ship or a job id, for spaces a job ship can be based in.

[↑ Contents](#toc)

## Checking the result

- **The debug log** carries the errors about jobs at load time and the job engine's messages during play. Every one of them is written as an error, between two lines of `=` signs, so it shows in the log without any `-debug` filter. See [The debug log](/x4/modding-support/running-x4-for-modding/#the-debug-log).
- **Counting ships from a script**: `find_ship job="'...'" space="player.galaxy" multiple="true" recursive="true"` gives the ships a job has in the universe, and `find_waiting_job_ship` those waiting to be built. Without `recursive="true"` the search misses ships docked at a station.
- **In game, without a script**: a job ship's name shows the job's name ahead of the ship type, and its Default Behaviour shows the job's order.
- **Watching ships arrive**: `event_job_ship_activated` fires for every job ship that enters the universe; see [Events](#events).

The messages that come up while writing jobs and the scripts that use them:

| Log message | Meaning |
| --- | --- |
| `JobDB::Import(): File '...' is an invalid job XML file` | A file that is not a diff has a root element other than `<jobs>`. |
| `LookupKeyName::LookupName(): The key name "..." is not recognized in lookup JobDBXML.` | A name the job parser does not know, such as the schema's `spwanoutofsector`; it is ignored. |
| `[JobDB] Error: JobID: '...' is invalid because the ID is not unique - an job with that ID already exists.` | Duplicate id; this later job is dropped and the first one kept. |
| `[JobDB] Error: JobID: '...' is invalid because neither <quota> or <quotas> is defined.` | The job has no quota. |
| `[JobDB] Error: JobID: '...' is invalid because total quota is zero.` | All quota values are zero. |
| `[JobDB] Error: JobID: '...' is invalid because <quotas> is empty.` | A `<quotas>` element with no `<quota>` in it. |
| `[JobDB] Error: JobID: '...' is invalid because <ship> or <masstraffic> definition is missing.` | Nothing to create. |
| `[JobDB] Warning: JobID: '...' has both a <ship> node and a <masstraffic> node. Results may be undesirable.` | Only one of them belongs in a job. |
| `[JobDB] Warning: JobID: '...' has multiple macro selection definitions (e.g. macro="", group="", ref="") defined in it's <ship> node. Ref will always be preferred (followed by group)!` | More than one of `ref`, `group` and `macro` on `<ship>`; the same exists for `<masstraffic>`. |
| `[JobDB] Warning: JobID: '...' is defining a 'wing' quota but is not set to startactive="false", this may result in double the ships!` | A subordinate job that is active. |
| `[JobDB] Warning: JobID: '...' is defining a quota variation which is only support for 'wing' quotas!` | `variation` without `wing`. |
| `[JobDB] Warning: JobID: '...' has a defined sector location but a sector quota of 0.` | A mass traffic job whose location class has no quota of the same name; the same message exists for cluster, zone and station. |
| `[JobDB] Warning: JobID: '...' has a defined commander '...' but a zone quota of 0.` | A job with `<commander>` and a zone location, but no `zone` quota. |
| `[JobDB] Warning: JobID: '...' definition prefers building but is not flagged to allow building at shipyards` | `preferbuilding` without `buildatshipyard="true"`; the ships are created in space. |
| `[JobDB] Warning: JobID: '...' is defined to spawn only in sector and only out of sector.` | `spawninsector` and `spawnoutofsector` both set. |
| `[JobDB] Warning: JobID: '...' has invalid region basket ...` | Unknown `regionbasket`. |
| `Job ... has invalid tag or taglist in node <category>` | A tag in `<category>` that does not exist. |
| `Error in context class: Property lookup failed: ...` | A misspelt keyword in a value, such as `size="ship_q"` in `<category>`. |
| `Faction list in job '...' has invalid entry: ...` | An unknown faction in a location filter; the same message exists for race, police faction, station faction, station faction race and station type lists, and `Faction licence in job '...' has invalid faction or licence: ...` for a licence. |
| `Unable to resolve subordinate job ID: '...'` | A `<subordinate job>` that names no job. |
| `JobClass::ResolveReferences(): job ... references non-subordinate job ... as a subordinate. Missing 'subordinate' modifier flag?` | The subordinate job lacks `<modifiers subordinate="true"/>`. |
| `Subordinate for job '...' has a clashing group ID of '...'` | Two subordinate entries share a group but not the assignment. |
| `Subordinate for job '...' has an invalid group range of '...' (maximum is 10)` | A `<subordinate group>` outside 1 to 10. |
| `Subordinate for job '...' has invalid assignment '...'` | An `assignment` that does not exist. |
| `Subordinate for job '...' with assignment '...' does not have a defined group ID and there are too many other groups to assign a free one` | An entry without `group` when all ten groups are taken. |
| `Job ... has subordinate job ... set to rebuild, which the subordinate definition does not allow` | A `<subordinate>` entry without `rebuild="false"` for a job with `rebuild="false"`. |
| `[JobEngine] No ship generated for JobID: '...'. Probably invalid ship macro/group/ref definition.` | The `<select>` found no ship macro. |
| `[JobEngine] No homebase found for JobID: '...'. Probably invalid macro definition ('...') or wrong location ('...').` | No object of the `<commander>` macro in the zone picked for a new ship, or none sharing a ware with the job's basket. |
| `[JobEngine] JobID: '...' could not find sector '...'.` | The location's `macro` names no such sector; the same exists for zones and clusters. |
| `[JobEngine] The corresponding AI task (script) '...' for JobID: '...' does not exist.` | A mass traffic `<task>` that does not exist. |
| `Job ... can not find suitable mainzone for ship ...` | No main zone could be picked for a ship, such as one moved to a successor job with `updatemainzone`. |
| `Tried to activate state for job ID ..., which is not valid!` | `set_job_active` names no job; deactivating logs `Tried to deactivate job ID ..., which is not valid!`, and `Tried to deactivate job ID ... with successor ..., which is not valid!` when the `successor` names no job. |
| `Tried to request ship from job ... which is not valid!` | `request_job_ship` names no job; `... when the job engine is not enabled!` when the gamestart has the job engine off. |
| `Ship ... does not have a job spawn source. Main zone cannot be set.` | `set_job_ship_mainzone` on a ship that is not a job ship; the same for the main sector. |
| `Waiting job ship ... is not in a state to be spawned in the universe. Check if it is already set to be spawned by another means.` | `spawn_waiting_job_ship` on a ship that is already in the universe, job ship or not. |
| `No valid zone, sector or dock was provided.` | `spawn_waiting_job_ship` without `zone`, `sector` or `dock`. |

[↑ Contents](#toc)

## Traps

- **`matchextension` defaults to `true`.** An extension job aimed at vanilla space needs `matchextension="false"`, or it finds no space. That includes a vanilla job the extension replaces as a whole.
- **`buildatshipyard` defaults to `false`.** Lost ships of a job without it come back in space, with no shipyard involved.
- **In a running game, a job without `<time>` waits for its turn.** A lost ship is replaced, or ordered from a shipyard, up to about 75 to 80 minutes of game time later. Loading a save processes every job at once, and `set_job_active` processes one within seconds.
- **`rebuild="false"` populates once, if at all.** Such a job is not refilled, and `set_job_active` does not populate it. With `<time>` it gets no ships on a new game unless its first scheduled time has already come at the start, as with `start="0"`.
- **A `<ship>` job that is not a subordinate needs a `galaxy` quota.** A galaxy-wide job without one gets no ships; a job in a cluster, sector or zone without a `galaxy` or `maxgalaxy` quota retires its ships older than three hours at every pass once it is full.
- **A subordinate job has to start inactive.** An active job with a `wing` quota logs a warning that it may double the ships.
- **The schema spells `spwanoutofsector`; the game reads `spawnoutofsector`.**
- **`find_ship` misses docked ships** unless it has `recursive="true"`.
- **Tags pull a job into vanilla's scripts.** `factionlogic` with `trader`, `miner` or `tug` and a basket makes the faction economy request ships of the job on top of its quota.
- **Lost ships of a `buildatshipyard="true"` job come back only from a shipyard.** A faction without a shipyard that can build the ship, or without a faction logic manager in `md/factionlogic.xml` (the Kha'ak have neither), gets no replacements.
- **Cargo is skipped on re-created ships** unless its `<wares>` has `onjobrespawn="true"`.
- **Fleet evolution swaps jobs late in a game.** A job tagged `fleetphase_1` is deactivated after 20 hours once the player's fleet is strong enough.

[↑ Contents](#toc)
