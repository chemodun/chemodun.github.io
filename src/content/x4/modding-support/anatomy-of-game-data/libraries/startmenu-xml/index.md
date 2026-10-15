---
title: startmenu.xml
description: How libraries/startmenu.xml lists the background scenes of the X4 start menu - the default scene, each scene's cutscene, music, map, background cluster, regions and unlock - how the expansions change it, how the player picks a scene, and how an extension adds one.
---

# startmenu.xml

`libraries/startmenu.xml` lists the scenes the start menu can show behind it. Each scene entry names the cutscene that builds the scene, the music played with it, the galaxy it is built in, the cluster whose sky it shows, and the regions placed around it. One scene is the default, the expansions add their own, and the player picks one in the settings.

This article covers the file: its format, how the expansions change it, how a scene is chosen, and how an extension adds one. It describes version 9.00. How a scene itself is made, the cutscene, the scene object with its camera, ships and stations, and the regions, is covered below this article in [Start menu background](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/background/).

<a id="toc"></a>

## Contents

<!-- xwiki: toc start="2" depth="3" -->

## Terms

- **Scene entry**: one `<scene>` in `startmenu.xml`. It names the cutscene the scene plays, the background cluster whose sky it shows, the music played with it, and the regions placed around it.
- **Default scene**: the scene shown when the player has not chosen one.
- **Background cluster**: the cluster content that gives a scene its sky: the skybox, planets, nebulae and the sun's light.
- **Scene object**: the object the cutscene places in the scene, holding the camera, the lights, and the ships and stations that move in it.

