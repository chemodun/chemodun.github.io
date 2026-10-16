---
title: missiongroups.xml
description: How libraries/missiongroups.xml names the groups mission offers are sorted into - the guild and war groups, the story groups and the game start groups - how the mission menu uses them, how the expansions add theirs, the script side, and how an extension adds a group for its own missions.
---

# missiongroups.xml

Every mission offer the player sees belongs to a **mission group**: the Argon Federation Police, the Teladi Trade Guild, the war between the Argon and the Xenon, a story, a game start. The mission menu sorts the offers under those names, and a script that creates an offer names the group it goes into. `libraries/missiongroups.xml` is the short table that defines the groups: an id, a name, whether the group is a story, and the faction and the enemy faction behind it.

This article covers the format, how the groups show in the mission menu, the script side and how an extension adds a group. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Mission group**: one `<group>` entry, named by its `id`. A script refers to it as `missiongroup.<id>`.
- **Offer**: a mission on offer, created by a script with `create_offer` or `create_mission`, and listed in the mission menu until it is accepted or expires.
- **Guild missions**: in the mission menu, the offers of the recurring groups, the police, the trade guilds, the wars and the pirates, listed under their group with a count.
- **Story**: a group with `story="true"`; its missions are the plot missions, listed apart from the guild offers.

[↑ Contents](#toc)

## How a group is used

1. **A script creates an offer in a group.** `create_offer` and `create_mission` take a `group` attribute, `missiongroup.argon_police` for instance, and `update_offer` and `update_mission` can change it later.
2. **The mission menu reads the group of every offer.** Plot missions are listed under their story group; the recurring offers appear under the heading for guild missions, one collapsible row per group with the group's name and how many missions it holds; offers without a group are listed on their own.
3. **The group's faction and enemy are there for the scripts** to read back, `missiongroup.argon_war_xenon.faction` and `.enemy`, so a generic mission can tell who it works for and against from the group alone.

[↑ Contents](#toc)

## The file

### Layout

```xml
<missiongroups>
  <group id="argon_police"          name="{30206,1}" faction="argon"/>
  <group id="argon_war_xenon"       name="{30210,1}" faction="argon" enemy="xenon"/>
  <group id="teladi_trade_guild"    name="{30204,1}" faction="teladi"/>
  <group id="scaleplate_pirates"    name="{30207,1}" faction="scaleplate"/>
  <group id="mentor_plot"           name="{30201,1}" faction="argon"/>
  <group id="terraforming"          name="{30500,1}" faction="player"/>
  <group id="story_boso"            name="{30201,51}" story="true"/>
  ...
</missiongroups>
```

The base file holds the base game's groups: the police of the Argon, the trade guilds of the Teladi and of Antigone, the Scale Plate pirates, the wars between the Argon, the Paranid and the Holy Order, the mentor missions, terraforming, and the base stories. Every expansion ships a `libraries/missiongroups.xml` of its own, a whole file gathered with the base one, holding its stories, its game start groups and, for Split Vendetta and Cradle of Humanity, its wars and guilds. Nothing in an expansion file touches a base group.

The schema, `libraries/missiongroups.xsd`, documents the attributes.

[↑ Contents](#toc)

### Attributes

| Attribute | Meaning |
| --- | --- |
| `id` | The group id, `missiongroup.<id>` in a script |
| `name` | The name shown in the mission menu; vanilla's are on text pages in the 302xx range, one page per group |
| `description` | A description; vanilla sets none |
| `story` | `true` for a story group. Its missions are listed as plot missions |
| `faction` | The faction the group's missions work for |
| `enemy` | The faction they work against; set on the war groups |

A group needs no more than an `id` and a `name`. Vanilla's story groups carry neither faction nor enemy, and the terraforming group names the player as its faction.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `missiongroup.<id>` | The group |
| `.name`, `.description` | The texts |
| `.faction`, `.enemy` | The two factions, or null where the entry sets none |
| `create_offer group="..."`, `create_mission group="..."` | The group of a new offer or mission |
| `update_offer group="..."`, `update_mission group="..."` | Change the group of an existing one |
| `create_mission_thread_offer group="..."` | The group of a mission thread |

Vanilla's generic missions carry their group in a variable, `$MissionGroup`, set by the script that generates the offer, and pass it to `create_offer`; the story scripts name their group directly, `group="missiongroup.story_boso"`.

[↑ Contents](#toc)

## Adding a group from an extension

A group of the extension's own is what keeps its missions apart from vanilla's in the menu. The example below, for a fictional extension `example_missions`, adds a guild group for Teladi courier missions, and shows the offer that goes into it.

`libraries/missiongroups.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/missiongroups">
    <group id="example_teladi_couriers" name="{1234567,1}" faction="teladi"/>
  </add>
</diff>
```

`t/0001-l044.xml`, with the page id the extension owns:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example missions" descr="" voice="no">
    <t id="1">Teladi Courier Guild</t>
  </page>
</language>
```

And in the extension's mission script, the offer that uses it, shortened to the attribute that matters:

```xml
<create_offer cue="this" name="$OfferName" description="$OfferDescription" difficulty="level.easy" faction="faction.teladi" group="missiongroup.example_teladi_couriers">
  ...
</create_offer>
```

Some points about the example:

- **The group is read when the offer is created**, so the diff has to be in place when the game starts or the save is loaded; the offer then shows under the new heading in the guild missions list.
- **A whole file instead of a diff** works as well, as the expansions do it: a `libraries/missiongroups.xml` with a `<missiongroups>` root and the new group is gathered with the base one.
- **A story of the extension's own** is the same entry with `story="true"` and its missions created with `create_mission`; the menu then lists them as plot missions under that name.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[factions.xml](/x4/modding-support/anatomy-of-game-data/libraries/factions-xml/) defines the factions a group names.

[↑ Contents](#toc)
