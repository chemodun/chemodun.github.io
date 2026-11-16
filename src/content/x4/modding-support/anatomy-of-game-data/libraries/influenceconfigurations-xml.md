---
title: influenceconfigurations.xml
description: How libraries/influenceconfigurations.xml defines influence lists - the temporary effects a weapon hit, a region, a placed object or a script puts on a ship or spacesuit, such as a disabled travel drive, reduced speed, damage over time or an oxygen recharge - with the influence types, the value profiles, the per-class blocks, the script side, and how an extension adds a list of its own.
---

# influenceconfigurations.xml

An EMP missile that switches off the target's boost and travel drive, an ion blaster that makes a fighter's guns stutter, a patch of radiation that eats at a spacesuit, an oxygen station that refills it: all of these are **influences**, temporary changes the game puts on an object and takes away again on its own. Which influences exist, what each changes, by how much and for how long is defined in `libraries/influenceconfigurations.xml`, as named **influence lists**. Weapons, regions, placed objects and scripts refer to a list by its id.

This article covers the format, the influence types and profiles, where the lists are used, the script side and how an extension adds a list. It describes version 9.00.

The word has a second meaning in 9.00: the player's diplomatic **influence**, with `player.influence` and the `influence` keyword on the script side. That is part of the diplomacy system and unrelated to this file.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Influence**: one change to one property of an object for a limited time, for example a multiplier on its maximum forward speed, or a block on its travel mode.
- **Influence list**: a named set of influences applied together, one `<influencelist>` of the file. It is the unit everything else refers to.
- **Class block**: an `<influences>` element inside a list. A list can hold several, each for different object classes, so the same hit can do one thing to a fighter and another to a destroyer.
- **Profile**: how an influence's value runs over time: held for a duration, or shaped as an envelope with attack, sustain and release phases.
- **Influence object**: a placed object of class `influenceobject` that keeps applying a list to what is near it.

