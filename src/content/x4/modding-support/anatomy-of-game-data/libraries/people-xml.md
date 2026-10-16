---
title: people.xml
description: How libraries/people.xml defines the crews of the ships the game creates - the fill percentage, the roles and the character selection per person, how a definition reaches a ship through ships.xml, a script or a game start, the player-only definitions of the Custom Game menu, how the expansions add their own, the script side, and how an extension adds a crew definition.
---

# people.xml

Every ship the game creates for a faction has people on board: service crew, marines, and sometimes a passenger or a prisoner. Which people, how many and how skilled is decided by a **people definition** in `libraries/people.xml`. A definition says how full the ship's crew quarters are and from which pool each person is drawn: a faction, a role and a tier such as `rookie` or `elite`. The ship list, the scripts and the game starts name a definition by its id, and the game fills the ship from it when the ship is created.

This article covers the format, how a definition reaches a ship, the player-only definitions of the Custom Game menu, the script side and how an extension adds a definition. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **People definition**: one `<people>` entry, named by its `id`. The schema calls the file the PeopleDB.
- **Crew**: the people on board a ship. The game keeps them as **NPC templates**, a record of role, character entry and skills each, and not as actual NPCs.
- **Role**: what a person does on board. This file uses `service`, `marine`, `passenger` and `prisoner`; `libraries/roles.xml` defines the roles.
- **Character entry**: an entry of `libraries/characters.xml`, the pool a person is drawn from, matched by faction and tags.
- **Tier**: the tags `rookie`, `regular`, `veteran` and `elite` on the character entries, each with its own skill ranges.
- **Capacity**: how many people a ship can carry, from `<people capacity="..."/>` in the ship macro.
- **Fill percentage**: the share of the capacity that is filled.

