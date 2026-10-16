---
title: stats.xml
description: How libraries/stats.xml declares the player statistics - what each counter is, its units and display, how one stat feeds another by copy, addition or mapping, the trade and fight scores and ranks, the account stats that drive the platform achievements, the Statistics menu, the script side, and how an extension adds a stat of its own, counted by its script and fed into a score and a rank.
---

# stats.xml

The game keeps count of what the player does: time in a ship, distance flown, gates passed, sectors found, ships destroyed, trades made, missions completed. Every such counter is a **stat** declared in `libraries/stats.xml`. Some are counted by the game itself, others by the Mission Director scripts. The file does not count anything; it says which counters exist, how each is shown in the Statistics menu, and how the counters feed each other: the trade and fight scores are sums of other stats, the ranks are bands of the scores, and the achievements of the platform are reached through stats that live in the player's account rather than in a save.

This article covers the format, the feeds between stats, the scores and ranks, the account stats and achievements, the menu, the script side and how an extension adds a stat. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Stat**: one `<stat>` entry, named by its `id`. The game keeps one value per stat.
- **Save stat**: the ordinary stat, stored in the savegame.
- **Account stat**: a stat with `account="true"`, stored in the player's Steam or GOG account and kept across savegames. Vanilla names them with an `s_` prefix.
- **Feed**: a `<copyto>`, `<addto>` or `<mapto>` child, by which a change of this stat changes another.
- **Score**: a stat that is nothing but the sum of feeds: `trade_score` and `fight_score`.
- **Rank**: a stat that holds a band number of a score and shows a name for it: `trade_rank` and `fight_rank`.
- **Hidden stat**: a stat the menu does not show, because it has no `name` or because it is `secret` and still at its default.