[↑ Contents](#toc)

## How a scene entry is used

```text
libraries/startmenu.xml
  <scene cutscene="startmenu_background" music="..." map="blackgalaxy_macro">
    <cluster name="cluster_black_macro" background="cluster_sm3_background_macro"/>   -> the sky
    <regions> <region name="sm_bs_region_macro"> ... </regions>                       -> asteroids, fog
        |
        v
cutscenes/startmenu_background.xml
  <director key="startmenu_background"/>
  <anchor name="startmenu_final_macro"/>                                              -> the scene object
  <teleport zone="tzonecluster_black_sector01_zone_macro"/>
        |
        v
assets/cutscenecore/macros/startmenu_final_macro.xml     the scene object's macro: what fills each connection
assets/cutscenecore/startmenu_final.xml                  its component: camera, lights, dummies, animations
```

The game builds the galaxy the entry names, with the background cluster's sky and the regions at their positions, plays the cutscene, which places the scene object in the galaxy's zone, and plays the music. [Start menu background](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/background/) covers the cutscene, the scene object, the background cluster and the regions.

[↑ Contents](#toc)

## The file

### Layout

The base file:

```xml
<startmenu>
  <background default="startmenu_background">
    <scene cutscene="startmenu_background" music="music_menu_main_music" map="blackgalaxy_macro">
      <cluster name="cluster_black_macro" background="cluster_sm3_background_macro" />
    </scene>
    <scene cutscene="startmenu_basegame_background" music="music_menu_main_bg_music" map="blackgalaxy_macro">
      <cluster name="cluster_black_macro" background="cluster_sm_basegame_background_macro" />
    </scene>
  </background>
</startmenu>
```

`<background>` holds the scene entries; its `default` names the default scene by its cutscene. There is no schema for this file.

### A scene entry

A Kingdom End scene, with every element vanilla uses:

```xml
<scene cutscene="startmenu_b2_background" music="music_menu_main_bor_music" map="blackgalaxy_macro">
  <unlock>
    <userdata ref="x4ke_sod_discovered" value="1" />
  </unlock>
  <cluster name="cluster_black_macro" background="cluster_sm605_background_macro" />
  <regions>
    <region name="sm_sod_region_macro">
      <position x="0" y="-50000" z="0"/>
    </region>
    <region name="sm_sod_region2_macro">
      <position x="0" y="-20000" z="0"/>
    </region>
  </regions>
  <paintmod default="paintmod_0191" />
</scene>
```

| Attribute or element | Meaning |
|---|---|
| `cutscene` | The cutscene that builds the scene, by its `<director key>`. It is also the scene's id. |
| `music` | The music played with the scene: the id of a `<sound>` in `libraries/sound_library.xml`, such as `music_menu_main_music`. Kingdom End defines its `music_menu_main_bor_music` with a diff on that file, and an extension's own start menu music needs a `<sound>` entry added the same way. |
| `map` | The galaxy the scene is built in; every vanilla scene uses the black galaxy, `blackgalaxy_macro`. |
| `<cluster name background>` | `name` is the cluster of that galaxy, `cluster_black_macro` in every vanilla scene; `background` is a macro of class `celestialbody` whose sky the scene shows. |
| `<regions>` | Regions placed in the cluster, each `<region name>` naming a region macro, with a `<position>`; [Start menu background](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/background/#regions) explains how the position depends on the region's shape. |
| `<unlock>` | `<userdata ref value>` entries that have to be met for the scene to be offered. |
| `<paintmod default>` | Set by the Boron and Timelines scenes. |

The vanilla `background` macros, the vanilla regions and how a region macro is made are listed in [Start menu background](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/background/#the-map-and-the-background).

### Unlocks

The two locked Kingdom End scenes wait for values a script sets when the player first enters the sector each scene shows:

```xml
<set_value name="userdata.x4ke_sod_discovered" exact="1" />
```

A `userdata` value is kept in the player's profile, not in a save, so it stays set for every later game. Game starts use the same kind of value for their own unlocks, described in [gamestarts.xml](/x4/modding-support/anatomy-of-game-data/libraries/gamestarts-xml/#locked-and-hidden-starts).

### The random entry

Kingdom End also adds an entry that is not a scene:

```xml
<random cutscene="random">
  <unlock>
    <userdata ref="unlock_x4ke_ch6_complete" value="1" />
    <userdata ref="unlock_x4ke_ch8_complete" value="1" />
  </unlock>
</random>
```

Its two values are set by the Kingdom End story.

[↑ Contents](#toc)

## How the expansions change it

Each expansion's `libraries/startmenu.xml` is a diff that does two things: it adds a scene entry of its own, and it replaces the default entry `startmenu_background` with a copy using its own background cluster and regions:

```xml
<diff>
  <replace sel="/startmenu/background/scene[@cutscene='startmenu_background']">
    <scene cutscene="startmenu_background" music="music_menu_main_music" map="blackgalaxy_macro">
      <cluster name="cluster_black_macro" background="cluster_sm_split_macro" />
    </scene>
  </replace>
  <add sel="/startmenu/background">
    <scene cutscene="startmenu_split_background" music="music_menu_main_split_music" map="blackgalaxy_macro">
      <cluster name="cluster_black_macro" background="cluster_sm_split_macro" />
    </scene>
  </add>
</diff>
```

Each also diffs the default cutscene, `cutscenes/startmenu_background.xml`, to point it at its own scene object. Each of those diffs selects the anchor by every name the earlier expansions set, so the default scene shows the most recent expansion's scene:

```xml
<diff>
  <replace sel="/cutscene/environments/environment_plot/anchor[@name='startmenu_final_macro' or @name='startmenu_split_final_macro']/@name">startmenu_terran_final_macro</replace>
</diff>
```

The base game's own scene stays available as the `startmenu_basegame_background` entry, which no expansion changes.

| Expansion | Scene entries it adds |
|---|---|
| Split Vendetta | `startmenu_split_background` |
| Cradle of Humanity | `startmenu_ter_background` |
| Tides of Avarice | `startmenu_pir_background` |
| Kingdom End | `startmenu_b1_background`, and `startmenu_b2_background` and `startmenu_b3_background` with unlocks, and the random entry |
| Timelines | `startmenu_t1_background` |

[↑ Contents](#toc)

## Choosing a scene

Settings, Game, "Start Menu Background Scene" is shown only in the start menu. It lists:

- "Default", the scene `default` names;
- "Random";
- every other scene, labelled with the name of the extension whose `startmenu.xml` added it, and numbered when one extension adds several.

Changing the choice reloads the start menu, so the new scene is built at once.

[↑ Contents](#toc)

## Adding a scene from an extension

A new scene entry is an `add` on `/startmenu/background`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<diff>
  <add sel="/startmenu/background">
    <scene cutscene="example_startmenu_background" music="music_menu_main_music" map="blackgalaxy_macro">
      <cluster name="cluster_black_macro" background="cluster_sm2_background_macro" />
      <regions>
        <region name="example_sm_asteroids_macro">
          <position x="0" y="-2500" z="0" />
        </region>
      </regions>
    </scene>
  </add>
</diff>
```

The entry needs a cutscene with the key it names, and every region macro it names needs to exist. [Start menu background](/x4/modding-support/anatomy-of-game-data/libraries/startmenu-xml/background/#adding-a-background-from-an-extension) has this entry with all its files as one complete example.

- **The scene is listed under the extension's name** in the settings. It does not replace the default scene.
- **Replacing the default scene** is a `replace` of the `startmenu_background` entry, as the expansions do. The expansions replace the same entry, so the result depends on which diff applies last.
- **The cutscene key has to be new.** It is the scene's id in the settings list.

The extension itself, its folder, `content.xml` and diff files, is covered in [Anatomy of an extension](/x4/modding-support/anatomy-of-an-extension/) and [XML diff patching](/x4/modding-support/anatomy-of-an-extension/xml-diff-patching/).

[↑ Contents](#toc)
