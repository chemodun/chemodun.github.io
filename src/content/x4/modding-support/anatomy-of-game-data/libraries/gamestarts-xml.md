---
title: gamestarts.xml
description: How libraries/gamestarts.xml defines every game start - the menu entry, the cutscene and intro, the start location, the player and the universe settings - what god.xml and the MD scripts add for a start, the custom game starts and scenarios, the script side, and how an extension adds a start of its own.
---

# gamestarts.xml

Every way into a game of X4 is a **gamestart**: the stories on the New Game menu, the custom game starts, the tutorials, the Timelines scenarios and the Station Designer. Each is one `<gamestart>` in `libraries/gamestarts.xml`. It says how the start appears in the menu, what plays when it is chosen, where the player is placed, who the player is, with which ship, money and knowledge, and how the universe is set up for it. The game builds a new universe from that definition, and the scripts that run for that start alone add the rest.

This article covers the format, what the game does with each part, the files that work together with it, and the script side. It describes version 9.00. The scenes the start menu shows behind the game start lists are covered in [startmenu.xml](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/).

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Gamestart**: one `<gamestart>` entry, named by its `id`. The game also calls it a **module**: `player.module` in a script and `NewGame(id)` in the UI take the same id.
- **Start menu**: the main menu shown before a game is loaded, with a 3D scene behind it.
- **Cutscene**: the short scene that plays in the preview panel of the New Game menu while a start is selected.
- **Intro**: the camera move in the start menu's background scene that plays after a start is chosen and before the game loads.
- **Custom game start**: a start the player configures in the Custom Game menu before playing; vanilla has a budgeted one and a creative one.
- **Scenario**: a Timelines start, a short self-contained mission with a score and a rating.