[↑ Contents](#toc)

## From a counter to the menu

1. **The game and the scripts count.** The game itself keeps the flight, trade, build, weapon and equipment counters: time, distance, gates passed, places discovered, trades, modules built, shots fired, mods installed. The Mission Director scripts keep the rest with `set_value` on `stat.<id>`: `md/notifications.xml` adds to the destruction, drop, crate and capture counters as the events arrive and sets the owned ships, the owned stations and the account to their current totals, the mission scripts add to the accepted and completed missions, and the diplomacy and terraforming scripts to theirs.
2. **The feeds run.** When a stat changes, its `<copyto>` targets take its value, its `<addto>` targets take the change, and its `<mapto>` targets take the band value its new value falls in. A target can feed further: a score fed by `<addto>` maps to a rank, and the rank copies to an account stat.
3. **The account is updated.** An account stat is written to the platform account, and when it reaches the `unlock` value of one of its `<achievement>` entries, that achievement is unlocked.
4. **The menu shows the stats.** The Statistics section of the Player Information menu lists every stat that has a `name` and is not hidden as secret, with its value formatted by its units.
5. **Scripts read them.** `stat.<id>` gives the current value to any script; `md/notifications.xml`, for example, reads `stat.sectors_discovered`.

[↑ Contents](#toc)

## The file

### Layout

```xml
<stats>
  <!-- Time -->
  <stat id="time_total" name="{1003,1}" comment="Total time" units="seconds" />
  ...
  <!-- Exploration -->
  <stat id="sectors_discovered" name="{1003,12}" comment="Sectors discovered" />
  ...
  <stat id="drops_collected" name="{1003,27}" comment="Dropped containers collected" secret="true" >
    <copyto stat="s_drops_collected" />
  </stat>
  <stat id="s_drops_collected" highest="true" account="true">
    <achievement progressstep="33" unlock="99" />
  </stat>
  ...
  <!-- Scores / Ranks -->
  <stat id="trade_score" datatype="double" highest="true" comment="Trade score">
    <mapto stat="trade_rank" min="1" max="8" value="1" />
    ...
  </stat>
  <stat id="trade_rank" units="named" highest="true" name="{1003,2}" comment="Trade rank">
    <copyto stat="s_trade_rank" />
    <namedvalue value="0" name="{20219,1001}" />
    ...
  </stat>
</stats>
```

- The root holds `<stat>` entries and nothing else. Vanilla groups them with a comment per subject: time, modes, distances, jumps, exploration, money and trade, build, fight, deployables, destruction, equipment mods, employer, missions, diplomacy, terraforming, ventures and visitors, and the scores and ranks at the end.
- The order of the entries does not matter to the feeds: `gates_traversed` near the top feeds `trade_score` declared at the bottom.
- An entry commented out, as the two landing-platform counters are, is a stat that does not exist.

The schema, `libraries/stats.xsd`, stands on its own and documents every attribute. The `id` of each stat is unique in the file, and so is each `leaderboard` name.

[↑ Contents](#toc)

### Attributes

| Attribute | Meaning |
| --- | --- |
| `id` | The stat's id, required: letters, digits and underscores. Scripts read it as `stat.<id>`. |
| `name` | The text shown in the menu. Without it the stat is hidden. The vanilla names are on page 1003. |
| `units` | `none` (the default, a plain count), `seconds`, `credits`, `metres`, `kilometres`, `unixseconds` or `named`, for a stat whose values have names. |
| `datatype` | `int`, `int64`, `float` or `double`; derived from the units when not given. Vanilla sets `double` on the distances and the scores and `float` on the hit percentages. |
| `fractional_digits` | Digits after the point for a floating-point stat, or `auto`; the default is none. |
| `default` | The starting value, 0 when not given. |
| `format` | A display format with `%s` for the value, derived from the units when not given. |
| `separators` | Whether groups of three digits are separated, `true` by default. |
| `secret` | `true` hides the stat while its value is the default. |
| `highest` | `true` keeps only the highest value the stat has reached. |
| `account` | `true` stores the stat in the platform account, across savegames. |
| `leaderboard` | The name of a platform leaderboard the stat is sent to; a readable name that is still unique. |
| `scenario` | `true` lets the account data of this stat change while a Timelines scenario is played; the default is `false`. |
| `comment` | A note for the reader of the file. |

No vanilla stat uses `format`, `separators`, `fractional_digits` or `leaderboard`; one uses `default`, the highest faction relation, which is held at 0 or above because the achievement that follows it counts from 0.

[↑ Contents](#toc)

### Children: the feeds, the names and the achievements

| Element | What it does |
| --- | --- |
| `<copyto stat multiplier divisor>` | Copies this stat's value to the named stat, scaled by the multiplier or divisor. The pair of a visible save stat and its hidden account stat is written this way. |
| `<addto stat multiplier divisor>` | Adds each change of this stat to the named stat, scaled. The scores are built from these. |
| `<mapto stat min max value>` | Sets the named stat to `value` while this stat is at least `min` and below `max`; either bound can be left out. The ranks are built from these. |
| `<namedvalue value name>` | Names a value: the name applies from `value` up to the next named value. Used with `units="named"`. |
| `<achievement progressstep unlock>` | Declares the platform achievement that this stat unlocks at `unlock`; `progressstep` and its multiples are the values at which progress is shown before that. Several entries with different `unlock` values are allowed on one stat. The stat, or a `<copyto>` target of it, has to be an account stat. |

[↑ Contents](#toc)

## Account stats and achievements

A visible counter and its achievement are two stats:

```xml
<stat id="turrets_destroyed" name="{1003,25}" comment="Turrets destroyed">
  <copyto stat="s_turrets_destroyed" />
  <addto stat="fight_score"/>
</stat>
<stat id="s_turrets_destroyed" highest="true" account="true">
  <achievement progressstep="25" unlock="100" />
</stat>
```

The save stat has the name and the menu row. The account stat has no name, so it is never shown, keeps only the highest value and lives in the platform account, so a new game cannot lower it and the achievement counts across games. Every achievement stat in vanilla follows this pattern, with one difference for the two stats that no save stat feeds: the external-view kills and the Timelines connection progress are account stats on their own, marked `scenario="true"` so that a scenario can advance them.

The rank achievements sit on `s_trade_rank` and `s_fight_rank`, each with two `<achievement>` entries, at rank 16 and at rank 30.

Achievements unlocked by a story rather than by a counter do not go through this file: a script unlocks them with `<unlock_achievement name="..."/>`, and that action takes a `scenario` attribute of its own.

[↑ Contents](#toc)

## Scores and ranks

`trade_score` and `fight_score` are hidden stats with no counter of their own. They are fed by `<addto>` from the stats below, each change scaled by the multiplier or divisor given there:

| Trade score | Factor | Fight score | Factor |
| --- | --- | --- | --- |
| `gates_traversed`, `accelerators_traversed` | 1 | `ships_destroyed`, `turrets_destroyed` | 1 |
| `anomalies_traversed` | 10 | `capships_destroyed` | 30 |
| `discounts_unlocked`, `commissions_unlocked` | 3 | `modules_destroyed` | 10 |
| `trades_executed`, `staff_hired` | 1 | `ships_claimed` | 10 |
| `trade_value` | 1 per 10 000 credits | `ships_boarded` | 100 |
| `station_modules_constructed` | 100 | `missions_completed` | 3 |

Each score has thirty `<mapto>` bands that set the rank from 1 to 30. The bands widen geometrically: each trade band starts at about 1.8 times the previous one, from 1 up to 100 million, each fight band at about 1.45 times, from 1 up to 100 000. Both scores and ranks carry `highest="true"`, so a rank does not fall.

The rank stats, `trade_rank` and `fight_rank`, carry `units="named"` and one `<namedvalue>` per band, from 0 to 30, with the names on page 20219: "Salesman" to "X-TREME" for trade, "Harmless" to "X-TREME" for fight. The menu shows the name, not the number. Each rank copies to an account stat for its two achievements.

[↑ Contents](#toc)

## The Statistics menu

The Player Information menu has a Statistics section. It asks the game for every stat id in file order and, for each, whether it is hidden and what its display name is; a stat that is not hidden gets a row with its name on the left and its display value on the right. The display value comes from the game already formatted by the stat's units and format; a named stat shows the name of its current value. The menu adds no grouping and no headings of its own.

A stat is hidden when it has no `name`, or when it has `secret="true"` and still holds its default. Vanilla marks as secret the time in the scan, travel and SETA modes, the anomalies, the collected and illegal drops, the lockboxes, boarding, the escort and passenger missions, and the venture and visitor counters.

[↑ Contents](#toc)

## How the expansions change it

No expansion ships a `stats.xml`. The counters for the expansions' features, terraforming, diplomacy, ventures and the Timelines progress, are declared in the base file; their names are in the base game's text file, on page 1003. The terraforming stats a sector carries, air pressure, temperature and the rest, are another system, declared in `libraries/terraforming.xml` and changed by scripts with `set_terraforming_stat`; this file only counts terraforming projects, missions and drones.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `stat.<id>` | The current value of the stat, a number. The ids are taken from this file, so a stat an extension adds is readable the same way. |
| `stat.trade_rank`, `stat.fight_rank` | The rank number; the rank name is not available here. |
| `<set_value name="stat.<id>" operation="add"/>` | Adds 1 to the stat, or the `exact` amount when given; `exact` without an operation sets the value. The feeds of the stat run as for a change made by the game. |
| `<unlock_achievement name="..." scenario="..."/>` | Unlocks a platform achievement by its name, independently of any stat. |

The vanilla scripts write more stats than they read. `md/notifications.xml` keeps the destruction, drop, crate, capture and property counters, the mission scripts add to `stat.missions_accepted` and `stat.missions_completed`, `md/setup.xml` counts the loaded savegames, and the diplomacy and terraforming scripts keep their own. Reads are rare: `md/notifications.xml` reads the owned ships, the owned stations and the discovered sectors.

[↑ Contents](#toc)

## Adding a stat from an extension

A stat an extension adds is declared with a diff on this file, counted by the extension's own script with `set_value` on `stat.<id>` or derived from the vanilla counters through the feeds, and shown in the Statistics menu under its name text. The example below is a complete set for a fictional extension `example_explorer`: a counter of the sectors the player enters, kept by a script; an exploration score fed by that counter and by the vanilla discovery counters; and a rank with names for the score.

`libraries/stats.xml`, a diff on the base file:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/stats/stat[@id='sectors_discovered']">
    <addto stat="example_explorer_score" multiplier="10" />
  </add>
  <add sel="/stats/stat[@id='gates_discovered']">
    <addto stat="example_explorer_score" multiplier="3" />
  </add>
  <add sel="/stats/stat[@id='anomalies_discovered']">
    <addto stat="example_explorer_score" multiplier="5" />
  </add>
  <add sel="/stats">
    <stat id="example_sectors_entered" name="{1234567,3}" comment="Sectors entered">
      <addto stat="example_explorer_score" />
    </stat>
    <stat id="example_explorer_score" name="{1234567,1}" highest="true" comment="Explorer score">
      <mapto stat="example_explorer_rank" min="1" max="50" value="1" />
      <mapto stat="example_explorer_rank" min="50" max="200" value="2" />
      <mapto stat="example_explorer_rank" min="200" value="3" />
    </stat>
    <stat id="example_explorer_rank" name="{1234567,2}" units="named" highest="true" comment="Explorer rank">
      <namedvalue value="0" name="{1234567,10}" />
      <namedvalue value="1" name="{1234567,11}" />
      <namedvalue value="2" name="{1234567,12}" />
      <namedvalue value="3" name="{1234567,13}" />
    </stat>
  </add>
</diff>
```

`t/0001-l044.xml`, with the page id the extension owns:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example explorer" descr="" voice="no">
    <t id="1">Explorer score</t>
    <t id="2">Explorer rank</t>
    <t id="3">Sectors entered</t>
    <t id="10">Tourist</t>
    <t id="11">Wanderer</t>
    <t id="12">Surveyor</t>
    <t id="13">Pathfinder</t>
  </page>
</language>
```

`md/example_explorer.xml`, the counter's script:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="Example_Explorer" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="Example_Sector_Entered" instantiate="true">
      <conditions>
        <event_object_changed_sector object="player.entity" />
      </conditions>
      <actions>
        <set_value name="stat.example_sectors_entered" operation="add" />
      </actions>
    </cue>
  </cues>
</mdscript>
```

Some points about the example:

- **The counter is the script's.** The game knows `example_sectors_entered` only from its declaration; the cue adds one to it on every sector change, as `md/notifications.xml` adds one to `ships_destroyed` on `event_player_killed_object`. The cue is instantiated so that it counts every time.
- **The feeds sit on the source.** A stat declares where its changes go, so the score is fed by the `<addto>` of the new counter and by three `<add>` operations on the vanilla discovery stats, not by anything on the score itself. The score only declares its bands, and the rank only its names.
- **The score starts at the install.** `<addto>` passes on changes, so in a game that has already explored, the score counts the sectors entered and the discoveries made from then on; `<copyto>` would carry a value over, but there is no single counter to copy an exploration score from.
- **The score is a count.** With whole-number multipliers it needs no `datatype`; the vanilla scores are `double` because of their divisor.
- **`highest` on the score and the rank** matches the vanilla scores and ranks.
- **The rank is readable in a script** as `stat.example_explorer_rank`, a number from 0 to 3; the names are for the menu only.
- **An achievement is out of reach.** The platform's achievements are the game's own; an `<achievement>` entry on an extension's stat has nothing on the platform to unlock.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[unlocks.xml](/x4/modding-support/anatomy-of-game-data/libraries/unlocks-xml/) covers the discounts and commissions whose counts feed the trade score. [gamestarts.xml](/x4/modding-support/anatomy-of-game-data/libraries/gamestarts-xml/) covers the Timelines scenarios that the `scenario` attribute refers to. The text pages of the stat names and the rank names, 1003 and 20219, are in the base game's `t/0001-l044.xml`.

[↑ Contents](#toc)
