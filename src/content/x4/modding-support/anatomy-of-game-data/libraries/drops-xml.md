---
title: drops.xml
description: How libraries/drops.xml defines what a destroyed ship, a mined asteroid or an opened lockbox leaves behind - the reusable ware and ammunition baskets, the droplists and their drops, how a droplist is attached to a ship, a lockbox or a mission object, how the expansions add their own, the script side, and how an extension adds a droplist.
---

# drops.xml

When a ship is destroyed, an asteroid is mined or a lockbox is opened, what floats out is decided by a **droplist**. `libraries/drops.xml` holds every droplist: which containers appear, with what chance and how many, and what each container holds, wares, money, missiles, a data entry or a shield restore. The lists are built from reusable **baskets** defined in the same file, so the common trade wares, crafting parts and missiles are written once and referred to from many lists.

This article covers the format, how a droplist reaches an object, the script side and how an extension adds a droplist. It describes version 9.00.

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Droplist**: one `<droplist>` entry, named by its `id`. An object carries at most one, and that is what it drops.
- **Drop**: one `<drop>` line inside a droplist: a container macro, a chance, a count, and what the container holds.
- **Basket**: a reusable `<wares>`, `<ammo>` or `<data>` selection defined at the top of the file and referred to by `ref` from a drop.
- **Selection**: a basket or a drop content with `selection="random"` picks one of its `<select>` entries by weight rather than giving all of them.
- **Lockbox**: a container object with a lock the player opens by shooting; its contents are a droplist like any other.

