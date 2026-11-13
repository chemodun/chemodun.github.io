---
title: stances.xml
description: How libraries/stances.xml defines ship stances - the modes a ship can be switched into, such as a cloak, each with an influence list, a minimum and maximum duration, a cooldown, tags, effects and an animation - how a ship macro lists the stances it supports, how the player and the AI scripts switch them, the script side, and how an extension adds a stance of its own.
---

# stances.xml

A **stance** is a mode a ship can be switched into and out of: a cloak that hides it from sensors at the price of speed and weapons, or a deployed state in which it cannot move. While a stance is active the ship is under the influences the stance names, and switching is limited by a minimum time, a maximum time and a cooldown. Which stances exist is defined in `libraries/stances.xml`; which of them a ship supports is listed in its macro.

The base game ships the mechanism and an empty file. One expansion pack adds the first stance, and the base game's AI scripts already handle ships that have one.

This article covers the format, how a ship gets a stance and how it is switched, what the AI scripts do with stances, the script side and how an extension adds a stance. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Stance**: one `<stance>` of the file, identified by its `id`.
- **Supported stances**: the stances a ship can take, listed in its macro. A ship without such a list has no stances, which is true of almost every ship.
- **Active stance**: the stance a ship is in at the moment, or none.
- **Default stance**: the stance a ship is in when no other is chosen. A ship may have none, and then its normal state is the one without any stance; the interface calls that state Neutral.
- **Influence list**: a named set of temporary changes to an object, defined in `libraries/influenceconfigurations.xml`. A stance does its work through one.
- **Tags**: free words on a stance by which the AI scripts find the stance fit for a situation, without knowing its id.

