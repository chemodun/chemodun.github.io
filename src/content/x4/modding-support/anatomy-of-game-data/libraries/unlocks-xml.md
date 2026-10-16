---
title: unlocks.xml
description: How libraries/unlocks.xml defines what scanning a station can reveal - the trade discounts, the commissions and the blueprint unlocks, the conditions each needs, the amount and duration it gives, the global limits on how often, the script side, and how an extension adds an unlock of its own.
---

# unlocks.xml

Flying close to a station and scanning it, or one of its signal leaks, can reveal something worth money: a **discount** on what the station sells, a **commission** on what it buys, or a **blueprint**. What can be revealed, under which conditions, how much it is worth and for how long is defined in `libraries/unlocks.xml`. The game picks from these entries whenever the player's scan qualifies, by weight among those whose conditions fit the station.

This article covers the format, the conditions and their meaning, the global limits, the script side and how an extension adds an unlock. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Unlock**: one entry of the file, a discount, a commission, a blueprint or an information unlock. The file calls the whole mechanism an unlock and names the entries bonuses in places.
- **Discount**: a percentage off the prices a station sells at, for a time. **Commission**: a percentage on top of the prices it buys at. Both are granted to the player, at one station.
- **Signal leak**: the small glowing object on a station's hull the player scans in the ship or on foot. A data leak is one kind of it.
- **Scanner level**: the level of the player ship's scanner, which decides which leaks and which unlocks are available.
- **Secrecy**: a level, -1 to 3, that a station's information and blueprints carry; an unlock can be limited to a secrecy range.