[↑ Contents](#toc)

## How a droplist reaches an object

A droplist does nothing by itself. An object has to name it, and vanilla does that in three places:

1. **The ship table.** Every entry in `libraries/ships.xml` carries a `<drop ref="..."/>`, and a ship created through that table, by `jobs.xml`, `god.xml` or a script's `create_ship` with a `ref` to an entry, drops that list. Vanilla's lists are by size and role: `ship_small_military`, `ship_medium_civilian`, `ship_large_xenon` and so on, with `masstraffic_civilian` for the traffic around stations.
2. **The object's macro.** A lockbox macro names its list in its properties, `<drop ref="hidden_common_lockbox"/>`, and so do the asteroid macros that drop crystals and ore. A ship macro does not; ships take theirs from the table or a script.
3. **A script.** `create_ship` accepts a `<drop ref="..."/>` child, and `set_drop_object` sets or clears the droplist of an object that already exists. `libraries/objectspawnrules.xml` is a fourth way for lockboxes: it says which hidden lockbox list a station or a region spawns.

When the object is destroyed or opened, each `<drop>` of its list is rolled once, and the containers that come up are spawned around it with their contents.

[↑ Contents](#toc)

## The file

### Layout

```xml
<droplists>
  <ammo id="basket_missiles_small_01" selection="random">
    <select weight="20" macro="missile_gen_s_dumbfire_01_mk1_macro" min="3" max="6"/>
    ...
  </ammo>
  <wares id="basket_wares_common_01" selection="random">
    <select weight="7">
      <ware ware="inv_algaescrubber" min="1" max="3"/>
    </select>
    ...
  </wares>
  <droplist id="ship_small_military">
    <drop macro="sm_gen_wares_common_01_macro" min="1" max="2" chance="100">
      <collectable>
        <wares ref="basket_wares_common_01"/>
      </collectable>
    </drop>
    ...
  </droplist>
  ...
</droplists>
```

- `<ammo>`, `<wares>` and `<data>` entries at the top are the baskets. Each has an `id` and, with `selection="random"`, a list of weighted `<select>` entries; without it, every entry is given.
- Each `<droplist>` is one list of drops.

The base file holds the baskets and the lists for ships, mass traffic, asteroids, lockboxes, exploration and a few story objects. Three expansions ship a `libraries/drops.xml` of their own, each a whole file that is gathered with the base one and holds only the lists of their own stories and scenarios; none of them touches a base list.

The schema, `libraries/drops.xsd`, documents every element and attribute.

[↑ Contents](#toc)

### A droplist, part by part

The list the small military ships drop, shortened:

```xml
<droplist id="ship_small_military">
  <!--Common Trade Wares-->
  <drop macro="sm_gen_wares_common_01_macro" min="1" max="2" chance="100">
    <collectable>
      <wares ref="basket_wares_common_01"/>
    </collectable>
  </drop>
  <!--Rare Mod Parts T1-->
  <drop macro="sm_gen_wpsmod_rare_01_macro" min="1" max="1" chance="10">
    <collectable>
      <wares ref="basket_wpsmod_rare_01"/>
    </collectable>
  </drop>
  <!--Small Missiles-->
  <drop macro="sm_gen_ammo_01_macro" min="1" max="2" chance="50">
    <collectable>
      <ammo ref="basket_missiles_small_01"/>
    </collectable>
  </drop>
</droplist>
```

Each `<drop>` is rolled on its own: with `chance` percent it spawns between `min` and `max` containers of the named `macro`, and each container holds what `<collectable>` says. Here a destroyed fighter always leaves one or two crates of common wares, has one chance in ten of a crate of rare mod parts, and one in two of a crate of missiles.

| Attribute of `<drop>` | Meaning |
| --- | --- |
| `macro` | The container macro to spawn. Required, except for collectable wares, where the ware's own container macro from `wares.xml` is used when none is given |
| `chance` | The percentage chance that this drop spawns at all; default 100 |
| `min`, `max` | How many containers; `min` defaults to 1 |
| `owner` | The faction that owns the spawned containers |

The droplist itself has an `id` and may carry a `name`, a `description` and a `rarity`; vanilla sets `rarity` on the unusual and rare lockbox lists.

[↑ Contents](#toc)

### What a container holds

`<collectable>` holds exactly one kind of content:

| Content | Meaning |
| --- | --- |
| `<wares>` | Wares, as a `ref` to a wares basket or as inline `<ware ware="..." amount="..."/>` or `min`/`max` lines, with an optional `<money>` beside them |
| `<money chance="..." min="..." max="..."/>` | Credits alone |
| `<ammo>` | Missiles or other ammunition, as a `ref` to an ammo basket or inline `macro` with `min`, `max` or `exact` |
| `<data>` | A data entry: a `timeline` entry id or an `audiolog` id, or a `ref` to a data basket |
| `<shieldrestore>` | A shield restore |

A `ref` wins over everything else on the same element: an element with `ref` ignores its other attributes and children.

[↑ Contents](#toc)

### Baskets and selection

A basket is the content written once. The ammo basket for small missiles:

```xml
<ammo id="basket_missiles_small_01" selection="random">
  <select weight="20" macro="missile_gen_s_dumbfire_01_mk1_macro" min="3" max="6"/>
  <select weight="10" macro="missile_gen_s_dumbfire_01_mk2_macro" min="2" max="4"/>
  <select weight="15" macro="missile_gen_s_emp_01_mk1_macro" min="2" max="4"/>
  ...
</ammo>
```

With `selection="random"` one `<select>` entry is picked, with a chance in proportion to its `weight`, and a container holds that one. A wares basket is the same with `<ware>` lines inside each `<select>`, and a `<select>` may hold several wares that come together. Without `selection`, every entry of the basket is given.

The same `selection` and `<select>` form works inline, on the `<wares>`, `<ammo>` or `<data>` of a drop, for a one-off list that nothing else shares. Vanilla keeps the shared ones as baskets: common and rare trade wares, mod parts by tier, missiles by size, luxury wares, the Kha'ak alloy, and the wares of a few story characters.

[↑ Contents](#toc)

### The vanilla lists

| Family | Lists |
| --- | --- |
| Ships | `ship_small_military`, `ship_small_pirate`, `ship_small_civilian`, `ship_small_xenon`, `ship_small_khaak`, `ship_medium_civilian`, `ship_medium_xenon`, `ship_medium_luxury`, `ship_large_civilian`, `ship_large_military`, `ship_large_xenon`, `ship_large_xenon_tf`, `ship_large_khaak` |
| Mass traffic | `masstraffic_civilian`, `masstraffic_xenon` |
| Asteroids | `asteroid_ore_m`, `asteroid_ice_l`, `asteroid_nividium_s` and the rest of the ware and size pairs, the hot asteroids, plus the crystal lists the small crystal formations use |
| Lockboxes | `hidden_common_lockbox`, `hidden_unusual_lockbox`, `hidden_rare_lockbox`, `hidden_luxury_lockbox`, `hidden_mines_lockbox`, and two trap lists |
| Exploration and story | `exploration_drops`, the tutorial and flight school lists, and the story items |

The ship lists are what the entries of `ships.xml` refer to, so a new ship entry picks one of these or brings its own.

[↑ Contents](#toc)

## The script side

| Expression or element | What it gives |
| --- | --- |
| `<object>.drop` | The id of the object's droplist, or null |
| `set_drop_object` | Sets an object's droplist by id, or clears it when `drop` is omitted |
| `spawn_drop` | Spawns an object's drops now, from its own list or from the `drop` given |
| `<drop ref="..."/>` under `create_ship` | The droplist of a ship created by a script |
| `create_lockbox` | Creates a lockbox object from a lockbox macro; its contents are the macro's droplist |
| `set_allow_drop`, `set_drop_persistence` | Whether an object, or any destructible part of it, may drop at all; and whether a dropped object stays instead of despawning after the default time |
| `event_object_dropped_objects`, `event_player_owned_dropped_objects` | An object dropped something; its `param` is the list of what was dropped |
| `event_object_drops_found`, `event_lockbox_opened`, `event_player_opened_lockbox` | Drops were found, a lockbox was opened |
| `drop_cargo`, `drop_inventory`, `drop_illegal_cargo`, `drop_illegal_inventory` | Make a ship or a person drop what it carries, which is a different thing from a droplist |

Vanilla's own use is small: the generic missions create lockboxes from the lockbox macros, and one library cue sets a droplist on a ship it has just created when the caller asks for one.

[↑ Contents](#toc)

## Adding a droplist from an extension

A droplist that nothing refers to is never used, so adding one is two steps: the list, and the reference from the ship table, a macro or a script. The example below, for a fictional extension `example_drops`, defines a list for a smuggler's ship that drops spacefuel and a little money, and gives it to the small pirate ships through the ship table.

`libraries/drops.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/droplists">
    <wares id="example_basket_contraband" selection="random">
      <select weight="10">
        <ware ware="spacefuel" min="2" max="6"/>
      </select>
      <select weight="5">
        <ware ware="spaceweed" min="1" max="3"/>
      </select>
    </wares>
    <droplist id="example_ship_small_smuggler">
      <drop macro="sm_gen_wares_common_01_macro" min="1" max="2" chance="100">
        <collectable>
          <wares ref="basket_wares_common_01"/>
        </collectable>
      </drop>
      <drop macro="sm_gen_wares_rare_01_macro" min="1" max="1" chance="80">
        <collectable>
          <wares ref="example_basket_contraband"/>
        </collectable>
      </drop>
      <drop macro="sm_gen_wares_common_02_macro" min="1" max="1" chance="30">
        <collectable>
          <money min="2000" max="8000"/>
        </collectable>
      </drop>
    </droplist>
  </add>
</diff>
```

`libraries/ships.xml`, pointing the Hatikvah mixed small ships at it:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <replace sel="/ships/ship[@id='hat_mixed_sm']/drop/@ref">example_ship_small_smuggler</replace>
</diff>
```

Some points about the example:

- **A basket of the extension's own** sits beside the vanilla ones and is referred to the same way; the vanilla common basket is reused for the first drop.
- **The container macros are vanilla's**, the small storage module macros the vanilla lists use. A container of the extension's own is an asset.
- **The ship table replace** names one entry by its `id`; every entry that should drop the new list needs a line of its own.
- **The table is read when a ship is created**, so the change shows on ships created afterwards; a ship that already exists is changed with `set_drop_object` from a script.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)

## Reading on

[jobs.xml](/x4/modding-support/anatomy-of-game-data/libraries/jobs-xml/) and [god.xml](/x4/modding-support/anatomy-of-game-data/libraries/god-xml/) create the ships that carry these lists, through the ship table.

[↑ Contents](#toc)