[↑ Contents](#toc)

## How a stance is used

Three things have to come together:

1. **The stance is defined** in `libraries/stances.xml`.
2. **A ship macro lists it.** The macro's `<properties>` hold a `<stances>` block with one `<stance ref="..."/>` per supported stance.
3. **Something activates it** on a ship of that macro: the player, an AI script or an MD script.

The player switches in the ship menu of the ship being flown: for a ship with stances the menu shows a row "Stance" with a dropdown of the supported stances, each with its icon and name and its description as a tooltip. When the ship has no default stance, the dropdown gets a "Neutral" entry at the top that stands for no stance. The dropdown is locked while a switch is not allowed, with the tooltip "Stance change is in progress." There is also an input action, Toggle Ship Stance.

When a stance is activated, its influence list applies to the ship, its activation effect is created and its animation trigger fires. The ship then cannot switch again until the stance's minimum duration has passed. The stance ends when it is deactivated or when its maximum duration runs out, and the cooldown starts, during which no switch is possible either.

[↑ Contents](#toc)

## The file

### Layout

The base file is empty apart from one comment, which states the assumption the AI scripts rely on:

```xml
<stances>
  <!-- default stance (no stance active) assumed to allow attack -->
</stances>
```

The one vanilla stance comes from the `ego_dlc_mini_02` pack:

```xml
<stances>
  <stance id="envoy_cloak" name="{1048,1}" description="{1048,2}" icon="stance_cloak" influencelist="envoy_cloak"
          minduration="12" maxduration="-1" cooldown="12" tags="covert evasive">
    <effects activation="envoy_cloak_activate" deactivation="envoy_cloak_deactivate" />
    <animation path="active">
      <triggers activation="activate" deactivation="deactivate" />
    </animation>
  </stance>
</stances>
```

The file is a flat list of `<stance>` elements. Each may hold one `<effects>` and one `<animation>` child.

The schema, `libraries/stances.xsd`, documents every attribute.

[↑ Contents](#toc)

### Attributes

| Attribute | Meaning |
| --- | --- |
| `id` | The stance id, which the ship macros and the scripts refer to |
| `name` | The name shown in the stance dropdown, a text reference |
| `description` | The description shown as the tooltip of the dropdown entry |
| `icon` | The icon shown before the name, an icon id from `libraries/icons.xml` |
| `influencelist` | The id of the influence list of `libraries/influenceconfigurations.xml` that applies while the stance is active |
| `minduration` | The seconds the stance has to stay active before it can be deactivated again; default 0 |
| `maxduration` | The seconds after which the stance is deactivated automatically; the default is no limit, which vanilla writes as `-1` |
| `cooldown` | The seconds after the stance's deactivation before another switch is allowed; default 0 |
| `tags` | Words for the AI scripts to pick the stance by, separated by spaces |

Text page `1048` of the base game holds the stance names and descriptions, and the base `icons.xml` has three stance icons: `stance_cloak`, `stance_neutral` and `stance_stationary`.

[↑ Contents](#toc)

### Effects and animation

| Element | Attribute | Meaning |
| --- | --- | --- |
| `<effects>` | `activation` | The effect from `libraries/effects.xml` created when the stance is activated |
| | `deactivation` | The effect created when it is deactivated, which includes the case of another stance being activated |
| `<animation>` | `path` | The animation path the ship has while the stance is active |
| `<animation><triggers>` | `activation` | The animation trigger fired when the stance is activated |
| | `deactivation` | The trigger fired when it is deactivated. It does not fire when the ship goes straight into another stance; that stance's activation trigger is used |

Both children are optional. The animation refers to the ship's model, so a stance with an `<animation>` fits the ships built for it: the pack's corvette has a model part tagged for the stance.

[↑ Contents](#toc)

### The influence list of a stance

What a stance does to the ship is not in this file but in the influence list it names. The pack's cloak list shows the form such a list takes:

- **Lasting influences use an envelope profile with a sustain duration of `-1`.** The cloak sets multipliers on the ship's radar cloaking and radar range, switches off boosting and shooting, and lowers the top speed, each with `sustainduration="-1"`.
- **Short influences shape the transition.** The same list holds a brief, strong speed cut with a sustain of under a second, and delays the lasting speed limit by the same time, which gives the switch a lurch.
- **The list has no name, description or icon.** The player sees those of the stance.

The influence types and profiles are covered in the [influenceconfigurations.xml](/x4/modding-support/anatomy-of-game-data/libraries/influenceconfigurations-xml/) article.

[↑ Contents](#toc)

## What the AI scripts do with stances

The base game's AI scripts work with stances through tags and through the default stance, never through an id, so they apply to any stance an extension defines.

- **Attacking returns to the default stance.** The attack scripts check for a ship that has stances and is not in its default one. If it may switch, they activate the default stance before the attack run; if it may not yet, they skip the run. This is the assumption of the comment in the base file: a stance may forbid firing, the default state has to allow it. The attack order remembers a non-default stance the ship started in and restores it at the end.
- **`covert` is taken for scouting and for visiting stations.** The recon order and the station visiting routine activate the stance tagged `covert` on a ship that may switch.
- **`immobile` marks a deployed ship.** The mining and engineer scripts handle a mining rig with a stance tagged `immobile`: the rig activates it to deploy, its trade offers are set up when it does, and the miners attached to it wait for the change. The base game has the text for such a stance, "Deploy", and an icon; no vanilla ship lists such a stance in 9.00.

A stance of an extension therefore gets sensible behaviour from the tags alone: `covert` makes NPC pilots use it when they scout, and a stance that blocks weapons is left by them before a fight, as long as the ship's default state can fire.

[↑ Contents](#toc)

## How the expansions change it

No story expansion ships a `stances.xml`. The `ego_dlc_mini_02` pack ships a whole file with the one stance shown above, gathered with the empty base file, together with the influence list and the corvette macro that lists the stance. The base game carries what the stance needs outside that pack: the texts, the icons, the menu row, the input action and the AI script handling.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `$ship.stances.list`, `.count` | The ids of the stances the ship supports, as a list of strings, and how many there are |
| `$ship.stances.active` | The id of the active stance, or null |
| `$ship.stances.default` | The id of the default stance, or null |
| `$ship.stances.{[tag.covert]}` | The stance of the ship that has all the listed tags. Vanilla writes it in the short form `stances.[tag.covert]` |
| `$ship.stances.random` | The id of a random supported stance |
| `$ship.stances.canswitch` | Whether the ship may switch stance right now |
| `$ship.stances.unlocktime` | The earliest game time at which switching is allowed again |
| `activate_ship_stance ship="..." stance="..."` | Activates a stance by id. It has to be in the ship macro's list |
| `activate_ship_stance_by_tag ship="..." tags="..."` | Activates the stance that has the given tag or list of tags |
| `activate_default_ship_stance ship="..."` | Activates the ship's default stance |
| `event_object_stance_activated` | A ship activated a stance: the object is the ship, `param` the stance id; the condition takes `stance` to narrow it |

The actions and the event are available in MD and AI scripts. Vanilla's combat and recon scripts test `stances.canswitch` before they activate a stance.

[↑ Contents](#toc)

## Adding a stance from an extension

A new stance takes four small files: the stance, its influence list, the texts, and a ship macro that lists it. The example below, for a fictional extension `example_stance`, gives the Argon Nova a "silent running" stance: harder to see on sensors, slower and without boost.

`libraries/stances.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/stances">
    <stance id="example_silent_running" name="{1234567,1}" description="{1234567,2}" icon="stance_cloak" influencelist="example_silent_running" minduration="10" cooldown="20" tags="covert" />
  </add>
</diff>
```

`libraries/influenceconfigurations.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/influencelistconfigurations">
    <influencelist id="example_silent_running">
      <influences>
        <influence type="radarcloak">
          <profile type="envelope" sustainvalue="0.5" sustainduration="-1" />
        </influence>
        <influence type="maxforwardspeed">
          <profile type="envelope" sustainvalue="0.6" sustainduration="-1" />
        </influence>
        <influence type="disableboost">
          <profile type="envelope" sustainduration="-1" />
        </influence>
      </influences>
    </influencelist>
  </add>
</diff>
```

`assets/units/size_s/macros/ship_arg_s_fighter_01_a_macro.xml`, a diff on the Nova's macro at the path it has in the game:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/macros/macro[@name='ship_arg_s_fighter_01_a_macro']/properties">
    <stances>
      <stance ref="example_silent_running" />
    </stances>
  </add>
</diff>
```

`t/0001-l044.xml`, with the page id the extension owns:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example stances" descr="" voice="no">
    <t id="1">Silent Running</t>
    <t id="2">This stance halves the range at which the ship appears on others' sensors. It lowers the ship's top speed and disables boosting.</t>
  </page>
</language>
```

Some points about the example:

- **The stance and its list share an id** by choice; they are separate things in separate files, linked by the `influencelist` attribute. Vanilla does the same.
- **The profiles follow the vanilla cloak**: envelope, sustain duration `-1`. For `radarcloak` a value of `1` is no cloaking and `0` full cloaking, so `0.5` is half.
- **Weapons stay usable**, so the stance gives nothing up in a fight. The AI attack scripts still leave it for the default state when a fight starts, because they do so for any stance that is not the default.
- **The `covert` tag** is all it takes for NPC pilots of a Nova to switch to it on a recon order.
- **No effects and no animation.** Both children are optional, and an animation would need a model made for it.
- **The times are the feel of it.** Ten seconds before it can be left and twenty before the next switch keep the stance from being flicked on and off; the menu shows the lock.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[influenceconfigurations.xml](/x4/modding-support/anatomy-of-game-data/libraries/influenceconfigurations-xml/) covers the influence lists a stance works through: the types, the profiles and the class blocks.

[↑ Contents](#toc)
