---
title: Resource areas
description: How version 9.00 defines the resources miners gather - yield definitions in regionyields.xml, the areas each sector gets in mapdefaults.xml, what regions still do, depletion and respawn, and how an extension and a script add or change them.
order: 10
---

# Resource areas

Since version 9.00, what miners gather in a sector comes from **resource areas**: spheres of a given size that each hold one ware, a fixed total yield and a gather speed. A sector lists how many areas of each kind it has, the game places them inside the sector, and an area that is mined empty comes back after a delay at a new random position. In 8.00 the resources belonged to the regions themselves, the asteroid fields and nebulae placed in a cluster; in 9.00 the regions no longer hold any yield, and only decide where in the sector the areas of each ware are placed and, for asteroid wares, whether an area can be mined at all.

This article covers the files involved, how they fit together and the script side. It describes version 9.00. It builds on an explanation of the new layout shared by **Entissus** on Discord.

Adding or changing resources from an extension needs [Yield definitions](#yield-definitions), [Areas per sector](#areas-per-sector) and [From an extension](#from-an-extension). The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Resource ware**: a ware that ships gather from space: `ore`, `silicon`, `ice` and `nividium` (solids, mined from rocks), `hydrogen`, `helium` and `methane` (gases, collected from a volume), and `rawscrap` and `rawkhaakscrap` (salvage).
- **Resource area**: one sphere in a sector holding one resource ware. It has a total yield, a gather speed and a star rating, and it is what mining orders look for.
- **Yield definition**: the recipe for a kind of resource area, named by an ID such as `sphere_large_helium_high_slow`. It comes from `libraries/regionyields.xml`.
- **Region**: a volume placed in a cluster that fills space with asteroids, nebula fog, debris and other objects. Regions are defined in `libraries/region_definitions.xml` and placed in a cluster's macro in `maps/xu_ep2_universe/clusters.xml` (a DLC has its own map files).
- **Map defaults**: `libraries/mapdefaults.xml`, the balancing data per cluster and sector: names, music, sunlight, economy, and since 9.00 the resource areas.

[↑ Contents](#toc)

## What changed from 8.00

In 8.00 a region carried its resources directly:

```xml
<region name="p1_40km_asteroid_field" density="4.5" rotation="0">
  <boundary class="cylinder">
    <size r="25000" linear="5000" />
  </boundary>
  <fields>
    <asteroid groupref="asteroid_ore_l" densityfactor="2.75" ... />
    ...
  </fields>
  <resources>
    <resource ware="ore" yield="medium" />
    <resource ware="silicon" yield="medium" />
  </resources>
</region>
```

The `yield` named a level from `libraries/regionyields.xml`, which set a resource density and a replenish time per ware. The whole volume of the region was the resource, and it refilled in place.

In 9.00:

- The `<resources>` element is gone from regions. The same `p1_40km_asteroid_field` region still exists with the same fields; its asteroids now mark where ore, silicon and nividium areas may be placed and make them mineable, while the total yield comes from the areas.
- `libraries/regionyields.xml` is a different file: it no longer lists levels per ware but builds yield definitions out of four parts; see [Yield definitions](#yield-definitions).
- Each sector's dataset in `libraries/mapdefaults.xml` lists its resource areas; see [Areas per sector](#areas-per-sector).
- A depleted area does not refill in place. It stays empty for a while and then comes back full somewhere else in the sector; see [Depletion and respawn](#depletion-and-respawn).
- Ore, silicon and ice asteroids carry ten times the yield per rock they had in 8.00, and nividium asteroids were rebalanced on their own (`libraries/regionobjectgroups.xml`).
- Scripts gain a `resourcearea` value and the actions around it; see [The script side](#the-script-side).

An 8.00 extension that adds `<resources>` to a region, or patches the old `regionyields.xml`, has to be rewritten for 9.00 rather than updated.

[↑ Contents](#toc)

## How the parts fit together

Three questions, three places:

1. **What kinds of area exist?** `libraries/regionyields.xml` defines sizes, yield levels and gather speeds, and every combination of them with a resource ware is a yield definition.
2. **How many of each does a sector get?** The sector's dataset in `libraries/mapdefaults.xml` lists yield definitions with an amount each, and a box, `<resourcebounds>`, that the areas stay in.
3. **Where do they go?** Regions from `libraries/region_definitions.xml`, placed in `clusters.xml`, are where the areas of a ware are placed: at regions whose asteroids carry that ware, or whose nebula fields name it in `resources`. They also provide the asteroid fields and gas clouds that ships see and fly through.

So an area of a ware lands both inside the sector's resource bounds and where it overlaps a region that holds the ware. A sector that lists hydrogen areas needs a region with a hydrogen field, and a sector that lists ore areas needs a region with ore asteroids.

[↑ Contents](#toc)

## Where areas are placed

In a running game, the areas of a sector show the pattern clearly:

- In Grand Exchange III every hydrogen, helium and methane area sits at its own 40 km gas field (`p1_40km_hydrogen_field`, `p1_40km_helium_field`, `p1_40km_methane_field`), and one more hydrogen area sits at the wreck field region whose fog carries `resources="hydrogen"`. None of them is anywhere else in the sector's 740 km wide resource bounds.
- Ore, silicon and ice areas sit along the regions whose asteroid groups carry those wares, such as the long spline-tube belts of Grand Exchange I and III.
- Saturn 2 has a single region, the planet's ring: 2 km thick, far wider than the sector, and tilted by about 27 degrees. Its ore, silicon, ice and gas areas all sit within a few kilometres of the ring's plane, which is why they look spread over the full 300 km height of that sector's resource bounds.

Area centres stay inside `<resourcebounds>`, give or take about 10 km.

### Solid wares need an overlapping region

An area of ore, silicon, ice or nividium is mineable only where its sphere overlaps a region that has asteroids of that ware. The overlap is with the region's actual volume, rotation included, not with a box around it. The game places its own areas so that they do. An area that does not, such as one a script creates in empty space, still exists, but it holds nothing a ship can mine: a mining order there ends at once with an empty hold.

The game reports such an area in its log when the area is created:

```text
No overlap between <definition> resource area at Pos(...) and any compatible region in <sector>
No yield density in overlap between <definition> resource area at Pos(...) and any compatible region in <sector>
```

The first means no region of the ware reaches the area at all. The second means the overlapping region names the ware but has no rocks of it, for example a field that only carries `resources="ore"`. Inside a region with the right asteroids, an area created by a script is mined just like the ones the game places.

### Gases do not

An area of hydrogen, helium or methane needs no region to be mined. A gas area that a script creates hundreds of kilometres from any region logs nothing and fills a miner's hold normally, and a methane area in Saturn 2 is mined although no region there carries methane. The game still places its own gas areas at regions that carry the gas, so a sector with gas areas still needs those regions.

### Checking a sector

The log lines above are the quickest check of a new or changed sector: a solid area the game cannot fill shows up there, while the area itself still appears to scripts and to mining orders looking for resources. Since miners go where the areas overlap the asteroids, the visible asteroid fields are also where they work.

[↑ Contents](#toc)

## Yield definitions

`libraries/regionyields.xml` has four lists. Three of them are parts that combine into IDs:

```xml
<regionyields>
  <boundaries>
    <boundary id="sphere_large" class="sphere">
      <size r="100000"/>
    </boundary>
    ...
  </boundaries>
  <yields>
    <yield id="high" tag="high" scaneffect="scfx_dynamic_highyield_01" scaneffectamount="4" scaneffectintensity="1.0">
      <ware id="helium" yield="1000000" respawndelay="120" />
      ...
    </yield>
    ...
  </yields>
  <gatherspeeds>
    <gatherspeed id="slow" factor="0.5" rating="6" />
    ...
  </gatherspeeds>
  <definitions>
  </definitions>
</regionyields>
```

The ID of a yield definition is `<boundary>_<ware>_<yield>_<gatherspeed>`. `sphere_large_helium_high_slow` is the `sphere_large` boundary, the `helium` entry of the `high` yield and the `slow` gather speed. No file lists that ID by name: every combination of a boundary, a ware listed under a yield, and a gather speed exists.

### Boundaries

The size and shape of the area. Vanilla has five spheres:

| ID | Radius |
| --- | --- |
| `sphere_tiny` | 20 km |
| `sphere_small` | 30 km |
| `sphere_medium` | 50 km |
| `sphere_large` | 100 km |
| `sphere_huge` | 200 km |

The schema also accepts `box`, `cylinder` and `splinetube` boundaries, a position and rotation offset, and `invert="true"` for a boundary that cuts a hole into the others.

### Yields

How much the area holds and how long it stays away after it is emptied. Each `<yield>` lists the wares it applies to, so a ware missing from a yield level has no definitions at that level.

| Yield | Most wares: yield | Respawn delay | Nividium: yield | Respawn delay |
| --- | --- | --- | --- | --- |
| `verylow` | 5,000 | 20 min | 500 | 90 min |
| `low` | 50,000 | 40 min | 1,000 | 150 min |
| `medium` | 200,000 | 60 min | 5,000 | 210 min |
| `high` | 1,000,000 | 120 min | 10,000 | 360 min |
| `veryhigh` | 2,000,000 | 180 min | 50,000 | 480 min |

"Most wares" is ore, silicon, ice, the three gases, `rawscrap` and `rawkhaakscrap`.

- `yield` on a `<ware>` is the total amount in the area, in units of the ware: a `verylow` ore area gives exactly 5,000 ore before it is empty.
- `respawndelay` is the time in game minutes, after the area is depleted, before it comes back at a random location. The default is 0; `-1` stops it from coming back.
- `tag` on a `<yield>` is matched against a region's `<allowedyields>`; see [Regions](#regions).
- `scaneffect`, `scaneffectamount` and `scaneffectintensity` set how the area looks in a resource scan (the effect from `libraries/effects.xml`, how many, and how strong).

### Gather speeds

| ID | Factor | Rating | Stars |
| --- | --- | --- | --- |
| `veryslow` | 0.2 | 3 | 1 |
| `slow` | 0.5 | 6 | 2 |
| `average` | 1.0 | 9 | 3 |
| `fast` | 2.0 | 12 | 4 |
| `veryfast` | 5.0 | 15 | 5 |

- `factor` scales the yield each rock holds, for solid wares, or how fast a ship collects, for gases.
- `rating` is the star rating of the area times 3, from 0 to 15. The stars shown for an area come from its gather speed, not from its total yield.

So the last two words of an ID say different things: `high_slow` is a large total that is slow to gather, `low_fast` a small total that is quick to gather. The respawn delay comes with the yield level.

### Explicit definitions

`<definitions>` is empty in vanilla. The schema allows a definition written out in full, with its own `id`, `ware`, `yield`, `factor`, `respawndelay`, `rating`, `tag`, scan effect and `<boundary>`, plus `randompitch`, `randomyaw` and `randomroll` to rotate it on spawn. This is the form for a one-off area that the combinations do not cover, such as a cylinder of a particular size.

```xml
<add sel="/regionyields/definitions">
  <definition id="myext_ore_quick" ware="ore" yield="1000" factor="1.0" respawndelay="1" rating="9" tag="verylow">
    <boundary class="sphere">
      <size r="20000" />
    </boundary>
  </definition>
</add>
```

Its `id` is used like any composed ID, for example in `create_resource_area yieldname="'myext_ore_quick'"`. The area it makes behaves like the others: it holds exactly its `yield`, needs a region with ore asteroids, and comes back `respawndelay` minutes after it is emptied, here after one minute.

[↑ Contents](#toc)

## Areas per sector

A sector's dataset in `libraries/mapdefaults.xml` lists its areas in `<resourceareas>`. Grand Exchange I:

```xml
<!--Grand Exchange I-->
<dataset macro="Cluster_01_Sector001_macro">
  <properties>
    <identification name="{20004,10011}" description="{20004,10012}" />
    <resourceareas>
      <resourcearea amount="3" ref="sphere_large_hydrogen_high_slow" />
      <resourcearea amount="4" ref="sphere_medium_hydrogen_medium_average" />
      <resourcearea amount="4" ref="sphere_large_ore_high_slow" />
      <resourcearea amount="4" ref="sphere_small_ore_medium_average" />
      <resourcearea amount="4" ref="sphere_tiny_ore_low_fast" />
      ...
      <resourcearea amount="1" ref="sphere_small_nividium_verylow_slow" />
    </resourceareas>
    <area sunlight="1.23" economy="0.5" security="0.25" tags="allowrandomanomaly"/>
  </properties>
</dataset>
```

- `ref` is a yield definition ID.
- `amount` is how many areas of that definition the sector has.

The usual pattern in vanilla is a few large areas with a high yield and a slow gather speed, more medium ones, and small fast ones: a choice between waiting for a big deposit and taking quick small loads.

### Resource bounds

The areas are spawned inside a box around the sector's centre, `<resourcebounds>`:

```xml
<resourcebounds>
  <center y="-200000" />
  <max x="300000" y="50000" z="300000" />
</resourcebounds>
```

- `<center>` is the middle of the box relative to the sector, 0 by default.
- `<max>` holds the **half** edge lengths.

A sector without its own `<resourcebounds>` gets the default from the `sector` dataset in `libraries/defaults.xml`: `max x="300000" y="50000" z="300000"`, a box 600 km across and 100 km tall. A few vanilla sectors change it, for example a wider box in Grand Exchange III, a box moved 200 km down in a Split sector, and a taller one at Saturn.

A region or station far from the sector's centre lies outside the default box. A sector whose content sits off-centre needs its own `<resourcebounds>` for the areas to land near it.

[↑ Contents](#toc)

## Regions

Regions in 9.00 are what they were, minus `<resources>`: a boundary, a falloff and `<fields>` of asteroids, nebulae, fog, debris and effects. They are placed as connections of a cluster macro:

```xml
<connection name="C01S01_Region004_connection" ref="regions">
  <offset>
    <position x="106698.35" y="0" z="-73481.35" />
  </offset>
  <macro name="C01S01_Region004_macro">
    <component connection="cluster" ref="standardregion" />
    <properties>
      <region ref="p1_40km_hydrogen_field" />
    </properties>
  </macro>
</connection>
```

The region's resource-related parts that remain:

- **Asteroid groups** in `libraries/regionobjectgroups.xml` set `resource` and `yield` per group, such as `asteroid_ore_l` with `resource="ore"` and a base yield per rock. An `<asteroid groupref="asteroid_ore_l" .../>` field fills the region with those rocks.
- **Field attributes**: `resources`, `yield`, `replenishtime` and `gatherspeedfactor` on a field, and `resourcepercentage` and `yieldvariation` on an object field such as `<asteroid>`. Vanilla 9.00 uses `resources` on its gas nebula fields (`resources="hydrogen"` and so on), and that is what places gas areas of the ware at the region. For a solid ware, `resources` alone is not enough: the area needs asteroids of the ware in the overlap; see [Where areas are placed](#where-areas-are-placed). The other attributes appear almost nowhere.
- **`<allowedyields>`**, new in 9.00, after `<fields>`:

```xml
<allowedyields>
  <yield ware="ore" tags="low medium" />
</allowedyields>
```

The schema describes it as the yields allowed in the region: for the ware named, only yield definitions whose yield level carries one of the tags, and a ware not listed has no restriction. Vanilla does not use it; the `tag` of each vanilla yield level is the same as its ID.

It does not limit what a script creates. In a region that allows only `low` ore, `create_resource_area` with `sphere_tiny_ore_high_average` logs no message, and a miner fills its hold there just as in the same region without `<allowedyields>`. Whether it limits where the game places its own areas was not tested.

[↑ Contents](#toc)

## Depletion and respawn

Ships take ware out of an area until its yield is gone. The last load is capped at what is left, so the total mined is exactly the definition's `yield`.

A mining order reserves part of the area's yield before it starts, one full hold of the ship, with `add_yield_reservation`, and releases it with `remove_yield_reservation`. An area accepts only as many miners as its remaining yield can cover: a `verylow` area of 5,000 takes six medium miners with 980-unit holds, and a seventh mining order there ends at once with an empty hold. A small area does not support a large fleet, however close it is.

Once the yield is gone:

- the area still exists as a script value, but holds nothing more;
- mining orders looking for resources no longer find it (they also pass it over while the reservations of other miners cover what is left);
- a collecting ship whose area no longer exists stops with the result `noresourcearea`.

After the yield level's `respawndelay`, in game minutes, the same area comes back, full, at a new random position, again inside the resource bounds and overlapping a region that holds the ware. It keeps its definition: the same size, total yield and gather speed. It does not refill where it was, and the game logs nothing when it comes back. A script that kept the area in a variable sees the area at its new position. Because the same area returns rather than a new one being made, a sector keeps the number of areas it had.

[↑ Contents](#toc)

## From an extension

`libraries/mapdefaults.xml` is a collection of datasets: the DLCs ship a whole `libraries/mapdefaults.xml` holding only the datasets of their own sectors, and the game adds them to the base file's. Changing an existing dataset, or anything in `libraries/regionyields.xml`, needs a diff file. See [How a file joins the game](/x4/modding-support/anatomy-of-an-extension/#how-a-file-joins-the-game).

### Changing a vanilla sector

Replace the sector's list, or add to it:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <replace sel="//dataset[@macro='Cluster_01_Sector001_macro']/properties/resourceareas">
    <resourceareas>
      <resourcearea amount="2" ref="sphere_huge_ore_veryhigh_slow" />
      <resourcearea amount="6" ref="sphere_small_silicon_medium_fast" />
    </resourceareas>
  </replace>
  <add sel="//dataset[@macro='Cluster_01_Sector002_macro']/properties/resourceareas">
    <resourcearea amount="2" ref="sphere_medium_methane_medium_average" />
  </add>
</diff>
```

A sector that has no `<resourceareas>` yet needs the whole element added under its `properties`.

### A new sector

A new sector's dataset carries its own `<resourceareas>`, and `<resourcebounds>` when its content is not around the centre. A whole file in the extension's `libraries/mapdefaults.xml` is enough, as in the DLCs:

```xml
<?xml version="1.0" encoding="utf-8"?>
<defaults>
  <dataset macro="myext_cluster_01_sector001_macro">
    <properties>
      <identification name="{1234567,101}" description="{1234567,102}" />
      <resourceareas>
        <resourcearea amount="3" ref="sphere_large_ice_high_slow" />
        <resourcearea amount="4" ref="sphere_small_ice_medium_average" />
      </resourceareas>
      <resourcebounds>
        <center x="150000" />
        <max x="150000" y="30000" z="150000" />
      </resourcebounds>
    </properties>
  </dataset>
</defaults>
```

Each ware listed needs a region in the sector that provides it, inside the resource bounds: asteroids of that ware for a solid, a nebula field with `resources` naming it for a gas. The regions are placed in the cluster's macro; see [Where areas are placed](#where-areas-are-placed).

### A new kind of area

Adding a part to `libraries/regionyields.xml` creates every combination with it. A new boundary:

```xml
<add sel="/regionyields/boundaries">
  <boundary id="sphere_giant" class="sphere">
    <size r="300000"/>
  </boundary>
</add>
```

makes `sphere_giant_ore_high_slow`, `sphere_giant_helium_low_fast` and the rest available to `mapdefaults.xml`. A new yield level or gather speed works the same way. A change to an existing part, such as the yield of `high` for ore, changes every definition that uses it in every sector, vanilla's included.

The game reads these files when it starts. A changed `regionyields.xml` or `mapdefaults.xml` takes effect only after the game is closed and started again; loading a save in the running game is not enough, and a script that names a new definition until then gets `Could not find region yield with name '...'` in the log.

A save keeps the areas it already has. An entry added to a sector's `<resourceareas>` does not appear in an existing game, even after a restart; a new game places it along with the sector's other areas. A changed yield definition applies to the areas made after the restart, a new game's included, but not to an area a save already has: that area keeps the amount it was saved with. To put new areas into a running game, a script creates them with `create_resource_area`; see [The script side](#the-script-side).

[↑ Contents](#toc)

## The script side

A resource area is a script value of its own, `resourcearea`, with these properties:

- `exists`: true while the area is there, also while it is depleted and waiting to come back.
- `position`: its position in the sector.
- `isdetectedby.{$faction}`: whether the faction's resource probes have found it. Probes only detect an area; they do not change what it holds or how fast it is mined.
- `hasreservationfor.{$ship}`: whether the ship holds a yield reservation in it.

Actions:

- `create_resource_area yieldname="'sphere_tiny_nividium_high_average'" sector="$sector" result="$area"`, with optional `<position>` and `<rotation>` children: creates an area from a yield definition, centred exactly at the given position. It always returns an area; whether a solid one can be mined depends on the region it overlaps, see [Solid wares need an overlapping region](#solid-wares-need-an-overlapping-region). The Timelines mining scenarios use it to seed their sectors.
- `find_resource_area ware refobject name`, with `minrating`, `bestrating` and `canpickup`, `cantow` or `candismantle`: finds the area at an object's position, if there is one.
- `find_closest_resource`: the search mining orders use; new in 9.00, it also returns the area it found in `resourcearea`, next to the `sector` and `position`.
- `add_yield_reservation` and `remove_yield_reservation`, both with `resourcearea` and `reserver`, new in 9.00: claim or release an area for a ship.

`get_highest_resource_yield` from 8.00 no longer exists. `get_resource_gatherrate` remains, but it is no measure of an area: its result depends on the reference ship, changes between calls, ignores how much is left, and reads 0 for an area that has just come back full. Whether an area can be mined is only settled by mining it.

The vanilla users are `aiscripts/order.mining.routine.xml`, `order.mining.player.xml`, `order.mining.collect.ship.xml` and the `order.salvage.*` scripts.

[↑ Contents](#toc)
