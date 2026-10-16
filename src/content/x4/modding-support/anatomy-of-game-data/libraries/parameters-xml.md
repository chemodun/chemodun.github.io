---
title: parameters.xml
description: How libraries/parameters.xml holds the tuning values of 9.00 - one section per game system, from flight and combat to the economy, docking and the map, the scriptparams table the scripts read through the param keyword, which values the scripts fall back to, how the expansions change the file, the script side, and how an extension adds a parameter of its own and changes a vanilla one.
---

# parameters.xml

`libraries/parameters.xml` is where the game keeps the numbers that are not part of any one object: how a pilot of a given skill steers, how long an autosave waits, what a build plot costs, how far from a station a ship may be and still get a dock assigned, at what distance the map fades an icon in, when fight music switches to its big version. The file is one root element with one section per subject, some seventy sections in 9.00, and each game system reads its own. One section, `<scriptparams>`, is not for the engine at all: it is a table of named values the scripts read through the `param` keyword, which makes it the natural place for an extension's own tuning values.

This article covers the format, what the sections hold, the script parameters in detail, how the expansions change the file, the script side, and how an extension adds a parameter and changes a vanilla one. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Section**: a direct child of `<parameters>`, named after the system it tunes: `<aiflight>`, `<economy>`, `<docking>`. The schema allows each section once at most, in any order.
- **Typed section**: a section whose content `libraries/parameters.xsd` describes element by element, with a documentation line on most attributes. A little over half of the sections are typed.
- **Untyped section**: a section the schema declares as `anycontent`: any content passes validation, and the comments in the file are the only description. The player flight, camera, first person, map and loadout sections are of this kind.
- **Script parameter**: a `<param>` in a `<category>` of `<scriptparams>`, a named value a script reads as `param.<category>.<name>`.
- **Fallback value**: a value in this file that applies when an object has none of its own, such as the loadout level of a ship created without one.