[↑ Contents](#toc)

## How a definition reaches a ship

1. **The ship list names it.** Each entry of `libraries/ships.xml` carries `<people ref="..."/>` beside its pilot and its drop list. The job engine and the scripts that pick a ship with `<select faction tags size>` get the definition with the entry; [jobs.xml](/x4/modding-support/anatomy-of-game-data/libraries/jobs-xml/#ship-definition) describes that selection. The Xenon, Kha'ak and mass traffic entries carry no `<people>`.
2. **A script names it.** `create_ship` takes a `<people ref="..."/>` child, with an optional fill override.
3. **A game start names it.** The `<ship>` of a game start's player, and each ship under its `<property>`, takes `<people people="..." fillpercent="..."/>`. No vanilla start uses it; the custom starts take the crew from the player's choice instead.
4. **The ship is created and filled.** The fill percentage is applied to the ship's capacity, and each place is filled from one `<person>` entry of the definition, the entries weighed against each other by `weight`. The character entry that `<select>` matches gives the person its race, name and skills.
5. **The crew is read as templates.** Scripts see the people through `people.count`, `people.capacity` and the per-role lists, and the ship's Crew section in the ship configuration menu lists them.

[↑ Contents](#toc)

## The file

### Layout

```xml
<peopledefinitions>
  <!--Argon-->
  <people id="argon_freighter_crew">
    <fillpercent min="20" max="75"/>
    <person role="service" weight="18">
      <select faction="argon" tags="[service, rookie]"/>
    </person>
    ...
  </people>
  ...
</peopledefinitions>
```

- The root holds `<people>` entries and nothing else. Vanilla groups them by faction, with a comment per faction.
- The base file holds the base game's factions. Each expansion ships a whole `libraries/people.xml` of its own with the same root, and the game reads all of them.

The schema, `libraries/people.xsd`, documents the attributes of an entry. The content of an entry is the `people` group of `libraries/common.xsd`, the same group the script side uses for `<people>` in `create_ship`.

[↑ Contents](#toc)

### A definition, part by part

The Argon military crew, complete:

```xml
<people id="argon_military_crew">
  <fillpercent min="20" max="75"/>
  <person role="service" weight="8">
    <select faction="argon" tags="[service, rookie]"/>
  </person>
  <person role="service" weight="55">
    <select faction="argon" tags="[service, regular]"/>
  </person>
  <person role="service" weight="16">
    <select faction="argon" tags="[service, veteran]"/>
  </person>
  <person role="service" weight="1">
    <select faction="argon" tags="[service, elite]"/>
  </person>
  <person role="marine" weight="2">
    <select faction="argon" tags="[marine, rookie]"/>
  </person>
  <person role="marine" weight="4">
    <select faction="argon" tags="[marine, regular]"/>
  </person>
  <person role="marine" weight="12">
    <select faction="argon" tags="[marine, veteran]"/>
  </person>
  <person role="marine" weight="1">
    <select faction="argon" tags="[marine, elite]"/>
  </person>
  <person role="prisoner" weight="1">
    <select faction="argon" tags="prisoner"/>
  </person>
</people>
```

- **`<fillpercent>`** sets how much of the capacity is filled, with the usual random attributes: `exact` for a fixed value, `min` and `max` for a range, `list` for a choice of values, `profile` and `scale` for the shape of the random draw. Every vanilla definition has one.
- **`<person>`** is one pool to draw from. `role` is required, `weight` is the pool's share of the draw. The weights are relative to each other within the definition and do not have to add up to 100: the vanilla freighter and military base crews do, the pirate, veteran and elite ones do not.
- **`<select faction tags>`** chooses the character entry, in the same form as the pilot selection of a job or a `create_ship`. `faction` and `tags` are matched against the `<category>` of the entries in `libraries/characters.xml`; every tag has to match.
- A `<person>` can also name a character directly with a `macro`, `group` or `ref` attribute, and can carry `<name>`, `<owner>`, `<page>` for the voice and `<skills>`. No vanilla definition does: the character entry supplies the skills.

[↑ Contents](#toc)

### Attributes

| Attribute | Meaning |
| --- | --- |
| `id` | The definition's id, required. Everything else refers to it by this id. |
| `name` | A text for the Custom Game menu. Only the player-only entries have one. |
| `description` | The mouse-over text of that menu entry. No vanilla entry has one. |
| `playeronly` | `true` marks a definition for player property. The Custom Game menu lists these and no others. |

The roles the schema allows on `<person>`:

| Role | In vanilla definitions |
| --- | --- |
| `service` | Every definition; the bulk of a freighter crew |
| `marine` | Every definition; the bulk of a military or pirate crew |
| `passenger` | A small share on the freighter crews |
| `prisoner` | A small share on the military and pirate crews |
| `trainee_group`, `worker`, `unassigned` | Not used in this file |

`libraries/roles.xml` marks `service` and `marine` as hired roles and `passenger` and `prisoner` as independent ones.

[↑ Contents](#toc)

## Who is drawn: the character entries

`<select>` finds its people in `libraries/characters.xml`. An entry there names a character group, a `<category>` with tags, the factions it serves and a race, and the skill ranges of the character:

```xml
<character id="service_argon_random_veteran" group="argon.service">
  <category tags="[crew, service, veteran, recruitable]" faction="[argon, antigone, scaleplate, hatikvah, alliance, buccaneers, faction.player]" race="argon"/>
  <skills>
    <skill type="engineering" min="6" max="9"/>
    <skill type="morale" min="6" max="9"/>
    <skill type="piloting" min="2" max="5"/>
    <skill type="management" exact="1"/>
    <skill type="boarding" min="1" max="2"/>
  </skills>
  ...
</character>
```

- **The tiers are tags.** For each race there is one service entry and one marine entry per tier, `rookie`, `regular`, `veteran` and `elite`, and the skill ranges rise from tier to tier: a rookie service crew member starts with low engineering, an elite one near the top of the scale. The rookie, regular and veteran entries also carry the `recruitable` tag, the elite ones do not.
- **The faction list is wide.** An Argon service entry serves the Argon factions, the pirates and the player alike, so the `faction` of a `<select>` decides the race of the crew through these lists, and a Hatikvah crew is Argon people.
- **Passengers and prisoners** have one entry per race, tagged `passenger` and `prisoner`.

A tag of an extension's own works the same way: the Timelines expansion's mining scenarios select with `scenario_mining_service`, a tag carried by character entries that expansion adds.

[↑ Contents](#toc)

## The vanilla definitions

The base file follows one scheme per faction:

| Factions | Definitions | Fill |
| --- | --- | --- |
| Argon, Paranid, Teladi | `<faction>_freighter_crew` and `<faction>_military_crew`, each also as `<faction>_veteran_...` and `<faction>_elite_...` | 20 to 75 or 80 percent |
| Hatikvah, Scale Plate Pact | `<faction>_pirate_crew`, `<faction>_veteran_pirate_crew`, `<faction>_elite_pirate_crew` | 20 to 60 percent |
| Duke's Buccaneers | The same three pirate forms | 80 to 100 percent |

- A **freighter crew** is mostly service crew, with a few marines and a small passenger share. A **military crew** has a larger marine share and a prisoner share instead of passengers. A **pirate crew** is heavier on marines and prisoners still.
- The **base form** of a crew mixes all four tiers, with `regular` as the bulk and `elite` as a rare draw. The **veteran** and **elite** forms draw every service member and marine from that one tier.
- The Buccaneers are the one faction whose ships sail nearly full.

`ships.xml` puts the base forms on the ordinary ship entries of each faction and the veteran and elite forms on a few; the elite military crews are mostly for the story ships the scripts create.

[↑ Contents](#toc)

## Player-only definitions

The entries named `player_<faction>_<tier>_freighter_crew` and `player_<faction>_<tier>_military_crew` carry `playeronly="true"`, a `name` and a fixed fill of 100 percent, and draw from one tier each: a freighter crew is four parts service to one part marines, a military crew the reverse. Their names are on text page 20208, in a block of ids per faction, such as "Argon freighter crew - Veteran".

These are the crews a player can choose in the Custom Game menu. In the ship configuration there, the Crew section shows a drop-down of every player-only definition, sorted by name, with "None" first and the `description` as mouse-over text, and a slider for the number of people, which the menu turns into the fill percentage. The custom starts list the choice among their `<custom>` items as `shippeople` and `shippeoplefillpercent`: `budgeted` in the budgeted start, `modified` in the creative one.

The budgeted start prices the choice. Its `<budget>` holds, under `<people>` and `<parameters>`, one `<people ref="..." factor="..."/>` per definition, and vanilla prices its three tiers in three steps:

| Tier | Factor |
| --- | --- |
| `regular` | 390 |
| `veteran` | 1360 |
| `elite` | 4090 |

The schema also allows an entry without `ref` as the price of every definition not listed; vanilla has none. [gamestarts.xml](/x4/modding-support/anatomy-of-game-data/libraries/gamestarts-xml/#custom-game-starts) covers the custom starts and their budget.

[↑ Contents](#toc)

## How the expansions change it

Every expansion ships a whole `libraries/people.xml` with its own factions, in the same scheme as the base file, and a whole `ships.xml` whose entries name those crews:

- **Split Vendetta** (`ego_dlc_split`): the Family Zyarth and Free Families crews, and the player-only Split crews.
- **Cradle of Humanity** (`ego_dlc_terran`): the Terran, Segaris Pioneers and Yaki crews, `terran_asgard_crew` with a higher fill range than the other military crews, and player-only crews for all three.
- **Tides of Avarice** (`ego_dlc_pirate`): the Vigor Syndicate and Riptide Rakers crews, each with pirate forms beside the freighter and military ones, and player-only crews for both.
- **Kingdom End** (`ego_dlc_boron`): the Boron crews and the player-only Boron crews. Its ship entries for the pirate factions name the base game's Hatikvah and Scale Plate crews.
- **Timelines** (`ego_dlc_timelines`): the Kaori crews, the player-only Kaori crews, and three `scenario_mining_<race>_crew` definitions for its mining scenarios, filled to 100 percent with the tag described above.

The names of the expansion's player-only crews are in the base game's text file, on page 20208 in the block after the base factions. No expansion changes a base definition.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `<people ref="...">` in `create_ship` | The crew of the new ship. A child `<fillpercent>` overrides the definition's fill; `<person>` children are ignored when `ref` is set. `ref` can be a variable, and an empty string gives no crew. |
| `<people people="..." fillpercent="..."/>` in a game start's `<ship>` | The same for the player's ship or a property ship of a game start. |
| `$ship.people.count`, `.capacity`, `.free` | How many people are on board or embarked, how many the ship can carry, how many more fit. |
| `$ship.people.list` | The people as NPC templates. |
| `$ship.people.service.count`, `.marine.count` | The count by role; `.list` gives the templates, `.combinedskill` their combined skill value for the role. |
| `$ship.people.{$entityrole}.{$level}.count` | The count of one role at one skill tier. |
| `$ship.availablepeople.count` and its role forms | Only the people currently on board, where `people` also counts those embarked for the ship. |

The vanilla scripts use the definitions in a few ways. The story ships of the Paranid plot are created with `paranid_elite_military_crew`, and one game start's setup gives a ship `argon_military_crew`. The mission reward ships in `md/mc_management.xml` take the definition from a variable and override the fill with `<fillpercent exact="..."/>`. The generic library `CreateShipAtExitGate` in `md/lib_generic.xml` passes a definition through its `$People` parameter.

[↑ Contents](#toc)

## Adding a crew definition from an extension

A new definition needs the file, and for the Custom Game menu a text and a budget entry; a script or a `ships.xml` entry puts it on a ship. The example below is a complete set for a fictional extension `example_crews`: an Argon salvage crew for the ships a story script creates, and a player-only form of it for the Custom Game menu.

`libraries/people.xml`, a whole file as the expansions ship it:

```xml
<?xml version="1.0" encoding="utf-8"?>
<peopledefinitions>
  <people id="example_argon_salvage_crew">
    <fillpercent min="40" max="70"/>
    <person role="service" weight="50">
      <select faction="argon" tags="[service, veteran]"/>
    </person>
    <person role="service" weight="10">
      <select faction="argon" tags="[service, elite]"/>
    </person>
    <person role="marine" weight="30">
      <select faction="argon" tags="[marine, regular]"/>
    </person>
    <person role="passenger" weight="5">
      <select faction="argon" tags="passenger"/>
    </person>
  </people>
  <people id="player_example_argon_salvage_crew" name="{1234567,1}" description="{1234567,2}" playeronly="true">
    <fillpercent exact="100"/>
    <person role="service" weight="60">
      <select faction="argon" tags="[service, veteran]"/>
    </person>
    <person role="marine" weight="30">
      <select faction="argon" tags="[marine, regular]"/>
    </person>
  </people>
</peopledefinitions>
```

`t/0001-l044.xml`, with the page id the extension owns:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example crews" descr="" voice="no">
    <t id="1">Argon salvage crew - Veteran</t>
    <t id="2">Veteran service crew with a regular marine detachment, as found on the salvage ships of the Argon border sectors.</t>
  </page>
</language>
```

`libraries/gamestarts.xml`, the price of the player-only crew in the budgeted start:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/gamestarts/gamestart[@id='custom_budgeted']/budget/people/parameters/people">
    <people ref="player_example_argon_salvage_crew" factor="1360"/>
  </add>
</diff>
```

`md/example_crews.xml`, a salvage ship with the crew, created when the player enters Argon Prime:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="Example_Crews" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="Example_Salvager">
      <conditions>
        <event_object_changed_sector object="player.entity" />
        <check_value value="player.sector.macro == macro.cluster_14_sector001_macro" />
      </conditions>
      <actions>
        <create_ship name="$Salvager" macro="macro.ship_arg_m_trans_container_01_a_macro" zone="player.zone">
          <owner exact="faction.argon" />
          <pilot>
            <select faction="faction.argon" tags="tag.traderpilot" />
          </pilot>
          <people ref="example_argon_salvage_crew">
            <fillpercent exact="90" />
          </people>
          <loadout>
            <level exact="0.5" />
          </loadout>
          <safepos object="player.ship" exact="3km" />
        </create_ship>
      </actions>
    </cue>
  </cues>
</mdscript>
```

Some points about the example:

- **The id is the link.** The `ref` of the script, the `ref` of the budget entry and any `<people ref>` in a `ships.xml` entry all use the definition's id. A prefix of the extension's own keeps it apart from other extensions' definitions.
- **A whole file or a diff.** The expansions ship a whole `<peopledefinitions>` file, as above; a `<diff>` that adds entries to the base file's root works for this file as for the other libraries.
- **The player-only entry** appears in the Custom Game menu by its `name` as soon as the file is read, with the `description` as mouse-over text. The budget entry prices it in the budgeted start; the creative start needs nothing more.
- **The ships of the jobs** get their crews from `ships.xml` only. To put a new crew on them, a diff on `libraries/ships.xml` replaces the `<people ref>` of the entries concerned, or adds entries of the extension's own; [jobs.xml](/x4/modding-support/anatomy-of-game-data/libraries/jobs-xml/#ship-definition) describes how a job picks its entries.
- **`<select>` only finds what `characters.xml` holds** for that faction and those tags. A tag of the extension's own needs character entries that carry it, as the Timelines mining crews have.
- **The fill override** in the script is optional. Without it the definition's own range applies, 40 to 70 percent here.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[jobs.xml](/x4/modding-support/anatomy-of-game-data/libraries/jobs-xml/) covers the ships the job engine creates and how they are picked from `ships.xml`, where the crew definition sits beside the pilot selection and the [drops.xml](/x4/modding-support/anatomy-of-game-data/libraries/drops-xml/) reference. [gamestarts.xml](/x4/modding-support/anatomy-of-game-data/libraries/gamestarts-xml/) covers the custom game starts, their budget and the player's ship. [factions.xml](/x4/modding-support/anatomy-of-game-data/libraries/factions-xml/) covers the factions the `<select>` names.

[↑ Contents](#toc)