[↑ Contents](#toc)

## How an influence reaches an object

A list does nothing until something applies it. The game has several sources, and each names the list by id:

1. **A weapon hit.** A bullet macro carries the list on its `<bullet>` element and a missile macro on its `<missile>` element, both in an `influencelist` attribute. The list is applied to what the shot hits. The ion weapons and the EMP missiles of the base game work this way.
2. **A region.** A region definition in `libraries/region_definitions.xml` can hold an `<influence ref="..."/>` field, which reapplies the list to the objects inside at an interval, one second by default. The field can be marked hazardous, which brings in the navigation and warning behaviour of a hazard region. Vanilla uses it in a tutorial region that keeps the travel drive off.
3. **An influence object.** A macro of class `influenceobject` carries `<influencelist id="..." delay="..."/>` in its properties. The oxygen recharger and the radiation hazard of the spacesuit levels are such objects.
4. **A defused bomb.** A bomb macro's `<defuse>` element can name a list; one Timelines scenario uses it.
5. **A stance.** The schema of `libraries/stances.xml` gives a stance an `influencelist`. The base game defines no stances.
6. **A script**, with `apply_influencelist`.

When a list is applied, the game picks the first class block that fits the object and starts every influence in it. Each influence then runs its profile and ends by itself.

A weapon's list also shows in the interface: when the list has a name, the weapon's page in the encyclopedia shows a row "Impact Influence" with the name, and the description below it. The weapon statistics table the menus share carries the same two rows.

[↑ Contents](#toc)

## The file

### Layout

```xml
<influencelistconfigurations>
  <influencelist id="emp_missile" name="{20230,2001}" description="{20230,2002}" icon="heavy_MAM_disruption">
    <influences classes="ship_xs ship_s ship_m">
      <influence type="disableboost">
        <profile type="continuous" duration="30" />
      </influence>
      <influence type="disabletravel">
        <profile type="continuous" duration="30" />
      </influence>
    </influences>
    <influences classes="ship_l ship_xl">
      <influence type="disableboost">
        <profile type="continuous" duration="18" />
      </influence>
      <influence type="disabletravel">
        <profile type="continuous" duration="18" />
      </influence>
    </influences>
  </influencelist>
  <influencelist id="recharge_oxygen">
    <influences classes="spacesuit">
      <influence type="chargeoxygen">
        <profile type="continuous" startvalue="25" duration="1" />
      </influence>
    </influences>
  </influencelist>
  ...
</influencelistconfigurations>
```

The file is a flat list of `<influencelist>` elements. Each holds one or more `<influences>` class blocks, each block one or more `<influence>` elements, and each influence exactly one `<profile>`.

The base file holds the lists of the base game's disruption weapons, the region and spacesuit lists, two lists that fix the engine glow and flame of a ship, and a few test lists. At its end sits a block of commented examples. They are worth reading for the ideas, with one caution: some of them use names the schema does not list, the type `shieldhulldamage` and the profile `ticking`, where the schema has `hullshielddamage` and the two profiles described below.

The schema, `libraries/influenceconfigurations.xsd`, documents every element, type and attribute.

[↑ Contents](#toc)

### The list

| Attribute | Meaning |
| --- | --- |
| `id` | The list id: letters, digits and underscores, not starting with a digit. Weapons, regions, objects and scripts refer to it |
| `name` | The name shown to the player, a text reference. Vanilla's weapon lists take theirs from text page `20230` |
| `description` | The description shown with it |
| `icon` | The icon of the influence, an icon id |
| `effect` | An effect definition played with the influence |
| `localeffect` | `true` lets the effect sit at a location given by the source of the influence, which per the schema only a bullet does, at its point of impact. The default places the effect at the centre of the object |

Only `id` matters to the mechanics. A list a weapon carries gets a name and a description, because the interface shows them; the internal lists, such as the oxygen recharge, have neither. No list of the base file sets `effect` or `localeffect`.

[↑ Contents](#toc)

### Class blocks

`<influences classes="...">` limits a block to the listed object classes, separated by spaces. A block without `classes` fits every object.

When a list has several blocks, the game takes the first one whose classes fit the object, and only that one. The order therefore matters:

- **Specific blocks go first.** A block for `ship_s` followed by one for `ship` treats small ships one way and every other ship the other way. In the opposite order the `ship` block would catch everything.
- **An object no block fits is not affected.** Vanilla's light targeting disruption has a block for extra small and small ships and one for medium ships, and nothing else, so the influence does not touch a capital ship the weapon hits. This is how a disruption is made to work against some sizes only.

Vanilla uses the ship classes, from `ship_xs` to `ship_xl` and the general `ship`, and `spacesuit`.

[↑ Contents](#toc)

### Influence types

`<influence type="...">` names the property the influence acts on. The types fall into four kinds, which differ in what the profile's value means and in how several influences of the same type on one object combine.

| Type | What it does | Several at once |
| --- | --- | --- |
| `hulldamage` | Damages the hull directly | Add up |
| `shielddamage` | Damages the shields | Add up |
| `hullshielddamage` | Damages the shields first, then the hull | Add up |
| `hullnoshielddamage` | Damages the hull only while the shields are down | Add up |
| `hullrepair` | Repairs the hull | Add up |
| `shieldrepair` | Recharges the shields | Add up |
| `chargeoxygen` | Recharges oxygen | Add up |
| `maxforwardspeed`, `maxreversespeed` | Multiplier on the maximum forward or reverse speed | Multiply |
| `maxstrafespeed` | Multiplier on the maximum strafe speed, both directions | Multiply |
| `maxsteeringspeed` | Multiplier on the maximum steering speed, all directions | Multiply |
| `forwardacceleration`, `reverseacceleration` | Multiplier on the forward or reverse acceleration | Multiply |
| `strafeacceleration` | Multiplier on the strafe acceleration, both directions | Multiply |
| `steeringacceleration` | Multiplier on the steering acceleration, all directions | Multiply |
| `radarrange` | Multiplier on the radar range | Multiply |
| `radarcloak` | Multiplier on the radar cloaking; 1 is no cloaking and 0 is full cloaking | Multiply |
| `disableboost` | No boosting while the profile runs | No stronger |
| `disabletravel` | No travel mode while the profile runs | No stronger |
| `disableshooting` | No weapon fire while the profile runs | No stronger |
| `engineglowfx` | Sets the strength of the main engine glow, whatever the ship's actual throttle | |
| `engineflamefx` | Sets the size of the main engine flame, whatever the ship's actual throttle | |

For a multiplier, a value of `1` leaves the property as it is, `0.5` halves it and `0` takes it away; a value above `1` raises it, which is how a list can also be a boost. For the three `disable` types the value plays no part, only the time does.

[↑ Contents](#toc)

### Profiles

Every influence has one `<profile>`, which gives the value over time. Times are in seconds.

A **continuous** profile holds one value for a duration:

| Attribute | Meaning |
| --- | --- |
| `type="continuous"` | |
| `startvalue` | The value |
| `duration` | How long it lasts; the default is 0 |

It is the form for switching something off for a while, `<profile type="continuous" duration="30"/>` on a `disabletravel`, and for a steady effect such as damage or an oxygen recharge. Sources that reapply a list at an interval, the regions and the influence objects, pair naturally with a duration equal to the interval: vanilla's oxygen recharger applies a one second profile every second.

An **envelope** profile moves from a start value to a sustain value, holds it, and moves on to an end value:

| Attribute | Meaning |
| --- | --- |
| `type="envelope"` | |
| `delay` | The time before the attack phase begins; default 0 |
| `startvalue` | The value before the attack phase |
| `attackduration` | The time over which the value goes from the start value to the sustain value; default 0 |
| `sustainvalue` | The value during the sustain phase |
| `sustainduration` | How long the sustain value is held; default 0 |
| `releaseduration` | The time over which the value goes from the sustain value to the end value; default 0 |
| `endvalue` | The value after the release phase |
| `loop` | `true` runs the profile again and again until it is stopped. The schema asks for caution with it |

It is the form for a slowdown that sets in and wears off: the Boron drive disruptors take a ship's maximum speed from `1` down to the sustain value over a second, hold it for a few and let it return over two more. The two engine lists use `loop="true"` with a sustain value of `1` to keep the glow and the flame at full for as long as the list stays on the ship.

[↑ Contents](#toc)

## How the expansions change it

Several expansions ship a `libraries/influenceconfigurations.xml` of their own, each a whole file with the same root that is gathered with the base one and holds only that expansion's lists:

- **Split Vendetta** adds the list of its disruptor missile.
- **Kingdom End** adds the drive and thruster disruption lists of the Boron weapons, the largest set, with a block per ship size in most of them. The Boron weapons also use the base game's ion and targeting disruption lists.
- **Timelines** adds the list of the defused bomb in one of its scenarios.
- **The `ego_dlc_mini_02` pack** adds the distortion lists of its weapons and a cloak list.

The names and descriptions of all of them are on text page `20230` of the base game.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `apply_influencelist object="..." influencelist="..."` | Applies a list to an object; `influencelist` is the id as a string expression. Available in MD and AI scripts |
| `apply_influencelist allowstop="true"` | Marks the application as one a script may stop |
| `stop_script_influences object="..."` | Stops the influences on the object that scripts applied with `allowstop`, all of them, whatever list they came from |
| `influencelist="..."` on `<bullet>` or `<missile>` of a weapon macro | The list a hit applies |
| `<influence ref="..." delay="..." hazardous="..."/>` in `libraries/region_definitions.xml` | A region field that reapplies the list |
| `<influencelist id="..." delay="..."/>` in a macro of class `influenceobject` | The list a placed object keeps applying |

There is no expression that tells which influences an object is under, and no event for one starting or ending. A script that applies a list and needs to act when it ends has to keep its own time.

Vanilla's one use of the script action is in Timelines: a scenario applies `engine_glow_fullthrottle` to a ship with `allowstop="true"`, so its engines keep glowing while it is held still, and calls `stop_script_influences` when the scene is over.

[↑ Contents](#toc)

## Adding a list from an extension

A new list is a diff on `libraries/influenceconfigurations.xml`, two texts when the list should have a name, and something that applies it. The example below, for a fictional extension `example_influence`, defines a "transit shock": each time the player's ship arrives in another sector, its travel drive stays off for a moment and, on the smaller ships, the top speed dips and recovers.

`libraries/influenceconfigurations.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/influencelistconfigurations">
    <influencelist id="example_transit_shock" name="{1234567,1}" description="{1234567,2}" icon="light_drive_disruption">
      <influences classes="ship_xs ship_s ship_m">
        <influence type="disabletravel">
          <profile type="continuous" duration="10" />
        </influence>
        <influence type="maxforwardspeed">
          <profile type="envelope" startvalue="1" sustainvalue="0.5" endvalue="1" attackduration="1" sustainduration="6" releaseduration="3" />
        </influence>
      </influences>
      <influences classes="ship">
        <influence type="disabletravel">
          <profile type="continuous" duration="4" />
        </influence>
      </influences>
    </influencelist>
  </add>
</diff>
```

`t/0001-l044.xml`, with the page id the extension owns:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example influences" descr="" voice="no">
    <t id="1">Transit Shock</t>
    <t id="2">After a gate transit the travel drive needs a moment to realign. Smaller ships also lose part of their top speed until it has.</t>
  </page>
</language>
```

`md/example_influence.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<mdscript name="Example_Influence" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="md.xsd">
  <cues>
    <cue name="Apply_Transit_Shock" instantiate="true">
      <conditions>
        <event_object_changed_sector object="player.entity"/>
        <check_value value="event.param and player.occupiedship"/>
      </conditions>
      <actions>
        <apply_influencelist object="player.occupiedship" influencelist="'example_transit_shock'"/>
      </actions>
    </cue>
  </cues>
</mdscript>
```

Some points about the example:

- **The block order does the sorting.** The first block names the three small classes; the second, for `ship`, catches what is left, the large and extra large ships, with a shorter lock and no slowdown. Swapped, the `ship` block would take every ship.
- **The envelope spans the lock.** One second down, six held and three back make ten seconds, the same as the travel lock beside it, so both end together. Nothing requires that; each influence runs on its own profile.
- **The icon is vanilla's.** `light_drive_disruption` is the icon of the Boron light drive disruption, reused here; an icon of the extension's own is an icon id like any other.
- **The condition guards the object.** `event.param` is the sector arrived in and is null inside a superhighway, and `player.occupiedship` is null while the player is not flying a ship, so the list is only applied on a real arrival at the controls.
- **A weapon needs no script.** To put the list on a hit, the bullet or missile macro names it in `influencelist`; the game applies it on impact and shows the name and description with the weapon.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[Resource areas](/x4/modding-support/anatomy-of-game-data/maps/resource-areas/) covers `libraries/region_definitions.xml`, the file in which a region's `<influence>` field is defined.

[stances.xml](/x4/modding-support/anatomy-of-game-data/libraries/stances-xml/) covers ship stances, each of which works through an influence list for as long as it is active.

[diplomacy.xml](/x4/modding-support/anatomy-of-game-data/libraries/diplomacy-xml/) covers the other influence of 9.00, the player's diplomatic influence and what it pays for.

[↑ Contents](#toc)