[↑ Contents](#toc)

## How an unlock is triggered

The schema describes the trigger as a check against the station the player is looking at:

1. **The player is in range and looking at the station.** The `<globals>` entry sets how close the player has to be before any check runs, and how far the player must move before the next check at the same place. The entry's own `<distance>` and `<viewangle>` narrow that further.
2. **An entry qualifies** when all of its conditions hold: the station's owner, the player's relation to that owner, what the station buys or sells, its secrecy level, the scanner level of the player's ship, and whether the player is on foot or in a spacesuit.
3. **One entry is picked by weight** among those that qualify. With a signal leak the pick is limited to the entries with `leak` set, which is the default.
4. **Its actions apply.** A discount or commission gets an amount and a duration rolled from the entry's ranges and is shown to the player; a blueprint is granted. The entry's `<rechecktime>` then holds it back at that station, and the global `rechecktime` holds every unlock back for a moment.

The scripts take over from there: `event_player_signal_unlock_finished` fires with the leak and its object, and `event_player_discount_added` and `event_player_commission_added` carry the name, the amount and the end time.

[↑ Contents](#toc)

## The file

### Layout

```xml
<unlocks>
  <globals threshold="800m" rechecktime="5s">
    <adjustment discount="{20212,1201}" commission="{20212,1301}" />
  </globals>
  <discount id="fruitfulcultivation" name="{20210,1011}" description="">
    <conditions weight="20">
      <wares sells="wheat meat spices spaceweed"/>
      <viewangle max="20"/>
      <distance exact="600m"/>
      <scannerlevel max="2" />
    </conditions>
    <actions>
      <amount min="2" max="6"/>
      <duration min="24h" max="48h"/>
    </actions>
    <rechecktime min="24h" max="36h"/>
  </discount>
  <commission id="orebounty" ...> ... </commission>
  <blueprint id="common_blueprint_l1"> ... </blueprint>
  ...
</unlocks>
```

- `<globals>` holds the limits that apply to every entry, and the names of the adjustment offsets.
- Each `<discount>`, `<commission>` and `<blueprint>` is one unlock. The schema also allows `<information>` entries, which unlock a chain of information about an object; vanilla has none.

The base file holds the vanilla discounts and commissions, a few of each per ware group and scanner level, the four blueprint unlocks, and the discount the diplomacy system of 9.00 grants. No expansion ships an `unlocks.xml`.

The schema, `libraries/unlocks.xsd`, documents every element and attribute, and a syntax example sits in a comment at the top of the file.

[↑ Contents](#toc)

### Globals

| Attribute | Meaning |
| --- | --- |
| `maxdistance` | No check runs when the target is farther away than this |
| `threshold` | After a check, no further check until the player has moved at least this far from where it was made; vanilla 800 m |
| `rechecktime` | The least time between any two unlocks being triggered; vanilla 5 s |
| `<adjustment discount="..." commission="..."/>` | The names shown for an offset: a discount that goes the other way appears as a negative commission and the reverse |

[↑ Contents](#toc)

### Conditions

`<conditions>` carries a `weight`, the entry's share of the pick among those that qualify, and three flags: `firstperson` for an unlock that needs the player on foot, `spacesuit` for one that needs a spacesuit, and `leak`, true by default, for whether the entry may be picked when a signal leak is scanned. The children narrow it:

| Element | Meaning |
| --- | --- |
| `<distance>` | The distance at which the unlock may trigger: `exact`, or `min` and `max` for a random value between them. The schema warns that `max` alone rolls from zero, which can make an unlock almost impossible to trigger; vanilla uses `exact` |
| `<viewangle max="..."/>` | How far off the player's view the station may be, in degrees; vanilla 20 |
| `<owner factions="..." negate="..."/>` | The owner the station must have, or with `negate`, must not have |
| `<relation min="..." max="..."/>` | The player's relation to the owner, as a number or a range name such as `friend`; the default minimum is the lower bound of neutral |
| `<wares buys="..." sells="..." matchall="..."/>` | Wares the station must buy or sell; one of the list by default, all of them with `matchall` |
| `<secrecy min="..." max="..."/>` | The station's secrecy level range |
| `<blueprintsecrecy min="..." max="..."/>` | For blueprint unlocks, the secrecy range of the blueprint that may be granted |
| `<scannerlevel min="..." max="..."/>` | The scanner level of the player's ship |

Vanilla's discounts and commissions come in two tiers by scanner level: the ones with `scannerlevel max="2"` give two to six percent and the ones with `min="3"` six to fourteen. Each is tied to a ware group through `<wares>`, which is how a food discount appears at a farm and an ore commission at a refinery.

[↑ Contents](#toc)

### Actions

`<actions>` is required for a discount or a commission and holds what it grants:

| Element | Meaning |
| --- | --- |
| `<amount>` | The percentage, `exact` or rolled between `min` and `max`, with an optional random `profile` (`flat`, `increasing`, `decreasing`, `bell`, `inversebell`) and `scale` |
| `<duration>` | How long it lasts, in the same form; vanilla's run one to two days |

A blueprint unlock has no `<actions>`: what it grants is a blueprint the game picks within the entry's `<blueprintsecrecy>` bounds. Vanilla has a common and a rare blueprint unlock per scanner tier, the rare one with a fifth of the weight.

`<rechecktime>`, on the entry itself, is how long the unlock stays unavailable at a station once it has triggered there, as an exact value or a range.

[↑ Contents](#toc)

### Values with units

Distances and times are written with their unit: `600m`, `2km`, `5s`, `40min`, `24h`. A value without a unit is accepted by the schema, and the form with a unit is what vanilla writes everywhere.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `player.hasdiscount.{$station}`, `player.hasdiscount.{$faction}`, `.{$id}` | Whether the player has a discount with a station or a faction, and with a given id |
| `player.hascommission.{...}` | The same for commissions |
| `add_player_discount`, `add_player_commission` | Grant the player a discount or commission at an object or with a faction: `amount` in percent, `time`, an `id`, a `name`, and for a discount `applytoshipsales` |
| `remove_player_discount`, `remove_player_commission` | Take one away |
| `add_discount`, `add_commission`, `remove_discount`, `remove_commission` | The same for any `target` faction, which is how one faction can be given a price modifier at another's stations |
| `event_player_discount_added`, `event_player_commission_added` | A discount or commission was granted: the object is the source, `param` the name, `param2` the amount, `param3` the end time |
| `event_player_signal_unlock_started`, `..._finished`, `..._failed`, `..._impossible` | The scanning of a signal leak began, succeeded, failed, or could not be done; `param` is the leak, `param2` the object it sits on |
| `get_next_bonus_unlocktime`, `set_next_bonus_unlocktime` | Read or set when a given unlock, by its id, may trigger again at an object |
| `diplomacy.action.{$id}.reward.unlocks` | The unlocks a diplomacy action may grant as its reward, in 9.00 |

The file's entries are what the game triggers on its own; the actions above are how a script grants a discount or commission directly, with an amount and a time of its choosing. Vanilla's diplomacy script does exactly that for the diplomacy discount: the entry in the file carries `leak="false"`, and the script grants it with `add_player_discount` when the action's reward comes due.

[↑ Contents](#toc)

## Adding an unlock from an extension

A new unlock is a diff on `libraries/unlocks.xml` and a text for its name. The example below, for a fictional extension `example_unlock`, adds a discount on hull parts and claytronics at stations that sell them, for players with a level 3 scanner, worth a little more than the vanilla ones and lasting longer.

`libraries/unlocks.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/unlocks">
    <discount id="example_constructionsurplus" name="{1234567,1}" description="">
      <conditions weight="5">
        <wares sells="hullparts claytronics"/>
        <viewangle max="20"/>
        <distance exact="400m"/>
        <relation min="0.01" max="1.0"/>
        <scannerlevel min="3"/>
      </conditions>
      <actions>
        <amount min="12" max="16"/>
        <duration min="48h" max="72h"/>
      </actions>
      <rechecktime min="36h" max="48h"/>
    </discount>
  </add>
</diff>
```

`t/0001-l044.xml`, with the page id the extension owns:

```xml
<?xml version="1.0" encoding="utf-8"?>
<language id="44">
  <page id="1234567" title="Example unlocks" descr="" voice="no">
    <t id="1">Construction Surplus</t>
  </page>
</language>
```

Some points about the example:

- **The id is unique across every kind of entry**, discounts and commissions alike, so a prefix of the extension's own keeps it clear of vanilla's and of other extensions'.
- **The weight is measured against vanilla's**: the level 3 discounts carry 5, so this one is as likely as any of them at a station that sells hull parts; a higher weight makes it the usual result there.
- **The relation line** keeps it for players at least friendly with the owner; without it the default allows anyone not hostile.
- **No script is needed.** The game triggers the entry, shows it, applies it to the station's prices and removes it when the duration ends.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[factions.xml](/x4/modding-support/anatomy-of-game-data/libraries/factions-xml/) defines the relation ranges the `<relation>` condition refers to.

[↑ Contents](#toc)
