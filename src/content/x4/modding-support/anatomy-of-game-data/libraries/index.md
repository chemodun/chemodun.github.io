---
title: libraries
description: What is in libraries/ in version 9.00 - every data table the game reads, grouped by subject, with what each file holds, its root element and how the expansions add to it.
order: 1
wiki: libraries
wikiRef: also
---

<!-- Canonical copy; the Egosoft wiki page is exported from it -->

# libraries

`libraries/` is where the universe is defined. Which wares exist and what they cost, which factions own what and how they feel about each other, which ships and stations the game creates and where, how a crew is skilled, what the player's keys do. Each of those is one XML file, and most mods that change the game rather than add behaviour to it change one of these files with a diff.

This article lists every file in the folder as version 9.00 ships it, grouped by subject, with what it holds and the root element a diff addresses. Where an article covers a file in full, the row links to it. It describes version 9.00.

Three things hold for the whole folder. A file is a collection, so an extension can add to it with a whole file of its own that is gathered with the base one, or change it with a diff; [How a file joins the game](/x4/modding-support/anatomy-of-an-extension/#how-a-file-joins-the-game) covers the choice. A file whose root element carries `xsi:noNamespaceSchemaLocation` names the schema that describes it, and `libraries.xsd` is the one shared by the ship, station, module, room, character, god and job tables; the schema is the authoritative description of what a file may contain. And a name in `{page,id}` form is a text reference into `t/`, so adding an entry with a name of its own also means a text file.

The last column says what the expansions do with the file. **diff** means every expansion that touches it ships a `<diff>`; **whole** means they ship a complete file that is gathered with the base one; **both** means some do one and some the other, which is a sign that either form works. An empty cell means no expansion touches the file. Reading an expansion's copy is the quickest way to see a working example of either form.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Wares, ships, stations and equipment

What exists in the universe and what it is made of.

| File | Root | Holds | Expansions |
| --- | --- | --- | --- |
| `wares.xml` | `<wares>` | Every ware: price range, volume, production recipes, owners, restrictions and the component it stands for; a ship, module, weapon or paint is a ware here too, which is what makes it buildable and buyable | diff |
| `waregroups.xml` | `<groups>` | The ware groups (agricultural, energy, food, hightech...), each with its name, icons and tier | |
| `baskets.xml` | `<baskets>` | Named ware baskets, from a single ware up to a faction's whole trade list; what a trade job or a trader stock refers to | diff |
| `stock.xml` | `<stocks>` | What an NPC trader of a given faction and entity type carries, as wares or baskets with min, max and chance | diff |
| [`drops.xml`](/x4/modding-support/anatomy-of-game-data/libraries/drops-xml/) | `<droplists>` | Drop lists: what a destroyed ship, a mined asteroid or an opened lockbox leaves behind, built from reusable ware and ammunition baskets; the linked article covers it in full | whole |
| `ships.xml` | `<ships>` | The ship table used to select ships by faction, size and tags: each entry names a macro and its categories | whole |
| `shipgroups.xml` | `<groups>` | Named groups of ship macros per faction and role (`arg_builder_xl`, ...), the `select` targets jobs and god entries use | whole |
| `stations.xml` | `<stations>` | The station table for selection by faction and tags: each entry names a station group and its categories | both |
| `stationgroups.xml` | `<groups>` | Named groups of stations, each selecting a construction plan | both |
| `constructionplans.xml` | `<plans>` | Complete station layouts, module by module with positions; what a god entry or a station group places, and what the game saves a player design as | whole |
| `modules.xml` | `<modules>` | The station module table: each module macro with its categories (faction, type, tags) for selection | both |
| `modulegroups.xml` | `<groups>` | Named groups of module macros by purpose, used when a station is built up from parts | whole |
| `modulesets.xml` | `<modulesets>` | The station kinds a faction can build (factory, wharf, shipyard...), which races get each, and whether a construction vessel is required | whole |
| `loadouts.xml` | `<loadouts>` | Named ship loadouts: engines, shields, weapons, software and consumables for a given macro | whole |
| [`loadoutrules.xml`](/x4/modding-support/anatomy-of-game-data/libraries/loadoutrules-xml/) | `<rules>` | Which drone and deployable macros of which mark a unit may carry (transport, defence, build, mine, repair, lasertower, satellite...), by category and tags; the linked article covers it in full | diff |
| `equipmentcompatibilities.xml` | `<compatibilitytypes>` | The compatibility classes equipment and slots share (standard, missile, mining, highpower, venture...) | |
| `equipmentmods.xml` | `<equipmentmods>` | Equipment modifications: for each weapon, engine, ship and shield mod ware, the bonus ranges by quality | diff |
| `paintmods.xml` | `<paintmods>` | Paint modifications: hue, brightness, metal, dirt and pattern per paint ware | |
| `clothingmods.xml` | `<clothingmods>` | The same for clothing | |
| `themes.xml` | `<themes>` | Paint and clothing themes: which paint mod a faction or group uses by default | diff |
| `adsigns.xml` | `<adsigns>` | Which advertisement sign macro shows for which ware, by sign type and faction | diff |
| `props.xml`, `propgroups.xml` | `<props>`, `<groups>` | Dock area props and their groups: which prop macros fill a corner or a slot, by tags | diff (`props.xml`) |
| `rooms.xml`, `roomgroups.xml` | `<rooms>`, `<groups>` | Station interior rooms and their groups, with categories for selection | whole |

[↑ Contents](#toc)

## Factions and people

Who lives in the universe, and the crews that fly it.

| File | Root | Holds | Expansions |
| --- | --- | --- | --- |
| [`factions.xml`](/x4/modding-support/anatomy-of-game-data/libraries/factions-xml/) | `<factions>` | Every faction: name, race, colour and icon, account, licences, relations to the others and the signals it reacts to; the linked article covers it in full | diff |
| [`races.xml`](/x4/modding-support/anatomy-of-game-data/libraries/races-xml/) | `<races>` | The races: name and name pool, icon, relations, and per-race settings for characters, agents, spacesuits, engine effects and trails; the linked article covers it in full | |
| [`diplomacy.xml`](/x4/modding-support/anatomy-of-game-data/libraries/diplomacy-xml/) | `<diplomacy>` | The diplomacy system: actions, events, gifts, the experience and rank tables, and the influence cost curve; the linked article covers it in full | diff |
| `characters.xml` | `<characters>` | The character table for selection by faction, entity type and tags; each entry names a character macro and its categories | diff |
| `charactergroups.xml` | `<characters>` | Named groups of character macros | diff |
| `character_components.xml`, `character_macros.xml` | `<components>`, `<macros>` | The character components and macros themselves, with the body parts, faces, animations and identification each is built from; the same shape as the components and macros under `assets/` | whole |
| `bodypartgroups.xml` | `<bodypartgroups>` | The named groups a body part belongs to (casual, terran) | |
| [`people.xml`](/x4/modding-support/anatomy-of-game-data/libraries/people-xml/) | `<peopledefinitions>` | Crew populations: for each definition, how full a ship's crew is and which roles are drawn from which factions and tags; the linked article covers it in full | whole |
| `entitytypes.xml` | `<entitytypes>` | The entity types an NPC can be (officer, trader, faction representative, shady guy, crowd, agent), with names and icons | |
| `posts.xml` | `<posts>` | The control posts on a ship or station (pilot, manager, defence...), which skills each weighs and who may hold it | |
| `roles.xml` | `<roles>` | The crew roles (service, marine, passenger, prisoner, worker, unassigned), the skills each weighs and its tier names | |
| `assignments.xml` | `<assignments>` | The assignments a subordinate can be given (defence, attack, interception, trade...), and whether a ship or a station can be the commander | |
| `purposes.xml` | `<purposes>` | The purposes of ships and station modules (trade, fight, build, mine, production, storage, habitation...) and the icon each gives per class | |
| `experiences.xml` | `<experiences>` | How much skill an event gives: for each experience id, the skills it trains for the individual and for the group, with base, falloff and limit | |
| `npc_tools.xml` | `<tools>` | The props an NPC carries in an animation (tools, mugs) | |
| `emotedb.xml` | `<emotes>` | The emotes a character animation can show | |
| `stances.xml` | `<stances>` | Stances (empty in the base game) | |

[↑ Contents](#toc)

## Populating the universe

What the game places at the start of a game and keeps in place afterwards.

| File | Root | Holds | Expansions |
| --- | --- | --- | --- |
| [`god.xml`](/x4/modding-support/anatomy-of-game-data/libraries/god-xml/) | `<god>` | What the god engine places: stations, products, objects and landmarks, with quotas and locations; the linked article covers it in full | diff |
| [`jobs.xml`](/x4/modding-support/anatomy-of-game-data/libraries/jobs-xml/) | `<jobs>` | What the job engine keeps flying: every NPC ship job with its ship, orders, quota and location; the linked article covers it in full | both |
| [`quotas.xml`](/x4/modding-support/anatomy-of-game-data/libraries/quotas-xml/) | `<quotas>` | Galaxy-wide limits on offers (trade, fight, build, think) per zone, with overrides per cluster, sector and zone; the linked article covers it in full | |
| [`objectspawnpoints.xml`](/x4/modding-support/anatomy-of-game-data/libraries/objectspawnrules-xml/) | `<objectspawnpoints>` | Fixed positions on a station module macro where a hidden lockbox sits, with the macro that appears there; the linked article covers it in full, together with `objectspawnrules.xml` | |
| [`objectspawnrules.xml`](/x4/modding-support/anatomy-of-game-data/libraries/objectspawnrules-xml/) | `<objectspawnrules>` | Which hidden lockbox a station gets and which crystal clusters an asteroid field grows, by owner, station type, field type, size and hazard, first matching rule wins; the linked article covers it in full | |
| `targetpoints.xml` | `<targetpoints>` | Points on a module macro that a scan or a similar action targets | |
| `infounlocklist.xml` | `<infounlocklist>` | Which information about an object unlocks at which scan level, by secrecy level | |
| [`unlocks.xml`](/x4/modding-support/anatomy-of-game-data/libraries/unlocks-xml/) | `<unlocks>` | Discounts, commissions and blueprint unlocks a station scan can reveal, with the conditions, amount and duration of each; the linked article covers it in full | |

[↑ Contents](#toc)

## The map's data

What the universe files under `maps/` refer to, and the defaults every object starts from.

| File | Root | Holds | Expansions |
| --- | --- | --- | --- |
| `defaults.xml` | `<defaults>` | Default properties per component class (a dataset per class: ship sizes, turrets, asteroids, adsigns...), including the relation changes for attacking, killing, scanning and hacking | |
| `mapdefaults.xml` | `<defaults>` | The same mechanism per map macro: a dataset for the galaxy, each cluster and each sector with its balancing data, encyclopedia information and, since 9.00, its resource areas. See [Resource areas](/x4/modding-support/resource-areas/) | whole |
| `region_definitions.xml` | `<regions>` | The regions (asteroid fields, nebulae, debris) a cluster places: their shape, density, objects and effects | whole |
| `regionyields.xml` | `<regionyields>` | The resource area definitions: yield boundaries, gather speeds and the sizes of each ware's areas. See [Resource areas](/x4/modding-support/resource-areas/) | |
| `regionobjectgroups.xml` | `<groups>` | Named groups of asteroid and debris macros a region draws from | |
| `region_lodvalues.xml` | `<regionlods>` | Fade and distance values for region levels of detail | |
| `highwayconfigurations.xml` | `<highwayconfigurations>` | Tube, gate, blocker and booster configurations for local and super highways | |
| `classcatalog.xml` | `<catalogs>` | Template names per component class the map editor offers | whole |
| `component.xml`, `macro.xml` | `<components>`, `<macros>` | A few test components and macros kept outside `assets/` | whole (`macro.xml`) |
| `macrohints.xml` | `<macros>` | Macros to load at start so their first use causes no stall | |
| `patchactions.xml` | `<actions>` | Objects and components that a version replaced, and how saves are patched to the new state | whole |

[↑ Contents](#toc)

## Game starts, story and progress

| File | Root | Holds | Expansions |
| --- | --- | --- | --- |
| [`gamestarts.xml`](/x4/modding-support/anatomy-of-game-data/libraries/gamestarts-xml/) | `<gamestarts>` | Every game start: the player character, ships and property, location, known space and budgets, and the universe it runs in; the linked article covers it in full | diff |
| [`missiongroups.xml`](/x4/modding-support/anatomy-of-game-data/libraries/missiongroups-xml/) | `<missiongroups>` | The mission groups offers are sorted into in the mission menu: guilds, wars, stories and game starts, each with its faction and enemy; the linked article covers it in full | whole |
| `timeline.xml` | `<timeline>` | The history timeline the encyclopedia shows: dated entries with text, voice and video | |
| `chapters.xml` | `<categories>` | Empty in the base game; filled by the ventures extension | |
| `terraforming.xml` | `<terraforming>` | Terraforming: the planet stats and their ranges, the project groups and the projects with their resources and effects | diff |
| [`stats.xml`](/x4/modding-support/anatomy-of-game-data/libraries/stats-xml/) | `<stats>` | The statistics the game tracks (time played, distance flown, trades, missions, diplomacy, terraforming...), each with its name text and units; the linked article covers it in full | |
| [`notificationtypes.xml`](/x4/modding-support/anatomy-of-game-data/libraries/notificationtypes-xml/) | `<notificationtypes>` | The notification types the player can switch off in the settings, in three categories, which scripts check before showing a message; the linked article covers it in full | |
| `voicesequences.xml` | `<voicesequences>` | Spoken sequences: delays and lines from a text page, by id | |
| `news.xml` | `<news>` | The start menu news items, their icons and store links per platform | |
| [`startmenu.xml`](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/) | `<startmenu>` | The start menu background scenes: cutscene, music and map per scene; the linked article covers it in full | diff |
| `progressbar.xml` | `<progressbar>` | The expected duration of each loading step, for the loading bar | |
| `influenceconfigurations.xml` | `<influencelistconfigurations>` | Status effects an object can be under (EMP, disabled boost or travel...), with their profile and duration per class | whole |

[↑ Contents](#toc)

## Balancing and behaviour

| File | Root | Holds | Expansions |
| --- | --- | --- | --- |
| `parameters.xml` | `<parameters>` | The game's tuning numbers in one place: player and AI flight, combat, first person, prices, skills and much more, one section per subject | diff |
| `behaviours.xml` | `<behaviours>` | Dogfight behaviour sets: which manoeuvres an AI pilot may pick in normal and evasive flight, with chance and minimum skill | |
| `camerasettings.xml` | `<camerasettings>` | Follow camera speed and offsets per ship class | whole |
| `aicompat.xml` | `<compatibility>` | For each AI script and version, where a script running in a save may be resumed after the script changed; the game's own save compatibility table for `aiscripts/` | |

[↑ Contents](#toc)

## Input, interface and configuration

| File | Root | Holds | Expansions |
| --- | --- | --- | --- |
| `inputmap.xml` | `<inputmap>` | The input actions, states and ranges the game knows, with the default keyboard and mouse binding of each | |
| `inputmap_defaults_*.xml` | `<inputmap>` | One default binding set per supported controller, joystick and HOTAS | |
| `contexts.xml` | `<inputcontexts>` | The input contexts (flight, map, menu, first person...) and which actions are active in each | |
| `controlschemes_*.xml` | `<controlschemes>` | The control schemes the options menu offers, default, experimental and movie capturing | |
| `inputfeedback.xml` | `<inputfeedback>` | Which actions give a control message or a voice confirmation | |
| `mousecursors.xml` | `<index>` | The cursor images in `mousecursors/`, by name | |
| `icons.xml` | `<icons>` | Every named icon: its texture and size; the names an `icon="..."` in a library, a script or Lua refers to | whole |
| `colors.xml` | `<colormap>` | The named colours the interface and the map use, the mappings between them, and the colour blindness transformations | |
| `fonts.xml`, `fonts-l0NN.xml` | `<fonts>` | The fonts and aliases, with one file per language that needs its own | |
| `languages.xml` | `<languages>` | The languages the game offers, with their ids | |
| `config.xml`, `config_*.xml` | `<root>` | The graphics options and the low, medium and ultra presets, plus the Linux and Steam Deck variants | |

[↑ Contents](#toc)

## Rendering, effects and sound

These files describe how things look and sound rather than what they are, and are mostly the domain of asset work.

| File | Root | Holds | Expansions |
| --- | --- | --- | --- |
| `effects.xml` | `<effects>` | The effect library: weapon, damage, explosion and generic effects built from elements, states and references | whole |
| `particle_effects.xml` | `<effects>` | Particle effect parameters and their level of detail classes | diff |
| `lens_effects.xml` | `<lenseffects>` | Lens flares and glows | diff |
| `trail_effects.xml` | `<effects>` | Engine trails per ship size | both |
| `trigger_events.xml` | `<effects>` | The events an effect can be triggered by (damage, activation, opening...) | |
| `eventdefs.xml` | `<events>` | The events a cutscene can raise, with the meaning of each parameter | |
| `animation_sequences.xml` | `<sequencestates>` | Animation state machines, such as a door's closed, opening, open and closing states and the triggers between them | diff |
| `material_library.xml`, `material_library_1.xml` | `<materiallibrary>` | The materials every model refers to: shader, textures and parameters, in collections | diff |
| `envmapprobes.xml` | `<envmapprobes>` | Environment map probe presets and templates for reflections | whole |
| `renderparam_library.xml` | `<renderparameters>` | Level of detail and render rules by distance and size | |
| `medium_library.xml` | `<library>` | The media light passes through: fog and air absorption and phase settings | |
| `volume_library.xml` | `<volumes>` | Volumetric fog definitions and their textures | |
| `stardust_library.xml` | `<stardust>` | The stardust configuration | |
| `sound_library.xml` | `<soundlibrary>` | Every sound: its files, volume, range and variation | diff |
| `sound_env_library.xml` | `<soundenvironmentlibrary>` | Sound environments (room size, density, occlusion) by place | |
| `audiologs.xml` | `<audiologs>` | Audio logs (empty in the base game) | |

[↑ Contents](#toc)

## Schemas and tool files

Not data, but what describes and reads the data.

| File | Holds |
| --- | --- |
| `libraries.xsd` | The schema for `ships.xml`, `stations.xml`, `modules.xml`, `rooms.xml`, `characters.xml`, `props.xml`, `modulesets.xml`, `god.xml` and `jobs.xml` |
| `common.xsd` | The types and the script commands shared by MD and AI scripts: class and ware lookups, the expression grammar, and the actions and conditions both script languages accept. See [Scripting/MD/Libraries/Map](/x4/modding-support/scripting-md-libraries-map/) |
| `md.xsd`, `aiscripts.xsd` | The schemas of the two script languages, each including `common.xsd` |
| `diff.xsd` | The schema of a diff file. See [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/) |
| `<name>.xsd` | The schema of the file of the same name, for the files that have one: `colors`, `diplomacy`, `drops`, `effects`, `factions`, `gamestarts`, `influenceconfigurations`, `inputfeedback`, `loadoutrules`, `material_library`, `missiongroups`, `notificationtypes`, `objectspawnpoints`, `objectspawnrules`, `parameters`, `people`, `quotas`, `races`, `region_definitions`, `region_lodvalues`, `regionobjectgroups`, `regionyields`, `sound_library`, `stances`, `stats`, `terraforming`, `timeline`, `unlocks`, `voicesequences`, `audiologs`, `classcatalog` |
| `scriptproperties.xml`, `.xsd`, `.xsl`, `.css` | The script property reference: every datatype, keyword and property an expression can use. `scriptproperties.html` in the game's root renders it in a browser |
| `editor.xml`, `editor.js`, `editor.css` | The job editor's configuration, with `jobeditor.html` in the game's root |
| `animation_sequences.dtd`, `icons.dtd`, `lenseffects.dtd` | Document type definitions for three of the files above |

[↑ Contents](#toc)

{{children}}
