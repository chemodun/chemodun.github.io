---
title: terraforming.xml
description: How libraries/terraforming.xml defines the terraforming system of 9.00 as a catalogue - the planet stats with their states, colours and habitability, the project groups, and the projects with conditions, effects, side effects, rebates, resources, drone deliveries and the projects they remove or block; how a script turns the catalogue into a planet's project list, how the expansions extend it, the script side, and how an extension adds a project of its own.
---

# terraforming.xml

`libraries/terraforming.xml` is the terraforming catalogue: the **stats** a planet can have (temperature, air pressure, oxygen, methane, housing...), each with a scale of states, a colour and a text per state, the **project groups** the interface sorts by, and the **projects**, each with the conditions it needs, the effects it has, the side effects it risks, the wares it costs and the drones that fly them down. The file defines what exists; it attaches nothing to any planet. That part is done by scripts: `md/terraforming.xml` initialises a planet, sets its starting stats and picks the projects it gets from the catalogue, one planet at a time.

This article covers the format, what a stat and a project consist of, how a script turns the catalogue into a planet's project list, how the expansions extend it, the script side, and how an extension adds a project. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **World**: the planet (or moon) being terraformed. The data lives on the **cluster**, and every script action and property addresses the cluster, not the planet.
- **Stat**: one measured property of the world, `temperature`, `oxygen`, `population`. A stat has a raw **value**, a non-negative integer, and the stat's `<range>` list maps the value to a **state**, a small integer that conditions test and that the interface shows as a colour.
- **Dynamic stat**: a stat with `dynamic="true"`. It is absent until something changes it, starts at 0 then, and disappears again when it returns to 0. The others are present from the start at their `default`.
- **Habitable**: a world is habitable while no stat of it sits in a range with `habitable="false"`.
- **Project**: one entry under `<projects>`. In the interface a project is a node the player can start once its conditions and predecessors are met, with a price in wares; an **event** is a project the script adds with `add_terraforming_event` instead of `add_terraforming_project`, sits in the `events` group and has no price.
- **Project group**: the column of the interface a project sits in, `power`, `biosphere`, `housing`; also the unit a predecessor or a block can name instead of a single project.
- **Predecessor**: a project, or a group of projects, that must be complete before this project can start. Predecessors are not in this file: the script states them when it adds the project to a world.
- **Setback**: a loss of progress on the running project, as a percentage, caused by a side effect.
- **Rebate**: a percentage off the wares of one ware group, or one ware, that a completed project grants to the projects after it.