[↑ Contents](#toc)

## From the menu to the game

1. **The menu lists the starts.** New Game shows the starts that are neither tutorials nor scenarios, grouped under headings. The tutorials have their own menu, and so do the Timelines scenarios.
2. **Selecting a start shows its details.** The panel beside the list shows the start's image, info rows and type. After the selection rests for about a second, the start's cutscene plays in the preview panel, with its voice line when one is set.
3. **Choosing a start plays the intro.** When the New Game menu was opened from the start menu and the start has an intro, the menu clears, the background scene plays the named intro animation with its voice line, the screen fades out, and only then the new game begins. From a running game, or without an intro, the game begins at once. A start tagged `customeditor` opens the Custom Game menu instead, and one tagged `mapeditor` opens the map editor settings.
4. **The game builds the universe.** The loading screen shows the start's texts. The galaxy named in `<location>` is created, the god engine and the job engine populate it unless the start switches them off, the player is created as `<player>` describes and placed as `<location>` describes, and the `<universe>` settings are applied.
5. **The scripts run.** Once the player is in the universe, `event_game_started` fires, and the Mission Director's `md.Setup.GameStart` cue signals everything that waits on a new game, including the cues written for this start alone.

[↑ Contents](#toc)

## The file

### Layout

```xml
<gamestarts>
  <groups>
    <group group="1" name="{1021,65}" />
    ...
  </groups>
  <defaults>
    <player>
      <featureunlocks> ... </featureunlocks>
    </player>
  </defaults>
  <gamestart id="..." name="..." ...> ... </gamestart>
  ...
</gamestarts>
```

- `<groups>` names the headings of the New Game list. Each `<group>` maps a number to a text.
- `<defaults>` holds what every start gets. In vanilla that is the story features unlocked from the beginning: the map, mission management, guidance, the encyclopedia and the gravidar.
- Each `<gamestart>` is one start.

The base file holds the base game's starts and the test starts, and also a short placeholder for every expansion start. An expansion's own `libraries/gamestarts.xml` is a diff: it adds its group to `<groups>`, replaces its placeholders with the full definitions and adds its other starts. Some expansions also replace single attributes of base starts.

The schema, `libraries/gamestarts.xsd`, documents every element and attribute, and is the reference for the parts this article only names.

[↑ Contents](#toc)

### A gamestart, part by part

The Teladi trader start, shortened:

```xml
<gamestart id="x4ep1_gamestart_trade" name="{1021,200}" description="{1021,201}" image="gamestart_trade" group="1">
  <info>
    <item name="{1021,8}" value="{1021,202}" />
    <item name="{1021,13}" value="{1021,213}" />
    <item />
    <item name="{1021,1}" value="{1021,211}" />
    <item name="@unlock" value="{1021,31}" />
  </info>
  <unlock>
    <userdata ref="unlock_x4gamestart_trade" value="1" />
  </unlock>
  <cutscene ref="gamestart_2" voice="gamestart_trade_selected" />
  <intro ref="gamestart5" voice="gamestart_trade_started" length="45.0" fadeout="2.0" />
  <type name="{1021,94}" description="{1021,95}" />
  <location galaxy="xu_ep2_universe_macro" zone="zone001_cluster_19_sector001_macro" room="dockingbay_arg_s_01_lowtech_macro" faction="player" station="station_gen_factory_base_01_macro">
    <player disembarked="true">
      <position x="-2.5" y="1.7" z="21" />
      <rotation yaw="145" pitch="0" roll="0" />
    </player>
  </location>
  <player macro="character_player_trade_macro" money="200000" name="{1021,202}">
    <ship macro="ship_tel_s_scout_01_a_macro">
      <loadout> ... </loadout>
    </ship>
    <inventory> ... </inventory>
    <blueprints> ... </blueprints>
    <research> ... </research>
    <theme paint="painttheme_player_01" />
  </player>
  <universe>
    <factions>
      <relations>
        <relation faction="teladi" otherfaction="player" relation="0.0032" />
      </relations>
    </factions>
  </universe>
</gamestart>
```

The children, in the order the schema expects them:

| Element | What it does |
|---|---|
| `<extension>` | Ties the start to an expansion, with store links for a player who does not own it |
| `<info>` | The rows of the details panel |
| `<unlock>` | What the player has to have done before the start can be chosen |
| `<cutscene>` | The preview cutscene and its voice line |
| `<intro>` | The intro animation in the start menu, its voice line, length and fade-out |
| `<type>` | The start's type label and description, and its recommendation score |
| `<loadingscreen>` | The loading screen image and texts |
| `<location>` | The galaxy and where in it the player starts |
| `<player>` | The player character, ship, money, knowledge and property |
| `<universe>` | Seed, highways, regions, the god and job engines, factions, licences and story states |
| `<options>` | Options the player can tick before starting |
| `<budget>` | The point budgets of a budgeted custom start |
| `<custom>` | Which values a custom start lets the player change |
| `<scenario>` | The chapter, description and score thresholds of a Timelines scenario |

[↑ Contents](#toc)

### Attributes

| Attribute | Meaning |
|---|---|
| `id` | The start's id, required. Scripts see it as `player.module`. |
| `name`, `description` | The texts of the list entry and the details panel; `name` is required. |
| `image` | An icon id from `libraries/icons.xml`. The vanilla start images are 512 by 256 icons such as `gamestart_trade`. |
| `group` | The group number, which decides the heading the start is listed under. |
| `tags` | Space-separated flags, below. |
| `debug` | `true` marks a debug-only start; the vanilla test starts carry it. |
| `cutscene`, `cutscenevoice`, `intro`, `introvoice`, `loadingscreen`, `loadingscreentext`, `loadingscreentime` | Attribute forms of the `<cutscene>`, `<intro>` and `<loadingscreen>` children. The Terran and Split starts set `introvoice` this way. |

The tags the schema allows, with the vanilla starts that use them:

| Tag | Used by |
|---|---|
| `tutorial` | The tutorials, which the Tutorials menu lists instead of New Game |
| `nosave` | The tutorials, the Timelines scenarios and hub, and the Station Designer |
| `customeditor` | The two custom starts; choosing one opens the Custom Game menu |
| `budget` | The budgeted custom start |
| `stationdesigner` | The Station Designer |
| `timelineshub` | The Timelines hub |
| `usetimelinesplayercharacter` | One Timelines scenario |
| `mapeditor` | No vanilla start; choosing such a start opens the map editor settings |

[↑ Contents](#toc)

## In the New Game menu

### Groups and order

The starts are listed by group, each group under the heading its `<group>` gives it. A group with no `<group>` entry is separated from the previous one by a line instead of a heading. Vanilla group 1 is "Foundations", group 2 "Special", and each expansion has its own number and heading.

`<type>` labels the start. Vanilla uses three types, "Guided", "Assisted" and "Sandbox", each with a description of who it suits. A `recommendation` score above 0 makes the start a candidate for the recommended marker, which goes to the two starts with the highest scores.

### The details panel

`<info>` is a list of rows. Each `<item>` with a `name` and `value` is one row, the name on the left and the value on the right; an empty `<item />` is a blank row. Vanilla names its rows with texts from page 1021: Name `{1021,8}`, Race `{1021,13}`, Gender `{1021,9}`, Location `{1021,1}`, Starting Ship `{1021,2}`, Cash `{1021,3}`, Property `{1021,5}`. The values are texts written for each start.

Four item names starting with `@` are special:

- `@playerimage` puts the image named in `value` next to the rows, instead of the portrait of the player macro.
- `@player` shows a choice of player character when the start offers more than one.
- `@name` shows the player name a custom start has set.
- `@unlock` shows its `value` as the unlock condition, only while the start is locked.

`<info>` also takes `requirement`, a text shown for a start that needs something, such as "Requires expansion: Kingdom End", and `startyear`, `startmonth` and `startday` for the in-game date.

### Locked and hidden starts

`<unlock>` lists what has to be true before the start can be chosen: an `<achievement ref>`, or a `<userdata ref value>`, a value the game keeps in the player's profile, outside any save. A script sets such a value with `set_value name="userdata.<name>"`; the trader start above opens once a story has set `userdata.unlock_x4gamestart_trade`. `<userdata>` also takes a `comparison`, a `mask` for bit flags and a `text` to show while the condition is not met. `<unlock locked="true">` locks the start whatever the conditions, and `hidden="true"` keeps it out of the list until it is unlocked.

### Expansion starts

The base file's placeholder for an expansion start carries an `<extension>` element:

```xml
<extension id="ego_dlc_boron">
  <source type="steam" value="1990040" />
  <source type="gog" value="{1021,1491}" />
</extension>
```

A player without the expansion still sees the start, with its name, image and texts, and the panel offers to open the store page. With the expansion installed, its diff replaces the placeholder with the full start.

[↑ Contents](#toc)

## Cutscene and intro

The two are different things:

- **`<cutscene ref voice>`** names a cutscene, a file in `cutscenes/` with a matching `<director key>`. It plays in the preview panel while the start is selected in the menu. Vanilla has one per start, such as `gamestart_2` or `gamestart_boron1`, and the tutorials share `scenario_flightschool`.
- **`<intro ref voice length fadeout>`** names an animation of the start menu's background scene. When the start is chosen from the start menu, the scene plays that animation for `length` seconds (30 by default), the screen fades out over `fadeout` seconds (2 by default), and the game begins. Vanilla intros use `gamestart1`, `gamestart3`, `gamestart4` and `gamestart5`, the animation names the vanilla background scenes carry on their camera; [Start menu background](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/background/) describes those scenes.

A start without `<intro>` begins as soon as it is chosen.

[↑ Contents](#toc)

## Start location

`<location>` names the galaxy, required, and where the player begins:

- `sector` or `zone` for a place in space; `zone` wins when both are given, and with neither the game picks a random sector. The custom starts name only a sector.
- `station` for a station macro the player starts at, narrowed by `faction` and by flags such as `shipyard`, `wharf`, `equipmentdock`, `tradestation` or `headquarters`; `stationgodentry` names a station by its [god.xml](/x4/modding-support/anatomy-of-game-data/libraries/god-xml/#player-starts-on-a-god-entry) entry instead.
- `ship` or `shipgodentry` in the same way for a ship, and `docked` for whether the player's ship starts docked.
- `room` for a room macro, such as a docking bay, the player stands in.
- `<position>` and `<rotation>` place the player's ship; a child `<player>` with `disembarked="true"` and its own position places the character on foot; `<interior>` builds a room for the player to start in.

The trader start above starts the player on foot in a docking bay of a factory owned by the player. That factory is not in `gamestarts.xml`: it is a [god.xml](/x4/modding-support/anatomy-of-game-data/libraries/god-xml/#one-quota-or-one-per-gamestart) station with a quota for this start alone, described below.

[↑ Contents](#toc)

## The player

`<player>` takes the character macro, required, a `name`, `female` (which has to match the macro) and `money`. Its children:

| Element | What it gives |
|---|---|
| `<ship macro name>` | The player's ship, with `<loadout>`, `<modification>`, `<cargo>`, a `<pilot>` and `<people>` |
| `<inventory>` | Wares in the player's inventory |
| `<blueprints>` | Blueprints, including paint and clothing mods |
| `<build method>` | The default build method |
| `<research>` | Research already done |
| `<encyclopedia>`, `<timeline>` | Encyclopedia and timeline entries already known |
| `<knownfactions>`, `<knownspace>`, `<knownobjects>` | Factions, clusters, sectors, zones and objects the map already shows |
| `<featureunlocks>` | Story features unlocked or locked, on top of `<defaults>` |
| `<property>` | Stations, ships and other objects the player owns from the start |
| `<theme paint clothing>` | The player's paint and clothing themes |
| `<modification clothing>` | The player's clothing mod |

The ship's `<loadout>` is written in the same form as the loadouts in `libraries/loadouts.xml`: `<macros>` with engines, weapons and shields on named connections, `<ammunition>`, `<software>` and `<virtualmacros>`. Every vanilla start with a ship writes it out in full.

No vanilla start uses `<property>`. The player's other ships and stations come from the two places described next.

[↑ Contents](#toc)

## What other files add for a start

A start is spread over three places, each linked to it by its id:

- **`libraries/god.xml`** places stations and objects. An entry with a quota for one start, `<quota galaxy="1" zone="1" gamestart="x4ep1_gamestart_trade" />`, is created only in that start; that is how the trader's factory and the scientist's headquarters exist. god.xml can also hold a whole dataset for one start. [god.xml](/x4/modding-support/anatomy-of-game-data/libraries/god-xml/#which-dataset-is-used) covers both.
- **`libraries/jobs.xml`** can hold quotas and datasets per start in the same way; [jobs.xml](/x4/modding-support/anatomy-of-game-data/libraries/jobs-xml/) covers them. Vanilla does not use them.
- **The Mission Director** runs cues written for the start. A cue with a `module` attribute exists only in the start with that id. Vanilla keeps the per-start cues in `md/setup_gamestarts.xml`, and each expansion adds its own to that script:

```xml
<cue name="X4ep1_Gamestart_Trade" module="x4ep1_gamestart_trade" version="2">
  <conditions>
    <event_cue_signalled cue="md.Setup.GameStart" />
  </conditions>
  <actions>
    <find_station name="$Factory" space="player.zone" owner="faction.player" />
    <!-- create the player's transporter docked at $Factory, staff the factory, ... -->
  </actions>
</cue>
```

The trader's cue finds the factory god.xml created, creates a transporter docked at it, gives the scout a pilot and assigns a manager, an engineer and a defence officer to the factory. Anything the gamestart format has no element for is done this way.

[↑ Contents](#toc)

## The universe

`<universe>` changes how the universe is generated and run for this start:

| Element or attribute | What it changes |
|---|---|
| `seed` | The universe seed: a number is used as it is. Several Timelines scenarios fix it at 42. |
| `visitors`, `ventures`, `onlineinventory` | Allow visitors, ventures and the online inventory; each defaults to `true`. |
| `<highways ring linear>` | Switch the ring highways and the other highways on or off. |
| `<regions>` | Factors for region object density and region yields. |
| `<hiddenobjects region station>` | Factors for hidden objects in regions and at stations. |
| `<jobs enabled>`, `<god enabled>` | Switch the job or god engine off, or scale their quotas per faction and tag with `<quotas>`. |
| `<masstraffic enabled>` | Switch mass traffic off. |
| `<factions>` | Police factions and starting relations. |
| `<accesslicences>` | Licences for locations, by owner faction. |
| `<stories>` | Story states for the start, read with `gamestart.storystate`. |

The vanilla tutorials and test starts switch the god and job engines off, so their universe holds only what the start and its scripts create. [god.xml](/x4/modding-support/anatomy-of-game-data/libraries/god-xml/#scaling-by-gamestart) describes the quota factors.

Relations are written per faction pair, with values between -1 and 1. The trader start gives the Teladi and the Ministry a small positive relation to the player and the Holy Order a small negative one.

[↑ Contents](#toc)

## Custom game starts

The two custom starts, `custom_budgeted` and `custom_creative`, are full gamestarts with a `<custom>` list. Each `<item value="...">` names a value the Custom Game menu lets the player change, such as `sector`, `ship`, `shiploadout`, `playermoney`, `playerproperty`, `universefactionrelations` or `universestorystates`, and its `state`:

- `standard`: the value can be changed and the game stays a standard game;
- `modified`: changing it marks the game as modified;
- `budgeted`: it is paid from a budget, and the game stays standard while the player stays inside that budget.

`min`, `max` and `list` limit the values; the player character item, for example, lists the character macros to choose from. An extension can offer more values for an item with a child `<extension list="...">`.

The budgeted start also has a `<budget>`: point budgets for money, knowledge, people and relations, and `<story>` entries that let the player begin with parts of a story already done. Several story scripts check for these and skip ahead, in cues named `Handle_Custom_Gamestart_Skip`.

[↑ Contents](#toc)

## Timelines scenarios

The Timelines expansion's scenarios are gamestarts with a `<scenario>` element: the `chapter` they belong to, a `description`, and `<scores>` with the score needed for each rating. They are listed in the Timelines menu, not on New Game, and carry `nosave`. The Timelines hub, `x4ep1_gamestart_hub`, is a start of its own, tagged `timelineshub`.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
|---|---|
| `player.module` | The id of the start being played |
| `player.modulename`, `player.moduledescription` | Its name and description |
| `player.previousmodule` | The id of the start played before |
| `player.allmodules.{$id}.exists`, `.name`, `.description`, `.isextensionenabled` | Data on any start by id |
| `player.allmodules.{$id}.isscenario`, `.istutorial.any` | Whether a start is a scenario or a tutorial |
| `player.recommendedmodule` | The id of the recommended start |
| `gamestart.seed` | The session seed |
| `gamestart.storystate.<story>` | A story state the start set; only available in a session that began with a new game, not after a load |
| `event_game_started` | Fires once the new universe is populated and the player placed; its `param` is the list of the options chosen |
| `md.Setup.GameStart` | The cue that signals on a new game; vanilla per-start cues wait for it |
| `<cue module="...">` | Limits a cue to one start |
| `quit_to_startmenu` | Ends the game and returns to the start menu |

A check such as `player.module == 'x4ep1_gamestart_scientist'` inside an ordinary cue is the other vanilla way to branch on the start.

[↑ Contents](#toc)

## Adding a gamestart from an extension

A new start needs a diff on `libraries/gamestarts.xml`, the texts, and, for anything beyond the player's own ship and knowledge, a script. The example below is a complete start for a fictional extension `example_gamestart`: an Argon courier in Argon Prime with a scout and, from its script, a container freighter. It reuses the trader's cutscene and intro and the vanilla start image.

`libraries/gamestarts.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/gamestarts">
    <gamestart id="example_gamestart_courier" name="{1234567,1}" description="{1234567,2}" image="gamestart_trade" group="1">
      <info>
        <item name="{1021,8}" value="{1234567,3}" />
        <item name="{1021,9}" value="{1021,51}" />
        <item />
        <item name="{1021,1}" value="{1234567,4}" />
        <item name="{1021,2}" value="{1234567,5}" />
      </info>
      <cutscene ref="gamestart_2" />
      <intro ref="gamestart5" length="20.0" fadeout="2.0" />
      <type name="{1021,94}" description="{1021,95}" />
      <location galaxy="xu_ep2_universe_macro" sector="cluster_14_sector001_macro" />
      <player macro="character_player_trade_macro" money="50000" name="{1234567,3}">
        <ship macro="ship_arg_s_scout_01_a_macro">
          <loadout>
            <macros>
              <engine macro="engine_arg_s_travel_01_mk2_macro" path="../con_engine_01" />
              <engine macro="engine_arg_s_travel_01_mk2_macro" path="../con_engine_02" />
              <weapon macro="weapon_gen_s_laser_01_mk1_macro" path="../con_primaryweapon_01" optional="1" />
              <shield macro="shield_arg_s_standard_01_mk1_macro" path="../con_shield_01" optional="1" />
            </macros>
            <software>
              <software ware="software_trademk1" />
            </software>
            <virtualmacros>
              <thruster macro="thruster_gen_s_allround_01_mk1_macro" />
            </virtualmacros>
          </loadout>
        </ship>
        <theme paint="painttheme_player_01" />
      </player>
      <universe>
        <factions>
          <relations>
            <relation faction="argon" otherfaction="player" relation="0.0032" />
          </relations>
        </factions>
      </universe>
    </gamestart>
  </add>
</diff>
```

`t/0001-l044.xml`, with the page id the extension owns:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example gamestart" descr="" voice="no">
    <t id="1">Argon Courier</t>
    <t id="2">Start as a courier in Argon Prime, with a scout and a freighter of your own.</t>
    <t id="3">Marten Holt</t>
    <t id="4">Argon Prime</t>
    <t id="5">Discoverer</t>
  </page>
</language>
```

`md/example_gamestart_setup.xml`, the start's own setup:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="Example_Gamestart_Setup" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="Example_Gamestart_Courier" module="example_gamestart_courier">
      <conditions>
        <event_cue_signalled cue="md.Setup.GameStart" />
      </conditions>
      <actions>
        <create_ship name="$Freighter" macro="macro.ship_arg_m_trans_container_01_a_macro" zone="player.zone">
          <owner exact="faction.player" overridenpc="true" />
          <pilot>
            <select race="race.argon" tags="tag.aipilot" />
          </pilot>
          <loadout>
            <level exact="0.5" />
          </loadout>
          <safepos object="player.ship" exact="2km" />
        </create_ship>
      </actions>
    </cue>
  </cues>
</mdscript>
```

Some points about the example:

- **The id is the link.** The `module` of the cue, any god.xml `gamestart` quota and any `player.module` check all use `example_gamestart_courier`. A prefix of the extension's own keeps it apart from other extensions' starts.
- **A group of the extension's own** is one more `<add sel="/gamestarts/groups">` with a `<group group="..." name="..."/>`, and a number vanilla does not use.
- **An image of the extension's own** is an icon added to `libraries/icons.xml` with a diff, 512 by 256 like the vanilla ones, and named in `image`.
- **The intro and the cutscene** can be vanilla ones, as here. A start without them works as well: without `<intro>` the game begins as soon as the start is chosen, and without `<cutscene>` the preview panel stays empty.
- **A start begins a new game**, so the extension's content is there from the first frame, and the `module` cue runs once, in that game only.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[startmenu.xml](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/) covers the list of scenes behind the start menu, and [Start menu background](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/background/) how such a scene is made: its cutscene, its scene object and its regions. The scene object is where the intro animations named above live.

[↑ Contents](#toc)
