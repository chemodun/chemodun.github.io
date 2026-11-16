---
title: Sector layout in a cluster
description: How the map arranges the sectors of a cluster that holds more than one - the fixed positions, the rules for two, three and four sectors, which sector counts as the first when two of them share a coordinate, and how to choose the offsets of a new cluster.
wiki: Sector layout in a cluster
wikiRef: also
---

<!-- Canonical copy; the Egosoft wiki page is exported from it -->

# Sector layout in a cluster

A cluster with one sector is drawn on the map as a single hexagon. A cluster with two, three or four sectors is drawn as the same hexagon with smaller sector hexagons inside it, and their places do not follow the distances written in the map files. The map takes only which sector lies to which side of the others, and puts each one on one of a few fixed positions. Where two sectors share a coordinate, the decision falls to the names of their connections, which is why two clusters with identical offsets can look different on the map.

This article describes those rules as version 9.00 applies them. It is for anyone adding a cluster or a sector to the map, and for tools that draw the map from the game files. The extension side, adding a cluster or patching an existing one with a diff file, is covered in [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/), and the place of the map files among the game data in [Anatomy of game data](/x4/modding-support/anatomy-of-game-data/).

Every rule below was checked in the game with a small extension that adds seventeen test clusters, each built to show one rule. Its files, the full list of tests and a download are in [The test extension](#the-test-extension); the screenshots in the sections below come from it.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Where the offsets come from

A cluster macro in `maps/xu_ep2_universe/clusters.xml` lists its sectors as connections with `ref="sectors"` (each expansion brings its own clusters file). Each connection may carry an offset, the position of the sector inside the cluster; a connection without one sits at the cluster's origin:

```xml
<macro name="Cluster_19_macro" class="cluster">
  <component ref="standardcluster" />
  <connections>
    <connection name="Cluster_19_Sector001_connection" ref="sectors">
      <macro ref="Cluster_19_Sector001_macro" connection="cluster" />
    </connection>
    <connection name="Cluster_19_Sector002_connection" ref="sectors">
      <offset>
        <position x="112672928" y="0" z="0" />
      </offset>
      <macro ref="Cluster_19_Sector002_macro" connection="cluster" />
    </connection>
    ...
```

The layout uses only `x` and `z`. On the map `x` grows to the right and `z` grows upwards; `y` plays no part. The size of the offsets plays no part either: a sector a few kilometres to the right of another counts exactly as one far to the right.

[↑ Contents](#toc)

## The positions

The map has a layout for one to four sectors in a cluster. The smaller hexagons sit on fixed positions around the centre of the cluster's hexagon:

```none
           upper left      upper right

     left             centre             right

           lower left      lower right
```

The six outer positions are at the same distance from the centre, sixty degrees apart. One sector fills the whole hexagon, two or three sectors are drawn at half size, and four at a smaller size again, with a layout of their own described below.

[↑ Contents](#toc)

## One sector

The sector is drawn at the centre, at full size, wherever its offset puts it.

[↑ Contents](#toc)

## Two sectors

Two sectors always take two opposite corners: upper right and lower left, or upper left and lower right. They are not placed side by side or one above the other.

The first sector is compared with the second (which one is the first: [Which sector comes first](#which-sector-comes-first)):

- If the first sector's `x` is greater, it goes to the right; otherwise to the left.
- If the first sector's `z` is greater, it goes up; otherwise down.
- The second sector takes the opposite corner.

When both coordinates differ, the order does not matter: the sector with the greater `x` is on the right and the one with the greater `z` is on top. The order matters only on a tie. With equal `x` the first sector goes to the left, and with equal `z` it goes down.

Hewa's Twin shows the tie at work. The base game has two clusters of that name with identical offsets: in each, the second sector lies straight along `x` from the first, at the same `z`.

| Cluster | Sectors | First | Result |
| --- | --- | --- | --- |
| `Cluster_19_macro` | Hewa's Twin I (`Sector001`), Hewa's Twin II (`Sector002`) | `Sector001` | I lower left, II upper right |
| `Cluster_42_macro` | Hewa's Twin III (`Sector001`), Hewa's Twin IV The Cove (`Sector002`) | `Sector002` | IV lower right, III upper left |

In both clusters the sector further along `x` ends up on the right. The equal `z` sends the first sector down, and the first sector is a different one in each cluster.

<figure>
  <img src="/sector-layout-in-a-cluster/hewas-twin.png" alt="The map with the two Hewa's Twin clusters side by side: in the left one Hewa's Twin I is at the lower left and Hewa's Twin II at the upper right, in the right one Hewa's Twin III is at the upper left and Hewa's Twin IV The Cove at the lower right">
  <figcaption>The two Hewa's Twin clusters. Their offsets are identical, but the first sector differs, so the pairs take opposite diagonals.</figcaption>
</figure>

The test clusters T1 to T4 repeat this with nothing else in play. In T1 and T2 the second sector lies 50 km along `x` from the first, in T3 and T4 50 km along `z`. Only the first sector changes between the two clusters of each pair, and the pair swaps its diagonal.

<figure>
  <img src="/sector-layout-in-a-cluster/test-two-sectors-tie.png" alt="Four test clusters. T1: T1 S1 lower left, T1 S2 upper right. T2: T2 S1 upper left, T2 S2 lower right. T3: T3 S1 lower left, T3 S2 upper right. T4: T4 S2 upper left, T4 S1 lower right">
  <figcaption>T1 and T2 (equal z) and T3 and T4 (equal x). S1 is first in T1 and T3, S2 in T2 and T4.</figcaption>
</figure>

Without a tie the order makes no difference, however small the gap: in T5 and T6 the second sector is 1 km to the right and 1 km below the first, and both clusters come out the same although their first sectors differ. A difference in `y` alone counts as a tie on both axes: in T13 and T14 the sectors differ only in `y`, and the first sector takes the lower left corner.

<figure>
  <img src="/sector-layout-in-a-cluster/test-two-sectors-no-tie.png" alt="Four test clusters. T5 and T6: S1 upper left, S2 lower right in both. T13: T13 S1 lower left, T13 S2 upper right. T14: T14 S2 lower left, T14 S1 upper right">
  <figcaption>Top: T5 (S1 first) and T6 (S2 first), 1 km apart, the same layout. Bottom: T13 (S1 first) and T14 (S2 first), apart only in y.</figcaption>
</figure>

[↑ Contents](#toc)

## Three sectors

The three sectors are sorted by `z`, lowest first; sectors with equal `z` stay in their [first-to-last order](#which-sector-comes-first). The lowest one goes to the bottom and the highest to the top, both on the same side, and the middle one goes to the centre of the other side:

- If the middle sector's `x` is below the average `x` of all three, it goes to the left, and the other two take lower right and upper right.
- Otherwise it goes to the right, and the other two take lower left and upper left.

Grand Exchange is an example. Grand Exchange I sits at the cluster's origin, Grand Exchange III lies a little above it and well to the left, and Grand Exchange IV far above and to the right. By `z` the order is I, III, IV. III is left of the average `x` of the three, so it goes to the left, I to the lower right and IV to the upper right.

<figure>
  <img src="/sector-layout-in-a-cluster/grand-exchange.png" alt="The Grand Exchange cluster on the map: Grand Exchange III at the left, Grand Exchange IV at the upper right and Grand Exchange I at the lower right">
  <figcaption>Grand Exchange: the middle sector by height, III, takes the left side, and the lowest and highest sectors share the right.</figcaption>
</figure>

In the test clusters T7 and T8, S1 and S2 share the lowest `z` and S3 is above them. The sort keeps the tied pair in its first-to-last order, so the first of them becomes the lowest sector and the second the middle one: the same offsets give two different layouts. In T9 the middle sector's `x` is exactly the average of the three, which is not below it, so it goes to the right.

<figure>
  <img src="/sector-layout-in-a-cluster/test-three-sectors.png" alt="Three test clusters. T7: T7 S3 upper left, T7 S2 right, T7 S1 lower left. T8: T8 S3 upper right, T8 S1 left, T8 S2 lower right. T9: T9 S3 upper left, T9 S2 right, T9 S1 lower left">
  <figcaption>T7 (S1 before S2), T8 (S2 before S1) and T9 (middle x equal to the average).</figcaption>
</figure>

[↑ Contents](#toc)

## Four sectors

The four sectors are sorted by `x`, and drawn smaller than two or three. The one with the lowest `x` goes to the left and the one with the highest to the right. The other two go above and below the centre, and their heights do not decide which is which. The first of them, the one with the lower `x`, is compared with itself: if its `x` is less than its own `z`, it goes above the centre, otherwise below, and the other one takes the remaining place.

So a sector can be drawn below its partner while lying above it. In T10 the second sector by `x` sits at `x` 60 km, `z` 40 km, and its partner at `z` -20 km; 60 is not less than 40, so the higher sector goes below. T16 moves that sector to `z` 80 km and it goes above; T15 and T17 show the same at `x` 10 km with `z` 40 km and 5 km.

<figure>
  <img src="/sector-layout-in-a-cluster/test-four-sectors.png" alt="Five test clusters, each with S1 on the left and S4 on the right. T10: S3 above, S2 below. T11: S3 above, S2 below. T15: S2 above, S3 below. T16: S2 above, S3 below. T17: S3 above, S2 below">
  <figcaption>T10, T11 and T15 (top), T16 and T17 (bottom). Whether S2 goes above depends only on its own x and z.</figcaption>
</figure>

To place the middle pair on purpose, give the one with the lower `x` a `z` greater than its `x` to put it above, or a smaller one to put it below. No cluster of the base game or its expansions has four sectors.

[↑ Contents](#toc)

## Five sectors or more

The map has no layout for five sectors or more. The game writes `UniverseMapBehavior::InitSectorPositions() too many sectors in cluster` and the cluster macro's name to its log once, draws the cluster's hexagon with no sectors in it, and runs on. The sectors exist and can be found by scripts, but they have no place on the map to select or focus.

<figure>
  <img src="/sector-layout-in-a-cluster/test-five-sectors.png" alt="Two test clusters side by side: T12 on the left, an empty hexagon; T13 on the right, with its two sector hexagons">
  <figcaption>T12 with five sectors (left) stays empty; T13 next to it shows its two sectors.</figcaption>
</figure>

[↑ Contents](#toc)

## Which sector comes first

The sectors of a cluster are kept in a fixed order: the order in which a new game creates them, which a save keeps from then on. It is not the order of the connections in the file. It comes from a key computed from each sector connection's `name`, in lowercase, and the connection with the lowest key comes first. The position of the connection in the file, the sector macro's name and the extension that adds the connection make no difference. The clusters inside the galaxy are kept in the same kind of order, keyed on their own connection names.

The key is a 64-bit number built from the bytes of the lowercase name. It starts at `0x811C9DC5`; for each byte it is multiplied by `0x01000193`, the result is cut to 64 bits, and the byte is combined into it with exclusive or. A byte above 127 counts as negative, so its sign is extended to 64 bits first. The same steps in Python:

```python
def connection_key(name):
    key = 0x811C9DC5
    for byte in name.lower().encode('utf-8'):
        if byte > 127:
            byte -= 256
        key = ((key * 0x01000193) ^ byte) & 0xFFFFFFFFFFFFFFFF
    return key

# the sectors in order, first one first
sectors.sort(key=lambda sector: connection_key(sector.connection_name))
```

The keys of the Hewa's Twin connections, to check an implementation against:

| Connection name | Key |
| --- | --- |
| `Cluster_19_Sector001_connection` | `0xBA57D450841053B7` |
| `Cluster_19_Sector002_connection` | `0xBB625882080C357E` |
| `Cluster_42_Sector001_connection` | `0x3EE44DBE87FB0B43` |
| `Cluster_42_Sector002_connection` | `0x38342E8E25512D9A` |

In `Cluster_19_macro` the key of `Sector001` is the lower one, so it comes first; in `Cluster_42_macro` it is `Sector002`.

[↑ Contents](#toc)

## Choosing offsets

- Place the sectors so that each pair differs in both `x` and `z`. The layout then follows from the offsets alone, and a renamed connection cannot change it. Only the side matters, so a small difference, such as a kilometre, is enough.
- Two sectors cannot be shown side by side or one above the other: they always take a diagonal. For a vertical or horizontal arrangement, the cluster needs a third sector.
- Where two sectors share a coordinate on purpose, as many base game clusters do, compute the keys of their connection names to know which sector is first.
- A sector added to an existing cluster from an extension takes its place in the order by its connection name, not by where the diff file inserts it.
- Keep a cluster to four sectors at most: a fifth one removes all of them from the map.

[↑ Contents](#toc)

## The test extension

**Download: [sector-layout-test.zip](/sector-layout-in-a-cluster/sector-layout-test.zip)** (7 KB) - the extension the screenshots in this article were taken with, for version 9.00.

Unpack it into the game's `extensions/` folder and start a new game. The seventeen test clusters lie to the right of the known galaxy, in four rows: T1 to T4 at the top, then T5 to T8, then T9, T10, T11 and T15, and T12, T13, T14, T16 at the bottom, with T17 below T12. A script marks them and their sectors as known at the start, so they are on the map at once. Each cluster is named `SLT T1`, `SLT T2` and so on, with a description of what it tests, and each sector `T1 S1`, `T1 S2` and so on. Started with `-debug all -logfile debuglog.txt`, the game also writes one `SectorLayoutTest:` line per cluster to the log, listing its sectors first to last with their offsets.

### The tests

Offsets are `x`, `z` in kilometres. "First" is the sector that comes first in the [first-to-last order](#which-sector-comes-first); a dash means the order plays no part.

| Test | Sectors | First | On the map |
| --- | --- | --- | --- |
| T1 | S1 (0, 0), S2 (50, 0) | S1 | S1 lower left, S2 upper right |
| T2 | as T1 | S2 | S1 upper left, S2 lower right |
| T3 | S1 (0, 0), S2 (0, 50) | S1 | S1 lower left, S2 upper right |
| T4 | as T3 | S2 | S2 upper left, S1 lower right |
| T5 | S1 (0, 0), S2 (1, -1) | S1 | S1 upper left, S2 lower right |
| T6 | as T5 | S2 | S1 upper left, S2 lower right |
| T7 | S1 (0, 0), S2 (50, 0), S3 (20, 50) | S1 before S2 | S1 lower left, S2 right, S3 upper left |
| T8 | as T7 | S2 before S1 | S2 lower right, S1 left, S3 upper right |
| T9 | S1 (0, 0), S2 (30, 20), S3 (60, 40) | - | S1 lower left, S2 right, S3 upper left |
| T10 | S1 (0, 0), S2 (60, 40), S3 (90, -20), S4 (150, 10) | - | S1 left, S4 right, S3 above, S2 below |
| T11 | S1 (0, 0), S2 (60, -20), S3 (90, 40), S4 (150, 10) | - | S1 left, S4 right, S3 above, S2 below |
| T12 | five sectors | - | an empty hexagon |
| T13 | S1 (0, 0), S2 (0, 0) and 10 km higher in `y` | S1 | S1 lower left, S2 upper right |
| T14 | as T13 | S2 | S2 lower left, S1 upper right |
| T15 | S1 (-100, 0), S2 (10, 40), S3 (90, -20), S4 (150, 10) | - | S1 left, S4 right, S2 above, S3 below |
| T16 | S1 (0, 0), S2 (60, 80), S3 (90, -20), S4 (150, 10) | - | S1 left, S4 right, S2 above, S3 below |
| T17 | S1 (-100, 0), S2 (10, 5), S3 (90, -20), S4 (150, 10) | - | S1 left, S4 right, S3 above, S2 below |

In every cluster the first-to-last order the game created the sectors in, as the log lines show it, matched the keys computed from the connection names.

### The files

| File | What it holds |
| --- | --- |
| `content.xml` | The extension's description. |
| `maps/xu_ep2_universe/galaxy.xml` | A diff file that adds one connection per test cluster to the galaxy macro. |
| `maps/xu_ep2_universe/slt_clusters.xml` | The cluster macros, each listing its sectors with their offsets. |
| `maps/xu_ep2_universe/slt_sectors.xml` | The sector macros: nothing but the standard sector component. |
| `index/macros.xml` | One entry per new macro, telling the game which file holds it. |
| `libraries/mapdefaults.xml` | A diff file with the names and descriptions. |
| `md/sector_layout_test.xml` | The script that reveals the clusters and writes the log lines. |
| `gen_layout.py` | Not used by the game: the Python script that wrote the map, index and map defaults files from a list of tests. |

The script picks the connection names. Where a test needs a particular sector first, it tries the names `Cluster_SLT01_Sector001_connection`, `Cluster_SLT01_Sector002_connection` and, if their keys come out the wrong way round, the same with a letter added to the cluster part (`Cluster_SLT01A_...`), until the order is right. That is why T1, T7, T8 and T14 have a letter in their names.

Test T2 shows every piece of one cluster. The galaxy diff places it; `x` and `z` are counted in the same steps of 15,000 km and 8,660 km as the base game's clusters, so it lands on a free cell of the hexagon grid:

```xml
<diff>
  <add sel="/macros/macro[@name='XU_EP2_universe_macro']/connections">
    <connection name="Cluster_SLT02_connection" ref="clusters">
      <offset>
        <position x="270000000" y="0" z="69280000" />
      </offset>
      <macro ref="Cluster_SLT02_macro" connection="galaxy" />
    </connection>
  </add>
</diff>
```

The cluster macro lists the two sectors; the second one is 50 km along `x`:

```xml
<macros>
  <macro name="Cluster_SLT02_macro" class="cluster">
    <component ref="standardcluster" />
    <connections>
      <connection name="Cluster_SLT02_Sector001_connection" ref="sectors">
        <macro ref="Cluster_SLT02_Sector001_macro" connection="cluster" />
      </connection>
      <connection name="Cluster_SLT02_Sector002_connection" ref="sectors">
        <offset>
          <position x="50000" y="0" z="0" />
        </offset>
        <macro ref="Cluster_SLT02_Sector002_macro" connection="cluster" />
      </connection>
    </connections>
  </macro>
</macros>
```

The sector macros need nothing more than their component; a sector without zones is valid:

```xml
<macros>
  <macro name="Cluster_SLT02_Sector001_macro" class="sector">
    <component ref="standardsector" />
  </macro>
  <macro name="Cluster_SLT02_Sector002_macro" class="sector">
    <component ref="standardsector" />
  </macro>
</macros>
```

The index tells the game where to find each macro. The base game's own entry `cluster_*` points at its clusters file, so every new macro gets an entry of its own, as the expansions do for theirs; the file name is given without `.xml`:

```xml
<index>
  <entry name="cluster_slt02_macro" value="extensions\sector_layout_test\maps\xu_ep2_universe\slt_clusters" />
  <entry name="cluster_slt02_sector001_macro" value="extensions\sector_layout_test\maps\xu_ep2_universe\slt_sectors" />
  <entry name="cluster_slt02_sector002_macro" value="extensions\sector_layout_test\maps\xu_ep2_universe\slt_sectors" />
</index>
```

The names come from the map defaults. They are plain text here, which the game shows as written; a released extension would use text references such as `{20003,150001}` so they can be translated:

```xml
<diff>
  <add sel="/defaults">
    <dataset macro="Cluster_SLT02_macro">
      <properties>
        <identification name="SLT T2" description="z tie, S2 first" />
      </properties>
    </dataset>
    <dataset macro="Cluster_SLT02_Sector001_macro">
      <properties>
        <identification name="T2 S1" description="T2 S1" />
      </properties>
    </dataset>
    <dataset macro="Cluster_SLT02_Sector002_macro">
      <properties>
        <identification name="T2 S2" description="T2 S2" />
      </properties>
    </dataset>
  </add>
</diff>
```

The script finds the test clusters by the extension that added them, marks them and their sectors as known when the game starts, and writes the log lines then and after every load. `find_sector` returns a cluster's sectors in their first-to-last order:

```xml
<mdscript name="SectorLayoutTest" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="Reveal">
      <actions>
        <find_cluster name="$Clusters" extension="'sector_layout_test'" multiple="true" />
        <do_all exact="$Clusters.count" counter="$i">
          <set_known object="$Clusters.{$i}" known="true" />
          <find_sector name="$Sectors" space="$Clusters.{$i}" multiple="true" />
          <do_all exact="$Sectors.count" counter="$j">
            <set_known object="$Sectors.{$j}" known="true" />
          </do_all>
        </do_all>
        <signal_cue cue="LogOrder" />
      </actions>
    </cue>

    <cue name="LogOrder" instantiate="true">
      <conditions>
        <check_any>
          <event_cue_signalled />
          <event_game_loaded />
        </check_any>
      </conditions>
      <actions>
        <find_cluster name="$Clusters" extension="'sector_layout_test'" multiple="true" />
        <do_all exact="$Clusters.count" counter="$i">
          <find_sector name="$Sectors" space="$Clusters.{$i}" multiple="true" />
          <set_value name="$Line" exact="'SectorLayoutTest: ' + $Clusters.{$i}.knownname + ' ' + $Clusters.{$i}.macro.id + ':'" />
          <do_all exact="$Sectors.count" counter="$j">
            <set_value name="$Line" exact="$Line + ' [' + $Sectors.{$j}.knownname + ' ' + $Sectors.{$j}.position + ']'" />
          </do_all>
          <debug_text text="$Line" filter="general" />
        </do_all>
      </actions>
    </cue>
  </cues>
</mdscript>
```

[↑ Contents](#toc)