[↑ Contents](#toc)

## How the catalogue reaches a world

The file alone does nothing. A world enters terraforming when a script runs `initialise_terraforming` on its cluster, naming the part of the cluster's model that is the planet; from then on the cluster has terraforming data, the headquarters' overview and the Terraforming menu show it, and the `terraforming` properties of the cluster answer. The script then sets the starting stats with `set_terraforming_stat`, which creates a dynamic stat where it names one, and adds projects with `add_terraforming_project`, each by its catalogue id, with the predecessors it should have on this world.

Vanilla does this per planet in `md/terraforming.xml`: one cue per world finds the cluster, initialises it, sets its stats, and calls a set of libraries that pick projects by what the stats say. A world below temperate gets the warming projects, a world with methane gets the methane oxidisers plus a global-warming event, a world with no toxicity never sees the toxin cleanup. Later cues react to stats that appear or vanish: when methane becomes relevant on a world, its cleanup projects are added; when it goes back to 0 and the cleanup was never completed, they are removed again. A project in the catalogue that no script adds to a world is never seen.

The interface, `menu_terraforming.lua`, shows the projects of one cluster. It lists only the projects whose conditions hold, greys a project that cannot start yet, and marks every project with an error colour while the player's headquarters is not in that cluster: resources are delivered from the headquarters, which has to sit in the world's cluster. Once the station holds the wares, the terraforming drones are built there and fly to the site; when the last delivery has landed the project's `duration` runs, and then its effects apply, or do not, by its `chance`.

[↑ Contents](#toc)

## The file

### Layout

```xml
<terraforming>
  <stats>
    <stat id="temperature" name="{1001,11401}" default="5" icon="terraforming_temperature" inactivetext="{1001,3828}">
      <range end="3" state="0" habitable="false" r="255" g="255" b="255" description="{1001,11402}" />
      <range end="4" state="1" r="102" g="204" b="204" description="{1001,11403}" />
      ...
    </stat>
    ...
  </stats>
  <projectgroups>
    <projectgroup id="events" name="{1001,11471}"/>
    <projectgroup id="special" name="{1001,11472}"/>
    ...
  </projectgroups>
  <projects>
    <project id="wat_irrigation" group="water" name="{20227,1070}" description="{20227,1071}">
      <conditions>
        <condition stat="temperature" min="1" max="3" />
      </conditions>
      <effects>
        <effect stat="humidity" change="1" />
      </effects>
      <resources price="75000000">
        <ware ware="hullparts" amount="1" />
        <ware ware="ice" amount="10" />
      </resources>
      <deliveries>
        <ship macro="ship_gen_m_transdrone_container_01_a_macro" amount="100" buildduration="30" />
        <ship macro="ship_gen_s_transdrone_container_01_a_macro" amount="500" buildduration="15" />
      </deliveries>
    </project>
    ...
  </projects>
</terraforming>
```

Three required sections, in this order. The schema is `libraries/terraforming.xsd`; it includes `common.xsd` for the price scale lookup and defines the rest itself. Every id is a plain identifier (letters, digits, underscore, not starting with a digit). The base file holds the stats and groups described below and about a hundred projects; the project ids carry a prefix by subject (`tmp_`, `wat_`, `atm_`, `bio_`, `pwr_`, `ind_`, `agr_`, `res_`, `trn_`, `ame_`, `eco_`, `xen_`, `evt_`), which is a naming habit, not a rule.

[↑ Contents](#toc)

### Stats

```xml
<stat id="methane" name="{1001,11412}" default="0" dynamic="true" icon="terraforming_methane" inactivetext="{1001,3831}">
  <range end="0" state="0" r="0" g="0" b="0" />
  <range end="1" state="1" r="0" g="255" b="0" description="{1001,11413}" />
  <range end="6" state="2" r="255" g="255" b="0" description="{1001,11413}" />
</stat>
```

| Attribute | Meaning |
| --- | --- |
| `id` | The stat id scripts and projects use; required |
| `name` | Name text; required |
| `icon` | Icon id from `libraries/icons.xml`; vanilla's are the `terraforming_*` icons |
| `inactivetext` | The line shown under "Other" in the menu while the stat is dynamic but not current |
| `default` | The value assumed while the stat has not been set; required |
| `dynamic` | `true`: the stat starts at 0 when first changed and is removed when it goes back to 0; default `false` |
| `shaderparam` | A shader parameter the planet's material changes with this stat, one per stat and one stat per parameter; no vanilla stat sets it |

A `<range>` maps values to a state. `end` is the last value of the range, `state` the state number conditions test; the ranges are listed in rising order of `end`, so the first range whose `end` the value does not exceed is the one in force. `r`, `g`, `b` are the colour the menu shows for the state, `description` the text for it, and `habitable="false"` marks the state as one in which the world is not habitable. A stat with no ranges, `population` and the two trainee counters, is a plain number.

What the ranges say in vanilla: temperature runs from freezing (uninhabitable) through cold, temperate and hot to burning (uninhabitable), the comfortable band of air pressure and oxygen is the one state in the middle, and the pollutants (`methane`, `carbondioxide`, `toxicity`, `radioactivity`, `seismicactivity`) are dynamic, start absent, and get a range of state 0 for the value 0 so that a world that has cleaned them up shows nothing. `toxicity` and `radioactivity` make the world uninhabitable at any value above 0. `xenon_alertness` and `xenon_production` belong to the Xenon variant of the feature; the file's own comment says production is a linear scale that works a bit differently from the other stats.

`population` is special in two ways: the schema's effect attributes name it as the one stat an effect may change besides the ids of this file, and an effect on it ignores `min`, `max`, `value` and `onfail`. Its name text is "Housing", which is also what the menu calls it.

[↑ Contents](#toc)

### Project groups

```xml
<projectgroup id="power" name="{1001,11473}"/>
```

A group is an id and a name text. The groups are the columns of the Terraforming menu, in file order: `events`, `special`, `power`, `industry`, `cleanup`, `water`, `atmosphere`, `biosphere`, `food_staple`, `food_luxury`, `housing`, `amenities`, `economy`, `training`, `xenon`. A project names its group in `group`; a script can name a group as a predecessor, so that any (or every) project of the group counts; a project can block a whole group.

[↑ Contents](#toc)

### Projects

```xml
<project id="bio_jumpstart" group="biosphere" name="{20227,1180}" description="{20227,1181}" duration="300" chance="25">
  <conditions>
    <condition stat="temperature" min="1" max="3" />
    <condition stat="humidity" min="1" />
    <condition stat="airpressure" min="1" />
  </conditions>
  <sideeffects>
    <sideeffect project="bio_cull" text="{1001,11431}" chance="25" beneficial="false" />
  </sideeffects>
  <resources price="20000000">
    <ware ware="methane" amount="40" />
    <ware ware="spices" amount="100" />
  </resources>
  <deliveries>
    <ship macro="ship_gen_m_transdrone_container_01_a_macro" amount="20" buildduration="30" />
    <ship macro="ship_gen_s_transdrone_container_01_a_macro" amount="100" buildduration="15" />
  </deliveries>
  <removedprojects>
    <project id="bio_tailored" />
  </removedprojects>
</project>
```

| Attribute | Meaning |
| --- | --- |
| `id` | The project id; required |
| `name`, `description` | Texts; `name` required. Two projects may share a text, as the three quake events do |
| `group` | The project group; required |
| `duration` | Seconds between the last delivery and the effects taking place; default 0 |
| `repeatcooldown` | Seconds between the effects and the project becoming available again; default -1, not repeatable. `0` makes it repeatable at once |
| `chance` | Chance of success in percent; default 100 |
| `resilient` | `true`: the project is immune to setbacks; default `false`. Vanilla sets it on most of the repeatable projects: imports, supply runs, training courses |
| `showalways` | Shown even while its conditions are not met; default `false`. The schema says it is for events only; the menu applies it to anything, and without it hides a project until its conditions hold |
| `research` | A research ware the player must have unlocked before the project becomes available; default none. The base game uses it nowhere; the Terran expansion gates its projects with it |
| `version` | Raise it after changing the project so that worlds which already hold it take the change in a loaded game |

The children, every one of them optional:

| Element | What it holds |
| --- | --- |
| `<conditions>` | One `<condition>` per stat the project needs: `stat`, and either `min`/`max` on the **state** or `minvalue`/`maxvalue` on the raw **value**; a value bound overrides a state bound on the same side |
| `<effects>` | What happens on success: `<effect stat change>` adds `change` to the stat, clamped by `min`/`max` on the result; `<effect stat value>` sets the stat instead (`value` is used when `change` is 0 or absent, and the clamps do not apply); `onfail="true"` applies it on failure too; `text` overrides the line the menu shows, and is the only thing needed for an effect that changes no stat; `beneficial` tells the menu how to colour an effect the code cannot judge itself |
| `<sideeffects>` | What may happen besides: a `<sideeffect>` takes the effect attributes plus a required `chance`, `setback` (percent of progress lost on the current project) and `project` (a project that is put in the way and blocks progress until done). The chance is ignored where the side effect only changes `population` |
| `<rebates>` | `<rebate value>` in percent on a `waregroup` of `libraries/waregroups.xml` or on one `ware`, granted to later projects once this one is complete |
| `<resources>` | The price and the ware list, below |
| `<deliveries>` | The drones that carry the wares down: `macro`, `amount`, and `buildduration` per ship, in seconds. The drone blueprints are given to the player by the script when terraforming starts |
| `<removedprojects>` | Projects removed from the world when this one succeeds: the two biosphere starters remove each other, the two refinery variants too |
| `<blockedprojects>`, `<blockedgroups>` | Projects or whole groups that cannot start until this one succeeds: the microbe cull blocks the fertiliser, the parasite cull blocks both food groups, the toxic-fruit projects and the refinery retrofit block the toxin cleanup |

Resources:

```xml
<resources price="2000000" payout="250" minwares="2" maxwares="3">
  <ware ware="advancedcomposites" amount="4" />
  <ware ware="claytronics" amount="1" />
  ...
</resources>
```

| Attribute | Meaning |
| --- | --- |
| `price` | The total cost, or a cost factor, by `pricescale`; required |
| `pricescale` | `absolute` (default): `price` is Credits. `population`: `price` is the cost per 100 000 inhabitants and scales with the world's housing. `playeraccount`: `price` is a percentage of the player's current account |
| `payout` | Paid on success, as a percentage of the price; default 0. Vanilla uses it on the supply runs of the economy group, which pay back more than they cost |
| `maxprice` | A ceiling applied after scaling |
| `minwares`, `maxwares` | How many of the listed wares are picked at random for one run; default all of them |
| `<ware ware amount>` | A ware and its share |

The `amount` of a ware is a ratio, not a quantity: the engine fills the price with the listed wares in those proportions at their maximum prices, and `terraforming.project.{id}.resources` on the cluster gives the scaled result. This is why a project can cost a hundred million Credits and list `graphene` at amount 1: the whole price is graphene. A `<resources>` with a price and no wares, as the bank's supply run has, is a price in money alone; the events and the Xenon district actions have no `<resources>` at all.

[↑ Contents](#toc)

### Events

An event is an ordinary `<project>` of the `events` group, told apart only by how the script adds it: `add_terraforming_event` instead of `add_terraforming_project`. Vanilla's events are the quakes, the ice melt, the two global-warming reactions and, with the Boron expansion, crust solidification, volcanic extinction and salinisation. They carry conditions on the stats, effects or a setback, a `duration` and usually `repeatcooldown="0"`, and no `<resources>`; the menu lists them in their own column and never greys them, since the player does not start them.

[↑ Contents](#toc)

### The Xenon variant

The `xenon` group and the two `xenon_*` stats serve one world, the Xenon-held planet of the Tharkas Cascade story, kept by the script in a group of its own. Its projects (claim, destroy or disable a district, subvert the core, detonate the reactor, EMP and bombardment runs) have deliveries but no conditions, effects or price in the file; the file's comment says their state texts, under Xenon control, liberated, destroyed, are set by the script. It is the catalogue used as a list of actions, with the logic elsewhere.

[↑ Contents](#toc)

## How the expansions change it

Three expansions ship a `libraries/terraforming.xml`, every one a `<diff>` that adds to the base file:

| Expansion | What it adds |
| --- | --- |
| Split Vendetta | One project, scruffin fields, to `food_staple`, with a rebate on food |
| Cradle of Humanity | Terran projects (water surfacing, outgassing, tectonic scaffolding, von Neumann industry), every one with `research="research_tf_tech"`, a mission-only research ware the expansion's story grants, and with Terran drone macros (`_02_a`) in their deliveries, whose blueprints the expansion's own script adds |
| Kingdom End | One stat, `salinity`, with four states and no habitable fresh-water state, and the projects and events of an ocean world: ocean currents, hydro power, reintroduction of microbes to megafauna, plankton fields, ocean housing, an art academy, and the three events named above |

The expansions' own `md/terraforming.xml` files add those projects to their worlds; the base file's entries and the base worlds' project lists are not changed by any expansion's diff.

[↑ Contents](#toc)

## The script side

Every action and property works on the cluster. The actions belong to the Mission Director; the properties can be read wherever a cluster is at hand.

| Expression or element | What it gives |
| --- | --- |
| `initialise_terraforming cluster partname` | Starts terraforming on a cluster; `partname` is the planet part of the cluster's model |
| `set_terraforming_stat cluster id value`, `remove_terraforming_stat` | Sets a stat (creating a dynamic one), or removes it so that it is neither shown nor used by conditions and effects |
| `add_terraforming_project cluster id`, `add_terraforming_event` | Adds a catalogue entry to the world; `name`, `description`, `duration`, `repeat`, `successchance`, `price`, `pricescale` and the children `conditions`, `effects`, `sideeffects`, `rebates`, `resources`, `deliveries`, `removedprojects` override the catalogue; `predecessors` states which projects or groups must be complete first, `any="true"` for one of them; `postfix` adds the same entry more than once under distinct ids; `starttime` adds it as already done |
| `remove_terraforming_project`, `remove_terraforming_event` | Takes an entry off the world |
| `set_terraforming_mission_activated cluster missioncue`, `..._deactivated`, `..._completed` | Ties the world to its story mission, for the menu's mission line and for the `mission` properties |
| `event_terraforming_project_available`, `_started`, `_started_production`, `_completed`, `_succeeded`, `_failed` | The life of a project, `object` the cluster, `param` the project id; on success `param2` is a pair of booleans for positive and negative side effects and `param3` the payout |
| `event_terraforming_stat_added`, `_changed`, `_removed`, `event_terraforming_habitability_changed`, `event_terraforming_event_started` | Stat and habitability changes, `param` the stat id |
| `$cluster.terraforming.stat.{$id}.exists`, `.value`, `.state` | Whether the stat is current, its raw value, its state number |
| `$cluster.terraforming.project.{$id}.exists`, `.complete`, `.name`, `.description`, `.successchance`, `.resources` | A project on the world: present, completed at least once, its texts, its chance, its scaled ware list |
| `$cluster.terraforming.habitable`, `.partname`, `.planetposition.{$sector}` | Habitability, the planet part, the planet's position seen from a sector |
| `$cluster.terraforming.mission.active`, `.complete` | The state of the world's story mission |
| `terraforming.stat.{$id}.name`, `.description.{$state}`, `terraforming.project.{$id}.name`, `.description`, `.successchance` | The catalogue itself, without a world |
| `set_world_population`, `set_world_settlements` | The planet's encyclopedia lines, which vanilla updates from the housing stat |

The statistics `terraforming_projects_completed`, `terraforming_projects_failed`, `terraforming_complications_suffered`, `terraforming_missions_completed` and the two personnel counters are kept by the script, not by the engine.

[↑ Contents](#toc)

## Adding a project from an extension

A project needs two files: the catalogue entry, and a script that adds the entry to the worlds, since nothing adds it on its own. The example below, for a fictional extension `example_terraforming`, adds orchards as a luxury food project: it wants a world that is not frozen or burning and has some humidity, adds a little oxygen, grants a rebate on food wares, and becomes available once any staple food project is complete.

`libraries/terraforming.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/terraforming/projects">
    <project id="agr_orchards" group="food_luxury" name="{1234567,1}" description="{1234567,2}" duration="900" version="1">
      <conditions>
        <condition stat="temperature" min="1" max="3" />
        <condition stat="humidity" min="1" />
      </conditions>
      <effects>
        <effect stat="oxygen" change="1" />
      </effects>
      <rebates>
        <rebate waregroup="food" value="5" />
      </rebates>
      <resources price="30000000">
        <ware ware="dronecomponents" amount="2" />
        <ware ware="water" amount="50" />
        <ware ware="wheat" amount="100" />
      </resources>
      <deliveries>
        <ship macro="ship_gen_m_transdrone_container_01_a_macro" amount="20" buildduration="30" />
        <ship macro="ship_gen_s_transdrone_container_01_a_macro" amount="100" buildduration="15" />
      </deliveries>
    </project>
  </add>
</diff>
```

`md/Example_Terraforming.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="Example_Terraforming" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="AddOrchards" instantiate="true" checkinterval="5min">
      <conditions>
        <check_value value="md.Terraforming.Start.state == cuestate.complete"/>
      </conditions>
      <actions>
        <do_for_each in="md.Terraforming.Start.$TerraformingClusters" name="$Cluster">
          <do_if value="not $Cluster.terraforming.stat.xenon_alertness.exists and not $Cluster.terraforming.project.agr_orchards.exists">
            <add_terraforming_project cluster="$Cluster" id="'agr_orchards'">
              <predecessors>
                <predecessor group="'food_staple'"/>
              </predecessors>
            </add_terraforming_project>
          </do_if>
        </do_for_each>
      </actions>
    </cue>
  </cues>
</mdscript>
```

`t/0001-l044.xml`, with the page id the extension owns:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example Terraforming" descr="Texts of the example_terraforming extension">
    <t id="1">Plant Orchards</t>
    <t id="2">Rows of fruit trees on terraced slopes, tended by drones. Slow to bear, but they feed the people and the air alike.</t>
  </page>
</language>
```

Some points about the example:

- **The entry is inert until added.** The diff puts the project in the catalogue; the cue adds it to every world vanilla has initialised, which are the clusters in the group its own script keeps, and skips the ones that already have it. Checking every few minutes covers a new game, a loaded game, and a world that is set up later.
- **The Xenon guard** keeps the project off the Xenon world, which vanilla keeps in the same group. `exists` on a stat is true where the stat is dynamic or has been set, and `xenon_alertness` is set on that one world alone. The project's own conditions would not keep it out: a stat nobody set reads as its `default`, and the defaults of temperature and humidity are temperate states.
- **The predecessor is stated by the script**, not in the file. A group predecessor is satisfied by any one project of the group; `any="false"` on the `<predecessor>` would demand all of them.
- **The price is the total.** The three amounts are shares: for every two drone components the engine budgets fifty water and a hundred wheat, scaled until the whole lot is worth the price at maximum prices.
- **The rebate is for later projects**, not this one. It takes effect once the orchards are complete.
- **The texts** use the extension's own page; the vanilla project texts live on page 20227 and the stat and group names on page 1001.
- **A later change** to the entry wants `version="2"`: a world that already holds the project takes the new values only when the version rises.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[stats.xml](/x4/modding-support/anatomy-of-game-data/libraries/stats-xml/) holds the terraforming statistics the script counts up; [missiongroups.xml](/x4/modding-support/anatomy-of-game-data/libraries/missiongroups-xml/) has the `terraforming` group under which the world missions are listed.

[↑ Contents](#toc)