[↑ Contents](#toc)

## How the game uses it

The file is a library like the others in `libraries/`: the game reads it when it starts, and an expansion or an extension changes it with a `<diff>` file of the same name. What sets it apart is that nothing in it describes an object. A ship macro says what one ship is; `parameters.xml` says how every ship docks, how every pilot of a given skill steers, how every station prices a plot.

Each section belongs to one system. The engine reads `<docking>` when it assigns a dock and plays the landing animation, `<economy>` when it prices and logs trades, `<holomap>` when it draws the map, `<platformnavigation>` when it builds the navigation mesh of a station interior. Scripts do not see these sections; a few of their values reach a script as a default, listed under [The script side](#the-script-side). The section scripts do read is `<scriptparams>`, through the `param` keyword, and that section has no engine meaning: the engine holds the values, the scripts give them meaning.

Three consequences for an extension:

- **A changed value applies to the whole game.** The AI attack run distance, the autosave window or the plot price formula have no per-object override. A `<replace>` on the attribute changes it for everything.
- **A new script parameter is free.** `<scriptparams>` accepts any category and any name. An extension that adds a category of its own gets a tuning table its scripts read with one keyword, and that a player or another extension can patch with a diff.
- **The schema is the documentation where there is one.** A typed section carries a documentation line per attribute in `parameters.xsd`. An untyped section has only the comments in the file, and some of those are the developers' notes to each other.

[↑ Contents](#toc)

## The file

### Layout

```xml
<?xml version="1.0" encoding="utf-8"?>
<parameters xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xsi:noNamespaceSchemaLocation="parameters.xsd">
  <playerflight>
    <input>
      <mouse>
        <curve>
          <point position="0" value="0" />
          <point position="0.05" value="0" />
          <point position="0.8" value="1" />
        </curve>
      </mouse>
      ...
    </input>
    ...
  </playerflight>
  <aiflight>...</aiflight>
  <aicombat>...</aicombat>
  ...
  <economy>
    <prices>
      <rounding up="false" />
      <build min="0.25" shipsalefactor="0.3" />
      <resource min="3600" max="144000" />
      <product factor="5000000" />
      <builder fee="50000" />
    </prices>
    ...
  </economy>
  ...
  <scriptparams>
    <category name="autosave">
      <param name="mintime" value="40min" />
      <param name="maxtime" value="80min" />
      <param name="retrytimeout" value="120s" />
    </category>
    ...
  </scriptparams>
  ...
  <storage base="10000000" />
  ...
  <missions limit="10" limitenabled="false" />
  ...
  <prestige>
    <level value="0"  name="{1001,12940}"/>
    <level value="1"  name="{1001,12941}"/>
    <level value="50" name="{1001,12942}"/>
  </prestige>
</parameters>
```

The root is `<parameters>`, with the schema declared on it, and every child is a section. The schema lists the sections in an `xs:all` group, so each may appear once and the order is free; the vanilla file runs roughly from flight and combat through the interface and the economy to docking and stations, with the small sections at the end. Two sections the schema knows, `<playerfirstpersongeometry>` and `<materials>`, are absent from the vanilla file.

[↑ Contents](#toc)

### The sections

The tables below name every section of the vanilla file, what it holds, and whether the schema types it. "Typed" means `parameters.xsd` describes the content and documents the attributes; "any" means the schema accepts anything there, and the file's comments are all there is. In a typed section the attribute documentation is the place to read before changing a value.

#### Flight and movement

| Section | Holds | Schema |
| --- | --- | --- |
| `<playerflight>` | The player's flight input: controller and mouse response curves, throttle steps and the sticky throttle, yaw into roll, the speed bar and flight assist sounds, the aim assist angle, the minimum size of a reference object | any |
| `<aiflight>` | AI piloting by skill level: reaction time, strafe and steering factors, and the formation shapes a level may fly; steering, the path spline turn radius, collision avoidance, the low attention flight model, highway exit and mass traffic return times, the angles at which boost and travel drive engage | typed |
| `<spaceflight>` | The speed cap of everything in space, strafe limits, local and super highway speeds, the equipment mod factor, the steering curve with flight assist off, and flight without a working engine | any |
| `<navigation>` | Path finding: average travel speed in space and in highways, the gate transition cost, and the maximum duration of a space reservation | typed |
| `<input>` | Acceleration curves for moving the mouse cursor with a controller | any |
| `<physics>` | Friction, restitution and inertia, planet collision warning and kill altitudes, the collision damage curve, densities, octree and small object thresholds, speed caps and the spinning thresholds of the flight model | any |
| `<engine>` | Engine visuals that follow movement: the acceleration ramp, jet and glow scaling, engine alignment and vortex trails | typed |
| `<tug>` | Tug flight: speed and acceleration scales in and out of highways, a distance, and width and length limits | any |
| `<furnace>` | The furnace: a trigger volume, slowdown and alignment on the way in, and the guidance line shown on approach | any |
| `<masstraffic>` | Mass traffic: clearance between objects, render and component distances, the wobble of ships on a lane, road widths and speeds by tag, highway trail colours, and how the road network is built between stations, highways and modules, with build and repair traffic and flow limits | typed |

#### Combat

| Section | Holds | Schema |
| --- | --- | --- |
| `<aicombat>` | AI combat by skill level, the Multi-Aggressor Distraction Score that spreads attackers over targets, attack run distance and speed, when an AI weapon starts aiming and firing relative to its range, and the missile overkill estimate | typed |
| `<combat>` | The weapon heat cooling penalty, player auto-aim and attacker relevance, beam oscillation, Travel Drive Stability, the missile proximity trigger, and the tags that make a launcher or turret compatible with dumbfire, guided and torpedo missiles | typed |
| `<lowattentioncombat>` | The simplified combat of ships outside the player's attention: hit chances and damage factors per weapon kind, surface element and shield generator chances, and the defender's speed, size, dodge, countermeasure and drone factors | typed |
| `<loadout>` | The default loadout level and variation of a newly created ship or station, the software level, ammunition fill, unit fill with the share of defence drones, and the group threshold | any |
| `<equipmentmod>` | Equipment modification chances: that a ship carries one, an additional one, its quality, that it drops and that it is recovered | any |
| `<damagestate>` | The hull percentages at which the high, medium and low damage states begin | any |
| `<shieldimpact>` | When a shield impact is shown: minimum percentage, maximum and relative distance | any |
| `<weaponmodes>`, `<dronemodes>` | The HUD icon per weapon mode and per drone mode, with a default | typed |
| `<weaponpointer>` | The weapon pointer: scale, material, render distance, the in range and out of range colours, and its pulse when a target comes into range | typed |

#### On foot

| Section | Holds | Schema |
| --- | --- | --- |
| `<playerfirstperson>` | The player on foot: body size, speeds, acceleration and gravity, crouch and jump, pitch limits, head bobbing, slopes, controller input, and overrides per race or by id that a script can switch on | any |
| `<playerfirstpersonguidance>` | The guidance line on foot: distances, curve radius, hover height, width, material and colour | any |
| `<platformnavigation>` | Station interiors: navigation mesh generation with a variant for small objects and overrides by id and by template, crowd steering with body size and speeds per race, path finding, floor costs, conveyor speeds and curves, trigger ranges and the transporter duration | typed |
| `<playerhelmet>` | Helmet camera motion in flight and on foot | any |
| `<controlpanel>` | The station control panel: the hacks with their duration, the wares they consume and their texts, and the plain interactions such as the scanner, the jukebox, the cameras and the people list | any |
| `<minigame>` | The hacking minigame: difficulties and their curves | any |

#### Interface and map

| Section | Holds | Schema |
| --- | --- | --- |
| `<playercamera>` | The cockpit camera: input, position and angle limits, velocities, the boost effect, look around, HUD compensation, zoom goggles, and the flight and first person variants | any |
| `<hud>` | Target name repetition: the sound played instead of a repeated name, and the timeout | typed |
| `<highlight>` | Outline and fill effects for the target, the environment object and each scan level, with colours from `colors.xml` | typed |
| `<environmentobject>` | The crosshair cone and timing that pick the object the HUD shows; the file's own comment says the values now refer to signal leaks | any |
| `<stationicon>` | The map and HUD icon per station type, with a scale | any |
| `<holomap>` | The map, the largest section: the holomap macro and materials, icons and geometries per object type with their fade distances, the radar, the universe view, construction with the plot and module slots, orders and guidance drawing, jump gates, cluster and sector hexes, fog of war, background, picking, sounds and attack markers | any |
| `<notifications>` | Notification text colours, default and critical, and the mission ticker colours | typed |
| `<hintpositions>` | Twenty screen positions, in percent of width and height, a help text can be placed at; a script picks one by index, 0 to 19 | any |
| `<render>` | The maximum weapon glow passed to the shaders | typed |
| `<cutscenes>` | The default scene keys for showing a character's face: in the universe, as an avatar, in the Boron tanks, in a black room | typed |
| `<presentation>` | The ship macro and connection that place characters in the presentation cluster | typed |
| `<bonuscontent>` | Empty in 9.00; its commented out entries list the bonus content of the original release | any |

#### Scanning and drops

| Section | Holds | Schema |
| --- | --- | --- |
| `<scanlevel>` | A single value, the `legal` maximum scan level | any |
| `<longrangescan>` | The long range scan: wave effect, range, speed and cone, charge time, the result effects and their visualisation | any |
| `<signalleak>` | The signal leak HUD visualisation in normal and in scan mode | any |
| `<drop>` | What a destroyed object drops: chance and share for a destruction and for a hack, the collateral chance, asteroid yield richness with a bonus per mining skill level, how long a drop lasts and how long it is invulnerable | any |
| `<lootmagnet>` | The loot magnet: range, force, speed and sound, with overrides per class | typed |
| `<mining>` | Mining estimates: damage and speed factors, drop distance, the minimum chance of a resource in an asteroid, the resource probe time penalty, the colours of each resource ware on the map and in scans, and when a depleted resource area times out | typed |
| `<hazardwarning>` | The distance and sound of the hazardous region warning | any |

#### Economy and stations

| Section | Holds | Schema |
| --- | --- | --- |
| `<economy>` | Prices (rounding, the resource threshold for the maximum price, the ship sale factor, the resource price time window, the product factor, the builder fee), storage normalisation with initial fill modifiers for two wares, the build storage drain of a recycled station, reservation and subscription durations, the illegal wares, the economy log with its condensing rules, module limits for game start generation, the critical ware log, and scrap processing | typed |
| `<workforce>` | Workforce sustained without food, the update interval, the bonus duration, and growth with its capacity and population factors | typed |
| `<productioncheck>` | When a station reports a shortage: time thresholds for build and production shortages, warnings, transporter requests and the non-viable flag, and storage percentage thresholds | typed |
| `<building>` | Station spacing margin, the hull percentage during construction, the equip and recycle order ids, the plot price formula (base price per cubic kilometre, contributions of gates, highways, stations and population), build price factor and variation when building for others, and resource returns from recycling | typed |
| `<upgraderesources>`, `<shipyardupgraderesources>`, `<wharfupgraderesources>`, `<equipmentdockupgraderesources>`, `<shipupgraderesources>` | Resource amount multipliers per equipment category: a set per kind of building station and one for resupply ships, the plain one a fallback for anything else | typed |
| `<storage>` | The logarithm base for the number of cargo bays a storage module shows by its fill | typed |
| `<jobs>` | Job quota factors, commented out in vanilla, and the over quota cleanup: maximum factor and minimum age | typed |
| `<god>` | A factor on the production quotas of `god.xml` | typed |
| `<missions>` | The number of missions the player can accept at once, upkeep and guidance missions excluded, and whether the limit is on; off in 9.00 | typed |

#### Docking

| Section | Holds | Schema |
| --- | --- | --- |
| `<docking>` | The speed inside a dock, the docking hologram, and one `<dock>` block per size: tags, assignment timeout and distances, retrieval safety, rotated docking, dock path spacing, far and near guidance visuals, the position and rotation tolerances per docking software, and the landing and take-off animations per traffic level. Four blocks: extra small with spacesuits, small, medium, large with extra large | typed |

#### Sound and voice

| Section | Holds | Schema |
| --- | --- | --- |
| `<sound>` | Anomaly pitch and volume curves, the high speed sound delay curve, and engine detail sounds per dock size | typed |
| `<voice>` | The range for speaking without comm, the comm opening delay, and the background comm range and minimum volume | any |
| `<enemywarning>` | The default sounds when an enemy appears on the gravidar and when one targets the player | typed |
| `<playeralert>` | The alert sounds the player can pick, each with a name text on page 20225, tags and a cooldown | typed |
| `<fightmusic>` | The minimum duration of fight music, and per class the distance and count at which a fight is a big one | typed |

#### Scripts and the rest

| Section | Holds | Schema |
| --- | --- | --- |
| `<scriptparams>` | Named values for the scripts, in categories; [The script parameters](#the-script-parameters) covers it | typed |
| `<prestige>` | The ship prestige levels and their names on page 1001 | typed |
| `<orders>` | A skill limit for looping orders, and the order failure queue: its maximum and whether it is kept for the player only | any |
| `<exclusionzones>` | A box size per tag, the ship classes and a radar dish, with an outline flag | typed |
| `<waypoint>` | Waypoint size levels by tag | any |

[↑ Contents](#toc)

### Value forms

A section writes its values in a few recurring forms:

- **Attributes on the section itself**, for a section with one or two values: `<storage base="10000000" />`, `<missions limit="10" limitenabled="false" />`.
- **Nested elements with attributes**, one element per topic: `<economy><prices><builder fee="50000" /></prices></economy>`. Most sections are of this form, two or three levels deep.
- **Curves**: a list of `<point position="..." value="..." />`, in the input sections, the collision damage of `<physics>`, the curve factors of `<masstraffic>` and the anomaly sound. A typed curve carries a `default` for an input outside its points.
- **Keyed lists**: `<tag id="..." speed="..." />`, `<ware ware="..." amount="..." />`, `<entry mode="..." icon="..." />`, `<dock tags="..." />`, `<threshold classes="..." />`, `<skill level="..." />`, `<level value="..." />`, `<race id="..." />`.
- **References into other files**: colours by name from `libraries/colors.xml`, the schema saying so on each such attribute; sounds by id; materials as `library.name`; macros; icons; texts as `{page,id}`; order ids in `<building>`.
- **Units**: the engine sections hold plain numbers, and the schema's documentation says the unit, seconds, metres, degrees or percent. The script parameters are expressions and carry their unit in the value: `40min`, `20km`.
- **Comments**: XML comments throughout, and a `comment` attribute on `<param>` and on the navigation mesh overrides, "for documentation purposes only" in the schema's words.

[↑ Contents](#toc)

## The script parameters

```xml
<scriptparams>
  <!-- Script access via param keyword (e.g. param.boarding.recruitstrength) -->
  <category name="crewtransfer">
    <param name="podmacro" value="macro.ship_gen_xs_escapepod_01_a_macro" />
    <param name="max_npcs_per_pod" value="3" comment="Number of people that can be assigned to the same pod" />
    <param name="max_travel_time" value="5min" comment="Max pod travel duration (not including scheduled launch delay) after which the transferred crew is expected to arrive at destination" />
  </category>
  <category name="docking">
    <!-- max distance at which player.occupiedship might be given permission to dock. -->
    <param name="maxdistance" value="table[
           {class.ship_xs} = 500m,
           {class.ship_s} = 5km,
           {class.ship_m} = 5km,
           {class.ship_l} = 15km,
           {class.ship_xl} = 15km]"/>
  </category>
</scriptparams>
```

- **`<category name>`**: an identifier, letters, digits and underscores not starting with a digit. It is the first part of the keyword path.
- **`<param name>`**: an identifier, the second part of the path.
- **`value`**: a script expression, the schema's `expression` type. The vanilla values show the range: a number, a number with a unit (`40min`, `120s`, `20km`, `150m`), a boolean, a quoted string (`'initial'`), an enumeration constant (`macro.ship_gen_xs_boardingpod_01_a_macro`, `formationshape.pointguard`, `class.ship_s`, `ware.ore`, `tag.console_01`), a list, or a table keyed by such constants. A float literal may carry the `f` suffix, as in `0.9f`.
- **`comment`**: documentation only.

A script reads a parameter as `param.<category>.<name>`. The result has the type the expression yields; the script side has no declaration of it, so the script has to know what it reads, and a checker cannot tell. A table parameter is read by key, `param.docking.maxdistance.{$ship.class}`; the `?` suffix tests whether a key exists, and an `@` before `param` suppresses the error for a parameter that may be missing, the form Timelines uses for its optional entries.

The vanilla categories, and who reads them:

| Category | Holds | Read by |
| --- | --- | --- |
| `boarding` | The service defence factor, the minimum effective marine skill, the boarding pod macro, and the combined skill of a defender that fully earns the resistance bonus | The boarding scripts read the pod macro and the skill; the two factors have no script reader in vanilla |
| `autosave` | The minimum and maximum time between autosaves and the retry window. The file's comments explain the window: between the minimum and the maximum an event such as undocking may trigger an autosave, at the maximum one is triggered anyway, and a zero disables either half | The autosave handling |
| `npcstatemachine` | The initial state name and four signal names of the character state machine | No vanilla script reads them through `param` |
| `cooldown` | Notification cooldowns: area damage, entering an atmosphere, entering a hazardous region, an incoming missile | The notification script |
| `interiorpath` | `allowpartial`, marked debug only by its own comment | No script reader |
| `voice` | A table mapping male honorific text ids to the female ones, and three comm chatter ranges | The usecase script swaps the honorific line for a female recipient; the chatter ranges gate remote comm |
| `formation` | Formation shapes by skill threshold, a table keyed 0, 3, 6, 9, 12 and 15, the default shape, the minimum radius for small ships, ships per line and the roll flags | The escort order and formation handling |
| `docking` | The distance per ship class within which the player's ship may be given docking permission | Split Vendetta's story script; in the base game nothing reads it |
| `crewtransfer` | The pod macro, and pod count, launch and travel timings for a bulk crew transfer | The crew transfer scripts |
| `mining` | Mining efficiency per resource ware, 0.001 to 1 | The mining efficiency library and the collect orders, clamping the value into that range |
| `buildprocessor` | The name of a blackboard variable | The build processor scripts |
| `criticalwares` | Shortage thresholds, documented at `generate_shortage_reports` | Station shortage handling |
| `shipbuilding` | When a blocked build becomes a priority, when a queued ship's loadout is reduced, when a military or civilian build is aborted | The shipyard scripts |
| `factionlogic` | Wait times and timeouts for freighter, production and factory requests, dismantling and paused production | The faction logic |
| `spacereservation` | The maximum duration of a space reservation; the most read parameter, nearly every movement script passes it as the reservation's duration | The movement scripts |
| `combat` | The cap on defence drones a station launches, and their default range | Station defence |
| `madscore` | How much a target's Multi-Aggressor Distraction Score reduces its priority in target selection | The target selection library |

Nothing in the engine knows these names. A category or a parameter an extension adds is as valid as a vanilla one, and a vanilla value an extension replaces changes every script that reads it. The autosave window is the common case: two replaced values, and the game saves on a different rhythm.

[↑ Contents](#toc)

## How the expansions change it

Four of the five expansions ship a `<diff>` on the file, and all four add rather than replace. Kingdom End and Split Vendetta each `<add>` a navigation mesh override to `<platformnavigation>/<navmesh_overrides>`, one by id for a Boron throne room, one by template for a Split frigate with a comment on the gap it closes. Cradle of Humanity adds a ware to `<economy>/<illegalwares>`. Timelines adds a `<scriptparams>` category for its scenario consoles and a navigation mesh override for a Terran corvette. Tides of Avarice ships no file. No expansion changes a vanilla value.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `param.<category>.<name>` | The value of a script parameter, as its expression evaluates; the type is the expression's |
| `param.<category>.<name>.{$key}` | One entry of a table parameter; a `?` suffix tests the key, an `@` before `param` suppresses the error for a missing parameter |
| `$object.loadoutlevel`, `.loadoutvariation`, `.moduleloadoutlevel`, `.moduleloadoutvariation`, `.loadoutquantity.level`, `.loadoutquality.level` and their `.variation` | The loadout values an object was generated with, falling back to `<loadout>` when it has none of its own; the `raw...` forms (`rawloadoutlevel`, `rawmoduleloadoutlevel`, `rawloadoutquantity.level`...) return -1 instead of the fallback, to be checked before use |
| `<loadout>` of `create_ship` | Its `level` and `variation`, also on the `<quality>` child, default to the values in `<loadout>` |
| `show_help position`, and `position` on a help `<text>` | An index into `<hintpositions>`, 0 to 19 in vanilla, 0 the default |
| `dock_player_ship_at` | The player ship must be close enough for docking permission; the schema refers to `<docking>` for the distance thresholds |
| `set_player_firstperson_override` | Switches the player's movement on foot to an override of `<playerfirstperson>/<overrides>` by id |
| `create_dynamic_interior navmeshoverride` | Names a `<platformnavigation>/<navmesh_overrides>/<by_id>` entry for the interior's navigation mesh |
| `speak backgroundcomm` | A background comm may exceed the maximum background comm distance of `<voice>` |
| The `duration` of a space reservation, with `component`, on a movement action | Must not exceed `<navigation>/<spacereservation maxduration>`, an error otherwise; vanilla passes `param.spacereservation.maxduration` |
| `<maxlimits>` in the `<compatibilities>` of a module creation | Module limits to respect when expanding a station; default to the definition's or to `<economy>/<modulelimits>` |

No vanilla UI script reads a script parameter: the interface sections of the file reach the UI through the engine, and a Lua side that needs a script parameter gets it from a script.

[↑ Contents](#toc)

## Adding a parameter from an extension

An extension's own tuning values are a new `<scriptparams>` category, and a vanilla value it wants different is a `<replace>` on the attribute. The example below, for a fictional extension `example_parameters`, does both: it adds a category with an interval, a hint position and a table of text ids by ship class, replaces the autosave maximum, and turns the simultaneous mission limit on. Its script shows a reminder every interval, the text picked by the class of the ship the player flies, at the configured position.

`libraries/parameters.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/parameters/scriptparams">
    <category name="example_parameters">
      <param name="reminder_interval" value="15min" comment="Time between two reminders" />
      <param name="reminder_position" value="7" comment="Index into hintpositions: 7 is bottom centre" />
      <param name="reminder_texts" value="table[ {class.ship_m} = 11, {class.ship_l} = 12, {class.ship_xl} = 13 ]" comment="Text id on the extension's page per ship class; classes not listed get no reminder" />
    </category>
  </add>
  <replace sel="/parameters/scriptparams/category[@name='autosave']/param[@name='maxtime']/@value">60min</replace>
  <replace sel="/parameters/missions/@limitenabled">true</replace>
</diff>
```

`md/example_parameters.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="Example_Parameters" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="Reminder">
      <delay exact="param.example_parameters.reminder_interval" />
      <actions>
        <do_if value="player.occupiedship and param.example_parameters.reminder_texts.{player.occupiedship.class}?">
          <show_help custom="readtext.{1234567}.{param.example_parameters.reminder_texts.{player.occupiedship.class}}" position="param.example_parameters.reminder_position" duration="10s" />
        </do_if>
        <reset_cue cue="this" />
      </actions>
    </cue>
  </cues>
</mdscript>
```

`t/0001-l044.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example parameters" descr="" voice="no">
    <t id="11">Reminder: this is a medium ship.</t>
    <t id="12">Reminder: this is a large ship.</t>
    <t id="13">Reminder: this is an extra large ship.</t>
  </page>
</language>
```

Some points about the example:

- **The category is the extension's settings table.** Any script reads `param.example_parameters.<name>`, and a player or another extension changes a value with the same `<replace>` on `@value` the example applies to the autosave, selected by category and parameter name.
- **A value is an expression.** `15min` is a time, `7` an integer, and the table is keyed by `class.` constants. A string would need quotes. The reading script decides what the value means; `delay` takes the time, `show_help` the index.
- **A delay, not a check interval.** A cue's `checkinterval` must be constant, by its documentation, so the loop is a `<delay>` with the parameter as its expression, followed by `reset_cue`.
- **The `?` on the table lookup** keeps small ships quiet: a class without an entry gives no reminder, instead of a reminder with an empty text.
- **The position** is the index into `<hintpositions>`; 7 is the bottom centre entry of the vanilla list.
- **The two replaced values** apply to the whole game, as every value in this file does: the autosave triggered by the timer comes after an hour instead of eighty minutes, and the engine's limit of ten simultaneous missions, defined but switched off in vanilla, is on.
- **The texts** are the extension's own: page 1234567 stands for its page. `readtext.{page}.{id}` resolves a text id held in a variable, where the `{page,id}` form needs constants.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[loadoutrules.xml](/x4/modding-support/anatomy-of-game-data/libraries/loadoutrules-xml/) is the file behind the unit fill that `<loadout>` sets the default level for. [jobs.xml](/x4/modding-support/anatomy-of-game-data/libraries/jobs-xml/) explains the quota cleanup that `<jobs>` tunes, and [god.xml](/x4/modding-support/anatomy-of-game-data/libraries/god-xml/) the quotas and module limits that `<god>` and `<economy>/<modulelimits>` factor. [drops.xml](/x4/modding-support/anatomy-of-game-data/libraries/drops-xml/) holds the drop lists while `<drop>` holds the chances. [notificationtypes.xml](/x4/modding-support/anatomy-of-game-data/libraries/notificationtypes-xml/) defines the notifications whose cooldowns sit in the `cooldown` category. [quotas.xml](/x4/modding-support/anatomy-of-game-data/libraries/quotas-xml/) limits mission offers per type and space, a separate mechanism from the player's mission limit in `<missions>`.

[↑ Contents](#toc)
